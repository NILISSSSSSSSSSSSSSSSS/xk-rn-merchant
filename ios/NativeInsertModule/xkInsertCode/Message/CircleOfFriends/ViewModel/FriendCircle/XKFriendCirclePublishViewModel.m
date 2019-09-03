/*******************************************************************************
 # File        : XKFriendCirclePublishViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/23
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCirclePublishViewModel.h"
#import "XKUploadMediaInfo.h"
#import "UIImage+Reduce.h"

@implementation XKFriendCirclePublishViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createDefualt];
  }
  return self;
}

- (void)createDefualt {
  _mediaInfoArr = @[].mutableCopy;
  XKUploadMediaInfo *addInfo = [[XKUploadMediaInfo alloc] init];
  addInfo.isAdd = YES;
  [self.mediaInfoArr addObject:addInfo];
}


#pragma mark - 请求发布
- (void)requestPublishComplete:(void(^)(NSString *error, id data))complete {
  __weak typeof(self) weakSelf = self;
  BOOL noMedia = [self getMediaArray].count == 0;
  if (noMedia) { // 没图片或者视频
    [self innerRequestPublishComplete:^(NSString *error, id data) {
      EXECUTE_BLOCK(complete,error,data);
    }];
  } else {
    [self uploadMediaComplete:^(NSString *error, id data) {
      if (error) {
        EXECUTE_BLOCK(complete,error,data);
      } else {
        [weakSelf innerRequestPublishComplete:^(NSString *error, id data) {
          EXECUTE_BLOCK(complete,error,data);
        }];
      }
    }];
  }
}

#pragma mark - GCD统一上传图片视频
- (void)uploadMediaComplete:(void(^)(NSString *error, id data))complete {
  dispatch_group_t group = dispatch_group_create();
  
  // 核心思想 资源上传完毕统一回调 失败再次上传时不会重复上传
  NSArray *mediaArray = [self getMediaArray];
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
    if ([self checkMediaAllUpload]) {
      complete(nil,@"嘿嘿 别用我我是酱油");
    } else {
      complete(@"网络错误",nil);
    }
  });
}

#pragma mark - 上传图片
- (void)requestUploadPicInfo:(XKUploadMediaInfo *)info complete:(void(^)(NSString *error, id data))complete {
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
- (void)requestUploadVideoInfo:(XKUploadMediaInfo *)info complete:(void(^)(NSString *error, id data))complete {
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

#pragma mark - 最终提交
- (void)innerRequestPublishComplete:(void(^)(NSString *error, id data))complete {
  NSString *url = @"im/ua/friendCircleReleaseDynamic/1.0";
  NSMutableDictionary *params = @{}.mutableCopy;
  
  params[@"content"] =  [self.contentStr sensitiveFilter];
  
  // 资源
  if ([self getMediaArray].count != 0) { // 有视频或者图片
    NSArray *videoes = [self getVideoArray];
    if (videoes.count != 0) { // 代表是视频
      XKUploadMediaInfo *videoInfo = videoes.firstObject;
      NSMutableDictionary *videoDic = @{}.mutableCopy;
      videoDic[@"showPic"] = videoInfo.videoFirstImgNetAddr;
      videoDic[@"url"] = videoInfo.videoNetAddr;
      
      params[@"detailType"] = @"video";
      params[@"videoContent"] = @[videoDic];
    } else {
      NSArray *pics = [self getPicArray];
      NSMutableArray *picDicArr = @[].mutableCopy;
      for (XKUploadMediaInfo *picInfo in pics) {
        NSMutableDictionary *picDic = @{}.mutableCopy;
        picDic[@"url"] = picInfo.imageNetAddr;
        [picDicArr addObject:picDic];
      }
      params[@"detailType"] = @"picture";
      params[@"pictureContent"] = picDicArr;
    }
  } else {
    params[@"detailType"] = @"content";
  }
  
  // 权限
  if (self.dynamicAuthResult) {
    NSString *dynamicAuthType = [self.dynamicAuthResult getDynamicAuthType];
    NSArray *userIds = [self.dynamicAuthResult getDynamicUserIds];
    if ([dynamicAuthType isEqualToString:DynamicAuthSee] || [dynamicAuthType isEqualToString:DynamicAuthUnSee]) { // 部分可见 和部分不可见
      if (userIds.count == 0) { // 没有选择人 相当于没有设置权限
        params[@"dynamicAuth"] = DynamicAuthPublic;
        
      } else {
        params[@"dynamicAuth"] = dynamicAuthType;
        params[@"userIds"] = userIds;
      }
    } else {
      params[@"dynamicAuth"] = dynamicAuthType;
    }
  } else {
    params[@"dynamicAuth"] = DynamicAuthPublic;
  }
  
  [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(complete,nil,responseObject);
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(complete,error.message,nil);
  }];
}

#pragma mark - -------------------数据处理类-------------------

#pragma mark - 检测资源是否全部上传完成
- (BOOL)checkMediaAllUpload {
  NSArray *mediaArr =[self getMediaArray];
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

#pragma mark - 重设数据源 处理add选项
- (void)resetMedioArr {
  if (self.mediaInfoArr.count > 9) {
    [self.mediaInfoArr removeLastObject];
  } else {
    // 只能有一个视频
    NSArray *videos = [self getVideoArray];
    if (videos.count == 0) { // 没有视频
      // 小于9个肯定要加上add
      BOOL hasAdd = NO;
      for (XKUploadMediaInfo *info in self.mediaInfoArr) {
        if (info.isAdd) {
          hasAdd = YES;
        }
      }
      if (hasAdd == NO) {
        XKUploadMediaInfo *add = [XKUploadMediaInfo new];
        add.isAdd = YES;
        [self.mediaInfoArr addObject:add];
      }
    } else {
      [self.mediaInfoArr removeAllObjects];
      [self.mediaInfoArr addObjectsFromArray:videos];
    }
  }
}

#pragma mark - 得到除去add的资源
- (NSArray *)getMediaArray {
  NSPredicate *pre = [NSPredicate predicateWithFormat:@"isAdd = NO"];
  return [self.mediaInfoArr filteredArrayUsingPredicate:pre];
}

#pragma mark - 得到视频
- (NSArray *)getVideoArray {
  // 只能有一个视频
  NSPredicate *pre = [NSPredicate predicateWithFormat:@"isVideo = YES && isAdd = NO"];
  return [self.mediaInfoArr filteredArrayUsingPredicate:pre];
}

#pragma mark - 得到图片
- (NSArray *)getPicArray {
  NSPredicate *pre = [NSPredicate predicateWithFormat:@"isVideo = NO && isAdd = NO"];
  return [self.mediaInfoArr filteredArrayUsingPredicate:pre];
}

- (NSArray *)getLimitUserIds {
  return @[];
}

@end

