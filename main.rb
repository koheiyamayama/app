# frozen_string_literal: true

sleep 10

require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'mysql2'

Dir.children('./models/').each do |file_name|
  require_relative "./models/#{file_name}"
end

if ENV['ENV'] === 'development'
  require 'sinatra/reloader'
end

DB = if ENV['ENV'] === 'development'
       Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app')
     else
       Mysql2::Client.new(host: '192.168.11.4', username: 'kohei', password: 'h19970203', database: 'app')
     end

get '/' do
  erb :index
end

get '/todos' do
  erb :'todos/index'
end

get '/todos/:id' do
  erb :'todos/show'
end

post '/todos' do
end

patch '/todos/:id' do
end

delete '/todos/:id' do
end
