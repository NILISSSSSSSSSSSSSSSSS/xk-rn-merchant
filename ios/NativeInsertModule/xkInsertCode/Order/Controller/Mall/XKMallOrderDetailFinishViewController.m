//
//  XKMallOrderDetailFinishViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailFinishViewController.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKMallOrderDetailGoodInfoCell.h"
#import "XKWelfareOrderFinishCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKMallOrderDetailFinishInfoCell.h"
@interface XKMallOrderDetailFinishViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *mallHeaderView;
@property (nonatomic, strong)UIView *mallFootView;
@property (nonatomic, strong)UIButton *expandedBtn;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)NSMutableArray *goodsTmpArr;
@property (nonatomic, strong)XKMallOrderDetailViewModel *viewModel;
@property (nonatomic, strong)MallOrderListDataItem *item;
@property (nonatomic, strong)NSArray *listNameArr;
@end

@implementation XKMallOrderDetailFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)handleData {
    [super handleData];
    _goodsTmpArr = [NSMutableArray array];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.titleString = @"订单详情";
    [_navBar customBaseNavigationBar];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
}

#pragma mark event
- (void)expandedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.isSelected) {
        [_goodsTmpArr removeAllObjects];
        [_goodsTmpArr addObjectsFromArray:_viewModel.goodsInfo];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        if(_viewModel.goodsInfo.count > 2) {
            [_goodsTmpArr addObject:_viewModel.goodsInfo[0]];
            [_goodsTmpArr addObject:_viewModel.goodsInfo[1]];
        } else {
            [_goodsTmpArr addObject:_viewModel.goodsInfo[0]];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    }
    
}

//去付款
- (void)toPayBtnClick:(UIButton *)sender {
    
}

- (void)updateModelWithItem:(MallOrderListDataItem *)item {
    _item = item;
}

- (void)setOrderId:(NSString *)orderId {
    [super setOrderId:orderId];
    [self requestWithTip:YES];
}

#pragma mark 网络请求
- (void)requestWithTip:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    NSDictionary *dic = @{
                         @"orderId" : _item.orderId
                          };
    [XKMallOrderDetailViewModel requestMallOrderDetailWithParamDic:dic Success:^(XKMallOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(XKMallOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;
    if(model.goodsInfo.count > 2) {
        [_goodsTmpArr addObject:model.goodsInfo[0]];
        [_goodsTmpArr addObject:model.goodsInfo[1]];
    } else {
        [_goodsTmpArr addObjectsFromArray:model.goodsInfo];
    }
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}
#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _viewModel == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? _goodsTmpArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *address = [NSString stringWithFormat:@"地址：%@",_viewModel.addressInfo.userAddress];
    CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
    return indexPath.section == 2 ? 440 : addressH + 75 + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            XKWelfareOrderDetailTopCell *cell = [[XKWelfareOrderDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if ([_item.status isEqualToString:@"del"]) {
                 [cell handleOrderDetailWithType:MOT_TERMINATE dataModel:_viewModel];
            } else {
                [cell handleOrderDetailWithType:MOT_COMPLETELY dataModel:_viewModel];
            }
           
            return cell;
        }
            break;
        case 1:
        {
            XKMallOrderDetailGoodInfoCell *cell = [[XKMallOrderDetailGoodInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell handleWaitPayOrderDetailModel:_viewModel.goodsInfo[indexPath.row]];
            return cell;
        }
        case 2:
        {
            XKMallOrderDetailFinishInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderDetailFinishInfoCell" forIndexPath:indexPath];
            [cell handleWaitPayOrderDetailModel:_viewModel];
            return cell;
        }
            
        default: return nil;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? _viewModel.goodsInfo.count > 2 ? 40 : 0 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 1 ? _viewModel.goodsInfo.count > 2 ? self.mallFootView : nil : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 40 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 1 ? self.mallHeaderView : self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareOrderDetailTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailTopCell"];
        [_tableView registerClass:[XKMallOrderDetailGoodInfoCell class] forCellReuseIdentifier:@"XKMallOrderDetailGoodInfoCell"];
        [_tableView registerClass:[XKMallOrderDetailFinishInfoCell class] forCellReuseIdentifier:@"XKMallOrderDetailFinishInfoCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)mallHeaderView {
    if(!_mallHeaderView) {
        _mallHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        _mallHeaderView.backgroundColor = [UIColor whiteColor];
        [_mallHeaderView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 20 - 30, 40)];
        titleLabel.text = @"晓可商城";
        titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        titleLabel.textColor = UIColorFromRGB(0x222222);
        [_mallHeaderView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH - 20, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        [_mallHeaderView addSubview:line];
        
    }
    return _mallHeaderView;
}

- (UIView *)mallFootView {
    if(!_mallFootView) {
        _mallFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        [_mallFootView addSubview:self.expandedBtn];
        _mallFootView.backgroundColor = [UIColor whiteColor];
        [_mallFootView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    }
    return _mallFootView;
}

- (UIButton *)expandedBtn {
    if(!_expandedBtn) {
        _expandedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_expandedBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        _expandedBtn.titleLabel.font = XKRegularFont(12);
        [_expandedBtn setTitle:@"展开所有" forState:0];
        [_expandedBtn setTitle:@"展开所有" forState:UIControlStateSelected];
        [_expandedBtn setImage:[UIImage imageNamed:@""] forState:0];
        [_expandedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_expandedBtn addTarget:self action:@selector(expandedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandedBtn;
}

@end
