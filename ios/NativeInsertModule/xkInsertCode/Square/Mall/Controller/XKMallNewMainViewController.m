//
//  XKMallNewMainViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallNewMainViewController.h"
#import "XKCustomNavBar.h"
#import "XKCommonSheetView.h"
#import "XKMallMainHeaderView.h"
#import "XKMallMainFooterView.h"
#import "XKMallMainSingleCell.h"
#import "XKMallMainDoubleCell.h"
#import "XKMallBuyCarViewController.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKAlertView.h"
#import "XKDeviceDataLibrery.h"
#import "XKMallListViewModel.h"
#import "XKMallSearchGoodsViewController.h"
#import "XKMallMainItemCollectionViewCell.h"
#import "XKMallMainBannerCell.h"
#import "XKMallMainCollectionViewFlowLayout.h"
#import "XKMallGoodsCategoryViewController.h"
#import "XKMallMainViewController.h"
#import "XKMallListViewModel.h"
#import "XKMallCategoryListModel.h"
#import "XKMallBuyCarViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMainMallOrderViewController.h"
#import "XKIMGlobalMethod.h"
#import "XKSquareBannerModel.h"
#import "XKSqureSearchViewController.h"
#import "XKJumpWebViewController.h"
typedef NS_ENUM(NSInteger, XKMallMainLayout) {
    XKMallMainLayoutSingleLayout    = 0,        // 列表
    XKMallMainLayoutDoubleLayout    = 1,        // 宫格
};
@interface XKMallNewMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XKMallMainCollectionViewFlowLayout,UITextFieldDelegate>
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

@implementation XKMallNewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDataForFist:YES];
}

- (void)handleData {
    [super handleData];
    _iconDataArr = [NSMutableArray array];
    _bannerArr = [NSMutableArray array];
    XKUserInfo *info =  [XKUserInfo currentUser];
    NSArray *sysArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmallsysicon];
    NSArray *userArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmallusericon];
    NSArray *optionalArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmalloptionalicon];
    NSArray *bannerOldArr = [NSArray yy_modelArrayWithClass:[XKSquareBannerModel class] json:info.xkmallbanner];
    [_bannerArr addObjectsFromArray:bannerOldArr];
    [_iconDataArr addObjectsFromArray:sysArr];
    NSMutableArray *tmpUserArr = [NSMutableArray array];
    [tmpUserArr addObjectsFromArray:userArr];
    //去重
        for (MallIconItem *icon in sysArr) {
              for (MallIconItem *item in userArr) {
            if (icon.code == item.code) {
                [tmpUserArr removeObject:item];
            }
        }
    }
    
    if (_iconDataArr.count < 9) {
        NSInteger other = 9 - _iconDataArr.count;
        if (other > 0) {
            if (tmpUserArr.count > 0) {
                if (tmpUserArr.count > other) {
                    for (NSInteger i = 0; i < other; i ++) {
                        MallIconItem *item = tmpUserArr[i];
                        [_iconDataArr addObject:item];

                    }
                } else {
                    [_iconDataArr addObjectsFromArray:tmpUserArr];
                }
            }
        }
         other = 9 - _iconDataArr.count;
        if (other > 0) {
            //去重 去权重
            NSMutableArray *tmpOptionalArr = [NSMutableArray array];
            NSMutableArray *addOptionalArr = [NSMutableArray array];
            [tmpOptionalArr addObjectsFromArray:optionalArr];
            [addOptionalArr addObjectsFromArray:optionalArr];
            
            for (MallIconItem *icon in _iconDataArr) {
                for (MallIconItem *item in optionalArr) {
                    if (icon.code == item.code || item.weight == 2) {
                        [tmpOptionalArr removeObject:item];
                    }
                }
            }
            
            //去权重
            for (MallIconItem *icon in _iconDataArr) {
                for (MallIconItem *item in optionalArr) {
                    if (icon.code == item.code || item.weight == 2) {
                        [addOptionalArr removeObject:item];
                    }
                }
            }
            if (addOptionalArr.count > other) {
                for (NSInteger i = 0; i < other; i ++) {
                    MallIconItem *item = addOptionalArr[i];
                    [_iconDataArr addObject:item];
                }
            } else {
                [_iconDataArr addObjectsFromArray:addOptionalArr];
            }
        }
    }
    
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

