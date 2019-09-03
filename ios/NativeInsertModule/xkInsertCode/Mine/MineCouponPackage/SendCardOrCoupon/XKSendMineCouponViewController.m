//
//  XKSendMineCouponViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSendMineCouponViewController.h"
#import "XKMineCouponPackageCompanyCardTableViewCell.h"
#import "XKMineCouponPackageTerminalCardTableViewCell.h"
#import "XKMineCouponPackageCompanyCouponTableViewCell.h"
#import "XKMineCouponPackageTerminalCouponTableViewCell.h"
#import "XKMineCouponPackageTerminalCouponTableViewHeader.h"
#import "XKMineCouponPackageTerminalCouponTableViewFooter.h"
#import "XKMineCouponPackageCardModel.h"
#import "XKMineCouponPackageCouponModel.h"

typedef NS_ENUM(NSInteger, XKSendMineCouponViewControllerType) {
    XKSendMineCouponViewControllerSendCompanyCard = 1,        /**< 赠送晓可折扣卡 */
    XKSendMineCouponViewControllerSendTerminalCard,           /**< 赠送商户折扣卡 */
    XKSendMineCouponViewControllerSendCompanyCoupon,          /**< 赠送晓可优惠券 */
    XKSendMineCouponViewControllerSendTerminalCoupon          /**< 赠送商户优惠券 */
};

@interface XKSendMineCouponViewController () <UITableViewDelegate, UITableViewDataSource, XKMineCouponPackageCompanyCardTableViewCellDelegate, XKMineCouponPackageTerminalCardTableViewCellDelegate, XKMineCouponPackageCompanyCouponTableViewCellDelegate, XKMineCouponPackageTerminalCouponTableViewCellDelegate, XKMineCouponPackageTerminalCouponTableViewFooterDelegate>

//@property (nonatomic, strong) UIButton *givenButton;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *extensionView;
@property (nonatomic, strong) UIButton *makeSureButton;

@property (nonatomic, assign) XKSendMineCouponViewControllerType type;
@property (nonatomic, strong) NSMutableArray *companyCardDataArr;
@property (nonatomic, strong) NSMutableArray *terminalCardDataArr;
@property (nonatomic, strong) NSMutableArray *companyCouponDataArr;
@property (nonatomic, strong) NSMutableArray *terminalCouponDataArr;
@property (nonatomic, assign) NSInteger companyCardCurrentPage;
@property (nonatomic, assign) NSInteger terminalCardCurrentPage;
@property (nonatomic, assign) NSInteger companyCouponCurrentPage;
@property (nonatomic, assign) NSInteger terminalCouponCurrentPage;
@property (nonatomic, assign) BOOL isCompanyCardHaveData;
@property (nonatomic, assign) BOOL isTerminalCardHaveData;
@property (nonatomic, assign) BOOL isCompanyCouponHaveData;
@property (nonatomic, assign) BOOL isTerminalCouponHaveData;
@property (nonatomic, strong) NSMutableArray *selectedDataArr;

@end

