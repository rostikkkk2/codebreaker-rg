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
    pluses = []
    minuses = []
    changed_s_code = @secret_code.clone
    code_arr = code.split('').map(&:to_i)
    changed_code_arr = code_arr

    code_arr.each_index do |i|
      next unless code_arr[i] == @secret_code[i]

      pluses.push('+')
      changed_s_code[i] = '+'
      changed_code_arr[i] = '-'
    end
    changed_code_arr.each_index do |i|
      changed_s_code.each_index do |j|
        next unless changed_code_arr[i] == changed_s_code[j]

        minuses.push('-')
        changed_s_code[j] = '+'
        changed_code_arr[i] = '-'
      end
    end
    p @secret_code
    (pluses + minuses).join('')
  end

  def generate_secrete_code
    4.times.map { rand(1..6) }
  end
end
