# pocobuilder

This tool will build openssl and poco for iOS and Android and will place the libs for openssl and poco in PocoLib for iOS and PocoLibA for Android.

Currently to run:
sh pocoProjectetup.sh

This will generate a PocoLib and a PocoLibA directory. The contents contain everything you need to use poco in you iOS app and Android app: Libraries and headers.

To use in your ios app copy the directory to your project space.
Add all the generated libs to you project.
Add new Header Search Paths to locate the include directories found in PocoLib.

Also... I plan on making the instructions more clear and easier to follow.

It does not currently integrate the libs into the project automatically. Stay tuned.
