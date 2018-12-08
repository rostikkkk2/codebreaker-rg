class Registration
  include Validation
  include ConsoleHelps

  def initialize
    @user = {
      name: nil,
      difficulty: nil,
      attempts_total: 0,
      attempts_used: 0,
      hints_total: 0,
      hints_used: 0
    }
  end

  def start_game_registration
    show_info(:write_name)
    name = gets.chomp.capitalize
    bye(name)
    if validate_length_range?(name, 3, 20) && validate_empty?(name) && validate_string?(name)
      @user[:name] = name
      return choose_difficulty
    end
    show_info(:unexpected_command)
    start_game_registration
  end

  def choose_difficulty
    show_info(:message_coose_difficulty)
    difficulty = gets.chomp.capitalize
    bye(difficulty)
    case difficulty
    when 'Easy' then whats_difficulty('Easy', 15, 2)
    when 'Medium' then whats_difficulty('Medium', 10, 1)
    when 'Hell' then whats_difficulty('Hell', 5, 1)
    else
      show_info(:unexpected_command)
      choose_difficulty
    end
  end

  def whats_difficulty(name_difficulty, attempts_total, hints_total)
    @user[:difficulty] = name_difficulty
    @user[:attempts_total] = attempts_total
    @user[:hints_total] = hints_total
    play_main = Play.new(@user)
    play_main.play_game
  end
end
