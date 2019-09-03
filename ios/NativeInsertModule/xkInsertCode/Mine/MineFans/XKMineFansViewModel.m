/*******************************************************************************
 # File        : XKMineFansViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/25
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineFansViewModel.h"
#import "XKContactModel.h"
#import "XKFriendshipManager.h"

@interface XKMineFansViewModel ()
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
/***/
@property(nonatomic, copy) NSString *timeStamp;

@end

@implementation XKMineFansViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefaultData];
    }
    return self;
}

- (void)createDefaultData {
    _page = 1;
    _limit = 20;
    _dataArray = [NSMutableArray array];
    
}

#pragma mark - 请求
- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
        self.timeStamp = [XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
        params[@"updatedAt"] = self.timeStamp;
    }
    [params setObject:@(_limit) forKey:@"limit"];
    
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    if (self.rid) {
        if (![self.rid isEqualToString:[XKUserInfo getCurrentUserId]]) { // 别人的才传
            params[@"rid"] = self.rid;
        }
    }
    
    [self requestWithParams:params block:^(NSString *error, NSString *data) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKContactModel class] json:[data xk_jsonToDic][@"data"]];
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if (array.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];
            EXECUTE_BLOCK(complete,nil,array);
        }
    }];
}

- (void)requestFocus:(NSIndexPath *)indexPath complete:(void (^)(NSString *, id))complete {
    XKContactModel *model = self.dataArray[indexPath.row];
    NSString *url;
    if (model.isFocusForFansList) { // 已经关注
        url = @"im/ua/unfollow/1.0";
        [XKFriendshipManager requestNoFocus:model.userId complete:^(NSString *error, id data) {
            if (error) {
                complete(error,nil);
            } else {
                [model setFocusForFansList:NO];
                complete(nil,@"");
            }
        }];
    } else {
        url = @"im/ua/follow/1.0";
        [XKFriendshipManager requestFocus:model.userId complete:^(NSString *error, id data) {
            if (error) {
                complete(error,nil);
            } else {
                [model setFocusForFansList:YES];
                complete(nil,@"");
            }
        }];
    }
}

- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/fansSyncList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}
@end
