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

#import "XKContactListViewModel.h"
#import "XKContactCacheManager.h"
#import "XKPersonDetailInfoViewController.h"

@interface XKContactListViewModel ()

@end


@implementation XKContactListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)setOutDataArray:(NSArray<XKContactModel *> *)outDataArray {
    _outDataArray = [outDataArray copy];
    // 保持数据清洁
    [_outDataArray enumerateObjectsUsingBlock:^(XKContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.defaultSelectedAndDisabale = NO;
    }];
}

- (void)requestComplete:(void (^)(NSString *, NSArray *))complete {
    if (self.useType == XKContactUseTypeUseOutDateAndManySelected) {
        [self.dataArray addObjectsFromArray:self.outDataArray];
        [self buildData];
        complete(nil,self.dataArray);
    } else {
        [XKContactCacheManager updateContactsComplete:^(NSString *err, NSArray<XKContactModel *> *arr) {
            if (err) {
                complete(err,nil);
                return;
            }
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:arr];
            [self configDefaultSelect];
            [self buildData];
            complete(nil,self.dataArray);
        }];
    }
}

- (void)createDefault {


}

#pragma mark - 公用方法

#pragma mark - 头像点击
- (void)headClick:(NSIndexPath *)indexPath model:(XKContactModel *)model {
    if (self.secretId) { // 为添加密友时
        /*未添加为密友用户，点击用户头像，可查看到可友的个人主页，但是此时不能发消息，必须加密友才能发消息。
        已添加为密友用户，点击用户头像，进入密友用户主页*/
        XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
        vc.isSecret = YES;
        vc.secretId = self.secretId;
        vc.userId = model.userId;
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    } else {
        XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
        vc.userId = model.userId;
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    }
}

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
        [self.defaultSelected enumerateObjectsUsingBlock:^(XKContactModel * _Nonnull defaultObj, NSUInteger defaultIdx, BOOL * _Nonnull stop) {
            [self.dataArray enumerateObjectsUsingBlock:^(XKContactModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([defaultObj.userId isEqualToString:obj.userId]) {
                    obj.selected = YES;
                    if (self.defaultIsGray) {
                        obj.defaultSelectedAndDisabale = YES;
                    }
                }
            }];
        }];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    XKContactListCell *cell = (XKContactListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.useType == XKContactUseTypeNormal || self.useType == XKContactUseTypeNormalForAddSecret || self.useType == XKContactUseTypeSingleSelectWithoutCheck) {
        cell.showChooseBtn = NO;
    } else {
        cell.showChooseBtn = YES;
    }
    if (self.useType == XKContactUseTypeNormalForAddSecret) { //
        [cell setOperationClick:^(NSIndexPath *indexPath, XKContactModel *model) {
            EXECUTE_BLOCK(weakSelf.operationBlock,indexPath, model);
        }];
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-80);
        }];
        if (cell.model.isSecertFriend && [cell.model.secretId isEqualToString: self.secretId]) {
            // 是密友  并且是当前密友圈的密友关系 
            cell.infoLabel.text = @"可友+密友";
            cell.operationBtn.hidden = YES;
            cell.infoLabel.hidden = NO;
        } else {
            cell.operationBtn.hidden = NO;
            cell.infoLabel.hidden = YES;
        }
    }
    if (self.useType == XKContactUseTypeNormal) {
        cell.headerImgView.userInteractionEnabled = YES;
    } else {
        cell.headerImgView.userInteractionEnabled = NO;
    }
    
    [cell setHeadClick:^(NSIndexPath *indexPath, XKContactModel *model) {
        [weakSelf headClick:indexPath model:model];
    }];
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
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.useType == XKContactUseTypeManySelect || self.useType == XKContactUseTypeNormalForAddSecret) { // 多选时
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
