//
//  XKWelfareOrderDetailWaitAcceptViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitAcceptViewController.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderWaitOpendDetailInfoCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareGoodsDestoryReportViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKWelfareGoodsDetailNumberInfoCell.h"
#import "XKWelfareReceiveGoodSuccessViewController.h"
#import "XKMenuView.h"
#import "XKWelfareOpinionViewController.h"
#import "XKWelfareChangeGoodsWaitingViewController.h"
#import "XKRefundProgressViewController.h"
@interface XKWelfareOrderDetailWaitAcceptViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UIView *sectionHeaderView;
@property (nonatomic, strong)UILabel *trackNameLabel;
@property (nonatomic, strong)NSArray *listNameArr;
@property (nonatomic, strong)NSArray *listValueArr;
@property (nonatomic, strong) WelfareOrderDataItem  *item;
@property (nonatomic, strong) XKWelfareOrderDetailViewModel  *viewModel;
@end

@implementation XKWelfareOrderDetailWaitAcceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)handleData {
    [super handleData];
    _page = 0;
    _listNameArr = @[@"兑奖方式：",@"中奖时间："];
    
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
    [self.view addSubview:self.bottomView];
}

- (void)handleOrderItemModel:(WelfareOrderDataItem *)item {
    _item = item;
    [self requestWithTip:YES];
}

