//
//  XKSendRedPacketViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@interface XKSendRedPacketViewController : BaseViewController
// IM单聊发红包
- (instancetype)initIMSendRedEnvelopWithUserId:(NSString *)userId succeedBlock:(void(^)(void))succeedBlock failedBlock:(void(^)(void))failedBlock;
// IM群聊发红包
- (instancetype)initIMSendRedEnvelopWithTeamId:(NSString *)teamId succeedBlock:(void(^)(void))succeedBlock failedBlock:(void(^)(void))failedBlock;

// 商户 IM单聊发红包
- (instancetype)initMerchantIMSendRedEnvelopWithUserId:(NSString *)userId succeedBlock:(void(^)(void))succeedBlock failedBlock:(void(^)(void))failedBlock;
// 商户 IM群聊发红包
- (instancetype)initMerchantIMSendRedEnvelopWithTeamId:(NSString *)teamId succeedBlock:(void(^)(void))succeedBlock failedBlock:(void(^)(void))failedBlock;

// 小视频发红包
- (instancetype)initLittleVideoSendRedEnvelopeWithVideoId:(NSString *)videoId succeedBlock:(void(^)(void))succeedBlock failedBlock:(void(^)(void))failedBlock;

@end
