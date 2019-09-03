#!/bin/sh
# 上传 iOS 到蒲公英
XCS_PRIMARY_REPO_DIR="/opt/xk-rn-merchant"
XCS_PRODUCT="${XCS_PRIMARY_REPO_DIR}/ios/build/archive/xkMerchant.ipa"

MSG=`git show -s --format="%h:%an:%B"`

# 上传 iOS 到蒲公英
curl -F "file=@$XCS_PRODUCT" \
-F "_api_key=d2b300d2d73a036434e36545c81c5b4b" \
-F "buildUpdateDescription=${MSG}" \
https://www.pgyer.com/apiv2/app/upload

# 上传 安卓 到蒲公英
# curl -F "file=@$XCS_PRIMARY_REPO_DIR/android/app/build/outputs/apk/release/app-release.apk" \
# -F "_api_key=d2b300d2d73a036434e36545c81c5b4b" \
# -F "buildUpdateDescription=${MSG}" \
# https://www.pgyer.com/apiv2/app/upload
