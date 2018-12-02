require_relative 'autoload'

class Registration
  include Validation
  include ConsoleHelps
  include TextMessages

  def initialize
    @user = {
      name: nil,
      difficulty: nil,
      attempts_total: 0,
      attempts_used: 0,
      hints_total: 0,
      hints_used: 0
    }
    start_game_registration
  end

  def start_game_registration
    show_info('Enter your name')
    name = gets.chomp.capitalize
    bye(name)
    if is_valid_name(name)
      @user[:name] = name
      return choose_difficulty
    end
    show_info('It is wrong')
    start_game_registration
  end

  def choose_difficulty
    show_info(MESSAGE_CHOOSE_DIFFICULTY)
    difficulty = gets.chomp.capitalize
    bye(difficulty)
    case difficulty
    when 'Easy' then whats_difficulty('Easy', 15, 2)
    when 'Medium' then whats_difficulty('Medium', 10, 1)
    when 'Hell' then whats_difficulty('Hell', 5, 1)
    else
      show_info('It is wrong')
      choose_difficulty
    end
  end

  def whats_difficulty(name_difficulty, attempts_total, hints_total)
    @user[:difficulty] = name_difficulty
    @user[:attempts_total] = attempts_total
    @user[:hints_total] = hints_total
    Play.new(@user)
  end
end
