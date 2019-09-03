#! /bin/bash
TARGET_NAME=xkMerchant
BUILD_TYPE=$1
ARCHIVEPATH=./build
EXPORTPATH=./build/archive

if [ "$1" == "Release" ]; then
    EXPORTOPTIONSPLIST=./BuildArchive/adhocExportOptions.plist
else
    EXPORTOPTIONSPLIST=./BuildArchive/developmentExportOptions.plist
fi

if [ ! -d ${ARCHIVEPATH}  ];then
  mkdir ${ARCHIVEPATH}
fi

if [ ! -d ${EXPORTPATH}  ];then
  mkdir ${EXPORTPATH}
fi

xcodebuild clean -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -arch arm64 | xcpretty
xcodebuild archive -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -arch arm64 -archivePath "${ARCHIVEPATH}/${TARGET_NAME}" | xcpretty
xcodebuild -exportArchive -archivePath "${ARCHIVEPATH}/${TARGET_NAME}.xcarchive" -exportPath ${EXPORTPATH} -exportOptionsPlist ${EXPORTOPTIONSPLIST} | xcpretty

echo "xcodebuild clean -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -arch arm64 | xcpretty"
echo "xcodebuild archive -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -arch arm64 -archivePath "${ARCHIVEPATH}/${TARGET_NAME}" | xcpretty"
echo "xcodebuild -exportArchive -archivePath "${ARCHIVEPATH}/${TARGET_NAME}.xcarchive" -exportPath ${EXPORTPATH} -exportOptionsPlist ${EXPORTOPTIONSPLIST} | xcpretty"

open ${EXPORTPATH}
