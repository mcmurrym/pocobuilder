compilation_files = Dir.entries("sharedsource")
file_list = ""
compilation_files.each { |file|
	if file.include? ".c"
		file_list += " sharedsource/" + file
	end
}

puts file_list