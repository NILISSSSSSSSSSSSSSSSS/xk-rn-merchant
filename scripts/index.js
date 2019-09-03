const fs = require('fs');
const os = require('os');
const path = require('path');
const child_process = require('child_process');
let requestConfig = require('../android/app/src/main/assets/requestConfig.json');

if (process.argv.length <= 2) {
  console.log('请传递参数');
}
const [argv1, argv2, argv3, ...args] = process.argv;
if (argv3 === '-r') {
  if (args.length === 0) return;
  const obj = {};
  args.forEach((arg) => {
    const splits = arg.split('=');
    if (splits.length >= 2) {
      obj[splits[0]] = splits[1];
    }
  });
  requestConfig = { ...requestConfig, ...obj };

  if (['2', '3'].includes(requestConfig.envir)) {
    console.log(`[./ios/AppDelegate/AppDelegate.m] 修改文件内容如下:
        \x1b[32m
  //   #if DEBUG
  //    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  //   #else
  jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  //   #endif
        \x1b[0m
        `);
    // const appDelegateFile = path.resolve(__dirname, '../ios/AppDelegate/AppDelegate.m');
    // child_process.exec(`code ${appDelegateFile}`, (error) => {
    //   console.log(error);
    // });
  }

  const wechatAppIds = ['wx852fa85c26f60106', 'wx469f90e31aa7c9d8']; // ["正式","测试/开发"]
  const sedParams = os.platform() === 'linux' ? '' : ' "" ';
  if (requestConfig.envir === '0') {
    const cmd = `sed -i ${sedParams} 's/${wechatAppIds[1]}/${wechatAppIds[0]}/' "${path.resolve(__dirname, '../android/app/src/main/java/com/xkshop/MainApplication.java')}"`;
    child_process.exec(cmd);
  } else {
    /**
    *  @闫菘(闫菘) 因天府银行测试环境（不支持app支付）使用的是生产环境的微信appId，导致我们dev、test、final调天府银行（微信）支付下单接口失败，现将dev、test、final环境下的《晓可广场》和《晓可盟商》的微信appId改成生产环境appId，请涉及支付的前端同时作相应改动，经测试Android可调起支付
    */
    const cmd = `sed -i ${sedParams} 's/${wechatAppIds[0]}/${wechatAppIds[1]}/' "${path.resolve(__dirname, '../android/app/src/main/java/com/xkshop/MainApplication.java')}"`;
    child_process.exec(cmd);
  }
  console.log('[./android/app/src/main/assets/requestConfig.json] 更改后文件内容如下:');
  console.log(`\x1b[32m${JSON.stringify(requestConfig, null, 4)}\x1b[0m`);
  const dir = path.resolve(__dirname, '../android/app/src/main/assets/requestConfig.json');
  fs.writeFileSync(dir, JSON.stringify(requestConfig, null, 4));
  // fix JSStackTrace.java bug
  const JSStackTraceFile = path.resolve(__dirname, './android/JSStackTrace.java');
  const copyJSStackTraceFile = path.resolve(__dirname, '../node_modules/react-native/ReactAndroid/src/main/java/com/facebook/react/util/JSStackTrace.java');
  fs.copyFileSync(JSStackTraceFile, copyJSStackTraceFile);
}
