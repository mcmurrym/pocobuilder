require 'fileutils'

project_name = ARGV[0]
libs_dir = ARGV[1]

top_dir = "Android"

project_path = project_name + "/" + top_dir
jni_path = project_path + "/" + "jni"

libs_path = project_name + "/" + libs_dir
android_create = ""

if Dir.exist?(project_name + "/Android")
	puts "update"
	android_create = "android update lib-project --target 1 --path " + project_path
else
	android_create = "android create lib-project --name " + project_name + " --target 1 --path " + project_path + " --package com.pocobuilder." + project_name
end

system(android_create)

if !Dir.exist?(jni_path)
	Dir.mkdir(jni_path)
end

resource_path = "Resources/Android/"

FileUtils.cp(resource_path + "_Android.mk", jni_path + "/Android.mk")
FileUtils.cp(resource_path + "_Application.mk", jni_path + "/Application.mk")
FileUtils.cp(resource_path + "src_files_android_mk.rb", jni_path + "/src_files_android_mk.rb")

android_mk_file_path = jni_path + "/Android.mk"

text = File.read(android_mk_file_path)
new_contents = text.gsub("__ModuleName__", project_name)
File.open(android_mk_file_path, "w") {|file| file.puts new_contents }

poco_dir = jni_path + "/poco"

if !Dir.exist?(poco_dir) 
	link_poco_dir = "ln -s ../../" + libs_dir + "/poco " + jni_path + "/poco"
	link_openssl_dir = "ln -s ../../" + libs_dir + "/openssl " + jni_path + "/openssl"
	link_shared_src = "ln -s ../../" + project_name + " " + jni_path + "/" + project_name

	system(link_poco_dir)
	system(link_openssl_dir)
	system(link_shared_src)
end