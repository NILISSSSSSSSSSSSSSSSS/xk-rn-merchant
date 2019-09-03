//
//  XKSecretChatViewController.h
//  XKSquare
//
//  Created by william on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <NIMKit.h>

@interface XKSecretChatViewController : BaseViewController
@property (nonatomic, strong)  NIMSession *session;

@property (nonatomic, strong) NIMMessage  *searchMessage;

@property (nonatomic, copy)     NSString *secretID;
/**
 *  初始化方法
 *
 *  @param session 所属会话
 *
 *  @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session;

/**
 刷新昵称标题旁的耳朵图片状态
 */
- (void)refreshEarImgViewStatus;

@end

