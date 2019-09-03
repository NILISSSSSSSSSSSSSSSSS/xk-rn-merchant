//
//  XKMineCouponPackageCouponViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageCouponViewController.h"
#import "XKMineCouponPackageCompanyCouponTableViewCell.h"
#import "XKMineCouponPackageTerminalCouponTableViewCell.h"
#import "XKMineCouponPackageTerminalCouponTableViewHeader.h"
#import "XKMineCouponPackageTerminalCouponTableViewFooter.h"
#import "XKMineCouponPackageCouponModel.h"
#import "XKContactListController.h"

@interface XKMineCouponPackageCouponViewController () <UITableViewDelegate, UITableViewDataSource, XKMineCouponPackageCompanyCouponTableViewCellDelegate, XKMineCouponPackageTerminalCouponTableViewCellDelegate, XKMineCouponPackageTerminalCouponTableViewFooterDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *extensionView;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) UIView *operationContainerView;
@property (nonatomic, strong) UIButton *givenEditButton;
@property (nonatomic, strong) UIButton *delateEditButton;
@property (nonatomic, strong) UIButton *showOverdueButton;
@property (nonatomic, strong) UIButton *showContactButton;
@property (nonatomic, strong) UIButton *confirmDeleteButton;

@property (nonatomic, strong) NSMutableArray *currentDataArr;
@property (nonatomic, strong) NSMutableArray *companyCouponDataArr;
@property (nonatomic, strong) NSMutableArray *terminalCouponDataArr;
@property (nonatomic, strong) NSMutableArray *overdueCompanyCouponDataArr;
@property (nonatomic, strong) NSMutableArray *overdueTerminalCouponDataArr;
@property (nonatomic, assign) NSInteger companyCouponPage;
@property (nonatomic, assign) NSInteger terminalCouponPage;
@property (nonatomic, assign) NSInteger overdueCompanyCouponPage;
@property (nonatomic, assign) NSInteger overdueTerminalCouponPage;
@property (nonatomic, assign) BOOL isCompanyCouponHaveData;
@property (nonatomic, assign) BOOL isTerminalCouponHaveData;
@property (nonatomic, assign) BOOL isOverdueCompanyCouponHaveData;
@property (nonatomic, assign) BOOL isOverdueTerminalCouponHaveData;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) NSMutableArray<XKMineCouponPackageCouponItem *> *selectedGivenCouponArr;
@property (nonatomic, strong) NSMutableArray<XKMineCouponPackageCouponItem *> *selectedDeleteCouponArr;

@end

@implementation XKMineCouponPackageCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化页面
    [self initializeViews];
    
    // 初始化当前分页
    self.companyCouponPage = 1;
    self.terminalCouponPage = 1;
    self.overdueCompanyCouponPage = 1;
    self.overdueTerminalCouponPage = 1;
    
    // 初始化区角状态
    self.isCompanyCouponHaveData = YES;
    self.isTerminalCouponHaveData = YES;
    self.isOverdueCompanyCouponHaveData = YES;
    self.isOverdueTerminalCouponHaveData = YES;
    
    // 初始画页面数据
    [self loadViewData:self.type isBackgroundLoad:NO];
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon) {
        [self loadViewData:XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon isBackgroundLoad:YES];
    } else {
        [self loadViewData:XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon isBackgroundLoad:YES];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.currentDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[section];
    if (dataItem.isNeedSimplify) {
        if (dataItem.isShowingAll) {
            return dataItem.coupons.count;
        } else {
            return 2;
        }
    } else {
        return dataItem.coupons.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon ||
        self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[section];
    if (dataItem.isNeedSimplify) {
        return 30;
    }
    return 0;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon ||
        self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        XKMineCouponPackageTerminalCouponTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewHeader"];
        XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[section];
        [header configHeaderViewWithModel:dataItem];
        
        if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
            header.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
        } else {
            header.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
        }
        return header;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[section];
    if (dataItem.isNeedSimplify) {
        XKMineCouponPackageTerminalCouponTableViewFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewFooter"];
        footer.delegate = self;
        XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[section];
        [footer configFooterViewWithModel:dataItem];
        
        if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
            footer.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
        } else {
            footer.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
        }
        return footer;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {
        // 自营未过期
        case XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon: {
            XKMineCouponPackageCompanyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell" forIndexPath:indexPath];
            XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configCellWithModel:couponItem];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
                [cell showCountChangeView];
            } else {
                [cell hiddenSelectButton];
                [cell hiddenCountChangeView];
            }
            return cell;
        }
        // 商户未过期
        case XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon: {
            XKMineCouponPackageTerminalCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell" forIndexPath:indexPath];
            XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configCellWithModel:couponItem];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
                [cell showCountChangeView];
            } else {
                [cell hiddenSelectButton];
                [cell hiddenCountChangeView];
            }
            return cell;
        }
        // 自营已过期
        case XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon: {
            XKMineCouponPackageCompanyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell" forIndexPath:indexPath];
            XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configOverdueCellWithModel:couponItem];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
            } else {
                [cell hiddenSelectButton];
            }
            return cell;
        }
        // 商户已过期
        case XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon: {
            XKMineCouponPackageTerminalCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell" forIndexPath:indexPath];
            XKMineCouponPackageCouponModelDataItem *dataItem = self.currentDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configOverdueCellWithModel:couponItem];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
            } else {
                [cell hiddenSelectButton];
            }
            return cell;
        }
    }
}

