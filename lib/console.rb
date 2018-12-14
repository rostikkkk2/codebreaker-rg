
class Console
  include ConsoleHelps
  include Validation

  attr_accessor :info_difficult, :user_name

  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'
  OPTIONS = { start: 'start', rules: 'rules', stats: 'stats', exit: 'exit' }.freeze
  YES = 'Yes'.freeze
  HINT = 'Hint'

  def initialize
    @info_difficult = nil
    @user_name = { name: nil }
    @game = Game.new
  end

  def check_option
    show_info(:welcome_and_option)
    loop do
      option = gets.chomp.downcase
      case option
      when OPTIONS[:start] then return registration
      when OPTIONS[:rules] then show_rules
      when OPTIONS[:stats] then show_stats
      when OPTIONS[:exit] then return show_info(:goodbye)
      else
        show_info(:wrong_input_option)
      end
    end
  end

  def registration
    ask_name
    ask_difficulty
    @user = Hash[*[@user_name, @info_difficult].map(&:to_a).flatten]
    play_game
  end

  def dafault_show_message_and_ask(message)
    show_info(message)
    value = gets.chomp.capitalize
    bye(value)
    value
  end

  def ask_name
    name = dafault_show_message_and_ask(:write_name)
    return if valid_name?(name)
    show_info(:unexpected_command)
    ask_name
  end

  def valid_name?(name)
    @user_name[:name] = name if validate_length_range?(name, 3, 20) && validate_string?(name)
  end

  def ask_difficulty
    difficulty = dafault_show_message_and_ask(:message_choose_difficulty)
    @info_difficult = Difficult.new(difficulty).choose_difficulty
    return unless @info_difficult.nil?
    show_info(:unexpected_command)
    ask_difficulty
  end

  def play_game
    loop do
      guess_code = dafault_show_message_and_ask(:message_guess_code)
      check_hint if guess_code == HINT
      return game_proccess(guess_code) if @game.valid_guess_code?(guess_code)
      show_info(:unexpected_command) if guess_code != HINT
    end
  end

  def game_proccess(guess_code)
    result_compare = @game.compare_guess_and_secret_codes(guess_code)
    show_info_without_i18(result_compare)
    play_game unless check_win(result_compare)
  end

  def show_hint
    @user[:hints_used] += 1
    show_info_without_i18(@game.give_digit_hint)
  end

  def check_win(compare_func)
    compare_func == '++++' ? win : check_lose
  end

  def win
    show_info_without_i18(I18n.t(:win) + "#{@game.secret_code.join} \n")
    save
    restart?
  end

  def save
    answer = dafault_show_message_and_ask(:ask_save_to_db)
    answer == YES ? Db.new(@user).add_data_to_db : return
  end

  def restart?
    answer = dafault_show_message_and_ask(:restart)
    Console.new.check_option if answer == YES
    exit
  end

  def check_lose
    @user[:attempts_used] += 1
    if @user[:attempts_used] == @user[:attempts_total]
      show_info_without_i18(I18n.t(:lose) + "#{@game.secret_code.join} \n")
      restart?
    end
  end

  def check_hint
    @user[:hints_used] != @user[:hints_total] ? show_hint : show_info(:used_all_hints)
  end

  def show_rules
    show_info(:rules)
  end

  def show_stats
    data = YAML.load_file(PATH_TO_DB)
    if !data
      show_info(:clear_stats)
    else
      sort_data = data.sort_by { |user| [user[:attempts_total], user[:attempts_used], user[:hints_used]] }
      sort_data.each do |user|
        user.each do |key, value|
          show_info_without_i18("#{key}: #{value} #{"\n" if key == :hints_used} ")
        end
      end
    end
  end
end
