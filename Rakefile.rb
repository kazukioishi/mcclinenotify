require 'bundler/setup'
require './init/stdlib'
require 'active_record'
require 'rails'
load 'active_record/railties/databases.rake'

include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['APP_ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
ActiveRecord::Tasks::DatabaseTasks.root = Pathname.new(Dir.pwd)
DatabaseTasks.database_configuration = YAML::load(ERB.new(IO.read(File.join(config_dir, 'database.yml'))).result)
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

