require 'csv'
require 'date'
require 'time'
puts 'EventManager initialized.'

contents = CSV.read(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
def regdates(csv_file)
  list_of_dates = []
  csv_file.each do |row|
    list_of_dates << DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M').strftime('%A')
    list_of_dates << DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M').strftime('%I:00 %p')
  end
  list_of_dates
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

def date_frequencies(csv_file)
  regdate_list = regdates(csv_file)
  csv_file.reduce(Hash.new(0)) do |container, row|
    date = DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M').strftime('%A')
    container[date] = regdate_list.count(date)
    container
  end
end

def hour_frequencies(csv_file)
  regdate_list = regdates(csv_file)
  csv_file.reduce(Hash.new(0)) do |container, row|
    hour = DateTime.strptime(row[:regdate], '%m/%d/%Y %H:%M').strftime('%I:00 %p')
    container[hour] = regdate_list.count(hour)
    container
  end
end

def peak_days(csv_file)
  date_frequencies = date_frequencies(csv_file)
  peak_frequency = date_frequencies.values.max
  date_frequencies.map do |key, value|
    puts key if value == peak_frequency
  end
end

def peak_hours(csv_file)
  hour_frequencies = hour_frequencies(csv_file)
  peak_frequency = hour_frequencies.values.max
  hour_frequencies.map do |key, value|
    puts key if value == peak_frequency
  end
end



contents.each do |row|
  puts clean_phone_numbers(row[:homephone])
end
puts "the peak day/s:"
peak_days(contents)
puts "the peak hour/s:"
peak_hours(contents)



