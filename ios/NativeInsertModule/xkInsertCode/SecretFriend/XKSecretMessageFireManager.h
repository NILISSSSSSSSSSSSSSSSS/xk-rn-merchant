//
//  XKSecretMessageFireManager.h
//  XKSquare
//
//  Created by william on 2018/12/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSecretMessageFireManager : NSObject

@property(nonatomic, strong) NSMutableArray *myselfFireMessageArr; //销毁发出去的阅后即焚消息数组

@property(nonatomic, strong) NSMutableArray *otherFireMessageArr; //销毁收到的阅后即焚消息数组

@property(nonatomic ,strong) NSTimer *fireTimer;

+(XKSecretMessageFireManager *)sharedManager;

-(void)addMessageToMyselfFireMessageArr:(NSArray *)arr;

-(void)addMessageToOtherFireMessageArr:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
