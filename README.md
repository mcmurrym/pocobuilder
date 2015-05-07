# pocobuilder

### Summary
pocobuilder is a bash script that downloads and compiles the [Poco](http://pocoproject.org) library and [openssl](http://www.openssl.org) library for iOS (Mac should be easy to add) and Android platforms. After compiling the libraries, projects for each platform are generated. The projects link to the poco and openssl libraries and provide a common place for all your c/c++ code that will be consumed by all the platforms. In theory pocobuilder could be made to generate resources for iOS, Mac, Android, Linux, Windows (Phone and Desktop).

### Requirements: (except for Mac and Xcode this list is validated by the script)
* [A Mac](http://store.apple.com/us/mac) (This may run on other platforms, but it is untested.)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) (I' not sure if the ruby gem Xcodeproj relies on xcode; this may not be a requirement for the build script)
* [Ruby](https://www.ruby-lang.org/en/downloads/) (If you are on a mac this should already be installed)
* [Rubg gem XcodeProj](https://github.com/CocoaPods/Xcodeproj)
* [Android NDK](https://developer.android.com/tools/sdk/ndk/)
* [Android SDK](https://developer.android.com/sdk/index.html)
* $NDK defined
* $PATH needs to include a path to the Android SDK tools (i.e. /Android/sdk/tools)
* $PATH needs to include a path to the Android NDK (i.e. /Library/Android/android-ndk)

### Run script

`sh pocoProjectSetup.sh`

#### Options

* **\-n [name]** By default the script will generate directories and projects with the name "SharedSource" supply this argument to override it.
* **\-a** If you rerun the script and all the resources from the last run are still in place, rebuilding will not occur. supply this argument to force everything to rebuild.

*Notice:* The compilation of all the libraries on all the platforms may take an hour or more.
