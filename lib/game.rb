require_relative 'text_messages'

class Game
  include TextMessages

  def initialize
    hello_message
    check_option
  end

  def show_info(info)
    puts info
  end

  def hello_message
    show_info(WELCOM + CHOOSE_OPTION)
  end

  def check_option
    input = false
    while !input
      input = gets.chomp.downcase
      case input
      when 'start' then start_game_registration
      when 'rules' then show_rules
      input = false
      when 'stats' then show_stats
      input = false
      when 'exit' then show_info(GOODBYE_MESSAGE)
      else
        show_info(WRONG_INPUT_OPTION)
        input = false
      end
    end
  end

  def show_rules
    show_info(MESSAGE_RULES + CHOOSE_OPTION)
  end

end

game = Game.new