- (void)requestDataForFist:(BOOL)isFirst {
  
    if (isFirst) {
        self.collectionView.hidden = YES;
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    XKWeakSelf(ws);
    self.networkGroup  = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(self.networkGroup);
    dispatch_group_async(self.networkGroup, queue, ^{
        [ws requestIconData];
    });
    
    dispatch_group_enter(self.networkGroup);
    dispatch_group_async(self.networkGroup, queue, ^{
        [ws requestRecommendData];
    });
    
    dispatch_group_enter(self.networkGroup);
    dispatch_group_async(self.networkGroup, queue, ^{
        [ws requestBannerData];
    });
    
    dispatch_group_notify(self.networkGroup, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [XKHudView hideAllHud];
            self.collectionView.hidden = NO;
            [ws.collectionView.mj_header endRefreshing];
            [ws.collectionView reloadData];
            ws.networkGroup = nil;
        });

    });
}

- (void)requestBannerData {
    XKWeakSelf(ws);
    [XKSquareBannerModel requestBannerListWithBannerType:BannerType_Mall TypeSuccess:^(NSArray *modelList) {
        [ws.bannerArr removeAllObjects];
        [ws.bannerArr addObjectsFromArray:modelList];;
        XKUserInfo *info =  [XKUserInfo currentUser];
        info.xkmallbanner = [modelList yy_modelToJSONString];
        [XKUserInfo saveCurrentUser:info];
        dispatch_group_leave(ws.networkGroup);
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        dispatch_group_leave(ws.networkGroup);
    }];
}

- (void)requestIconData {
     XKWeakSelf(ws);
    [XKMallCategoryListModel requestNewMallIconListSuccess:^(XKMallCategoryListModel *model) {
        [ws.iconDataArr removeAllObjects];
        if (model.fixed.count > 9) {
            for (NSInteger i = 0; i < 9; i++) {
                [ws.iconDataArr addObject:model.fixed[i]];
            }
        } else {
            [ws.iconDataArr addObjectsFromArray:model.fixed];
        }
       
        NSMutableArray *tmpUserArr = [NSMutableArray array];
        NSMutableArray *tmpOptionalArr = [NSMutableArray array];
        NSMutableArray *addOptionalArr = [NSMutableArray array];
        if (ws.iconDataArr.count < 9) {
            NSInteger other = 9 - ws.iconDataArr.count;
            if (other > 0) {
                XKUserInfo *info = [XKUserInfo currentUser];
            NSArray *userArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmallusericon];

               
                [tmpUserArr addObjectsFromArray:userArr];
                //去重  后台配置的和之前用户选择的有冲突
                for (MallIconItem *icon in model.fixed) {
                    for (MallIconItem *item in userArr) {
                        if (icon.code == item.code) {
                            [tmpUserArr removeObject:item];
                        }
                    }
                }
                
            if (tmpUserArr.count > 0) {
                //后台配多了 要顶掉一部分用户的
                if (tmpUserArr.count > other) {
                    for (NSInteger i = 0; i < other; i ++) {
                        MallIconItem *item = tmpUserArr[i];
                        [ws.iconDataArr addObject:item];
        
                    }
                } else {
                    [ws.iconDataArr addObjectsFromArray:tmpUserArr];
                }
            }
            }
            //后台+用户的还是不够  就从可选中来拿
            other = 9 - ws.iconDataArr.count;
            if (other > 0) {
                //去重
                [tmpOptionalArr addObjectsFromArray: model.notFixed];
                [addOptionalArr addObjectsFromArray: model.notFixed];
                for (MallIconItem *icon in ws.iconDataArr) {
                    for (MallIconItem *item in model.notFixed) {
                        if (icon.code == item.code ) {
                            [tmpOptionalArr removeObject:item];
                        }
                    }
                }
                //去权重
                for (MallIconItem *icon in ws.iconDataArr) {
                    for (MallIconItem *item in model.notFixed) {
                        if (icon.code == item.code || item.weight == 2) {
                            [addOptionalArr removeObject:item];
                        }
                    }
                }
                
            if (addOptionalArr.count > other) {
                for (NSInteger i = 0; i < other; i ++) {
                    MallIconItem *item = addOptionalArr[i];
                    [ws.iconDataArr addObject:item];
    
                }
            } else {
                [ws.iconDataArr addObjectsFromArray:addOptionalArr];
            }
            }
        }
        if (model) {
            XKUserInfo *info =  [XKUserInfo currentUser];
            info.xkmallsysicon = [model.fixed yy_modelToJSONString];
            info.xkmalloptionalicon = [model.notFixed yy_modelToJSONString];
            info.xkmallusericon = [tmpUserArr yy_modelToJSONString];
            [XKUserInfo saveCurrentUser:info];
        }
        dispatch_group_leave(ws.networkGroup);
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        dispatch_group_leave(ws.networkGroup);
    }];
}

