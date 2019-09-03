#!/bin/sh

# 此文件为Dockerfile中允许脚本，系统环境ubuntu，依赖环境已经安装好
# 环境变量
XCS_PRIMARY_REPO_DIR="/opt/xk-rn-merchant"
TASK_TIME_FILE="starttime.log"

date +"%Y-%m-%d %H:%M:%S" > $TASK_TIME_FILE

# 设置执行环境的语言编码
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8
export LC_ALL=C.UTF-8

# 进入到项目目录
cd $XCS_PRIMARY_REPO_DIR
# 更新代码
git pull origin dev

# 运行 yarn install
yarn install --registry http://192.168.2.201:4873

# 更改编译环境
yarn run envir:test
yarn run logger:disable

# 替换语法错误的地方
cd $XCS_PRIMARY_REPO_DIR
cd ./node_modules/react-native/Libraries/LinkingIOS
sed -i 's/__nullable//' "RCTLinkingManager.h"
# 避免因为packager服务未起报错
cd $XCS_PRIMARY_REPO_DIR
cd ./node_modules/react-native/React/React.xcodeproj
sed -i 's/exit\ 2//' "project.pbxproj"

# 运行 pod install
cd $XCS_PRIMARY_REPO_DIR
cd ./ios
pod install

# 删除AppDelegate.m 中不要的行
sed -i '/sedd/d' ./AppDelegate/AppDelegate.m

# 修复pod中错误的地方
mv ./Pods/Target\ Support\ Files/ ./Pods/TargetSupportFiles
grep -rl 'stdc++.6.0.9' ./Pods | xargs sed -i "s/-l\"stdc++.6.0.9\"//g"
mv ./Pods/TargetSupportFiles ./Pods/Target\ Support\ Files/

# 打bundle包
cd $XCS_PRIMARY_REPO_DIR
if [ ! -d "release_ios" ];then
mkdir release_ios
else
echo "release_ios文件夹已经存在"
fi

npm run bundle:ios

# 构建安卓包
# npm run release

cd $XCS_PRIMARY_REPO_DIR
cd ./scripts
# 构建iOS
bash ./xcbuild.sh Debug
# 上传
bash ./upload-test.sh
# 报告
bash ./report-test.sh