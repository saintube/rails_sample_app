require 'open3'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # 返回评论的主题情感信息
  def getThemeGrade(content, algorithm_type)
		bcinfo = Array.new(10);
		cmd = "python3 ../algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}";
		Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
			while line = stdout.gets
				bcinfo.push(line);
			end
		end
		puts bcinfo;
  end
  
  # 计算数组的均值，忽略nil
  def get_subjects(subject_values)
    if subject_values.length == 0
      return 0
    end
    sum = 0
    count = 0
    for value in subject_values
      if value != nil
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
