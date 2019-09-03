//
//  XKStoreEditMenuViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEditMenuViewController.h"
#import "XKStoreEidtMenuCollectionViewCell.h"
#import "XKMallTypeTableViewCell.h"
#import "XKMallTypeCollectionReusableView.h"
#import "XKCommonSheetView.h"
#import "XKStoreEidtChooseSpecificationView.h"
#import "XKStoreEidtMenuBottomShopCarView.h"
#import "XKTradingAreaGoodsDetailViewController.h"
#import "XKTradingAreaOfflineOrderSureViewController.h"
#import "XKTradingAreaAddGoodsListViewController.h"
#import "XKTradingAreaOnlineOrderSureViewController.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderReserveViewController.h"
#import "XKStoreReserveChooseSpecificationView.h"
#import "XKTradingAreaShopCarManager.h"
#pragma mark - 模型
#import "XKGoodsCoustomCategaryListModel.h"
#import "XKCategaryGoodsListModel.h"
#import "XKTradingAreaGoodsInfoModel.h"

static NSString * const collectionViewCellID          = @"RightCollectionViewCell";
static NSString * const tableViewCellID               = @"leftTableViewCell";
static NSString * const collectionViewReusableViewID  = @"collectionViewReusableViewID";


@interface XKStoreEditMenuViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EidtMenuCollectionViewDelegate>

@property (nonatomic, strong) UIView            *bottomView;
@property (nonatomic, strong) UIButton          *bottomShopCarBtn;
@property (nonatomic, strong) UILabel           *bottomTipLable;
@property (nonatomic, strong) UILabel           *bottomPriceLabel;
@property (nonatomic, strong) UIButton          *bottomGoBuyBtn;

@property (nonatomic, strong) UITableView      *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic ,strong) NSArray          *leftClassDataArr;
@property (nonatomic ,strong) NSArray          *rightCollectionDataArr;
@property (nonatomic ,assign) NSInteger        selectedIndex;
@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@property (nonatomic, assign) XKIndustryType   xkIndustryType;

//缓存
@property (nonatomic, strong) NSMutableDictionary *goodsInfoMuDic;
@property (nonatomic, strong) NSMutableDictionary *goodsListMuDic;

//外卖、现场购买
@property (nonatomic, strong) XKStoreEidtChooseSpecificationView *guigeChooseView;
@property (nonatomic, strong) XKCommonSheetView                  *chooseSheetView;
@property (nonatomic, strong) XKCommonSheetView                  *shopCarChooseSheetView;
@property (nonatomic, strong) XKStoreEidtMenuBottomShopCarView   *shopCarView;

//服务
@property (nonatomic, strong) XKStoreReserveChooseSpecificationView *reserveGuigeChooseView;
@property (nonatomic, strong) XKCommonSheetView                     *reserveChooseGuigeSheetView;

@end

@implementation XKStoreEditMenuViewController

#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    NSString *titel = @"";
    if (self.type == Type_hotel) {
        titel = @"酒店预定";
    } else if (self.type == Type_sever) {
        if (self.isAdd) {
            titel = @"服务加购";
        } else {
            titel = @"服务预定";
        }
    } else if (self.type == Type_offline) {
        if (self.isAdd) {
            titel = @"商品加购";
        } else {
            titel = @"商品选择";
        }
    } else if (self.type == Type_takeOut) {
        titel = @"菜单编辑";
    }
    [self setNavTitle:titel WithColor:[UIColor whiteColor]];
