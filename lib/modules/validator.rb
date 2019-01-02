module Validator
  def validate_length_range?(value, length_range)
    length_range.include?(value.length)
  end

  def validate_class?(value, klass)
    value.is_a?(klass)
  end

  def validate_each_char_in_range?(value, first_range, last_range)
    value.each do |num|
      return false unless num.to_i.between?(first_range, last_range)
    end
  end

  def valid_length?(value, length)
    value.length == length
  end
end
