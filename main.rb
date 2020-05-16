require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'mysql2'

DB = Mysql2::Client.new(:host => "192.168.11.4", :username => "kohei", password: "h19970203")
p DB
get '/' do
  erb :index
end
