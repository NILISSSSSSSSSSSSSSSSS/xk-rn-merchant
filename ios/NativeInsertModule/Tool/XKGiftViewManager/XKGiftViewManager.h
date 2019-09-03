//
//  XKGiftViewManager.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/13.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XKIMGiftModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGiftViewManager : NSObject

- (instancetype)initWithAnimationView:(UIView *)animationView;
// 显示IM送礼物
- (void)showIMGiftsViewWhitTargetUserId:(NSString *)targetUserId
                           succeedBlock:(nullable void(^)(void))succeedBlock
                            failedBlock:(nullable void(^)(void))failedBlock;
// 显示朋友圈送礼物
- (void)showFriendsCycleGiftsViewWhitTargetUserId:(NSString *)targetUserId
                                   friendsCycleId:(NSString *)friendsCycleId
                                     succeedBlock:(nullable void(^)(void))succeedBlock
                                      failedBlock:(nullable void(^)(void))failedBlock;
// 显示小视频送礼物
- (void)showLittleVideoGiftsViewWithTargetUserId:(NSString *)targetUserId
                                         videoId:(NSString *)videoId
                            redEnvelopeCellBlock:(nullable void(^)(void))redEnvelopeCellBlock
                                    succeedBlock:(nullable void(^)(void))succeedBlock
                                     failedBlock:(nullable void(^)(void))failedBlock;

- (void)showRedEnvelopeGiftsViewWithChooseBlock:(nullable void(^)(NSArray <XKIMGiftModel *>*))chooseBlock;

@end

NS_ASSUME_NONNULL_END
