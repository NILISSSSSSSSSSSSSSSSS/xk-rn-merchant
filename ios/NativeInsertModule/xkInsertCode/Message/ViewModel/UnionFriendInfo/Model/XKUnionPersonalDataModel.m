//
//  XKUnionPersonalDataModel.m
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKUnionPersonalDataModel.h"

@interface XKUnionPersonalDataModel(){
    NSString *_birthdayDes;
    NSString *_sexDes;
}

@end
@implementation XKUnionPersonalDataModel
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
