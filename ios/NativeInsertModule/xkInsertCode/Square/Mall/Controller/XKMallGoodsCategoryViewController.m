//
//  XKGoodsCategoryViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsCategoryViewController.h"
#import "XKCustomNavBar.h"
#import "XKMallGoodsCategoryCell.h"
#import "XKMallGoodsHeaderView.h"
#import "XKMallCategoryListModel.h"
#import "XKWelfareCategoryModel.h"
#import "XKSquareHomeToolModel.h"

@interface XKMallGoodsCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sysArr;
@property (nonatomic, strong) NSArray *userArr;
@property (nonatomic, strong) NSArray *optionalArr;
@property (nonatomic, strong) NSMutableArray  *tmpUserArr;
@property (nonatomic, strong) XKMallGoodsHeaderView  *titleHeaderView;
@property (nonatomic, assign) BOOL  edit;
@property (nonatomic, assign) BOOL  haveSeaved;//保存过 返回才刷新
@property (nonatomic, assign) BOOL changed;

@end

@implementation XKMallGoodsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    _tmpUserArr = [NSMutableArray array];
    XKUserInfo *info = [XKUserInfo currentUser];
    if (self.type == CategoryTypeMall) {

        _sysArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmallsysicon];
        _userArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmallusericon];
        _optionalArr = [NSArray yy_modelArrayWithClass:[MallIconItem class] json:info.xkmalloptionalicon];

        for (MallIconItem *icon in _optionalArr) {
            icon.isChose = NO;
            for (MallIconItem *item in _userArr) {
                if (icon.code == item.code) {
                    icon.isChose = YES;
                }
            }
        }
    } else if (self.type == CategoryTypeWelfare) {

        _sysArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:info.xkwelfaresysicon];
        _userArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:info.xkwelfareusericon];
        _optionalArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:info.xkwelfareoptionalicon];

        for (WelfareIconItem *icon in _optionalArr) {
            icon.isChose = NO;
            for (WelfareIconItem *item in _userArr) {
                if (icon.code == item.code) {
                    icon.isChose = YES;
                }
            }
        }
        
    } else if (self.type == CategoryTypeHome) {
        
        _sysArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkHomeSysIcon];
        _userArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkHomeUserIcon];
        _optionalArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkHomeOptionalIcon];
        
        for (XKSquareHomeToolModel *icon in _optionalArr) {
            icon.isChose = NO;
            for (XKSquareHomeToolModel *item in _userArr) {
                if (icon.code == item.code) {
                    icon.isChose = YES;
                }
            }
        }
    } else if (self.type == CategoryTypeArea) {
        
        _sysArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkTradingAreaSysIcon];
        _userArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkTradingAreaUserIcon];
        _optionalArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:info.xkTradingAreaOptionalIcon];
        
        for (XKSquareHomeToolModel *icon in _optionalArr) {
            icon.isChose = NO;
            for (XKSquareHomeToolModel *item in _userArr) {
                if (icon.code == item.code) {
                    icon.isChose = YES;
                }
            }
        }
    }
    [_tmpUserArr addObjectsFromArray:_userArr];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    self.navBar = [[XKCustomNavBar alloc] init];
    [self.navBar customBaseNavigationBar];
    _navBar.leftButtonBlock = ^{
        if (ws.refreshBlock && ws.haveSeaved) {
            ws.refreshBlock();
            [ws.navigationController popViewControllerAnimated:YES];
        } else {
            [ws backBtnClick];
        }
    };
    self.navBar.titleLabel.text = @"商品分类";
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
}

- (void)handleUserChose:(NSIndexPath *)index {
    if (self.type == CategoryTypeMall) {
        MallIconItem *item = self.tmpUserArr[index.row];
        [self.tmpUserArr removeObject:item];
        
        for (MallIconItem *icon in self.optionalArr) {
            if (icon.code == item.code) {
                icon.isChose = NO;
                icon.weight = 2;
            }
        };
    } else if (self.type == CategoryTypeWelfare) {
        WelfareIconItem *item = self.tmpUserArr[index.row];
        [self.tmpUserArr removeObject:item];
        
        for (WelfareIconItem *icon in self.optionalArr) {
            if (icon.code == item.code) {
                icon.isChose = NO;
                icon.weight = 2;
            }
        };
    } else if (self.type == CategoryTypeHome || self.type == CategoryTypeArea) {
        XKSquareHomeToolModel *item = self.tmpUserArr[index.row];
        [self.tmpUserArr removeObject:item];
        
        for (XKSquareHomeToolModel *icon in self.optionalArr) {
            if (icon.code == item.code) {
                icon.isChose = NO;
                icon.weight = 2;
            }
        };
    }
    
    
    [self.collectionView reloadData];
}

