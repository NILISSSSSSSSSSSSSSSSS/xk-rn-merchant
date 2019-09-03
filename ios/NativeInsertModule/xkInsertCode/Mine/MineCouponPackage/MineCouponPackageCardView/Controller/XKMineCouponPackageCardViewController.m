//
//  XKMineCouponPackageCardViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageCardViewController.h"
#import "XKMineCouponPackageCompanyCardTableViewCell.h"
#import "XKMineCouponPackageTerminalCardTableViewCell.h"
#import "XKContactListController.h"
#import "XKMineCouponPackageCardModel.h"

@interface XKMineCouponPackageCardViewController () <UITableViewDelegate, UITableViewDataSource, XKMineCouponPackageCompanyCardTableViewCellDelegate, XKMineCouponPackageTerminalCardTableViewCellDelegate>

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
@property (nonatomic, strong) NSMutableArray *companyCardDataArr;
@property (nonatomic, strong) NSMutableArray *terminalCardDataArr;
@property (nonatomic, strong) NSMutableArray *overdueCompanyCardDataArr;
@property (nonatomic, strong) NSMutableArray *overdueTerminalCardDataArr;
@property (nonatomic, assign) NSInteger companyCardPage;
@property (nonatomic, assign) NSInteger terminalCardPage;
@property (nonatomic, assign) NSInteger overdueCompanyCardPage;
@property (nonatomic, assign) NSInteger overdueTerminalCardPage;
@property (nonatomic, assign) BOOL isCompanyCardHaveData;
@property (nonatomic, assign) BOOL isTerminalCardHaveData;
@property (nonatomic, assign) BOOL isOverdueCompanyCardHaveData;
@property (nonatomic, assign) BOOL isOverdueTerminalCardHaveData;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) NSMutableArray<XKMineCouponPackageCardItem *> *selectedGivenCardArr;
@property (nonatomic, strong) NSMutableArray<XKMineCouponPackageCardItem *> *selectedDeleteCardArr;

@end

@implementation XKMineCouponPackageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化页面
    [self initializeViews];
    
    // 初始化当前分页
    self.companyCardPage = 1;
    self.terminalCardPage = 1;
    self.overdueCompanyCardPage = 1;
    self.overdueTerminalCardPage = 1;
    
    // 初始化区脚状态
    self.isCompanyCardHaveData = YES;
    self.isTerminalCardHaveData = YES;
    self.isOverdueCompanyCardHaveData = YES;
    self.isOverdueTerminalCardHaveData = YES;
    
    // 初始化页面数据
    [self loadViewData:self.type isBackgroundLoad:NO];
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard) {
        [self loadViewData:XKMineCouponPackageCardViewControllerTypeNormalTerminalCard isBackgroundLoad:YES];
    } else {
        [self loadViewData:XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard isBackgroundLoad:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {

        // 自营未过期
        case XKMineCouponPackageCardViewControllerTypeNormalCompanyCard: {
            XKMineCouponPackageCompanyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell" forIndexPath:indexPath];
            [cell configCellWithModel:self.currentDataArr[indexPath.row]];
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
            break;
        }
            
        // 商户未过期
        case XKMineCouponPackageCardViewControllerTypeNormalTerminalCard: {
            XKMineCouponPackageTerminalCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell" forIndexPath:indexPath];
            [cell configCellWithModel:self.currentDataArr[indexPath.row]];
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
            break;
        }
            
        // 自营已过期
        case XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard: {
            XKMineCouponPackageCompanyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell" forIndexPath:indexPath];
            [cell configOverdueCellWithModel:self.currentDataArr[indexPath.row]];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
            } else {
                [cell hiddenSelectButton];
            }
            return cell;
            break;
        }
            
        // 商户已过期
        case XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard: {
            XKMineCouponPackageTerminalCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell" forIndexPath:indexPath];
            [cell configOverdueCellWithModel:self.currentDataArr[indexPath.row]];
            cell.indexPath = indexPath;
            cell.delegate = self;
            if (self.isEditing) {
                [cell showSelectButton];
            } else {
                [cell hiddenSelectButton];
            }
            return cell;
            break;
        }
    }
}

#pragma mark - XKMineCouponPackageCompanyCardTableViewCellDelegate

