require_relative "../config/environment.rb"
require 'pry'

class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end


  def self.create_table
    sql = <<-SQL
     CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT)
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs(name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    self
  end

  def self.create(hash={})
    #binding.pry
    dog = Dog.new(name:hash[:name],breed:hash[:breed])
    dog.save
  end

  # def update
  #   sql =  "UPDATE dogs SET name = ?, breed = ? where id =?"
  #   DB[:conn].execute(sql, self.name, self.breed, self.id)
  # end
  #
  # def self.create(name:, breed:)
  #   dog = Dog.new(name: name, breed: breed)
  #   dog.save
  #   dog
  # end
  #
  # def self.find_by_id(id)
  #   sql = <<-SQL
  #     SELECT * FROM dogs
  #     WHERE id = ?
  #     LIMIT 1
  #   SQL
  #   DB[:conn].execute(sql, id).map do |row|
  #     self.new_from_db(row)
  #   end.first
  # end
  #
  # def self.new_from_db(row)
  #     id = row[0]
  #     name = row[1]
  #     breed = row[2]
  #     self.new(id: id, name: name, breed: breed)
  #   end
  #
  #   def self.find_or_create_by(name:, breed:)
  #   dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = '#{name}' AND breed = '#{breed}'")
  #   if !dog.empty?
  #     dog_data = dog[0]
  #     dog = Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
  #   else
  #     dog = self.create(name: name, breed: breed)
  #   end
  #   dog
  # end
  #
  #
  # def self.find_by_name(name)
  #    sql = <<-SQL
  #      SELECT *
  #      FROM dogs
  #      WHERE name = ?
  #      LIMIT 1
  #    SQL
  #
  #    DB[:conn].execute(sql,name).map do |row|
  #      self.new_from_db(row)
  #    end.first
  #  end

end
