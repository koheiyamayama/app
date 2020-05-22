require 'rubygems'
require 'bundler'

Bundler.require

class ActiveRecordLike
  DB = if ENV['ENV'] === 'development'
    Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app')
  else
    Mysql2::Client.new(host: '192.168.11.4', username: 'kohei', password: 'h19970203', database: 'app')
  end

  def initialize(record: {})
    record = if record&.empty?
      hash = Hash.new
      DB.query("show columns from todos;").each { |record| hash[record["Field"]] = "" }  
      hash
    else 
      record
    end

    record.each do |key, value|
      # この辺無駄にイテレートしている気がするので、リファクタする
      instance_variable_set("@#{key}", value)
      instance_variables.each do |instance_variable|
        define_singleton_method(instance_variable.to_s.gsub('@', '')) do
          instance_variable_get(instance_variable)
        end
        define_singleton_method(instance_variable.to_s.gsub('@', '') + '=') do |arg|
          instance_variable_set("@#{key}", arg)
        end
      end
    end
  end

  class << self
    def all
      statement = DB.prepare("select * from #{to_table_name};")
      statement.execute.map do |record|
        new(record: record)
      end
    end

    def insert(hash)
      raise ArgumentError, 'Hashを渡してください' unless hash.instance_of?(Hash)
      columns = hash.keys.join(',')
      values = hash.values.map { |value| "'#{value}'"}.join(',')
      statement = DB.prepare("insert into #{to_table_name} (#{columns}) values (#{values});")
      unless statement.execute
        new(record: hash)
      end
    end

    def find(id)
      statement = DB.prepare("select * from #{to_table_name} where id = ?;")
      result = statement.execute(id).map do |record|
        new(record: record)
      end[0]
      raise StandardError, 'NotFound' unless result
      result
    end

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

  def update(id)
  end

  def assign(hash)
  end
end