*/
    [self setNavTitle:@"商品选择" WithColor:[UIColor whiteColor]];

    self.xkIndustryType = 0;
    if (self.type == Type_takeOut) {
        self.xkIndustryType = XKIndustryType_online;
    } else if (self.type == Type_offline) {
        self.xkIndustryType = XKIndustryType_offline;
    }
    
    [self initViews];
    [self layoutViews];
    
    [self requestTradingAreaGoodsCoustomCategaryList];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.type == Type_offline) {
        [self refreshShopCarDataChangeShopCarViewHeight:YES];
    } else if (self.type == Type_takeOut) {
        [self refreshShopCarDataChangeShopCarViewHeight:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)requestTradingAreaGoodsCoustomCategaryList {

    [XKSquareTradingAreaTool tradingAreaGoodsCoustomCategaryList:@{@"shopId":self.shopId ? self.shopId : @"",
                                                                   @"serviceCatalogCode":self.severCode ? self.severCode : @""}
                                                           group:nil
                                                         success:^(NSArray<XKGoodsCoustomCategaryListModel *> *listArr) {
                                                             
        self.leftClassDataArr = listArr;
        if (listArr.count == 0) {
            self.emptyView.config.viewAllowTap = NO;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无相关数据" tapClick:nil];
        } else {
            [self.emptyView hide];
            [self.leftTableView reloadData];
            XKGoodsCoustomCategaryListModel *model = listArr[0];
            [self requestTradingAreaCategaryGoodsList:model.itemId];
        }
    }];
}



- (void)requestTradingAreaCategaryGoodsList:(NSString *)categaryCode {
    
    [XKSquareTradingAreaTool tradingAreaCategaryGoodsList:@{@"goodsClassificationId":categaryCode ? categaryCode : @"",
                                                            @"shopId":self.shopId ? self.shopId : @""}
                                                    group:nil
                                                  success:^(NSArray<XKCategaryGoodsListModel *> *listArr) {
    
                                                      if (listArr.count) {
                                                          [self.goodsListMuDic setObject:listArr forKey:categaryCode];
                                                      }
                                                      self.bottomView.hidden = NO;
                                                      self.rightCollectionDataArr = listArr;
                                                      [self.rightCollectionView reloadData];
        
    }];
    
}


#pragma mark - Events

- (void)clearShopCarData {
    
    
    [[XKTradingAreaShopCarManager shareManager] clearnShopCarWithShopId:self.shopId industryType:self.xkIndustryType];
    [self.shopCarView setValueWithModelArr:nil];
    [self.shopCarChooseSheetView dismiss];
    self.bottomPriceLabel.text = @"￥0";
    self.bottomTipLable.hidden = YES;
    self.bottomGoBuyBtn.backgroundColor = [UIColor grayColor];
    self.bottomGoBuyBtn.enabled = NO;
}

- (void)refreshShopCarDataChangeShopCarViewHeight:(BOOL)changeHeight {
    
    
    NSArray *arr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
    CGFloat price = 0;
    for (NSArray *subArr in arr) {
        if (subArr.count) {
            GoodsSkuVOListItem *item = subArr[0];
            price += subArr.count * item.discountPrice.floatValue;
        }
    }
    if (changeHeight) {
        CGFloat height = (arr.count * 50 + 100) > SCREEN_HEIGHT - 150 ? SCREEN_HEIGHT - 150 : (arr.count * 50 + 100);
        [self.shopCarView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
    }
    [self.shopCarView setValueWithModelArr:arr];
    
    self.bottomPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", price / 100.0];
    self.bottomTipLable.text = [NSString stringWithFormat:@"%d", (int)arr.count];

    if (arr.count) {
        self.bottomTipLable.hidden = NO;
        self.bottomGoBuyBtn.backgroundColor = XKMainTypeColor;
        self.bottomGoBuyBtn.enabled = YES;
    } else {
        //如果购物车没商品了就dismiss
        [self.shopCarChooseSheetView dismiss];
        self.bottomTipLable.hidden = YES;
        self.bottomGoBuyBtn.backgroundColor = [UIColor grayColor];
        self.bottomGoBuyBtn.enabled = NO;
    }
}

- (void)shopCarButtonClicked:(UIButton *)sender {
    if (self.bottomTipLable.hidden) {
        return;
    }
    [self.shopCarChooseSheetView show];
}
//去结算
- (void)goBuyBtnClicked:(UIButton *)sender {
    [self.shopCarChooseSheetView dismiss];

    if (self.isAdd) {
        
        XKTradingAreaAddGoodsListViewController *vc = [[XKTradingAreaAddGoodsListViewController alloc] init];
        vc.listType = GoodsListType_addGoods;
        vc.goodsArr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
        vc.orderId = self.orderId;
        vc.itemId = self.itemId;
        vc.shopId = self.shopId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        if (self.type == Type_takeOut) {
            XKTradingAreaOnlineOrderSureViewController *vc = [[XKTradingAreaOnlineOrderSureViewController alloc] init];
            vc.shopName = self.shopName;
            vc.shopId = self.shopId;
            vc.goodsArr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (self.type == Type_offline) {
            XKTradingAreaOfflineOrderSureViewController *vc = [[XKTradingAreaOfflineOrderSureViewController alloc] init];
            vc.shopName = self.shopName;
            vc.shopId = self.shopId;
            vc.goodsArr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



- (void)reserveGuigeChooseViewCloseButtonClicekd {
    [self.reserveChooseGuigeSheetView dismiss];
}

- (void)reserveGuigeChooseViewNextButtonCliceked:(GoodsSkuVOListItem *)skuItem time:(NSString *)time viewType:(SpecificationViewType)viewType {
    //生成订单
    [self.reserveChooseGuigeSheetView dismiss];
    
    XKTradingAreaOrderReserveViewController *VC = [[XKTradingAreaOrderReserveViewController alloc] init];
    
    VC.skuItem = skuItem;
//    VC.goodsDec = self.
    
    if (viewType == viewType_service) {
        VC.reserveVCType = OrderReserveVC_service;
        VC.reserveTime = time;
    } else if (viewType == viewType_hetol) {
        VC.reserveVCType = OrderReserveVC_hotel;
    }

    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - Private Metheods


- (void)initViews {
    
    if (self.type == Type_hotel || self.type == Type_sever) {
        
    } else {
        
        if (iPhoneX) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            line.backgroundColor = XKSeparatorLineColor;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBottomSafeHeight, SCREEN_WIDTH, kBottomSafeHeight)];
            view.backgroundColor = [UIColor whiteColor];
            [view addSubview:line];
            [self.view addSubview:view];
        }
        [self.view addSubview:self.bottomView];
        [self.bottomView addSubview:self.bottomShopCarBtn];
        [self.bottomView addSubview:self.bottomTipLable];
        [self.bottomView addSubview:self.bottomPriceLabel];
        [self.bottomView addSubview:self.bottomGoBuyBtn];
    }
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
}


- (void)layoutViews {
    
    if (self.type == Type_hotel || self.type == Type_sever) {
        
        [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.width.equalTo(@(114 * ScreenScale));
        }];
        
    } else {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
            make.height.equalTo(@50);
        }];
        [self.bottomShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.bottomView);
            make.width.equalTo(@60);
        }];
        [self.bottomTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView).offset(5);
            make.centerX.equalTo(self.bottomShopCarBtn).offset(8);
            make.height.equalTo(@14);
            make.width.greaterThanOrEqualTo(@14);
        }];
        [self.bottomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomShopCarBtn.mas_right);
            make.centerY.equalTo(self.bottomView);
        }];
        [self.bottomGoBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.bottomView);
            make.width.equalTo(@105);
        }];
        [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
            make.width.equalTo(@(114 * ScreenScale));
        }];
    }
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView.mas_top);
        make.left.equalTo(self.leftTableView.mas_right);
        make.bottom.equalTo(self.leftTableView.mas_bottom);
        make.right.equalTo(self.view);
    }];
}


