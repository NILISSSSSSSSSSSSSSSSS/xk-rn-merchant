//
//  XKSubscriptionViewController.m
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSubscriptionViewController.h"
#import "XKSubscriptionTableViewCell.h"
#import "XKSubscriptionHeaderView.h"
#import "XKSubscriptionFooterView.h"
#import "XKSubscriptionCellModel.h"


static NSString * const subscriptionCellID      = @"subscriptionCellID";
static NSString * const sectionHeaderViewID     = @"sectionHeaderView";
static NSString * const sectionFooterViewID     = @"sectionFooterView";

static CGFloat const SectoionHeaderHeight = 30;

@interface XKSubscriptionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *alreadySubscriptionArray;
@property (nonatomic, strong) NSMutableArray     *canSubscriptionArray;
@property (nonatomic, assign) BOOL               changed;

@end

@implementation XKSubscriptionViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configBaseData];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)backBtnClick {
    if (self.changed) {
        [XKAlertView showCommonAlertViewWithTitle:@"本次编辑需要保存后才能生效，是否保存？" leftText:@"不保存" rightText:@"保存" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            [self sureBtnClicked];
        }];
    } else {
        [super backBtnClick];
    }
}

#pragma mark - Private Metheods

- (void)configBaseData {
    
    _alreadySubscriptionArray = [NSMutableArray array];
    _canSubscriptionArray = [NSMutableArray array];
    
    
    NSString *jsonStr1 = [XKUserDefault objectForKey:kAlreadySubscriptionArr];
    if (jsonStr1) {
       [_alreadySubscriptionArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKSubscriptionCellModel class] json:jsonStr1]];
    } else {
        NSArray *arr1 = @[
                          @{@"itemId":@"0", @"titleName":@"商品推荐", @"selectImgName":@"xk_icon_subscription_product_heighlight",      @"normalImgName":@"xk_icon_subscription_product_normal", @"selected":@1},
                          @{@"itemId":@"1", @"titleName":@"商家推荐", @"selectImgName":@"xk_iocn_subscription_activity_heighLight", @"normalImgName":@"xk_iocn_subscription_activity_normal", @"selected":@1},
                          @{@"itemId":@"2", @"titleName":@"平台资讯", @"selectImgName":@"xk_iocn_subscription_consult_heighlight", @"normalImgName":@"xk_iocn_subscription_consult_normal", @"selected":@1},
                          @{@"itemId":@"3", @"titleName":@"朋友圈", @"selectImgName":@"xk_iocn_subscription_cricle_heighLight", @"normalImgName":@"xk_iocn_subscription_cricle_normal", @"selected":@1}
                          ];
        
        for (NSDictionary *dic in arr1) {
            [_alreadySubscriptionArray addObject:[XKSubscriptionCellModel yy_modelWithDictionary:dic]];
        }
    }
    
    NSString *jsonStr2 = [XKUserDefault objectForKey:kCanSubscriptionArr];
    if (jsonStr2) {
        [_canSubscriptionArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKSubscriptionCellModel class] json:jsonStr2]];
    } else {
        NSArray *arr2 = @[
                          @{@"itemId":@"4", @"titleName":@"推荐小视频", @"selectImgName":@"xk_iocn_subscription_video_heightLight", @"normalImgName":@"xk_iocn_subscription_video_normal", @"selected":@0},
                          @{@"itemId":@"5", @"titleName":@"游戏推荐", @"selectImgName":@"xk_iocn_subscription_friend_heightLight", @"normalImgName":@"xk_iocn_subscription_friend_normal", @"selected":@0}
                          ];
        for (NSDictionary *dic in arr2) {
            [_canSubscriptionArray addObject:[XKSubscriptionCellModel yy_modelWithDictionary:dic]];
        }
    }
    
}


- (void)configTableView {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height+10, 0, 0, 0));
    }];
}


