require 'i18n'
require 'yaml'
require_relative './lib/modules/console_helpers'
require_relative './lib/modules/validator'
require_relative './lib/console'
require_relative './lib/difficulty'
require_relative './lib/storage'
require_relative './lib/game'
I18n.load_path << Dir[File.expand_path('./lib/text_messages/') + '/*.yml']
I18n.config.available_locales = :en
