linux构建iOS应用

一、安装iOS项目构建环境

1. iOS工具链
  a. llvm/clang
    此处构建后得到可以编译工具链的的apple clang替代工具。
  b. iOS SDK 
    通过XCode安装包得到
  c. iOS Toolchains 和 iOS Platforms
    通过XCode安装包得到
  d. 构建不同arch下的执行程序，通过clang链接到所有的可执行程序，再将gcc、g++、cc、clang++建立软链接到clang程序
  e. xcbuild
    终端命令行工具，用于构建，打包，签名iOS应用。
2. cocoapods
  a. ruby
    cocoapods依赖ruby
  b. cocoapods
    gem install cocoapods

二、安装android构建环境

1. jre
  java运行时虚拟机环境
2. android sdk
  用于构建android应用

三、安装RN项目构建环境

1. node和yarn

