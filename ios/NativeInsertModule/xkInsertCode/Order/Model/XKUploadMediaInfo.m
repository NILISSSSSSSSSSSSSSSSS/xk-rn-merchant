/*******************************************************************************
 # File        : XKUploadMedioInfo.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKUploadMediaInfo.h"

@implementation XKUploadMediaInfo
#pragma mark - 请求发布
+ (void)uploadMediainfoWithModel:(XKUploadMediaInfo *)model Complete:(void(^)(NSString *error, id data))complete {
    if (model.isVideo) { // 是视频
        [self requestUploadVideoInfo:model complete:^(NSString *error, id data) {
            if (complete) {
                complete(error,data);
            }
        }];
    } else {
        [self requestUploadPicInfo:model complete:^(NSString *error, id data) {
            if (complete) {
                complete(error,data);
            }
        }];
    }
}

#pragma mark - 上传图片
+ (void)requestUploadPicInfo:(XKUploadMediaInfo *)info complete:(void(^)(NSString *error, id data))complete {
    if(info.imageNetAddr.length != 0) {
        complete(nil,@"");
    } else {
        [[XKUploadManager shareManager] uploadImage:info.image withKey:@"friendCircle" progress:nil success:^(NSString *key) {
            info.imageNetAddr = kQNPrefix(key);
            complete(nil,info.imageNetAddr);
        } failure:^(id data) {
            complete(nil,info.imageNetAddr);
        }];
    }
}

#pragma mark - 上传视频
+ (void)requestUploadVideoInfo:(XKUploadMediaInfo *)info complete:(void(^)(NSString *error, id data))complete {
    if (info.videoFirstImgNetAddr.length != 0 && info.videoNetAddr.length != 0) {
        complete(nil,@"");
    } else {
        [[XKUploadManager shareManager] uploadVideoWithUrl:info.videolocalURL FirstImg:info.image WithKey:@"friendCicle"  Progress:nil Success:^(NSString *videoKey, NSString *imgKey) {
            info.videoFirstImgNetAddr = kQNPrefix(imgKey);
            info.videoNetAddr = kQNPrefix(videoKey);
            complete(nil,@"");
        } Failure:^(NSString *error) {
            complete(error,nil);
        }];
    }
}


+ (void)uploadMediaWithMediaArr:(NSArray <XKUploadMediaInfo *> * )mediaArr Complete:(void(^)(NSString *error, id data))complete {
    dispatch_group_t group = dispatch_group_create();
    
    // 核心思想 资源上传完毕统一回调 失败再次上传时不会重复上传
    NSArray *mediaArray = mediaArr;
    for (XKUploadMediaInfo *mediaInfo in mediaArray) {
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            if (mediaInfo.isVideo) { // 是视频
                [self requestUploadVideoInfo:mediaInfo complete:^(NSString *error, id data) {
                    dispatch_semaphore_signal(sema);
                }];
            } else {
                [self requestUploadPicInfo:mediaInfo complete:^(NSString *error, id data) {
                    dispatch_semaphore_signal(sema);
                }];
            }
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 请求完成 这里判断一下资源是否已经全部上传成功
        if ([self checkMediaAllUploadWithMediaArr:mediaArr]) {
            complete(nil,@"嘿嘿 别用我我是酱油");
        } else {
            complete(@"网络错误",nil);
        }
    });
}

#pragma mark - 检测资源是否全部上传完成
+ (BOOL)checkMediaAllUploadWithMediaArr:(NSArray <XKUploadMediaInfo *> * )mediaArr {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isAdd = NO"];
    mediaArr =  [mediaArr filteredArrayUsingPredicate:pre];
    if (mediaArr.count == 0) {
        return YES;
    } else {
        for (XKUploadMediaInfo *info in mediaArr) {
            if (info.isVideo) {
                if (info.videoNetAddr.length == 0 || info.videoFirstImgNetAddr.length == 0) {
                    return NO;
                }
            } else {
                if (info.imageNetAddr.length == 0) {
                    return NO;
                }
            }
        }
        return YES;
    }
}
@end