#pragma mark - XKMineCouponPackageCompanyCouponTableViewCellDelegate

// 选中晓可券后回调
- (void)companyCouponTableViewCell:(XKMineCouponPackageCompanyCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem {

    // 可用券赠送
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon) {
        if (couponItem.isSelected == NO) {
            [self.selectedGivenCouponArr removeObject:couponItem];
        } else {
            [self.selectedGivenCouponArr addObject:couponItem];
        }
    }

    // 过期券删除
    else if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon) {
        if (couponItem.isSelected == NO) {
            [self.selectedDeleteCouponArr removeObject:couponItem];
        } else {
            [self.selectedDeleteCouponArr addObject:couponItem];
        }
    }
    
    // 刷新列表
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCouponTableViewCellDelegate

// 选中商户券后回调
- (void)terminalCouponTableViewCell:(XKMineCouponPackageTerminalCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem {

    // 可用券赠送
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon) {
        if (couponItem.isSelected == NO) {
            [self.selectedGivenCouponArr removeObject:couponItem];
        } else {
            [self.selectedGivenCouponArr addObject:couponItem];
        }
    }

    // 过期券删除
    else if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        if (couponItem.isSelected == NO) {
            [self.selectedDeleteCouponArr removeObject:couponItem];
        } else {
            [self.selectedDeleteCouponArr addObject:couponItem];
        }
    }

    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCouponTableViewFooterDelegate

- (void)tableViewFooter:(XKMineCouponPackageTerminalCouponTableViewFooter *)footer updateModel:(XKMineCouponPackageCouponModelDataItem *)model {
    
    [self.tableView reloadData];
}

#pragma mark - events

// 点击转赠
- (void)clickGivenToOne:(UIControl *)sender {
    
    self.isEditing = !self.isEditing;
    if (self.isEditing == YES) {
        self.showOverdueButton.hidden = YES;
        self.showContactButton.hidden = NO;
        [self.givenEditButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
        }];
    } else {
        self.showOverdueButton.hidden = NO;
        self.showContactButton.hidden = YES;
        [self.givenEditButton setTitle:@"转赠" forState:UIControlStateNormal];
        [self.operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
        }];
    }
    [self.tableView reloadData];
}

