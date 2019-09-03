//
//  XKTradingAreaAddGoodsListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaAddGoodsListViewController.h"
#import "XKTradingAreaOrderPayViewController.h"
#import "XKOderSureGoodsInfoCell.h"
#import "XKStoreSectionHeaderView.h"
#import "XKOrderSureGoodsInfoFooterView.h"
#import "XKTradingAreaShopCarManager.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaOrderDetaiModel.h"

static NSString * const goodsInfoCellID               = @"goodsInfoCellID";
static NSString * const addGoodsInfoFooterViewID      = @"addGoodsInfoFooterViewID";


@interface XKTradingAreaAddGoodsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *footerView;
@property (nonatomic, strong) UIButton    *footerButton;
@property (nonatomic, strong) UIButton    *allChooseBtn;


@end


@implementation XKTradingAreaAddGoodsListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configViews];
}

#pragma mark - Events

- (void)footerBtnClicked:(UIButton *)sender {
    
    //提交
    
    if (self.listType == GoodsListType_addGoods) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        [muDic setObject:self.orderId ? self.orderId : @"" forKey:@"orderId"];
        [muDic setObject:self.itemId ? self.itemId : @"" forKey:@"itemId"];

        NSMutableArray *muarr = [NSMutableArray array];
        for (NSArray *arr in self.goodsArr) {
            for (GoodsSkuVOListItem *skuItem in arr) {
                NSDictionary *dic = @{@"goodsId":skuItem.goodsId ? skuItem.goodsId : @"",
                                      @"goodsSkuCode":skuItem.skuCode ? skuItem.skuCode : @""
                                      };
                [muarr addObject:dic];
            }
        }
        [muDic setObject:muarr forKey:@"goods"];

        [XKSquareTradingAreaTool tradingAreaOrderAddGoods:muDic success:^(NSArray<XKTradingAreaAddGoodSuccessModel *> *list) {
            //清空对应类型的购物车
            [[XKTradingAreaShopCarManager shareManager] clearnShopCarWithShopId:self.shopId industryType:XKIndustryType_offline];
            [self backOrderDetailVC];
        } faile:^(XKHttpErrror *error) {
            
        }];
        
    } else if (self.listType == GoodsListType_payAddGoods) {
        
        XKTradingAreaOrderPayViewController *vc = [[XKTradingAreaOrderPayViewController alloc] init];
        vc.itemsArr = self.goodsArr;
        vc.type = PayViewType_add;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (self.listType == GoodsListType_refundGoods) {
        
        NSMutableArray *muArr = [NSMutableArray array];
        for (PurchasesItem *item in self.goodsArr) {
            if (item.isSelected) {
                [muArr addObject:item];
            }
        }
        if (muArr.count == 0) {
            [XKHudView showErrorMessage:@"您暂未选择！"];
            return;
        }
        /*
         暂无这种情况
         */
    }
}


- (void)allChooseButtonClicked:(UIButton *)sender {
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (PurchasesItem *item in self.goodsArr) {
        item.isSelected = YES;
        [muArr addObject:item];
    }
    self.goodsArr = muArr.copy;
    [self.tableView reloadData];
}


