//
//  XKRefundProgressViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKRefundProgressViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKMallOrderRefundProgressViewTopCell.h"
#import "XKMallOrderRefundProgressCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKRefundProgressViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)NSString *reason;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *submitBtn;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) XKMallOrderDetailViewModel  *viewModel;
@end

@implementation XKRefundProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
}

- (void)setRefundId:(NSString *)refundId {
    _refundId = refundId;
     [self requestData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"退款进度" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
}

#pragma mark delegate
- (void)requestData {
    [XKHudView showLoadingTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"refundId" : _refundId
                          };
    [XKMallOrderDetailViewModel requestMallAfterSaleOrderDetailWithParamDic:dic Success:^(XKMallOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
    
}

- (void)handleSuccessDataWithModel:(XKMallOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;

    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? _viewModel.refundLogList.count : section == 0 ? _viewModel.goodsInfo.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            {
                XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
                [cell handleWaitPayOrderDetailModel:_viewModel.goodsInfo[indexPath.row]];
                return cell;
            }
            break;
        case 1:
            {
                XKMallOrderRefundProgressViewTopCell *info = [XKMallOrderRefundProgressViewTopCell new];
                [info updateInfoWithModel:_viewModel];
                return info;
            }
            break;
        case 2:
            {
                XKMallOrderRefundProgressCell *progress = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderRefundProgressCell" forIndexPath:indexPath];
                progress.xk_openClip = YES;
                progress.xk_radius = 5;
                XKMallRefundLogListItem *item = _viewModel.refundLogList[indexPath.row];
                if(_dataArr.count == 1) {
                    [progress bindDataWithModel:item isFirst:YES isLast:YES];
                    progress.xk_clipType = XKCornerClipTypeAllCorners;
                } else {
                    if(indexPath.row == 0) {
                        [progress bindDataWithModel:item isFirst:YES isLast:NO];
                        progress.xk_clipType = XKCornerClipTypeTopBoth;
                        
                    } else if(indexPath.row == _dataArr.count - 1){
                        [progress bindDataWithModel:item isFirst:NO isLast:YES];
                        progress.xk_clipType = XKCornerClipTypeBottomBoth;
                    } else {
                        [progress bindDataWithModel:item isFirst:NO isLast:NO];
                        progress.xk_clipType = XKCornerClipTypeNone;
                    }
                }
                
                return progress;
            }
            break;
        default:return nil;
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 1 && indexPath.row == 0) {
        [self.bottomView show];
    }
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        [_tableView registerClass:[XKMallOrderRefundProgressViewTopCell class] forCellReuseIdentifier:@"XKMallOrderRefundProgressViewTopCell"];
        [_tableView registerClass:[XKMallOrderRefundProgressCell class] forCellReuseIdentifier:@"XKMallOrderRefundProgressCell"];
    }
    return _tableView;
}

@end
