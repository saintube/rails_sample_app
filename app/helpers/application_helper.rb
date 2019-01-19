require 'open3'

module ApplicationHelper

  # rendering the complete title according to the page info
  def full_title(page_title = '')                          # define a method
    base_title = "汽车在线论坛"                             # assign a value
    if page_title.empty?                                   # boolean test
      base_title                                           # return implicitly
    else
      page_title + " | " + base_title                      # build a string
    end
  end
  
  # 返回评论的主题情感信息
  def getThemeGrade(content, algorithm_type)
		bcinfo = Array.new(10);
		cmd = "python3 ../../algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}";
		Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
			while line = stdout.gets
				bcinfo.push(line);
			end
		end
		puts bcinfo;
  end
    
end
