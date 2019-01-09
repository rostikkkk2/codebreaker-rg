class Storage
  attr_reader :db_user
  PATH_TO_DB = File.dirname(__FILE__) + '/db/db.yaml'

  def initialize
    @db_user = []
  end

  def add_data_to_db(user)
    file_exist? ? add_data_to_old_info(user) : @db_user.push(user)
    write_to_db
  end

  def add_data_to_old_info(user)
    @db_user = load.push(user)
  end

  def file_exist?
    File.exist?(PATH_TO_DB)
  end

  def sort_db_info(data)
    data.sort_by { |user| [user[:attempts_total], user[:attempts_used], user[:hints_used]] }
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
