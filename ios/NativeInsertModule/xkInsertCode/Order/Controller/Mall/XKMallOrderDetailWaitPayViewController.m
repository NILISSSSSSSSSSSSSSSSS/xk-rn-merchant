//
//  XKMallOrderDetailWaitPayViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailWaitPayViewController.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKMallOrderDetailGoodInfoCell.h"
#import "XKWelfareOrderFinishCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKMallOrderListBottomView.h"
#import "XKMallOrderDetailWaitPayInfoCell.h"
#import "XKMallOrderDetailViewModel.h"
#import "XKPayAlertSheetView.h"
#import "XKMallOrderDetailInfoTableViewCell.h"
@interface XKMallOrderDetailWaitPayViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *mallHeaderView;
@property (nonatomic, strong)UIView *mallFootView;
@property (nonatomic, strong)UIButton *expandedBtn;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKMallOrderListBottomView *bottomView;
@property (nonatomic, strong)XKMallOrderDetailViewModel *viewModel;
@property (nonatomic, strong)NSArray *listNameArr;
@property (nonatomic, strong)NSMutableArray *goodsTmpArr;

@end

@implementation XKMallOrderDetailWaitPayViewController

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
        [_goodsTmpArr removeAllObjects];
        if(_viewModel.goodsInfo.count > 2) {
            [_goodsTmpArr addObject:_viewModel.goodsInfo[0]];
            [_goodsTmpArr addObject:_viewModel.goodsInfo[1]];
        } else {
            [_goodsTmpArr addObject:_viewModel.goodsInfo[0]];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    }
   
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
                          @"orderId" : self.orderId
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
    
    if (![_viewModel.status isEqualToString:@"del"] && !self.bottomView) {
        [self.view addSubview:self.bottomView];
    }
    [_bottomView updatePrice:_viewModel.amountInfo.payMoney / 100];
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
    if (_viewModel) {
        if (!_viewModel.invoiceInfo.invoiceType) {
            return 4;
        } else {
            return 5;
        }
    }
    return  0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? _goodsTmpArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *address = [NSString stringWithFormat:@"地址：%@",_viewModel.addressInfo.userAddress];
    CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
    switch (indexPath.section) {
        case 0:
            return addressH + 75 + 5;
            break;
        case 1:
            return 108;
            break;
        case 2:
            return 95;
            break;
        case 3:
            return 70;
            break;
        case 4:
            return 95;
            break;
            
        default:return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
    case 0:
        {
            XKWelfareOrderDetailTopCell *cell = [[XKWelfareOrderDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if ([_viewModel.status isEqualToString:@"del"]) {
                [cell handleOrderDetailWithType:MOT_TERMINATE dataModel:_viewModel];
            } else {
                [cell handleOrderDetailWithType:MOT_PRE_PAY dataModel:_viewModel];
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
            XKMallOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderDetailInfoTableViewCell" forIndexPath:indexPath];
            [cell handleWaitPayOrderDetailModel:_viewModel WithType:1];
            return cell;
        }
        case 3:
        {
            XKMallOrderDetailWaitPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderDetailWaitPayInfoCell" forIndexPath:indexPath];
            [cell handleWaitPayOrderDetailModel:_viewModel];
            if (!_viewModel.invoiceInfo.electInvoice) {
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                cell.xk_clipType = XKCornerClipTypeNone;
            }
            return cell;
        }
        case 4:
        {
            XKMallOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderDetailInfoTableViewCell" forIndexPath:indexPath];
            [cell handleWaitPayOrderDetailModel:_viewModel WithType:0];
            return cell;
        }
            
        default: return nil;
            break;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return _viewModel.goodsInfo.count > 2 ? 40 : 10;
            break;
        case 2:
            return 0.01;
            break;
        case 3:
            return 0.01;
            break;
        case 4:
            return 10;
            break;
            
        default: return 0;
            break;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 1 ? _viewModel.goodsInfo.count > 2 ? self.mallFootView : nil : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return 0;
            break;
        case 4:
            return 0;
            break;
            
        default: return 0;
            break;
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareOrderDetailTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailTopCell"];
        [_tableView registerClass:[XKMallOrderDetailGoodInfoCell class] forCellReuseIdentifier:@"XKMallOrderDetailGoodInfoCell"];
        [_tableView registerClass:[XKMallOrderDetailWaitPayInfoCell class] forCellReuseIdentifier:@"XKMallOrderDetailWaitPayInfoCell"];
        [_tableView registerClass:[XKMallOrderDetailInfoTableViewCell class] forCellReuseIdentifier:@"XKMallOrderDetailInfoTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKMallOrderListBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [XKMallOrderListBottomView MallOrderListBottomViewWithType:MallOrderDetailBottomViewWaitPay];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.payBlock = ^(UIButton *sender) {
            [XKPayAlertSheetView showWithResultBlock:^(NSInteger index) {
                
            }];
        };
    }
    return _bottomView;
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
