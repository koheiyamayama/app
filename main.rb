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
       Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app', charset: 'utf8mb4', encoding: 'utf8mb4', collation: 'utf8mb4_general_ci', reconnect: true)
     else
       Mysql2::Client.new(host: '10.0.2.4', username: 'root', password: 'root', database: 'app')
     end

enable :method_override

get '/' do
  erb :index
end

get '/todos' do
  @todos = Todo.all
  erb :'todos/index'
end

get %r{/todos/(\d+)} do
  @todo = Todo.find(params['captures'].first)
  erb :'todos/show'
end

get '/todos/new' do
  erb :'todos/new'
end

get '/todos/:id/edit' do
  @todo = Todo.find(params['id'])
  erb :'todos/edit'
end

post '/todos' do
  Todo.insert(params.to_h)
  redirect '/todos'
end

patch '/todos/:id' do
  todo = Todo.find(params['id'])
  todo.assign({id: todo.id, title: params['title'], body: params['body']})
  todo.save
  redirect '/todos'
end

delete '/todos/:id' do
  todo = Todo.find(params['id'])
  todo.destroy
  redirect '/todos'
end
