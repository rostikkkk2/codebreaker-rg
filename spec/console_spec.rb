RSpec.describe Console do
  let(:console) { described_class.new }
  let(:game) { Game.new }
  let(:db) { Db.new }
  let(:hint) { 'Hint' }
  let(:test_guess) { '1234' }
  let(:lose) { '----' }
  let(:win) { '++++' }
  let(:yes) { 'Yes' }
  let(:no) { 'No' }
  let(:name) { 'Rostik' }
  let(:easy) { 'Easy' }
  let(:test_user) { { name: 'Test', difficulty: 'Easy', attempts_total: 15, attempts_used: 2, hints_total: 2, hints_used: 0 } }

  context 'navigation' do
    after { console.check_option }

    describe '#check_option' do
      before { allow(console).to receive(:registration) }

      it 'calling method registration' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:start])
        expect(console).to receive(:registration)
      end

      it 'calling method rules' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:rules], Console::OPTIONS[:start])
        expect(console).to receive(:show_rules)
      end

      it 'calling method show_stats' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:stats], Console::OPTIONS[:start])
        expect(console).to receive(:show_stats)
      end

      it 'exit from game' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:exit])
        allow(console).to receive(:show_info).with(:welcome_and_option)
        expect(console).to receive(:show_info).with(:goodbye)
      end

      it 'when invalid' do
        allow(console).to receive(:gets).and_return('', Console::OPTIONS[:start])
        allow(console).to receive(:show_info).with(:welcome_and_option)
        expect(console).to receive(:show_info).with(:wrong_input_option)
      end
    end

    it 'give error after enter name and difficulty' do
      allow(console).to receive(:gets).and_return(Console::OPTIONS[:start], '', name, '', easy)
      expect(console).to receive(:show_info).with(:welcome_and_option)
      expect(console).to receive(:show_info).with(:write_name).twice
      expect(console).to receive(:show_info).with(:unexpected_command).twice
      expect(console).to receive(:show_info).with(:message_choose_difficulty).twice
      expect(console).to receive(:play_game)
    end
  end

  describe '#show_rules' do
    after { console.show_rules }

    it 'return rules' do
      expect_any_instance_of(described_class).to receive(:show_info)
    end
  end

  describe '#play_game' do
    after { console.play_game }

    it 'show hint' do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
      allow_any_instance_of(described_class).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return(hint)
      expect_any_instance_of(described_class).to receive(:check_hint).once
    end

    it 'check guess' do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
      allow_any_instance_of(described_class).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return(test_guess)
      allow_any_instance_of(Game).to receive(:valid_guess_code?).and_return(true)
      expect_any_instance_of(described_class).to receive(:game_proccess).once
    end

    it 'wrong command' do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
      allow_any_instance_of(described_class).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return('')
      expect_any_instance_of(described_class).to receive(:show_info).with(:unexpected_command).once
    end
  end

  describe '#game_proccess' do
    after { console.game_proccess(test_guess) }

    it 'return play_game' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return(lose)
      expect_any_instance_of(described_class).to receive(:show_info_without_i18).with(lose)
      expect_any_instance_of(described_class).to receive(:check_win).with(lose).and_return(false)
      expect_any_instance_of(described_class).to receive(:play_game)
    end

    it 'return check_win' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return(win)
      expect_any_instance_of(described_class).to receive(:show_info_without_i18).with(win)
      expect_any_instance_of(described_class).to receive(:check_win).with(win).and_return(true)
      expect_any_instance_of(described_class).not_to receive(:play_game)
    end
  end

  describe '#check_hint' do
    it 'show hint' do
      subject.instance_variable_set(:@user, hints_used: 0, hints_total: 2)
      expect(subject).to receive(:show_hint)
      subject.check_hint
    end

    it 'do not show hint' do
      subject.instance_variable_set(:@user, hints_used: 2, hints_total: 2)
      expect(subject).to receive(:show_info)
      subject.check_hint
    end
  end

  describe '#show_hint' do
    it 'show hint' do
      subject.instance_variable_set(:@user, hints_used: 1)
      expect(subject).to receive(:show_info_without_i18)
      subject.show_hint
    end
  end

  describe '#check_lose' do
    it 'show loose' do
      subject.instance_variable_set(:@user, attempts_used: 1, attempts_total: 2)
      expect(subject).to receive(:show_info_without_i18)
      expect(subject).to receive(:restart)
      subject.check_lose
    end
  end

  describe '#check_win' do
    it 'return win' do
      expect_any_instance_of(described_class).to receive(:win)
      described_class.new.check_win(win)
    end

    it 'return check_lose' do
      expect_any_instance_of(described_class).to receive(:check_lose)
      described_class.new.check_win(lose)
    end
  end

  describe '#win' do
    after { console.win }

    it 'return restart' do
      expect_any_instance_of(described_class).to receive(:show_info_without_i18).and_call_original
      expect_any_instance_of(described_class).to receive(:save)
      expect_any_instance_of(described_class).to receive(:restart)
    end
  end

  describe '#save' do
    it 'save to db' do
      allow_any_instance_of(described_class).to receive(:dafault_show_message_and_ask).and_return(yes)
      allow_any_instance_of(Db).to receive(:add_data_to_db)
      subject.save
    end

    it 'do not save' do
      allow_any_instance_of(described_class).to receive(:dafault_show_message_and_ask).and_return(no)
      expect_any_instance_of(Db).not_to receive(:add_data_to_db)
      subject.save
    end
  end

  describe '#show_stats' do
    it 'stats clear' do
      allow_any_instance_of(Db).to receive(:load).and_return(false)
      expect_any_instance_of(described_class).to receive(:show_info)
      subject.show_stats
    end

    it 'show stats' do
      allow_any_instance_of(Db).to receive(:file_exist?).and_return(true)
      allow_any_instance_of(Db).to receive(:load).and_return(true)
      expect_any_instance_of(described_class).to receive(:sort_db_info)
      expect_any_instance_of(described_class).to receive(:show_db_info)
      subject.show_stats
    end
  end
end
