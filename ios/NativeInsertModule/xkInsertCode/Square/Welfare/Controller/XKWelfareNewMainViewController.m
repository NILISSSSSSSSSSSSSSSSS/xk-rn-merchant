//
//  XKWelfareNewMainViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareNewMainViewController.h"
#import "XKCustomNavBar.h"
#import "XKCommonSheetView.h"
#import "XKAlertView.h"
#import "XKDeviceDataLibrery.h"
#import "XKWelfareMainSingleCell.h"
#import "XKWelfareListSingleTimeCell.h"
#import "XKWelfareListSingleProgressCell.h"
#import "XKWelfareListSingleProgressAndTimeCell.h"
#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareMainDoubleCell.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKWelfareNewMainFunctionCell.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKWelfareMainViewController.h"
#import "XKWelfareMainHeaderView.h"
#import "XKWelfareMainHeaderView.h"
#import "XKWelfareCategoryModel.h"
#import "XKWelfareBuyCarViewController.h"
#import "XKMallMainFooterView.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMallMainItemCollectionViewCell.h"
#import "XKMallMainBannerCell.h"
#import "XKMallGoodsCategoryViewController.h"
#import "XKWelfareOrderViewController.h"
#import "XKIMGlobalMethod.h"
#import "XKSquareBannerModel.h"
#import "XKSqureSearchViewController.h"
#import "XKJumpWebViewController.h"
#import "XKLatestSecretViewController.h"
#import "XKGrandPrizeShowOrderViewController.h"
#import "XKWelfareActivityRulesViewController.h"
#import "XKWelfareMainItemCollectionViewCell.h"
typedef NS_ENUM(NSInteger, XKWelfareMainLayout) {
    XKWelfareMainLayoutSingleLayout    = 0,        // 列表
    XKWelfareMainLayoutDoubleLayout    = 1,        // 宫格
};
@interface XKWelfareNewMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *goosDataArr;
@property (nonatomic, strong) NSMutableArray *iconDataArr;
@property (nonatomic, strong) NSMutableArray  *bannerArr;
@property (nonatomic, assign)XKWelfareMainLayout  layoutType;
@property (nonatomic, strong) XKMallMainFooterView  *moreFootView;
@property (nonatomic, strong) XKWelfareMainHeaderView  *layoutView;
@property (nonatomic, strong) dispatch_group_t  networkGroup;
@end

@implementation XKWelfareNewMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDataForFist:YES];
}

- (void)handleData {
    [super handleData];
    _iconDataArr = [NSMutableArray array];
    _bannerArr = [NSMutableArray array];
    XKUserInfo *info =  [XKUserInfo currentUser];
    NSArray *bannerOldArr = [NSArray yy_modelArrayWithClass:[XKSquareBannerModel class] json:info.xkmallbanner];
    [_bannerArr addObjectsFromArray:bannerOldArr];
    NSArray *sysArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:info.xkwelfaresysicon];
//    NSArray *userArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:[XKUserInfo getCurrentMallUserIcon]];
//    NSArray *optionalArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:[XKUserInfo getCurrentMallOptionalIcon]];

   // [_iconDataArr addObjectsFromArray:sysArr];
    /*
    NSMutableArray *tmpUserArr = [NSMutableArray array];
    [tmpUserArr addObjectsFromArray:userArr];
    //去重
    for (WelfareIconItem *icon in sysArr) {
        for (WelfareIconItem *item in userArr) {
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
                        WelfareIconItem *item = tmpUserArr[i];
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
            
            for (WelfareIconItem *icon in _iconDataArr) {
                for (WelfareIconItem *item in optionalArr) {
                    if (icon.code == item.code || item.weight == 2) {
                        [tmpOptionalArr removeObject:item];
                    }
                }
            }
            
            //去权重
            for (WelfareIconItem *icon in _iconDataArr) {
                for (WelfareIconItem *item in optionalArr) {
                    if (icon.code == item.code || item.weight == 2) {
                        [addOptionalArr removeObject:item];
                    }
                }
            }
            if (addOptionalArr.count > other) {
                for (NSInteger i = 0; i < other; i ++) {
                    WelfareIconItem *item = addOptionalArr[i];
                    [_iconDataArr addObject:item];
                }
            } else {
                [_iconDataArr addObjectsFromArray:addOptionalArr];
            }
        }
    }*/
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
}

