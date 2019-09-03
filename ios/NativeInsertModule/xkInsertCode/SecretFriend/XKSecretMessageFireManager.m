//
//  XKSecretMessageFireManager.m
//  XKSquare
//
//  Created by william on 2018/12/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretMessageFireManager.h"
#import <NIMSDK/NIMSDK.h>
#import "XKSecretFrientManager.h"
#import "XKSecretMessageFireOtherModel.h"
@implementation XKSecretMessageFireManager

+ (XKSecretMessageFireManager *)sharedManager{
    
    static XKSecretMessageFireManager *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

-(void)addMessageToMyselfFireMessageArr:(NSArray *)arr{
    if (!_myselfFireMessageArr) {
        _myselfFireMessageArr = [NSMutableArray array];
    }
    [_myselfFireMessageArr addObjectsFromArray:arr];
    [self.fireTimer fire];
}

-(void)addMessageToOtherFireMessageArr:(NSArray *)arr{
    if (!_otherFireMessageArr) {
        _otherFireMessageArr = [NSMutableArray array];
    }
    [_otherFireMessageArr addObjectsFromArray:arr];
    [self.fireTimer fire];
}

-(NSTimer *)fireTimer{
    if (!_fireTimer) {
        _fireTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_fireTimer forMode:NSRunLoopCommonModes];
    }
    return _fireTimer;
}

-(void)timerRun{
    NSLog(@"timer------------");
    NSMutableArray *deleteArr = [NSMutableArray array];
    if (self.myselfFireMessageArr.count > 0) {
        for (NIMMessage *message in self.myselfFireMessageArr) {
           NSTimeInterval second = [self compareTimeStampWithNow:message.timestamp];
            NSLog(@"剩余时间:%f",second)
            if (second > 60) {
                [deleteArr addObject:message];
//                [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
                [XKSecretFrientManager deleteSecretMessage:@[message] session:message.session complete:^(BOOL success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:XKIMBaseChatViewControllrtRefreshViewNotification object:nil];
                }];
            }
        }
    }
    
    if (self.otherFireMessageArr.count > 0) {
        for (XKSecretMessageFireOtherModel *model in self.otherFireMessageArr) {
            NSDate *date2 = [NSDate date];
            NSTimeInterval seconds = [date2 timeIntervalSinceDate:model.fireDate];
            NSLog(@"剩余时间:%f",seconds)
            if (seconds > 60) {
                [deleteArr addObject:model];
                //                [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
                [XKSecretFrientManager deleteSecretMessage:@[model.message] session:model.message.session complete:^(BOOL success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:XKIMBaseChatViewControllrtRefreshViewNotification object:nil];
                }];
            }
        }
    }
    
    [self.myselfFireMessageArr removeObjectsInArray:deleteArr];
    [self.otherFireMessageArr removeObjectsInArray:deleteArr];
    
    if ((self.myselfFireMessageArr.count <=0 || self.myselfFireMessageArr == nil) && (self.otherFireMessageArr.count <= 0 || self.otherFireMessageArr == nil)) {
        [_fireTimer invalidate];
        _fireTimer = nil;
        NSLog(@"timer_销毁");
    }
    
}

- (NSTimeInterval)compareTimeStampWithNow:(NSTimeInterval)time{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *date2 = [NSDate date];
    NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
    
    return seconds;
}
@end
