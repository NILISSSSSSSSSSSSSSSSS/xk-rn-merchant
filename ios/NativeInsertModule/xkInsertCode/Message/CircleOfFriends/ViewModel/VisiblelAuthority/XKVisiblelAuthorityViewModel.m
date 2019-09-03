/*******************************************************************************
 # File        : XKVisiblelAuthorityViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKVisiblelAuthorityViewModel.h"
#import "XKVisbleAuthorityChooseCell.h"
#import "XKCheckFolderSectionHeaderView.h"
#import "XKContactListController.h"
#import "XKCreateTagController.h"
#import "XKGroupDetailController.h"
#import "XKTagSettingController.h"

@interface XKVisiblelAuthorityViewModel () {
  
}
/**<##>*/
@property(nonatomic, strong) XKVisiblelAuthorityInfo *sectionDataForPublic;
@property(nonatomic, strong) XKVisiblelAuthorityInfo *sectionDataForSecret;
@property(nonatomic, strong) XKVisiblelAuthorityInfo *sectionDataForSomeCanSee;
@property(nonatomic, strong) XKVisiblelAuthorityInfo *sectionDataForSomeNoSee;

@end

@implementation XKVisiblelAuthorityViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefalut];
    }
    return self;
}

- (void)createDefalut {
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:self.sectionDataForPublic];
    [_dataArray addObject:self.sectionDataForSecret];
    [_dataArray addObject:self.sectionDataForSomeCanSee];
    [_dataArray addObject:self.sectionDataForSomeNoSee];
}

- (void)setInitData:(XKVisiblelAuthorityResult *)result {

    if ([result containNetData]) { // 有结果 包含待分组的数据 就直接用数据 后续不会请求了
        _dataArray = result.dataArray;
        self.sectionDataForPublic = _dataArray[0];
        self.sectionDataForSecret = _dataArray[1];
        self.sectionDataForSomeCanSee = _dataArray[2];
        self.sectionDataForSomeNoSee = _dataArray[3];
    }
    if (result && ![result containNetData]) { // 有结果 不包含网络分组数据 虽然数据不完整至少要之前用户上次保持选择的样子
        // 处理通讯录有选择的情况
        _dataArray[result.currentInfoIndex].itemFromAddress = result.dataArray[result.currentInfoIndex].itemFromAddress;
        // 设置默认选中
        for (XKVisiblelAuthorityInfo *info in _dataArray) {
            info.selected = NO;
        }
        _dataArray[result.currentInfoIndex].selected = YES;
    }
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKVisbleAuthorityChooseCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[XKCheckFolderSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"head"];
}

#pragma mark - 请求
- (void)requestGroupsComplete:(void(^)(NSString *err,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/labelAndXkGroupList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKFriendGroupModel class] json:responseObject];
        [self configGroups:arr];
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - 配置选择项
- (void)configGroups:(NSArray *)groups {
    NSMutableArray *itemsArrayForCanSee = _sectionDataForSomeCanSee.itemsArray;
    [itemsArrayForCanSee removeAllObjects];
    NSMutableArray *itemsArrayForNoSee = _sectionDataForSomeNoSee.itemsArray;
    [itemsArrayForNoSee removeAllObjects];
    for (XKFriendGroupModel *group in groups) {
        XKVisiblelAuthorityItem *itemCanSee = [[XKVisiblelAuthorityItem alloc] init];
        itemCanSee.group = group;
        [itemsArrayForCanSee addObject:itemCanSee];
        XKVisiblelAuthorityItem *itemNoSee = [[XKVisiblelAuthorityItem alloc] init];
        itemNoSee.group = group;
        [itemsArrayForNoSee addObject:itemNoSee];
    }
}

#pragma mark - 添加标签后本地加数据
- (void)addGroups:(XKFriendGroupModel *)group user:(NSArray *)users andSetSelected:(NSInteger)section {
    {
        NSMutableArray *itemsArrayForCanSee = _sectionDataForSomeCanSee.itemsArray;
        XKFriendGroupModel *newGroup = [XKFriendGroupModel new];
        newGroup.groupName = group.groupName;
        newGroup.groupId = group.groupId;
        newGroup.groupType = @"label";
        newGroup.list = users.copy;
        
        XKVisiblelAuthorityItem *item = [XKVisiblelAuthorityItem new];
        item.group = newGroup;
        [itemsArrayForCanSee addObject:item];}
    
    {
        NSMutableArray *itemsArrayForNoSee = _sectionDataForSomeNoSee.itemsArray;
        XKFriendGroupModel *newGroup = [XKFriendGroupModel new];
        newGroup.groupName = group.groupName;
       newGroup.groupId = group.groupId;
        newGroup.groupType = @"label";
        newGroup.list = users.copy;
    
        XKVisiblelAuthorityItem *item = [XKVisiblelAuthorityItem new];
        item.group = newGroup;
        [itemsArrayForNoSee addObject:item];
    }
    
    self.dataArray[section].itemsArray.lastObject.selected = YES;
}


