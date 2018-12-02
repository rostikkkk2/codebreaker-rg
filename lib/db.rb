require_relative 'modules/console_helps'

class Db
  include ConsoleHelps

  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'

  def initialize(user_data)
    @user = {
      name: user_data[:name],
      difficulty: user_data[:difficulty],
      attempts_total: user_data[:attempts_total],
      attempts_used: user_data[:attempts_used],
      hints_total: user_data[:hints_total],
      hints_used: user_data[:hints_used]
    }
    save
  end

  def save
    show_info("Do you want to save your progres? yes/no or nothing \n")
    answer = gets.chomp.capitalize
    answer == 'Yes' ? add_data_to_db : return
  end

  def add_data_to_db
    db_user = []
    data = YAML.load_file(PATH_TO_DB)
    !data ? db_user.push(@user) : db_user = data.push(@user)
    db_file = File.open(PATH_TO_DB, 'w')
    db_file.write(db_user.to_yaml)
    db_file.close
  end
end
