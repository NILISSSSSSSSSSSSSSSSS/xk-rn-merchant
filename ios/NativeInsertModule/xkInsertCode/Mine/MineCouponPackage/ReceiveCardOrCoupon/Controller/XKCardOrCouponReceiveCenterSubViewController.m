//
//  XKCardOrCouponReceiveCenterSubViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCardOrCouponReceiveCenterSubViewController.h"
#import "XKReceiveXKCardTableViewCell.h"
#import "XKReceiveMerchantCardTableViewCell.h"
#import "XKReceiveXKCouponTableViewCell.h"
#import "XKReceiveMerchantCouponTableViewCell.h"
#import "XKReceiveCardModel.h"
#import "XKReceiveCouponModel.h"

@interface XKCardOrCouponReceiveCenterSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger dataCount;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKCardOrCouponReceiveCenterSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[XKReceiveXKCardTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKReceiveXKCardTableViewCell class])];
    [self.tableView registerClass:[XKReceiveMerchantCardTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKReceiveMerchantCardTableViewCell class])];
    [self.tableView registerClass:[XKReceiveXKCouponTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKReceiveXKCouponTableViewCell class])];
    [self.tableView registerClass:[XKReceiveMerchantCouponTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKReceiveMerchantCouponTableViewCell class])];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postDatas];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.datas.count >= weakSelf.dataCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postDatas];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5.0, 0.0, 0.0, 0.0));
    }];
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -150.0;
    
    weakSelf.page = 1;
    [weakSelf postDatas];
}

#pragma mark - POST
// 获取数据
- (void)postDatas {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *urlStr;
    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard ||
        self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCard) {
        [para setObject:@"mall" forKey:@"module"];
        urlStr = [XKAPPNetworkConfig getCardsReceiveCenterUrl];
    } else {
        [para setObject:@"shop" forKey:@"module"];
        urlStr = [XKAPPNetworkConfig getCouponsReceiveCenterUrl];
    }
    [para setObject:@(self.page) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
    [HTTPClient postEncryptRequestWithURLString:urlStr timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.datas removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.dataCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard ||
                self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCard) {
                [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKReceiveCardModel class] json:dict[@"data"]]];
                for (XKReceiveCardModel *card in self.datas) {
                    card.isXKCard = self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard;
                }
            } else {
                [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKReceiveCouponModel class] json:dict[@"data"]]];
            }
            [self.tableView reloadData];
        }
        if (self.datas.count) {
            [self.emptyView hide];
        } else {
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.datas.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postDatas];
            }];
        }
    }];
}

- (void)postReceiveCardWithIndexPath:(NSIndexPath *) indexPath {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *urlStr;
    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard) {
//        晓可卡
        XKReceiveCardModel *XKCard = self.datas[indexPath.row];
        [para setObject:XKCard.memberId forKey:@"memberCardId"];
        urlStr = [XKAPPNetworkConfig getReceiveXKCardUrl];
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCard) {
//        商户卡
        XKReceiveCardModel *merchantCard = self.datas[indexPath.row];
        [para setObject:merchantCard.shopId forKey:@"storeId"];
        [para setObject:merchantCard.memberId forKey:@"memberCardId"];
        urlStr = [XKAPPNetworkConfig getReceiveMerchantCardUrl];
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCoupon) {
//        晓可券
        XKReceiveCouponModel *XKCoupon = self.datas[indexPath.row];
        [para setObject:XKCoupon.couponId forKey:@"couponId"];
        urlStr = [XKAPPNetworkConfig getReceiveXKCouponUrl];
    } else {
//        商户券
        XKReceiveCouponModel *merchantCoupon = self.datas[indexPath.row];
        [para setObject:merchantCoupon.shopId forKey:@"storeId"];
        [para setObject:merchantCoupon.couponId forKey:@"couponId"];
        urlStr = [XKAPPNetworkConfig getReceiveMerchantCouponUrl];
    }

    [HTTPClient postEncryptRequestWithURLString:urlStr timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(XKHttpErrror *error) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard) {
        XKReceiveXKCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKReceiveXKCardTableViewCell class]) forIndexPath:indexPath];
        XKReceiveCardModel *XKCard = self.datas[indexPath.row];
        [cell configCellWithCardModel:XKCard];
        return cell;
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCard) {
        XKReceiveXKCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKReceiveXKCardTableViewCell class]) forIndexPath:indexPath];
        XKReceiveCardModel *merchantCard = self.datas[indexPath.row];
        [cell configCellWithCardModel:merchantCard];
        return cell;
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCoupon) {
        XKReceiveXKCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKReceiveXKCouponTableViewCell class]) forIndexPath:indexPath];
        XKReceiveCouponModel *XKCoupon = self.datas[indexPath.row];
        [cell configCellWithModel:XKCoupon];
        cell.receiveBtnBlock = ^(XKReceiveCouponModel * _Nonnull coupon) {
            if (self.receiveCouponBtnBlock) {
                self.receiveCouponBtnBlock(XKCoupon);
            }
        };
        return cell;
    } else {
        XKReceiveMerchantCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKReceiveMerchantCouponTableViewCell class]) forIndexPath:indexPath];
        XKReceiveCouponModel *merchantCoupon = self.datas[indexPath.row];
        [cell configCellWithModel:merchantCoupon];
        cell.receiveBtnBlock = ^(XKReceiveCouponModel * _Nonnull coupon) {
            if (self.receiveCouponBtnBlock) {
                self.receiveCouponBtnBlock(merchantCoupon);
            }
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon) {
//        return 30.0;
//    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon) {
//        UIView *tempView = [[UIView alloc] init];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = @"戴森官方旗舰店";
//        label.font = XKRegularFont(14.0);
//        label.textColor = HEX_RGB(0x555555);
//        [tempView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
//        }];
//        return tempView;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCard) {
        return (110.0 * (SCREEN_WIDTH - 10.0)) / 355.0 + 10.0;
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCard) {
        return (110.0 * (SCREEN_WIDTH - 10.0)) / 355.0 + 10.0;
    } else if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeXKCoupon) {
        return (90.0 * (SCREEN_WIDTH - 10.0)) / 355.0 + 10.0;
    } else {
        return (90.0 * (SCREEN_WIDTH - 10.0)) / 355.0 + 10.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon) {
//        return 30.0;
//    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (self.vcType == XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon) {
//        UIView *tempView = [[UIView alloc] init];
//        UIView *tapView = [[UIView alloc] init];
//        [tempView addSubview:tapView];
//        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.mas_equalTo(tempView);
//            make.trailing.mas_equalTo(-10.0);
//        }];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = 1 ? @"更多" : @"收起";
//        label.font = XKRegularFont(12.0);
//        label.textColor = HEX_RGB(0x999999);
//        [tapView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.bottom.mas_equalTo(tapView);
//        }];
//        UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_img_receiveCenter_merchantCoupon_arrow_down")];
//        [tapView addSubview:arrowImgView];
//        arrowImgView.transform = CGAffineTransformMakeRotation(1 ? 0 : M_PI);
//        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(tapView);
//            make.left.mas_equalTo(label.mas_right).offset(5.0);
//            make.trailing.mas_equalTo(tapView);
//            make.size.mas_equalTo(arrowImgView.image.size);
//        }];
//        [tapView bk_whenTapped:^{
//
//        }];
//        return tempView;
//    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
