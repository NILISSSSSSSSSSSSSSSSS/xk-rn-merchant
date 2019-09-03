//
//  XKTradingAreaOrderPayViewController.m
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderPayViewController.h"
#import "XKTradingAreaPayStatusViewController.h"
#import "XKCheckoutCounterViewController.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderPayCouponCell.h"
#import "XKTradingAreaOrderPayTotalPriceCell.h"
#import "XKMallBottomTicketView.h"
#import "XKCommonSheetView.h"
#import "XKTradingAreaOrderPaySeviceCell.h"
#import "XKTradingAreaAddGoodsListViewController.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKStoreSectionHeaderView.h"
#import "XKSquareTradingAreaTool.h"
//模型
#import "XKTradingAreaOrderDetaiModel.h"
#import "XKTradingAreaGetPriceModel.h"
#import "XKTradingAreaOrderCouponModel.h"
#import "XKTradingAreaPrePayModel.h"

@class XKCheckoutCounterViewPaymentMethodModel;

static NSString * const firstCellID                 = @"firstCellID";
static NSString * const lastCellID                  = @"lastCellID";
static NSString * const otherCellID                 = @"otherCellID";
static NSString * const sectionHeaderViewID         = @"sectionHeaderViewID";

@interface XKTradingAreaOrderPayViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView            *tableView;
@property (nonatomic, strong) XKMallBottomTicketView *ticketBottomView;
@property (nonatomic, strong) XKCommonSheetView      *ticketBgView;

@property (nonatomic, strong) UIView     *bottomView;
@property (nonatomic, strong) UIButton   *bottomPriceBtn;
@property (nonatomic, strong) UIButton   *bottomPayBtn;
@property (nonatomic, copy  ) NSArray    *couponArray;

@property (nonatomic, strong) XKTradingAreaOrderCouponModel *selectedCouponModel;
@property (nonatomic, copy  ) NSString  *orderId;
@property (nonatomic, assign) CGFloat   totalPrice;
@property (nonatomic, assign) CGFloat   payPrice;
@property (nonatomic, assign) CGFloat   depositPrice;
@property (nonatomic, assign) CGFloat   refundPrice;
@property (nonatomic, assign) NSInteger canUseCouponNum;


@end

@implementation XKTradingAreaOrderPayViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];

    if (!self.orderId) {
        if (self.itemsArr.count) {
            OrderItems *items = self.itemsArr[0];
            self.orderId = items.orderId;
        }
    }
    //支付服务+加购 中的 服务 或者加购
    if ((self.type == PayViewType_service && !self.isMainOrder) || self.type == PayViewType_add) {
        if (self.type == PayViewType_add) {
            for (OrderItems *items in self.itemsArr) {
                for (PurchasesItem *item in items.purchases) {
                    self.totalPrice += item.platformShopPrice.floatValue;
                }
            }
            self.totalPrice = self.totalPrice / 100.0;
            
        } else {
            for (OrderItems *items in self.itemsArr) {
                self.totalPrice += items.platformShopPrice.floatValue;
            }
            self.totalPrice = self.totalPrice / 100.0;
        }
        self.payPrice = self.totalPrice;
        [self.bottomPriceBtn setAttributedTitle:[self setAttributedStrWithString1:@"应付金额：￥" price:self.totalPrice - self.refundPrice] forState:UIControlStateNormal];
        [self.bottomPayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    } else {
        //第一次获取价格 此时是总价
        [self getPayPrice:YES];
    }
    if (self.type == PayViewType_add || (self.type == PayViewType_service && !self.isMainOrder)) {//非主订单
        //不能选优惠券
    } else {
        [self getOrderCoupons];
    }
}

#pragma mark - request

- (void)getOrderCoupons {
    
    [XKSquareTradingAreaTool tradingAreaGetOrderCoupons:@{@"orderId":self.orderId ? self.orderId : @""}
                                                success:^(NSArray<XKTradingAreaOrderCouponModel *> *list) {
                                                    self.canUseCouponNum = 0;
                                                    for (XKTradingAreaOrderCouponModel *model in list) {
                                                        if (model.state) {
                                                            self.canUseCouponNum += 1;
                                                        }
                                                    }
                                                    self.couponArray = list;
                                                    [self.tableView reloadData];
                                                }
                                                faile:^(XKHttpErrror *error) {
                                                }];
}


