class Console
  include ConsoleHelpers
  include Validator

  attr_reader :info_difficult, :user_name, :user

  OPTIONS = {
    start: 'Start',
    rules: 'Rules',
    stats: 'Stats',
    exit: 'Exit'
  }.freeze
  GAME_RESULTS = {
    win: '++++',
    lose: '----'
  }.freeze
  NAME_DIFFICULTIES = %w[Easy Medium Hell].freeze
  COUNT_ATTEMPTS = 0
  COUNT_HINTS = 0
  ANSWERS = {
    yes: 'Yes'
  }.freeze
  NAME_LENGTH_RANGE = (3..20).freeze
  HINT = 'Hint'.freeze
  EXIT = 'Exit'.freeze

  def check_option
    show_info(:welcome)
    loop do
      case show_message_with_input(:choose_option)
      when OPTIONS[:start] then return registration
      when OPTIONS[:rules] then show_rules
      when OPTIONS[:stats] then show_stats
      else
        show_info(:wrong_input_option)
      end
    end
  end

  def show_message_with_input(message, key = nil)
    show_info(message, key)
    value = gets.chomp.capitalize
    value == OPTIONS[:exit] ? bye : value
  end

  private

  def registration
    @user_name = ask_name
    @info_difficulty = ask_difficulty
    @user = { name: user_name, **@info_difficulty, attempts_left: COUNT_ATTEMPTS, hints_left: COUNT_HINTS }
    play_game
  end

  def ask_name
    loop do
      name = show_message_with_input(:write_name)
      return name if valid_name?(name)

      show_info(:unexpected_command)
    end
  end

  def valid_name?(name)
    validate_length_range?(name, NAME_LENGTH_RANGE) && validate_class?(name, String)
  end

  def ask_difficulty
    loop do
      difficulty = show_message_with_input(:choose_difficulty,
                                           difficulties: Difficulty::DIFFICULTIES.keys.join(', '))
      break Difficulty.new(difficulty).choose_difficulty if NAME_DIFFICULTIES.include?(difficulty)

      show_info(:unexpected_command)
    end
  end

  def play_game
    @game ||= Game.new
    loop do
      guess_code = show_message_with_input(:message_guess_code)
      check_hint if guess_code == HINT
      @game.valid_guess_code?(guess_code) ? game_proccess(guess_code) : show_info(:unexpected_command)
    end
  end

  def game_proccess(guess_code)
    puts @game.compare_guess_and_secret_codes(guess_code)
    check_win_with_lose(guess_code)
  end

  def check_win_with_lose(guess_code)
    guess_code == @game.secret_code.join ? win : check_lose
  end

  def win
    show_info(:win)
    ask_for_save
    ask_restart
  end

  def show_hint
    @game.hints_left_increase(user)
    puts @game.give_digit_hint
  end

  def ask_restart
    return check_option if show_message_with_input(:restart) == ANSWERS[:yes]

    bye
  end

  def ask_for_save
    Storage.new.add_data_to_db(user) if show_message_with_input(:ask_save_to_db) == ANSWERS[:yes]
  end

  def check_lose
    @game.attempts_left_increase(user)
    return if attempts_left?

    show_info(:lose)
    ask_restart
  end

  def attempts_left?
    user[:attempts_left] != user[:attempts_total]
  end

  def check_hint
    user[:hints_left] == user[:hints_total] ? show_info(:used_all_hints) : show_hint
  end

  def new_storage
    @db = Storage.new
  end

  def show_rules
    show_info(:rules)
  end

  def show_stats
    new_storage
    @db.file_exist? ? show_db_info(@db.load) : show_info(:clear_stats)
  end

  def show_db_info(data)
    @db.sort_db_info(data).each do |user|
      user.each do |key, value|
        puts "#{key}: #{value} #{"\n" if key == :hints_left} "
      end
    end
  end
end
