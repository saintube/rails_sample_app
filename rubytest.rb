require 'open3'

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

bcinfo = []
content = "这个车灯真的好看，逼格很高"
puts("start")
algorithm_type = 1
cmd = "python3 algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}"
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
	while line = stdout.gets
		line = line.chomp.to_i
		bcinfo.push(line)
	end
end
#sentiment_value = get_subjects(bcinfo)
#puts sentiment_value
puts "subjects:"
puts bcinfo.class
puts bcinfo[0].class
puts bcinfo.to_s
puts("end")