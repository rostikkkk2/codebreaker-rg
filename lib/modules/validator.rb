module Validator
  def validate_length_range?(value, begin_length, last_length)
    value.length >= begin_length && value.length <= last_length
  end

  def validate_string?(value)
    value.is_a?(String)
  end

  def validate_value_in_right_range?(value, first_range, last_range)
    value.split('').each do |num|
      return false unless num.to_i >= first_range && num.to_i <= last_range
    end
  end

  def validate_right_length?(value, length)
    value.length == length
  end
end
