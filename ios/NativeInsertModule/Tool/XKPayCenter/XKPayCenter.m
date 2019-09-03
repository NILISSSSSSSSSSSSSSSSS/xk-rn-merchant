//
//  XKPayCenter.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPayCenter.h"
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

@interface XKPayCenter ()<WXApiDelegate>

@end

@implementation XKPayCenter
/**获取全局PayCenter实例*/
static XKPayCenter *paycenter;
+ (instancetype)sharedPayCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        paycenter = [[XKPayCenter alloc] init];
    });
    return paycenter;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (paycenter == nil) {
            paycenter = [super allocWithZone:zone];
            NSLog(@"allocWithZone");
        }
    });
    return paycenter;
}

/**
 微信支付
 
 @param payPara 订单参数字典
 @param succeedBlock 微信支付成功回调事件
 @param failedBlock 微信支付失败回调事件
 */
- (void)WeChatPayWithPayPara:(NSDictionary *)payPara
                succeedBlock:(nullable WeChatPaySucceedBlock) succeedBlock
                 failedBlock:(nullable WeChatPayFailedBlock) failedBlock {
    self.WeChatPaySucceedBlock = succeedBlock;
    self.WeChatPayFailedBlock = failedBlock;
    if (![WXApi isWXAppInstalled]) {
        [XKHudView showErrorMessage:@"请安装微信客户端"];
        return;
    }
    
    if (payPara && payPara.allKeys.count) {
        PayReq *req = [[PayReq alloc] init];
   //     req.openID = @"wxa300ba94a08cc352";
        req.partnerId = payPara[@"partnerId"];
        req.prepayId = payPara[@"prepayId"];
        req.nonceStr = payPara[@"nonceStr"];
        req.timeStamp = [payPara[@"timestamp"] intValue];
        req.package = payPara[@"attach"];
        req.sign = payPara[@"sign"];
        [WXApi sendReq:req];
    } else {
        [XKHudView showErrorMessage:@"订单信息错误"];
    }
}

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
               succeedBlock:(WeChatPaySucceedBlock)succeedBlock
                failedBlock:(WeChatPayFailedBlock)failedBlock {
    self.WeChatPaySucceedBlock = succeedBlock;
    self.WeChatPayFailedBlock = failedBlock;
    if (![WXApi isWXAppInstalled]) {
        [XKHudView showErrorMessage:@"请安装微信客户端"];
        return;
    }
    PayReq *req = [[PayReq alloc] init];
    req.openID = openId;
    req.partnerId = partnerId;
    req.prepayId = prepayId;
    req.nonceStr = nonceStr;
    req.timeStamp = timeStamp;
    req.package = package;
    req.sign = sign;
    [WXApi sendReq:req];
}

/**
 支付宝支付
 
 @param orderString 订单字符串
 @param succeedBlock 支付宝支付成功回调
 @param failedBlock 支付宝支付回调事件
 */
- (void)AliPayWithOrderString:(NSString *)orderString
                 succeedBlock:(nullable AliPaySucceedBlock) succeedBlock
                  failedBlock:(nullable AliPayFailedBlock) failedBlock {
    self.AliPaySucceedBlock = succeedBlock;
    self.AliPayFailedBlock = failedBlock;
    if (orderString && orderString.length) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"com.xiaoke.GRoom.Rel" callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                if (self.AliPaySucceedBlock) {
                    self.AliPaySucceedBlock();
                }
            } else {
                if (self.AliPayFailedBlock) {
                    self.AliPayFailedBlock(resultDic[@"memo"]);
                }
            }
        }];
    } else {
        [XKHudView showErrorMessage:@"订单信息错误"];
    }
}

#pragma mark - 微信回调
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        if (resp.errCode == 0) {
            // 成功。
        } else{
            // 失败
            NSLog(@"error %@",resp.errStr);
        }
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        // 微信支付
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:{
                if (self.WeChatPaySucceedBlock) {
                    self.WeChatPaySucceedBlock();
                }
                break;
            }
            case WXErrCodeCommon: {
                if (self.WeChatPayFailedBlock) {
                    self.WeChatPayFailedBlock(@"支付出现错误,请重试");
                }
                break;
            }
            case WXErrCodeUserCancel: {
                if (self.WeChatPayFailedBlock) {
                    self.WeChatPayFailedBlock(@"您已取消支付");
                }
                break;
            }
            default: {
                if (self.WeChatPayFailedBlock) {
                    self.WeChatPayFailedBlock(@"支付失败,请重试");
                }
                break;
            }
        }
    }
}
@end
