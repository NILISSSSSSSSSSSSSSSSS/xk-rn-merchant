//
//  XKTradingAreaCommonAdapter.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaCommonAdapter.h"

#import "XKStoreIntroductionTableViewCell.h"
#import "XKStoreActivityTableViewCell.h"
#import "XKStoreBookingTableViewCell.h"
#import "XKStoreTakeoutTableViewCell.h"
#import "XKStoreInStoreOnlySevericeTableViewCell.h"
#import "XKSotreInfoTableViewCell.h"
#import "XKStoreInStoreTableViewCell.h"
#import "XKStoreEstimateCell.h"
#import "XKSqureSectionFooterView.h"
#import "XKStoreSectionHeaderView.h"
#import "XKStoreEstimateSectionHeaderView.h"
#import "XKSquareTradingAreaTool.h"
#import "XKSqureCommonNoDataCell.h"
#pragma mark - 模型
#import "XKTradingAreaCommentLabelsModel.h"
#import "XKTradingAreaCommentListModel.h"
#import "XKTradingAreaShopCellTypeModel.h"
#import "XKTradingAreaCommentGradeModel.h"
#import "XKTradingAreaShopInfoModel.h"

static NSString * const noDataCellID          = @"noDataCellID";
static NSString * const introductionID        = @"introductionCell";
static NSString * const activityID            = @"activityCell";
static NSString * const bookingID             = @"bookingCell";
static NSString * const hotelID               = @"hotelCell";
static NSString * const orderDishesID         = @"orderDishesCell";
static NSString * const takeoutID             = @"takeoutCell";

static NSString * const storeInStoreID        = @"storeInStoreCell";

static NSString * const storeInfoID           = @"storeInfoCell";
static NSString * const estimateID            = @"estimateCell";

static NSString * const sectionHeaderViewID           = @"sectionHeaderView";
static NSString * const estimateSectionHeaderViewID   = @"estimateSectionHeaderView";
static NSString * const sectionFooterViewID           = @"sectionFooterView";

static CGFloat const SectoionHeaderHeight      = 40;
static CGFloat const SectoionFooterHeight      = 44+10;


@interface XKTradingAreaCommonAdapter ()<StoreEstimateDelegate,StoreImageDelegate,XKCustomShareViewDelegate>

@property (nonatomic, strong) XKStoreEstimateSectionHeaderView *estimateHeaderView;
@property (nonatomic, strong) XKTradingAreaCommentGradeModel   *gradeModel;
@property (nonatomic, strong) XKTradingAreaShopInfoModel       *shopModel;

@property (nonatomic, assign) BOOL bookingLookMore;

@property (nonatomic, copy  ) NSArray          *dataSourceArr;

@property (nonatomic, copy  ) NSArray          *shopCommentLabelsArr;
@property (nonatomic, copy  ) NSArray          *shopCommentListArr;
@property (nonatomic, assign) CGFloat          labelsViewHeight;
//缓存商品详情
@property (nonatomic, strong) NSMutableDictionary *goodsInfoCacheMuDic;

@end

