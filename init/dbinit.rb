config = YAML::load(ERB.new(IO.read(File.expand_path('../../config/database.yml', __FILE__))).result)
env = ENV.fetch('APP_ENV', 'development')
ActiveRecord::Base.establish_connection(config[env])
ActiveRecord::Base.time_zone_aware_attributes = true