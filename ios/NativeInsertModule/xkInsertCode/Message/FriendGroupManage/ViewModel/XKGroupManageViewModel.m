/*******************************************************************************
 # File        : XKGroupManageViewModel.m
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

#import "XKGroupManageViewModel.h"

@implementation XKGroupManageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    _dataArray = [NSMutableArray array];
}

#pragma mark - 创建
- (void)requestCreateGroupName:(NSString *)name complete:(void(^)(NSString *error,id data))complete {
    NSString *url = self.isSecret ? @"im/ua/secretGroupCreate/1.0" : @"im/ua/xkGroupCreate/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.isSecret) {
        params[@"secretId"] = self.secretId;
        params[@"groupName"] = name;
    } else {
        if (self.isTag) {
            params[@"groupType"] = @"label";
        } else {
            params[@"groupType"] = @"friend";
        }
        params[@"groupName"] = name;
    }
    
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.defaultGroupId = [responseObject xk_jsonToDic][@"id"];
        self.isSendNotification = YES;
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 修改分组名称
- (void)requestModifyGroupName:(NSString *)name groupId:(NSString *)groupId complete:(void (^)(NSString *, id))complete {
    
    NSString *url = self.isSecret ? @"im/ua/secretGroupNameUpdate/1.0" : @"im/ua/xkGroupNameUpdate/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.isSecret) {
        params[@"secretId"] = self.secretId;
        params[@"groupId"] = groupId;
    } else {
        if (self.isTag) {
            params[@"groupType"] = @"label";
        } else {
            params[@"groupType"] = @"friend";
        }
            params[@"groupId"] = groupId;
    }
    params[@"groupName"] = name;
    
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.isSendNotification = YES;
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 请求列表
- (void)requestListComplete:(void (^)(NSString *, id))complete {
    NSString *url = self.isSecret ? @"im/ua/secretGroupList/1.0" : @"im/ua/xkGroupList/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.isSecret) {
        params[@"secretId"] = self.secretId;
    } else {
        if (self.isTag) {
            params[@"groupType"] = @"label";
        } else {
            params[@"groupType"] = @"friend";
        }
    }

    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKFriendGroupModel class] json:responseObject];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        for (XKFriendGroupModel *model in self.dataArray) {
            if ([model.groupId isEqualToString:self.defaultGroupId]) {
                model.selected = YES;
            }
        }
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
    
}

#pragma mark - 删除分组
- (void)requestDeleteGroup:(NSString *)groupId complete:(void (^)(NSString *, id))complete {
    NSString *url = self.isSecret ? @"im/ua/secretGroupDelete/1.0" : @"im/ua/xkGroupDelete/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"groupId"] = groupId;

    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.isSendNotification = YES;
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 请求交换
- (void)requestExchangeComplete:(void (^)(NSString *, id))complete {
    NSString *url = self.isSecret ? @"im/ua/secretGroupSort/1.0" : @"im/ua/xkGroupSort/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableArray *ids = @[].mutableCopy;
    for (XKFriendGroupModel *model in self.dataArray) {
        [ids addObject:model.groupId];
    }
    params[@"ids"] = ids;
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSLog(@"分组排序成功");
        self.isSendNotification = YES;
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        NSLog(@"分组排序失败");
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

@end
