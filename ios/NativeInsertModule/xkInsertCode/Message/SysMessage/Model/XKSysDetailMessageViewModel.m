//
//  XKSysDetailMessageViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSysDetailMessageViewModel.h"
#import "XKSysDetailMessageModel.h"

@interface XKSysDetailMessageViewModel()
/**请求页数*/
@property(nonatomic, assign) NSInteger page;

/**请求条数*/
@property(nonatomic, assign) NSInteger limit;

@end
@implementation XKSysDetailMessageViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.page = 0;
        self.limit = 10;
    }
    return self;
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid = @"";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)tableViewReoadData {
    if (self.loadBlock) {
        self.loadBlock();
    }
}

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void (^)(NSString *, NSArray *))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //抽奖
    if (self.type == XKPraiseSysMessageControllerType) {
        params[@"code"] = SysMessagepPraiseCode;
    }
    //系统
    else if (self.type == XKSysSysMessageControllerType){
        params[@"code"] = SysMessageCode;
    }
    //自营
    else if (self.type == XKShoppingSysMessageControllerType){
        params[@"code"] = SysMessageShoppingCode;
    }
    //福利
    else if (self.type == XKMallSysMessageControllerType){
        params[@"code"] = SysMessageMallCode;
    }
    //活动
    else if (self.type == XKActivitySysMessageControllerType){
        params[@"code"] = SysMessageActivityCode;
    }
    //专题
    else if (self.type == XKSpecialSysMessageControllerType){
        params[@"code"] = SysMessageSpecialCode;
    }
    //周边
    else if (self.type == XKAreaSysMessageControllerType){
        params[@"code"] = SysMessageAreaCode;
    }
    
    params[@"limit"] = @(self.limit);
    
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
    }
    
    [self requestWithParams:params block:^(NSString *error, id data) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        }else{
            NSArray *array = [NSArray array];
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            XKSysDetailMessageModel *model = [XKSysDetailMessageModel yy_modelWithJSON:data];
            array = model.data;
            
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
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/systemMsgList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}
@end
