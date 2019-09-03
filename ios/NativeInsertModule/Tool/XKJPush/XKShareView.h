//
//  XKShareView.h
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHAREService.h"
/**
 分享的回调
 
 @param platform 分享平台类型
 @param type 分享类型
 */
typedef void(^ShareBlock)(JSHAREPlatform platform, JSHAREMediaType type);

@interface XKShareView : UIView

/**
 通过block创建ShareView
 
 @param block 分享平台和分享类型的block
 @return ShareView
 */
+ (XKShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block;

/**
 通过指定的分享类型展示ShareView
 
 @param type 分享的类型
 */
- (void)showWithContentType:(JSHAREMediaType)type;


@end
