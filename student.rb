require './person'
require './classroom'

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
