class Db
  include ConsoleHelps

  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'

  def initialize(user_data)
    @user = user_data
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
