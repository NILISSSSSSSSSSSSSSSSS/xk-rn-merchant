//
//  XKMallOrderDetailViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailViewModel.h"
@implementation XKOrderTransportInfoItem

@end
@implementation XKMallRefundLogListItem

@end
@implementation XKMallOrderDetailAmountInfoItem

@end
@implementation XKMallOrderDetailAddressItem

@end
@implementation XKMallOrderDetailGoodsItem

@end

@implementation XKMallRefundEvidenceItem

@end
@implementation XKMallInvoiceInfo

@end
@implementation XKMallOrderDetailViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsInfo"      : [XKMallOrderDetailGoodsItem class],
             @"refundLogList"  : [XKMallRefundLogListItem class],
             @"refundEvidence" : [XKMallRefundEvidenceItem class],
             @"logisticsInfos" : [XKOrderTransportInfoItem class]
             };
}

+ (void)requestMallOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderDetailUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKMallOrderDetailViewModel *model = [XKMallOrderDetailViewModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestMallAfterSaleOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderRefundDetailUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKMallOrderDetailViewModel *model = [XKMallOrderDetailViewModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}
@end
