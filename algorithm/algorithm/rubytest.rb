require 'open3'

bcinfo = Array.new(20);
content=" 显示屏的分辨率惨不忍睹";
algorithm_type = 2;
cmd = "python3 algorithm/FindTheme.py #{content} #{algorithm_type}";
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
	while line = stdout.gets
		bcinfo.push(line);
	end
end
puts bcinfo;