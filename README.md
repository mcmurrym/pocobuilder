# pocobuilder

### Summary
pocobuilder is a bash script that downloads and compiles the [Poco](http://pocoproject.org) library and [openssl](http://www.openssl.org) library for iOS (Mac should be easy to add) and Android platforms. After compiling the libraries projects for each platform are generatated (currently only an Xcode project is generated). The projects link to the poco and openssl libraries and provide a common place for all your c/c++ code that will be consumed by all the platforms. In theory pocobuilder could be made to generate resources for iOS, Mac, Android, Linux, Windows (Phone and Desktop).

### Requirements: (this list is not currently validated by the script)
* A Mac (haven't tested this anywhere else, the xcode project generation is done by a ruby gem so technically this could run on other OS's)
* Xcode
* NDK
* $NDK defined
* Ruby
* Ruby gem xcodeproj
* $PATH needs to include a path to: ... /Android/sdk/tools

### Run script
The build is not currently configurable.
To run: run `sh pocoProjectSetup.sh` in the directory this repo was cloned or downloaded to.

*Notice:* The compilation of all the libraries on all the platforms my take an hour or more.
