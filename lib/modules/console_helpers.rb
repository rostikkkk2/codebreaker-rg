module ConsoleHelpers
  EXIT = 'Exit'

  def show_info(info)
    puts I18n.t(info)
  end

  def bye(input_value)
    return if input_value != EXIT
    show_info(:goodbye)
    exit
  end
end