- (void)gotoDeatilWithItem:(WelfareDataItem *)item {
    
    XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
    detail.goodsId = item.goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma network
- (void)requestDataForFist:(BOOL)isFirst {
    XKWeakSelf(ws);
    if (isFirst) {
        self.collectionView.hidden = YES;
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    self.networkGroup  = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_enter(self.networkGroup);
//    dispatch_group_async(self.networkGroup, queue, ^{
//        [ws requestIconData];
//    });self.dataSourceArr[indexPath.row];
    WelfareIconItem *item = [WelfareIconItem new];
    item.name = @"福利商品";
    item.icon = @"xk_btn_home_welfareGoods";
    
    WelfareIconItem *item1 = [WelfareIconItem new];
    item1.name = @"平台大奖";
    item1.icon = @"xk_btn_home_platForm";
    
    WelfareIconItem *item2 = [WelfareIconItem new];
    item2.name = @"店铺大奖";
    item2.icon = @"xk_btn_home_shop";
    
    [self.iconDataArr addObjectsFromArray:@[item,item1,item2]];
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
            ws.collectionView.hidden = NO;
            [ws.collectionView reloadData];
            [ws.collectionView.mj_header endRefreshing];
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
        info.xkwelfarebanner = [modelList yy_modelToJSONString];
        [XKUserInfo saveCurrentUser:info];
        dispatch_group_leave(ws.networkGroup);
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
         dispatch_group_leave(ws.networkGroup);
    }];
}