@implementation XKSendMineCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化页面
    [self initializeViews];
    
    // 初始化当前分页
    self.companyCardCurrentPage = 1;
    self.terminalCardCurrentPage = 1;
    self.companyCouponCurrentPage = 1;
    self.terminalCouponCurrentPage = 1;
    
    // 初始化区脚状态
    self.isCompanyCardHaveData = YES;
    self.isTerminalCardHaveData = YES;
    self.isCompanyCouponHaveData = YES;
    self.isTerminalCouponHaveData = YES;
    
    // 初始化页面数据
    [self loadViewData:XKSendMineCouponViewControllerSendCompanyCard isBackgroundLoad:NO];
    [self loadViewData:XKSendMineCouponViewControllerSendTerminalCard isBackgroundLoad:YES];
    [self loadViewData:XKSendMineCouponViewControllerSendCompanyCoupon isBackgroundLoad:YES];
    [self loadViewData:XKSendMineCouponViewControllerSendTerminalCoupon isBackgroundLoad:YES];
    
    self.type = XKSendMineCouponViewControllerSendCompanyCard;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (self.type) {
        case XKSendMineCouponViewControllerSendCompanyCard:
        case XKSendMineCouponViewControllerSendTerminalCard: {
            return 1;
        }
        case XKSendMineCouponViewControllerSendCompanyCoupon: {
            return self.companyCouponDataArr.count;
        }
        case XKSendMineCouponViewControllerSendTerminalCoupon: {
            return self.terminalCouponDataArr.count;
        }
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.type) {
        case XKSendMineCouponViewControllerSendCompanyCard: {
            return self.companyCardDataArr.count;
        }
        case XKSendMineCouponViewControllerSendTerminalCard: {
            return self.terminalCardDataArr.count;
        }
        case XKSendMineCouponViewControllerSendCompanyCoupon: {
            XKMineCouponPackageCouponModelDataItem *dataItem = self.companyCouponDataArr[section];
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
        case XKSendMineCouponViewControllerSendTerminalCoupon: {
            XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[section];
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
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == XKSendMineCouponViewControllerSendCompanyCard ||
        self.type == XKSendMineCouponViewControllerSendTerminalCard) {
        return 120.0;
    } else {
        return 110.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.type == XKSendMineCouponViewControllerSendTerminalCoupon) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.type == XKSendMineCouponViewControllerSendTerminalCoupon) {
        XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[section];
        if (dataItem.isNeedSimplify) {
            return 30;
        }
    }
    return 0;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.type == XKSendMineCouponViewControllerSendTerminalCoupon) {
        XKMineCouponPackageTerminalCouponTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewHeader"];
        XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[section];
        header.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
        [header configHeaderViewWithModel:dataItem];
        return header;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.type == XKSendMineCouponViewControllerSendTerminalCoupon) {
        XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[section];
        if (dataItem.isNeedSimplify) {
            XKMineCouponPackageTerminalCouponTableViewFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewFooter"];
            footer.delegate = self;
            XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[section];
            footer.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
            [footer configFooterViewWithModel:dataItem];
            return footer;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {
        // 晓可卡
        case XKSendMineCouponViewControllerSendCompanyCard: {
            XKMineCouponPackageCompanyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell"];
            cell.delegate = self;
            [cell configCellWithModel:self.companyCardDataArr[indexPath.row]];
            [cell showSelectButton];
            [cell showCountChangeView];
            [cell showCountLabel];
            return cell;
        }
        // 商户卡
        case XKSendMineCouponViewControllerSendTerminalCard: {
            XKMineCouponPackageTerminalCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell"];
            cell.delegate = self;
            [cell configCellWithModel:self.terminalCardDataArr[indexPath.row]];
            [cell showSelectButton];
            [cell showCountChangeView];
            [cell showCountLabel];
            return cell;
        }
        // 晓可券
        case XKSendMineCouponViewControllerSendCompanyCoupon: {
            XKMineCouponPackageCompanyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            XKMineCouponPackageCouponModelDataItem *dataItem = self.companyCouponDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configCellWithModel:couponItem];
            [cell showSelectButton];
            [cell showCountChangeView];
            [cell showCountLabel];
            return cell;
        }
        // 商户券
        case XKSendMineCouponViewControllerSendTerminalCoupon: {
            XKMineCouponPackageTerminalCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell"];
            cell.delegate = self;
            XKMineCouponPackageCouponModelDataItem *dataItem = self.terminalCouponDataArr[indexPath.section];
            XKMineCouponPackageCouponItem *couponItem = dataItem.coupons[indexPath.row];
            [cell configCellWithModel:couponItem];
            [cell showSelectButton];
            [cell showCountChangeView];
            [cell showCountLabel];
            return cell;
        }
    }
}

#pragma mark - XKMineCouponPackageCompanyCardTableViewCellDelegate

