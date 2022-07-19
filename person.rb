require './nameable'

class Person < Nameable
  def initialize(name)
    super()
    @name = name
  end

  def correct_name
    @name
  end
end

person = Person.new('maximilianus')
puts person.correct_name
