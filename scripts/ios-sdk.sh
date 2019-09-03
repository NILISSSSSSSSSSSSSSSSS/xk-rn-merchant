

SDK=$(ls -l /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs | grep " -> iPhoneOS.sdk" | head -n1 | awk '{print $9}')
cp -r /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk /tmp/$SDK 1>/dev/null
cp -r /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1 /tmp/$SDK/usr/include/c++ 1>/dev/null

pushd /tmp
tar -cvzf $SDK.tar.gz $SDKls
rm -rf $SDK
mv $SDK.tar.gz ~
popd