#pragma mark - UITableviewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftClassDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMallTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[XKMallTypeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tableViewCellID];
    }
    XKGoodsCoustomCategaryListModel *model = self.leftClassDataArr[indexPath.row];
    
//    [cell setTitle:model.name titleColor:indexPath.row == self.selectedIndex ? XKMainTypeColor : HEX_RGB(0x222222)];
//    [cell setSelectedBackGroundViewColor:indexPath.row == self.selectedIndex ? [UIColor whiteColor] : HEX_RGB(0xf1f1f1)];
    
    [cell setTitle:model.name titleColor:HEX_RGB(0x222222)];
    [cell setSelectedBackGroundViewColor:HEX_RGB(0xf1f1f1)];
    [cell showSelectedView:indexPath.row == self.selectedIndex];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
//    [self.rightCollectionView scrollToItemAtIndexPath:index atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
    //在赋值前
    NSIndexPath *oldInxdexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    NSIndexPath *newInxdexPath = indexPath;
    //赋值
    self.selectedIndex = indexPath.row;
    
    [self.leftTableView reloadRowsAtIndexPaths:@[oldInxdexPath, newInxdexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    XKGoodsCoustomCategaryListModel *model = self.leftClassDataArr[indexPath.row];
    NSArray *arr = [self.goodsListMuDic objectForKey:model.itemId];
    if (arr.count) {
        self.rightCollectionDataArr = arr;
        [self.rightCollectionView reloadData];
    } else {
        [self requestTradingAreaCategaryGoodsList:model.itemId];
    }
}

#pragma mark -  UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
//    return self.leftClassDataArr.count;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.rightCollectionDataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreEidtMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell hiddenChooseView:YES hiddenChooseGuigeBtn:NO];
    CategaryGoodsItem *item = self.rightCollectionDataArr[indexPath.row];
    [cell setValueWithModel:item cellType:self.type == Type_hotel ? EidtMenuCellType_hotel : EidtMenuCellType_default indexPath:indexPath];
    
    return cell;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XKMallTypeCollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID forIndexPath:indexPath];
        [reusableView titleTextAlignmentBotton];
        
        XKGoodsCoustomCategaryListModel *model = self.leftClassDataArr[indexPath.row];
        [reusableView setTitleWithTitleStr:model.name titleColor:HEX_RGB(0x222222) font:XKRegularFont(14)];
    }
    return reusableView;
}*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CategaryGoodsItem *item = self.rightCollectionDataArr[indexPath.row];

    XKTradingAreaGoodsDetailViewController *vc = [[XKTradingAreaGoodsDetailViewController alloc] init];
    vc.goodsId = item.goodsId;
    vc.shopId = self.shopId;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - coustomDelegate

