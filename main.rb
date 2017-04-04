require 'bundler'
Bundler.require
require './init/stdlib'
require './init/dbinit'
Dir.glob('./app/models/*.rb').each do |file|
  require file
end
require './app/mcclinenotify'
