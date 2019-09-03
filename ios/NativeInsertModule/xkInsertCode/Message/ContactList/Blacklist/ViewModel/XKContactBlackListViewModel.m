/*******************************************************************************
 # File        : XKContactListViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactBlackListViewModel.h"
#import "UIView+XKCornerRadius.h"
#import "XKContactListCell.h"
#import "UTPinYinHelper.h"
#import "XKContactModel.h"
#import "XKContactListViewModel.h"
#import "XKFriendshipManager.h"

@interface XKContactBlackListViewModel ()

@end


@implementation XKContactBlackListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {

}

- (void)removeBlackList:(NSIndexPath *)indexPath complete:(void (^)(NSString *, id))complete {
    XKContactModel *model = self.sectionDataArray[indexPath.section][indexPath.row];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = model.userId;
    [XKFriendshipManager requestRemoveBlackList: model.userId complete:^(NSString *error, id data) {
        if (error) {
            complete(error,nil);
        } else {
            // 本地处理数据撒
            [self.dataArray removeObject:model];
            [self buildData];
            complete(nil,data);
        }
    }];
}

#pragma mark - 网络请求
- (void)requestComplete:(void (^)(NSString *, NSArray *))complete {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/blackList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:dic];
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
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移除黑名单" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EXECUTE_BLOCK(self.remove,indexPath);
    }];
    return @[removeAction];
}


@end
