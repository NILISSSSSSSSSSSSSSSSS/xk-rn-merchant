0. 概述
本文档主要描述RN和原生之间的交互行为，包括xkMerchantModule（原生接口）、xkMerchantEmitterModule（原生事件）两个文件的方法和参数定义。

1. IM消息相关

    1.1. 设置中心 - 开关IM消息通知声音
    ```js
    // 开关IM消息通知声音
    xkMerchantModule.switchIMMute(flag);  // flag 整数类型 0是开启静音（没有声音），1是关闭静音（有声音）
    ```

    1.2. 设置中心 - 获取IM消息通知声音状态
    ```js
    // 获取IM消息通知声音状态
    let flag = xkMerchantModule.getIMMute();  // flag 整数类型 0是开启静音（没有声音），1是关闭静音（有声音）
    ```

2. 上传与下载

    所有接口采用promise异步规范。

    上传接口统一传递结果定义如下：

    ```js
    // 选择图片返回结果
    [{
        imagePath: "/Users/xxx/xxx.png", // 文件路径
    }]
    // 选择视频返回结果
    [{
        imagePath: "/Users/xxx/xxx.png", // 可能有封面也可能没有
        videoPath: "/Users/xxx/xxx.mp4",
    }]
    ```

    2.1 选择图片和视频
    ```js
    /**
     * 选择图片和视频
     * type 选择类型 1 图片 2 视频 3 视频或图片
     * crop 是否需要裁剪 0 不裁剪 1 裁剪
     * total 需要选择的文件数量
     * limit 限制上传的文件大小 0 不限制大小 >0 限制大小（单位KB）
     * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     **/
    xkMerchantModule.pickImageAndVideo(type, crop = 0, totalNum = 0, limit = 0, duration = 0); 
    ```
    2.2 拍照
    ```js
    /**
     * 拍照
     * type 选择类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
     * crop 是否需要裁剪 0 不裁剪 1 裁剪 (仅当type为0时参数生效)
     * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
     **/
    xkMerchantModule.takeImageAndVideo(type, crop = 0, duration = 0); 
    ```