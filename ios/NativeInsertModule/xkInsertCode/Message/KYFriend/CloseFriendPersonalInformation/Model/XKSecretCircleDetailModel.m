//
//  XKSecretCircleDetailModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretCircleDetailModel.h"
@interface XKSecretCircleDetailModel(){
    NSString *_birthdayDes;
    NSString *_sexDes;
}
@end

@implementation XKSecretCircleDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"secretId" : @"id"};
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
