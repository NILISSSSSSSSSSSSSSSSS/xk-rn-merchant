//
//  XKWelfareListViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareListViewController.h"
#import "XKWelfareListSingleCell.h"
#import "XKWelfareListSingleTimeCell.h"
#import "XKWelfareListSingleProgressCell.h"
#import "XKWelfareListSingleProgressAndTimeCell.h"
#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareListDoubleCell.h"
#import "XKWelfareListDoubleTimeCell.h"
#import "XKWelfareListDoubleProgressCell.h"
#import "XKWelfareListDoubleProgressAndTimeCell.h"
#import "XKWelfareListDoubleProgressOrTimeCell.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKWelfareGoodsListViewModel.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKDeviceDataLibrery.h"
#import "XKWelfareGoodsListViewModel.h"
#import "XKWelfareBuySuccessViewController.h"
@interface XKWelfareListViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)XKWelfareGoodsListViewModel *viewModel;

@end

@implementation XKWelfareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)handleData {
    [super handleData];

}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.collectionView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.collectionView config:nil];
}

- (void)updateLayout {

    [self.collectionView reloadData];
}

- (void)setType:(NSInteger)type {
    _type = type;
    _viewModel = [XKWelfareGoodsListViewModel new];
    _viewModel.page = 0;
    _viewModel.limit = 10;
    _viewModel.category = _model.code;
    _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setModel:(XKWelfareCategoryModel *)model {
    _model = model;
   

}


#pragma mark network
- (void)refreshData {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestDataWithType:(NSInteger)type {
    switch (type) {
        case 0:
        {
            [self requestReCommentData];
        }
            break;
        case 1:
        {
           [self requestWelfareData];
        }
            break;
        case 2:
        {
            [self requestPlatFormData];
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)requestPlatFormData {
    
    _viewModel.page ++;
    if(_viewModel.page == 1) { //第一页  更新时间戳
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{@"limit":@(_viewModel.limit),
                          @"page":@(_viewModel.page),
                          };
    
    [XKWelfareGoodsListViewModel requestWelfarePlatformGoodsListWithParam:dic success:^(NSArray *modelList) {
        [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)requestStoreData {
    
    _viewModel.page ++;
    if(_viewModel.page == 1) { //第一页  更新时间戳
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{@"limit":@(_viewModel.limit),
                          @"page":@(_viewModel.page),
                          };
    
    [XKWelfareGoodsListViewModel requestWelfareStoremGoodsListWithParam:dic success:^(NSArray *modelList) {
        [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)requestReCommentData {

    _viewModel.page ++;
    if(_viewModel.page == 1) { //第一页  更新时间戳
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{@"limit":@(_viewModel.limit),
                          @"page":@(_viewModel.page),
                          @"jCondition" : @{ @"districtCode" : @"110201"}
          
                          };

    [XKWelfareGoodsListViewModel requestWelfareRecommendGoodsListWithParam:dic success:^(NSArray *modelList) {
       [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)requestWelfareData {
    
    _viewModel.page ++;
    if(_viewModel.page == 1) { //第一页  更新时间戳
        _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    NSDictionary *dic = @{@"limit":@(_viewModel.limit),
                          @"page":@(_viewModel.page),
                          @"jmallEsSearch":@{@"keyWord": @"",
                                        },
                          //@"lastUpdateAt":@(_viewModel.timestamp)
                          };
    [XKWelfareGoodsListViewModel requestWelfareGoodsListWithParam:dic success:^(NSArray *modelList) {
        [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(NSArray *)listModel {
    [XKHudView hideAllHud];
    XKWeakSelf(ws);
    [self.emptyTipView hide];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
         _dataArr = nil;
        if (listModel == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [ws.collectionView.mj_header beginRefreshing];
            }];
        }
    }
    
    if (listModel == nil) {
        _viewModel.page --;
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:_dataArr];
        [tmp addObjectsFromArray:listModel];
        _dataArr = [tmp copy];
    }
    [self.collectionView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    _viewModel.page --;
    [self.emptyTipView hide];
    XKWeakSelf(ws);
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    if (self.viewModel.dataSourceArr.count == 0) {//无数据 请求第一页 请求出错
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
              [ws.collectionView.mj_header beginRefreshing];
        }];
    } else {//请求更多出错
       [self.emptyTipView hide];
       [XKHudView showErrorMessage:reason];
    }
    
}

- (void)gotoDeatilWithItem:(WelfareDataItem *)item {
    
    XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
    detail.goodsId = item.goodsId;
    
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
     return CGSizeZero;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     WelfareDataItem * item = self.dataArr[indexPath.row];
    if(self.layoutType == XKWelfareListLayoutSingle) {
        XKWelfareListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleCell" forIndexPath:indexPath];
        if ([item.drawType isEqualToString:@"bytime"]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:@"bymember"]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell" forIndexPath:indexPath];
            
        } else if ([item.drawType isEqualToString:@"bytime_and_bymember"]) {
            singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell" forIndexPath:indexPath];
        }
        [singleCell bindData:item WithType:0];
        
        if(_dataArr.count == 1) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
            [singleCell hiddenSeperateLine:YES];
        } else {
            if(indexPath.row == 0) {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
                [singleCell hiddenSeperateLine:NO];
            } else if(indexPath.row == _dataArr.count - 1) {
                 singleCell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
                [singleCell hiddenSeperateLine:NO];
            } else {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeNone;
                [singleCell hiddenSeperateLine:NO];
            }
        }
        
        return singleCell;
    } else {
        XKWelfareListDoubleCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleCell" forIndexPath:indexPath];
        if ([item.drawType isEqualToString:@"bytime"]) {
            doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleTimeCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:@"bymember"]) {
            doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleProgressCell" forIndexPath:indexPath];
        } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
            doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleProgressOrTimeCell" forIndexPath:indexPath];
            
        } else if ([item.drawType isEqualToString:@"bytime_and_bymember"]) {
            doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListDoubleProgressAndTimeCell" forIndexPath:indexPath];
        }
        [doubleCell bindData:item];
        return doubleCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WelfareDataItem * item = self.dataArr[indexPath.row];
    if(self.layoutType == XKWelfareListLayoutSingle) {
        if ([item.drawType isEqualToString:@"bytime"]) {
            return CGSizeMake(SCREEN_WIDTH, 135);
        } else if ([item.drawType isEqualToString:@"bymember"]) {
            return CGSizeMake(SCREEN_WIDTH, 130);
        } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        } else if ([item.drawType isEqualToString:@"bytime_and_bymember"]) {
            return CGSizeMake(SCREEN_WIDTH, 155);
        }
        return CGSizeZero;
    } else {
        if ([item.drawType isEqualToString:@"bytime"]) {
            return CGSizeMake((SCREEN_WIDTH - 30 ) / 2, 245);
        } else if ([item.drawType isEqualToString:@"bymember"]) {
            return CGSizeMake((SCREEN_WIDTH - 30 ) / 2, 245);
        } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
            return CGSizeMake((SCREEN_WIDTH - 30 ) / 2, 275);
        } else if ([item.drawType isEqualToString:@"bytime_and_bymember"]) {
            return CGSizeMake((SCREEN_WIDTH - 30 ) / 2, 265);
        }
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKWelfareListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKWelfareListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.layoutType == XKWelfareListLayoutSingle) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    WelfareDataItem *item = _dataArr[indexPath.row];
    [self gotoDeatilWithItem:item];

}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareListHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareListFooter"];
        [_collectionView registerClass:[XKWelfareListSingleCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell"];
        [_collectionView registerClass:[XKWelfareListSingleTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressOrTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressAndTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell"];
        [_collectionView registerClass:[XKWelfareListDoubleCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleCell"];
        [_collectionView registerClass:[XKWelfareListDoubleProgressCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleProgressCell"];
        [_collectionView registerClass:[XKWelfareListDoubleTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleTimeCell"];
        [_collectionView registerClass:[XKWelfareListDoubleProgressOrTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleProgressOrTimeCell"];
        [_collectionView registerClass:[XKWelfareListDoubleProgressAndTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListDoubleProgressAndTimeCell"];
        
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestDataWithType:ws.type];
        }];
        self.collectionView.mj_header = narmalHeader;
        narmalHeader.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
            ws.viewModel.timestamp = ceilf([lastUpdatedTime timeIntervalSince1970]);
            return [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithDate:[NSDate date]];
        };
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithType:ws.type];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer = foot;
    }
    return _collectionView;
}
@end
