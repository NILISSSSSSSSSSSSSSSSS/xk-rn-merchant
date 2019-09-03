//
//  XKTradingAreaViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaViewModel.h"
#import "XKTradingAreaRootHeaderView.h"
#import "XKMineCollectGamesTableViewCell.h"
#import "CommonSegmentControl.h"
#import "XKTradingAreaRootTableViewCell.h"
#import "XKTradingIocnListModel.h"
#import "XKSquareBannerModel.h"
#import "XKTradingShopListModel.h"
#import "XKSquareHomeToolModel.h"
#import "XKAreaPrizeTableViewCell.h"

static NSString * const sectionToolHeaderViewID = @"sectionHeaderViewID";
static NSString * const cellID = @"twoCell";
static NSString * const oneCellID = @"oneCell";

@interface XKTradingAreaViewModel ()
/**分段选择*/
@property(nonatomic, strong) CommonSegmentControl *segmentControl;
@property(nonatomic, strong) UIView *headerView;

/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;
/**iconArray*/
@property(nonatomic, strong) NSMutableArray *iconArray;
@property(nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation XKTradingAreaViewModel

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
        _limit = 10;
        _orderType = @"POPULARITY";
    }
    return self;
}
- (void)registerClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKTradingAreaRootTableViewCell class] forCellReuseIdentifier:cellID];
    [tableView registerClass:[XKAreaPrizeTableViewCell class] forCellReuseIdentifier:oneCellID];

}
#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XKAreaPrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oneCellID forIndexPath:indexPath];
        return cell;
    }else {
        XKTradingAreaRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.myContentView.xk_radius = 8;
        cell.myContentView.xk_openClip = YES;
        if (indexPath.row == self.dataArray.count - 1 && indexPath.section == 1) {
            cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
        }else{
            cell.myContentView.xk_clipType = XKCornerClipTypeNone;
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataArray.count > 0) {
            return 1;
        }else {
            return 0;
        }
    }else{
        return self.dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }else {
        return 130;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        XKTradingAreaRootHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionToolHeaderViewID];
        if (!headerView) {
            headerView = [[XKTradingAreaRootHeaderView alloc] initWithReuseIdentifier:sectionToolHeaderViewID];
        }
        XKWeakSelf(ws);
        
        headerView.dataArray = self.iconArray;
        [headerView.collectionView reloadData];
        [headerView reloadLayoutToolBackView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [headerView loopViewImageArray:self.bannerArray];
        });
        
        headerView.headerItemBlock = ^(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath,NSString *code) {
            if (ws.headerItemBlock) {
                ws.headerItemBlock(collectionView, indexPath,code,self.iconArray);
            }
        };
        headerView.viewItemBlock = ^(XKAutoScrollView * _Nonnull autoScrollView, XKAutoScrollImageItem * _Nonnull item, NSInteger index) {
            if (ws.bannerItemBlock) {
                ws.bannerItemBlock(autoScrollView, item, index);
            }
        };
        return headerView;
    }else{
        return self.headerView;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        if (section == 0) {
            CGFloat he = ( 10 + 70 * (ceilf(self.iconArray.count/5.0)) * ScreenScale) + 170 * ScreenScale;
            return he;
        }else{
            return 40;
        }
    }else {
        return CGFLOAT_MIN;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.cellSelcetBlock) {
        self.cellSelcetBlock(tableView, indexPath);
    }
}

#pragma mark  -----------getter && setter -----------

- (NSMutableArray *)dataArray {
    if (!_dataArray ) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)iconArray {
    if (!_iconArray) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UIView *headerContentView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
        headerContentView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:headerContentView];
        headerContentView.xk_radius = 8;
        headerContentView.xk_clipType = XKCornerClipTypeTopBoth;
        headerContentView.xk_openClip = YES;
        _headerView.backgroundColor = [UIColor clearColor];
        UIView *buttonContentView  =  [[UIView alloc]init];
        [headerContentView addSubview:buttonContentView];
        [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_headerView);
            make.height.equalTo(self->_headerView.mas_height);
            make.width.equalTo(@100);
        }];
        _segmentControl = [[CommonSegmentControl alloc]initWithFrame:CGRectMake(0, 10, 100, 25) items:@[@"热门", @"附近"] toSuperView:self.headerView swipView:nil];
        _segmentControl.titleColor = HEX_RGB(0x777777);
        _segmentControl.selectColor = HEX_RGB(0x222222);
        _segmentControl.titleFont = XKFont(XK_PingFangSC_Regular, 14);
        _segmentControl.selectFont = XKFont(XK_PingFangSC_Regular, 17);
        _segmentControl.lineColor = XKMainTypeColor;
        _segmentControl.duration = 0.3;
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.lineWidth = 40;
        [_segmentControl addTarget:self action:@selector(segmentChange:)];
        [buttonContentView addSubview:_segmentControl];
        
    }
    return _headerView;
}