// 选择卡后回调
- (void)companyCardTableViewCell:(XKMineCouponPackageCompanyCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem {
    
    // 可用卡赠送
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard) {
        if (cardItem.isSelected == NO) {
            [self.selectedGivenCardArr removeObject:cardItem];
        } else {
            [self.selectedGivenCardArr addObject:cardItem];
        }
    }
    
    // 过期卡删除
    else if (self.type == XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard) {
        if (cardItem.isSelected == NO) {
            [self.selectedDeleteCardArr removeObject:cardItem];
        } else {
            [self.selectedDeleteCardArr addObject:cardItem];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCardTableViewCellDelegate

// 选择卡后回调
- (void)terminalCardTableViewCell:(XKMineCouponPackageTerminalCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem {
    
    // 可用卡赠送
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalTerminalCard) {
        if (cardItem.isSelected == NO) {
            [self.selectedGivenCardArr removeObject:cardItem];
        } else {
            [self.selectedGivenCardArr addObject:cardItem];
        }
    }
    
    // 过期卡删除
    else if (self.type == XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard) {
        if (cardItem.isSelected == NO) {
            [self.selectedDeleteCardArr removeObject:cardItem];
        } else {
            [self.selectedDeleteCardArr addObject:cardItem];
        }
    }
    
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
    if (self.selectedDeleteCardArr.count != 0) {
        [self.selectedDeleteCardArr removeAllObjects];
    }
    [self.tableView reloadData];
}

// 选择小可卡
- (void)clickCompanyCard:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalTerminalCard) {
        self.type = XKMineCouponPackageCardViewControllerTypeNormalCompanyCard;
        self.currentDataArr = self.companyCardDataArr;
    } else if (self.type == XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard) {
        self.type = XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard;
        self.currentDataArr = self.overdueCompanyCardDataArr;
    }
    [self reloadTableViewFooter];
    [self.tableView reloadData];
}

// 选择商户卡
- (void)clickTerminalCard:(UIControl *)sender {

    [self updateSwitchingViewFrame:sender];
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard) {
        self.type = XKMineCouponPackageCardViewControllerTypeNormalTerminalCard;
        self.currentDataArr = self.terminalCardDataArr;
    } else if (self.type == XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard) {
        self.type = XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard;
        self.currentDataArr = self.overdueTerminalCardDataArr;
    }
    [self reloadTableViewFooter];
    [self.tableView reloadData];
}

// 展示过期列表
- (void)showOverdueCardList:(UIButton *)sender {
    
    XKMineCouponPackageCardViewController *couponPackageCardViewController = [XKMineCouponPackageCardViewController new];
    couponPackageCardViewController.type = XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard;
    [self.navigationController pushViewController:couponPackageCardViewController animated:YES];
}

