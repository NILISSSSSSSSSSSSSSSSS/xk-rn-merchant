//
//  XKTradingAreaGoodsDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaGoodsDetailViewController.h"

#import "XKGoodsDetailIntroductionTableViewCell.h"
#import "XKGoodsDetailGuigeTableViewCell.h"
#import "XKTradingAreaGoodsInfoTableViewCell.h"

#import "XKStoreEstimateCell.h"
#import "XKStoreEstimateSectionHeaderView.h"
#import "XKCommonSheetView.h"
#import "XKStoreEidtMenuBottomShopCarView.h"
#import "XKStoreEstimateDetailListViewController.h"
#import "XKTradingAreaGoodsDetailChooseSpecificationView.h"
#import "XKAutoScrollImageItem.h"
#import "XKSquareTradingAreaTool.h"
#import "XKTradingAreaOrderReserveViewController.h"
#import "XKSqureCommonNoDataCell.h"
#import "XKStoreReserveChooseSpecificationView.h"
#import "XKTradingAreaShopCarManager.h"
#import "XKTradingAreaOnlineOrderSureViewController.h"
#import "XKTradingAreaOfflineOrderSureViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKTradingAreaAddGoodsListViewController.h"

#pragma mark - 模型
#import "XKTradingAreaCommentListModel.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaCommentGradeModel.h"

static NSString * const noDataCellID          = @"noDataCellID";
static NSString * const introductionID        = @"introductionCell";
static NSString * const guigeID               = @"guigeCell";
static NSString * const goodsInfoID           = @"goodsInfoCell";
static NSString * const estimateID            = @"estimateCell";
static NSString * const estimateSectionHeaderViewID   = @"estimateSectionHeaderView";

typedef enum : NSUInteger {
    GoodsDetailCellType_introduction,//商品简介
    /*GoodsDetailCellType_guige,*///规格
    GoodsDetailCellType_goodsInfo,//商品详细信息
    GoodsDetailCellType_estimate,//评价
} GoodsDetailCellType;

@interface XKTradingAreaGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, StoreEstimateDelegate,GoodsImageDelegate,XKCustomShareViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, assign) GoodsType         goodsType;

//非服务类
@property (nonatomic, strong) UIView            *bottomView;
@property (nonatomic, strong) UIButton          *bottomShopCarBtn;
@property (nonatomic, strong) UILabel           *bottomTipLable;
@property (nonatomic, strong) UILabel           *bottomPriceLabel;
@property (nonatomic, strong) UIButton          *bottomGoBuyBtn;

//服务类
@property (nonatomic, strong) UIView            *severBottomView;
@property (nonatomic, strong) UIButton          *severBottomCallBtn;
@property (nonatomic, strong) UIButton          *severBottomGoBuyBtn;

//现场购买 外卖
@property (nonatomic, strong) XKCommonSheetView                              *shopCarChooseSheetView;
@property (nonatomic, strong) XKStoreEidtMenuBottomShopCarView               *shopCarView;
@property (nonatomic, strong) XKTradingAreaGoodsDetailChooseSpecificationView *guigeChooseView;
@property (nonatomic, strong) XKCommonSheetView                               *chooseSheetView;

//服务
@property (nonatomic, strong) XKStoreReserveChooseSpecificationView *reserveGuigeChooseView;
@property (nonatomic, strong) XKCommonSheetView                     *reserveChooseGuigeSheetView;

@property (nonatomic, strong) dispatch_group_t group;

@property (nonatomic, strong) XKTradingAreaGoodsInfoModel    *model;
@property (nonatomic, strong) XKTradingAreaCommentGradeModel *gradeModel;
@property (nonatomic, assign) XKIndustryType                 xkIndustryType;

@property (nonatomic, copy  ) NSArray          *goodsCommentLabelsArr;
@property (nonatomic, copy  ) NSArray          *goodsCommentListArr;
@property (nonatomic, assign) CGFloat          labelsViewHeight;

@end

@implementation XKTradingAreaGoodsDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self requestAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    
    [self setNavTitle:@"商品详情" WithColor:[UIColor whiteColor]];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_share_white"] forState:UIControlStateNormal];
    [self setNaviCustomView:shareBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
}

