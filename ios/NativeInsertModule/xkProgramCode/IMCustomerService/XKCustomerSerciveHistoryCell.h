//
//  XKCustomerSerciveHistoryCell.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@class XKRNMerchantCustomerConsultationModel;

@interface XKCustomerSerciveHistoryCell : UITableViewCell

-(void)setIndexPath:(NSIndexPath *)indexPath allRow:(NSInteger)allRow;


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


/**
 消息体 用于展示历史消息
 */
@property(nonatomic, strong) NIMMessage       *message;


/**
 搜索关键字 用于历史消息标记
 */
@property(nonatomic, copy)  NSString          *searchKeyWord;

/**显示异常原因*/
@property(nonatomic, strong) UILabel *reasonLabel;

- (void)configCellWithCustomerConsultationModel:(XKRNMerchantCustomerConsultationModel *)customerConsultationModel;

-(void)test;
@end
