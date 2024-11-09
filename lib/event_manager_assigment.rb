require 'csv'
require 'date'
require 'time'
puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

def hours(date)
  hours = []
  date.each do |row|
    hour = row[:regdate].split()
    hour.shift
    hour = hour.join.split('')
    hour.length == 5 ? hours << "#{hour[0, 2].join}:00" : hours << "#{hour[0, 1].join.rjust(2, '0')}:00"
  end
  hours
end

def hour_frequencies(hours)
  hours.map {|hour| hours.count(hour)}.uniq.sort{|a, b| b <=> a} 
end

def hours_with_frequency(hours)
  hours.reduce(Hash.new(0)) do |storage, item|
    storage[item] += 1
    storage
  end
end

hours_array = hours(contents)
def most_registered_hours(hour_freq, hour_with_freq)
  array = []
  hour_with_freq.each do |key, value|
    array << key if value == hour_frequencies(hour_freq)[0]
  end
  array
end

def print_most_reg_hours(hours)
  puts 'the most registered hours are:'
  hours.each do |hour|
    time_obj = Time.strptime(hour, '%H:%M')
    p time_obj.strftime("%I:%M %p").strip
  end
end

def clean_phone_numbers(number)
  plain_number = number.gsub(/[^\d]+/ , '')
  if plain_number.length == 10
    return plain_number
  elsif plain_number.length == 11
    return plain_number[1, plain_number.length] if plain_number[0] == '1'
  end
  'Bad Number'
end


# contents.each do |row|
#   puts clean_phone_numbers(row[:homephone])
# end
most_reg_hours = most_registered_hours(hour_frequencies(hours_array), hours_with_frequency(hours_array))

print_most_reg_hours(most_reg_hours)