- (void)backOrderDetailVC {
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKTradingAreaOrderDetailViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    if (self.listType == GoodsListType_addGoods) {
        [self setNavTitle:@"确认加购" WithColor:[UIColor whiteColor]];
    } else if (self.listType == GoodsListType_refundGoods) {
        [self setNavTitle:@"选择商品" WithColor:[UIColor whiteColor]];
        [self setNaviCustomView:self.allChooseBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
    } else if (self.listType == GoodsListType_lookGoods) {
        [self setNavTitle:self.seatName WithColor:[UIColor whiteColor]];
        self.footerButton.hidden = YES;
    } else if (self.listType == GoodsListType_payAddGoods) {
        [self setNavTitle:@"加购结算" WithColor:[UIColor whiteColor]];
    }
}

- (void)configViews {
    
//    [self.footerView addSubview:self.footerButton];
//    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerButton.mas_top).offset(0);
    }];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listType == GoodsListType_payAddGoods) {
        return self.goodsArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listType == GoodsListType_payAddGoods) {
        OrderItems *items = self.goodsArr[section];
        return items.purchases.count;
    }
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XKOderSureGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellID];
    if (!cell) {
        cell = [[XKOderSureGoodsInfoCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell hiddenLineView:NO];
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    
    if (self.listType == GoodsListType_refundGoods) {
    
        [cell showSelectedBtn:YES];
        [cell setValueWithPurchasesModel:self.goodsArr[indexPath.row] orderTpye:nil];
        [cell hiddenStatusBtn:YES];
        
    } else if (self.listType == GoodsListType_addGoods) {
        
        NSArray *arr = self.goodsArr[indexPath.row];
        [cell setValueWithModel:arr.count ? arr[0] : nil num:arr.count];
        
    } else if (self.listType == GoodsListType_payAddGoods) {
        
        OrderItems *items = self.goodsArr[indexPath.section];
        NSArray *arr = items.purchases;
        [cell setValueWithPurchasesModel:arr[indexPath.row] orderTpye:nil];
        [cell hiddenStatusBtn:YES];
        
    } else if (self.listType == GoodsListType_lookGoods) {

        [cell setValueWithPurchasesModel:self.goodsArr[indexPath.row] orderTpye:nil];
        if (self.goodsArr.count == 1) {
            cell.xk_clipType = XKCornerClipTypeAllCorners;
            [cell hiddenLineView:YES];
        } else {
            if (indexPath.row == 0) {
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                [cell hiddenLineView:NO];
            } else if (self.goodsArr.count == indexPath.row + 1) {
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
                [cell hiddenLineView:YES];
            } else {
                cell.xk_clipType = XKCornerClipTypeNone;
                [cell hiddenLineView:NO];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listType == GoodsListType_refundGoods) {
        PurchasesItem *item = self.goodsArr[indexPath.row];
        item.isSelected = !item.isSelected;
        
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.goodsArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:item];
        self.goodsArr = muArr.copy;
        [self.tableView reloadData];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.listType == GoodsListType_addGoods || self.listType == GoodsListType_payAddGoods) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.listType == GoodsListType_addGoods || self.listType == GoodsListType_payAddGoods) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.listType == GoodsListType_addGoods || self.listType == GoodsListType_payAddGoods) {
        XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"addHeader"];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:@"addHeader"];
            
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopBoth;
        }
        if (self.listType == GoodsListType_addGoods) {
            [sectionHeaderView setTitleName:@"加购商品" titleColor:HEX_RGB(0x222222) titleFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        } else if (self.listType == GoodsListType_payAddGoods) {
            OrderItems *items = self.goodsArr[section];
            [sectionHeaderView setTitleName:items.seatName titleColor:HEX_RGB(0x222222) titleFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        }

        return sectionHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.listType == GoodsListType_addGoods || self.listType == GoodsListType_payAddGoods) {
        XKOrderSureGoodsInfoFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:addGoodsInfoFooterViewID];
        if (!sectionFooterView) {
            sectionFooterView = [[XKOrderSureGoodsInfoFooterView alloc] initWithReuseIdentifier:addGoodsInfoFooterViewID];
            [sectionFooterView hiddenLine1View:YES line2View:YES];
            sectionFooterView.xk_openClip = YES;
            sectionFooterView.xk_radius = 5;
            sectionFooterView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        }
        CGFloat price = 0;
        CGFloat totalPrice = 0;
        
        if (self.listType == GoodsListType_addGoods) {
            for (NSArray *arr in self.goodsArr) {
                for (GoodsSkuVOListItem *skuItem in arr) {
                    price += skuItem.discountPrice.floatValue;
                    totalPrice += skuItem.originalPrice.floatValue;
                }
            }
            
        } else if (self.listType == GoodsListType_payAddGoods) {
            OrderItems *items = self.goodsArr[section];
            for (PurchasesItem *item in items.purchases) {
                price += item.platformShopPrice.floatValue;
                totalPrice += item.originalPrice.floatValue;
            }
        }
        price = price / 100.0;
        totalPrice = totalPrice / 100.0;
        [sectionFooterView setPriceValue:[NSString stringWithFormat:@"%.2f", price] totalPrice:[NSString stringWithFormat:@"%.2f", totalPrice]];
        return sectionFooterView;
    }
    return nil;
}


#pragma mark - customDelegate


#pragma mark - costomBlock

#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UIButton *)footerButton {
    if (!_footerButton) {
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
        _footerButton.backgroundColor = XKMainTypeColor;
//        _footerButton.layer.masksToBounds = YES;
//        _footerButton.layer.cornerRadius = 5;
        if (self.listType == GoodsListType_payAddGoods) {
            [_footerButton setTitle:@"结算" forState:UIControlStateNormal];
        } else {
            [_footerButton setTitle:@"确定" forState:UIControlStateNormal];
        }
        _footerButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(footerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    return _footerView;
}



- (UIButton *)allChooseBtn {
    if (!_allChooseBtn) {
        _allChooseBtn = [[UIButton alloc] init];
        [_allChooseBtn addTarget:self action:@selector(allChooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_allChooseBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allChooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _allChooseBtn;
}

@end
