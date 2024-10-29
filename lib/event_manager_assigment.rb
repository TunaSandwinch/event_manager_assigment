require 'csv'
puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

def clean_phone_numbers(number)
  plain_number = number.gsub(/[^\d]+/ , '')
  if plain_number.length == 10
    return plain_number
  elsif plain_number.length == 11
    return plain_number[1, plain_number.length] if plain_number[0] == '1'
  end
  'Bad Number'
end

contents.each do |row|
  puts clean_phone_numbers(row[:homephone])
end