# load bundler
require 'bundler'
Bundler.require
# initialize standard libs
require './init/stdlib'
# initialize database
require './init/dbinit'
# initialize logger
Rails.logger = Logger.new(STDOUT)
# load all model files
Dir.glob('./app/models/*.rb').each do |file|
  require file
end
# load all libs
Dir.glob('./app/lib/*.rb').each do |file|
  require file
end
# run app └(。`･ ω ･´。)┘ｶﾞﾝﾊﾞﾙﾋﾞｨ
require './app/mcclinenotify'
