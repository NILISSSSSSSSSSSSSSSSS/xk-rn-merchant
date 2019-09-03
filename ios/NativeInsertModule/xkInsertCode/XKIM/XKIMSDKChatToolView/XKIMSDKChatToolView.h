//
//  XKIMSDKChatToolView.h
//  xkMerchant
//
//  Created by xudehuai on 2019/3/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XKIMSDKChatToolModel : NSObject

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithIDStr:(NSString *)idStr img:(NSString *)img title:(NSString *)title;

@end

typedef NS_ENUM(NSUInteger, XKIMSDKChatToolViewType) {
    XKIMSDKChatToolViewTypeP2P, // 单聊
    XKIMSDKChatToolViewTypeTeam, // 群聊
    XKIMSDKChatToolViewTypeCustomerSer, // 客服
};

static NSString *photo = @"photo";
static NSString *camera = @"camera";
static NSString *works = @"works";
static NSString *redEnvelope = @"redEnvelope";
static NSString *collection = @"collection";
static NSString *friendCard = @"friendCard";
static NSString *gift = @"gift";
static NSString *cardCoupon = @"cardCoupon";
static NSString *order = @"order";
static NSString *evaluate = @"evaluate";
static NSString *complain = @"complain";


NS_ASSUME_NONNULL_BEGIN

@interface XKIMSDKChatToolView : UIView

/**
 当前对话session
 */
@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, assign) XKIMSDKChatToolViewType toolType;

- (void)prepareWithTools:(NSArray <NSString *>*)tools;

@end

NS_ASSUME_NONNULL_END
