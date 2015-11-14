require "csv"
require "faker"

id = 1

["Jazz", "Rock", "Country", "Pop", "Electronic"].each do |genre|
  20.times do
    artist = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
    decade = ["1970", "1980", "1990", "2000", "2010"]

    10.times do
      puts [id, artist, Faker::Commerce.product_name, genre, decade.sample].to_csv
      id += 1
    end
  end
end