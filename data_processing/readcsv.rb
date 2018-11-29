# data filename: data.csv
require 'csv'
require './helpers'

print_memory_usage do
  print_time_spent do
    models = []
    CSV.foreach('small.csv', headers: true) do |row|
      row_h = Hash.new
      models.push(row)
      puts row
    end
    #puts models
  end
end

