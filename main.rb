require './app'

def request
  puts 'Please choose an option below :'
  puts '1 - List all books'
  puts '2 - List all people'
  puts '3 - Create a person'
  puts '4 - Create a book'
  puts '5 - Create a rental'
  puts '6 - List all rentals for a given person id'
  puts '7 - Exit'
end

def actions(input, app)
  case input
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
  end
end

def main
  puts "Welcome to School Library App!\n\n "
  response = nil
  app = App.new
  while response != '7'
    request
    response = gets.chomp
    actions(response, app)
    puts 'Thank you for using this app'
    puts "\n"
  end
end

main
