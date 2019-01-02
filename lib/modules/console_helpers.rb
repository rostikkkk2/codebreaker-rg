module ConsoleHelpers
  EXIT = 'Exit'.freeze

  def show_info(info, key = nil)
    puts I18n.t(info, key)
  end

  def bye
    show_info(:goodbye)
    exit
  end
end
