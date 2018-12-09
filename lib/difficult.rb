class Difficult
  include Validation
  include ConsoleHelps

  NAME_DIFFICULTS = { easy: 'Easy', medium: 'Medium', hell: 'Hell' }.freeze

  def initialize(difficulty)
    @difficulty = difficulty
    @info_difficult = {
      difficulty: nil,
      attempts_total: 0,
      attempts_used: 0,
      hints_total: 0,
      hints_used: 0
    }
  end

  def choose_difficulty
    case @difficulty
    when NAME_DIFFICULTS[:easy] then whats_difficulty('Easy', 15, 2)
    when NAME_DIFFICULTS[:medium] then whats_difficulty('Medium', 10, 1)
    when NAME_DIFFICULTS[:hell] then whats_difficulty('Hell', 5, 1)
    end
  end

  def whats_difficulty(name_difficulty, attempts_total, hints_total)
    @info_difficult[:difficulty] = name_difficulty
    @info_difficult[:attempts_total] = attempts_total
    @info_difficult[:hints_total] = hints_total
    @info_difficult
  end
end
