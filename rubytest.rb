require 'open3'

bcinfo = Array.new(20);
content=" 上下推动，切换中控显示屏，设置显示屏的";
algorithm_type = 1;
cmd = "python3 algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}";
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
	while line = stdout.gets
		bcinfo.push(line);
	end
end
puts bcinfo;