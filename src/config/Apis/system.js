/**
 * @file
 * 系统初始化或者全局公用数据接口
 */
import request from '../request';
/** 同步七牛token */
export function syncQiniuToken() {
    return request("GET", "sys/ma/qosstoken/1.0");
}
