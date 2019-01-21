require 'open3'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # 返回评论的主题得分数组
  def getThemeGrade(content, algorithm_type)
		bcinfo = []
		app_dir = Rails.root.to_s
		cmd = "python3 #{app_dir}/algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}"
		Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
			while line = stdout.gets
		    line = line.chomp.to_i
		    bcinfo.push(line)
			end
		end
		return bcinfo
  end
  
  # 计算数组的均值，忽略nil
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
  
  # 返回评论的主题得分和综合评分的参数哈希
  def evaluate_content(content, algorithm_type)
    subjects_arr = getThemeGrade(content, algorithm_type)
    sentiment_value = get_subjects(subjects_arr)
    if sentiment_value < 0
      sentiment_value = 50
    else
      sentiment_value *= 50
    end
    scores = Hash[  :sentiment_value => sentiment_value, \
                    :power => subjects_arr[0], \
                  	:price => subjects_arr[1], \
                  	:interior => subjects_arr[2], \
                  	:configure => subjects_arr[3], \
                  	:safety => subjects_arr[4], \
                  	:appearance => subjects_arr[5], \
                  	:control => subjects_arr[6], \
                  	:consumption => subjects_arr[7], \
                  	:space => subjects_arr[8], \
                  	:comfort => subjects_arr[9]]
    return scores
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
  
  private
  
    # 前置过滤器

    # 确保用户已登录
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "请先登录!"
        redirect_to login_url
      end
    end

    # 确保是正确的用户
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 确保是管理员
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
