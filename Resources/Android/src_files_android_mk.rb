project_name = ARGV[0]

compilation_files = Dir.entries(project_name)
file_list = ""
compilation_files.each { |file|
	if file.include? ".c"
		file_list += " " + project_name + "/" + file
	end
}

puts file_list