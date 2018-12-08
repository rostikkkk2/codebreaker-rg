module ConsoleHelps
  def show_info(info)
    puts I18n.t(info)
  end

  def show_info_without_i18(info)
    puts info
  end

  def bye(input_value)
    if input_value == 'Exit'
      show_info(:goodbye)
      exit
    end
  end
end
