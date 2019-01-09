module Validator
  def validate_length_range?(value, length_range)
    length_range.include?(value.length)
  end

  def validate_class?(value, klass)
    value.is_a?(klass)
  end

  def validate_each_char_in_range?(value, length_range)
    value.each { |num| return false unless length_range.include?(num.to_i) }
  end

  def valid_length?(value, length)
    value.length == length
  end
end