- (void)chooseGuigeButtonSelected:(UIButton *)sender {
    
    CategaryGoodsItem *item = self.rightCollectionDataArr[sender.tag];
    //从缓存取
    XKTradingAreaGoodsInfoModel *goodsModel = [self.goodsInfoMuDic objectForKey:item.goodsId];
    if (goodsModel) {
        [self showGuiGeChooseView:goodsModel];
        
    } else {
        [XKSquareTradingAreaTool tradingAreaGoodsDetail:@{@"shopId":self.shopId ? self.shopId : @"",
                                                          @"id":item.goodsId ? item.goodsId : @""}
                                                  group:nil
                                                success:^(XKTradingAreaGoodsInfoModel *model) {
                                                    //存缓存去
                                                    [self.goodsInfoMuDic setObject:model forKey:item.goodsId];
                                                    [self showGuiGeChooseView:model];
                                                }];
    }
}


- (void)showGuiGeChooseView:(XKTradingAreaGoodsInfoModel *)goodsModel {
    
    if (self.type == Type_sever) {
        [self.reserveGuigeChooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255 + (goodsModel.goodsSkuAttrsVO.attrList.count * 60) + kBottomSafeHeight)];
        [self.reserveGuigeChooseView setValueWithModel:goodsModel viewType:viewType_service];
        [self.reserveChooseGuigeSheetView show];
        
    } else if (self.type == Type_hotel) {
        [self.reserveGuigeChooseView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196 + (goodsModel.goodsSkuAttrsVO.attrList.count * 60) + kBottomSafeHeight)];
        [self.reserveGuigeChooseView setValueWithModel:goodsModel viewType:viewType_hetol];
        [self.reserveChooseGuigeSheetView show];
        
    } else {
        CGFloat height = 130 + goodsModel.goodsSkuAttrsVO.attrList.count * 60;
        [self configCenterShowGuigeViewWithHeight:height];
        [self.guigeChooseView setValueWithModel:goodsModel];
        [self.chooseSheetView show];
    }
}

#pragma mark - coustomBlock

- (void)guigeChooseViewCloseButtonClicekd {
    [self.chooseSheetView dismiss];
    _chooseSheetView = nil;
    _guigeChooseView = nil;
}

