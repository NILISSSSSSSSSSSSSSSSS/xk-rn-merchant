/*******************************************************************************
 # File        : XKGroupDetailViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupDetailViewModel.h"

@implementation XKGroupDetailViewModel

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"groupId"] = self.tagId;
    
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/labelOrXkGroupDetail/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        XKFriendGroupModel *model = [XKFriendGroupModel yy_modelWithJSON:dic];
        self.model = model;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:model.list];
        [self buildData];
        complete(nil,self.dataArray);
        EXECUTE_BLOCK(complete,nil,self.dataArray);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    __weak typeof(self) weakSelf = self;
    XKContactListCell *cell = (XKContactListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *arr = self.sectionDataArray[indexPath.section];
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        cell.hideSeperate = NO;
        if (arr.count == 1) {
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        }
    } else if (indexPath.row != arr.count - 1) { // 不是最后一个
        cell.xk_clipType = XKCornerClipTypeNone;
    } else { // 最后一个
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchStatus) {
        return [UIView new];
    }
    UILabel *label = [UILabel new];
    label.font = XKSemiboldFont(16);
    label.text = [NSString stringWithFormat:@"   %@",self.indexArray[section]];
    [label showBorderSite:rzBorderSitePlaceBottom];
    label.bottomBorder.borderLine.backgroundColor = RGBGRAY(235);
    
    return label;
}


@end
