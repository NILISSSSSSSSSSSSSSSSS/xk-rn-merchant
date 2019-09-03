/*******************************************************************************
 # File        : XKPersonalDataModel.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/19
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKPersonalDataModel.h"
@interface XKPersonalDataModel(){
    NSString *_birthdayDes;
    NSString *_sexDes;
}

@end
@implementation XKPersonalDataModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             @"referralCode" : @"securityCode",
             };
}

- (void)setBirthday:(NSString *)birthday {
    _birthday = birthday;
    _birthdayDes = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:birthday];
}

- (void)setSex:(NSString *)sex {
    _sex = sex;
    if ([sex isEqualToString:XKSexMale]) {
        _sexDes = @"男";
    }else if ([sex isEqualToString:XKSexFemale]){
        _sexDes = @"女";
    }else{
        _sexDes = @"保密";
    }
}
- (NSString *)birthdayDes {
    return _birthdayDes;
}

- (NSString *)sexDes {
    return _sexDes;
}
@end
