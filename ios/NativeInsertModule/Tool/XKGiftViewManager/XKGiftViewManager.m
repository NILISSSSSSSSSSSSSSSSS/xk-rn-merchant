//
//  XKGiftViewManager.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/13.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGiftViewManager.h"
#import "XKIMGiftModel.h"
#import "XKCommonSheetView.h"
#import "XKChatGiveGiftView.h"
#import "XKIMGlobalMethod.h"

typedef NS_OPTIONS(NSUInteger, XKGiftViewType) {
    XKGiftViewTypeIM = 1 << 0, // IM
    XKGiftViewTypeFriendsCycle = 1 << 1, // 朋友圈
    XKGiftViewTypeLittleVideo = 1 << 2, // 小视频
    XKGiftViewTypeRedEnvelope = 1 << 3, // 红包
};

@interface XKGiftViewManager ()

@property (nonatomic, assign) XKGiftViewType type;

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, copy) NSString *targetUserId;

@property (nonatomic, copy) NSString *sceneId;

@property (nonatomic, copy) NSString *timesId;

@property (nonatomic, copy) NSString *giftScene;


@property (nonatomic, copy) void(^redEnvelopeCellBlock)(void);

@property (nonatomic, copy) void(^succeedBlock)(void);

@property (nonatomic, copy) void(^failedBlock)(void);

@property (nonatomic, copy) void(^chooseBlock)(NSArray <XKIMGiftModel *>*);

@end

@implementation XKGiftViewManager

- (instancetype)initWithAnimationView:(UIView *)animationView {
    self = [super init];
    if (self) {
        _animationView = animationView;
    }
    return self;
}

- (void)showIMGiftsViewWhitTargetUserId:(NSString *)targetUserId
                           succeedBlock:(nullable void(^)(void))succeedBlock
                            failedBlock:(nullable void(^)(void))failedBlock {
    _type = XKGiftViewTypeIM;
    _targetUserId = targetUserId;
    
    _succeedBlock = succeedBlock;
    _failedBlock = failedBlock;
    
    [self postGifts];
}

- (void)showFriendsCycleGiftsViewWhitTargetUserId:(NSString *)targetUserId
                                   friendsCycleId:(NSString *)friendsCycleId
                                     succeedBlock:(void (^)(void))succeedBlock
                                      failedBlock:(void (^)(void))failedBlock {
    _type = XKGiftViewTypeFriendsCycle;
    _targetUserId = targetUserId;
    _sceneId = friendsCycleId;
    
    _succeedBlock = succeedBlock;
    _failedBlock = failedBlock;
    
    [self postGifts];
}

- (void)showLittleVideoGiftsViewWithTargetUserId:(NSString *)targetUserId
                                         videoId:(NSString *)videoId
                            redEnvelopeCellBlock:(nullable void(^)(void))redEnvelopeCellBlock
                                    succeedBlock:(nullable void(^)(void))succeedBlock
                                     failedBlock:(nullable void(^)(void))failedBlock {
    _type = XKGiftViewTypeLittleVideo;
    _targetUserId = targetUserId;
    _sceneId = videoId;
    
    _redEnvelopeCellBlock = redEnvelopeCellBlock;
    _succeedBlock = succeedBlock;
    _failedBlock = failedBlock;
    
    [self postGifts];
}

- (void)showRedEnvelopeGiftsViewWithChooseBlock:(void (^)(NSArray<XKIMGiftModel *> * _Nonnull))chooseBlock {
    
    _type = XKGiftViewTypeRedEnvelope;

    _chooseBlock = chooseBlock;

}

