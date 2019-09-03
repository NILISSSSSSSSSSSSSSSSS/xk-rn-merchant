//
//  XKQRCodeScanViewController.h
//  QRCodeScan
//
//  Created by hupan on 2018/7/24.
//  Copyright © 2018年 hupan. All rights reserved.
//

#import "BaseViewController.h"
#import "XKQRCodeResultManager.h"

typedef enum : NSUInteger {
    QRCodeScanVCType_QRScan,/** 二维码条形码扫描*/
    QRCodeScanVCType_Recharge,/** 晓可币充值*/
    QRCodeScanVCType_buyGoods,/** 商品购买*/
} QRCodeScanVCType;


typedef void(^QRCodeScanResult)(NSString * resultString);

@interface XKQRCodeScanViewController : BaseViewController
/**push跳转到界面后会自动移除掉自己  defualt：YES*/
@property (nonatomic, assign) BOOL   autoRemove;
@property (nonatomic, assign) QRCodeScanVCType   vcType;
@property (nonatomic, copy  ) QRCodeScanResult   scanResult;



@end
