//
//  XKMallMerchantViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallMerchantViewController.h"
#import "XKCustomNavBar.h"
#import "XKMallMainHeaderView.h"
#import "XKMallMainFooterView.h"
#import "XKMallMainSingleCell.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKMallMerchantTopCollectionViewCell.h"
#import "XKMallListViewModel.h"
#import "XKMallMainItemCollectionViewCell.h"
#import "XKMallMainBannerCell.h"
#import "XKMallMainCollectionViewFlowLayout.h"
#import "XKMallGoodsCategoryViewController.h"
#import "XKMallMainViewController.h"
#import "XKMallListViewModel.h"
#import "XKMallCategoryListModel.h"


typedef NS_ENUM(NSInteger, XKMallMainLayout) {
    XKMallMainLayoutSingleLayout    = 0,        // 列表
    XKMallMainLayoutDoubleLayout    = 1,        // 宫格
};
@interface XKMallMerchantViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XKMallMainCollectionViewFlowLayout,UITextFieldDelegate>
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *iconDataArr;
@property (nonatomic, strong) NSArray *goosDataArr;
@property (nonatomic, strong) NSMutableArray  *bannerArr;
@property (nonatomic, assign) XKMallMainLayout  layoutType;
@property (nonatomic, strong) XKMallMainHeaderView  *layoutHeaderView;
@property (nonatomic, strong) XKMallMainFooterView  *moreFootView;
@property (nonatomic, strong) dispatch_group_t  networkGroup;
@end

@implementation XKMallMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self.collectionView.mj_header beginRefreshing];
}

- (void)handleData {
    [super handleData];
  
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
}

- (void)gotoDeatilWithItem:(MallGoodsListItem *)item {
    
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = item.ID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requestData {
    XKWeakSelf(ws);
    NSDictionary *parmDic = @{
                              @"page" : @1,
                              @"limit" : @4,
                              @"condition" : @{ @"address" : @"510107"},
                              };
    
    [XKMallGoodsListModel requestMallRecommendGoodsListWithParam:parmDic Success:^(NSArray *modelList) {
        ws.goosDataArr = modelList;
      
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
      
    }];
}
#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 1 : _goosDataArr.count;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 30);
    }
    return CGSizeZero;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UIView *contentView;
        NSString *identifier;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            identifier = @"XKMallMainHeaderView";
            contentView = self.layoutHeaderView;
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
            [view addSubview:contentView];
            return view;
        }
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 10)];
    contentView.backgroundColor = [UIColor clearColor];
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    [view addSubview:contentView];
    return  view;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if (indexPath.section == 0) {
    XKMallMerchantTopCollectionViewCell *infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallMerchantTopCollectionViewCell" forIndexPath:indexPath];
        return infoCell;
        
    } else if (indexPath.section == 1) {
        XKMallMainSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallMainSingleCell" forIndexPath:indexPath];
        [singleCell bindData:_goosDataArr[indexPath.row]];
        if(_goosDataArr.count == 1) {
            [singleCell cutCornerForType:XKCornerCutTypeLastCell WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 130)];
        } else {
            if(indexPath.row == _goosDataArr.count - 1) {
                [singleCell cutCornerForType:XKCornerCutTypeLastCell WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 130)];
            } else {
                singleCell.layer.mask = nil;
            }
        }
        return singleCell;
    }
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//     return CGSizeMake(SCREEN_WIDTH - 20, 155);
//    } else {
//         return CGSizeMake(SCREEN_WIDTH - 20, 130);
//    }
//
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        MallGoodsListItem *item = _goosDataArr[indexPath.row];
        [self gotoDeatilWithItem:item];
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
         return UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return UIEdgeInsetsZero;
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH - 20 , 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallMainHeaderView"];

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        
        [_collectionView registerClass:[XKMallMainSingleCell class] forCellWithReuseIdentifier:@"XKMallMainSingleCell"];
        [_collectionView registerClass:[XKMallMerchantTopCollectionViewCell class] forCellWithReuseIdentifier:@"XKMallMerchantTopCollectionViewCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestData];
        }];
        _collectionView.mj_header = narmalHeader;
    }
    return _collectionView;
}



- (XKCustomNavBar *)navBar {
    if(!_navBar) {
        XKWeakSelf(ws);
        _navBar  =  [[XKCustomNavBar alloc] init];
        [_navBar customBaseNavigationBar];
        _navBar.titleLabel.text = @"商家详情";
    }
    return _navBar;
}

- (XKMallMainHeaderView *)layoutHeaderView {
    XKWeakSelf(ws);
    if (!_layoutHeaderView) {
        _layoutHeaderView = [[XKMallMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 30)];
        _layoutHeaderView.layoutBlock = ^(UIButton *sender) {
            ws.layoutType = ws.layoutType == XKMallMainLayoutSingleLayout ? XKMallMainLayoutDoubleLayout : XKMallMainLayoutSingleLayout;
            [ws.collectionView reloadData];
        };
    }
    return _layoutHeaderView;
}

- (XKMallMainFooterView *)moreFootView {
    if (!_moreFootView) {
        _moreFootView = [[XKMallMainFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 35)];
        _moreFootView.moreBlock = ^(UIButton *sender) {
            
        };
    }
    return _moreFootView;
    
}

@end
