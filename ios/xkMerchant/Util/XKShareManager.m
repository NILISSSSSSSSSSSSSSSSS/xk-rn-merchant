//
//  XKShareManager.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKShareManager.h"
#import "XKAlertUtil.h"
#import <UIImage+Reduce.h>
@interface XKShareManager()
//@property (nonatomic, strong) XKShareView * shareView;
//@property (nonatomic, assign) JSHAREPlatform selectPlatform;
@property (nonatomic, copy)  NSString *linkUrl;
@property (nonatomic, copy)  NSString *linkText;
@property (nonatomic, copy)  NSString *linkTitle;
@property (nonatomic, copy)  NSString *linkImageURL;

@end

static XKShareManager *_shareManager = nil;
@implementation XKShareManager

#pragma mark ShareManager单例

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [super allocWithZone:zone ];
    });
    return _shareManager;
}
+ (instancetype)shared{
    if (_shareManager == nil) {
        _shareManager = [[super alloc]init];
    }
    return _shareManager;
}

- (id)copyWithZone:(NSZone *)zone{
    return _shareManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _shareManager;
}

- (void)showSharePanelWithLinkUrl:(NSString *)url LinkText:(NSString *)text LinkTitle:(NSString *)title LinkImageURL:(NSString *)imageURL {
    self.linkText = text;
    self.linkUrl = url;
    self.linkTitle = title;
    self.linkImageURL = imageURL;
//    [self.shareView showWithContentType:JSHARELink];
}

//- (XKShareView *)shareView {
//    if (!_shareView) {
//        _shareView = [XKShareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
//            if (type == JSHARELink) {
//              [self shareLinkUrl:self.linkUrl LinkText:self.linkText LinkTitle:self.linkTitle LinkImageURL:self.linkImageURL WithPlatform:platform complete:^(NSString *err) {
//                //
//              }];
//            }
//        }];
//        [[UIApplication sharedApplication].delegate.window addSubview:self.shareView];
//    }
//    return _shareView;
//}

- (void)shareLinkUrl:(NSString *)url LinkText:(NSString *)text LinkTitle:(NSString *)title LinkImageURL:(NSString *)imageURL WithPlatform:(JSHAREPlatform)platform complete:(void(^)(NSString *err))complete {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
    message.url = url;
    message.text = [NSString stringWithFormat:@"%@", text];
    message.title = title;
    message.platform = platform;
  // 图片
  UIImage *orignalImg;
  orignalImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)imageURL]]];
  
  if (platform == JSHAREPlatformQQ) {
    // QQ
    message.thumbnail = [orignalImg imageCompressForSpecifyKB:1024.0];
    message.image = [orignalImg imageCompressForSpecifyKB:1024.0 * 5.0];
  } else {
    // 其他
    message.thumbnail = [orignalImg imageCompressForSpecifyKB:32.0];
    message.image = [orignalImg imageCompressForSpecifyKB:1024.0 * 10.0];
  }
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
      [self showAlertWithState:state error:error Platform:platform complete:complete];
    }];
}

- (void)showAlertWithState:(JSHAREState)state error:(NSError *)error Platform:(JSHAREPlatform)platform complete:(void(^)(NSString *err))complete {

    NSString *string = nil;
    if (error) {
        if (![JSHAREService isQQInstalled] && (platform == JSHAREPlatformQQ || platform == JSHAREPlatformQzone)){
          complete(@"没有安装QQ客户端");
//          [XKAlertUtil presentAlertViewWithTitle:nil message:@"没有安装QQ客户端"  confirmTitle:@"确定" handler:^{
//            //
//          }];
                return;
        }
        if (![JSHAREService isWeChatInstalled] && (platform == JSHAREPlatformWechatSession || platform == JSHAREPlatformWechatTimeLine || platform == JSHAREPlatformWechatFavourite )) {
          complete(@"没有安装微信客户端");
//          [XKAlertUtil presentAlertViewWithTitle:nil message:@"没有安装微信客户端"  confirmTitle:@"确定" handler:^{
//            //
//          }];
                return;
            }
        if (![JSHAREService isSinaWeiBoInstalled] && platform == JSHAREPlatformSinaWeibo) {
          complete(@"没有安装微博客户端");
//          [XKAlertUtil presentAlertViewWithTitle:nil message:@"没有安装微博客户端"  confirmTitle:@"确定" handler:^{
//            //
//          }];
                return;
            }
        string = [NSString stringWithFormat:@"分享失败,请重新分享"];
       complete(string);
    }else{
        switch (state) {
            case JSHAREStateSuccess:
                string = nil;
                break;
            case JSHAREStateFail:
                string = @"分享失败";
                break;
            case JSHAREStateCancel:
                string = @"分享取消";
                break;
            case JSHAREStateUnknown:
                string = @"Unknown";
                break;
            default:
                break;
        }
      complete(string);

    }
}

@end