- (void)getPayPrice:(BOOL)firstRequest {
    
    //获取价格
    [XKHudView showLoadingTo:self.tableView animated:YES];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:self.orderId ? self.orderId : @"" forKey:@"orderId"];
    if (self.selectedCouponModel) {
        [muDic setObject:@(self.selectedCouponModel.ID) forKey:@"userDiscountId"];
        [muDic setObject:self.selectedCouponModel.cardType ? self.selectedCouponModel.cardType : @"" forKey:@"discountType"];
    }
    [XKSquareTradingAreaTool tradingAreaOrderGetPayPrice:@{@"userAmountOrder":muDic} success:^(XKTradingAreaGetPriceModel *model) {
        [XKHudView hideHUDForView:self.tableView];
        if (firstRequest) {
            self.totalPrice = model.payPrice / 100.0;
        }
        self.payPrice = model.payPrice / 100.0;
        self.refundPrice = model.refundPrice / 100.0;
        self.depositPrice = model.depositPrice / 100.0;
        
        if (self.totalPrice > 0) {
            [self.bottomPriceBtn setAttributedTitle:[self setAttributedStrWithString1:@"应付金额：￥" price:self.payPrice] forState:UIControlStateNormal];
            [self.bottomPayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        } else {
            if (self.totalPrice == 0) {
                [self.bottomPriceBtn setAttributedTitle:[self setAttributedStrWithString1:@"应付金额：￥" price:self.totalPrice] forState:UIControlStateNormal];
                [self.bottomPayBtn setTitle:@"确认" forState:UIControlStateNormal];
            }
            if (self.refundPrice > 0) {
                [self.bottomPriceBtn setAttributedTitle:[self setAttributedStrWithString1:@"定金返还：￥" price:self.refundPrice] forState:UIControlStateNormal];
                [self.bottomPayBtn setTitle:@"确认" forState:UIControlStateNormal];
            }
        }
        [self.tableView reloadData];
        
    } faile:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
    }];
}

- (NSAttributedString *)setAttributedStrWithString1:(NSString *)str1 price:(CGFloat)price {
    
    NSAttributedString *attStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(str1).font(XKRegularFont(14)).textColor(HEX_RGB(0x222222));
        confer.text([NSString stringWithFormat:@"%.2f", price]).font(XKMediumFont(24)).textColor(HEX_RGB(0x222222));
    }];
    return attStr;
}

#pragma mark - Events

- (void)sureBtnClicked {
 
    [XKHudView showLoadingTo:self.tableView animated:YES];
    //预支付 确认订单
    if ([self.bottomPayBtn.currentTitle isEqualToString:@"确认"]) {
        //0元支付 或者 有退款
        [XKSquareTradingAreaTool tradingAreaOrderPrePayRefundOrder:@{@"orderId":self.orderId ? self.orderId : @"",
                                                                     @"refundPrice":@(self.refundPrice)}
                                                           success:^(id reslut) {
                                                               [XKHudView hideHUDForView:self.tableView];
                                                               [self backLastViewController];
                                                           } faile:^(XKHttpErrror *error) {
                                                               [XKHudView hideHUDForView:self.tableView];
                                                           }];
        
    } else {
    
        NSString *type = @"";
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        
        if (self.type == PayViewType_add) {
            type = @"1";
            [muDic setObject:self.orderId ? self.orderId : @"" forKey:@"orderId"];
        } else if (self.type == PayViewType_service && !self.isMainOrder) {
            //服务且非主单
            type = @"2";
            [muDic setObject:self.orderId ? self.orderId : @"" forKey:@"orderId"];
        } else {
            //主单
            type = @"3";
            NSMutableDictionary *subMuDic = [NSMutableDictionary dictionary];
            [subMuDic setObject:self.orderId ? self.orderId : @"" forKey:@"orderId"];
            [subMuDic setObject:@(self.payPrice * 100) forKey:@"payAmount"];
            if (self.selectedCouponModel) {
                [subMuDic setObject:self.selectedCouponModel.cardType ? self.selectedCouponModel.cardType : @"" forKey:@"discountType"];
                [subMuDic setObject:@(self.selectedCouponModel.ID) forKey:@"userDiscountId"];
            }
            [muDic setObject:subMuDic forKey:@"userAmountOrder"];
        }
        
        [XKSquareTradingAreaTool tradingAreaOrderPrePay:muDic typeStr:type success:^(XKTradingAreaPrePayModel *model) {
            [XKHudView hideHUDForView:self.tableView];
            
            XKCheckoutCounterViewController *vc = [[XKCheckoutCounterViewController alloc] init];
            vc.orderBody = model.body;
            vc.orderAmount = model.amount.floatValue;
            vc.paymentMethods = model.channelConfigs;
            [self.navigationController pushViewController:vc animated:YES];
            
        } faile:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.tableView];
        }];
    }
}

