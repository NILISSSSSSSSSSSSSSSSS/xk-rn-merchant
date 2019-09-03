//
//  XKHUD.h
//  XKSquare
//
//  Created by william on 2018/7/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@interface XKHUD : NSObject
/**
 *  显示纯文本 加一个转圈
 *
 *  @param aText 要显示的文本
 */
+ (void)showLoadingText:(NSString *)aText;


/**
 显示成功

 @param aText 成功文本
 */
+ (void)showSuccessWithText:(NSString *)aText;

/**
 显示错误信息
 
 @param aText 错误提示文本
 */
+ (void)showErrorWithText:(NSString *)aText;

/**
 HUD消失
 */
+ (void)dismiss;
@end
