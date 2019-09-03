//
//  XKPayPasswordInputViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, XKPayPasswordInputViewControllerVerificationType) {
    
    XKPayPasswordInputViewControllerVerificationTypeFaceId = 0, /** 面部识别 */
    XKPayPasswordInputViewControllerVerificationTypeTouchId,    /** 指纹识别 */
    XKPayPasswordInputViewControllerVerificationTypePassword    /** 支付密码识别 */
};

typedef NS_ENUM(NSUInteger, XKPayPasswordInputViewControllerError) {
    
    XKPayPasswordInputViewControllerErrorNoPayPassword = 0,             /** 无支付密码，需跳转账号安全页（XKMineAccountManageViewController） */
    XKPayPasswordInputViewControllerErrorForgotPayPassword,             /** 忘记密码，需跳转手机验证页（XKVerifyPhoneNumberViewController） */
    XKPayPasswordInputViewControllerErrorForgotPayPasswordNoPhoneNumber /** 忘记密码且无预留手机号，需跳转手机绑定页（XKChangePhonenumViewController） */
};

@class XKPayPasswordInputViewController;

@protocol XKPayPasswordInputViewControllerDelegate <NSObject>

@optional

/**
 *  TouchID / FaceID / 支付密码校验
 *
 *  @param type 校验类型
 *
 *  @param isPass 校验结果
 *
 *  @param key 通过校验后 TouchID / FaceID 服务器校验码
 *
 *  @param password 通过校验后 用户输入支付密码
 *
 */
- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView
       verificationType:(XKPayPasswordInputViewControllerVerificationType)type
                 isPass:(BOOL)isPass
          severCheckKey:(NSString *)key
          inputPassword:(NSString *)password;

/**
 *  校验出错
 *
 *  @param error 错误类型
 *
 */
- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView
                  error:(XKPayPasswordInputViewControllerError)error;

@end

@interface XKPayPasswordInputViewController : UIViewController

@property (nonatomic, weak) id<XKPayPasswordInputViewControllerDelegate> delegate;

/** 展示用户支付验证视图 */
+ (XKPayPasswordInputViewController *)showPayPasswordInputViewController:(UIViewController *)viewController;

@end
