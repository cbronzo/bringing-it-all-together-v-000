require_relative "../config/environment.rb"

class Dog
  
  attr_accessor :name, :breed, :id

  def initialize (name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT
      breed TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
      SQL
    DB[:conn].execute(sql)
  end
  
   def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end
  
  def self.create(name:, breed:)
   dog = Dog.new(name: name, breed: breed)
   dog.save
   dog
 end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
    self.new_from_db(row)
    end.first
  end
  
  def self.new_from_db(row)
    dog = self.new(row[0], row[1], row[2])
    dog.id = row[0]
    dog.name = row[1]
    dog.breed = row[2]
    dog
  end
  
  def update
    sql = "UPDATE students SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  
  
  
  
end