- (void)configViews {
    
    if (iPhoneX) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBottomSafeHeight, SCREEN_WIDTH, kBottomSafeHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:line];
        [self.view addSubview:view];
    }
    
    if (self.goodsType == GoodsType_offline || self.goodsType == GoodsType_online) {
        
        [self.view addSubview:self.bottomView];
        [self.bottomView addSubview:self.bottomShopCarBtn];
        [self.bottomView addSubview:self.bottomTipLable];
        [self.bottomView addSubview:self.bottomPriceLabel];
        [self.bottomView addSubview:self.bottomGoBuyBtn];
        [self.view addSubview:self.tableView];

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
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.bottom.equalTo(self.bottomView.mas_top);
            make.left.right.equalTo(self.view);
        }];
        
        //刷新购物车
        [self refreshShopCarDataChangeShopCarViewHeight:YES];
        
    } else if (self.goodsType == GoodsType_sever || self.goodsType == GoodsType_hotel) {
        
        [self.view addSubview:self.severBottomView];
        [self.severBottomView addSubview:self.severBottomCallBtn];
        [self.severBottomView addSubview:self.severBottomGoBuyBtn];
        [self.view addSubview:self.tableView];
        
        [self.severBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
            make.height.equalTo(@50);
        }];
        [self.severBottomCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.severBottomView);
            make.right.equalTo(self.severBottomGoBuyBtn.mas_left);
            make.width.equalTo(@105);
        }];
        [self.severBottomGoBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.severBottomView);
            make.width.equalTo(@105);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
            make.bottom.equalTo(self.severBottomView.mas_top);
            make.left.right.equalTo(self.view);
        }];
    }
    
}


#pragma mark - request

- (void)requestAllData {
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    
    [self requestTeadingAreaGoodsDetail];
    
    [self requestTeadingAreaGoodsCommentGrade];
    
    [self requestGoodsCommentListWithParameters:@{@"page":@"1", @"limit":@"3", @"goodsId":self.goodsId ? self.goodsId : @""}];
    
    
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.tableView.hidden = NO;
            self.bottomView.hidden = NO;
            [XKHudView hideHUDForView:self.tableView];
            [self.tableView stopRefreshing];
            [self.tableView reloadData];
        });
    });
}

- (void)requestTeadingAreaGoodsDetail {
    
    [XKSquareTradingAreaTool tradingAreaGoodsDetail:@{@"shopId":self.shopId ? self.shopId : @"",
                                                      @"id":self.goodsId ? self.goodsId : @""}
                                              group:self.group
                                            success:^(XKTradingAreaGoodsInfoModel *model) {
                                                
                                                self.model = model;
                                                NSString *goodsTypeId = self.model.goods.category.goodsTypeId;
                                                
                                                self.xkIndustryType = 0;
                                                if ([goodsTypeId isEqualToString:kSeverCode]) {
                                                    self.goodsType = GoodsType_sever;
                                                } else if ([goodsTypeId isEqualToString:kHotelCode]) {
                                                    self.goodsType = GoodsType_hotel;
                                                } else if ([goodsTypeId isEqualToString:kOnlineCode]) {
                                                    self.goodsType = GoodsType_online;
                                                    self.xkIndustryType = XKIndustryType_online;

                                                } else if ([goodsTypeId isEqualToString:kOfflineCode]) {
                                                    self.goodsType = GoodsType_offline;
                                                    self.xkIndustryType = XKIndustryType_offline;
                                                }
                                                [self configViews];
    }];
}

- (void)requestTeadingAreaGoodsCommentGrade {
    [XKSquareTradingAreaTool tradingAreaGoodsCommentGrade:@{@"goodsId":self.goodsId ? self.goodsId : @""} group:self.group success:^(XKTradingAreaCommentGradeModel *model) {
        self.gradeModel = model;
    }];
}