- (void)moreBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    NSString *status = @"";
    if([_item.state isEqualToString:@"NO_LOTTERY"]) {
        status = @"未开奖";
    } else if([_item.state isEqualToString:@"LOSING_LOTTERY"]) {
        status = @"未中奖";
    } else if([_item.state isEqualToString:@"WINNING_LOTTERY"]) {
        status = @"已中奖";
    } else if([_item.state isEqualToString:@"SHARE_LOTTERY"]) {
        status = @"已晒单";
    } else if([_item.state isEqualToString:@"NOT_SHARE"]) {
        status = @"待分享";
    } else if([_item.state isEqualToString:@"NOT_DELIVERY"]) {
        status = @"待发货";
    } else if([_item.state isEqualToString:@"DELIVERY"]) {
        status = @"待收货";
    } else if([_item.state isEqualToString:@"RECEVING"]) {
        status = @"已收货";
    } else if([_item.state isEqualToString:@"CHANGED"]) {
        status = @"已换货";
    }
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:@[@"货物报损"] images:nil width:80 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if (ws.viewModel.refundCount < 2) {
        if (([ws.viewModel.refundRecordAudit isEqualToString:@"OTHER"]) || ([ws.viewModel.refundRecordAudit isEqualToString:@"UNAPPROVED"] && (ws.viewModel.refundCount < 2))) {//未申请或者被拒次数小于2次
            XKWelfareOpinionViewController *destory = [XKWelfareOpinionViewController new];
            destory.reportType = XKReportTypeChangeGoods;
            destory.orderId = ws.viewModel.orderId;
            [ws.navigationController pushViewController:destory animated:YES];
        } else if ([ws.viewModel.refundRecordAudit isEqualToString:@"UNAUDITED"]) {//待审核
            XKWelfareChangeGoodsWaitingViewController *waiting = [XKWelfareChangeGoodsWaitingViewController new];
            waiting.orderId = ws.viewModel.orderId;
            [ws.navigationController pushViewController:waiting animated:YES];
        } else if ([ws.viewModel.refundRecordAudit isEqualToString:@"VERIFIED"]) {
            XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
            progress.refundId = ws.viewModel.orderId;
            [[self getCurrentUIVC].navigationController pushViewController:progress animated:YES];
        }
        } else {
            [XKHudView showErrorMessage:@"申请次数超过限制，请联系客服处理"];
        }

    }];
    moreMenuVuew.textFont = XKRegularFont(12);
    moreMenuVuew.textColor = UIColorFromRGB(0x222222);
    [moreMenuVuew show];
}
#pragma mark 网络请求
//确认收货
- (void)sureToAccepte:(UIButton *)sender {
    sender.enabled = NO;
    [XKHudView showLoadingTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"orderId" : _item.orderId ?:@"",
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderSureAcceptWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        XKWelfareReceiveGoodSuccessViewController *accept = [XKWelfareReceiveGoodSuccessViewController new];
        [self.navigationController pushViewController:accept animated:YES];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)requestWithTip:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    NSDictionary *dic = @{
                          @"orderId" : _item.orderId ?:@"",
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderDetailWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(XKWelfareOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;
    if (model.logisticsName) {
        NSArray *nameArr = @[@"小可自营物流",@"顺丰",@"韵达",@"中通",@"申通",@"圆通",@"百世汇通",@"用户自行配送"];
        NSArray *valueArr = @[@"XK",@"SF",@"YD",@"ZT",@"ST",@"YT",@"BSHT",@"HIMSELF"];
        NSInteger index = [valueArr indexOfObject:model.logisticsName];
        NSString *transport = nameArr[index];
        self.sectionHeaderView.backgroundColor  = [UIColor whiteColor];
        _trackNameLabel.text = [NSString stringWithFormat:@"%@:   %@",transport,_viewModel.logisticsNo];
    }

    NSString *winDate = [XKTimeSeparateHelper backYMDHMStringByChineseSegmentWithTimestampString:@(_viewModel.lotteryTime).stringValue];
    _listValueArr = @[@"积分兑奖", winDate ?:@""];
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 3 ? _listValueArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
           {
               XKWelfareOrderDetailTopCell *cell = [[XKWelfareOrderDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                [cell handleWelfareOrderDetailWithType:WelfareOrderTypePre_recevice dataModel:_viewModel];
               return cell;
           }
            break;
        case 1:
        {
            XKWelfareOrderWaitOpendDetailInfoCell *cell = [[XKWelfareOrderWaitOpendDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell bindDataModel:_viewModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 2:{
            XKWelfareGoodsDetailNumberInfoCell *cell = [[XKWelfareGoodsDetailNumberInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell bindDataModel:_viewModel];
            return cell;
        }
        case 3:
        {
            XKOrderInputTableViewCell *inputCell = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            inputCell.rightTf.enabled = NO;
            [inputCell updateTextLayout];
            inputCell.leftLabel.text =  [NSString stringWithFormat:@"%@   %@",_listNameArr[indexPath.row],_listValueArr[indexPath.row]];
            if (indexPath.row == 0) {
                 inputCell.xk_clipType = XKCornerClipTypeTopBoth;
            } else {
                 inputCell.xk_clipType = XKCornerClipTypeBottomBoth;
            }
            return inputCell;
            
        }
            break;
        case 4: {
            XKOrderInputTableViewCell *cell  = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell updateTextLayout];
            cell.xk_clipType = XKCornerClipTypeAllCorners;
            NSMutableAttributedString *attrSt = [[NSMutableAttributedString alloc] initWithString:@""];
            for (NSInteger i = 0; i < _viewModel.logisticsInfos.count; i ++) {
                XKWelfareGoodsTransportInfoItem *obj = _viewModel.logisticsInfos[i];
                NSString *time =  [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:obj.time];
                NSString *location = obj.location;
                NSString *info = [NSString stringWithFormat:@"%@ %@\n",time,location];
                UIColor *textColor = UIColorFromRGB(0x555555);
                NSAttributedString *setpAttrStr = [[NSMutableAttributedString alloc] initWithString:info attributes:@{NSForegroundColorAttributeName:textColor}];
                [attrSt appendAttributedString:setpAttrStr];
            }
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];
            [attrSt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrSt length])];
            cell.leftLabel.attributedText = attrSt;
            return cell;
        }
            
            break;
            
        default: return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  section == 3 ? 10 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return section == 4 ? self.tableFooterView : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 4 ? 44 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return section == 4 ? self.sectionHeaderView : self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareOrderDetailTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailTopCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewWaitAccept];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        
        _bottomView.moreBtnBlock = ^(UIButton *sender) {
            if (ws.viewModel) {
                [ws moreBtnClick:sender];
            }
            
        };
        
        _bottomView.sureBtnBlock = ^(UIButton *sender) {
            [ws sureToAccepte:sender];
        };
        
        _bottomView.chatBtnBlock  = ^(UIButton *sender) {
             [XKCustomeSerMessageManager createXKCustomerSerChat];
        };
    }
    return _bottomView;
}

- (UIView *)sectionHeaderView {
    if(!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 , 44)];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        [_sectionHeaderView cutCornerWithRoundedRect:_sectionHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        _trackNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 50, 44)];
        _trackNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _trackNameLabel.textColor = UIColorFromRGB(0x555555);
   
        [_sectionHeaderView addSubview:_trackNameLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH - 20, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [_sectionHeaderView addSubview:lineView];
    }
    return _sectionHeaderView;
}

@end
