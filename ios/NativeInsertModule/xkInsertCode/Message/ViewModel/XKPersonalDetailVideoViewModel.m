/*******************************************************************************
 # File        : XKPersonalDetailVideoViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/26
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKPersonalDetailVideoViewModel.h"
#import "XKVideoDisplayModel.h"
#import "XKPersonalDetailVideoTotalCell.h"

@implementation XKPersonalDetailVideoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    _dataArray = @[].mutableCopy;
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKPersonalDetailVideoTotalCell class] forCellReuseIdentifier:@"totalCell"];
}

- (void)requestComplete:(void (^)(id, id))complete {

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = self.userId;
    params[@"page"] = @(0);
    params[@"limit"] = @(5);
    [XKZBHTTPClient postRequestWithURLString:@"index/Square/a001/showVideo/1.0" timeoutInterval:20.0 parameters:params success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            XKVideoDisplayModel * model = [XKVideoDisplayModel yy_modelWithJSON:responseObject];
            self.dataArray = model.body.video_list.mutableCopy;
            EXECUTE_BLOCK(complete,nil,model);
        }
    } failure:^(XKHttpErrror * _Nonnull error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count == 0 ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKPersonalDetailVideoTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell" forIndexPath:indexPath];
    cell.dataArray = self.dataArray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    EXECUTE_BLOCK(self.scrollViewScroll,scrollView);
}

@end