- (void)requestRecommendData {
    XKWeakSelf(ws);
    NSDictionary *parmDic = @{
                              @"page" : @1,
                              @"limit" : @100,
                              @"condition" : @{ @"districtCode" : @"510107"},
                              };
    
    [XKMallGoodsListModel requestMallRecommendGoodsListWithParam:parmDic Success:^(NSArray *modelList) {
        ws.goosDataArr = modelList;
        dispatch_group_leave(ws.networkGroup);
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        dispatch_group_leave(ws.networkGroup);
    }];
}
#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 1 : section == 1 ? 1 : _goosDataArr.count;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (_goosDataArr.count > 0) {
            return  CGSizeMake(SCREEN_WIDTH - 20, 50);
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeMake(SCREEN_WIDTH - 20, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (_goosDataArr.count > 0) {
            return  CGSizeMake(SCREEN_WIDTH, 30);
        } else {
            return CGSizeZero;
        }
    } else if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 10);
    }
    return CGSizeZero;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 2) {
     UIView *contentView;
     NSString *identifier;
     if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
         identifier = @"XKMallMainHeaderView";
         contentView = self.layoutHeaderView;
         UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
         [view addSubview:contentView];
         return view;
     } else {
         identifier = @"XKMallMainFooterView";
         contentView = self.moreFootView;
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
        
        XKMallMainBannerCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallMainBannerCell" forIndexPath:indexPath];
        [item.loopView setScrollViewItems:_bannerArr];
        item.loopView.tapBlock = ^(NSInteger type, NSString *jumpStr) {
            if (type == 1) {//h5
                XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
                vc.url = jumpStr;
                [ws.navigationController pushViewController:vc animated:YES];
            }

        };
        return item;
        
    } else if (indexPath.section == 1) {
       
        XKMallMainItemCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallMainItemCollectionViewCell" forIndexPath:indexPath];
        item.dataSourceArr = self.iconDataArr.copy;
        item.choseBlock = ^(NSInteger index) {
            
            if (index == ws.iconDataArr.count) {
                XKMallGoodsCategoryViewController *category = [XKMallGoodsCategoryViewController new];
                category.type = CategoryTypeMall;
                category.refreshBlock = ^{
                    [ws handleData];
                    [ws.collectionView reloadData];
                };
                [self.navigationController pushViewController:category animated:YES];
            } else {
                XKMallMainViewController *main = [XKMallMainViewController new];
                MallIconItem *item = ws.iconDataArr[index];
                main.categoryCode = @(item.code).stringValue;
                [self.navigationController pushViewController:main animated:YES];
            }
        };
        
        return item;
        
    } else if (indexPath.section == 2) {
        
    if (self.layoutType == XKMallListLayoutSingle) {
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
    } else {
        XKMallMainDoubleCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallMainDoubleCell" forIndexPath:indexPath];
        [doubleCell bindData:_goosDataArr[indexPath.row]];
        return doubleCell;
    }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH - 20, 155);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH - 20, 160*ScreenScale);
    } else {
        if(self.layoutType == XKMallListLayoutSingle) {
            return CGSizeMake(SCREEN_WIDTH - 20, 130);
        } else {
            return  CGSizeMake((SCREEN_WIDTH - 20 - 45)/2, 265);
        }
    }

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        if(self.layoutType == XKMallMainLayoutSingleLayout) {
            return 0;
        } else {
            return  15;
        }
    }
    return 10;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        if (self.layoutType == XKMallMainLayoutSingleLayout) {
            return 0;
        } else {
            return  10;
        }
    }
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
    if (section == 2) {
        if (self.layoutType == XKMallMainLayoutSingleLayout) {
            return UIEdgeInsetsMake(0, 15, 0, 15);
        } else {
            return  UIEdgeInsetsMake(10, 15, 10, 15);
        }
    }
    return UIEdgeInsetsZero;
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    return section  == 2 ? [UIColor whiteColor] : [UIColor clearColor];
}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        XKMallMainCollectionViewFlowLayout *layout = [[XKMallMainCollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallMainHeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKMallMainFooterView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        
        [_collectionView registerClass:[XKMallMainSingleCell class] forCellWithReuseIdentifier:@"XKMallMainSingleCell"];
        [_collectionView registerClass:[XKMallMainDoubleCell class] forCellWithReuseIdentifier:@"XKMallMainDoubleCell"];
        [_collectionView registerClass:[XKMallMainItemCollectionViewCell class] forCellWithReuseIdentifier:@"XKMallMainItemCollectionViewCell"];
       [_collectionView registerClass:[XKMallMainBannerCell class] forCellWithReuseIdentifier:@"XKMallMainBannerCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [ws requestDataForFist:NO];
        }];
        _collectionView.mj_header = narmalHeader;
    }
    return _collectionView;
}



