require "csv"
require "faker"

20.times do
  artist = "#{Faker::Name.first_name} #{Faker::Name.last_name}"

  25.times do
    puts [artist, Faker::Commerce.product_name].to_csv
  end
end