- (void)configNavigationBar {
    
    [self setNavTitle:@"内容订阅" WithColor:[UIColor whiteColor]];
    [self setBackButton:nil andName:nil];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16];
    [sureBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
    [self setNaviCustomView:sureBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
}

- (void)sureBtnClicked {
    
    [XKUserDefault setObject:[_alreadySubscriptionArray yy_modelToJSONString]  forKey:kAlreadySubscriptionArr];
    [XKUserDefault setObject:[_canSubscriptionArray yy_modelToJSONString] forKey:kCanSubscriptionArr];
    [XKUserDefault synchronize];
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    
    [XKHudView showTipMessage:@"保存中..." to:self.tableView animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XKHudView hideHUDForView:self.tableView];
        [self.navigationController popViewControllerAnimated:YES];
    });
}



- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            
            if (indexPath.section == sourceIndexPath.section) {
                if (sourceIndexPath.section == 0) {
                    
                    [_alreadySubscriptionArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row];
                } else if (sourceIndexPath.section == 1) {
                    [_canSubscriptionArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row];
                }
                self.changed = YES;
//                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                [self.tableView reloadData];
                sourceIndexPath = indexPath;
            }
            
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                cell.alpha = 1.0f;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIView* snapshot = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        //ios7.0 以下通过截图形式保存快照
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        //ios7.0 系统的快照方法
        snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView {
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
}




#pragma mark - UITableViewDelegate && UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _alreadySubscriptionArray.count;
    }
    return _canSubscriptionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSubscriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subscriptionCellID];
    if (!cell) {
        cell = [[XKSubscriptionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:subscriptionCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    XKWeakSelf(weakSelf);
    cell.sortBtnBlock = ^(UIButton *sender) {
        [weakSelf sortButtonClicked:sender indexPath:indexPath];
    };
    
    if (indexPath.section == 0) {
        
        [cell hiddenLine:(indexPath.row + 1 == _alreadySubscriptionArray.count)];
        [cell setValuesWithModel:_alreadySubscriptionArray[indexPath.row] indexPath:indexPath];
    } else {
        [cell hiddenLine:(indexPath.row + 1 == _canSubscriptionArray.count)];
        [cell setValuesWithModel:_canSubscriptionArray[indexPath.row] indexPath:indexPath];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0 && _alreadySubscriptionArray.count) || (section == 1 && _canSubscriptionArray.count)) {
        return SectoionHeaderHeight;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ((section == 0 && _alreadySubscriptionArray.count) || (section == 1 && _canSubscriptionArray.count)) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ((section == 0 && _alreadySubscriptionArray.count) || (section == 1 && _canSubscriptionArray.count)) {

        XKSubscriptionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
        if (!sectionHeaderView) {
            sectionHeaderView = [[XKSubscriptionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
            [sectionHeaderView cutCorner:YES];
        }
        
        NSString *title = @"";
        if (section == 0) {
            title = @"已订阅";
        } else if (section == 1) {
            title = @"可订阅";
        }
        [sectionHeaderView setTitleName:title];
        return sectionHeaderView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XKSubscriptionFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFooterViewID];
    if (!sectionFooterView) {
        sectionFooterView = [[XKSubscriptionFooterView alloc] initWithReuseIdentifier:sectionFooterViewID];
    }
    return sectionFooterView;
}

#pragma mark - Custom Delegates

#pragma mark - Custom Block

- (void)sortButtonClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    self.changed = YES;
    if (indexPath.section == 0) {
        XKSubscriptionCellModel *model = _alreadySubscriptionArray[indexPath.row];
        model.selected = NO;
        [_canSubscriptionArray addObject:model];
        [_alreadySubscriptionArray removeObjectAtIndex:indexPath.row];
    } else {
        XKSubscriptionCellModel *model = _canSubscriptionArray[indexPath.row];
        model.selected = YES;
        [_alreadySubscriptionArray addObject:model];
        [_canSubscriptionArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView reloadData];
}


#pragma mark - Lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 66;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.1;
        [_tableView addGestureRecognizer:longPress];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
