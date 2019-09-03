/*******************************************************************************
 # File        : XKFriendGroupModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendGroupModel.h"

@implementation XKFriendGroupModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupId" : @[@"id",@"groupId"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XKContactModel class]};
}

- (XKGroupType)groupTypeEnum {
    ///**friend / secret / label */
    if ([self.groupType isEqualToString:@"friend"]) {
        return XKGroupFriendType;
    }
    if ([self.groupType isEqualToString:@"secret"]) {
        return XKGroupSecretType;
    }
    if ([self.groupType isEqualToString:@"label"]) {
        return XKGroupLabelType;
    }
    return XKGroupFriendType;
}

@end
