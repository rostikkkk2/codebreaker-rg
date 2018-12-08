require 'i18n'
require 'yaml'
require_relative './lib/modules/console_helps'
require_relative './lib/modules/validation'
require_relative './lib/console'
require_relative './lib/registration'
require_relative './lib/db'
require_relative './lib/play'
I18n.load_path << Dir[File.expand_path('./lib/text_messages/') + '/*.yml']
I18n.config.available_locales = :en
