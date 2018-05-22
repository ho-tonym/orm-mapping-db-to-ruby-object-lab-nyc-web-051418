require "pry"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
    # create a new Student object given a row from the database
  end


  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = (?)
    SQL

    student = DB[:conn].execute(sql, name).flatten
    self.new_from_db(student)
    #returns new instance
  end


  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <= ?
    SQL

    students = DB[:conn].execute(sql, 11)
    students.map do |student|
      find_by_name(student[1]) #[2, "Sam", "10"]    1 = "Sam"
    #  binding.pry
    end
    #array of all new instances
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, 9)
  end


  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    all_students = DB[:conn].execute(sql)
    all_students.map do |student|
      new_from_db(student)
    end
  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end


  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  def self.first_X_students_in_grade_10 (times)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(sql, times)
  end

  def self.first_student_in_grade_10
    new_from_db(first_X_students_in_grade_10(1).flatten)
  end


  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade)
  end
end