- (void)requestGoodsCommentListWithParameters:(NSDictionary *)parameters {
    [XKSquareTradingAreaTool tradingAreaGoodsOrShopCommentList:parameters group:self.group success:^(NSArray<CommentListItem *> *listArr) {
        self.goodsCommentListArr = listArr;
    } faile:^(XKHttpErrror *error) {
    }];
}


#pragma mark - Events


- (void)shareButtonClicked:(UIButton *)sender {
    
    NSMutableArray *shareItems = [NSMutableArray arrayWithArray:@[XKShareItemTypeCircleOfFriends,
                                                                  XKShareItemTypeWechatFriends,
                                                                  XKShareItemTypeQQ,
                                                                  XKShareItemTypeSinaWeibo]];
    XKCustomShareView *moreView = [[XKCustomShareView alloc] init];
    moreView.autoThirdShare = YES;
    moreView.delegate = self;
    moreView.layoutType = XKCustomShareViewLayoutTypeBottom;
    moreView.shareItems = shareItems;
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = self.model.goods.goodsName ? self.model.goods.goodsName : @"";
    shareData.content = self.model.goods.details ? self.model.goods.details : @"";
    shareData.url = [NSString stringWithFormat:@"%@share/#/businessGoodsDetail?id=%@&shopId=%@&goodsTypeId=%@", BaseWebUrl, self.model.goods.itemId, self.model.goods.shopId, self.model.goods.category.goodsTypeId];
    shareData.img = self.model.goods.mainPic;
    moreView.shareData = shareData;
    [moreView showInView:self.view];
    
}


- (void)clearShopCarData {
    
    [[XKTradingAreaShopCarManager shareManager] clearnShopCarWithShopId:self.shopId industryType:self.xkIndustryType];
    [self.shopCarView setValueWithModelArr:nil];
    [self.shopCarChooseSheetView dismiss];
    self.bottomPriceLabel.text = @"￥0";
    self.bottomTipLable.hidden = YES;

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
    } else {
        //如果购物车没商品了就dismiss
        [self.shopCarChooseSheetView dismiss];
        self.bottomTipLable.hidden = YES;
    }
}



- (void)shopCarButtonClicked:(UIButton *)sender {
    if (self.bottomTipLable.hidden) {
        return;
    }
    [self.shopCarChooseSheetView show];
}

- (void)addShopCarBtnClicked:(UIButton *)sender {
    [self.chooseSheetView show];
}

//服务类
- (void)severCallButtonClicked:(UIButton *)sender {
    //联系客服
    [XKCustomeSerMessageManager createShopCustomerWithCustomerID:self.shopId];
}