// 选择晓可卡
- (void)companyCardTableViewCell:(XKMineCouponPackageCompanyCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem {
    
    if (cardItem.isSelected == NO) {
        [self.selectedDataArr removeObject:cardItem];
    } else {
        [self.selectedDataArr addObject:cardItem];
    }
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCardTableViewCellDelegate

// 选择商户卡
- (void)terminalCardTableViewCell:(XKMineCouponPackageTerminalCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem {
    
    if (cardItem.isSelected == NO) {
        [self.selectedDataArr removeObject:cardItem];
    } else {
        [self.selectedDataArr addObject:cardItem];
    }
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageCompanyCouponTableViewCellDelegate

// 选择晓可券
- (void)companyCouponTableViewCell:(XKMineCouponPackageCompanyCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem {
    
    if (couponItem.isSelected == NO) {
        [self.selectedDataArr removeObject:couponItem];
    } else {
        [self.selectedDataArr addObject:couponItem];
    }
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCouponTableViewCellDelegate

// 选择商户券
- (void)terminalCouponTableViewCell:(XKMineCouponPackageTerminalCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem {
    
    if (couponItem.isSelected == NO) {
        [self.selectedDataArr removeObject:couponItem];
    } else {
        [self.selectedDataArr addObject:couponItem];
    }
    [self.tableView reloadData];
}

#pragma mark - XKMineCouponPackageTerminalCouponTableViewFooterDelegate

- (void)tableViewFooter:(XKMineCouponPackageTerminalCouponTableViewFooter *)footer updateModel:(XKMineCouponPackageCouponModelDataItem *)model {
    
    [self.tableView reloadData];
}

#pragma mark - private method

- (void)initializeViews {
    
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    
    // 导航栏
    [self setNavTitle:@"卡券包" WithColor:[UIColor whiteColor]];
    [self hideNavigationSeperateLine];
    //    UIButton *givenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [givenButton setTitle:@"发红包" forState:UIControlStateNormal];
    //    [givenButton addTarget:self action:@selector(clickGivenButton:) forControlEvents:UIControlEventTouchUpInside];
    //    givenButton.titleLabel.tintColor = [UIColor whiteColor];
    //    [self setRightView:givenButton withframe:CGRectMake(20, 20, 100, 24)];
    //    self.givenButton = givenButton;
    
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
    UIControl *oneControl = [UIControl new];
    oneControl.tag = 1001;
    [extensionView addSubview:oneControl];
    [oneControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(extensionView.mas_left);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.25);
    }];
    UILabel *oneLabel = [UILabel new];
    oneLabel.textColor = [UIColor whiteColor];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [oneControl addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oneControl.mas_centerX);
        make.centerY.equalTo(oneControl.mas_centerY);
    }];
    
    UIControl *twoControl = [UIControl new];
    twoControl.tag = 1002;
    [extensionView addSubview:twoControl];
    [twoControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(oneControl.mas_right);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.25);
    }];
    UILabel *twoLabel = [UILabel new];
    twoLabel.textColor = [UIColor whiteColor];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [twoControl addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoControl.mas_centerX);
        make.centerY.equalTo(twoControl.mas_centerY);
    }];
    
    UIControl *threeControl = [UIControl new];
    threeControl.tag = 1003;
    [extensionView addSubview:threeControl];
    [threeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(twoControl.mas_right);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.25);
    }];
    UILabel *threeLabel = [UILabel new];
    threeLabel.textColor = [UIColor whiteColor];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    threeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [threeControl addSubview:threeLabel];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(threeControl.mas_centerX);
        make.centerY.equalTo(threeControl.mas_centerY);
    }];
    
    UIControl *fourControl = [UIControl new];
    fourControl.tag = 1004;
    [extensionView addSubview:fourControl];
    [fourControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_top);
        make.left.equalTo(threeControl.mas_right);
        make.bottom.equalTo(extensionView.mas_bottom);
        make.width.equalTo(extensionView.mas_width).multipliedBy(0.25);
    }];
    UILabel *fourLabel = [UILabel new];
    fourLabel.textColor = [UIColor whiteColor];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    fourLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [fourControl addSubview:fourLabel];
    [fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fourControl.mas_centerX);
        make.centerY.equalTo(fourControl.mas_centerY);
    }];
    
    oneLabel.text = @"晓可卡";
    [oneControl addTarget:self action:@selector(clickCardOrCoupon:) forControlEvents:UIControlEventTouchUpInside];
    twoLabel.text = @"商户卡";
    [twoControl addTarget:self action:@selector(clickCardOrCoupon:) forControlEvents:UIControlEventTouchUpInside];
    threeLabel.text = @"晓可券";
    [threeControl addTarget:self action:@selector(clickCardOrCoupon:) forControlEvents:UIControlEventTouchUpInside];
    fourLabel.text = @"商户券";
    [fourControl addTarget:self action:@selector(clickCardOrCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
    // 滑动选择视图
    self.switchingView = [UIView new];
    self.switchingView.backgroundColor = [UIColor whiteColor];
    [extensionView addSubview:self.switchingView];
    [self.switchingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@3);
        make.width.equalTo(@50);
        make.centerX.equalTo(oneControl.mas_centerX);
        make.bottom.equalTo(extensionView.mas_bottom);
    }];
    
    // 确定按钮
    UIButton *makeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [makeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureButton setTitle:@"确 定" forState:UIControlStateNormal];
    makeSureButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15.0];
    makeSureButton.backgroundColor = XKMainTypeColor;
    [makeSureButton addTarget:self action:@selector(clickGivenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeSureButton];
    [makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomSafeHeight);
        make.height.offset(44);
    }];
    self.makeSureButton = makeSureButton;
    
    // 卡列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extensionView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(makeSureButton.mas_top);
    }];
}

