class Nameable
  def correct_name
    raise NotImplementedError
  end
end

class Person < Nameable
  attr_accessor :name, :age, :rentals, :id

  def initialize(age, name = 'unknown', parent_permission = 'true')
    super()
    @id = Random.rand(1..1000)
    @age = age
    @name = name
    @parent_permission = parent_permission
    @rentals = []
  end

  def can_use_services?
    of_age? || @parent_permission
    false
  end

  def correct_name
    @name
  end

  def add_rental(date, book)
    Rental.new(date, book, self)
  end

  private

  def of_age?
    @age >= 10
  end
end

class Student < Person
  attr_accessor :classroom

  def initialize(age, name, classroom, parent_permission)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  def add_classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end

  def play
    "¯\(ツ)/¯"
  end
end

class Teacher < Person
  attr_accessor :specialization

  def initialize(age, name, specialization, parent_permission)
    super(age, name, parent_permission: parent_permission)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end

class Decorator < Nameable
  attr_accessor :nameable

  def initialize(nameable)
    super()
    @nameable = nameable
  end

  def correct_name
    @nameable
  end
end

class CapitalizeDecorator < Decorator
  def correct_name
    @nameable.correct_name.capitalize
  end
end

class TrimmerDecorator < Decorator
  def correct_name
    if @nameable.correct_name.length > 10
      @nameable.correct_name[0...10]
    else
      @nameable.correct_name
    end
  end
end

class Book
  attr_accessor :title, :author, :rentals

  def initialize(title, author)
    @title = title
    @author = author
    @rentals = []
  end

  def add_rental(date, person)
    Rental.new(date, person, self)
  end
end

class Classroom
  attr_accessor :label
  attr_reader :students

  def initialize(label)
    @label = label
    @students = []
  end

  def add_student(student)
    @students.push(student)
    student.classroom = self
  end
end

class Rental
  attr_accessor :date, :book, :person

  def initialize(date, book, person)
    @date = date

    @book = book
    book.rentals << self

    @person = person
    person.rentals << self
  end
end

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def list_all_books
    if @books.empty?
      print 'No books in library'
      return
    end
    @books.each do |book|
      print "Title: #{book.title.capitalize}, Author: #{book.author.capitalize}\n"
    end
  end

  def create_book
    print 'Title: '
    title = gets.chomp.capitalize
    print 'Author: '
    author = gets.chomp.capitalize
    book = Book.new(title: title, author: author)
    @books << book
    puts "Book created successfully\n"
  end

  def list_all_people
    if @people.empty?
      puts 'Your Library is empty'
      return
    end
    @people.each do |person|
      print "[#{person.class.name}] Name: #{person.name.capitalize}, ID: #{person.id}, Age: #{person.age}\n"
    end
  end

  def create_person
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '

    option = gets.chomp

    case option
    when '1'
      print 'Age: '
      age = gets.chomp
      print 'Name: '
      name = gets.chomp
      print 'Classroom:'
      classroom = gets.chomp
      print 'Has parent permission? [Y/N]: '
      permission_resp = gets.chomp
      parent_permission = permission_resp.downcase == 'y'

      student = Student.new(age: age, classroom: classroom, name: name, parent_permission: parent_permission)
      @people.push(student)

      puts "Person created successfuly\n"
    when '2'
      print 'Age: '
      age = gets.chomp
      print 'Name: '
      name = gets.chomp
      print 'Specialization: '
      specialization = gets.chomp

      teacher = Teacher.new(age: age, specialization: specialization, name: name, parent_permission: parent_permission)
      @people.push(teacher)

      puts "Person created successfuly\n"

    else
      puts 'Please choose number 1 or 2'
      nil
    end
  end

  def list_all_rental
    print 'ID of person: '
    id = gets.chomp.to_i

    puts 'Rentals: '

    rentals = @rentals.select { |rental| rental.person.id == id }

    if rentals.empty?
      puts 'No rentals found'
      return
    end

    rentals.each do |rental|
      print "Date: #{rental.date}, Book \'#{rental.book.title}\' by #{rental.book.author}\n"
    end
  end

  def create_rental
    if @people.empty? && @books.empty?
      puts 'Your Library is empty'
      return
    end
    puts 'Select a book by number'
    @books.each_with_index do |book, i|
      print "#{i}) Title: #{book.title}, Author: #{book.author}\n"
    end

    book_index = gets.chomp.to_i
    book = @books[book_index]

    puts 'Select a person by number'
    @people.each_with_index do |person, i|
      print "#{i}) [#{person.class}] Name: #{person.name.capitalize}, ID: #{person.id}, Age: #{person.age}\n"
    end

    person_index = gets.chomp.to_i
    person = @people[person_index]

    print "\nDate: "

    date = gets.chomp

    rental = Rental.new(date: date, person: person, book: book)
    @rentals << rental

    puts "Rental created successfully\n"
  end
end 

def main
  puts "Welcome to Library App!\n\n "
  response = nil
  app = App.new

  while response != '7'
    puts 'Please choose an option below :'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'

    response = gets.chomp

    puts "\n"

    case response
    when '1'
      app.list_all_books
    when '2'
      app.list_all_people
    when '3'
      app.create_person
    when '4'
      app.create_book
    when '5'
      app.create_rental
    when '6'
      app.list_all_rental
    when '7'
      puts 'Exit'
    end
    puts "\n"
  end
end

main()