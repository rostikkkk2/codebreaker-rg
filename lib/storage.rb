class Storage

  attr_reader :db_user
  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'

  def initialize
    @db_user = []
  end

  def add_data_to_db(user)
    data = load if file_exist?
    data ? @db_user = data.push(user) : @db_user.push(user)
    write_to_db
  end

  def file_exist?
    File.exist?(PATH_TO_DB)
  end

  def load
    YAML.load_file(PATH_TO_DB)
  end

  def write_to_db
    db_file = File.open(PATH_TO_DB, 'w')
    db_file.write(@db_user.to_yaml)
    db_file.close
  end

end