- (void)backLastViewController {
    //先返回订单详情 如果没有返回上一级界面
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKTradingAreaOrderDetailViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"支付订单" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomPriceBtn];
    [self.bottomView addSubview:self.bottomPayBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
        make.height.equalTo(@50);
    }];

    [self.bottomPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(25);
        make.top.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.bottomPayBtn.mas_left);
    }];
    [self.bottomPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView);
        make.width.equalTo(@105);
        make.top.bottom.equalTo(self.bottomView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.totalPrice == 0) {//0元订单
        return self.itemsArr.count + 1;//没有选择优惠券

    } else if (self.type == PayViewType_add) {
        return self.itemsArr.count + 1;//没有选择优惠券

    } else if (self.type == PayViewType_service) {
        if (self.isMainOrder) {
            return self.itemsArr.count + 2;//第一组价格  最后一组选优惠券
        } else {
            return self.itemsArr.count + 1;//没有选择优惠券
        }
    } else if (self.type == PayViewType_offline) {
        return self.itemsArr.count + 2;//第一组价格  最后一组选优惠券

    } else if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
        return 3;//第一组价格  最后一组选优惠券
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
            if (section == 1) {
                return self.itemsArr.count;
            }
            return 1;
        } else {
            //优惠券选择
            if (section == self.itemsArr.count + 1) {
                return 1;
            } else {
                if (self.type == PayViewType_service) {
                    return 1;
                } else {
                    NSInteger index = section - 1;
                    if (self.itemsArr.count > index) {
                        OrderItems *items = self.itemsArr[index];
                        return items.purchases.count;
                    }
                }
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XKTradingAreaOrderPayTotalPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellID];
        if (!cell) {
            cell = [[XKTradingAreaOrderPayTotalPriceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:firstCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        }
        if (self.refundPrice > 0) {
            [cell setTotalPriceValue:-self.refundPrice];
        } else {
            [cell setTotalPriceValue:self.totalPrice];
        }
        return cell;

    } else {
        
        if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
        
            if (indexPath.section == 1) {
                return [self returnSureGoodsInfoCell:indexPath tableView:tableView];
            } else {
                return [self returnOrderPayCouponCell:indexPath tableView:tableView];
            }
            
        } else {
            
            if (indexPath.section == self.itemsArr.count + 1) {
                
                return [self returnOrderPayCouponCell:indexPath tableView:tableView];

            } else {
                
                if (self.type == PayViewType_service) {
                    XKTradingAreaOrderPaySeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellID];
                    if (!cell) {
                        cell = [[XKTradingAreaOrderPaySeviceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:otherCellID];
                        XKWeakSelf(weakSelf);
                        cell.lookDetailBlock = ^() {
                            [weakSelf lookDetailClicked:indexPath.row];
                        };
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.xk_openClip = YES;
                        cell.xk_radius = 5;
                        cell.xk_clipType = XKCornerClipTypeAllCorners;
                    }
                    if (indexPath.section - 1 >= 0 && self.itemsArr.count > indexPath.section - 1) {
                        [cell setValueWithModel:self.itemsArr[indexPath.section - 1] appointRange:self.appointRange];
                    }
                    return cell;
                    
                } else {
                    return [self returnSureGoodsInfoCell:indexPath tableView:tableView];
                }
            }
        }
    }
}


- (XKOderSureGoodsInfoCell *)returnSureGoodsInfoCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellID];
    if (!cell) {
        cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:otherCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
    }
    
    NSInteger index = indexPath.section - 1;
    if (self.itemsArr.count > index) {
        OrderItems *items = self.itemsArr[index];

        if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
            if (indexPath.row == self.itemsArr.count - 1) {
                [cell hiddenLineView:YES];
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                [cell hiddenLineView:NO];
                cell.xk_clipType = XKCornerClipTypeNone;
            }
            [cell setValueWithModel:items];
        } else {
            if (indexPath.row == items.purchases.count - 1) {
                [cell hiddenLineView:YES];
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                [cell hiddenLineView:NO];
                cell.xk_clipType = XKCornerClipTypeNone;
            }
            [cell setValueWithPurchasesModel:items.purchases[indexPath.row] orderTpye:nil];
        }
        
        [cell hiddenStatusBtn:YES];

        
    }
    return cell;
}