// 点击删除
- (void)clickDeleteEditButton:(UIButton *)sender {
    
    self.isEditing = !self.isEditing;
    if (self.isEditing == YES) {
        self.confirmDeleteButton.hidden = NO;
        [self.delateEditButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
        }];
    } else {
        self.confirmDeleteButton.hidden = YES;
        [self.delateEditButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    // 清空上次数据
    if (self.selectedDeleteCouponArr.count != 0) {
        [self.selectedDeleteCouponArr removeAllObjects];
    }
    [self.tableView reloadData];
}

// 选择小可卡
- (void)clickCompanyCoupon:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon) {
        self.type = XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon;
        self.currentDataArr = self.companyCouponDataArr;
    } else if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        self.type = XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon;
        self.currentDataArr = self.overdueCompanyCouponDataArr;
    }
    [self reloadTableViewFooter];
    [self.tableView reloadData];
    
    if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        self.view.backgroundColor = HEX_RGB(0xFFFFFF);
        self.tableView.backgroundColor = HEX_RGB(0xFFFFFF);
    } else {
        self.view.backgroundColor = HEX_RGB(0xF6F6F6);
        self.tableView.backgroundColor = HEX_RGB(0xF6F6F6);
    }
}

// 选择商户卡
- (void)clickTerminalCoupon:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon) {
        self.type = XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon;
        self.currentDataArr = self.terminalCouponDataArr;
    } else if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon) {
        self.type = XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon;
        self.currentDataArr = self.overdueTerminalCouponDataArr;
    }
    [self reloadTableViewFooter];
    [self.tableView reloadData];
    
    if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        self.view.backgroundColor = HEX_RGB(0xFFFFFF);
        self.tableView.backgroundColor = HEX_RGB(0xFFFFFF);
    } else {
        self.view.backgroundColor = HEX_RGB(0xF6F6F6);
        self.tableView.backgroundColor = HEX_RGB(0xF6F6F6);
    }
}

// 展示过期列表
- (void)showOverdueCouponList:(UIButton *)sender {
    
    XKMineCouponPackageCouponViewController *couponPackageCouponViewController = [XKMineCouponPackageCouponViewController new];
    couponPackageCouponViewController.type = XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon;
    [self.navigationController pushViewController:couponPackageCouponViewController animated:YES];
}

// 展示联系人列表
- (void)showTheContactList:(UIButton *)sender {
    
    if (self.selectedGivenCouponArr.count == 0) {
        // 未选择卡券
        return;
    }
    
    XKContactListController *contactListController = [XKContactListController new];
    contactListController.useType = XKContactUseTypeSingleSelect;
    contactListController.bottomButtonText = @"确认转赠";
    contactListController.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        
    };
    [self.navigationController pushViewController:contactListController animated:YES];
}

