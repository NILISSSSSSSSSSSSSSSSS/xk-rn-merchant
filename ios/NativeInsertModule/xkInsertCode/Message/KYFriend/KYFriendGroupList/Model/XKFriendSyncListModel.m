//
//  XKFriendSyncListModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKFriendSyncListModel.h"

@implementation XKFriendSyncListDataItem

@end


@implementation XKFriendSyncListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[XKFriendSyncListDataItem class]};
}
@end
