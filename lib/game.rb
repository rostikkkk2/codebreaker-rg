require_relative 'autoload'

class Game
  include TextMessages
  include ConsoleHelps
  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'

  def initialize
    hello_message
    check_option
  end

  def check_option
    input = false
    until input
      input = gets.chomp.downcase
      case input
      when 'start' then Registration.new
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

  def hello_message
    show_info(WELCOM + CHOOSE_OPTION)
  end

  def show_rules
    show_info(MESSAGE_RULES + CHOOSE_OPTION)
  end

  def show_stats
    data = YAML.load_file(PATH_TO_DB)
    if !data
      show_info('Statistic is empty')
    else
      sort_data = data.sort_by { |user| [user[:attempts_total], user[:attempts_used], user[:hints_used]] }
      sort_data.each do |user|
        user.each do |key, value|
          show_info("#{key}: #{value} #{"\n" if key == :hints_used} ")
        end
      end
    end
  end
end

game = Game.new
