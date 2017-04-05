# load bundler
require 'bundler'
Bundler.require
# initialize standard libs
require './init/stdlib'
# initialize database
require './init/dbinit'
# load all model files
Dir.glob('./app/models/*.rb').each do |file|
  require file
end
# load all libs
Dir.glob('./app/lib/*.rb').each do |file|
  require file
end
# run app
require './app/mcclinenotify'