- (void)segmentChange:(CommonSegmentControl *)sender {
    NSLog(@"%ld", (long)sender.selectedIndex);
    if (sender.selectedIndex == 0) {
        _orderType = @"POPULARITY";
        [self loadRequestShopListisRefresh:YES WithType:@"POPULARITY" Block:^(NSMutableArray * _Nonnull array) {
            
        }];
    }else if (sender.selectedIndex == 1){
        _orderType = @"DISTANCE";
        [self loadRequestShopListisRefresh:YES WithType:@"DISTANCE" Block:^(NSMutableArray * _Nonnull array) {
            
        }];
        
    }
}


#pragma mark  -----------网络请求 -----------

/**
 首页icon的列表

 @param block 首页icon的列表数据返回
 */
- (void)loadIconListBlock:(void(^)(NSMutableArray *array))block {
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/industryQList/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        if (responseObject) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:responseObject];
            self.iconArray = [self reAreaHomeIcon:array].copy;
            block(self.iconArray);
            [self reloadData];
        }
    } failure:^(XKHttpErrror *error) {
        
    }];
}

- (NSArray *)reAreaHomeIcon:(NSArray *)iconArr {
    
    XKUserInfo *info =  [XKUserInfo currentUser];
    
    NSMutableArray *fixedArr =  [NSMutableArray array];
    NSMutableArray *notFixedArr =  [NSMutableArray array];
    for (XKSquareHomeToolModel *item in iconArr) {
        if ([item.status isEqualToString:@"del"]) {
            
        }else{
            if (item.moveEnable) {
                [notFixedArr addObject:item];
            } else {
                [fixedArr addObject:item];
            }
        }
    }
    //保存系统的
    info.xkTradingAreaSysIcon = [fixedArr yy_modelToJSONString];
    [XKUserInfo saveCurrentUser:info];
    
    return [XKGlobleCommonTool recombineIconArrWithFixedArr:fixedArr notFixedArr:notFixedArr iconType:BannerIconType_tradingArea];
    
}

- (void)refreshAreaToolView {
    
    NSArray *sysIconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:[XKUserInfo currentUser].xkTradingAreaSysIcon];
    NSMutableArray *sysMuarr = [NSMutableArray arrayWithArray:sysIconArr];
    
    NSArray *optionIconArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:[XKUserInfo currentUser].xkTradingAreaOptionalIcon];
    NSMutableArray *optionMuarr = [NSMutableArray arrayWithArray:optionIconArr];
    
    self.iconArray = [XKGlobleCommonTool recombineIconArrWithFixedArr:sysMuarr notFixedArr:optionMuarr iconType:BannerIconType_tradingArea].mutableCopy;
    [self reloadData];
}

- (void)loadBannerBlock:(void(^)(NSMutableArray *array))block {
    [XKSquareBannerModel requestBannerListWithBannerType:BannerType_Area TypeSuccess:^(NSArray *modelList) {
        self.bannerArray = modelList.mutableCopy;
        [self reloadData];
        block(modelList.mutableCopy);
    } failed:^(NSString *failedReason) {
        NSLog(@"%@", failedReason);
    }];
}

- (void)loadRequestShopListisRefresh:(BOOL)isRefresh WithType:(NSString *)orderType Block:(void(^)(NSMutableArray *array))block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [parameters setObject:@(1) forKey:@"page"];
    } else {
        [parameters setObject:@(self.page + 1) forKey:@"page"];
        
    }
    [parameters setObject:@(_limit) forKey:@"limit"];
    parameters[@"lng"] = [NSString stringWithFormat:@"%f",[[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude].longitude];
    parameters[@"lat"] = [NSString stringWithFormat:@"%f",[[XKBaiduLocation shareManager]getUserLocationLaititudeAndLongtitude].latitude];
    parameters[@"orderType"] = orderType;

    [HTTPClient postEncryptRequestWithURLString:@"goods/ua/esPopularityShopPage/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        NSArray *array = [NSArray array];
        if (responseObject) {
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            XKTradingShopListModel *model = [XKTradingShopListModel yy_modelWithJSON:responseObject];
            array = model.data.mutableCopy;
            
            if (self.dataArray.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];

            [self reloadData];
            block(self.dataArray);
        }else {
            block(nil);
        }
    } failure:^(XKHttpErrror *error) {
        self.refreshStatus = Refresh_NoNet;
        [XKHudView showErrorMessage:error.message to:nil time:2.0 animated:YES completion:nil];
        block(nil);
    }];
}

- (void)reloadData {
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}
@end
