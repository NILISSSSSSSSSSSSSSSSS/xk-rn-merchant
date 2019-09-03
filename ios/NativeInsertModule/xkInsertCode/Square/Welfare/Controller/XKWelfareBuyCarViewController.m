//
//  XKWelfareBuyCarViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareBuyCarViewController.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareBuyCarCell.h"
#import "XKWelfareSureOrderViewController.h"
#import "XKWelfareBuyCarViewModel.h"
#import "XKWelfareLoseEfficacyBuyCarCell.h"
#import "XKWelfareOrderWaitOpenCell.h"
#import "XKWelfareOrderWaitOpenTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressCell.h"
#import "XKWelfareOrderWaitOpenProgressAndTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressOrTimeCell.h"
@interface XKWelfareBuyCarViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) XKWelfareOrderDetailBottomView *bottomView;

@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) XKWelfareBuyCarViewModel  *viewModel;
/**合计积分*/
@property (nonatomic, strong) UILabel *totalPointLabel;
/**剩余积分*/
@property (nonatomic, strong) UILabel *otherPointLabel;

/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@end

@implementation XKWelfareBuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestWithTip:YES];
}

- (void)handleData {
    [super handleData];
    _viewModel = [XKWelfareBuyCarViewModel new];
    _viewModel.dataArr = [NSMutableArray array];
    _viewModel.choseArr = [NSMutableArray array];
    _viewModel.page = 0;
    _viewModel.limit = 200;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    [_navBar customNaviBarWithTitle:@"福利商城" andRightButtonTitle:@"管理" andRightColor:[UIColor whiteColor]];
    _navBar.leftButtonBlock = ^{
        [XKWelfareBuyCarViewModel changeWelfareBuyCarListNumberWithAllArr:ws.viewModel.dataArr success:nil failed:nil];
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    _navBar.rightButtonBlock = ^(UIButton *sender){
        if([ws.navBar.rightButton.currentTitle isEqualToString:@"管理"]) {
            [ws.navBar.rightButton setTitle:@"完成" forState:0];
            ws.bottomView.type = 1;
            ws.countView.hidden = YES;
            ws.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            ws.viewModel.manager = YES;
        } else {
            [ws.navBar.rightButton setTitle:@"管理" forState:0];
            ws.bottomView.type = 0;
            ws.countView.hidden = NO;
            ws.viewModel.manager = NO;
            ws.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        }
        [ws.tableView reloadData];
    };
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    [self addCountView];
    
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

- (void)addCountView {
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.countView];
    [self.countView addSubview:self.totalPointLabel];
    [self.countView addSubview:self.otherPointLabel];
    [self.totalPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.countView);
        make.left.equalTo(self.countView.mas_left).offset(25);
    }];
    
    [self.otherPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.countView);
        make.left.equalTo(self.totalPointLabel.mas_right).offset(20);
    }];
    
   
}

#pragma mark 网络请求
- (void)requestWithTip:(BOOL)tip {
    if (tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    _viewModel.page++;
    NSDictionary *dic = @{
                          @"page"   : @(_viewModel.page),
                          @"limit"  : @(_viewModel.limit),
                          };
    [XKWelfareBuyCarViewModel requestWelfareBuyCarListWithParam:dic success:^(XKWelfareBuyCarViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
//
//    if(tip) {
//        [XKHudView showLoadingTo:self.tableView animated:YES];
//    }
//    [_viewModel requestByCarListDataComplete:^(NSString *error, id data) {
//        [XKHudView hideHUDForView:self.tableView];
//        if (error) {
//            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"" des:error tapClick:^{
//                [self requestWithTip:YES];
//            }];
//        } else {
//            [self.tableView.mj_header endRefreshing];
//            [self.emptyView hide];
//            [self.tableView reloadData];
//        }
//    }];
}

- (void)handleSuccessDataWithModel:(XKWelfareBuyCarViewModel *)model {
    XKWeakSelf(ws);
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (_viewModel.page == 1) {
        _viewModel.lostCount = 0;
        [_viewModel.dataArr removeAllObjects];
        if (model == nil) {//第一页没数据
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [ws.tableView.mj_header beginRefreshing];
            }];
        }
    }

    
    if (model == nil) {
        _viewModel.page --;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [_viewModel.dataArr addObjectsFromArray:model.data];
    }

    for (XKWelfareBuyCarItem *item in model.data) {
        if(item.status == 0) {
            _viewModel.lostCount++;
        }
    }
    [self countPoint];
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    _viewModel.page --;
    [self.emptyTipView hide];
    XKWeakSelf(ws);
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    if (self.viewModel.data.count == 0) {//无数据 请求第一页 请求出错
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
            [ws.tableView.mj_header beginRefreshing];
        }];
    } else {//请求更多出错
        [self.emptyTipView hide];
        [XKHudView showErrorMessage:reason];
    };
}

