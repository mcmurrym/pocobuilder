require 'xcodeproj'

proj = Xcodeproj::Project.new("PocoLib/PocoLib.xcodeproj")
main_group = proj.new_group("PocoLib")

#ssl groups
ssl_group = main_group.new_group("openssl")
ssl_include_group = ssl_group.new_group("include")
ssl_lib_group = ssl_group.new_group("lib")

#poco groups
poco_group = main_group.new_group("poco")
poco_include_group = poco_group.new_group("include")
poco_lib_group = poco_group.new_group("lib")

#target
app_target = proj.new_target(:static_library, "Poco", :ios, "8.0")
frameworks_build_phase = app_target.frameworks_build_phase

#add search paths
configurations = ["Debug", "Release"]
configurations.each { |config| 
	build_settings = app_target.build_configuration_list.build_settings(config)
	header_ref = build_settings["HEADER_SEARCH_PATHS"]
	if header_ref == nil 
		header_ref = []
		header_ref.push("$(inherited)")
		build_settings["HEADER_SEARCH_PATHS"] = header_ref
	end
	header_ref.push("$(SRCROOT)/openssl/include")
	header_ref.push("$(SRCROOT)/poco/include")

	library_ref = build_settings["LIBRARY_SEARCH_PATHS"]
	if library_ref == nil 
		library_ref = []
		build_settings["LIBRARY_SEARCH_PATHS"] = library_ref
	end
	library_ref.push("$(SRCROOT)/openssl/lib")
	library_ref.push("$(SRCROOT)/poco/lib")
}

#save i guess
proj.save()

#this function adds the headers to the project
def add_headers(directory, relative_directory, group, app_target)
	header_files = Dir.entries(directory)

	header_files.each { |file|
		if !file.include? ".c"
			if file.include? ".h"
				h_ref = group.new_file(relative_directory + file)
				# build_file_ref = app_target.headers_build_phase().add_file_reference(h_ref, true)
				# build_file_ref.settings = { "ATTRIBUTES" => ["Public"] }
			elsif file != "." && file != ".."
				a_header_group = group.new_group(file)
				add_headers(directory + "/" + file, relative_directory + "/" + file + "/", a_header_group, app_target)
			end
		end
	}
end

#this function adds the framework files to the project
def add_files(frameworks_build_phase, files, lib_group, relative_source_directory)
	files.each { |file|
		if file != "." && file != ".."
			a_ref = lib_group.new_file(relative_source_directory + file)
			frameworks_build_phase.add_file_reference(a_ref, true)
		end
	}
end

#h files
add_headers("PocoLib/poco/include/Poco/", "poco/include/Poco/",poco_include_group, app_target)

poco_a_files = Dir.entries("PocoLib/poco/lib")

add_files(frameworks_build_phase, poco_a_files, poco_lib_group, "poco/lib/")

#a files
add_headers("PocoLib/openssl/include/openssl/", "openssl/include/openssl/", ssl_include_group, app_target)

ssl_a_files = Dir.entries("PocoLib/openssl/lib")

add_files(frameworks_build_phase, ssl_a_files, ssl_lib_group, "openssl/lib/")

#save and done
proj.save()
