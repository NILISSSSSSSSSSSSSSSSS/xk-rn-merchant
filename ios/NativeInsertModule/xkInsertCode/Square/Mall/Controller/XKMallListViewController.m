//
//  XKMallListViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallListViewController.h"
#import "XKMallListSingleCell.h"
#import "XKMallListDoubleCell.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKAlertView.h"
#import "XKDeviceDataLibrery.h"
@interface XKMallListViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArr;

@end

@implementation XKMallListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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

- (void)setModel:(XKMallCategoryListModel *)model {
    _model = model;
    _viewModel = [XKMallListViewModel new];
    _viewModel.page = 0;
    _viewModel.isDesc = 1;
    _viewModel.limit = 10;
    if ([model.listType isEqualToString:@"recommend"]) {//推荐
        _viewModel.type = @"POPULARITY_DESC";
    } else {
        _viewModel.type = @"popularity";
        _viewModel.category = _model.code;
      //  _viewModel.timestamp = ceilf([[NSDate date] timeIntervalSince1970]);
    }
    [self requestDataWithTips:NO code:_viewModel.category];

}

- (void)refreshDataWithCode:(NSInteger)code {
    self.viewModel.category = code;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark 网络请求
- (void)filterRefreshWithType:(XKMllFilterType)filterType sort:(NSInteger)sort {
    NSString *searchType;
      if ([_model.listType isEqualToString:@"recommend"]) {//推荐
          switch (filterType) {
              case 0:
              {
                  if (sort == 1) {
                      searchType = @"POPULARITY_ASC";
                  } else {
                       searchType = @"POPULARITY_DESC";
                  }
              }

                  break;
              case 1:
              {
                  if (sort == 1) {
                       searchType = @"SALE_NUM_ASC";
                  } else {
                       searchType = @"SALE_NUM_DESC";
                  }
              }
                  break;
              case 2:
              {
                  if (sort == 1) {
                       searchType = @"PRICE_ASC";
                  } else {
                       searchType = @"PRICE_DESC";
                  }
              }
                  break;
                  
              default:
                  break;
          }
      } else {
          switch (filterType) {
              case 0:
                searchType = @"popularity";
                  break;
              case 1:
                searchType = @"saleQ";
                  break;
              case 2:
                searchType = @"price";
                  break;
                  
              default:
                  break;
          }
      }
    _viewModel.type = searchType;
    _viewModel.isDesc = sort;
    _viewModel.page = 0;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark network
// 请求第一页数据 可能有缓存
- (void)requestDataWithTips:(BOOL)tip code:(NSInteger)code {
    if (tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _viewModel.page ++;
    NSDictionary *dic;
    if ([_model.listType isEqualToString:@"recommend"]) {//推荐

        dic = @{
                @"page" :  @(_viewModel.page),
                @"limit" : @(_viewModel.limit),
                @"condition" : @{ @"districtCode" : @"510107",
                                  @"orderType" :  _viewModel.type
                                  },
                
               };
        [XKMallGoodsListModel requestMallRecommendGoodsListWithParam:dic Success:^(NSArray *modelList) {
            [self handleSuccessDataWithModel:modelList];
        } failed:^(NSString *failedReason) {
            [self handleErrorDataWithReason:failedReason];
        }];
    } else {
        dic = @{@"condition": @{@"category": @(_viewModel.category),
                                },
                @"sort"     : @{@"type"    : _viewModel.type,
                                @"isDesc"  : @(_viewModel.isDesc)
                                },
                @"page"     : @(_viewModel.page),
                @"limit"    : @(_viewModel.limit),
                
                };
        [XKMallGoodsListModel requestMallGoodsListWithParam:dic Success:^(NSArray *modelList) {
            [self handleSuccessDataWithModel:modelList];
        } failed:^(NSString *failedReason) {
            [self handleErrorDataWithReason:failedReason];
        }];
    }

}

- (void)handleSuccessDataWithModel:(NSArray *)listModel {
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
        _dataArr = nil;
        if (listModel == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [self.collectionView.mj_header beginRefreshing];
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
    XKWeakSelf(ws);
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    if (_dataArr.count == 0) {//无数据 请求第一页 请求出错
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
            [ws requestDataWithTips:YES code:ws.viewModel.category];
        }];
    } else {//请求更多出错
        [self.emptyTipView hide];
        [XKHudView showErrorMessage:reason];
    }
}

- (void)gotoDeatilWithItem:(MallGoodsListItem *)item {
    
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = item.ID;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 10);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.layoutType == XKMallListLayoutSingle) {
        XKMallListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListSingleCell" forIndexPath:indexPath];
        [singleCell bindData:_dataArr[indexPath.row]];
        if(_dataArr.count == 1) {
            singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
            } else if(indexPath.row == _dataArr.count - 1) {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeNone;
            }
        }
        return singleCell;
    } else {
        XKMallListDoubleCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallListDoubleCell" forIndexPath:indexPath];
        [doubleCell bindData:_dataArr[indexPath.row]];
        return doubleCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.layoutType == XKMallListLayoutSingle) {
        return CGSizeMake(SCREEN_WIDTH, 90);
    } else {
        return  CGSizeMake((SCREEN_WIDTH - 30)/2, 240);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKMallListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKMallListLayoutSingle) {
        return 0;
    } else {
        return  10;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(self.layoutType == XKMallListLayoutSingle) {
        return UIEdgeInsetsZero;
    } else {
        return  UIEdgeInsetsMake(0, 10, 0, 10);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    MallGoodsListItem *item = _dataArr[indexPath.row];
    [self gotoDeatilWithItem:item];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - 44) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareListHeader"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKWelfareListFooter"];
        [_collectionView registerClass:[XKMallListSingleCell class] forCellWithReuseIdentifier:@"XKMallListSingleCell"];
        [_collectionView registerClass:[XKMallListDoubleCell class] forCellWithReuseIdentifier:@"XKMallListDoubleCell"];
        
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestDataWithTips:NO code:ws.viewModel.category];
        }];
//        narmalHeader.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
//            ws.viewModel.timestamp = ceilf([lastUpdatedTime timeIntervalSince1970]);
//            return [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithDate:[NSDate date]];
//        };
        self.collectionView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestDataWithTips:NO code:ws.viewModel.category];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer = foot;
    }
    return _collectionView;
}

@end