- (void)backBtnClick {
    if (self.changed) {
        [XKAlertView showCommonAlertViewWithTitle:@"本次编辑需要保存后才能生效，是否保存？" leftText:@"不保存" rightText:@"保存" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            [self saveData];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];

        }];
    } else {
        [super backBtnClick];
    }
}

- (void)updateDataWithIndex:(NSIndexPath *)index {
    
}
#pragma mark collectionview代理 数据源
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
       return CGSizeMake(SCREEN_WIDTH - 30 , 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);

    switch (indexPath.section) {
        case 0: {
            XKMallGoodsHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallGoodsHeaderView" forIndexPath:indexPath];
            [view hideRirhtBtn:YES title:@"平台推荐"];
            return  view;
        }
            break;
        case 1: {
            XKMallGoodsHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallGoodsHeaderView" forIndexPath:indexPath];
            view.saveBlock = ^(UIButton *sender) {
                
                ws.edit = !ws.edit;
                if (!ws.edit) {
                    ws.changed = NO;
                    ws.haveSeaved = YES;
                    [ws saveData];
                    [ws.collectionView reloadData];
                } else {
                    ws.changed = YES;
                    ws.haveSeaved = NO;
                    [ws.collectionView reloadData];
                }
               
            };
            [view hideRirhtBtn:NO title:@"私人订制"];
            if (!ws.edit) {
                [view.saveBtn setTitle:@"" forState:0];
                [view.saveBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_edit"] forState:0];
            } else {
                [view.saveBtn setTitle:@"保存" forState:0];
                [view.saveBtn setImage:[UIImage imageNamed:@""] forState:0];
            }
           
            return  view;
        }
            break;
        case 2: {
            XKMallGoodsHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallGoodsHeaderView" forIndexPath:indexPath];
            [view hideRirhtBtn:YES title:@"所有分类"];
            return  view;
        }
            break;
            
        default:return  nil;
            break;
    }
    
}

