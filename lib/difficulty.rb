class Difficulty
  DIFFICULTIES = {
    easy: {
      difficulty: 'Easy',
      attempts_total: 15,
      hints_total: 2
    },
    medium: {
      difficulty: 'Medium',
      attempts_total: 10,
      hints_total: 1
    },
    hell: {
      difficulty: 'Hell',
      attempts_total: 5,
      hints_total: 1
    }
  }.freeze

  def initialize(difficulty)
    @difficulty = difficulty.downcase.to_sym if difficulty
  end

  def choose_difficulty
    return DIFFICULTIES[@difficulty] if DIFFICULTIES.key?(@difficulty)
  end
end
