

####  初始化项目

一、git clone git@47.104.155.18:xk-rn/xk-rn-merchant.git

二、yarn

> 项目只使用 yarn

#### yarn 安装

`npm i yarn -g`

#### yarn 命令

| yarn                  | npm                     |
| --------------------- | ----------------------- |
| yarn                  | npm i                   |
| yarn add [package]    | npm i --save [package]  |
| yarn remove [package] | npm uninstall [package] |

#### 开启 debug 开发者菜单

`adb shell input keyevent 82`

#### 删除 node_modules

`rm -rf node_modules`

三、ios

1、cd ios

2、pod install

3、用 Xcode 打开 xkMerchant.xcworkspace 文件（不要打开 xkMerchant.xcodeproj）

4、打包

> 错误解决
>
> 1、Xcode-> File->Project/Workspace settings.
>
> 2、修改 the build system 为 Legacy Build system.
>
> 3、Open Xcode > Pods > Targets Support Files > Pods-{TARGET-NAME}
> find "OTHER_LDFLAGS" and remove only "-ObjC" in these two files:
> Pods-{TARGET-NAME}.release.xcconfig & Pods-{TARGET-NAME}.debug.xcconfig
>
> ~~4、Go to project main target > Build Settings > Other Linker Flags:
> Make sure no "-ObjC" is left in the value~~

四、adnroid

#### android 打包

cd android && gradle assembleRelease

android studio 摇一摇命令： adb shell input keyevent 82

> Mac debug 找不到设备
> 执行 chmod 755 android/gradlew

ios打包main.jsbundle
react-native bundle --entry-file index.js --platform ios --dev false --bundle-output release_ios/main.jsbundle --assets-dest release_ios/

七、分享到 qq 需要等 qq 开放平台审核过后才能分享成功，现在提示应用不存在,微博和 qq 都要等审核(ios)

八、获取地址数据：console.log('////////////////', storage.sync)

九：切换环境：npm run envir:test

dev: 17311441900(入驻成功)
        17311441898
        17311441897 shop:jia-00-02  userId:5c4a78540334552384d75dfe merchantId;5c4a79920334552384d75dff  (入驻成功)
        17311441885 (入驻成功) 可晓可币充值  102127 code: 1501040002 c18368
     17311441894 （入驻成功）652001
     17311441898 (入驻成功） 638001
     17311441886 737001   code:2301030001
     17311441842 101345
     17311441799 （商户和合伙人）102017


     18664960022
        123456

正式 13568960505 zt123456 1000059001
    13086638978 2010hjc
18900000002-9

dev存在的主播账号：
13927791851  家族安全码：

dev存在的晓可账号
15808077462
19940855384
dev 家族长安全吗：634001


test:家族安全码 100035 安全码：174001 晓可

test:13568969966
17311441885 100223
17311441883 （商户修改审核中） 100314
17311441882 （商户） 100315
家族长安全吗：100050

final:17311441880 100264
  17311441879 (扩展商户失败 -修改了资料，没有修改店铺)=》继续入驻  100281
  17311441878 (线下支付，全部信息提交完毕) =》审核中
  17311441877 入驻完成 100283
  17311441876 (线上支付 ，未提交店铺) =》继续入驻
   15884545646

13600000004 xk123456
#### CodePush 相关
登录：
`code-push login http://push.xksquare.com/`
账号：`admin`
密码：`123456`
token: `ae29ecf09c39e563d1c5ab233264b09528b1156e`

android版本的App名字：`com.xkshop.android`
ios版本的App名字：`com.xkshop.ios`

- 查看不同平台不同版本的的CodePush key：`code-push deployment ls -k <appName>`
eg: 
`code-push deployment ls -k com.xkshop.android`
`code-push deployment ls -k com.xkshop.ios`
- 查看更新历史`code-push deployment history <appName> <Production> or <Staging>`
eg: 
`code-push deployment history com.xkshop.android Staging`
`code-push deployment history com.xkshop.ios Staging`
 - 清除历史
 `code-push deployment clear <appName> Production or Staging`
##### CodePush 发布更新
两种方式：
- 简单方法：`code-push release-react <appName> <platform>`
eg:
`code-push release-react com.xkshop.ios ios`
`code-push release-react com.xkshop.android android`
- 复杂方法：
eg:
`code-push release-react com.xkshop.android android  --t 1.0 --dev false --d Staging --des "1.优化操作流程\n2.这是第二条内容" --m true`
`code-push release-react com.xkshop.ios ios  --t 1.0.0 --dev false --d Staging --des "1.优化操作流程\n2.这是第二条内容" --m true`
- 参数说明：
> –t为二进制(.ipa与apk)安装包的的版本，
–dev为是否启用开发者模式(默认为false)；
–d是要发布更新的环境分Production与Staging(默认为Staging)；
–des为更新说明，一般5条
–m 是强制更新。

## 打包命令

1. `npm run envir:test`
2. 更改`AppDelegate.m`
3. 测试和开发环境，运行`npm run build:debug` / 生产环境，运行`npm run build:release`

问题：
1、夺奖派对收藏列表：既有取消收藏又有删除功能（实际功能一样，冗余）
2、自己做了任务为什么还要自己审核
