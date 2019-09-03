//
//  XKWelfareOpinionViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,XKReportType) {
    XKReportTypeOpinion = 0,
    XKReportTypeChangeGoods
};
@interface XKWelfareOpinionViewController : BaseViewController
//商品详情反馈需要用的
@property (nonatomic, copy) NSString  *goodsName;
@property (nonatomic, copy) NSString  *goodsId;
//福利订单退货用的
@property (nonatomic, copy) NSString  *orderId;
@property (nonatomic, assign) XKReportType  reportType;
@end
