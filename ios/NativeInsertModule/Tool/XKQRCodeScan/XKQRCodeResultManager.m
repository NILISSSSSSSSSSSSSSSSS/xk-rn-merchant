//
//  XKQRCodeResultManager.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKQRCodeResultManager.h"
#import <NIMSDK/NIMSDK.h>
#import "XKP2PChatViewController.h"
#import "XKShopPayController.h"
#import "XKSecretDataSingleton.h"
#import "XKPersonDetailInfoViewController.h"
@implementation XKQRCodeResultManager

/**
 通过扫描回来的数据判断是什么类型的二维码
 
 @param resultString 扫描回来的数据
 @return 什么类型的二维码
 */
+ (XKQRCodeResultType)qrCodeResultTypeWithResult:(NSString *)resultString {
  if ([resultString containsString:@"xksl://business_card"]) {
    return XKQRCodeResultBusinessCardType;
  }
  else if ([resultString containsString:@"xksl://group_business_card"]){
    return XKQRCodeResultGroupBusinessCardType;
  }
//  else if ([resultString containsString:@"xkgc://commodity_detail"]){
//    return XKQRCodeResultCommodityDetailType;
//  }
//  else if ([resultString containsString:@"xkgc://store_detail"] || [resultString containsString:@"xksl://store_detail"]){
//    return XKQRCodeResultStoreDetailType;
//  }
//  else if ([resultString containsString:@"xksl://store_receipt"]){
//    return XKQRCodeResultStoreReceiptType;
//  }
//  else if ([resultString containsString:@"xksl://sales_xiaoke_currency"]){
//    return XKQRCodeResultSalesXiaokeCurrencyType;
//  }
//  else if ([resultString containsString:@"xksl://offline_receipt_order"]){
//    return XKQRCodeResultOfflineReceiptOrderType;
//  }
//  else if ([resultString containsString:@"xkgc://offline_consumption_order"]){
//    return XKQRCodeResultOfflineConsumptionOrderType;
//  }
  else{
    return XKQRCodeResultNoneType;
  }
}


/**
 根据二维码类型处理跳转
 
 @param resultString 扫描回来的数据
 */
+ (void)dealResult:(NSString *)resultString {
  
  XKQRCodeResultType resultType = [XKQRCodeResultManager qrCodeResultTypeWithResult:resultString];
  //个人二维码
  if (resultType == XKQRCodeResultBusinessCardType) {
    
    [XKQRCodeResultManager identityCardQrResult:resultString];
  }
  //群聊
  else if (resultType == XKQRCodeResultGroupBusinessCardType){
    
    [XKQRCodeResultManager groupBusinessCardResult:resultString];
  }
//  //各种商品二维码
//  else if (resultType == XKQRCodeResultCommodityDetailType){
//
//    [XKQRCodeResultManager commodityDetailQrResult:resultString];
//  }
//  //店铺的二维码
//  else if (resultType == XKQRCodeResultStoreDetailType){
//    [XKQRCodeResultManager storeDetailQrResult:resultString];
//  }
//  //店铺收款
//  else if (resultType == XKQRCodeResultStoreReceiptType){
//    [XKQRCodeResultManager storeReceiptQrResult:resultString];
//  }
//  //出售晓可币
//  else if (resultType == XKQRCodeResultSalesXiaokeCurrencyType){
//    [XKQRCodeResultManager salesXiaokeCurrencyQrResult:resultString];
//  }
//  //线下收款订单
//  else if (resultType == XKQRCodeResultOfflineReceiptOrderType){
//    [XKQRCodeResultManager offlineReceiptOrderQrResult:resultString];
//  }
//  //线下消费订单
//  else if (resultType == XKQRCodeResultOfflineConsumptionOrderType){
//    [XKQRCodeResultManager offlineConsumptionOrderQrResult:resultString];
//  }
  //未定义
  else{
    //TODO:未定义
    
  }
}


/**
 个人的二维码
 
 @param resultString 扫描回来的字符串
 */
+ (void)identityCardQrResult:(NSString *)resultString {
  NSMutableDictionary *dict = [XKQRCodeResultManager registerQrResult:resultString];
  NSString *userId = dict[@"userId"];
  XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
  vc.userId = userId;
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    vc.secretId = [XKSecretDataSingleton sharedManager].secretId;
    vc.isSecret = YES;
  }
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
/**
 群聊
 
 @param resultString 扫描回来的字符串
 */

+ (void)groupBusinessCardResult:(NSString *)resultString {

  NSString *url = @"";
  NSMutableDictionary *urlParams = [NSMutableDictionary dictionary];
  NSDictionary *resultStringDic = [resultString getURLParameters];
  NSString *groupId = resultStringDic[@"groupId"];
  NSLog(@"%@", groupId);
  if ([[NIMSDK sharedSDK].teamManager isMyTeam:groupId]) {
    NSLog(@"%@", groupId);
    NIMSession *session = [NIMSession session:groupId type:NIMSessionTypeTeam];
    XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  }else {
    urlParams[@"groupId"] = groupId;
    url = [[XKRouter sharedInstance] urlDynamicTargetClassName:@"XKGroupChatInviteViewController" Storyboard:nil Identifier:nil XibName:nil Params:urlParams];
  }
  [[XKRouter sharedInstance] runRemoteUrl:url ParentVC:[self getCurrentUIVC]];
}

/**
 注册时扫描二维码返回安全码
 
 @param resultString 扫描回来的数据
 @return 处理过后的字典
 */
+ (NSMutableDictionary *)registerQrResult:(NSString *)resultString {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  NSDictionary *ResultStringDic = [resultString getURLParameters];
  NSString *userId =  ResultStringDic[@"userId"];
  NSString *securityCode = ResultStringDic[@"securityCode"];
  
  params[@"userId"] = userId;
  params[@"securityCode"] = securityCode;
  
  return params;
}

@end
