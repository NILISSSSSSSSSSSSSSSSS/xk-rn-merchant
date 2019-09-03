//
//  XKCustomerSerRootViewController.h
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <NIMKit.h>

typedef NS_ENUM(NSUInteger, XKCustomerSerRootVCType) {
  XKCustomerSerRootVCTypeUserContactCustomerService, // 客户联系客服
  XKCustomerSerRootVCTypeCustomerServiceContactUser, // 客服联系客户
  XKCustomerSerRootVCTypeCurrentConsultations, // 当前咨询
};

@interface XKCustomerSerRootViewController : BaseViewController
@property (nonatomic, strong)  NIMSession *session;

@property (nonatomic, copy) NSString    *shopID;

@property (nonatomic, copy) void(^finishCustomerServiceBlock)(void);

/**
 *  初始化方法
 *
 *  @param session 所属会话
 *
 *  @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session;


/**
 初始化方法

 @param session 所属会话
 @param IMType IM类型
 @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session vcType:(XKCustomerSerRootVCType)vcType;

/**
 隐藏聊天输入框
 */
-(void)hideInputView;
@end
