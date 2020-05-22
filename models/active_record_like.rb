require 'rubygems'
require 'bundler'

Bundler.require

class ActiveRecordLike
  DB = if ENV['ENV'] === 'development'
    Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app')
  else
    Mysql2::Client.new(host: '192.168.11.4', username: 'kohei', password: 'h19970203', database: 'app')
  end

  def initialize(record)
    record.each do |key, value|
      instance_variable_set("@#{key}", value)
      instance_variables.each do |instance_variable|
        define_singleton_method(instance_variable.to_s.gsub('@', '')) do
          instance_variable_get(instance_variable)
        end
      end
    end
  end

  class << self
    def all
      statement = DB.prepare("select * from #{to_table_name};")
      statement.execute.map do |record|
        new(record)
      end
    end

    def insert
    end

    def find_by(id)
      statement = DB.prepare("select * from #{to_table_name};")
      statement.execute.map do |record|
        new(record)
      end[0]
    end

    private

    def to_table_name
      str = to_s
      str.split("").each_with_index do |char, index|
        next if index.zero?
        if char.match(/[A-Z]/)
          str.insert(index, "_")
        end
      end
      str.downcase + 's'
    end
  end

  def destroy
  end

  def update
  end
end
