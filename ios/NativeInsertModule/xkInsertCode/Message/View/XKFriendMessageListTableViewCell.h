//
//  XKFriendMessageListTableViewCell.h
//  XKSquare
//
//  Created by william on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import "XKIM.h"

@class XKRNMerchantCustomerConsultationModel;

@interface XKFriendMessageListTableViewCell : UITableViewCell

/**
 如果是置顶消息 设置置顶样式
 */
-(void)setTopChat:(BOOL)isTop;

/**
 最新消息 用于展示最近聊天列表
 */
@property(nonatomic, strong) NIMRecentSession *recentSession;
@property (nonatomic,strong) UIImageView    *userAvatorImageView;
@property (nonatomic,strong) UILabel        *messageCountLabel;
@property (nonatomic,strong) UILabel        *userNameLabel;
@property (nonatomic,strong) UILabel        *lastMessageLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UIImageView    *remindImageView;
@property (nonatomic,strong) UIView         *bottomLineView;


/**
 消息体 用于展示历史消息
 */
@property(nonatomic, strong) NIMMessage       *message;


/**
 搜索关键字 用于历史消息标记
 */
@property(nonatomic, copy)  NSString          *searchKeyWord;

- (void)configCellWithIMType:(XKIMType)IMType recentSession:(NIMRecentSession *)recentSession;

- (void)configCellWithCustomerConsultationModel:(XKRNMerchantCustomerConsultationModel *)customerConsultationModel;

@end
