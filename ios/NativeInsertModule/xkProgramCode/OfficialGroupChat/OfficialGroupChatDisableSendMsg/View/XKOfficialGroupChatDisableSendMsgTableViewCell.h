//
//  XKOfficialGroupChatDisableSendMsgTableViewCell.h
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKOfficialGroupChatDisableSendMsgTableViewCell;

@protocol XKOfficialGroupChatDisableSendMsgTableViewCellDelegate <NSObject>

- (void)tableViewCell:(XKOfficialGroupChatDisableSendMsgTableViewCell *)cell selectedTime:(NSDictionary *)dict;

@end

@interface XKOfficialGroupChatDisableSendMsgTableViewCell : UITableViewCell

@property (nonatomic, assign) id<XKOfficialGroupChatDisableSendMsgTableViewCellDelegate> delegate;

- (void)configTableViewCellWithDictionary:(NSMutableDictionary *)dict;
- (void)configTableViewCellWithCustomTimeString:(NSString *)customTimeString;
- (void)showCellSeparator;
- (void)hiddenCellSeparator;
- (void)showCustomTimeLabel;
- (void)hiddenCustomTimeLabel;

@end

NS_ASSUME_NONNULL_END