- (void)guigeChooseViewAddCarButtonClicekd:(NSArray<GoodsSkuVOListItem *> *)arr {
    [self.chooseSheetView dismiss];
    _chooseSheetView = nil;
    _guigeChooseView = nil;
    
    //加入购物车
    for (GoodsSkuVOListItem *item in arr) {
        [[XKTradingAreaShopCarManager shareManager] addToShopCarWithGoodsModel:item shopId:self.shopId industryType:self.xkIndustryType];
    }
    //刷新
    [self refreshShopCarDataChangeShopCarViewHeight:YES];

}

#pragma mark - setter && getter


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (UIButton *)bottomShopCarBtn {
    if (!_bottomShopCarBtn) {
        _bottomShopCarBtn = [[UIButton alloc] init];
        [_bottomShopCarBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_shopCar"] forState:UIControlStateNormal];
        [_bottomShopCarBtn addTarget:self action:@selector(shopCarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomShopCarBtn;
}

- (UILabel *)bottomTipLable {
    if (!_bottomTipLable) {
        _bottomTipLable = [[UILabel alloc] init];
        _bottomTipLable.textAlignment = NSTextAlignmentCenter;
        _bottomTipLable.backgroundColor = HEX_RGB(0xEE6161);
        _bottomTipLable.textColor = [UIColor whiteColor];
        _bottomTipLable.font = XKRegularFont(10);
        _bottomTipLable.layer.masksToBounds = YES;
        _bottomTipLable.layer.cornerRadius = 7;
        _bottomTipLable.hidden = YES;
    }
    return _bottomTipLable;
}

- (UILabel *)bottomPriceLabel {
    if (!_bottomPriceLabel) {
        _bottomPriceLabel = [[UILabel alloc] init];
        _bottomPriceLabel.text = @"￥0";
        _bottomPriceLabel.textColor = HEX_RGB(0xEE6161);;
        _bottomPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _bottomPriceLabel;
}

- (UIButton *)bottomGoBuyBtn {
    if (!_bottomGoBuyBtn) {
        _bottomGoBuyBtn = [[UIButton alloc] init];
        [_bottomGoBuyBtn addTarget:self action:@selector(goBuyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bottomGoBuyBtn.backgroundColor = XKMainTypeColor;
        [_bottomGoBuyBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_bottomGoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomGoBuyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _bottomGoBuyBtn;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _leftTableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.rowHeight = 50;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView {
    
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumInteritemSpacing = 0.f;
        flowlayout.minimumLineSpacing = 0.5f;
        flowlayout.itemSize = CGSizeMake((SCREEN_WIDTH - 114*ScreenScale), 110);
//        flowlayout.headerReferenceSize = CGSizeMake((SCREEN_WIDTH - 114*ScreenScale), 35.0f);
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_rightCollectionView registerClass:[XKStoreEidtMenuCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
//        [_rightCollectionView registerClass:[XKMallTypeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _rightCollectionView;
}

- (void)configCenterShowGuigeViewWithHeight:(CGFloat)height {
    
    _guigeChooseView = [[XKStoreEidtChooseSpecificationView alloc] initWithFrame:CGRectMake(45, (SCREEN_HEIGHT - height) / 2, SCREEN_WIDTH - 90, height)];
    _guigeChooseView.transform = CGAffineTransformMakeScale(0, 0);
    _guigeChooseView.layer.masksToBounds = YES;
    _guigeChooseView.layer.cornerRadius = 5;
    XKWeakSelf(weakSelf);
    _guigeChooseView.closeBlock = ^{
        [weakSelf guigeChooseViewCloseButtonClicekd];
    };
    _guigeChooseView.addCarBlock = ^(NSArray<GoodsSkuVOListItem *> *itemsArr) {
        [weakSelf guigeChooseViewAddCarButtonClicekd:itemsArr];
    };
}

/*
- (XKStoreEidtChooseSpecificationView *)guigeChooseView {
    if (!_guigeChooseView) {
        _guigeChooseView = [[XKStoreEidtChooseSpecificationView alloc] initWithFrame:CGRectMake(50, (SCREEN_HEIGHT - 100) / 2, SCREEN_WIDTH - 100, 200)];
//        _guigeChooseView.transform = CGAffineTransformMakeScale(0, 0);
        _guigeChooseView.layer.masksToBounds = YES;
        _guigeChooseView.layer.cornerRadius = 5;
        XKWeakSelf(weakSelf);
        _guigeChooseView.closeBlock = ^{
            [weakSelf guigeChooseViewCloseButtonClicekd];
        };
        _guigeChooseView.addCarBlock = ^(NSArray<GoodsSkuVOListItem *> *itemsArr) {
            [weakSelf guigeChooseViewAddCarButtonClicekd:itemsArr];
        };
    }
    return _guigeChooseView;
}*/

- (XKCommonSheetView *)chooseSheetView {
    
    if (!_chooseSheetView) {
        _chooseSheetView = [[XKCommonSheetView alloc] init];
        _chooseSheetView.animationWay = AnimationWay_centerShow;
        _chooseSheetView.contentView = self.guigeChooseView;
        [_chooseSheetView addSubview:self.guigeChooseView];
    }
    return _chooseSheetView;
}



- (XKStoreEidtMenuBottomShopCarView *)shopCarView {
    if (!_shopCarView) {
        _shopCarView = [[XKStoreEidtMenuBottomShopCarView alloc] init];
        _shopCarView.shopId = self.shopId;
        _shopCarView.xkIndustryType = self.xkIndustryType;
        XKWeakSelf(weakSelf);
        _shopCarView.clearBlock = ^{
            [weakSelf clearShopCarData];
        };
        _shopCarView.refreshBlock = ^{
            [weakSelf refreshShopCarDataChangeShopCarViewHeight:NO];
        };
        _shopCarView.gotoBuyBlock = ^{
            [weakSelf goBuyBtnClicked:nil];
        };
    }
    return _shopCarView;
}

- (XKCommonSheetView *)shopCarChooseSheetView {
    
    if (!_shopCarChooseSheetView) {
        _shopCarChooseSheetView = [[XKCommonSheetView alloc] init];
        _shopCarChooseSheetView.addBottomSafeHeight = YES;
        _shopCarChooseSheetView.shieldBottomHeight = 50;
        _shopCarChooseSheetView.contentView = self.shopCarView;
        [_shopCarChooseSheetView addSubview:self.shopCarView];
    }
    return _shopCarChooseSheetView;
}



- (XKStoreReserveChooseSpecificationView *)reserveGuigeChooseView {
    if (!_reserveGuigeChooseView) {
        _reserveGuigeChooseView = [[XKStoreReserveChooseSpecificationView alloc] init];
        XKWeakSelf(weakSelf);
        _reserveGuigeChooseView.closeBlock = ^{
            [weakSelf reserveGuigeChooseViewCloseButtonClicekd];
        };
        _reserveGuigeChooseView.nextBlock = ^(GoodsSkuVOListItem *skuItem, NSString *time, SpecificationViewType viewType) {
            [weakSelf reserveGuigeChooseViewNextButtonCliceked:skuItem time:time viewType:viewType];
        };
    }
    return _reserveGuigeChooseView;
}

- (XKCommonSheetView *)reserveChooseGuigeSheetView {
    
    if (!_reserveChooseGuigeSheetView) {
        _reserveChooseGuigeSheetView = [[XKCommonSheetView alloc] init];
//        _reserveChooseGuigeSheetView.addBottomSafeHeight = YES;
        _reserveChooseGuigeSheetView.contentView = self.reserveGuigeChooseView;
        [_reserveChooseGuigeSheetView addSubview:self.reserveGuigeChooseView];
    }
    return _reserveChooseGuigeSheetView;
}



- (NSMutableDictionary *)goodsListMuDic {
    if (!_goodsListMuDic) {
        _goodsListMuDic = [NSMutableDictionary dictionary];
    }
    return _goodsListMuDic;
}

- (NSMutableDictionary *)goodsInfoMuDic {
    if (!_goodsInfoMuDic) {
        _goodsInfoMuDic = [NSMutableDictionary dictionary];
    }
    return _goodsInfoMuDic;
}

@end