- (void)countPoint {
    _viewModel.totalPoint = 0;
    for (XKWelfareBuyCarItem *item in _viewModel.dataArr) {
        if(item.selected == YES && item.status != 0) {
            _viewModel.totalPoint += item.price * item.quantity;
        }
    }
    NSString *totalPoint = @(_viewModel.totalPoint).stringValue;
    NSString *totalPointStr = [NSString stringWithFormat:@"合计积分：%@",totalPoint];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalPointStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, totalPoint.length)];
    NSString *otherPoint = @"0";
    NSString *otherPointStr = [NSString stringWithFormat:@"       剩余积分：%@",otherPoint];
    NSMutableAttributedString *otherAttrString = [[NSMutableAttributedString alloc] initWithString:otherPointStr];
    [otherAttrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(otherPointStr.length - otherPoint.length, otherPoint.length)];
    [attrString appendAttributedString:otherAttrString];
    _totalPointLabel.attributedText = attrString;
}

- (void)choseAll:(UIButton *)sender {
    if(sender.isSelected) {
        for (XKWelfareBuyCarItem *model in _viewModel.dataArr) {
            model.selected = YES;
        }
        [_viewModel.choseArr removeAllObjects];
        [_viewModel.choseArr addObjectsFromArray:_viewModel.dataArr];
    } else {
        for (XKWelfareBuyCarItem *model in _viewModel.dataArr) {
            model.selected = NO;
        }
        [_viewModel.choseArr removeAllObjects];

    }
    [self countPoint];
    [self.tableView reloadData];
}

- (void)choseRow:(NSInteger )row {
    XKWelfareBuyCarItem *model = _viewModel.dataArr[row];
    model.selected = !model.selected;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self countPoint];
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
}

- (void)deleteChoseItem:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    XKWeakSelf(ws);
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (XKWelfareBuyCarItem *model in _viewModel.dataArr) {
        if(model.selected) {
            [deleteArr addObject:model];
        }
    }
    [XKWelfareBuyCarViewModel deleteWelfareBuyCarListWithDeleteArr:deleteArr success:^(NSArray *modelArr) {
        [XKHudView showTipMessage:@"删除成功"];
        [self.viewModel.dataArr removeObjectsInArray:deleteArr];
        ws.navBar.rightButtonBlock(ws.navBar.rightButton);
        sender.userInteractionEnabled = YES;
        [ws.tableView.mj_header beginRefreshing];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
        sender.userInteractionEnabled = YES;
    }];
}

