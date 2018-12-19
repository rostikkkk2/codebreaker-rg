RSpec.describe Console do
  let(:game) { Game.new }
  let(:db) { Storage.new }
  let(:hint) { 'Hint' }
  let(:test_guess) { '1234' }
  let(:lose) { '----' }
  let(:win) { '++++' }
  let(:yes) { 'Yes' }
  let(:no) { 'No' }
  let(:name) { 'Rostik' }
  let(:easy) { 'Easy' }
  let(:test_user) do
    { name: 'Test',
      difficulty: 'Easy',
      attempts_total: 15,
      attempts_used: 2,
      hints_total: 2,
      hints_used: 0 }
  end

  describe '#check_option' do
    it 'calling method registration' do
      allow(subject).to receive(:show_info).with(:welcome_and_option)
      allow(subject).to receive(:show_message_and_input).and_return(Console::OPTIONS[:start])
      expect(subject).to receive(:registration)
      subject.check_option
    end

    it 'calling method rules' do
      allow(subject).to receive(:show_info).with(:welcome_and_option)
      allow(subject).to receive(:show_message_and_input).and_return(Console::OPTIONS[:rules], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_rules)
      subject.check_option
    end

    it 'calling method show_stats' do
      allow(subject).to receive(:show_info).with(:welcome_and_option)
      allow(subject).to receive(:show_message_and_input).and_return(Console::OPTIONS[:stats], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_stats)
      subject.check_option
    end

    it 'when invalid' do
      allow(subject).to receive(:show_info).with(:welcome_and_option)
      allow(subject).to receive(:show_message_and_input).and_return('', Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_info).with(:wrong_input_option)
      subject.check_option
    end

    it 'enter name and difficulty' do
      allow(subject).to receive(:show_info).with(:welcome_and_option)
      allow(subject).to receive(:show_message_and_input).and_return(Console::OPTIONS[:start])
      expect(subject).to receive(:show_message_and_input).with(:write_name).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:show_message_and_input).with(:write_name).and_return(name)
      expect(subject).to receive(:show_message_and_input).with(:message_choose_difficulty).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:show_message_and_input).with(:message_choose_difficulty).and_return(easy)
      expect(subject).to receive(:play_game)
      subject.check_option
    end
  end

  describe '#show_rules' do
    it 'return rules' do
      expect(subject).to receive(:show_info)
      subject.show_rules
    end
  end

  describe '#play_game' do
    after { subject.play_game }

    it 'show hint' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_and_input).with(:message_guess_code).and_return(hint)
      expect(subject).to receive(:check_hint).once
    end

    it 'check guess' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_and_input).with(:message_guess_code).and_return(test_guess)
      allow(game).to receive(:valid_guess_code?).and_return(true)
      expect(subject).to receive(:game_proccess).once
    end

    it 'wrong command' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_and_input).with(:message_guess_code).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command).once
    end
  end

  describe '#game_proccess' do
    after { subject.game_proccess(test_guess) }

    it 'return play_game' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return(lose)
      expect(subject).to receive(:check_win).with(lose).and_return(false)
      expect(subject).to receive(:play_game)
    end

    it 'return check_win' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return(win)
      expect(subject).to receive(:check_win).with(win).and_return(true)
      expect(subject).not_to receive(:play_game)
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
      expect(subject).to receive(:puts).and_return(Game.new.give_digit_hint)
      subject.show_hint
    end
  end

  describe '#check_lose' do
    it 'show loose' do
      subject.instance_variable_set(:@user, attempts_used: 1, attempts_total: 2)
      expect(subject).to receive(:show_info)
      expect(subject).to receive(:restart)
      subject.check_lose
    end
  end

  describe '#check_win' do
    it 'return win' do
      expect(subject).to receive(:win)
      subject.check_win(win)
    end

    it 'return check_lose' do
      expect(subject).to receive(:check_lose)
      subject.check_win(lose)
    end
  end

  describe '#win' do
    it 'return restart' do
      allow(subject).to receive(:show_info)
      allow(subject).to receive(:save)
      expect(subject).to receive(:restart)
      subject.win
    end
  end

  describe '#show_db_info' do
    it 'show message and input' do
      subject.show_db_info(test_user)
    end
  end

  describe '#save' do
    it 'save to db' do
      allow(subject).to receive(:show_message_and_input).and_return(yes)
      allow_any_instance_of(Storage).to receive(:add_data_to_db)
      subject.save
    end

    it 'do not save' do
      allow_any_instance_of(described_class).to receive(:show_message_and_input).and_return(no)
      expect_any_instance_of(Storage).not_to receive(:add_data_to_db)
      subject.save
    end
  end

  describe '#show_stats' do
    it 'stats clear' do
      allow_any_instance_of(Storage).to receive(:load).and_return(false)
      expect(subject).to receive(:show_info)
      subject.show_stats
    end

    it 'show stats' do
      allow_any_instance_of(Storage).to receive(:file_exist?).and_return(true)
      allow_any_instance_of(Storage).to receive(:load).and_return(true)
      expect(subject).to receive(:sort_db_info)
      expect(subject).to receive(:show_db_info)
      subject.show_stats
    end
  end

  describe '#show_message_and_input' do
    it 'show message and input' do
      allow(subject).to receive(:show_info)
      allow(subject).to receive(:gets).and_return('')
      expect(subject).to receive(:bye).and_return('')
      subject.show_message_and_input('')
    end
  end
end