@implementation XKTradingAreaCommonAdapter

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    
    if (index == CommonType_estimate) {
        return self.shopCommentListArr.count ? self.shopCommentListArr.count : 1;
    } else {
        return model.dataList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[indexPath.section];
    NSInteger index = model.cellId.integerValue;
    
    
    if (index == CommonType_introduction) {
        
        XKStoreIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:introductionID];
        if (!cell) {
            cell = [[XKStoreIntroductionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:introductionID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setIntroductionTableViewCelltype:IntroductionCellType_offlineOrdering];

            XKWeakSelf(weakSelf);
            cell.addresBtnBlock = ^(UIButton *sender) {
                [weakSelf addressButtonClicked:sender];
            };
            cell.reservationBtnBlock = ^(UIButton *sender, NSArray *phoneArr, IntroductionCellType cellType) {
                [weakSelf reservationButtonClicked:sender phoneArray:phoneArr cellType:cellType];
            };
            cell.coverItemBlock = ^(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item, NSInteger index) {
                [weakSelf coverItemClicked:autoScrollView didSelectItem:item index:index];
            };
        }
        [cell setValueWithModel:model.dataList[indexPath.row]];
        return cell;
        
    } else if (index == CommonType_activity) {
        
        XKStoreActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityID];
        if (!cell) {
            cell = [[XKStoreActivityTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:activityID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setValueWithModelArr:model.dataList[indexPath.row]];
        return cell;
        
    } else if (index == CommonType_booking) {
        
        XKStoreBookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookingID];
        if (!cell) {
            cell = [[XKStoreBookingTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:bookingID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = StoreBookingType_offline;
            XKWeakSelf(weakSelf);
            cell.buyBlock = ^(NSString *goodsId) {
                [weakSelf buyButtonClicked:goodsId type:CommonType_booking];
            };
        }
        [cell setValueWithModel:model.dataList[indexPath.row]];
        return cell;
        
    } else if (index == CommonType_hotel) {
        
        XKStoreBookingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotelID];
        if (!cell) {
            cell = [[XKStoreBookingTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hotelID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = StoreBookingType_offline;
            XKWeakSelf(weakSelf);
            cell.buyBlock = ^(NSString *goodsId) {
                [weakSelf buyButtonClicked:goodsId type:CommonType_hotel];
            };
        }
        [cell setValueWithModel:model.dataList[indexPath.row]];

        return cell;
        
    } else if (index == CommonType_offLine) {
        
        XKStoreTakeoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDishesID];
        if (!cell) {
            cell = [[XKStoreTakeoutTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderDishesID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleName:@"现场购买"];
            XKWeakSelf(weakSelf);
            cell.goBuyBlock = ^(UITableViewCell *cell) {
                [weakSelf takeoutGotoBuy:cell];
            };
            cell.itemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSString *goodsId) {
                [weakSelf itemSelected:collectionView indexPath:indexPath goodsId:goodsId cellId:index];
            };
        }
        [cell setValueWithModelArr:model.dataList[indexPath.row]];
        
        return cell;
        
    } else if (index == CommonType_takeout) {
        
        XKStoreTakeoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:takeoutID];
        if (!cell) {
            cell = [[XKStoreTakeoutTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:takeoutID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleName:@"外卖"];
            XKWeakSelf(weakSelf);
            cell.goBuyBlock = ^(UITableViewCell *cell) {
                [weakSelf takeoutGotoBuy:cell];
            };
            cell.itemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSString *goodsId) {
                [weakSelf itemSelected:collectionView indexPath:indexPath goodsId:goodsId cellId:index];
            };
        }
        [cell setValueWithModelArr:model.dataList[indexPath.row]];

        return cell;
        
    } else if (index == CommonType_storeInStore) {
        
        XKStoreInStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeInStoreID];
        if (!cell) {
            cell = [[XKStoreInStoreTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:storeInStoreID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XKWeakSelf(weakSelf);
            cell.lookStoreBlock = ^(NSString *shopId) {
                [weakSelf lookStoreButtonClicked:shopId];
            };
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
        }
        if (model.dataList.count == indexPath.row + 1) {
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
            [cell hiddenLineView:YES];
        } else {
            cell.xk_clipType = XKCornerClipTypeNone;
            [cell hiddenLineView:NO];
        }
        [cell setValueWithModel:model.dataList[indexPath.row]];
        return cell;
        
    } else if (index == CommonType_storeInfo) {
        
        XKSotreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeInfoID];
        if (!cell) {
            cell = [[XKSotreInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:storeInfoID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.xk_openClip = YES;
            cell.xk_radius = 5;
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
        }
        [cell setValueWithModel:model.dataList[indexPath.row]];
        return cell;
        
    } else {
        
        if (self.self.shopCommentListArr.count) {
            XKStoreEstimateCell *cell = [tableView dequeueReusableCellWithIdentifier:estimateID];
            if (!cell) {
                cell = [[XKStoreEstimateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:estimateID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.xk_openClip = YES;
                cell.xk_radius = 5;
                cell.delegate = self;
            }
            [cell setValueWithModel:self.shopCommentListArr[indexPath.row]];
            if (indexPath.row + 1 == self.shopCommentListArr.count) {
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
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    
    if (index == CommonType_introduction) {
        return 10;
    } else if (index == CommonType_activity) {
        return 0;
    } else if (index == CommonType_booking || index == CommonType_hotel) {
        return SectoionHeaderHeight;
    } else if (index == CommonType_offLine || index == CommonType_takeout) {
        return 0;
    } else if (index == CommonType_storeInStore || index == CommonType_storeInfo) {
        return SectoionHeaderHeight;
    } else if (index == CommonType_estimate) {
        return self.labelsViewHeight + 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    
    if (index == CommonType_introduction) {
        return 10;
    } else if (index == CommonType_activity) {
        return 10;
    } else if (index == CommonType_booking || index == CommonType_hotel) {
        return SectoionFooterHeight;
    } else if (index == CommonType_offLine || index == CommonType_takeout) {
        return 10;
    } else if (index == CommonType_storeInStore || index == CommonType_storeInfo || index == CommonType_estimate) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    
    if (index == CommonType_booking || index == CommonType_hotel || index == CommonType_storeInfo || index == CommonType_storeInStore) {
        
        XKStoreSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKStoreSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
            sectionHeaderView.backView.xk_openClip = YES;
            sectionHeaderView.backView.xk_radius = 5;
            sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        }
        NSString *titleName = @"";
        NSString *moreBtnImgName = @"";
        NSInteger moreBtnImgDirection = ButtonImgDirection_left;
        NSString *moreBtnTitleName = @"";
        if (index == CommonType_booking) {
            titleName = @"预定";
            moreBtnImgName = @"xk_icon_TradingArea_right";
            moreBtnTitleName = @" 支持退";
            
        } else if (index == CommonType_hotel) {
            titleName = @"酒店预定";
            moreBtnImgName = @"xk_icon_TradingArea_right";
            moreBtnTitleName = @" 支持退";
            
        } else if (index == CommonType_storeInStore) {
            
            titleName = @"店中店";
            moreBtnImgName = @"";
            moreBtnTitleName = @"";
            
        } else if (index == CommonType_storeInfo) {
            titleName = @"商户信息";
            moreBtnImgName = @"";
            moreBtnTitleName = @"";
        }
        [sectionHeaderView setTitleName:titleName titleColor:HEX_RGB(0x222222) titleFont:XKRegularFont(14)];
        [sectionHeaderView setMoreButtonWithTitle:moreBtnTitleName titleColor:HEX_RGB(0x999999) titleFont:XKRegularFont(14) buttonTag:index];
        [sectionHeaderView setMoreButtonImageWithImageName:moreBtnImgName space:5 imgDirection:moreBtnImgDirection];
        
        return sectionHeaderView;
        
    } else if (index == CommonType_estimate) {
        return self.estimateHeaderView;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    
    if (index == CommonType_booking || index == CommonType_hotel) {
        
        XKSqureSectionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
        
        if (!sectionFooterView) {
            sectionFooterView = [[XKSqureSectionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
            [sectionFooterView hiddenLineView:YES];
            sectionFooterView.backView.xk_openClip = YES;
            sectionFooterView.backView.xk_radius = 5;
            sectionFooterView.backView.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
            XKWeakSelf(weakSelf);
            sectionFooterView.footerViewBlock = ^(UIButton *sender) {
                [weakSelf footerMoreViewClicked:sender];
            };
        }

        
        NSString *imgName = @"";
        NSString *titleName = @"";
        if (index == CommonType_booking) {
            [sectionFooterView hiddenLineView:YES];
            imgName = @"xk_btn_home_sectionFooter_more";
            titleName = @"";
        } else if (index == CommonType_hotel) {
            
            [sectionFooterView hiddenLineView:YES];
            imgName = @"xk_btn_home_sectionFooter_more";
            titleName = @"";
        }
        
        [sectionFooterView setFooterButtonTag:section];
        [sectionFooterView setFooterViewImg:[UIImage imageNamed:imgName]];
        [sectionFooterView setFooterViewWithTitle:titleName titleColor:XKMainTypeColor titleFont:XKRegularFont(14)];
        return sectionFooterView;
    }
    return nil;
}



#pragma mark - request

//店铺详情
- (void)requestTradingAreaShopInfo {
    
    [XKSquareTradingAreaTool tradingAreaShopInfo:@{@"shopId":self.shopId ? self.shopId : @"",
                                                   @"lng":@(self.lng),
                                                   @"lat":@(self.lat)}
                                           group:self.group
                                         success:^(XKTradingAreaShopInfoModel *model) {
                                             self.shopModel = model;
                                             
                                             NSMutableArray *severGoodsArr = [NSMutableArray array];
                                             NSMutableArray *hotelGoodsArr = [NSMutableArray array];
                                             NSMutableArray *offLineGoodsArr = [NSMutableArray array];
                                             NSMutableArray *takeOutGoodsArr = [NSMutableArray array];
                                             for (ATGoodsItem *item in model.goods) {
                                                 if ([item.goodsTypeId isEqualToString:kSeverCode]) {//服务类
                                                     if (item.shopGoods.count <= 3) {
                                                         [severGoodsArr addObjectsFromArray:item.shopGoods];
                                                     } else {
                                                         [severGoodsArr addObjectsFromArray:[item.shopGoods subarrayWithRange:NSMakeRange(0, 3)]];
                                                     }
                                                 } else if ([item.goodsTypeId isEqualToString:kHotelCode]) {//酒店类
                                                     if (item.shopGoods.count <= 3) {
                                                         [hotelGoodsArr addObjectsFromArray:item.shopGoods];
                                                     } else {
                                                         [hotelGoodsArr addObjectsFromArray:[item.shopGoods subarrayWithRange:NSMakeRange(0, 3)]];
                                                     }
                                                 } else if ([item.goodsTypeId isEqualToString:kOfflineCode]) {//现场购买
                                                     [offLineGoodsArr addObjectsFromArray:item.shopGoods];
                                                 } else if ([item.goodsTypeId isEqualToString:kOnlineCode]) {//外卖
                                                     [takeOutGoodsArr addObjectsFromArray:item.shopGoods];
                                                 }
                                             }
                                             NSMutableArray *muArr = [NSMutableArray array];
                                             [muArr addObject:@{@"cellId":@"0", @"dataList":@[model]}];//店铺简介
                                             [muArr addObject:@{@"cellId":@"1", @"dataList":@[model.coupons]}];//店铺活动
                                             if (severGoodsArr.count) {
                                                 [muArr addObject:@{@"cellId":@"2", @"dataList":severGoodsArr.copy}];//服务商品
                                             }
                                             if (hotelGoodsArr.count) {
                                                 [muArr addObject:@{@"cellId":@"3", @"dataList":hotelGoodsArr.copy}];//酒店商品
                                             }
                                             if (offLineGoodsArr.count) {
                                                 [muArr addObject:@{@"cellId":@"4", @"dataList":@[offLineGoodsArr.copy]}];//现场购买
                                             }
                                             if (takeOutGoodsArr.count) {
                                                 [muArr addObject:@{@"cellId":@"5", @"dataList":@[takeOutGoodsArr.copy]}];//外卖
                                             }
                                             if (model.shops.count) {
                                                 [muArr addObject:@{@"cellId":@"6", @"dataList":model.shops}];//店中店
                                             }
                                             [muArr addObject:@{@"cellId":@"7", @"dataList":@[model.mShop]}];//店铺信息
                                             [muArr addObject:@{@"cellId":@"8", @"dataList":@[]}];//店铺评论
                                             
                                             NSMutableArray *dataMuarr = [NSMutableArray array];
                                             for (NSDictionary *dic in muArr) {
                                                 XKTradingAreaShopCellTypeModel *model = [XKTradingAreaShopCellTypeModel yy_modelWithDictionary:dic];
                                                 [dataMuarr addObject:model];
                                             }
                                             self.dataSourceArr = dataMuarr.copy;
    } faile:^(XKHttpErrror *error) {
        
    }];
    
}

//商店是否收藏
- (void)requsetTradingAreaShopFavoriteStatus:(void (^__strong)(NSInteger code))success {
    
    [XKSquareTradingAreaTool tradingAreaShopFavoriteStatus:@{@"xkModule":@"shop",
                                                             @"userId":[XKUserInfo getCurrentUserId] ? [XKUserInfo getCurrentUserId] : @"",
                                                             @"targetId":self.shopId ? self.shopId : @""}
                                                   success:^(NSInteger code) {
                                                       success(code);
    } faile:^(XKHttpErrror *error) {
    }];
}

//收藏
- (void)tradingAreaShopFavorite:(void (^__strong)(NSInteger code))success {
    
    [XKSquareTradingAreaTool tradingAreaShopFavorite:@{@"xkModule":@"shop",
                                                       @"ids":@[self.shopId ? self.shopId : @""]}
                                                   success:^(NSInteger code) {
                                                       success(code);
                                                   } faile:^(XKHttpErrror *error) {
                                                   }];
}

//取消收藏
- (void)tradingAreaCancelShopFavorite:(void (^__strong)(NSInteger code))success {
    
    [XKSquareTradingAreaTool tradingAreaShopCancelFavorite:@{@"xkModule":@"shop",
                                                             @"userId":[XKUserInfo getCurrentUserId] ? [XKUserInfo getCurrentUserId] : @"",
                                                             @"targetId":self.shopId ? self.shopId : @""}
                                                   success:^(NSInteger code) {
                                                       success(code);
                                                   } faile:^(XKHttpErrror *error) {
                                                   }];
}

//商店评论列表
- (void)requsetTradingAreaShopCommentList {
    
    [XKSquareTradingAreaTool tradingAreaGoodsOrShopCommentList:@{@"page":@"1", @"limit":@"3", @"shopId":self.shopId ? self.shopId : @""} group:self.group success:^(NSArray<CommentListItem *> *listArr) {
        self.shopCommentListArr = listArr;
    } faile:^(XKHttpErrror *error) {

    }];
}

- (void)configViewCommentHeaderView {
    
    CGFloat labelsViewH = [self.estimateHeaderView configLabelsWithDataSource:self.shopCommentLabelsArr type:EstimateHeaderType_shop];
    if (labelsViewH != self.labelsViewHeight) {
        self.labelsViewHeight = labelsViewH;
    }
}

- (void)requestTradingAreaShopCommentLabels {
    
    [XKSquareTradingAreaTool tradingAreaShopCommentLabels:@{@"shopId":self.shopId ? self.shopId : @""} group:self.group success:^(NSArray<XKTradingAreaCommentLabelsModel *> *result) {
        self.shopCommentLabelsArr = result;
        [self configViewCommentHeaderView];
    }];
}


- (void)requestTeadingAreaShopCommentGrade {
    [XKSquareTradingAreaTool tradingAreaShopCommentGrade:@{@"shopId":self.shopId ? self.shopId : @""} group:self.group success:^(XKTradingAreaCommentGradeModel *model) {
        self.gradeModel = model;
    }];
}

- (void)requestShopCommentListWithParameters:(NSDictionary *)dic {
    [XKHUD showLoadingText:nil];
    [XKSquareTradingAreaTool tradingAreaGoodsOrShopCommentList:dic group:nil success:^(NSArray<CommentListItem *> *listArr) {
        
        self.shopCommentListArr = listArr;
        [self.tableView reloadData];
        [XKHUD dismiss];
    } faile:^(XKHttpErrror *error) {
        [XKHUD dismiss];
    }];
}

- (void)shareButtonClicked {
    
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
    shareData.title = self.shopModel.mShop.name ? self.shopModel.mShop.name : @"商圈店铺";
    shareData.content = self.shopModel.mShop.descriptionStr ? self.shopModel.mShop.descriptionStr : @"暂无店铺简介";
    shareData.url = [NSString stringWithFormat:@"%@share/#/businessDetail?lng=%f&lat=%f&shopId=%@", BaseWebUrl, self.lng, self.lat, self.shopId];
    shareData.img = self.shopModel.mShop.cover;
    moreView.shareData = shareData;
    [moreView showInView:[self getCurrentUIVC].view];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[indexPath.section];
    NSInteger index = model.cellId.integerValue;
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:self.shopId forKey:@"shopId"];
    
    if (index == CommonType_booking) {//服务
        ATShopGoodsItem *item = model.dataList[indexPath.row];
        [muDic setObject:item.goodsId ? item.goodsId : @"" forKey:@"goodsId"];
    } else if (index == CommonType_hotel) {//酒店
        ATShopGoodsItem *item = model.dataList[indexPath.row];
        [muDic setObject:item.goodsId ? item.goodsId : @"" forKey:@"goodsId"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterTableView:didSelectRowAtIndex:info:)]) {
        [self.delegate adapterTableView:tableView didSelectRowAtIndex:index info:muDic];
    }
}

#pragma mark - CustomBlock
//indexPath 是collectionView 的 indexPath
- (void)itemSelected:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath goodsId:(NSString *)goodsId cellId:(NSInteger)cellId {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsItemSelected:index:)]) {
        [self.delegate goodsItemSelected:goodsId index:cellId];
    }
}

- (void)buyButtonClicked:(NSString *)goodsId type:(CommonType)type {
    
    XKTradingAreaGoodsInfoModel *goodsDetail = [self.goodsInfoCacheMuDic objectForKey:goodsId];
    
    if (!goodsDetail) {
        [XKSquareTradingAreaTool tradingAreaGoodsDetail:@{@"shopId":self.shopId ? self.shopId : @"",
                                                          @"id":goodsId ? goodsId : @""}
                                                  group:nil
                                                success:^(XKTradingAreaGoodsInfoModel *model) {
                                                    [self.goodsInfoCacheMuDic setObject:model forKey:goodsId];
                                                    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonSelected:goodsDetail:type:)]) {
                                                        [self.delegate buyButtonSelected:goodsId goodsDetail:model type:type];
                                                    }
                                                }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonSelected:goodsDetail:type:)]) {
            [self.delegate buyButtonSelected:goodsId goodsDetail:goodsDetail type:type];
        }
    }
}

- (void)footerMoreViewClicked:(UIButton *)sender {
    
    NSString *severCode = [self getSeverCode:sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterFooterMoreViewClicked:shopId:severCode:shopName:)]) {
        [self.delegate adapterFooterMoreViewClicked:sender.tag shopId:self.shopId severCode:severCode shopName:self.shopModel.mShop.name];
    }
    
}

