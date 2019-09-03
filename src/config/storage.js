/**
 * https://github.com/sunnylqm/react-native-storage/blob/master/README-CHN.md
 */
import {
    AsyncStorage
} from 'react-native';
import Storage from 'react-native-storage';

var storage = new Storage({
    // 最大容量，默认值1000条数据循环存储
    size: 1000,
    // 存储引擎：对于RN使用AsyncStorage
    // 如果不指定则数据只会保存在内存中，重启后即丢失
    storageBackend: AsyncStorage,
    // 数据过期时间，默认为null永不过期，也可以设置一整天（1000 * 3600 * 24 毫秒）
    defaultExpires: null,
    // 读写时在内存中缓存数据。默认启用。
    enableCache: false,
    // 如果storage中没有相应数据，或数据已过期，
    // 则会调用相应的sync方法，无缝返回最新数据。
    sync: {
        //
    }
});

export default storage;

// 保存
// storage.save({
//   key: 'user',  // 注意:请不要在key中使用_下划线符号!
//   id: '001',   // 注意:请不要在id中使用_下划线符号!
//   data: userA,
//   expires: null
// });

// 读取
// storage.load({
//   key: 'user',
//   id: '001'
// }).then(ret => {
//   // 如果找到数据，则在then方法中返回
//   console.log(ret);
// }).catch(err => {
//   // 如果没有找到数据且没有sync方法，
//   // 或者有其他异常，则在catch中返回
//   console.warn(err);
// });

// 删除单个数据
// storage.remove({
//   key: 'user'
// });
// // or
// storage.remove({
//   key: 'user',
//   id: '001'
// });

// !! 清空map，移除所有"key-id"数据（但会保留只有key的数据）
// storage.clearMap();