- (void)requestIconData {
    XKWeakSelf(ws);
    [XKWelfareCategoryModel requestNewWelfareIconListSuccess:^(XKWelfareCategoryModel *model) {
        
        [ws.iconDataArr removeAllObjects];
        [ws.iconDataArr addObjectsFromArray:model.fixed];
     //   NSMutableArray *tmpUserArr = [NSMutableArray array];
        /*
        NSMutableArray *tmpUserArr = [NSMutableArray array];
        NSMutableArray *tmpOptionalArr = [NSMutableArray array];
        NSMutableArray *addOptionalArr = [NSMutableArray array];
        if (ws.iconDataArr.count < 9) {
            NSInteger other = 9 - ws.iconDataArr.count;
            if (other > 0) {
                NSArray *userArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:[XKUserInfo currentUser].xkmallusericon];
                
                [tmpUserArr addObjectsFromArray:userArr];
                //去重  后台配置的和之前用户选择的有冲突
                for (WelfareIconItem *icon in model.fixed) {
                    for (WelfareIconItem *item in userArr) {
                        if (icon.code == item.code) {
                            [tmpUserArr removeObject:item];
                        }
                    }
                }
                
                if (tmpUserArr.count > 0) {
                    //后台配多了 要顶掉一部分用户的
                    if (tmpUserArr.count > other) {
                        for (NSInteger i = 0; i < other; i ++) {
                            WelfareIconItem *item = tmpUserArr[i];
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
                for (WelfareIconItem *icon in ws.iconDataArr) {
                    for (WelfareIconItem *item in model.notFixed) {
                        if (icon.code == item.code ) {
                            [tmpOptionalArr removeObject:item];
                        }
                    }
                }
                //去权重
                for (WelfareIconItem *icon in ws.iconDataArr) {
                    for (WelfareIconItem *item in model.notFixed) {
                        if (icon.code == item.code || item.weight == 2) {
                            [addOptionalArr removeObject:item];
                        }
                    }
                }
                
                if (addOptionalArr.count > other) {
                    for (NSInteger i = 0; i < other; i ++) {
                        WelfareIconItem *item = addOptionalArr[i];
                        [ws.iconDataArr addObject:item];
                        
                    }
                } else {
                    [ws.iconDataArr addObjectsFromArray:addOptionalArr];
                }
            }
        }*/
        if (model) {

            XKUserInfo *info =  [XKUserInfo currentUser];
            info.xkwelfaresysicon = [model.fixed yy_modelToJSONString];
            [XKUserInfo saveCurrentUser:info];
//            [XKUserInfo saveNewWelfareOptionalIconJsonStr:[model.notFixed yy_modelToJSONString]];
//            [XKUserInfo saveNewWelfareUserIconJsonStr:[tmpUserArr yy_modelToJSONString]];

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
                              @"jCondition" : @{ @"districtCode" : @"110201"}
                              
                              };
    [XKWelfareGoodsListViewModel requestWelfareRecommendGoodsListWithParam:parmDic success:^(NSArray *modelList) {
        ws.goosDataArr = modelList;
        dispatch_group_leave(ws.networkGroup);
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
        dispatch_group_leave(ws.networkGroup);
    }];
}
#pragma mark collectionview代理 数据源
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (_goosDataArr.count > 0) {
            return  CGSizeMake(SCREEN_WIDTH , 40);
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (_goosDataArr.count > 0) {
            return  CGSizeMake(SCREEN_WIDTH, 35);
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UIView *contentView;
        NSString *identifier;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            identifier = @"XKWelfareMainHeaderView";
            contentView = self.layoutView;
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
    } else {
        UIView *contentView;
        NSString *identifier;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            return nil;
        } else {
            identifier = @"UICollectionReusableView";
            contentView = [UIView new];
            contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
            [view addSubview:contentView];
            return view;
        }
    }
    return  nil;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 3 : _goosDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
        } else if (indexPath.row == 1) {
            XKWelfareMainItemCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareMainItemCollectionViewCell" forIndexPath:indexPath];
            item.dataSourceArr = self.iconDataArr;
            item.choseBlock = ^(NSInteger index) {
                 if (index == 3) {
                     XKWelfareMainViewController *main = [XKWelfareMainViewController new];
                     main.choseIndex =  0;
                     [ws.navigationController pushViewController:main animated:YES];
                 } else {
                     XKWelfareMainViewController *main = [XKWelfareMainViewController new];
                     main.choseIndex =  index + 1;
                     [ws.navigationController pushViewController:main animated:YES];
                 }
               
//                if (indexPath.row == 3) {
//                    XKMallGoodsCategoryViewController *category = [XKMallGoodsCategoryViewController new];
//                    category.type = CategoryTypeWelfare;
//                    category.refreshBlock = ^{
//                        [ws handleData];
//                        [ws.collectionView reloadData];
//                    };
//                    [ws.navigationController pushViewController:category animated:YES];
//                } else {
//                    XKWelfareMainViewController *main = [XKWelfareMainViewController new];
//                    main.choseIndex =  index;
//                    [ws.navigationController pushViewController:main animated:YES];
//                }
            };
            
            return item;
        } else if (indexPath.row == 2) {
            XKWelfareNewMainFunctionCell *function = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareNewMainFunctionCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            function.leftViewBlock = ^{
                XKLatestSecretViewController *vc = [[XKLatestSecretViewController alloc] init];
                vc.vcType = XKLatestSecretVCTypeLatestSecret;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            function.midViewBlock = ^{
                XKGrandPrizeShowOrderViewController *vc = [[XKGrandPrizeShowOrderViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            function.rightViewBlock = ^{
                XKWelfareActivityRulesViewController *vc = [[XKWelfareActivityRulesViewController alloc] init];
                [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:[XKAPPNetworkConfig getWelfareActivityRulesUrl]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return function;
        }
    } else if (indexPath.section == 1) {
        
        if (self.layoutType == XKWelfareMainLayoutSingleLayout) {
            XKWelfareListSingleCell *singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleCell" forIndexPath:indexPath];
            WelfareDataItem * item = self.goosDataArr[indexPath.row];
            if ([item.drawType isEqualToString:@"bytime"]) {
                singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell" forIndexPath:indexPath];
            } else if ([item.drawType isEqualToString:@"bymember"]) {
                singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell" forIndexPath:indexPath];
            } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
                singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell" forIndexPath:indexPath];
                
            } else if ([item.drawType isEqualToString:@"bytime_and_bymember"]) {
                singleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell" forIndexPath:indexPath];
            }
            [singleCell bindData:item WithType:1];
            
            if (_goosDataArr.count == 1) {
                singleCell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
                [singleCell hiddenSeperateLine:YES];
            } else {
                if(indexPath.row == 0) {
                    singleCell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
                    [singleCell hiddenSeperateLine:NO];
                } else if(indexPath.row == _goosDataArr.count - 1) {
                    singleCell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
                    [singleCell hiddenSeperateLine:NO];
                } else {
                    singleCell.bgContainView.xk_clipType = XKCornerClipTypeNone;
                    [singleCell hiddenSeperateLine:NO];
                }
            }
            return singleCell;
        } else {
            XKWelfareMainDoubleCell *doubleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKWelfareMainDoubleCell" forIndexPath:indexPath];
              [doubleCell bindData:_goosDataArr[indexPath.row]];
            return doubleCell;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREEN_WIDTH , 155);
        } else if (indexPath.row == 1) {
            return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 60 * ScreenScale) / 4 * 87 / 78);
        } else if (indexPath.row == 2) {
            return CGSizeMake(SCREEN_WIDTH , 182 * ScreenScale);
        }
    } else if (indexPath.section == 1) {
          WelfareDataItem * item = self.goosDataArr[indexPath.row];
        if (self.layoutType == XKWelfareMainLayoutSingleLayout) {
          
            if ([item.drawType isEqualToString:@"bytime"]) {
                return CGSizeMake(SCREEN_WIDTH , 135);
            } else if ([item.drawType isEqualToString:@"bymember"]) {
                return CGSizeMake(SCREEN_WIDTH , 130);
            } else if ([item.drawType isEqualToString:@"bytime_or_bymember"]) {
                return CGSizeMake(SCREEN_WIDTH , 155);
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
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        if(self.layoutType == XKWelfareMainLayoutSingleLayout) {
            return 0;
        } else {
            return  10;
        }
    }
    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        if (self.layoutType == XKWelfareMainLayoutSingleLayout) {
            return 0;
        } else {
            return  10;
        }
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        WelfareDataItem *item = _goosDataArr[indexPath.row];
        [self gotoDeatilWithItem:item];
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        if (self.layoutType == XKWelfareMainLayoutSingleLayout) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            return  UIEdgeInsetsMake(10, 10, 0, 10);
        }
    }
    return UIEdgeInsetsZero;
}

//- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
//    return section  == 2 ? [UIColor whiteColor] : [UIColor clearColor];
//}
#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH - 0, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XKMallMainFooterView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKWelfareMainHeaderView"];
        
        [_collectionView registerClass:[XKWelfareNewMainFunctionCell class]forCellWithReuseIdentifier:@"XKWelfareNewMainFunctionCell"];
        
        [_collectionView registerClass:[XKWelfareListSingleCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressCell"];
        [_collectionView registerClass:[XKWelfareListSingleTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressOrTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressOrTimeCell"];
        [_collectionView registerClass:[XKWelfareListSingleProgressAndTimeCell class] forCellWithReuseIdentifier:@"XKWelfareListSingleProgressAndTimeCell"];
        [_collectionView registerClass:[XKWelfareMainDoubleCell class] forCellWithReuseIdentifier:@"XKWelfareMainDoubleCell"];
        [_collectionView registerClass:[XKWelfareMainItemCollectionViewCell class] forCellWithReuseIdentifier:@"XKWelfareMainItemCollectionViewCell"];
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
            vc.searchType = SearchEntryType_Welfare;
            [ws.navigationController pushViewController:vc animated:NO];
        };
        
        _navBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
        
        _navBar.messageButtonBlock = ^{
            [XKIMGlobalMethod gotoCustomerSerChatList];
        };
        
        _navBar.buyCarButtonBlock = ^{
            XKWelfareBuyCarViewController *buyCar = [XKWelfareBuyCarViewController new];
            [ws.navigationController pushViewController:buyCar animated:YES];
        };
        
        _navBar.orderButtonBlock = ^{
            XKWelfareOrderViewController *orderVC = [XKWelfareOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return _navBar;
}

- (XKMallMainFooterView *)moreFootView {
    if (!_moreFootView) {
        XKWeakSelf(ws);
        _moreFootView = [[XKMallMainFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 35)];
        _moreFootView.moreBlock = ^(UIButton *sender) {
            XKWelfareMainViewController *main = [XKWelfareMainViewController new];
            main.choseIndex = 0;
            [ws.navigationController pushViewController:main animated:YES];
        };
    }
    return _moreFootView;
}

- (XKWelfareMainHeaderView *)layoutView {
    if (!_layoutView) {
        XKWeakSelf(ws);
        _layoutView = [[XKWelfareMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 40)];
        _layoutView.layoutBlock = ^(UIButton *sender) {
            ws.layoutType = ws.layoutType == XKWelfareMainLayoutSingleLayout ? XKWelfareMainLayoutDoubleLayout : XKWelfareMainLayoutSingleLayout;
            [ws.collectionView reloadData];
        };

    }
    return _layoutView;
}
@end
