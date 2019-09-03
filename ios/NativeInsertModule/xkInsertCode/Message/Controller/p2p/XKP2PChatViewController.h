//
//  XKP2PChatViewController.h
//  XKSquare
//
//  Created by william on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <NIMKit.h>
@interface XKP2PChatViewController : BaseViewController

@property (nonatomic, strong)  NIMSession *session;

@property (nonatomic, strong) NIMMessage  *searchMessage;

@property (nonatomic, assign) BOOL    isOfficialTeam;
@property (nonatomic, copy) NSString  *merchantType;
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
