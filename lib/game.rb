class Game
  include Validator
  attr_reader :secret_code, :secret_code_for_hints

  LENGTH_GUESS_CODE = 4
  RANGE_GUESS_CODE = (1..6).freeze

  def initialize
    @secret_code = generate_secrete_code
    @secret_code_for_hints = @secret_code.clone.shuffle
  end

  def valid_guess_code?(guess_code)
    validate_each_char_in_range?(guess_code.split(''), RANGE_GUESS_CODE) && valid_length?(guess_code, LENGTH_GUESS_CODE)
  end

  def hints_left_increase(user)
    user[:hints_left] += 1
  end

  def attempts_left_increase(user)
    user[:attempts_left] += 1
  end

  def give_digit_hint
    @secret_code_for_hints.pop
  end

  def compare_guess_and_secret_codes(guess_code)
    @result_signs = ''
    double_secret_code = @secret_code.clone
    code_arr = guess_code.split('').map(&:to_i)
    double_guess_code = code_arr

    check_same_index(code_arr, double_secret_code, double_guess_code)
    [double_secret_code, double_guess_code].each(&:compact!)
    check_different_index(double_guess_code, double_secret_code)
    @result_signs
  end

  private

  def check_same_index(code_arr, double_secret_code, double_guess_code)
    code_arr.each_index do |index|
      next unless code_arr[index] == @secret_code[index]

      double_secret_code[index], double_guess_code[index] = nil
      @result_signs += '+'
    end
  end

  def check_different_index(double_guess_code, double_secret_code)
    double_guess_code.each do |guess_digit|
      next unless double_secret_code.include?(guess_digit)

      double_secret_code[double_secret_code.find_index(guess_digit)] = nil
      @result_signs += '-'
    end
  end

  def generate_secrete_code
    Array.new(LENGTH_GUESS_CODE) { rand(RANGE_GUESS_CODE) }
  end
end