// 点击确认删除
- (void)confirmDeleteSelectedCoupon:(UIButton *)sender {
    
    if (self.selectedDeleteCouponArr.count == 0) {
        return;
    }
    
    NSMutableArray *deleteCardIdArr = @[].mutableCopy;
    for (XKMineCouponPackageCouponItem *couponItem in self.selectedDeleteCouponArr) {
        [deleteCardIdArr addObject:couponItem.userCouponId];
    }
    NSDictionary *params = @{@"ids": deleteCardIdArr};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetDeleteCouponUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        
        [self.tableView.mj_header beginRefreshing];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

#pragma mark - private methods

- (void)initializeViews {
    
    if (self.type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
        self.view.backgroundColor = HEX_RGB(0xFFFFFF);
    } else {
        self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    }
    
    // 导航栏
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon ||
        self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon) {
        [self setNavTitle:@"优惠券" WithColor:[UIColor whiteColor]];
        UIButton *givenEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [givenEditButton setTitle:@"转赠" forState:UIControlStateNormal];
        [givenEditButton addTarget:self action:@selector(clickGivenToOne:) forControlEvents:UIControlEventTouchUpInside];
        givenEditButton.titleLabel.tintColor = [UIColor whiteColor];
        [self setRightView:givenEditButton withframe:CGRectMake(20, 20, 100, 24)];
        self.givenEditButton = givenEditButton;
    } else {
        [self setNavTitle:@"过期优惠券" WithColor:[UIColor whiteColor]];
        UIButton *delateEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [delateEditButton setTitle:@"删除" forState:UIControlStateNormal];
        [delateEditButton addTarget:self action:@selector(clickDeleteEditButton:) forControlEvents:UIControlEventTouchUpInside];
        delateEditButton.titleLabel.tintColor = [UIColor whiteColor];
        [self setRightView:delateEditButton withframe:CGRectMake(20, 20, 100, 24)];
        self.delateEditButton = delateEditButton;
    }
    [self hideNavigationSeperateLine];
    
    // 容器视图
    UIView *extensionView = [UIView new];
    extensionView.backgroundColor = self.navigationView.backgroundColor;
    [self.view addSubview:extensionView];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(36);
    }];
    self.extensionView = extensionView;
    
    // tab栏
    UIControl *leftControl = [UIControl new];
    [leftControl addTarget:self action:@selector(clickCompanyCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [extensionView addSubview:leftControl];
    [leftControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(extensionView.mas_left);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.5);
    }];
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.text = @"晓可券";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [leftControl addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftControl.mas_centerX);
        make.centerY.equalTo(leftControl.mas_centerY);
    }];
    UIControl *rightControl = [UIControl new];
    [rightControl addTarget:self action:@selector(clickTerminalCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [extensionView addSubview:rightControl];
    [rightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.right.equalTo(extensionView.mas_right);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.5);
    }];
    UILabel *rightLabel = [UILabel new];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = @"商户券";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [rightControl addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightControl.mas_centerX);
        make.centerY.equalTo(rightControl.mas_centerY);
    }];
    
    // 滑动选择视图
    self.switchingView = [UIView new];
    self.switchingView.backgroundColor = [UIColor whiteColor];
    [extensionView addSubview:self.switchingView];
    [self.switchingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@3);
        make.width.equalTo(@50);
        make.centerX.equalTo(leftControl.mas_centerX);
        make.bottom.equalTo(extensionView.mas_bottom);
    }];
    
    // 操作按钮父视图
    UIView *operationContainerView = [UIView new];
    operationContainerView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:operationContainerView];
    [operationContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
        make.height.equalTo(@0);
    }];
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon ||
        self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon) {
        [operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
        }];
    }
    self.operationContainerView = operationContainerView;
    
    // 查看过期券按钮
    UIButton *showOverdueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showOverdueButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    [showOverdueButton setTitle:@"查看过期券" forState:UIControlStateNormal];
    showOverdueButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13.0];
    showOverdueButton.backgroundColor = self.view.backgroundColor;
    [showOverdueButton addTarget:self action:@selector(showOverdueCouponList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showOverdueButton];
    [showOverdueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationContainerView.mas_left);
        make.right.equalTo(operationContainerView.mas_right);
        make.bottom.equalTo(operationContainerView.mas_bottom);
        make.top.equalTo(operationContainerView.mas_top);
    }];
    if (self.type == XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon ||
        self.type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon) {
        showOverdueButton.hidden = NO;
    } else {
        showOverdueButton.hidden = YES;
    }
    self.showOverdueButton = showOverdueButton;
    
    // 查看联系人按钮
    UIButton *showContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showContactButton setTitle:@"转赠给好友" forState:UIControlStateNormal];
    showContactButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15.0];
    showContactButton.backgroundColor = XKMainTypeColor;
    [showContactButton addTarget:self action:@selector(showTheContactList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showContactButton];
    [showContactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationContainerView.mas_left);
        make.right.equalTo(operationContainerView.mas_right);
        make.bottom.equalTo(operationContainerView.mas_bottom);
        make.top.equalTo(operationContainerView.mas_top);
    }];
    showContactButton.hidden = YES;
    self.showContactButton = showContactButton;
    
    // 删除券按钮
    UIButton *confirmDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmDeleteButton setTitle:@"确认删除" forState:UIControlStateNormal];
    confirmDeleteButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13.0];
    confirmDeleteButton.backgroundColor = XKMainTypeColor;
    [confirmDeleteButton addTarget:self action:@selector(confirmDeleteSelectedCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmDeleteButton];
    [confirmDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationContainerView.mas_left);
        make.right.equalTo(operationContainerView.mas_right);
        make.bottom.equalTo(operationContainerView.mas_bottom);
        make.top.equalTo(operationContainerView.mas_top);
    }];
    confirmDeleteButton.hidden = YES;
    self.confirmDeleteButton = confirmDeleteButton;
    
    // 券列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(showOverdueButton.mas_top).offset(-1);
    }];
}

