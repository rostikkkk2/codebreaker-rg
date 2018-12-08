class Console
  include ConsoleHelps
  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'
  OPTIONS = { start: 'start', rules: 'rules', stats: 'stats', exit: 'exit' }.freeze

  def check_option
    hello_message
    input = false
    until input
      input = gets.chomp.downcase
      case input
      when OPTIONS[:start] then Registration.new.start_game_registration
      when OPTIONS[:rules] then show_rules
                                input = false
      when OPTIONS[:stats] then show_stats
                                input = false
      when OPTIONS[:exit] then show_info(:goodbye)
      else
        show_info(:wrong_input_option)
        input = false
      end
    end
  end

  def hello_message
    show_info(:welcome_and_option)
  end

  def show_rules
    show_info(:rules)
  end

  def show_stats
    data = YAML.load_file(PATH_TO_DB)
    if !data
      show_info(:clear_stats)
    else
      sort_data = data.sort_by { |user| [user[:attempts_total], user[:attempts_used], user[:hints_used]] }
      sort_data.each do |user|
        user.each do |key, value|
          show_info_without_i18("#{key}: #{value} #{"\n" if key == :hints_used} ")
        end
      end
    end
  end
end
