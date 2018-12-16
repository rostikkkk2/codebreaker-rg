module Validation
  def validate_length_range?(val, begin_length, last_length)
    val.length >= begin_length && val.length <= last_length
  end

  def validate_string?(val)
    val.is_a?(String)
  end

  def validate_value_right_range?(val, first_range, last_range)
    val.split('').each do |num|
      return false unless num.to_i >= first_range && num.to_i <= last_range
    end
  end

  def validate_right_length?(val, length)
    val.length == length
  end
end
