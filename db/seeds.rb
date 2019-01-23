# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
require 'csv'

# 计算数组的均值，忽略nil
def get_subjects(subject_values)
  if subject_values.length == 0
    return 0
  end
  sum = 0
  count = 0
  for value in subject_values
    if value != nil && value >= 0 
      sum += value
      count += 1
    end
  end
  if count == 0
    return 0
  else
    return sum / count
  end
end

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

Car.create!(carname: "Regal", description: "Buick Regal", score: 50)
Car.create!(carname: "b520i", description: "BMW 520i", score: 50)
Car.create!(carname: "Verano", description: "Buick Verano")
Car.create!(carname: "Tiguan", description: "Volkswagen Tiguan", score: 50)

15.times do |n|
  content = "test comments."
  car = Car.first
  user = User.first
  sentiment_value = 50
  Comment.create!(content: content, car: car, user: user, sentiment_value: sentiment_value, \
                      power: -1, price: -1, \
                      interior: -1, configure: -1, \
                      safety: -1, appearance: -1, \
                      control: -1, consumption: -1, \
                      space: -1, comfort: -1)
end

10.times do |n|
  content = "others' test comments."
  car = Car.last
  user = User.last
  sentiment_value = 50
  Comment.create!(content: content, car: car, user: user, sentiment_value: sentiment_value, \
                      power: -1, price: -1, \
                      interior: -1, configure: -1, \
                      safety: -1, appearance: -1, \
                      control: -1, consumption: -1, \
                      space: -1, comfort: -1)
end

models = []
CSV.foreach('data_processing/seeds.csv', headers: true) do |row|
  flag = 0
  for model in models
    if row['content_id'] == model['cid']
      flag = 1
      # model should append a new value for row's subject
      case row['subject']
      when '动力'
        model['power'] = row['sentiment_value'].to_i + 1
      when '价格'
        model['price'] = row['sentiment_value'].to_i + 1
      when '内饰'
        model['interior'] = row['sentiment_value'].to_i + 1
      when '配置'
        model['configure'] = row['sentiment_value'].to_i + 1
      when '安全性'
        model['safety'] = row['sentiment_value'].to_i + 1
      when '外观'
        model['appearance'] = row['sentiment_value'].to_i + 1
      when '操控'
        model['control'] = row['sentiment_value'].to_i + 1
      when '油耗'
        model['consumption'] = row['sentiment_value'].to_i + 1
      when '空间'
        model['space'] = row['sentiment_value'].to_i + 1
      when '舒适性'
        model['comfort'] = row['sentiment_value'].to_i + 1
      else
        puts "Error subject!"
        exit()
      end
    end
  end
  if flag == 1
    next
  end
  formatted_row = Hash['cid' => row['content_id'], \
                      'content' => row['content'], \
                      'power' => -1, 'price' => -1, \
                      'interior' => -1, 'configure' => -1, \
                      'safety' => -1, 'appearance' => -1, \
                      'control' => -1, 'consumption' => -1, \
                      'space' => -1, 'comfort' => -1]
  # handle cases for differenct subjects
  case row['subject']
  when '动力'
    formatted_row['power'] = row['sentiment_value'].to_i + 1
  when '价格'
    formatted_row['price'] = row['sentiment_value'].to_i + 1
  when '内饰'
    formatted_row['interior'] = row['sentiment_value'].to_i + 1
  when '配置'
    formatted_row['configure'] = row['sentiment_value'].to_i + 1
  when '安全性'
    formatted_row['safety'] = row['sentiment_value'].to_i + 1
  when '外观'
    formatted_row['appearance'] = row['sentiment_value'].to_i + 1
  when '操控'
    formatted_row['control'] = row['sentiment_value'].to_i + 1
  when '油耗'
    formatted_row['consumption'] = row['sentiment_value'].to_i + 1
  when '空间'
    formatted_row['space'] = row['sentiment_value'].to_i + 1
  when '舒适性'
    formatted_row['comfort'] = row['sentiment_value'].to_i + 1
  else
    puts "Error subject!"
    exit()
  end
  models.push(formatted_row)
end

car_score = 0
power_values = []
price_values = []
interior_values = []
configure_values = []
safety_values = []
appearance_values = []
control_values = []
consumption_values = []
space_values = []
comfort_values = []
for m in models
  car = Car.last
  user = User.first
  sentiment_value = 0
  sentiment_count = 0
  
  power_values.push(m['power'])
  price_values.push(m['price'])
  interior_values.push(m['interior'])
  configure_values.push(m['configure'])
  safety_values.push(m['safety'])
  appearance_values.push(m['appearance'])
  control_values.push(m['control'])
  consumption_values.push(m['consumption'])
  space_values.push(m['space'])
  comfort_values.push(m['comfort'])
  
  for attrs in m.values
    if attrs.to_i == attrs
      if attrs != -1
        sentiment_count += 1
        sentiment_value += attrs * 50
      end
    end
  end
  sentiment_value /= sentiment_count
  car_score += sentiment_value
  Comment.create!(content: m['content'], car: car, user: user, \
                  sentiment_value: sentiment_value, \
                  power: m['power'], price: m['price'], \
                  interior: m['interior'], configure: m['configure'], \
                  safety: m['safety'], appearance: m['appearance'], \
                  control: m['control'], consumption: m['consumption'], \
                  space: m['space'], comfort: m['comfort'])
end
car_score /= models.length
power = get_subjects(power_values)
price = get_subjects(price_values)
interior = get_subjects(interior_values)
configure = get_subjects(configure_values)
safety = get_subjects(safety_values)
appearance = get_subjects(appearance_values)
control = get_subjects(control_values)
consumption = get_subjects(consumption_values)
space = get_subjects(space_values)
comfort = get_subjects(comfort_values)
car_attributes = Hash[:score => car_score, \
                  :power => power, \
                  :price => price, \
                  :interior => interior, \
                  :configure => configure, \
                  :safety => safety, \
                  :appearance => appearance, \
                  :control => control, \
                  :consumption => consumption, \
                  :space => space, \
                  :comfort => comfort]
Car.last.update_attributes(car_attributes)
