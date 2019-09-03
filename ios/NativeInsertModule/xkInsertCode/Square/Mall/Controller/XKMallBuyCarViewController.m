//
//  XKMallBuyCarViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallBuyCarViewController.h"
#import "XKMallBuyCarListBottomView.h"
#import "XKMallBuyCarCell.h"
#import "XKMallBuyCarCountViewController.h"
#import "XKCommonSheetView.h"
#import "XKMallBottomDiscountTicketView.h"
#import "XKMallBuyCarViewModel.h"
#import "XKMallLoseEfficacyBuyCarCell.h"
#import "XKMallGoodsDetailViewController.h"
@interface XKMallBuyCarViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKMallBuyCarListBottomView *bottomView;
@property (nonatomic, strong)XKMallBottomDiscountTicketView *ticketBottomView;
@property (nonatomic, strong)XKCommonSheetView *ticketBgView;
@property (nonatomic, strong)XKMallBuyCarViewModel  *viewModel;
@end

@implementation XKMallBuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [_bottomView allChose:NO];
}

- (void)handleData {
    [super handleData];
    _viewModel  = [XKMallBuyCarViewModel new];
    _viewModel.page = 0;
    _viewModel.limit = 200;
    _viewModel.dataArr = [NSMutableArray array];
    _viewModel.choseArr = [NSMutableArray array];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    [_navBar customNaviBarWithTitle:@"商城" andRightButtonTitle:@"管理" andRightColor:[UIColor whiteColor]];
    _navBar.leftButtonBlock = ^{
        [XKMallBuyCarViewModel changeMallBuyCarListNumberWithAllArr:ws.viewModel.dataArr success:^(NSArray *modelArr) {
            
        } failed:^(NSString *failedReason) {
            
        }];
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    _navBar.rightButtonBlock = ^(UIButton *sender){
        if([ws.navBar.rightButton.currentTitle isEqualToString:@"管理"]) {
            [ws.navBar.rightButton setTitle:@"完成" forState:0];
            ws.bottomView.type = 1;
            ws.viewModel.manager = YES;
        } else {
            [ws.navBar.rightButton setTitle:@"管理" forState:0];
            ws.bottomView.type = 0;
            ws.viewModel.manager = NO;

        }
        [ws.tableView reloadData];
    };
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

//计算总价
- (void)countPoint {
    _viewModel.totalPoint = 0;
    for (XKMallBuyCarItem *item in _viewModel.dataArr) {
        if(item.selected == YES && item.status != 0) {
            _viewModel.totalPoint += item.price / 100 * item.quantity;
        }
    }
    NSString *nameStr = [NSString stringWithFormat:@"合计：%@",@(_viewModel.totalPoint).stringValue];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, nameStr.length - 3)];
    _bottomView.countLabel.attributedText = attrString;
}
#pragma mark 网络请求
//购物车优惠券
- (void)requestTicketWithXKMallBuyCarItem:(XKMallBuyCarItem *)item {
    //      [self.ticketBgView show];
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    NSDictionary *dic = @{
                          @"goodsId": item.goodsId,
                          @"page"   : @(1),
                          @"limit"   : @(100),
                          @"userId" : [XKUserInfo getCurrentUserId]
                          };
    [XKMallBuyCarViewModel requestMallBuyCarTicketWithParam:dic success:^(NSArray *modelArr) {
        
        ws.ticketBottomView.dataArr = modelArr;
        [ws.ticketBgView show];
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];
    
}
//购物车列表
- (void)requestWithTip:(BOOL)tip {
    if (tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _viewModel.page++;
    NSDictionary *dic = @{
                          @"page"   : @(_viewModel.page),
                          @"limit"  : @(_viewModel.limit),
                          @"userId" : [XKUserInfo getCurrentUserId]
                          };
    [XKMallBuyCarViewModel requestMallBuyCarListWithParam:dic success:^(XKMallBuyCarViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];

}

- (void)handleSuccessDataWithModel:(XKMallBuyCarViewModel *)model {
    [XKHudView hideAllHud];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
        _viewModel.lostCount = 0;
        [_viewModel.dataArr removeAllObjects];
    }

    if (model == nil) {
        _viewModel.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [_viewModel.dataArr addObjectsFromArray:model.data];
    }

    for (XKMallBuyCarItem *item in model.data) {
        if(item.status == 0) {
            _viewModel.lostCount++;
        }
    }
    [self countPoint];
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    _viewModel.page --;
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [XKHudView showErrorMessage:reason];
}

- (void)choseAll:(UIButton *)sender {
    if(sender.isSelected) {
        for (XKMallBuyCarItem *model in _viewModel.dataArr) {
            model.selected = YES;
        }
        [_viewModel.choseArr removeAllObjects];
        [_viewModel.choseArr addObjectsFromArray:_viewModel.dataArr];
    } else {
        for (XKMallBuyCarItem *model in _viewModel.dataArr) {
            model.selected = NO;
        }
        [_viewModel.choseArr removeAllObjects];
        
    }
    [self countPoint];
    [self.tableView reloadData];
}

- (void)choseRow:(NSInteger )row {
    XKMallBuyCarItem *model = _viewModel.dataArr[row];
    model.selected = !model.selected;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
   
    if(model.selected) {
        [_viewModel.choseArr addObject:model];
    } else {
        [_viewModel.choseArr removeObject:model];
    }
    if(_viewModel.choseArr.count == 0) {
        [self.bottomView allChose:NO];
    } else if(_viewModel.choseArr.count == _viewModel.dataArr.count - _viewModel.lostCount) {
        [self.bottomView allChose:YES];
    } else {
       [self.bottomView allChose:NO];
    }
    [self countPoint];
}

//删除
- (void)deleteChoseItem:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (XKMallBuyCarItem *model in _viewModel.dataArr) {
        if(model.selected) {
            [deleteArr addObject:model];
        }
    }
    
    [XKMallBuyCarViewModel deleteMallBuyCarListWithDeleteArr:deleteArr success:^(NSArray *modelArr) {
        [XKHudView showTipMessage:@"删除成功"];
        [self.viewModel.dataArr removeObjectsInArray:deleteArr];
        [self.tableView reloadData];
        sender.userInteractionEnabled = YES;
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
        sender.userInteractionEnabled = YES;
    }];
}

//收藏
- (void)collectChoseItem:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    XKWeakSelf(ws);
    NSMutableArray *collectArr = [NSMutableArray array];
    for (XKMallBuyCarItem *model in _viewModel.dataArr) {
        if(model.selected) {
            [collectArr addObject:model];
        }
    }
    [XKMallBuyCarViewModel collectMallBuyCarListWithDeleteArr:collectArr success:^(NSArray *modelArr) {
        [XKHudView showTipMessage:@"收藏成功"];
        ws.navBar.rightButtonBlock(ws.navBar.rightButton);
        sender.userInteractionEnabled = YES;
        [ws.tableView.mj_header beginRefreshing];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
        sender.userInteractionEnabled = YES;
    }];
}

