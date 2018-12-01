module Validation

  def is_valid_name(name)
    !name.empty? && name.is_a?(String) && name.length >= 3 && name.length <= 20
  end

  def is_valid_guess_code(code)
    right_nums = 0
    code.split("").each { |num|
      right_nums += 1 unless num.to_i >= 1 && num.to_i <= 6
    }
    code.length == 4 && right_nums == 0
  end

end
