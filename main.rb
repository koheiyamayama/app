require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'mysql2'

get '/' do
  erb :index
end
