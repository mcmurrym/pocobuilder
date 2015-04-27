# pocobuilder

This tool will build openssl and poco for iOS and place the libs for openssl and poco in a given project.

Currently to run:
sh pocoProjectetup.sh

This will generate a PocoLib directory. The contents contain everything you need to use poco in you iOS app.

To use in your app copy the directory to your project space.
Add all the generated libs to you project.
Add new Header Search Paths to locate the include directories found in PocoLib.

Also... I plan on making the instructions more clear and easier to follow. Think pictures.

It does not currently integrate the libs into the project automatically. Stay tuned.