- (void)takeoutGotoBuy:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *severCode = [self getSeverCode:indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterFooterMoreViewClicked:shopId:severCode:shopName:)]) {
        [self.delegate adapterFooterMoreViewClicked:0 shopId:self.shopId severCode:severCode shopName:self.shopModel.mShop.name];
    }
}

- (NSString *)getSeverCode:(NSInteger)section {
    
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[section];
    NSInteger index = model.cellId.integerValue;
    NSString *severCode = @"";
    if (index == 2) {
        severCode = kSeverCode;//服务类型
    } else if (index == 3) {
        severCode = kHotelCode;//酒店类型
    } else if (index == 4) {
        severCode = kOfflineCode;//现场购买类型
    } else if (index == 5) {
        severCode = kOnlineCode;//外卖类型
    }
    return severCode;
}



- (void)coverItemClicked:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem*)item index:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterAutoScrollView:didSelectItem:index:)]) {
        [self.delegate adapterAutoScrollView:autoScrollView didSelectItem:item index:index];
    }
}


- (void)addressButtonClicked:(UIButton *)sender {
    XKTradingAreaShopCellTypeModel *model = self.dataSourceArr[0];
    XKTradingAreaShopInfoModel *shopInfo = model.dataList.firstObject;
    double lat = shopInfo.mShop.lat.doubleValue;
    double lng = shopInfo.mShop.lng.doubleValue;
    NSString *name = shopInfo.mShop.name;
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressButtonSelected:lat:lng:)]) {
        [self.delegate addressButtonSelected:name lat:lat lng:lng];
    }
}

