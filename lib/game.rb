class Game
  include Validator
  attr_reader :secret_code, :secret_code_for_hints

  LENGTH_GUESS_CODE = 4
  MIN_GUESS_DIGIT = 1
  MAX_GUESS_DIGIT = 6

  def initialize
    @secret_code = generate_secrete_code
    @secret_code_for_hints = @secret_code.clone.shuffle
  end

  def valid_guess_code?(guess_code)
    valid_value_in_range?(guess_code, MIN_GUESS_DIGIT, MAX_GUESS_DIGIT) && valid_length?(guess_code, LENGTH_GUESS_CODE)
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

  def restart
    return Console.new.check_option
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
      if double_secret_code.include?(guess_digit)
        double_secret_code[double_secret_code.find_index(guess_digit)] = nil
        @result_signs += '-'
      end
    end
    p @secret_code
  end

  def generate_secrete_code
    Array.new(LENGTH_GUESS_CODE) { rand(MIN_GUESS_DIGIT..MAX_GUESS_DIGIT) }
  end
end