- (void)saveData {
    
    if (self.type == CategoryTypeMall) {
        [XKUserInfo currentUser].xkmallsysicon = [self.sysArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkmalloptionalicon = [self.optionalArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkmallusericon = [self.tmpUserArr yy_modelToJSONString];
    } else if (self.type == CategoryTypeWelfare) {
        
        
    } else if (self.type == CategoryTypeArea) {
        
        [XKUserInfo currentUser].xkTradingAreaSysIcon = [self.sysArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkTradingAreaOptionalIcon = [self.optionalArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkTradingAreaUserIcon = [self.tmpUserArr yy_modelToJSONString];
        
    } else if (self.type == CategoryTypeHome) {
        [XKUserInfo currentUser].xkHomeSysIcon = [self.sysArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkHomeOptionalIcon = [self.optionalArr yy_modelToJSONString];
        [XKUserInfo currentUser].xkHomeUserIcon = [self.tmpUserArr yy_modelToJSONString];
    }
    
    [XKUserInfo synchronizeUser];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? _sysArr.count : section == 1 ? _tmpUserArr.count : _optionalArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKMallGoodsCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMallGoodsCategoryCell" forIndexPath:indexPath];
    cell.index = indexPath;
    XKWeakSelf(ws);
    switch (indexPath.section) {
        case 0:{//第一排所有都一样
            if (self.type == CategoryTypeMall) {
                MallIconItem *item = _sysArr[indexPath.row];
                [cell updateStatus:ItemStatusNone withTitle:item.name];
                
            } else if (self.type == CategoryTypeWelfare) {
                WelfareIconItem *item = _sysArr[indexPath.row];
                [cell updateStatus:ItemStatusNone withTitle:item.name];
                
            } else if (self.type == CategoryTypeHome || self.type == CategoryTypeArea) {
                XKSquareHomeToolModel *item = _sysArr[indexPath.row];
                [cell updateStatus:ItemStatusNone withTitle:item.name];
            }
            
            }
            break;
        case 1:{
            cell.choseBlock = ^(NSIndexPath *index, UIButton *sender) {
                if (!self.edit) {
                    return;
                }
                [ws handleUserChose:index];
            };
            [self updateDataWithIndex:indexPath];
            if (self.type == CategoryTypeMall) {
                if (self.edit) {
                    MallIconItem *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusDelete withTitle:item.name];
                } else {
                    MallIconItem *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
                
            } else if (self.type == CategoryTypeWelfare) {
                if (self.edit) {
                    WelfareIconItem *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusDelete withTitle:item.name];
                } else {
                    WelfareIconItem *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
                
            } else if (self.type == CategoryTypeHome || self.type == CategoryTypeArea) {
                if (self.edit) {
                    XKSquareHomeToolModel *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusDelete withTitle:item.name];
                } else {
                    XKSquareHomeToolModel *item = _tmpUserArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
            }

        }
            break;
        case 2:{
            if (self.type == CategoryTypeMall) {
                cell.choseBlock = ^(NSIndexPath *index, UIButton *sender) {
                    if (!self.edit) {
                        return;
                    }
                    MallIconItem *item = ws.optionalArr[index.row];
                    if (item.isChose) {
                        NSMutableArray *tempArr = [NSMutableArray array];
                        [tempArr addObjectsFromArray:ws.tmpUserArr];
                        
                        for (MallIconItem *icon in tempArr) {
                            if (icon.code == item.code) {
                                [ws.tmpUserArr removeObject:icon];
                                item.isChose = NO;
                            }
                        }
                        
                    } else {
                        if (ws.sysArr.count + ws.tmpUserArr.count == 9) {
                            [XKHudView showErrorMessage:@"已达到最大数量"];
                            return ;
                        }
                        item.isChose = YES;
                        [ws.tmpUserArr addObject:item];
                    }
                    [ws.collectionView reloadData];
                };
                if (self.edit) {
                    MallIconItem *item = _optionalArr[indexPath.row];
                    if (item.isChose) {
                        [cell updateStatus:ItemStatusDelete withTitle:item.name];
                    } else {
                        [cell updateStatus:ItemStatusChose withTitle:item.name];
                    }
                    
                } else {
                    MallIconItem *item = _optionalArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
            } else if (self.type == CategoryTypeWelfare) {
                cell.choseBlock = ^(NSIndexPath *index, UIButton *sender) {
                    if (!self.edit) {
                        return;
                    }
                    WelfareIconItem *item = ws.optionalArr[index.row];
                    if (item.isChose) {
                        NSMutableArray *tempArr = [NSMutableArray array];
                        [tempArr addObjectsFromArray:ws.tmpUserArr];
                        for (WelfareIconItem *icon in tempArr) {
                            if (icon.code == item.code) {
                                [ws.tmpUserArr removeObject:icon];
                                item.isChose = NO;
                                
                            }
                        }
                        
                    } else {
                        if (ws.sysArr.count + ws.tmpUserArr.count == 9) {
                            [XKHudView showErrorMessage:@"已达到最大数量"];
                            return ;
                        }
                        item.isChose = YES;
                        [ws.tmpUserArr addObject:item];
                    }
                    [ws.collectionView reloadData];
                };
                if (self.edit) {
                    WelfareIconItem *item = _optionalArr[indexPath.row];
                    if (item.isChose) {
                        [cell updateStatus:ItemStatusDelete withTitle:item.name];
                    } else {
                        [cell updateStatus:ItemStatusChose withTitle:item.name];
                    }
                    
                } else {
                    WelfareIconItem *item = _optionalArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
                
            } else if (self.type == CategoryTypeHome || self.type == CategoryTypeArea) {
                cell.choseBlock = ^(NSIndexPath *index, UIButton *sender) {
                    if (!self.edit) {
                        return;
                    }
                    XKSquareHomeToolModel *item = ws.optionalArr[index.row];
                    if (item.isChose) {
                        NSMutableArray *tempArr = [NSMutableArray array];
                        [tempArr addObjectsFromArray:ws.tmpUserArr];
                        for (XKSquareHomeToolModel *icon in tempArr) {
                            if (icon.code == item.code) {
                                [ws.tmpUserArr removeObject:icon];
                                item.isChose = NO;
                            }
                        }
                        
                    } else {
                        if (ws.sysArr.count + ws.tmpUserArr.count == 9) {
                            [XKHudView showErrorMessage:@"已达到最大数量"];
                            return ;
                        }
                        item.isChose = YES;
                        [ws.tmpUserArr addObject:item];
                    }
                    [ws.collectionView reloadData];
                };
                if (self.edit) {
                    XKSquareHomeToolModel *item = _optionalArr[indexPath.row];
                    if (item.isChose) {
                        [cell updateStatus:ItemStatusDelete withTitle:item.name];
                    } else {
                        [cell updateStatus:ItemStatusChose withTitle:item.name];
                    }
                    
                } else {
                    XKSquareHomeToolModel *item = _optionalArr[indexPath.row];
                    [cell updateStatus:ItemStatusNone withTitle:item.name];
                }
            }

        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 30 - 5 * 4) / 5, (SCREEN_WIDTH - 30 - 5 * 4) / 5);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.edit) {
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
 
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, kIphoneXNavi(64), SCREEN_WIDTH - 30, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[XKMallGoodsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XKMallGoodsHeaderView"];
        [_collectionView registerClass:[XKMallGoodsCategoryCell class] forCellWithReuseIdentifier:@"XKMallGoodsCategoryCell"];
    }
    return _collectionView;
}

- (XKMallGoodsHeaderView *)titleHeaderView {
    XKWeakSelf(ws);
    if (!_titleHeaderView) {
        _titleHeaderView = [[XKMallGoodsHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 45)];
       

    }
    return _titleHeaderView;
}


@end