- (void)reservationButtonClicked:(UIButton *)sender phoneArray:(NSArray *)phoneArr cellType:(IntroductionCellType) cellType{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reservationButtonSelected:phoneArray:cellType:)]) {
        [self.delegate reservationButtonSelected:sender phoneArray:phoneArr cellType:cellType];
    }
}

- (void)lookMoreEstimate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterLookMoreEstimate:)]) {
        [self.delegate adapterLookMoreEstimate:1];
    }
}

- (void)unfoldButtonClick:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < self.shopCommentListArr.count) {
        CommentListItem *model = self.shopCommentListArr[indexPath.row];
        model.unfold = !model.unfold;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.shopCommentListArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:model];
        self.shopCommentListArr = [muArr copy];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)estimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterEstimateCollectionView:didSelectItemAtIndexPath:imgArr:)]) {
        [self.delegate adapterEstimateCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgArr:imgArr];
    }
}

- (void)storeImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterStoreIntroductionImgCollectionView:didSelectItemAtIndexPath:imgArr:)]) {
        [self.delegate adapterStoreIntroductionImgCollectionView:collectionView didSelectItemAtIndexPath:indexPath imgArr:imgArr];
    }
}


- (void)lookStoreButtonClicked:(NSString *)shopId {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adapterLookStore:)]) {
        [self.delegate adapterLookStore:shopId];
    }
}



