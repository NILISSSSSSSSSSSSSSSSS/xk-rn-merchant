import { setJSExceptionHandler, setNativeExceptionHandler } from 'react-native-exception-handler';

const config = {
    allowedInDevMode: false, // 允许Dev环境下捕获错误
    forceApplicationToQuit: true, // Android原生代码异常时是否退出app
    executeDefaultHandler: false, // 是否执行默认处理函数
}

setJSExceptionHandler((error = {}, isFatal = false)=>{
    if(typeof error === "string") {
        console.warn(`${isFatal ? "[Fatal]": "[Error]"}[${"未知错误"}]${error || "错误内容"}`)
    } else if(typeof error === "object") {
     console.warn(`${isFatal ? "[Fatal]": "[Error]"}[${error.name || "未知错误"}]${error.message || "错误内容"}`)
    }
}, config.allowedInDevMode);

setNativeExceptionHandler((error)=>{
    if(typeof error === "string") {
        console.warn(`"[NativeError]"[${"未知错误"}]${error || "错误内容"}`)
    } else if(typeof error === "object") {
        console.warn(`"[NativeError]"[${error.name || "未知错误"}]${error.message || "错误内容"}`)
    }
}, config.forceApplicationToQuit, config.executeDefaultHandler)