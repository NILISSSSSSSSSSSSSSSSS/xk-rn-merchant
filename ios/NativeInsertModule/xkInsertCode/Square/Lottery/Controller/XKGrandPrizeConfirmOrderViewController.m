//
//  XKGrandPrizeConfirmOrderViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeConfirmOrderViewController.h"
#import "XKMallOrderSureAddressCell.h"
#import "XKMallOrderNoAddressCell.h"
#import "XKLatestSecretTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"
#import "XKMineConfigureRecipientListViewController.h"
#import "XKGrandPrizeResultViewController.h"

@interface XKGrandPrizeConfirmOrderViewController () <UITableViewDataSource, UITableViewDelegate, ConfigureRecipientListDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) XKMineConfigureRecipientItem *selectedAddress;

@end

@implementation XKGrandPrizeConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"确认订单" WithColor:[UIColor whiteColor]];
    [self postShippingAddressList];
}

- (void)initializeViews {
    [self.containView addSubview:self.tableView];
    [self.containView addSubview:self.bottomView];
    [self.bottomView addSubview:self.confirmBtn];
}

- (void)updateViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containView);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.containView);
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(105.0);
    }];
}

#pragma mark - privite method

- (void)confirmBtnAction {
//    [self postGrandPrizeConfirmOrder];
    XKGrandPrizeResultViewController *vc = [[XKGrandPrizeResultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - POST
// 收货地址列表
- (void)postShippingAddressList {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(20) forKey:@"limit"];
    [XKHudView showLoadingTo:self.containView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getRecipientListUrl] timeoutInterval:5.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (responseObject) {
                NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                NSArray *tempArray = [NSArray yy_modelArrayWithClass:[XKMineConfigureRecipientItem class] json:dict[@"data"]];
                for (XKMineConfigureRecipientItem *shippingAddress in tempArray) {
                    if ([shippingAddress.isDefault isEqualToString:@"1"]) {
//                        默认收货地址
                        self.selectedAddress = shippingAddress;
                        break;
                    }
                }
            }
            [self initializeViews];
            [self updateViews];
        });
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initializeViews];
            [self updateViews];
        });
    }];
}
// 大奖确认订单
- (void)postGrandPrizeConfirmOrder {
    [XKHudView showLoadingTo:self.containView animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:5.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView];
        XKGrandPrizeResultViewController *vc = [[XKGrandPrizeResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView];
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        收货地址
        if (self.selectedAddress) {
//            有收货地址
            XKMallOrderSureAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKMallOrderSureAddressCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateInfoWithAddressName:[NSString stringWithFormat:@"地址： %@%@%@%@",self.selectedAddress.provinceName ?: @"" ,self.selectedAddress.cityName ?: @"",self.selectedAddress.districtName ?: @"",self.selectedAddress.street ?: @""] phone:self.selectedAddress.phone userName:[NSString stringWithFormat:@"收货人：%@", self.selectedAddress.receiver ?: self.selectedAddress.receiver]];
            [cell cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 84.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
            return cell;
        } else {
//            无收货地址
            XKMallOrderNoAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKMallOrderNoAddressCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 57.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
            return cell;
        }
    } else {
//        大奖信息
        XKLatestSecretTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLatestSecretTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 110.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectedAddress) {
            return 84.0;
        } else {
            return 57.0;
        }
    }
    return 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XKMineConfigureRecipientListViewController *vc = [[XKMineConfigureRecipientListViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ConfigureRecipientListDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XKMineConfigureRecipientItem *)item {
    self.selectedAddress = item;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - getter setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XKMallOrderNoAddressCell class] forCellReuseIdentifier:NSStringFromClass([XKMallOrderNoAddressCell class])];
        [_tableView registerClass:[XKMallOrderSureAddressCell class] forCellReuseIdentifier:NSStringFromClass([XKMallOrderSureAddressCell class])];
        [_tableView registerClass:[XKLatestSecretTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLatestSecretTableViewCell class])];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = XKRegularFont(16.0);
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = XKMainRedColor;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end