#pragma mark - Getters and Setters
- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

- (XKStoreEstimateSectionHeaderView *)estimateHeaderView {
    
    if (!_estimateHeaderView) {
        _estimateHeaderView = [[XKStoreEstimateSectionHeaderView alloc] initWithReuseIdentifier:estimateSectionHeaderViewID];
        _estimateHeaderView.backView.xk_openClip = YES;
        _estimateHeaderView.backView.xk_radius = 5;
        _estimateHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        XKWeakSelf(weakSelf);
        _estimateHeaderView.moreBlock = ^{
            [weakSelf lookMoreEstimate];
        };
        _estimateHeaderView.labelsBlock = ^(NSInteger index) {
            XKTradingAreaCommentLabelsModel *model = weakSelf.shopCommentLabelsArr[index];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"1" forKey:@"page"];
            [dic setObject:@"3" forKey:@"limit"];
            [dic setObject:weakSelf.shopId ? weakSelf.shopId : @"" forKey:@"shopId"];
            if (model.code) {
                [dic setObject:model.code forKey:@"shopIndustryCode"];
            }
            [weakSelf requestShopCommentListWithParameters:dic];
        };
    }

    [_estimateHeaderView setTitleName:[NSString stringWithFormat:@"评价（%ld）", (long)self.gradeModel.commentCount.integerValue] titleColor:HEX_RGB(0x222222) titleFont:XKRegularFont(14)];
    [_estimateHeaderView setStarViewValue:self.gradeModel.averageScore.integerValue];
    
    return _estimateHeaderView;
}

- (NSMutableDictionary *)goodsInfoCacheMuDic {
    if (!_goodsInfoCacheMuDic) {
        _goodsInfoCacheMuDic = [NSMutableDictionary dictionary];
    }
    return _goodsInfoCacheMuDic;
}

@end
