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
puts("================开始 Ruby + Python3 环境依赖测试==============")
puts("* 接下来，如果您能看到算法模块的输出，代表测试通过！")
algorithm_type = 2
cmd = "python3 algorithm/algorithm/FindTheme.py #{content} #{algorithm_type}"
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
	while line = stdout.gets
		line = line.chomp.to_i
		bcinfo.push(line)
	end
end
sentiment_value = get_subjects(bcinfo)
puts "输入车评: " + content
puts "算法选项: " + 2.to_s
puts "车评综合评分: " + sentiment_value.to_s
puts "主题评分:"
puts bcinfo.to_s
puts "输出类型检查: "
puts "输出数组类型: " + bcinfo.class.to_s
puts "输出数组元素: " + bcinfo[0].class.to_s
puts("==========================测试结束============================")