/** 获取数据 */
- (void)loadViewData:(XKSendMineCouponViewControllerType)type isBackgroundLoad:(BOOL)isBackgroundLoad {
    
    NSInteger page;
    NSDictionary *coupon;
    NSMutableArray *tempDataArr;
    NSString *url;
    
    switch (type) {
        case XKSendMineCouponViewControllerSendCompanyCard: {
            url = GetCardListUrl;
            coupon = @{@"xkModule": @"mall",
                       @"type": @(1)};
            page = self.companyCardCurrentPage;
            tempDataArr = self.companyCardDataArr;
            break;
        }
        case XKSendMineCouponViewControllerSendTerminalCard: {
            url = GetCardListUrl;
            coupon = @{@"xkModule": @"shop",
                       @"type": @(1)};
            page = self.terminalCardCurrentPage;
            tempDataArr = self.terminalCardDataArr;
            break;
        }
        case XKSendMineCouponViewControllerSendCompanyCoupon: {
            url = GetCouponListUrl;
            coupon = @{@"xkModule": @"mall",
                       @"type": @(1)};
            page = self.companyCouponCurrentPage;
            tempDataArr = self.companyCouponDataArr;
            break;
        }
        case XKSendMineCouponViewControllerSendTerminalCoupon: {
            url = GetCouponListUrl;
            coupon = @{@"xkModule": @"shop",
                       @"type": @(1)};
            page = self.terminalCouponCurrentPage;
            tempDataArr = self.terminalCouponDataArr;
            break;
        }
    }
    
    NSDictionary *params = @{@"limit": @(10),
                             @"page": @(page),
                             @"coupon": coupon};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        
        [XKHudView hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (page == 1) {
            [tempDataArr removeAllObjects];
        }
        
        NSInteger currentDataCount;
        
        // 卡
        if (type == XKSendMineCouponViewControllerSendCompanyCard ||
            type == XKSendMineCouponViewControllerSendTerminalCard) {
            
            
            // yuan'mock
//            XKMineCouponPackageCardItem *cardItem = [XKMineCouponPackageCardItem new];
//            cardItem.cardType = @"GENERAL";
//            cardItem.discount = @"0.1";
//            cardItem.invalidTime = 1538327520;
//            cardItem.validTime = 1000000000;
//            cardItem.memberId = @"5ba899ea84912c1e90acee6d";
//            cardItem.message = @"XXX";
//            cardItem.name = @"普通";
//            cardItem.storeId = @"123123123";
//            cardItem.storeName = @"asdfsdf";
//            cardItem.userMemberId = @"123213";
//            [tempDataArr addObject:cardItem];
            
            
            XKMineCouponPackageCardModel *model = [XKMineCouponPackageCardModel yy_modelWithJSON:responseObject];
            [tempDataArr addObjectsFromArray:model.data];
            for (XKMineCouponPackageCardItem *cardItem in tempDataArr) {
                cardItem.isSelected = NO;
            }
            currentDataCount = model.data.count;
            
        // 券
        } else {
            // yuan'mock
//            XKMineCouponPackageCouponModelDataItem *dataItem = [XKMineCouponPackageCouponModelDataItem new];
//            dataItem.shopId = @"234134";
//            dataItem.shopName = @"yuan'shop";
//            NSMutableArray *coupons = @[].mutableCopy;
//            XKMineCouponPackageCouponItem *couponItem = [XKMineCouponPackageCouponItem new];
//            couponItem.couponId = @"12323";
//            couponItem.invalidTime = 1538327520;
//            couponItem.message = @"XXX";
//            couponItem.couponName = @"yuan test";
//            couponItem.price = @"1000000";
//            couponItem.couponType = @"DISCOUNT";
//            couponItem.validTime = 1538190710;
//            couponItem.userCouponId = @"52";
//            [coupons addObject:couponItem];
//            [coupons addObject:couponItem];
//            [coupons addObject:couponItem];
//            dataItem.coupons = coupons.copy;
//            [tempDataArr addObject:dataItem];
            
            XKMineCouponPackageCouponModel *model =  [XKMineCouponPackageCouponModel yy_modelWithJSON:responseObject];
            for (XKMineCouponPackageCouponModelDataItem *dataItem in model.data) {
                if (dataItem.coupons.count > 2) {
                    dataItem.isNeedSimplify = YES;
                    dataItem.isShowingAll = NO;
                } else {
                    dataItem.isNeedSimplify = NO;
                    dataItem.isShowingAll = YES;
                }
            }
            currentDataCount = model.data.count;
            [tempDataArr addObjectsFromArray:model.data];
        }
        
        // 下拉刷新 & 上拉加载
        BOOL isHaveData;
        if (currentDataCount < 10) {
            isHaveData = NO;
        } else {
            isHaveData = YES;
        }
        switch (type) {
            case XKSendMineCouponViewControllerSendCompanyCard: {
                self.isCompanyCardHaveData = isHaveData;
                self.companyCardCurrentPage++;
                break;
            }
            case XKSendMineCouponViewControllerSendTerminalCard: {
                self.isTerminalCardHaveData = isHaveData;
                self.terminalCardCurrentPage++;
                break;
            }
            case XKSendMineCouponViewControllerSendCompanyCoupon: {
                self.isCompanyCouponHaveData = isHaveData;
                self.companyCouponCurrentPage++;
                break;
            }
            case XKSendMineCouponViewControllerSendTerminalCoupon: {
                self.isTerminalCouponHaveData = isHaveData;
                self.terminalCouponCurrentPage++;
                break;
            }
        }
        
        if (isBackgroundLoad) {
            // 后台加载数据不作任何操作
            return;
            
        } else {
            
            // 修改数据源、刷新区脚、刷新tableView
            [self reloadTableViewFooter];
            [self.tableView reloadData];
        }
    } failure:^(XKHttpErrror *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
        self.tableView.mj_footer.hidden = YES;
    }];
}

