class Difficulty
  EASY = { difficulty: 'Easy', attempts_total: 15, hints_total: 2 }.freeze
  MEDIUM = { difficulty: 'Medium', attempts_total: 10, hints_total: 1 }.freeze
  HELL = { difficulty: 'Hell', attempts_total: 5, hints_total: 1 }.freeze

  def initialize(difficulty)
    @difficulty = difficulty
    @info_difficulty = {}
  end

  def choose_difficulty
    case @difficulty
    when EASY[:difficulty] then @info_difficulty = { **EASY }
    when MEDIUM[:difficulty] then @info_difficulty = { **MEDIUM }
    when HELL[:difficulty] then @info_difficulty = { **HELL }
    end
  end
end
