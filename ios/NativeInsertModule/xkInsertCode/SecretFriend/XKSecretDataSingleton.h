//
//  XKSecretDataSingleton.h
//  XKSquare
//
//  Created by william on 2018/11/13.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKSecretCircleDetailModel.h"
typedef NS_ENUM(NSInteger ,XKCurrentIMChatModel) {
  XKCurrentIMChatModelNormal = 0, // 可友
  XKCurrentIMChatModelSecret, // 密友
};

@interface XKSecretDataSingleton : NSObject

@property(nonatomic, assign) XKCurrentIMChatModel currentIMChatModel;
@property(nonatomic, copy) NSString *secretId;
@property(nonatomic, strong)XKSecretCircleDetailModel *currentMySecretInfo;
+(XKSecretDataSingleton *)sharedManager;

@end