- (XKCustomNavBar *)navBar {
    if(!_navBar) {
        XKWeakSelf(ws);
        _navBar  =  [[XKCustomNavBar alloc] init];
        [_navBar customWelfareNewNaviBar];
        
        _navBar.inputTextFieldBlock = ^(NSString *text) {
            XKSqureSearchViewController *vc = [[XKSqureSearchViewController alloc] init];
            vc.searchType = SearchEntryType_Mall;
            [ws.navigationController pushViewController:vc animated:NO];
        };
        
        _navBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
        
        _navBar.messageButtonBlock = ^{
           [XKIMGlobalMethod gotoCustomerSerChatList ];
        };
        
        _navBar.buyCarButtonBlock = ^{
            XKMallBuyCarViewController *buyCarVC = [XKMallBuyCarViewController new];
            [ws.navigationController pushViewController:buyCarVC animated:YES];
        };
        
        _navBar.orderButtonBlock = ^{
            XKMainMallOrderViewController *orderVC = [XKMainMallOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return _navBar;
}

- (XKMallMainHeaderView *)layoutHeaderView {
    XKWeakSelf(ws);
    if (!_layoutHeaderView) {
        _layoutHeaderView = [[XKMallMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
        _layoutHeaderView.layoutBlock = ^(UIButton *sender) {
            ws.layoutType = ws.layoutType == XKMallMainLayoutSingleLayout ? XKMallMainLayoutDoubleLayout : XKMallMainLayoutSingleLayout;
            [ws.collectionView reloadData];
        };
    }
    return _layoutHeaderView;
}

- (XKMallMainFooterView *)moreFootView {
    if (!_moreFootView) {
        XKWeakSelf(ws);
        _moreFootView = [[XKMallMainFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 35)];
        _moreFootView.moreBlock = ^(UIButton *sender) {
            XKMallMainViewController *main = [XKMallMainViewController new];
            [ws.navigationController pushViewController:main animated:YES];
        };
    }
    return _moreFootView;
   
}
@end