- (void)updateSwitchingViewFrame:(UIControl *)sender {
    
    [self.switchingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
        make.height.equalTo(@3);
        make.width.equalTo(@50);
        make.bottom.equalTo(self.extensionView.mas_bottom);
    }];
    [self.switchingView setNeedsUpdateConstraints];
    [self.switchingView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [self.extensionView layoutIfNeeded];
    }];
}

- (void)loadViewData:(XKMineCouponPackageCouponViewControllerType)type isBackgroundLoad:(BOOL)isBackgroundLoad {
    
    NSInteger page;
    NSDictionary *coupon;
    NSMutableArray *tempDataArr;
    
    switch (type) {
        
        // 自营未过期
        case XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon: {
            page = self.companyCouponPage;
            coupon = @{@"xkModule": @"mall"};
            tempDataArr = self.companyCouponDataArr;
            break;
        }
        // 商户未过期
        case XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon: {
            page = self.terminalCouponPage;
            coupon = @{@"xkModule": @"shop"};
            tempDataArr = self.terminalCouponDataArr;
            break;
        }
        // 自营已过期
        case XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon: {
            page = self.overdueCompanyCouponPage;
            coupon = @{@"xkModule": @"mall",
                       @"type": @(3)};
            tempDataArr = self.overdueCompanyCouponDataArr;
            break;
        }
        // 商户已过期
        case XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon: {
            page = self.overdueTerminalCouponPage;
            coupon = @{@"xkModule": @"shop",
                       @"type": @(3)};
            tempDataArr = self.overdueTerminalCouponDataArr;
            break;
        }
    }
    
    NSDictionary *params = @{@"limit": @(10),
                             @"page": @(page),
                             @"coupon": coupon};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetCouponListUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {

        [XKHudView hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (page == 1) {
            [tempDataArr removeAllObjects];
        }
        
        // yuan'mock
//        XKMineCouponPackageCouponModelDataItem *dataItem = [XKMineCouponPackageCouponModelDataItem new];
//        dataItem.shopId = @"234134";
//        dataItem.shopName = @"yuan'shop";
//        NSMutableArray *coupons = @[].mutableCopy;
//        XKMineCouponPackageCouponItem *couponItem = [XKMineCouponPackageCouponItem new];
//        couponItem.couponId = @"12323";
//        couponItem.invalidTime = 1538327520;
//        couponItem.message = @"XXX";
//        couponItem.couponName = @"yuan test";
//        couponItem.price = @"1000000";
//        couponItem.couponType = @"DISCOUNT";
//        couponItem.validTime = 1538190710;
//        couponItem.userCouponId = @"52";
//        [coupons addObject:couponItem];
//        [coupons addObject:couponItem];
//        [coupons addObject:couponItem];
//        dataItem.coupons = coupons.copy;
//        [tempDataArr addObject:dataItem];
        
        XKMineCouponPackageCouponModel *model =  [XKMineCouponPackageCouponModel yy_modelWithJSON:responseObject];
        [tempDataArr addObjectsFromArray:model.data];
        
        for (XKMineCouponPackageCouponModelDataItem *dataItem in tempDataArr) {
            
            // 初始化展示状态
            if (type == XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon ||
                type == XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon) {
                if (dataItem.coupons.count > 2) {
                    dataItem.isNeedSimplify = YES;
                    dataItem.isShowingAll = NO;
                } else {
                    dataItem.isNeedSimplify = NO;
                    dataItem.isShowingAll = YES;
                }
            } else {
                dataItem.isNeedSimplify = NO;
                dataItem.isShowingAll = YES;
            }
            
            // 初始化选择状态
            for (XKMineCouponPackageCouponItem *couponItem in dataItem.coupons) {
                couponItem.isSelected = NO;
            }
        }
        
        // 更新下拉刷新 & 上拉加载
        if (!tempDataArr || tempDataArr.count == 0) {
            
            // 显示空白页
            self.tableView.mj_footer.hidden = YES;
        } else {
            BOOL isHaveData = NO;
            if (model.data.count < 10) {
                isHaveData = NO;
            } else {
                isHaveData = YES;
            }
            switch (type) {
                case XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon: {
                    self.isCompanyCouponHaveData = isHaveData;
                    self.companyCouponPage++;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon: {
                    self.isTerminalCouponHaveData = isHaveData;
                    self.terminalCouponPage++;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon: {
                    self.isOverdueCompanyCouponHaveData = isHaveData;
                    self.overdueCompanyCouponPage++;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon: {
                    self.isOverdueTerminalCouponHaveData = isHaveData;
                    self.overdueTerminalCouponPage++;
                    break;
                }
            }
        }
        
        // 更新数据源
        if (isBackgroundLoad) {
            // 后台加载数据不作任何操作
            return;
            
        } else {
            
            // 修改数据源、刷新区脚、刷新tableView
            self.currentDataArr = tempDataArr;
            [self reloadTableViewFooter];
            [self.tableView reloadData];
        }
    } failure:^(XKHttpErrror *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
        self.tableView.mj_footer.hidden = YES;
    }];
}

// 刷新区脚
- (void)reloadTableViewFooter {
    
    BOOL isHaveData;
    switch (self.type) {
        case XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon: {
            isHaveData = self.isCompanyCouponHaveData;
            break;
        }
        case XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon: {
            isHaveData = self.isTerminalCouponHaveData;
            break;
        }
        case XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon: {
            isHaveData = self.isOverdueCompanyCouponHaveData;
            break;
        }
        case XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon: {
            isHaveData = self.isOverdueTerminalCouponHaveData;
            break;
        }
    }
    if (isHaveData) {
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[XKMineCouponPackageCompanyCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewHeader class] forHeaderFooterViewReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewHeader"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewFooter class] forHeaderFooterViewReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewFooter"];
        
        // 下拉刷新 & 上拉加载
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            switch (weakSelf.type) {
                case XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon: {
                    weakSelf.companyCouponPage = 1;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon: {
                    weakSelf.terminalCouponPage = 1;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon: {
                    weakSelf.overdueCompanyCouponPage = 1;
                    break;
                }
                case XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon: {
                    weakSelf.overdueTerminalCouponPage = 1;
                    break;
                }
            }
            [weakSelf loadViewData:weakSelf.type isBackgroundLoad:NO];
        }];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadViewData:weakSelf.type isBackgroundLoad:NO];
        }];
        
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray *)companyCouponDataArr {
    
    if (!_companyCouponDataArr) {
        _companyCouponDataArr = @[].mutableCopy;
    }
    return _companyCouponDataArr;
}

- (NSMutableArray *)terminalCouponDataArr {
    
    if (!_terminalCouponDataArr) {
        _terminalCouponDataArr = @[].mutableCopy;
    }
    return _terminalCouponDataArr;
}

- (NSMutableArray *)overdueCompanyCouponDataArr {
    
    if (!_overdueCompanyCouponDataArr) {
        _overdueCompanyCouponDataArr = @[].mutableCopy;
    }
    return _overdueCompanyCouponDataArr;
}

- (NSMutableArray *)overdueTerminalCouponDataArr {
    
    if (!_overdueTerminalCouponDataArr) {
        _overdueTerminalCouponDataArr = @[].mutableCopy;
    }
    return _overdueTerminalCouponDataArr;
}

- (NSMutableArray *)selectedGivenCouponArr {
    
    if (!_selectedGivenCouponArr) {
        _selectedGivenCouponArr = @[].mutableCopy;
    }
    return _selectedGivenCouponArr;
}

- (NSMutableArray *)selectedDeleteCouponArr {
    
    if (!_selectedDeleteCouponArr) {
        _selectedDeleteCouponArr = @[].mutableCopy;
    }
    return _selectedDeleteCouponArr;
}

@end
