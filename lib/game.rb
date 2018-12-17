class Game
  include Validation
  include ConsoleHelps
  attr_reader :secret_code, :secret_code_for_hints

  def initialize
    @secret_code = generate_secrete_code
    @secret_code_for_hints = @secret_code.clone
  end

  def valid_guess_code?(guess_code)
    validate_value_right_range?(guess_code, 1, 6) && validate_right_length?(guess_code, 4)
  end

  def give_digit_hint
    rand_elem = @secret_code_for_hints.sample
    @secret_code_for_hints.delete_at(@secret_code_for_hints.index(rand_elem))
    rand_elem
  end

  def compare_guess_and_secret_codes(code)
    sign = ''
    double_secret_code = @secret_code.clone
    code_arr = code.split('').map(&:to_i)
    double_guess_code = code_arr
    code_arr.each_index do |index|
      next unless code_arr[index] == @secret_code[index]

      double_secret_code[index], double_guess_code[index] = nil
      sign += '+'
    end
    [double_secret_code, double_guess_code].each(&:compact!)

    double_guess_code.each do |guess_digit|
      if double_secret_code.include?(guess_digit)
        double_secret_code[double_secret_code.find_index(guess_digit)] = nil
        sign += '-'
      end
    end
    p @secret_code
    sign
  end

  def generate_secrete_code
    Array.new(4) { rand(1..6) }
  end
end
