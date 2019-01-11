# data filename: data.csv
require 'csv'
require './helpers'

print_memory_usage do
  print_time_spent do
    models = []
    CSV.foreach('seeds.csv', headers: true) do |row|
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
    # puts models
    for m in models
      sentiment_value = 0
      sentiment_count = 0
      for attrs in m.values
        if attrs.to_i == attrs
          if attrs != -1
            sentiment_count += 1
            sentiment_value += attrs * 50
          end
        end
      end
      sentiment_value /= sentiment_count
      puts sentiment_value
    end
  end
end

