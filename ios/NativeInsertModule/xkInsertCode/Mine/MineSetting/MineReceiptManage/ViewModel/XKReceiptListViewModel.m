/*******************************************************************************
 # File        : XKReceiptListViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptListViewModel.h"

@interface XKReceiptListViewModel ()
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
/**当前时间戳 请求使用*/
@property(nonatomic, copy) NSString *timeStamp;

@end

@implementation XKReceiptListViewModel

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

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void(^)(NSString *error,NSArray *array))complete {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
        self.timeStamp = [XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
        params[@"lastUpdatedAt"] = self.timeStamp;
    }
    [params setObject:@(_limit) forKey:@"limit"];
    
   
    [self requestWithParams:params block:^(NSString *error, NSString *data) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKReceiptInfoModel class] json:[data xk_jsonToDic][@"data"]];
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

- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserInvoiceQPage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}


@end