- (void)severBuyButtonClicked:(UIButton *)sender {
    
    if (self.goodsType == GoodsType_hotel) {
        [self.reserveChooseGuigeSheetView show];
        
    } else if (self.goodsType == GoodsType_sever) {
        [self.reserveChooseGuigeSheetView show];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == GoodsDetailCellType_introduction) {
        return 1;
    } /*else if (section == GoodsDetailCellType_guige) {
        return 1;
    }*/ else if (section == GoodsDetailCellType_goodsInfo) {
        return 1;
    } else if (section == GoodsDetailCellType_estimate) {
        return self.goodsCommentListArr.count ? self.goodsCommentListArr.count : 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == GoodsDetailCellType_introduction) {
        
        XKGoodsDetailIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:introductionID];
        if (!cell) {
            cell = [[XKGoodsDetailIntroductionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:introductionID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.coverItemBlock = ^(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item, NSInteger index) {
                [weakSelf coverItemClicked:autoScrollView didSelectItem:item index:index];
            };
        }
        [cell setValuesWithModel:self.model.goods];
        return cell;
        
        
    } /*else if (indexPath.section == GoodsDetailCellType_guige) {
        
        XKGoodsDetailGuigeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:guigeID];
        if (!cell) {
            cell = [[XKGoodsDetailGuigeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:guigeID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValuesWithModel:self.model.goods];
        return cell;
        
    }*/ else if (indexPath.section == GoodsDetailCellType_goodsInfo) {
        
        XKTradingAreaGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoID];
        if (!cell) {
            cell = [[XKTradingAreaGoodsInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsInfoID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setValuesWithModel:self.model.goods];
        return cell;
        
    } else {
        
        if (self.goodsCommentListArr.count) {
            XKStoreEstimateCell *cell = [tableView dequeueReusableCellWithIdentifier:estimateID];
            if (!cell) {
                cell = [[XKStoreEstimateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:estimateID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
                cell.delegate = self;
            }
            [cell setValueWithModel:self.goodsCommentListArr[indexPath.row]];
            if (indexPath.row + 1 == self.goodsCommentListArr.count) {
                [cell hiddenLine:YES];
                cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
            } else {
                [cell hiddenLine:NO];
                cell.xk_clipType = XKCornerClipTypeNone;
            }
            return cell;
        } else {
            XKSqureCommonNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataCellID];
            if (!cell) {
                cell = [[XKSqureCommonNoDataCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:noDataCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backView.xk_openClip = YES;
                cell.backView.xk_radius = 5;
                cell.backView.xk_clipType = XKCornerClipTypeBottomBoth;
            }
            [cell hiddenLineView:YES];
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == GoodsDetailCellType_estimate) {
        return self.labelsViewHeight + 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == GoodsDetailCellType_goodsInfo || section == GoodsDetailCellType_estimate) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == GoodsDetailCellType_estimate) {
        
        XKStoreEstimateSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:estimateSectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreEstimateSectionHeaderView alloc] initWithReuseIdentifier:estimateSectionHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
            XKWeakSelf(weakSelf);
            sectionHeaderView.moreBlock = ^{
                [weakSelf lookMore];
            };
        }
        [sectionHeaderView setTitleName:[NSString stringWithFormat:@"评价（%ld）", (long)self.gradeModel.commentCount.integerValue] titleColor:HEX_RGB(0x222222) titleFont:XKRegularFont(14)];
        [sectionHeaderView setStarViewValue:self.gradeModel.averageScore.integerValue];
        return sectionHeaderView;
    }
    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - CustomBlock

- (void)guigeChooseViewCloseButtonClicekd{
    
    [self.chooseSheetView dismiss];
}

- (void)guigeChooseViewSureBtnClicked:(NSArray<GoodsSkuVOListItem *> *)arr {
    [self.chooseSheetView dismiss];
    
    //加入购物车
    for (GoodsSkuVOListItem *item in arr) {
        [[XKTradingAreaShopCarManager shareManager] addToShopCarWithGoodsModel:item shopId:self.shopId industryType:self.xkIndustryType];
    }
    //刷新
    [self refreshShopCarDataChangeShopCarViewHeight:YES];
    
}

- (void)reserveGuigeChooseViewCloseButtonClicekd {
    [self.reserveChooseGuigeSheetView dismiss];
}

- (void)reserveGuigeChooseViewNextButtonCliceked:(GoodsSkuVOListItem *)skuItem time:(NSString *)time viewType:(SpecificationViewType)viewType {
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


- (void)lookMore {
    XKStoreEstimateDetailListViewController *vc = [[XKStoreEstimateDetailListViewController alloc] init];
    vc.type = EstimateDetailListType_goods;
    vc.goodsId = self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)gotoBuy {
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
        if (self.goodsType == GoodsType_online) {
            XKTradingAreaOnlineOrderSureViewController *vc = [[XKTradingAreaOnlineOrderSureViewController alloc] init];
//            vc.shopAddr = self.model.
            vc.shopName = self.model.goods.shopName;
            vc.shopId = self.shopId;
            vc.goodsArr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (self.goodsType == GoodsType_offline) {
            XKTradingAreaOfflineOrderSureViewController *vc = [[XKTradingAreaOfflineOrderSureViewController alloc] init];
            vc.shopName = self.model.goods.shopName;
            vc.shopId = self.shopId;
            vc.goodsArr = [[XKTradingAreaShopCarManager shareManager] getShopCarGoodsListWithShopId:self.shopId industryType:self.xkIndustryType];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


#pragma mark - Custom Delegates

- (void)unfoldButtonClick:(UITableViewCell *)cell {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row < self.goodsCommentListArr.count) {
        CommentListItem *model = self.goodsCommentListArr[indexPath.row];
        model.unfold = !model.unfold;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.goodsCommentListArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:model];
        self.goodsCommentListArr = [muArr copy];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)coverItemClicked:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem*)item index:(NSInteger)index {

    [XKGlobleCommonTool showBigImgWithImgsArr:@[item.image] viewController:self];
}

- (void)estimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    [XKGlobleCommonTool showBigImgWithImgsArr:imgArr viewController:self];
}

- (void)goodsInfoImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [XKGlobleCommonTool showBigImgWithImgsArr:self.model.goods.showPics viewController:self];
    
}

#pragma mark - Lazy load


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
        [_bottomGoBuyBtn addTarget:self action:@selector(addShopCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bottomGoBuyBtn.backgroundColor = XKMainTypeColor;
        [_bottomGoBuyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_bottomGoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomGoBuyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _bottomGoBuyBtn;
}

- (UIView *)severBottomView {
    if (!_severBottomView) {
        _severBottomView = [[UIView alloc] init];
        _severBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _severBottomView;
}

- (UIButton *)severBottomCallBtn {
    if (!_severBottomCallBtn) {
        _severBottomCallBtn = [[UIButton alloc] init];
        [_severBottomCallBtn addTarget:self action:@selector(severCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _severBottomCallBtn.backgroundColor = HEX_RGB(0xEE6161);
        [_severBottomCallBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_severBottomCallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _severBottomCallBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _severBottomCallBtn;
}


- (UIButton *)severBottomGoBuyBtn {
    if (!_severBottomGoBuyBtn) {
        _severBottomGoBuyBtn = [[UIButton alloc] init];
        [_severBottomGoBuyBtn addTarget:self action:@selector(severBuyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _severBottomGoBuyBtn.backgroundColor = XKMainTypeColor;
        [_severBottomGoBuyBtn setTitle:@"立即预定" forState:UIControlStateNormal];
        [_severBottomGoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _severBottomGoBuyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _severBottomGoBuyBtn;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
    }
    return _tableView;
}


- (XKTradingAreaGoodsDetailChooseSpecificationView *)guigeChooseView {
    if (!_guigeChooseView) {
        
        _guigeChooseView = [[XKTradingAreaGoodsDetailChooseSpecificationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.model.goodsSkuAttrsVO.attrList.count * 60 + 231 + kBottomSafeHeight)];
        [_guigeChooseView setValueWithModel:self.model];
        XKWeakSelf(weakSelf);
        _guigeChooseView.closeBlock = ^{
            [weakSelf guigeChooseViewCloseButtonClicekd];
        };
        _guigeChooseView.sureBlock = ^(NSArray<GoodsSkuVOListItem *> *itemsArr) {
            [weakSelf guigeChooseViewSureBtnClicked:itemsArr];
        };
    }
    return _guigeChooseView;
}

- (XKCommonSheetView *)chooseSheetView {
    
    if (!_chooseSheetView) {
        _chooseSheetView = [[XKCommonSheetView alloc] init];
//        _chooseSheetView.addBottomSafeHeight = YES;
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
            [weakSelf gotoBuy];
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
        SpecificationViewType viewType = 0;
        if (self.goodsType == GoodsType_hotel) {
            viewType = viewType_hetol;
            _reserveGuigeChooseView = [[XKStoreReserveChooseSpecificationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196 + (self.model.goodsSkuAttrsVO.attrList.count * 60) + kBottomSafeHeight)];

        } else if (self.goodsType == GoodsType_sever) {
            viewType = viewType_service;
            _reserveGuigeChooseView = [[XKStoreReserveChooseSpecificationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 255 + (self.model.goodsSkuAttrsVO.attrList.count * 60) + kBottomSafeHeight)];
        }
        [_reserveGuigeChooseView setValueWithModel:self.model viewType:viewType];
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
        _reserveChooseGuigeSheetView.contentView = self.reserveGuigeChooseView;
        [_reserveChooseGuigeSheetView addSubview:self.reserveGuigeChooseView];
    }
    return _reserveChooseGuigeSheetView;
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

@end
