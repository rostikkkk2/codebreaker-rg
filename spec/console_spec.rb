RSpec.describe Console do
  let(:game) { Game.new }
  let(:storage) { Storage.new }
  let(:hint) { 'Hint' }
  let(:test_guess) { '1234' }
  let(:agree_command) { 'Yes' }
  let(:disagree_command) { 'No' }
  let(:name) { 'Rostik' }
  NAME_DIFFICULTIES_FOR_PUTS = { difficulties: 'easy, medium, hell' }.freeze
  GAME_RESULTS = {
    win: '++++',
    lose: '----'
  }.freeze
  DIFFICULTIES_INPUT = {
    easy: 'Easy',
    medium: 'Medium',
    hell: 'Hell'
  }.freeze

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
  end

  describe 'input name and difficulties' do
    let(:easy) { 'Easy' }
    let(:medium) { 'Medium' }
    let(:hell) { 'Hell' }

    before do
      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).with(:choose_option).and_return(Console::OPTIONS[:start])
    end

    it 'when invalid name' do
      expect(subject).to receive(:show_message_with_input).with(:write_name).and_return('', name)
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, NAME_DIFFICULTIES_FOR_PUTS).and_return(easy)
      expect(subject).to receive(:play_game)
      subject.check_option
    end

    it 'when invalid difficulty' do
      expect(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
      expect(subject).to receive(:show_message_with_input).with(:choose_difficulty, NAME_DIFFICULTIES_FOR_PUTS).and_return('', easy)
      expect(subject).to receive(:show_info).with(:unexpected_command)
      expect(subject).to receive(:play_game)
      subject.check_option
    end

    it 'entered all difficulties' do
      DIFFICULTIES_INPUT.each do |_key, value|
        allow(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
        allow(subject).to receive(:show_message_with_input).with(:choose_difficulty, NAME_DIFFICULTIES_FOR_PUTS).and_return(value)
      end
      expect(subject).to receive(:play_game)
      subject.check_option
    end
  end

  describe '#show_rules' do
    it 'return rules' do
      allow(subject).to receive(:show_info)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:rules], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      expect(subject).to receive(:show_info).with(:rules)

      subject.check_option
    end
  end

  describe '#play_game' do
    let(:some_secret_code) { [1, 1, 1, 1] }
    let(:some_secret_code_string) { '1111' }

    before do
      subject.instance_variable_set(:@game, game)
      game.instance_variable_set(:@secret_code, [1, 1, 1, 1])
      game.instance_variable_set(:@secret_code_for_hints, some_secret_code)

      allow(subject).to receive(:show_info).with(:welcome)
      allow(subject).to receive(:show_message_with_input).with(:choose_option).and_return(Console::OPTIONS[:start])
      allow(subject).to receive(:show_message_with_input).with(:write_name).and_return(name)
      allow(subject).to receive(:show_message_with_input).with(:choose_difficulty, NAME_DIFFICULTIES_FOR_PUTS).and_return('Easy')
      allow(subject).to receive(:loop).and_yield
    end

    it 'when user win' do
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(some_secret_code_string)
      allow(subject).to receive(:ask_for_save)
      allow(subject).to receive(:ask_restart)
      expect(subject).to receive(:show_info).with(:win)
      subject.check_option
    end

    it 'when ask restart' do
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(some_secret_code_string)
      allow(subject).to receive(:show_info).with(:win)
      allow(subject).to receive(:ask_for_save)
      allow(subject).to receive(:exit)
      expect(subject).to receive(:show_message_with_input).with(:restart)
      expect(subject).to receive(:show_info).with(:goodbye)
      subject.check_option
    end

    it 'when show error' do
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return('')
      expect(subject).to receive(:show_info).with(:unexpected_command)
      subject.check_option
    end

    it 'when show hint' do
      expect(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(hint)
      expect(subject).to receive(:show_info).with(:unexpected_command)
      subject.check_option
    end

    it 'when user lose' do
      subject.instance_variable_set(:@user, attempts_left: 1, attempts_total: 2)
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(test_guess)
      allow(subject).to receive(:attempts_left?)
      expect(subject).to receive(:show_info).with(:lose)
      expect(subject).to receive(:ask_restart)
      subject.check_option
    end

    it 'when used all hints' do
      subject.instance_variable_set(:@user, hints_left: 2, hints_total: 2)
      allow(subject).to receive(:show_message_with_input).with(:message_guess_code).and_return(hint)
      allow(subject).to receive(:show_info).with(:unexpected_command)
      allow(subject).to receive(:show_info).with(:used_all_hints)
      expect(subject).to receive(:check_hint)
      subject.check_option
    end
  end

  describe '#show_stats' do
    it 'when stats clear' do
      allow(subject).to receive(:show_info)
      allow(subject).to receive(:show_message_with_input).and_return(Console::OPTIONS[:stats], Console::OPTIONS[:start])
      allow(subject).to receive(:registration)
      allow(subject).to receive(:show_db_info)
      expect(subject).to receive(:show_info).with(:clear_stats)
      subject.check_option
    end
  end

  describe '#show_message_with_input' do
    it 'when show message and input' do
      allow(subject).to receive(:show_info).with('', nil)
      allow(subject).to receive(:gets).and_return('')
      subject.show_message_with_input('')
    end
  end
end