- (void)postGifts {
    [[self getCurrentUIVC].childViewControllers.firstObject touchesBegan:[NSSet set] withEvent:nil];
    [XKHudView showLoadingTo:self.animationView animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(100) forKey:@"limit"];
    // 请求礼物列表接口
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig chatGiftListUrl] timeoutInterval:5.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.animationView animated:YES];
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSArray <XKIMGiftModel *>*array = [NSArray yy_modelArrayWithClass:[XKIMGiftModel class] json:dict[@"data"]];
            if (array.count) {
                // 显示礼物选择视图
                XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                sheetView.backgroundColor = [UIColor clearColor];
                
                XKChatGiveGiftViewType tempType = -1;
                if (self.type == XKGiftViewTypeIM) {
                    tempType = XKChatGiveGiftViewTypeIM;
                } else if (self.type == XKGiftViewTypeFriendsCycle) {
                    tempType = XKChatGiveGiftViewTypeIM;
                } else if (self.type == XKGiftViewTypeLittleVideo) {
                    tempType = XKChatGiveGiftViewTypeLittleVideo;
                } else if (self.type == XKGiftViewTypeRedEnvelope) {
                    tempType = XKChatGiveGiftViewTypeRedEnvelope;
                }
                
                XKChatGiveGiftView *giftView = [[XKChatGiveGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300.0 * ScreenScale + kBottomSafeHeight) gifts:array type:tempType];
                giftView.handselBtnBlock = ^(XKIMGiftModel *gift, NSInteger num) {
                    [sheetView dismiss];
                    
                    [XKHudView showLoadingTo:self.animationView animated:YES];
                    
                    NSMutableDictionary *userPara = [NSMutableDictionary dictionary];
                    [userPara setObject:self.targetUserId forKey:@"userId"];
                    NSMutableDictionary *giftPara = [NSMutableDictionary dictionary];
                    if (self.sceneId && self.sceneId.length) {
                        [giftPara setObject:self.sceneId forKey:@"sceneId"];
                    }
                    if (self.type == XKGiftViewTypeIM) {
                        // IM
                        [giftPara setObject:@"im_single" forKey:@"giftScene"];
                    } else if (self.type == XKGiftViewTypeFriendsCycle) {
                        // 朋友圈
                        [giftPara setObject:@"friends_cycle" forKey:@"giftScene"];
                    } else if (self.type == XKGiftViewTypeLittleVideo) {
                        // 小视频
                        [giftPara setObject:@"video" forKey:@"giftScene"];
                    } else if (self.type == XKGiftViewTypeRedEnvelope) {
                        // 红包
                        if (self.chooseBlock) {
                            self.chooseBlock(@[gift]);
                        }
                        return ;
                    }
                    [giftPara setObject:gift.giftId forKey:@"giftId"];
                    [giftPara setObject:@(num) forKey:@"num"];
                    NSMutableDictionary *para = [NSMutableDictionary dictionary];
                    [para setObject:userPara forKey:@"receivingUser"];
                    [para setObject:giftPara forKey:@"giftPackage"];
                    
                    // 请求送礼物接口
                    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig sendGiftUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
                        [XKHudView hideHUDForView:self.animationView animated:YES];
                        if (self.type == XKGiftViewTypeIM) {
                            // IM
                            XKIMMessageGiftAttachment *attachment = [[XKIMMessageGiftAttachment alloc] init];
                            attachment.giftId = gift.giftId;
                            attachment.giftName = gift.name;
                            attachment.giftIconUrl = gift.smallPicture;
                            attachment.giftNumber = num;

                            [XKIMGlobalMethod sendGift:attachment session:[NIMSession session:self.targetUserId type:NIMSessionTypeP2P]];
                        } else if (self.type == XKGiftViewTypeFriendsCycle) {
                            // 朋友圈
                            
                        } else if (self.type == XKGiftViewTypeLittleVideo) {
                            // 小视频
                            
                        } else if (self.type == XKGiftViewTypeRedEnvelope) {
                            // 红包
                            
                        }
                        if (self.succeedBlock) {
                            self.succeedBlock();
                        }
                        
                    } failure:^(XKHttpErrror *error) {
                        [XKHudView hideHUDForView:self.animationView animated:YES];
                        [XKHudView showErrorMessage:error.message];
                        if (self.failedBlock) {
                            self.failedBlock();
                        }
                    }];
                };
                sheetView.contentView = giftView;
                [sheetView addSubview:giftView];
                [sheetView showWithNoShield];
            }
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.animationView animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}

@end
