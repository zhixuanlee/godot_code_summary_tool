extends Node

# 汇总文件的保存路径
var output_file = "res://gd_scripts_summary.txt"
var summary_content = ""
func _ready():
	# 开始收集脚本
	collect_all_gd_scripts()
	print("脚本汇总完成！文件保存至: ", output_file)
	get_tree().quit()

func collect_all_gd_scripts():
	
	# 从项目根目录开始搜索
	var root_dir = DirAccess.open("res://")
	if not root_dir:
		print("无法打开项目根目录: ", DirAccess.get_open_error())
		return
	
	# 递归遍历所有文件
	traverse_files(root_dir, "")
	# 保存汇总内容到文件
	var out_put_file := FileAccess.open(output_file, FileAccess.WRITE)
	out_put_file.store_string(summary_content)

func traverse_files(dir: DirAccess, current_path: String):
	# 获取目录中的所有条目
	dir.list_dir_begin()
	var entry = dir.get_next()
	
	while entry != "":
		# 跳过.和..
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue
		
		var full_path = current_path + entry
		var is_dir = dir.current_is_dir()
		
		if is_dir:
			# 如果是目录，递归处理
			var sub_dir = DirAccess.open("res://" + full_path)
			if sub_dir:
				traverse_files(sub_dir, full_path + "/")
		else:
			# 如果是.gd文件，读取内容
			if entry.ends_with(".gd"):
				var file_path = "res://" + full_path
				var file_content = FileAccess.open(file_path, FileAccess.READ).get_as_text()
				
				if file_content != null:
					# 添加文件路径作为分隔符
					summary_content += "\n\n" + "=".repeat(80)  + "\n"
					summary_content += "文件路径: " + file_path + "\n"
					summary_content += "=".repeat(80) + "\n\n"
					
					# 添加文件内容
					summary_content += file_content
		
		entry = dir.get_next()
	
	dir.list_dir_end()
