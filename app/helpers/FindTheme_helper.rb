require 'open3'

module FindThemeHelper
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