#!/bin/bash

echo Boot Strapping

# ios_project_path=""

# while getopts i: opt; do
# 	case $opt in
# 		i)
# 			ios_project_path=$OPTARG
# 			echo $ios_project_path
# 		;;
# 	esac
# done


ios_staging=PocoLib

mkdir $ios_staging

mkdir pocoTmp
cd pocoTmp

ios_openssl_directory=iOS_openssl
ios_openssl_install_directory=$ios_staging/openssl

echo "################################ iOS ssl START."

git clone https://github.com/x2on/OpenSSL-for-iPhone.git $ios_openssl_directory

cd $ios_openssl_directory

echo "Building ssl for iOS"
./build-libssl.sh

cd ..

mkdir ../$ios_openssl_install_directory
cp -r $ios_openssl_directory/include/ ../$ios_openssl_install_directory/include
cp -r $ios_openssl_directory/lib/ ../$ios_openssl_install_directory/lib

echo "################################ iOS ssl DONE."

echo "Cloning Poco"

poco_ios_install_directory=$ios_staging/poco
poco_prefix=$poco_ios_staging$poco_ios_install_directory
poco_dir=poco
poco_always_build=""
poco_cores="-j8"
poco_omit_list=Data/ODBC,Data/MySQL,Zip,PDF,MongoDB,CppParser,XML

git clone https://github.com/pocoproject/poco.git $poco_dir

cd $poco_dir

ssl_path=`pwd`/../$ios_openssl_directory

echo "Building Poco for iOS architectures"

iphone_sdk_version_min=8.0 #should be taken from xcode project?
ios_configurations=(iPhone-clang-libc++ iPhoneSimulator-clang-libc++)
iphone=(armv7 armv7s arm64)
ios_simulator=(i686 x86_64)

for ((i=0; i < ${#ios_configurations[@]}; i++))
	do
		configuration=${ios_configurations[$i]}
		echo Configuring for $configuration
		./configure --config=$configuration --no-samples --no-tests --omit=$poco_omit_list --include-path=$ssl_path/include --library-path=$ssl_path/lib --prefix=../../$poco_ios_install_directory

		declare -a archs_array

		if [ $i = 0 ]; then
			archs_array=("${iphone[@]}")
		else
			archs_array=("${ios_simulator[@]}")
		fi

		for j in "${archs_array[@]}"
			do
				echo Executing make for $j
				make IPHONE_SDK_VERSION_MIN=$iphone_sdk_version_min POCO_TARGET_OSARCH=$j $poco_always_build -s $poco_cores 
			done 
	done

make install
rm -rf ../../$poco_ios_install_directory/bin
rm -rf ../../$poco_ios_install_directory/lib
mkdir ../../$poco_ios_install_directory/lib
cd lib

ios_all_directory=iOSAll
mkdir $ios_all_directory
cd $ios_all_directory

lib_list=(libPocoCrypto.a libPocoData.a libPocoDataSQLite.a libPocoFoundation.a libPocoJSON.a libPocoNet.a libPocoNetSSL.a libPocoUtil.a libPocoXML.a)

#config iOS/iPhonesimulator
	#arch
		#liblist

for ((j=0; j < ${#ios_configurations[@]}; j++))
	do
		libtool_job_prefix="libtool -static"
		
		declare -a archs_array
		declare -a sub_path

		if [ $j = 0 ]; then
			sub_path="../iPhoneOS"
			archs_array=("${iphone[@]}")
		else
			sub_path="../iPhoneSimulator"
			archs_array=("${ios_simulator[@]}")
		fi

		for k in "${archs_array[@]}"
			do
				libtool_job=$libtool_job_prefix
				for i in "${lib_list[@]}"
					do
					
						lib_path="${sub_path}/${k}/${i}"
						libtool_job="${libtool_job} ${lib_path}"

					done

				libtool_job="${libtool_job} -o ${k}_libCombined.a"

				$libtool_job
			done

	done

lipo_job="lipo -c"
for ((j=0; j < ${#ios_configurations[@]}; j++))
	do
		declare -a archs_array
		if [ $j = 0 ]; then
			archs_array=("${iphone[@]}")
		else
			archs_array=("${ios_simulator[@]}")
		fi

		for k in "${archs_array[@]}"
			do
				lipo_job="${lipo_job} ${k}_libCombined.a"
			done

	done

lipo_job="${lipo_job} -o libPoco.a"
$lipo_job

cp libPoco.a ../../../../$poco_ios_install_directory/lib/libPoco.a

# cd ../../../../

# if [ "${ios_project_path}" != "" ]; then
# 	echo "Integrating into iOS project: $ios_project_path"

# 	pwd
# fi


cd ../../../../

#NDK needs to be defined

echo "Building Poco for Android architectures"

android_staging=PocoLibA

mkdir $android_staging

cd pocoTmp

android_openssl_directory=android_openssl
android_openssl_install_directory=$android_staging/openssl

echo "################################ Android ssl START."

git clone https://github.com/Metaswitch/openssl-android.git $android_openssl_directory

cd $android_openssl_directory

git remote add upstream https://android.googlesource.com/platform/external/openssl.git

git fetch upstream                       # Get newest code from Android, but don't merge)
git checkout dev                         # Checkout the dev branch
git merge upstream/kitkat-mr2.2-release  # Merge the latest Android release into this branch)
git push origin master                   # Push the updated merge

echo "Building ssl for Android"

cd jni
sed -i -e '1s/4.4.3/4.9/' Application.mk
cd ..

ndk-build

cd ..

mkdir ../$android_openssl_install_directory
cp -r $android_openssl_directory/include/ ../$android_openssl_install_directory/include
cp -r $android_openssl_directory/libs/ ../$android_openssl_install_directory/libs


echo "################################ Android ssl DONE."

x86_toolchain=android-15-toolchain-x86
arm_toolchain=android-15-toolchain-arm

$NDK/build/tools/make-standalone-toolchain.sh --platform=android-15 --install-dir=$x86_toolchain --toolchain=x86-4.8
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-15 --install-dir=$arm_toolchain --toolchain=arm-linux-androideabi-4.8

x86_path=`pwd`/${x86_toolchain}
arm_path=`pwd`/${arm_toolchain}

export PATH=$PATH:${x86_path}/bin:${arm_path}/bin

android_ssl_path=`pwd`/$android_openssl_directory
poco_android_install_directory=$android_staging/poco
cd $poco_dir

./configure --config=Android --no-samples --no-tests --omit=$poco_omit_list --include-path=$android_ssl_path/include --library-path=$android_ssl_path/libs --prefix=../../$poco_android_install_directory

android_archs=(x86 armeabi-v7a armeabi)

for j in "${android_archs[@]}"
	do
		echo Executing make for $j
		make ANDROID_ABI=${j} $poco_always_build -s $poco_cores 
	done 

make install

rm -rf ../../$poco_android_install_directory/bin
rm -rf ../../$poco_android_install_directory/lib
mkdir ../../$poco_android_install_directory/libs

cd ..
### The android libs are not combineable
cp -r $poco_dir/lib/Android/ ../$poco_android_install_directory/libs

for j in "${android_archs[@]}"
	do
		arch_path="../${poco_android_install_directory}/libs/${j}"
		
		#delete debug libs.
		find $arch_path -type f -name '*d.a' -delete
		
	done 

#echo "Clean up."

#rm -rf pocoTmp