//领取优惠券
- (void)drawTicketWithItem:(XKMallBuyCarItem *)item {
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    NSDictionary *dic = @{
                          @"couponId" : item.couponId,
                          @"userId"   : [XKUserInfo getCurrentUserId]
                          };
    [XKMallBuyCarViewModel drawMallBuyCarTicketWithParam:dic success:^(id respons) {
        [XKHudView showSuccessMessage:@"领取成功"];
    } failed:^(NSString *failedReason) {
         [XKHudView showErrorMessage:failedReason];
    }];
    [XKMallBuyCarViewModel requestMallBuyCarTicketWithParam:dic success:^(NSArray *modelArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:modelArr];
        [arr addObjectsFromArray:modelArr];
        ws.ticketBottomView.dataArr = arr.copy;
        [ws.ticketBgView show];
    } failed:^(NSString *failedReason) {
       
    }];
}
#pragma mark tableview代理 数据源
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    XKMallBuyCarItem *model = _viewModel.dataArr[indexPath.row];
    model.index = indexPath.row;
    if(model.status == 0) {
        XKMallLoseEfficacyBuyCarCell *lost = [tableView dequeueReusableCellWithIdentifier:@"XKMallLoseEfficacyBuyCarCell" forIndexPath:indexPath];
        [lost handleDataModel:model managerModel:_viewModel.manager];
        
        lost.ticketClickBlock = ^(UIButton *sender, NSInteger index) {
            XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
            XKMallBuyCarItem *model = ws.viewModel.dataArr[index];
            detail.goodsId = model.goodsId;
            [self.navigationController pushViewController:detail animated:YES];
        };
        
        lost.choseClickBlock = ^(UIButton *sender, NSInteger index) {
             [ws choseRow:index];
        };
        
        if(self.viewModel.dataArr.count == 1) {
            [lost cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
        } else {
            if(indexPath.row == 0) {
                [lost cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
            } else if(indexPath.row == self.viewModel.dataArr.count - 1) {
                [lost cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
            } else {
                lost.layer.mask = nil;
            }
        }
        return lost;
    } else {
        XKMallBuyCarCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"XKMallBuyCarCell" forIndexPath:indexPath];
        [cell handleDataModel:model managerModel:_viewModel.manager];
        
        cell.calculateBlock = ^(NSInteger row, NSInteger currentCount) {
            [ws countPoint];
        };
//
        cell.choseClickBlock = ^(NSInteger row, UIButton *sender) {
            [ws choseRow:row];
        };
        
        cell.ticketClickBlock = ^(NSInteger row, UIButton *sender) {
            [ws requestTicketWithXKMallBuyCarItem:model];
        };

        if(self.viewModel.dataArr.count == 1) {
            [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
        } else {
            if(indexPath.row == 0) {
                [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
            } else if(indexPath.row == self.viewModel.dataArr.count - 1) {
                [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 135)];
            } else {
                cell.layer.mask = nil;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKMallBuyCarItem *model = _viewModel.dataArr[indexPath.row];
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = model.goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        XKWeakSelf(ws);
        _tableView.separatorColor = XKSeparatorLineColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestWithTip:NO];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestWithTip:NO];
        }];
        _tableView.mj_footer = foot;
        [_tableView registerClass:[XKMallLoseEfficacyBuyCarCell class] forCellReuseIdentifier:@"XKMallLoseEfficacyBuyCarCell"];
        [_tableView registerClass:[XKMallBuyCarCell class] forCellReuseIdentifier:@"XKMallBuyCarCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKMallBuyCarListBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [[XKMallBuyCarListBottomView alloc] init];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.type = 0;
        
        _bottomView.choseBlock = ^(UIButton *sender) {
            sender.selected = !sender.selected;
            [ws choseAll:sender];

        };
        
        _bottomView.deleteBlock = ^(UIButton *sender) {
             [ws deleteChoseItem:sender];
        };
        
        _bottomView.collectBlock = ^(UIButton *sender) {
             [ws collectChoseItem:sender];
        };
        
        _bottomView.finishBlock = ^(UIButton *sender) {
            if (ws.viewModel.choseArr.count < 1) {
                [XKHudView showErrorMessage:@"请先选择需要结算的商品"];
                return ;
            }
            XKMallBuyCarCountViewController *sureVC = [XKMallBuyCarCountViewController new];
            sureVC.goodsArr = [ws.viewModel.choseArr copy];
            [ws.viewModel.choseArr removeAllObjects];
            sureVC.totalPrice = ws.viewModel.totalPoint;
            [ws.navigationController pushViewController:sureVC animated:YES];
        };
    }
    return _bottomView;
}

- (XKMallBottomDiscountTicketView *)ticketBottomView {
    if (!_ticketBottomView) {
        XKWeakSelf(ws);
        _ticketBottomView = [[XKMallBottomDiscountTicketView alloc] initWithTicketArr:@[@"1"] titleStr:@"优惠券"];
        _ticketBottomView.choseBlock = ^(XKMallBuyCarItem *item) {
            [ws.ticketBgView dismiss];
            [ws drawTicketWithItem:item];
        };
    }
    return _ticketBottomView;
}

- (XKCommonSheetView *)ticketBgView {
    if (!_ticketBgView) {
        _ticketBgView = [[XKCommonSheetView alloc] init];
        _ticketBgView.contentView = self.ticketBottomView;
        [_ticketBgView addSubview:self.ticketBottomView];
    }
    return _ticketBgView;
}

@end
