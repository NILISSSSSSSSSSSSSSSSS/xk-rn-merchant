/*******************************************************************************
 # File        : XKSecreContactListViewModel.m
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

#import "XKSecreContactListViewModel.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKSecretContactCacheManager.h"

@implementation XKSecreContactListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete {
    [XKSecretContactCacheManager configCurrentSecretId:self.secretId];
    [XKSecretContactCacheManager updateContactsComplete:^(NSString *err, NSArray<XKContactModel *> *arr) {
        if (err) {
            EXECUTE_BLOCK(complete,err,nil);
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:arr];
            [self configDefaultSelect];
            [self buildData];
            EXECUTE_BLOCK(complete,nil,arr);
        }
    }];
}

- (void)createDefault {
    self.isSecret = YES;
    
}

#pragma mark - 公用方法
- (NSArray *)getSelectedArray {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"selected = YES && defaultSelectedAndDisabale = NO"];
    return [self.dataArray filteredArrayUsingPredicate:pred];
}

- (void)setDefaultSelected:(NSArray *)defaultSelected {
    _defaultSelected = defaultSelected;
}

- (void)configDefaultSelect {
    // 遍历 加上默认选中
    if (self.useType == XKContactUseTypeSingleSelect || self.useType == XKContactUseTypeManySelect) {
        [self.defaultSelected enumerateObjectsUsingBlock:^(XKContactModel * _Nonnull defaultObj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataArray enumerateObjectsUsingBlock:^(XKContactModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([defaultObj.userId isEqualToString:obj.userId]) {
                    obj.selected = YES;
                    if (self.defaultIsGray) {
                        obj.defaultSelectedAndDisabale = YES;
                    } else {
                        obj.defaultSelectedAndDisabale = NO;
                    }
                }
            }];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKContactListCell *cell = (XKContactListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.useType == XKContactUseTypeNormal || self.useType == XKContactUseTypeSingleSelectWithoutCheck) {
        cell.showChooseBtn = NO;
    } else {
        cell.showChooseBtn = YES;
    }

    cell.nameLabel.text = cell.model.secretRemark.length != 0 ?  cell.model.secretRemark : cell.model.nickname;
    [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-80);
    }];
    if (cell.model.isFriends) {
        cell.infoLabel.hidden = NO;
        cell.infoLabel.text = @"可友+密友";
    } else {
        cell.infoLabel.hidden = NO;
        cell.infoLabel.text = @"密友";
    }
    cell.headerImgView.userInteractionEnabled = NO;
  
    return cell;
}


#pragma mark - cell 点击事件 处理选择状态
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XKContactModel *model;
    if (!self.searchStatus) {
        model = self.sectionDataArray[indexPath.section][indexPath.row];
    } else {
        model = self.searchResultArray[indexPath.row];
    }
    if (self.useType == XKContactUseTypeNormal) {
        XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
        vc.userId = model.userId;
        vc.isSecret = YES;
        vc.secretId = self.secretId;
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.useType == XKContactUseTypeManySelect) { // 多选时
        if (model.defaultSelectedAndDisabale) {
            return;
        }
    } else if (self.useType == XKContactUseTypeSingleSelect) { // 单选
        // 清除其他所有的选择
        for (XKContactModel *model in self.dataArray) {
            model.selected = NO;
        }
    } else if (self.useType == XKContactUseTypeSingleSelectWithoutCheck) { // 单选不带钩
        // 清除其他所有的选择
        for (XKContactModel *model in self.dataArray) {
            model.selected = NO;
        }
    }
    model.selected = !model.selected;
    self.refreshBlock();
    if (self.useType == XKContactUseTypeSingleSelectWithoutCheck) {
        EXECUTE_BLOCK(self.sureClick);
    }
}


@end