#pragma mark - 业务逻辑

#pragma mark 点击区头 切换可见模式
- (void)clickSection:(NSInteger)section {
    if (self.dataArray[section].selected == YES) {
        return;
    }
    NSInteger chooseIndex = 0;
    for (XKVisiblelAuthorityInfo *info in self.dataArray) {
        info.selected = NO;
        [info.itemFromAddress.userArray removeAllObjects];
        for (XKVisiblelAuthorityItem *item in info.itemsArray) {
            item.selected = NO;
        }
        chooseIndex ++;
    }
    self.dataArray[section].selected = YES;
    self.reloadData();
}

#pragma mark 点击分组
- (void)clickItem:(NSIndexPath *)indexPath {
    XKVisiblelAuthorityInfo *info = self.dataArray[indexPath.section];
    XKVisiblelAuthorityItem *item = info.itemsArray[indexPath.row];
    item.selected = !item.selected;
    self.reloadData();
}

#pragma mark  点击信息
- (void)clickItemInfoBtn:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKVisiblelAuthorityInfo *info = self.dataArray[indexPath.section];
    XKVisiblelAuthorityItem *item = info.itemsArray[indexPath.row];
    if (item.group.groupTypeEnum == XKGroupLabelType) {
        XKTagSettingController *vc = [XKTagSettingController new];
        vc.tagId = item.group.groupId;
        [vc setChangeBlock:^(XKFriendGroupModel *model) { // 改变的回调
            item.group = model;
            weakSelf.reloadData();
        }];
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    } else  {
        XKGroupDetailController *vc = [XKGroupDetailController new];
        vc.groupId = item.group.groupId;
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark - 添加分组
- (void)addGroupFromAddress:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    XKVisiblelAuthorityInfo *info = self.dataArray[section];
    
    XKContactListController *list = [[XKContactListController alloc] init];
    list.rightButtonText = @"完成";
    list.showSelectedNum = YES;
    list.useType = XKContactUseTypeManySelect;
    list.title = @"选择联系人";
    list.defaultSelected = info.itemFromAddress.userArray;
    
    UIViewController * currentVC = self.getCurrentUIVC;
    [list setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        if (contacts.count == 0) {
            [XKHudView showTipMessage:@"还未选择好友"];
        }
        [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"保存为标签，下次直接选用" leftText:@"存为标签" rightText:@"忽略" leftBlock:^{
            // 存标签
            XKCreateTagController *creatTagVC = [XKCreateTagController new];
            creatTagVC.userArray = contacts;
            [creatTagVC setSuccessBlock:^(XKFriendGroupModel *groupInfo) {
                // 创建成功了组
                // 本地直接加数据 并设置为选中
                [weakSelf addGroups:groupInfo user:contacts andSetSelected:section];
                weakSelf.reloadData();
                [NSObject popToVCFromCurrentStackTargetVCClass:NSClassFromString(@"XKVisibleAuthorityController")];
            }];
            [weakSelf.getCurrentUIVC.navigationController pushViewController:creatTagVC animated:YES];
        } rightBlock:^{
            [info.itemFromAddress.userArray removeAllObjects];
            [info.itemFromAddress.userArray addObjectsFromArray:contacts];
            weakSelf.reloadData();
            [currentVC.navigationController popViewControllerAnimated:YES];
        } textAlignment:NSTextAlignmentCenter];

    }];
    [currentVC.navigationController pushViewController:list animated:YES];
}