// 展示联系人列表
- (void)showTheContactList:(UIButton *)sender {

    if (self.selectedGivenCardArr.count == 0) {
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
- (void)confirmDeleteSelectedCard:(UIButton *)sender {
    
    if (self.selectedDeleteCardArr.count == 0) {
        return;
    }
    
    NSMutableArray *deleteCardIdArr = @[].mutableCopy;
    for (XKMineCouponPackageCardItem *cardItem in self.selectedDeleteCardArr) {
        [deleteCardIdArr addObject:cardItem.userMemberId];
    }
    NSDictionary *params = @{@"ids": deleteCardIdArr};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetDeleteCardUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        
        [self.tableView.mj_header beginRefreshing];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

#pragma mark - private methods

- (void)initializeViews {
    
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    
    // 导航栏
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard ||
        self.type == XKMineCouponPackageCardViewControllerTypeNormalTerminalCard) {
        [self setNavTitle:@"会员卡" WithColor:[UIColor whiteColor]];
        UIButton *givenEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [givenEditButton setTitle:@"转赠" forState:UIControlStateNormal];
        [givenEditButton addTarget:self action:@selector(clickGivenToOne:) forControlEvents:UIControlEventTouchUpInside];
        givenEditButton.titleLabel.tintColor = [UIColor whiteColor];
        [self setRightView:givenEditButton withframe:CGRectMake(20, 20, 100, 24)];
        self.givenEditButton = givenEditButton;
    } else {
        [self setNavTitle:@"过期会员卡" WithColor:[UIColor whiteColor]];
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
    [leftControl addTarget:self action:@selector(clickCompanyCard:) forControlEvents:UIControlEventTouchUpInside];
    [extensionView addSubview:leftControl];
    [leftControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(extensionView.mas_left);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.5);
    }];
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.text = @"晓可卡";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [leftControl addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftControl.mas_centerX);
        make.centerY.equalTo(leftControl.mas_centerY);
    }];
    UIControl *rightControl = [UIControl new];
    [rightControl addTarget:self action:@selector(clickTerminalCard:) forControlEvents:UIControlEventTouchUpInside];
    [extensionView addSubview:rightControl];
    [rightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.right.equalTo(extensionView.mas_right);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.5);
    }];
    UILabel *rightLabel = [UILabel new];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = @"商户卡";
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
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard ||
        self.type == XKMineCouponPackageCardViewControllerTypeNormalTerminalCard) {
        [operationContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
        }];
    }
    self.operationContainerView = operationContainerView;
    
    // 查看过期卡按钮
    UIButton *showOverdueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showOverdueButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    [showOverdueButton setTitle:@"查看过期卡" forState:UIControlStateNormal];
    showOverdueButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13.0];
    showOverdueButton.backgroundColor = self.view.backgroundColor;
    [showOverdueButton addTarget:self action:@selector(showOverdueCardList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showOverdueButton];
    [showOverdueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationContainerView.mas_left);
        make.right.equalTo(operationContainerView.mas_right);
        make.bottom.equalTo(operationContainerView.mas_bottom);
        make.top.equalTo(operationContainerView.mas_top);
    }];
    if (self.type == XKMineCouponPackageCardViewControllerTypeNormalCompanyCard ||
        self.type == XKMineCouponPackageCardViewControllerTypeNormalTerminalCard) {
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
    
    // 删除卡按钮
    UIButton *confirmDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmDeleteButton setTitle:@"确认删除" forState:UIControlStateNormal];
    confirmDeleteButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13.0];
    confirmDeleteButton.backgroundColor = XKMainTypeColor;
    [confirmDeleteButton addTarget:self action:@selector(confirmDeleteSelectedCard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmDeleteButton];
    [confirmDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationContainerView.mas_left);
        make.right.equalTo(operationContainerView.mas_right);
        make.bottom.equalTo(operationContainerView.mas_bottom);
        make.top.equalTo(operationContainerView.mas_top);
    }];
    confirmDeleteButton.hidden = YES;
    self.confirmDeleteButton = confirmDeleteButton;
    
    // 卡列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(showOverdueButton.mas_top).offset(-1);
    }];
    [self.tableView registerClass:[XKMineCouponPackageCompanyCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell"];
    [self.tableView registerClass:[XKMineCouponPackageTerminalCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell"];
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

- (void)loadViewData:(XKMineCouponPackageCardViewControllerType)type isBackgroundLoad:(BOOL)isBackgroundLoad {
    
    NSInteger page;
    NSDictionary *coupon;
    NSMutableArray *tempDataArr;
    
    switch (type) {

        // 自营未过期
        case XKMineCouponPackageCardViewControllerTypeNormalCompanyCard: {
            page = self.companyCardPage;
            coupon = @{@"xkModule": @"mall",
                       @"type": @(1)};
            tempDataArr = self.companyCardDataArr;
            break;
        }
            
        // 商户未过期
        case XKMineCouponPackageCardViewControllerTypeNormalTerminalCard: {
            page = self.terminalCardPage;
            coupon = @{@"xkModule": @"shop",
                       @"type": @(1)};
            tempDataArr = self.terminalCardDataArr;
            break;
        }
            
        // 自营已过期
        case XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard: {
            page = self.overdueCompanyCardPage;
            coupon = @{@"xkModule": @"mall",
                       @"type": @(3)};
            tempDataArr = self.overdueCompanyCardDataArr;
            break;
        }
            
        // 商户已过期
        case XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard: {
            page = self.overdueTerminalCardPage;
            coupon = @{@"xkModule": @"shop",
                       @"type": @(3)};
            tempDataArr = self.overdueTerminalCardDataArr;
            break;
        }
    }
    
    NSDictionary *params = @{@"limit": @(10),
                             @"page": @(page),
                             @"coupon": coupon};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetCardListUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        
        [XKHudView hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (page == 1) {
            [tempDataArr removeAllObjects];
        }
        
        // yuan'mock
//        XKMineCouponPackageCardItem *cardItem = [XKMineCouponPackageCardItem new];
//        cardItem.cardType = @"GENERAL";
//        cardItem.discount = @"0.1";
//        cardItem.invalidTime = 1538327520;
//        cardItem.validTime = 1000000000;
//        cardItem.memberId = @"5ba899ea84912c1e90acee6d";
//        cardItem.message = @"XXX";
//        cardItem.name = @"普通";
//        cardItem.storeId = @"123123123";
//        cardItem.storeName = @"asdfsdf";
//        cardItem.userMemberId = @"123213";
//        [tempDataArr addObject:cardItem];
        
        XKMineCouponPackageCardModel *model =  [XKMineCouponPackageCardModel yy_modelWithJSON:responseObject];
        [tempDataArr addObjectsFromArray:model.data];
        
        for (XKMineCouponPackageCardItem *cardItem in tempDataArr) {
            cardItem.isSelected = NO;
        }
        
        // 下拉刷新 & 上拉加载
        BOOL isHaveData = NO;
        if (model.data.count < 10) {
            isHaveData = NO;
        } else {
            isHaveData = YES;
        }
        switch (type) {
            case XKMineCouponPackageCardViewControllerTypeNormalCompanyCard: {
                self.isCompanyCardHaveData = isHaveData;
                self.companyCardPage++;
                break;
            }
            case XKMineCouponPackageCardViewControllerTypeNormalTerminalCard: {
                self.isTerminalCardHaveData = isHaveData;
                self.terminalCardPage++;
                break;
            }
            case XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard: {
                self.isOverdueCompanyCardHaveData = isHaveData;
                self.overdueCompanyCardPage++;
                break;
            }
            case XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard: {
                self.isOverdueTerminalCardHaveData = isHaveData;
                self.overdueTerminalCardPage++;
                break;
            }
        }
        
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
        
        // yuan'mock
//        XKMineCouponPackageCardItem *cardItem = [XKMineCouponPackageCardItem new];
//        cardItem.cardType = @"GENERAL";
//        cardItem.discount = @"0.1";
//        cardItem.invalidTime = 1538327520;
//        cardItem.validTime = 1000000000;
//        cardItem.memberId = @"5ba899ea84912c1e90acee6d";
//        cardItem.message = @"XXX";
//        cardItem.name = @"普通";
//        cardItem.storeId = @"123123123";
//        cardItem.storeName = @"asdfsdf";
//        cardItem.userMemberId = @"123213";
//        [tempDataArr addObject:cardItem];
//        self.currentDataArr = tempDataArr;
//        [self.tableView reloadData];
        
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
        case XKMineCouponPackageCardViewControllerTypeNormalCompanyCard: {
            isHaveData = self.isCompanyCardHaveData;
            break;
        }
        case XKMineCouponPackageCardViewControllerTypeNormalTerminalCard: {
            isHaveData = self.isTerminalCardHaveData;
            break;
        }
        case XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard: {
            isHaveData = self.isOverdueCompanyCardHaveData;
            break;
        }
        case XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard: {
            isHaveData = self.isOverdueTerminalCardHaveData;
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
        
        // 下拉刷新 & 上拉加载
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            switch (weakSelf.type) {
                case XKMineCouponPackageCardViewControllerTypeNormalCompanyCard: {
                    weakSelf.companyCardPage = 1;
                    break;
                }
                case XKMineCouponPackageCardViewControllerTypeNormalTerminalCard: {
                    weakSelf.terminalCardPage = 1;
                    break;
                }
                case XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard: {
                    weakSelf.overdueCompanyCardPage = 1;
                    break;
                }
                case XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard: {
                    weakSelf.overdueTerminalCardPage = 1;
                    break;
                }
            }
            [weakSelf loadViewData:weakSelf.type isBackgroundLoad:NO];
        }];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadViewData:self.type isBackgroundLoad:NO];
        }];
        
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray *)companyCardDataArr {
    
    if (!_companyCardDataArr) {
        _companyCardDataArr = @[].mutableCopy;
    }
    return _companyCardDataArr;
}

- (NSMutableArray *)terminalCardDataArr {
    
    if (!_terminalCardDataArr) {
        _terminalCardDataArr = @[].mutableCopy;
    }
    return _terminalCardDataArr;
}

- (NSMutableArray *)overdueCompanyCardDataArr {
    
    if (!_overdueCompanyCardDataArr) {
        _overdueCompanyCardDataArr = @[].mutableCopy;
    }
    return _overdueCompanyCardDataArr;
}

- (NSMutableArray *)overdueTerminalCardDataArr {
    
    if (!_overdueTerminalCardDataArr) {
        _overdueTerminalCardDataArr = @[].mutableCopy;
    }
    return _overdueTerminalCardDataArr;
}

- (NSMutableArray *)selectedGivenCardArr {
    
    if (!_selectedGivenCardArr) {
        _selectedGivenCardArr = @[].mutableCopy;
    }
    return _selectedGivenCardArr;
}

- (NSMutableArray *)selectedDeleteCardArr {
    
    if (!_selectedDeleteCardArr) {
        _selectedDeleteCardArr = @[].mutableCopy;
    }
    return _selectedDeleteCardArr;
}

@end