- (void)collectChoseItem:(UIButton *)sender {
    XKWeakSelf(ws);
    sender.userInteractionEnabled = NO;
    NSMutableArray *collectArr = [NSMutableArray array];
    for (XKWelfareBuyCarItem *model in _viewModel.dataArr) {
        if(model.selected) {
            [collectArr addObject:model];
        }
    }
    [XKWelfareBuyCarViewModel collectWelfareBuyCarListWithDeleteArr:collectArr success:^(NSArray *modelArr) {
        [XKHudView showTipMessage:@"收藏成功"];
        ws.navBar.rightButtonBlock(ws.navBar.rightButton);
        sender.userInteractionEnabled = YES;
        [ws.tableView.mj_header beginRefreshing];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
        sender.userInteractionEnabled = YES;
    }];
}
#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWelfareBuyCarItem *model = _viewModel.dataArr[indexPath.row];
    if ([model.drawType isEqualToString:@"bytime"]) {
        return 115;
    } else if ([model.drawType isEqualToString:@"bymember"]) {
        return 120;
    } else if ([model.drawType isEqualToString:@"bytime_or_bymember"]) {
        return 150;
        
    } else if ([model.drawType isEqualToString:@"bytime_and_bymember"]) {
        return 150;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    XKWelfareOrderWaitOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenCell"];
    XKWelfareBuyCarItem *model = _viewModel.dataArr[indexPath.row];
    model.index = indexPath.row;
    if ([model.drawType isEqualToString:@"bytime"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenTimeCell" forIndexPath:indexPath];
    } else if ([model.drawType isEqualToString:@"bymember"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenProgressCell" forIndexPath:indexPath];
    } else if ([model.drawType isEqualToString:@"bytime_or_bymember"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenProgressOrTimeCell" forIndexPath:indexPath];
        
    } else if ([model.drawType isEqualToString:@"bytime_and_bymember"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenProgressAndTimeCell" forIndexPath:indexPath];
    }
    if(model.status == 0) {
        [cell handleDataModel:model hasLose:YES manangeModel:_viewModel.manager];
    } else {
        [cell handleDataModel:model hasLose:NO manangeModel:_viewModel.manager];
    }
    
    cell.calculateBlock = ^(NSInteger row, NSInteger currentCount) {
        [ws countPoint];
    };
    
    cell.choseBlock = ^(NSInteger row, UIButton *sender) {
        [ws choseRow:row];
    };
    
    if(self.viewModel.dataArr.count == 1) {
        cell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    } else {
        if(indexPath.row == 0) {
            cell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if(indexPath.row == self.viewModel.dataArr.count - 1) {
             cell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
        } else {
             cell.bgContainView.xk_clipType = XKCornerClipTypeNone;
        }
    }
   

      return cell;
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
}


#pragma mark 懒加载
- (UITableView *)tableView {
    XKWeakSelf(ws);
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareBuyCarCell class] forCellReuseIdentifier:@"XKWelfareBuyCarCell"];
        [_tableView registerClass:[XKWelfareLoseEfficacyBuyCarCell class] forCellReuseIdentifier:@"XKWelfareLoseEfficacyBuyCarCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenTimeCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressAndTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressAndTimeCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressOrTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressOrTimeCell"];
        
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.viewModel.page = 0;
            [ws requestWithTip:NO];
        }];
        _tableView.mj_header = narmalHeader;
//
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [ws requestWithTip:NO];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = foot;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewBuyCar];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
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
                [XKHudView showErrorMessage:@"没有选择购物车商品"];
                return ;
            }
            XKWelfareSureOrderViewController *sureVC = [XKWelfareSureOrderViewController new];
            sureVC.goodsArr = ws.viewModel.choseArr;
            sureVC.totalPrice = ws.viewModel.totalPoint;
            [ws.navigationController pushViewController:sureVC animated:YES];
        };
    }
    return _bottomView;
}

- (UIView *)countView {
    if(!_countView) {
        _countView = [[UIView alloc] init];
        _countView.backgroundColor = [UIColor whiteColor];
        _countView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50 - 30, SCREEN_WIDTH, 30);
    }
    return _countView;
}

- (UILabel *)totalPointLabel {
    if(!_totalPointLabel) {
        _totalPointLabel = [[UILabel alloc] init];
        _totalPointLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _totalPointLabel.textColor = UIColorFromRGB(0x222222);

    }
    return _totalPointLabel;
}

- (UILabel *)otherPointLabel {
    if(!_otherPointLabel) {
        _otherPointLabel = [[UILabel alloc] init];
        _otherPointLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _otherPointLabel.textColor = UIColorFromRGB(0x222222);

       // _otherPointLabel.attributedText = attrString;
    }
    return _otherPointLabel;
}

@end
