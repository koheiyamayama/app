# frozen_string_literal: true

sleep 10

require 'rubygems'
require 'bundler'

Bundler.require

Dir.children('./models/').each do |file_name|
  require_relative "./models/#{file_name}"
end

require 'sinatra/reloader' if ENV['ENV'] === 'development'

DB = if ENV['ENV'] === 'development'
       Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app', charset: 'utf8mb4', encoding: 'utf8mb4', collation: 'utf8mb4_general_ci')
     else
       Mysql2::Client.new(host: '192.168.11.4', username: 'kohei', password: 'h19970203', database: 'app')
     end

get '/' do
  erb :index
end

get '/todos' do
  @todos = Todo.all
  erb :'todos/index'
end

get '/todos/:id' do
  @todo = Todo.find_by(params['id'])
  erb :'todos/show'
end

post '/todos' do
end

patch '/todos/:id' do
end

delete '/todos/:id' do
end
