//
//  XKWelfateOrderListViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderListViewModel.h"
@implementation WelfareOrderDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end

@implementation XKWelfareOrderListViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [WelfareOrderDataItem class]
             };
}

+ (void)requestWelfareGoodsListWithOrderType:(WelfareListType)orderType param:(NSDictionary *)dic success:(void(^)(XKWelfareOrderListViewModel *model))success failed:(void(^)(NSString *failedReason))failed {
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    switch (orderType) {
        case WLT_WelfareListTypeAll:
        {
            [parmDic setObject:@"0" forKey:@"status"];
        }
            break;
        case WLT_WelfareListTypeWaitOpen:
        {
            [parmDic setObject:@"1" forKey:@"status"];
        }
            break;
        case WLT_WelfareListTypeWin:
        {
            [parmDic setObject:@"2" forKey:@"status"];
        }
            break;
        case WLT_WelfareListTypeFinish:
        {
           [parmDic setObject:@"3" forKey:@"status"];
        }
            break;
        default:
            break;
    }

    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderListUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareOrderListViewModel *model = [XKWelfareOrderListViewModel yy_modelWithJSON:responseObject];
        if(model) {
            if(model.data > 0) {
                for (WelfareOrderDataItem * item in model.data) {
                      item.currentIndex = WLP_WelfareListPositionOther;
                }
                if(model.data.count == 1) {
                    WelfareOrderDataItem *item = model.data.firstObject;
                    item.currentIndex = WLP_WelfareListPositionOnly;
                } else {
                    WelfareOrderDataItem *firstItem = model.data.firstObject;
                    firstItem.currentIndex = WLP_WelfareListPositionFirst;
                    
                    WelfareOrderDataItem *lastItem = model.data.lastObject;
                    lastItem.currentIndex = WLP_WelfareListPositionLast;
                }
            }
        }
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
