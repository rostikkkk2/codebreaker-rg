require 'rspec'
require './autoload'

RSpec.describe Console do
  let(:console) { Console.new }
  let(:game) { Game.new }
  # let(:test_user) do {name: 'Rostik',  difficulty: 'Easy', attempts_total: 15, attempts_used: 2, hints_total: 2, hints_used: 0} end

  describe '.new' do
    it { expect(console.instance_variable_get(:@info_difficult)).to eq(nil) }
  end

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
      allow(console).to receive(:gets).and_return('start', '', 'Rositk', '', 'Easy')
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
      expect_any_instance_of(Console).to receive(:show_info)
    end
  end

  describe '#show_stats' do
    it 'return stats' do
      console.show_stats
    end
  end

  describe '#play_game' do
    after { console.play_game }

    it 'show hint' do
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return('Hint')
      expect_any_instance_of(Console).to receive(:check_hint).once
    end

    it 'check guess' do
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return('1234')
      allow_any_instance_of(Game).to receive(:valid_guess_code?).and_return(true)
      expect_any_instance_of(Console).to receive(:game_proccess).once
    end

    it 'wrong command' do
      allow_any_instance_of(Console).to receive(:loop).and_yield
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).with(:message_guess_code).and_return('')
      expect_any_instance_of(Console).to receive(:show_info).with(:unexpected_command).once
    end
  end

  describe '#game_proccess' do
    after { console.game_proccess('1234') }

    it 'return play_game' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return('----')
      expect_any_instance_of(Console).to receive(:show_info_without_i18).with('----')
      expect_any_instance_of(Console).to receive(:check_win).with('----').and_return(false)
      expect_any_instance_of(Console).to receive(:play_game)
    end

    it 'return check_win' do
      allow_any_instance_of(Game).to receive(:compare_guess_and_secret_codes).and_return('++++')
      expect_any_instance_of(Console).to receive(:show_info_without_i18).with('++++')
      expect_any_instance_of(Console).to receive(:check_win).with('++++').and_return(true)
      expect_any_instance_of(Console).not_to receive(:play_game)
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
      expect_any_instance_of(Console).to receive(:win)
      Console.new.check_win('++++')
    end

    it 'return check_lose' do
      expect_any_instance_of(Console).to receive(:check_lose)
      Console.new.check_win('----')
    end
  end

  describe '#win' do
    after { console.win }

    it 'return restart' do
      expect_any_instance_of(Console).to receive(:show_info_without_i18).and_call_original
      expect_any_instance_of(Console).to receive(:save)
      expect_any_instance_of(Console).to receive(:restart)
    end
  end

  describe '#save' do
    after { console.save }

    it 'save to db' do
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).and_return('Yes')
      expect_any_instance_of(Db).to receive(:add_data_to_db).and_call_original
    end

    it 'do not save' do
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).and_return('No')
      expect_any_instance_of(Db).not_to receive(:add_data_to_db)
    end
  end

  describe '#restart' do
    after { console.restart }

    it 'go to restart' do
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).and_return('Yes')
      expect_any_instance_of(Console).to receive(:check_option)
    end

    it 'do no to restart' do
      allow_any_instance_of(Console).to receive(:dafault_show_message_and_ask).and_return('No')
      expect_any_instance_of(Console).not_to receive(:check_option)
    end
  end

end
