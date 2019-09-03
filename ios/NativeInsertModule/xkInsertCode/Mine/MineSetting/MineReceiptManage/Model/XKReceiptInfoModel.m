/*******************************************************************************
 # File        : XKReceiptInfoModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptInfoModel.h"

@interface XKReceiptInfoModel () {
    BOOL _isPersonal;
}

@end

@implementation XKReceiptInfoModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"receiptId":@"id"};
}

+ (instancetype)createForPerson {
    XKReceiptInfoModel *model = [XKReceiptInfoModel new];
    model.type = @"PERSONAL";
    return model;
}

+ (instancetype)createForCompany {
    XKReceiptInfoModel *model = [XKReceiptInfoModel new];
    model.type = @"ENTERPRISE";
    return model;
}

- (BOOL)isPersonal {
    if ([_type isEqualToString:@"PERSONAL"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setPersonal:(BOOL)personal {
    if (personal) {
        _type = @"PERSONAL";
    } else {
        _type = @"ENTERPRISE";
    }
}
@end

@implementation XKReceiptInfoDataConfig

+ (instancetype)configTitle:(NSString *)title hasStar:(BOOL)has placeHolder:(NSString *)placeHolder maxLength:(NSInteger)maxLengthNum minLength:(NSInteger)minLengthNum inputType:(XKReceiptInfoInputType)inputType {
    XKReceiptInfoDataConfig *config = [[XKReceiptInfoDataConfig alloc] init];
    config.title = title;
    config.hasStar = has;
    config.placeHolder = placeHolder;
    config.maxLengthNum = maxLengthNum;
    config.minLengthNum = minLengthNum;
    config.inputType = inputType;
    return config;
}

@end

