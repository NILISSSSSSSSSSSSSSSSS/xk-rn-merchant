#! /bin/bash
XCS_PRIMARY_REPO_DIR="/opt/xk-rn-merchant"
TARGET_NAME=xkMerchant
BUILD_TYPE=$1
ARCHIVEPATH=./build
EXPORTPATH=./build/archive
# 进入目录
cd $XCS_PRIMARY_REPO_DIR && cd ./ios

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

echo "xcbuild -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -archivePath "${ARCHIVEPATH}/${TARGET_NAME}""
xcbuild -workspace ${TARGET_NAME}.xcworkspace -scheme ${TARGET_NAME} -configuration ${BUILD_TYPE} -archivePath "${ARCHIVEPATH}/${TARGET_NAME}"
echo "xcbuild -exportArchive -archivePath "${ARCHIVEPATH}/${TARGET_NAME}.xcarchive" -exportPath ${EXPORTPATH} -exportOptionsPlist ${EXPORTOPTIONSPLIST}"
xcbuild -exportArchive -archivePath "${ARCHIVEPATH}/${TARGET_NAME}.xcarchive" -exportPath ${EXPORTPATH} -exportOptionsPlist ${EXPORTOPTIONSPLIST}