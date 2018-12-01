require 'yaml'
require_relative 'modules/text_messages'
require_relative 'modules/validation'

class Game
  include TextMessages
  include Validation

  PATH_TO_DB = File.dirname(__FILE__) + "/db/db.yaml"


  @@user = {
    rating: 1,
    name: nil,
    difficulty: nil,
    attempts_total: 0,
    attempts_used: 0,
    hints_total: 0,
    hints_used: 0
  }

  def initialize
    hello_message
    check_option
  end

  def show_info(info)
    puts info
  end

  def hello_message
    show_info(WELCOM + CHOOSE_OPTION)
  end

  def check_option
    input = false
    while !input
      input = gets.chomp.downcase
      case input
      when 'start' then start_game_registration
      when 'rules' then show_rules
      input = false
      when 'stats' then show_stats
      input = false
      when 'exit' then show_info(GOODBYE_MESSAGE)
      else
        show_info(WRONG_INPUT_OPTION)
        input = false
      end
    end
  end

  def show_stats
    data = YAML.load_file(PATH_TO_DB)
    if !data
      show_info('Statistic is empty')
    else
      data.each {|user|
        user.each {|key, value|
          show_info("#{key}: #{value} #{"\n" if key == :hints_used} ")
        }
      }
    end
  end

  def show_rules
    show_info(MESSAGE_RULES + CHOOSE_OPTION)
  end

  def start_game_registration
    show_info('Enter your name')
    name = gets.chomp.capitalize
    return if name == 'Exit'
    if is_valid_name(name)
      @@user[:name] = name
      return choose_difficulty
    end
    show_info('It is wrong')
    start_game_registration
  end

  def choose_difficulty
    show_info(MESSAGE_CHOOSE_DIFFICULTY)
    difficulty = gets.chomp.capitalize
    return if difficulty == 'Exit'
    case difficulty
    when 'Easy' then whats_difficulty("Easy", 15, 2)
    when 'Medium' then whats_difficulty("Medium", 10, 1)
    when 'Hell' then whats_difficulty("Hell", 5, 1)
    else
      show_info('It is wrong')
      choose_difficulty
    end
  end

  def whats_difficulty(name_difficulty, attempts_total, hints_total)
    @@user[:difficulty] = name_difficulty
    @@user[:attempts_total] = attempts_total
    @@user[:hints_total] = hints_total
    @@secret_code = generate_secrete_code
    @@secret_code_for_hints = @@secret_code.clone
    play_game
  end

end


game = Game.new