- (XKTradingAreaOrderPayCouponCell *)returnOrderPayCouponCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    XKTradingAreaOrderPayCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:lastCellID];
    if (!cell) {
        cell = [[XKTradingAreaOrderPayCouponCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:lastCellID];
        XKWeakSelf(weakSelf);
        cell.chooseCouponBlock = ^() {
            [weakSelf chooseCouponButtonClicked];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.xk_clipType = XKCornerClipTypeAllCorners;
    }
    [cell setValueWithModel:self.selectedCouponModel totalPrice:self.totalPrice reducePrice:self.totalPrice - self.payPrice depositPrice:self.depositPrice couponNum:self.canUseCouponNum];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == PayViewType_service) {
        return 0;
    } else if (self.type == PayViewType_add) {
        if (section == self.itemsArr.count + 1 || section == 0) {
            return 0;
        }
        return 50;
    } else if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
        if (section == 1) {
            return 50;
        }
        return 0;
    } else if (self.type == PayViewType_offline) {
        
        if (section == self.itemsArr.count + 1 || section == 0) {
            return 0;
        }
        return 50;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (self.type == PayViewType_service) {
        return nil;
    } else if (self.type == PayViewType_add) {
        if (section == self.itemsArr.count + 1 || section == 0) {
            return nil;
        }
        //
    } else if (self.type == PayViewType_takeoutSelfTake || self.type == PayViewType_takeoutSend) {
        if (section == 1) {
            //
        } else {
            return nil;
        }
    } else if (self.type == PayViewType_offline) {
        if (section == self.itemsArr.count + 1 || section == 0) {
            return nil;
        } else {
            //
        }
    }
    
    XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
    if (!sectionHeaderView) {
        sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
        sectionHeaderView.backView.xk_openClip = YES;
        sectionHeaderView.backView.xk_radius = 5;
        sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopBoth;
    }
    NSString *titleName = @"";
    if (self.type == PayViewType_takeoutSelfTake) {
        titleName = @"到店自提";
    } else if (self.type == PayViewType_takeoutSend) {
        titleName = @"配送上门";
    } else {
        OrderItems *items;
        NSInteger index = section - 1;
        if (index >= 0 && index < self.itemsArr.count) {
            items = self.itemsArr[index];
        }
        titleName = items.seatName;
    }
    [sectionHeaderView setTitleName:titleName titleColor:HEX_RGB(0x222222) titleFont:XKMediumFont(16)];
    return sectionHeaderView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - customDelegate


#pragma mark - coustomBlock

- (void)lookDetailClicked:(NSInteger)index {
    
    XKTradingAreaAddGoodsListViewController *vc = [[XKTradingAreaAddGoodsListViewController alloc] init];
    vc.listType = GoodsListType_lookGoods;
    OrderItems *items = self.itemsArr[index];
    vc.seatName = items.seatName;
    vc.goodsArr = items.purchases;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)chooseCouponButtonClicked {
    
    [self.ticketBottomView setDataArr:self.couponArray];
    [self.ticketBgView show];
}

- (void)tradingAreaChosed:(XKTradingAreaOrderCouponModel *)item {
    [self.ticketBgView dismiss];
    self.selectedCouponModel = item;
    [self getPayPrice:NO];
}


#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (UIButton *)bottomPayBtn {
    if (!_bottomPayBtn) {
        _bottomPayBtn = [[UIButton alloc] init];
        _bottomPayBtn.titleLabel.font = XKMediumFont(17);
        [_bottomPayBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bottomPayBtn setBackgroundColor:XKMainTypeColor];
        [_bottomPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomPayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        
    }
    return _bottomPayBtn;
}

- (UIButton *)bottomPriceBtn {
    if (!_bottomPriceBtn) {
        _bottomPriceBtn = [[UIButton alloc] init];
        _bottomPriceBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_bottomPriceBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_bottomPriceBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    }
    return _bottomPriceBtn;
}


- (XKMallBottomTicketView *)ticketBottomView {
    if (!_ticketBottomView) {
        XKWeakSelf(weakSelf);
        _ticketBottomView = [[XKMallBottomTicketView alloc] initWithTicketArr:nil titleStr:@"可用卡券"];
        _ticketBottomView.viewType = TicketViewType_tradingArea;
        _ticketBottomView.tradingAreaChoseBlock = ^(XKTradingAreaOrderCouponModel *item) {
            [weakSelf tradingAreaChosed:item];
        };
    }
    return _ticketBottomView;
}

- (XKCommonSheetView *)ticketBgView {
    if (!_ticketBgView) {
        _ticketBgView = [[XKCommonSheetView alloc] init];
        _ticketBgView.contentView = self.ticketBottomView;
        [_ticketBgView addSubview:self.ticketBottomView];
    }
    return _ticketBgView;
}


@end
