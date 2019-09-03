//
//  XKWelfareOrderDetailWaitSendViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitSendViewController.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderWaitOpendDetailInfoCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareGoodsDestoryReportViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKWelfareGoodsDetailNumberInfoCell.h"
@interface XKWelfareOrderDetailWaitSendViewController () <UITableViewDelegate,UITableViewDataSource>
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

@implementation XKWelfareOrderDetailWaitSendViewController

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

//联系客服
- (void)chatBtnClick:(UIButton *)sender {
    [XKCustomeSerMessageManager createXKCustomerSerChat];
}


- (void)handleOrderItemModel:(WelfareOrderDataItem *)item {
    _item = item;
    [self requestWithTip:YES];
}
#pragma mark 网络请求
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

    NSString *winDate = [XKTimeSeparateHelper backYMDHMStringByChineseSegmentWithTimestampString:@(_viewModel.lotteryTime).stringValue];
    _listValueArr = @[@"积分兑奖", winDate ?:@""];
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 3 ? _listValueArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSString *address = [NSString stringWithFormat:@"地址：%@",_viewModel.userAddress];
            CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
            return  addressH + 75 + 5;
        }
            break;
        case 1:
            return 110;
            break;
        case 2:
        {
            NSString *number = @"";
            for (XKWelfareOrderNumberItem * item in _viewModel.lotteryNumbers) {
                number =  [number stringByAppendingString:item.lotteryNumber];
                number =  [number stringByAppendingString:@"\n"];
            }
            NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:number];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10];
            [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
            CGFloat numberH = [number boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12),NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
            return 40 + numberH;
        }
            break;
        case 3:
            return 42;

            
        default: return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            XKWelfareOrderDetailTopCell *cell = [[XKWelfareOrderDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell handleWelfareOrderDetailWithType:WelfareOrderTypePre_send dataModel:_viewModel];
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
            inputCell.leftLabel.text = _listNameArr[indexPath.row];
            inputCell.rightTf.text = _listValueArr[indexPath.row];
            if(_listNameArr.count == 1) {
                inputCell.xk_clipType = XKCornerClipTypeAllCorners;
            } else {
                if(indexPath.row == 0) {
                    inputCell.xk_clipType = XKCornerClipTypeTopBoth;
                    [inputCell hiddenSeperateLine:NO];
                } else {
                    inputCell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [inputCell hiddenSeperateLine:YES];
                }
            }
            return inputCell;
            
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
    
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewWaitSend];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.chatBtnBlock  = ^(UIButton *sender) {
              [XKCustomeSerMessageManager createXKCustomerSerChat];
        };
        
        _bottomView.tipBtnBlock  = ^(UIButton *sender) {
            [XKHudView showSuccessMessage:@"已成功提醒发货！"];
        };
        
        _bottomView.moreBtnBlock = ^(UIButton *sender) {
            
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
        _trackNameLabel.text = @"中通快递:   123123123123123";
        [_sectionHeaderView addSubview:_trackNameLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH - 20, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [_sectionHeaderView addSubview:lineView];
    }
    return _sectionHeaderView;
}

@end
