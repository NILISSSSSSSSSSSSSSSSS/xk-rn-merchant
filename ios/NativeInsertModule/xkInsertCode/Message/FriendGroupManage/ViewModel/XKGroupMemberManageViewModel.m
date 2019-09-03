/*******************************************************************************
 # File        : XKGroupMemberManageViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupMemberManageViewModel.h"
#import "XKFriendshipManager.h"

@implementation XKGroupMemberManageViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    
}

- (void)removeList:(NSIndexPath *)indexPath complete:(void (^)(NSString *, id))complete {
    XKContactModel *model = self.sectionDataArray[indexPath.section][indexPath.row];
    // 本地处理数据撒
    [self.dataArray removeObject:model];
    [self buildData];
    complete(nil,@"");
}

#pragma mark - 添加成员
- (void)addMembers:(NSArray *)array complete:(void (^)(NSString *, id))complete {
    // 本地处理数据撒
    [self.dataArray addObjectsFromArray:array];
    [self buildData];
    complete(nil,@"");
}

#pragma mark - 网络请求
- (void)requestComplete:(void (^)(NSString *, NSArray *))complete {
    NSString *url = self.isSecret ? @"im/ua/secretFriendGroupList/1.0" : @"im/ua/labelOrXkGroupDetail/1.0";
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.isSecret) {
        params[@"meSecretId"] = self.secretId;
    }
    params[@"groupId"] = self.groupId;
    params[@"page"] = @(1);
    params[@"limit"] = @(0);
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    NSLog(@"%@",params);
    [HTTPClient getEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSArray *arr;
        NSDictionary *dic = [responseObject xk_jsonToDic];
        if (self.isSecret) {
            arr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:dic[@"data"]];
        } else {
            arr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:dic[@"list"]];
        }

        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arr];
        [self buildData];
        complete(nil,self.dataArray);
    } failure:^(XKHttpErrror *error) {
        complete(error.message,nil);
    }];
}

#pragma mark - 侧滑
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EXECUTE_BLOCK(self.remove,indexPath);
    }];
    return @[removeAction];
}
@end
