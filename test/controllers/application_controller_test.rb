require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @car = cars(:regal)
    @comment = comments(:regal_comment)
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  def get_subjects(subject_values)
    if subject_values.length == 0
      return -1
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
      return -1
    else
      return sum / count
    end
  end
  
  def calculate_scores(coms)
    subjects = ['power', 'price', 'interior', 'configure', 'safety', \
                'appearance', 'control', 'consumption', 'space', 'comfort']
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
    for m in coms
      sentiment_count = 0
      sentiment_value = 0
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
      for attrs in m.attributes
        if attrs[1].to_i == attrs[1] && subjects.include?(attrs[0])
          if attrs[1] != -1
            sentiment_count += 1
            sentiment_value += attrs[1] * 50
          end
        end
      end
      if sentiment_count != 0
        sentiment_value /= sentiment_count
      else
        sentiment_value = 50
      end
      car_score += sentiment_value
    end
    if coms.length != 0
      car_score /= coms.length
    else
      car_score = 50
    end
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
    return car_attributes
  end

  test "should return correct scores" do
    init_subjects = Hash[:power => -1, \
                  	:price => -1, \
                  	:interior => -1, \
                  	:configure => -1, \
                  	:safety => -1, \
                  	:appearance => -1, \
                  	:control => -1, \
                  	:consumption => -1, \
                  	:space => -1, \
                  	:comfort => -1]
    @comment.update_attributes(init_subjects)
    new_scores = calculate_scores([@comment])
    correct_scores = Hash[:score => 50, \
			                  :power => -1, \
                        :price => -1, \
                        :interior => -1, \
                        :configure => -1, \
                        :safety => -1, \
                        :appearance => -1, \
                        :control => -1, \
                        :consumption => -1, \
                        :space => -1, \
                        :comfort => -1]
    assert_equal new_scores, correct_scores
  end

end
