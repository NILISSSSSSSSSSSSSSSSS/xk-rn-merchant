//
//  XKIMGiftModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMGiftModel : NSObject
// 是否连送
@property (nonatomic, assign) NSInteger allowContinuity;
// 是否允许选择数量
@property (nonatomic, assign) NSInteger allowSelectNumber;
// 礼物大图
@property (nonatomic, copy) NSString *bigPicture;
// 礼物小图
@property (nonatomic, copy) NSString *smallPicture;
// 送出确认
@property (nonatomic, assign) NSInteger confirm;
// 连送时间 秒
@property (nonatomic, assign) NSInteger continuityTime;
//
@property (nonatomic, assign) NSInteger createdAt;
//
@property (nonatomic, assign) NSInteger updatedAt;
// 礼物ID
@property (nonatomic, copy) NSString *giftId;
// 序号
@property (nonatomic, assign) NSInteger index;
// 礼物名
@property (nonatomic, copy) NSString *name;
// 礼物价格
@property (nonatomic, assign) NSInteger price;
// 礼物状态
@property (nonatomic, copy) NSString *status;
//

@end

NS_ASSUME_NONNULL_END
