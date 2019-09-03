//
//  XKMallOrderPayResultViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderPayResultViewController.h"
#import "XKMallOrderPayResultCell.h"
#import "XKMallOrderPayResultStatusCell.h"
#import "XKMallOrderDetailWaitPayViewController.h"
#import "XKMallOrderDetailWaitSendViewController.h"
#import "XKMallListViewModel.h"
@interface XKMallOrderPayResultViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSArray *dataArr;
@end

@implementation XKMallOrderPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestRecommendData];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
  
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    NSString *titleStr = self.payResult == 1 ? @"付款成功" : @"付款失败";
    [_navBar customNaviBarWithTitle:titleStr andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
}

- (void)requestRecommendData {
    XKWeakSelf(ws);
    NSDictionary *parmDic = @{
                              @"page" : @1,
                              @"limit" : @100,
                              @"condition" : @{ @"districtCode" : @"510107"},
                              };
    
    [XKMallGoodsListModel requestMallRecommendGoodsListWithParam:parmDic Success:^(NSArray *modelList) {
        ws.dataArr = modelList;
        [ws.tableView reloadData];
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
      
    }];
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 225 : 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if(indexPath.section == 0) {
        XKMallOrderPayResultStatusCell *status = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderPayResultStatusCell" forIndexPath:indexPath];
        status.status = self.payResult;
        status.orderClickBlock = ^(UIButton *sender) {
            if (ws.payResult == 1) {
                XKMallOrderDetailWaitSendViewController *waitSend = [XKMallOrderDetailWaitSendViewController new];
                waitSend.orderId = ws.item.orderId;
                [ws.navigationController pushViewController:waitSend animated:YES];
            } else {
                XKMallOrderDetailWaitPayViewController *waitPay = [XKMallOrderDetailWaitPayViewController new];
                waitPay.orderId = ws.item.orderId;
                [ws.navigationController pushViewController:waitPay animated:YES];
            }
        };
        
        status.mallClickBlock = ^(UIButton *sender) {
            NSMutableArray *tmpArr = ws.navigationController.viewControllers.mutableCopy;
            UIViewController *vc = [tmpArr objectAtIndex:1];
            [ws.navigationController popToViewController:vc animated:YES];
        };
        
        status.groundClickBlock = ^(UIButton *sender) {
            NSMutableArray *tmpArr = ws.navigationController.viewControllers.mutableCopy;
            UIViewController *vc = [tmpArr objectAtIndex:0];
            [ws.navigationController popToViewController:vc animated:YES];

        };
        
        status.payAgainstBlock = ^(UIButton *sender) {
            [ws showPayWithItem:ws.item successBlock:^(id  _Nonnull data) {
                [XKHudView showSuccessMessage:@"支付成功"];
                ws.payResult = 1;
                [ws.tableView reloadData];
            } failedBlock:^(NSString * _Nonnull reason) {
                [XKHudView showErrorMessage:reason];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws.navigationController popViewControllerAnimated:YES];
                });
            }];
        };
        return status;
    } else {
        XKMallOrderPayResultCell *result = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderPayResultCell" forIndexPath:indexPath];
        [result bindData:_dataArr[indexPath.row]];
        return result;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? self.clearHeaderView : self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderPayResultCell class] forCellReuseIdentifier:@"XKMallOrderPayResultCell"];
        [_tableView registerClass:[XKMallOrderPayResultStatusCell class] forCellReuseIdentifier:@"XKMallOrderPayResultStatusCell"];
    }
    return _tableView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 30)];
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.font = XKRegularFont(14);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"热门推荐";
        [_headerView addSubview:titleLabel];
    }
    return _headerView;
}

@end