// 刷新区脚
- (void)reloadTableViewFooter {
    
    BOOL isHaveData;
    switch (self.type) {
        case XKSendMineCouponViewControllerSendCompanyCard: {
            isHaveData = self.isCompanyCardHaveData;
            break;
            
        }
        case XKSendMineCouponViewControllerSendTerminalCard: {
            isHaveData = self.isTerminalCardHaveData;
            break;
        }
        case XKSendMineCouponViewControllerSendCompanyCoupon: {
            isHaveData = self.isCompanyCouponHaveData;
            break;
        }
        case XKSendMineCouponViewControllerSendTerminalCoupon: {
            isHaveData = self.isTerminalCouponHaveData;
            break;
        }
    }
    if (isHaveData) {
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - events

// 点击确定赠送
- (void)clickGivenButton:(UIControl *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate sendMineCouponViewController:self selectedArray:self.selectedDataArr];
}

// 选择晓可卡/商户卡/晓可券/商户券
- (void)clickCardOrCoupon:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    self.type = sender.tag - 1000;
    [self reloadTableViewFooter];
    [self.tableView reloadData];
}

// 滑动选择滑块
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
        
        [_tableView registerClass:[XKMineCouponPackageCompanyCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageCompanyCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewHeader class] forHeaderFooterViewReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewHeader"];
        [_tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewFooter class] forHeaderFooterViewReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewFooter"];
        
        __weak typeof(self) weakSelf = self;
        // 下拉刷新 & 上拉加载
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            switch (weakSelf.type) {
                case XKSendMineCouponViewControllerSendCompanyCard: {
                    weakSelf.companyCardCurrentPage = 1;
                    break;
                }
                case XKSendMineCouponViewControllerSendTerminalCard: {
                    weakSelf.terminalCardCurrentPage = 1;
                    break;
                }
                case XKSendMineCouponViewControllerSendCompanyCoupon: {
                    weakSelf.companyCouponCurrentPage = 1;
                    break;
                }
                case XKSendMineCouponViewControllerSendTerminalCoupon: {
                    weakSelf.terminalCouponCurrentPage = 1;
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

- (NSMutableArray *)selectedDataArr {
    
    if (!_selectedDataArr) {
        _selectedDataArr = @[].mutableCopy;
    }
    return _selectedDataArr;
}


@end
