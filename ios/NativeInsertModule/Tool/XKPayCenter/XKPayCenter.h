//
//  XKPayCenter.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

typedef void(^AliPaySucceedBlock)(void);
typedef void(^AliPayFailedBlock)(NSString *reason);
typedef void(^WeChatPaySucceedBlock)(void);
typedef void(^WeChatPayFailedBlock)(NSString *reason);

@interface XKPayCenter : NSObject <WXApiDelegate>

@property (nonatomic, copy) AliPaySucceedBlock AliPaySucceedBlock;

@property (nonatomic, copy) AliPayFailedBlock AliPayFailedBlock;

@property (nonatomic, copy) WeChatPaySucceedBlock WeChatPaySucceedBlock;

@property (nonatomic, copy) WeChatPayFailedBlock WeChatPayFailedBlock;


+ (instancetype)sharedPayCenter;

/**
 微信支付

 @param payPara 订单参数字典
 @param succeedBlock 微信支付成功回调事件
 @param failedBlock 微信支付失败回调事件
 */
- (void)WeChatPayWithPayPara:(NSDictionary *)payPara
                succeedBlock:(nullable WeChatPaySucceedBlock) succeedBlock
                 failedBlock:(nullable WeChatPayFailedBlock) failedBlock;

/**
 微信支付

 @param openId 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录
 @param partnerId 商家向财付通申请的商家id
 @param prepayId 预支付订单
 @param nonceStr 随机串，防重发
 @param timeStamp 时间戳，防重发
 @param package 商家根据财付通文档填写的数据和签名
 @param sign 商家根据微信开放平台文档对数据做的签名
 @param succeedBlock 微信支付成功回调事件
 @param failedBlock 微信支付失败回调事件
 */
- (void)WeChatPayWithOpenId:(NSString *)openId
                  partnerId:(NSString *)partnerId
                   prepayId:(NSString *)prepayId
                   nonceStr:(NSString *)nonceStr
                  timeStamp:(NSInteger)timeStamp
                    package:(NSString *)package
                       sign:(NSString *)sign
                succeedBlock:(nullable WeChatPaySucceedBlock) succeedBlock
                 failedBlock:(nullable WeChatPayFailedBlock) failedBlock;

/**
 支付宝支付

 @param orderString 订单字符串
 @param succeedBlock 支付宝支付成功回调
 @param failedBlock 支付宝支付回调事件
 */
- (void)AliPayWithOrderString:(NSString *)orderString
                 succeedBlock:(nullable AliPaySucceedBlock) succeedBlock
                  failedBlock:(nullable AliPayFailedBlock) failedBlock;

@end
