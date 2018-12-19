class Console
  include ConsoleHelpers
  include Validator

  attr_accessor :info_difficult, :user_name, :user

  OPTIONS = { start: 'Start', rules: 'Rules', stats: 'Stats', exit: 'Exit' }.freeze
  AGREE_ANSWER = 'Yes'.freeze
  HINT = 'Hint'.freeze
  WIN = '++++'.freeze
  MIN_LENGTH_NAME = 3
  MAX_LENGTH_NAME = 20
  EXIT = 'Exit'

  def initialize
    @user_name = {}
    @game = Game.new
    @db = Storage.new
  end

  def check_option
    show_info(:welcome_and_option)
    loop do
      case show_message_and_input
      when OPTIONS[:start] then return registration
      when OPTIONS[:rules] then show_rules
      when OPTIONS[:stats] then show_stats
      else
        show_info(:wrong_input_option)
      end
    end
  end

  def registration
    ask_name
    ask_difficulty
    @user = {**@user_name, **@info_difficulty, attempts_used: 0, hints_used: 0}
    play_game
  end

  def show_message_and_input(message = nil)
    show_info(message)
    value = gets.chomp.capitalize
    bye(value)
    value
  end

  def ask_name
    name = show_message_and_input(:write_name)
    return @user_name[:name] = name if valid_name?(name)

    show_info(:unexpected_command)
    ask_name
  end

  def valid_name?(name)
     validate_length_range?(name, MIN_LENGTH_NAME, MAX_LENGTH_NAME) && validate_string?(name)
  end

  def ask_difficulty
    difficulty = show_message_and_input(:message_choose_difficulty)
    @info_difficulty = Difficulty.new(difficulty).choose_difficulty
    return if @info_difficulty

    show_info(:unexpected_command)
    ask_difficulty
  end

  def play_game
    loop do
      guess_code = show_message_and_input(:message_guess_code)
      check_hint if guess_code == HINT
      return game_proccess(guess_code) if @game.valid_guess_code?(guess_code)

      show_info(:unexpected_command) if guess_code != HINT
    end
  end

  def game_proccess(guess_code)
    puts result_compare = @game.compare_guess_and_secret_codes(guess_code)
    play_game unless check_win(result_compare)
  end

  def show_hint
    @user[:hints_used] += 1
    puts @game.give_digit_hint
  end

  def check_win(result_compare)
    result_compare == WIN ? win : check_lose
  end

  def win
    show_info(:win)
    save
    restart
  end

  def save
    @db.add_data_to_db(@user) if show_message_and_input(:ask_save_to_db) == AGREE_ANSWER
  end

  def restart
    Console.new.check_option if show_message_and_input(:restart) == AGREE_ANSWER
    bye(EXIT)
  end

  def check_lose
    @user[:attempts_used] += 1
    return if @user[:attempts_used] != @user[:attempts_total]
    show_info(:lose)
    restart
  end

  def check_hint
    @user[:hints_used] != @user[:hints_total] ? show_hint : show_info(:used_all_hints)
  end

  def show_rules
    show_info(:rules)
  end

  def show_stats
    data = @db.load if @db.file_exist?
    if data
      sort_data = sort_db_info(data)
      show_db_info(sort_data)
    else
      show_info(:clear_stats)
    end
  end

  def sort_db_info(data)
    data.sort_by { |user| [user[:attempts_total], user[:attempts_used], user[:hints_used]] }
  end

  def show_db_info(sort_data)
    sort_data.each do |user|
      user.each do |key, value|
        puts "#{key}: #{value} #{"\n" if key == :hints_used} "
      end
    end
  end
end
