require './person'

class Teacher < person
  attr_accessor :specialization

  def initialize(age, name, specialization, parent_permission)
    super(age, name, parent_permission: parent_permission)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end