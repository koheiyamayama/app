require 'rubygems'
require 'bundler'

Bundler.require

class ActiveRecordLike
  DB = if ENV['ENV'] === 'development'
    Mysql2::Client.new(host: 'db', username: 'root', password: 'root', database: 'app', reconnect: true)
  else
    Mysql2::Client.new(host: '192.168.11.2', username: 'root', password: 'root', database: 'app')
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
      instance_variable_set("@#{key}", value)
    end

    instance_variables.each do |instance_variable|
      define_singleton_method(instance_variable.to_s.gsub('@', '')) { instance_variable_get(instance_variable) }
      define_singleton_method(instance_variable.to_s.gsub('@', '') + '=') do |value| 
        instance_variable_set(instance_variable, value) 
        send(instance_variable.to_s.gsub('@', ''))
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
    rescue StandardError
      nil
    end

    def find(id)
      statement = DB.prepare("select * from #{to_table_name} where id = ?;")
      result = statement.execute(id).map do |record|
        new(record: record)
      end[0]
      raise StandardError, 'NotFound' unless result
      result
    rescue StandardError
      nil
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
    statement = DB.prepare("delete from #{self.class.to_table_name} where id = ?;")
    if statement.execute(id)
      false
    else
      true
    end
  end

  def save
    if self.class.find(id)
      attributes = instance_variables.map do |instance_variable|
        "#{instance_variable.to_s.gsub('@', '')} = '#{send(instance_variable.to_s.gsub('@', ''))}'"
        end.join(", ")
      statement = DB.prepare("update #{self.class.to_table_name} set #{attributes} where id = ?;")
      if statement.execute(id)
        false
      else
        true
      end
    else
      hash = Hash.new
      instance_variables.each do |instance_variable|
        hash[instance_variable.to_s.gsub('@', '')] = send(instance_variable.to_s.gsub('@', ''))
      end
      self.class.insert(hash)
    end
  end

  def assign(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
    self
  end
end
