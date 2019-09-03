/*******************************************************************************
 # File        : XKGiftBaseModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGiftBaseModel.h"

@implementation XKGiftBaseModel {
    NSMutableArray *_arr;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"gift" : [XKGiftInfoModel class]};
}

- (void)setGift:(NSArray<XKGiftInfoModel *> *)gift {
    _gift = gift;
    NSMutableArray *arr = [NSMutableArray array];
    for (XKGiftInfoModel *model in gift) {
        NSString *str;
        if ([model.number isEqualToString:@"1"]) {
            str = model.name;
        } else {
            str = [NSString stringWithFormat:@"%@x%@",model.name,model.number];
        }
        [arr addObject:str];
    }
    _arr = arr.copy;
}

- (NSArray *)getGiftArr {
    return _arr;
}

@end

@implementation XKGiftInfoModel

@end
