/*******************************************************************************
 # File        : XKVisiblelAuthorityInfo.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKVisiblelAuthorityInfo.h"

@interface XKVisiblelAuthorityResult()
/**<##>*/
@property(nonatomic, strong) XKVisiblelAuthorityInfo *currentInfo;
@end

@implementation XKVisiblelAuthorityResult {
    
}

- (BOOL)containNetData {
    // 取分组数据为空则为没请求过 
    return self.dataArray[2].itemsArray.count == 0 ? NO : YES;
}

/**获取权限类型*/
- (NSString *)getDynamicAuthType {
    return self.currentInfo.dynamicAuthType;
}

/**获取用户组*/
- (NSArray <NSString *>*)getDynamicUserIds {
    if ([self.currentInfo.dynamicAuthType isEqualToString:DynamicAuthPublic] || [self.currentInfo.dynamicAuthType isEqualToString:DynamicAuthMe] ) {
        return nil;
    }
    NSMutableSet *ids = [NSMutableSet set];
    for (XKContactModel *user in self.currentInfo.itemFromAddress.userArray) {
        [ids addObject:user.userId];
    }
    for (XKVisiblelAuthorityItem *item in self.currentInfo.itemsArray) {
        if (item.selected) {
            for (XKContactModel *user in item.group.list) {
                [ids addObject:user.userId];
            }
        }
    }
    return [ids allObjects];
}
/**获取显示文本*/
- (NSString *)getDynamicDisplayInfo {
    if ([self.currentInfo.dynamicAuthType isEqualToString:DynamicAuthPublic] || [self.currentInfo.dynamicAuthType isEqualToString:DynamicAuthMe]    ) {
        return self.currentInfo.title;
    }
    
    NSMutableArray *nameArray = @[].mutableCopy;
    for (XKVisiblelAuthorityItem *item in self.currentInfo.itemsArray) {
        if (item.selected) {
            [nameArray addObject:item.groupName];
        }
    }
    for (XKContactModel *user in self.currentInfo.itemFromAddress.userArray) {
        [nameArray addObject:user.displayName];
    }
    NSString *namesStr = [nameArray componentsJoinedByString:@"，"];
    if ([self.currentInfo.dynamicAuthType isEqualToString:DynamicAuthUnSee]) {
         return [@"除去  " stringByAppendingString:namesStr];
    }
    return namesStr;
}

- (XKVisiblelAuthorityInfo *)currentInfo {
    if (!_currentInfo) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"selected = YES"];
        _currentInfo = [self.dataArray filteredArrayUsingPredicate:pred].firstObject;
    }
    return _currentInfo;
}

- (NSInteger)currentInfoIndex {
    return [self.dataArray indexOfObject:self.currentInfo];
}

@end

@implementation XKVisiblelAuthorityInfo

@end

@implementation XKVisiblelAuthorityItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userArray = [NSMutableArray array];
        _hasInfo = YES;
    }
    return self;
}

- (BOOL)showInfoBtn {
    return self.hasInfo;
}

- (NSString *)groupName {
    if (_groupName) {
        return _groupName;
    }
    return self.group.groupName;
}

- (NSString *)groupInfo {
    if (_groupInfo != nil) {
        return _groupInfo;
    }
    NSMutableArray *arr = @[].mutableCopy;
    for (XKContactModel *user in self.userArray) {
        [arr addObject:user.displayName];
    }
    if (arr.count == 0) {
        return nil;
    }
    return [arr componentsJoinedByString:@"、"];
}

@end

