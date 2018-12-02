module ConsoleHelps
  def show_info(info)
    puts info
  end

  def bye(input_value)
    if input_value == 'Exit'
      show_info('Goodbye')
      exit
    end
  end
end
