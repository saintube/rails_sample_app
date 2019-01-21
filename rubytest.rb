require 'open3'

bcinfo = Array.new(20);
content=" 弄哈，挺好看的这个灯，装了逼格高";
puts("start")
algorithm_type = 1;
cmd = "python3 algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}";
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
	while line = stdout.gets
		bcinfo.push(line);
	end
end
puts bcinfo;
puts("end")