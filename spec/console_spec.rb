RSpec.describe Console do
  let(:game) { Game.new }
  let(:hint) { 'Hint' }
  let(:test_guess) { '1234' }
  let(:lose) { '----' }
  let(:win) { '++++' }
  let(:agree_command) { 'Yes' }
  let(:disagree_command) { 'No' }
  let(:name) { 'Rostik' }
  let(:name_difficulties) { { difficulties: 'easy, medium, hell' } }
  let(:easy) { 'Easy' }
  let(:medium) { 'Medium' }
  let(:hell) { 'Hell' }

  describe '#check_option' do
    it 'calling method registration' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:start])
      expect(subject).to receive(:registration)
      subject.check_option
    end

    it 'calling method rules' do
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:rules], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_rules)
      subject.check_option
    end

    it 'calling method show_stats' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:stats], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_stats)
      subject.check_option
    end

    it 'when invalid' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).and_return('', Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_info).with(:wrong_input_option)
      subject.check_option
    end

    it 'enter name and difficulty' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).with(:choose_option).and_return(Console::OPTIONS[:start])
      expect(subject).to receive(:show_message_with_input).with(:write_name).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, name_difficulties).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, name_difficulties).and_return(easy)
      expect(subject).to receive(:play_game)
      subject.check_option
    end

    it 'enter difficulty medium' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:start])
      allow(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, name_difficulties).and_return(medium)
      expect(subject).to receive(:play_game)
      subject.check_option
    end

    it 'enter difficulty hell' do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:start])
      allow(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, name_difficulties).and_return(hell)
      expect(subject).to receive(:play_game)
      subject.check_option
    end
  end

  describe '#show_rules' do
    it 'return rules' do
      expect(subject).to receive(:show_info)
      subject.send(:show_rules)
    end
  end

  describe '#play_game' do
    after { subject.send(:play_game) }

    it 'show hint' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(hint)
      expect(subject).to receive(:check_hint).once
    end

    it 'check guess' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(test_guess)
      allow(game).to receive(:valid_guess_code?).and_return(true)
      expect(subject).to receive(:game_proccess).once
    end

    it 'wrong command' do
      allow(subject).to receive(:loop).and_yield
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command).once
    end
  end

  describe '#game_proccess' do
    after { subject.send(:game_proccess, test_guess) }
    it 'return check_win' do
      subject.instance_variable_set(:@game, game)
      allow(game).to receive(:compare_guess_and_secret_codes).with('1234')
      expect(subject).to receive(:check_win)
    end
  end

  describe '#check_hint' do
    it 'show hint' do
      subject.instance_variable_set(:@user, hints_left: 0, hints_total: 2)
      expect(subject).to receive(:show_hint)
      subject.send(:check_hint)
    end

    it 'do not show hint' do
      subject.instance_variable_set(:@user, hints_left: 2, hints_total: 2)
      expect(subject).to receive(:show_info)
      subject.send(:check_hint)
    end
  end

  describe '#show_hint' do
    it 'show hint' do
      subject.instance_variable_set(:@game, game)
      subject.instance_variable_set(:@user, hints_used: 1)
      allow(game).to receive(:hints_left_increase)
      expect(game).to receive(:give_digit_hint)
      subject.send(:show_hint)
    end
  end

  describe '#check_lose' do
    it 'show loose' do
      subject.instance_variable_set(:@user, attempts_left: 1, attempts_total: 2)
      expect(subject).to receive(:show_info)
      expect(subject).to receive(:ask_restart)
      subject.send(:check_lose)
    end
  end

  describe '#check_win' do
    let(:some_secret_code) { [1, 1, 1, 1] }
    let(:some_secret_code_string) { '1111' }
    before do
      subject.instance_variable_set(:@game, game)
      game.instance_variable_set(:@secret_code, some_secret_code)
      game.instance_variable_set(:@secret_code_for_hints, some_secret_code)
    end
    it 'return win' do
      expect(subject).to receive(:win)
      subject.send(:check_win, some_secret_code_string)
    end

    it 'return check_lose' do
      expect(subject).to receive(:check_lose)
      subject.send(:check_win, lose)
    end
  end

  describe '#win' do
    it 'return restart' do
      allow(subject).to receive(:show_info)
      allow(subject).to receive(:ask_for_save)
      expect(subject).to receive(:ask_restart)
      subject.send(:win)
    end
  end

  describe '#ask_for_save' do
    it 'save to db' do
      allow(subject).to receive(:show_message_with_input).and_return(agree_command)
      expect_any_instance_of(Storage).to receive(:add_data_to_db)
      subject.send(:ask_for_save)
    end

    it 'do not save' do
      allow_any_instance_of(described_class).to receive(:show_message_with_input).and_return(disagree_command)
      expect_any_instance_of(Storage).not_to receive(:add_data_to_db)
      subject.send(:ask_for_save)
    end
  end

  describe '#show_stats' do
    it 'stats clear' do
      allow_any_instance_of(Storage).to receive(:load_data_if_file_exists?).and_return(false)
      expect(subject).to receive(:show_info)
      subject.send(:show_stats)
    end

    it 'show stats' do
      allow_any_instance_of(Storage).to receive(:load_data_if_file_exists?).and_return(true)
      expect(subject).to receive(:show_db_info)
      subject.send(:show_stats)
    end
  end

  describe '#show_message_with_input' do
    it 'show message and input' do
      allow(subject).to receive(:show_info).with('', nil)
      allow(subject).to receive(:gets).and_return('')
      subject.send(:show_message_with_input, '')
    end
  end
end