#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XKVisiblelAuthorityInfo *info = self.dataArray[section];
    if (info.selected) {
        return info.itemsArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKVisbleAuthorityChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    XKVisiblelAuthorityInfo *info = self.dataArray[indexPath.section];
    NSArray *items = info.itemsArray;
    cell.item = items[indexPath.row];
    cell.indexPath = indexPath;
    
    [cell setInfoBtnBlock:^(NSIndexPath *indexPath) {
        [weakSelf clickItemInfoBtn:indexPath];
    }];
    cell.xk_radius = 6;
    cell.xk_openClip = YES;
    if (indexPath.row == 0) {
        cell.contentView.topBorder.borderLine.hidden = NO;
    } else {
        cell.contentView.topBorder.borderLine.hidden = YES;
    }
    if (self.dataArray.count - 1 ==  indexPath.section) { // 最后一行
        if (info.itemsArray.count - 1 == indexPath.row) { // 最后一个cell
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
        } else {
            cell.xk_clipType = XKCornerClipTypeNone;
        }
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    XKVisiblelAuthorityInfo *info = self.dataArray[section];
    XKCheckFolderSectionHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    headView.info = info;
    headView.section = section;
    [headView setClickBlock:^(NSInteger section) {
        [weakSelf clickSection:section];
    }];
    headView.xk_openClip = YES;
    headView.xk_radius = 6;
    headView.topBorder.borderLine.hidden = NO;
    if (section == 0) {
        headView.topBorder.borderLine.hidden = YES;
        headView.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (section == self.dataArray.count - 1) {
        if (info.selected == YES) {
            headView.xk_clipType = XKCornerClipTypeNone;
        } else {
            headView.xk_clipType = XKCornerClipTypeBottomBoth;
        }
    } else {
        headView.xk_clipType = XKCornerClipTypeNone;
    }

    [headView setNeedsLayout];
    [headView layoutIfNeeded];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 82;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    XKVisiblelAuthorityInfo *info = self.dataArray[section];
    if (info.selected == YES && (info == self.sectionDataForSomeCanSee || info == self.sectionDataForSomeNoSee)) {
        if (info.itemFromAddress.userArray.count != 0) {
            return 68;
        }
        return 50;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XKVisiblelAuthorityInfo *info = self.dataArray[section];
    if (info == self.sectionDataForSomeCanSee || info == self.sectionDataForSomeNoSee) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 2;
        label.font = XKRegularFont(14);
        label.textColor = HEX_RGB(0xEE6161);
        if (info.itemFromAddress.userArray.count != 0) {
            [label rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.paragraphStyle.lineSpacing(6);
                confer.text(@"从好友列表中选择");
                confer.text(@"\n");
                confer.appendImage(IMG_NAME(@"xk_ic_contact_chose")).bounds(CGRectMake(0, -2.5, 15, 15));
                confer.text(@"  ");
                confer.text(info.itemFromAddress.groupInfo).textColor(XKMainTypeColor);
            }];
        } else {
            label.text = @"从好友列表中选择";
        }
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view.mas_left).offset(69);
            make.right.equalTo(view.mas_right).offset(-2);
        }];
        __weak typeof(self) weakSelf = self;
        [view bk_whenTapped:^{
            [weakSelf addGroupFromAddress:section];
        }];
        
        view.xk_openClip = YES;
        view.xk_radius  = 6;
        view.clipsToBounds = YES;
        if (section == self.dataArray.count - 1) {
            view.xk_clipType = XKCornerClipTypeBottomBoth;
        } else {
            view.xk_clipType = XKCornerClipTypeNone;
        }
        return view;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self clickItem:indexPath];
}

#pragma mark - getter

- (XKVisiblelAuthorityInfo *)sectionDataForPublic {
    if (!_sectionDataForPublic) {
        _sectionDataForPublic = [[XKVisiblelAuthorityInfo alloc] init];
        _sectionDataForPublic.title = @"公开";
        _sectionDataForPublic.dynamicAuthType = DynamicAuthPublic;
        _sectionDataForPublic.describe = @"所有人可见";
        _sectionDataForPublic.selected = YES;
    }
    return _sectionDataForPublic;
}

- (XKVisiblelAuthorityInfo *)sectionDataForSecret {
    if (!_sectionDataForSecret) {
        _sectionDataForSecret = [[XKVisiblelAuthorityInfo alloc] init];
        _sectionDataForSecret.title = @"私密";
        _sectionDataForSecret.describe = @"仅自己可见";
        _sectionDataForSecret.dynamicAuthType = DynamicAuthMe;
    }
    return _sectionDataForSecret;
}

- (XKVisiblelAuthorityInfo *)sectionDataForSomeCanSee {
    if (!_sectionDataForSomeCanSee) {
        _sectionDataForSomeCanSee = [[XKVisiblelAuthorityInfo alloc] init];
        _sectionDataForSomeCanSee.title = @"部分可见";
        _sectionDataForSomeCanSee.describe = @"选中的朋友可见";
        _sectionDataForSomeCanSee.dynamicAuthType = DynamicAuthSee;
        NSMutableArray *itemsArray = @[].mutableCopy;
        _sectionDataForSomeCanSee.itemsArray = itemsArray;
        _sectionDataForSomeCanSee.itemFromAddress = [XKVisiblelAuthorityItem new];
    }
    return _sectionDataForSomeCanSee;
}

- (XKVisiblelAuthorityInfo *)sectionDataForSomeNoSee {
    if (!_sectionDataForSomeNoSee) {
        _sectionDataForSomeNoSee = [[XKVisiblelAuthorityInfo alloc] init];
        _sectionDataForSomeNoSee.title = @"不给谁看";
        _sectionDataForSomeNoSee.describe = @"选中的朋友不可见";
        _sectionDataForSomeNoSee.dynamicAuthType = DynamicAuthUnSee;
        NSMutableArray *itemsArray = @[].mutableCopy;
        _sectionDataForSomeNoSee.itemsArray = itemsArray;
        _sectionDataForSomeNoSee.itemFromAddress = [XKVisiblelAuthorityItem new];

    }
    return _sectionDataForSomeNoSee;
}


@end
