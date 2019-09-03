//
//  XKLittleVideoGiftNotificationModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLittleVideoGiftNotificationModel : NSObject

// 礼物赠送记录的ID
@property (nonatomic, copy) NSString *idStr;
// 礼物的ID
@property (nonatomic, copy) NSString *giftId;
// 礼物的类型
@property (nonatomic, assign) NSUInteger giftType;
// 礼物的名字
@property (nonatomic, copy) NSString *giftName;
// 礼物的图片
@property (nonatomic, copy) NSString *giftImg;
// 礼物的数量
@property (nonatomic, assign) NSUInteger giftNum;
// 礼物对应的小视频ID
@property (nonatomic, copy) NSString *videoId;
// 礼物发送者ID
@property (nonatomic, copy) NSString *senderId;
// 礼物发送者名字
@property (nonatomic, copy) NSString *senderName;
// 礼物发送者头像
@property (nonatomic, copy) NSString *senderAvatar;

@end

NS_ASSUME_NONNULL_END
