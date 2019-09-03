//
//  XKMallOrderApplyRefundViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderApplyRefundViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKRefundProgressViewController.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallOrderRefundMoneyApplySuccessViewController.h"
@interface XKMallOrderApplyRefundItem : NSObject
@property (nonatomic, copy) NSString  *refundId;
@end

@implementation XKMallOrderApplyRefundItem
@end
@interface XKMallOrderApplyRefundViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView  *submitView;
@property (nonatomic, strong) XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) NSArray  *reasonArr;
@property (nonatomic, copy) NSString  *reason;
@property (nonatomic, copy) NSString  *reasonId;
@end

@implementation XKMallOrderApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
    for (MallOrderListObj *obj in self.goodsArr) {
        _totalPrice += obj.price;
    }
    _totalPrice = _totalPrice / 100;
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"退款申请" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    
    _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _submitView.backgroundColor = [UIColor clearColor];
    [self.submitView addSubview:self.submitBtn];
   
}

- (void)reasonChose {
    XKWeakSelf(ws);
    [XKMallOrderViewModel requestMallRefundReasonSuccess:^(NSArray *modelArr) {
        ws.reasonArr = modelArr;
        NSMutableArray  *tmp = [NSMutableArray array];
        for (XKMallOrderViewModel *model in modelArr) {
            [tmp addObject:model.refundReason];
        }
        [tmp addObject:@"取消"];
        self.bottomView = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:tmp firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            if ([choseTitle isEqualToString:@"取消"]) {
                ws.reason = @"退货原因:";
            } else {
                
                ws.reason = choseTitle;
                XKMallOrderViewModel *model = ws.reasonArr[index];
                ws.reasonId = model.refundReasonId;
             
            }
            [ws.tableView reloadData];
        }];
        [self.bottomView show];
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
    }];
}

- (void)submitBtnClick:(UIButton *)sender {
    if (!self.reasonId) {
        [XKHudView showErrorMessage:@"请选择退款理由"];
        return;
    }
    NSMutableArray *tmp = [NSMutableArray array];
    for (MallOrderListObj *obj in self.goodsArr) {
        NSDictionary *dic = @{
                              @"goodsId" : obj.goodsId,
                              @"goodsSkuCode" : obj.goodsSkuCode
                              };
        [tmp addObject:dic];
    }
    NSDictionary *dic = @{@"mallRefundOrderParams" : @{
                                  @"refundType" : _refundType,
                                  @"refundGoods" : tmp,
                                  @"orderId" : self.orderId,
                                  @"refundReasonId" : _reasonId,
                                  @"refundMessage" : _reason
                                  }
                          
                          };


    [XKMallOrderViewModel requestMallRefundWithParm:dic Success:^(id data) {
        XKMallOrderApplyRefundItem * item = [XKMallOrderApplyRefundItem yy_modelWithJSON:data];
        XKMallOrderRefundMoneyApplySuccessViewController *apply = [XKMallOrderRefundMoneyApplySuccessViewController new];
        apply.refundId = item.refundId ?:@"";
     
        [self.navigationController pushViewController:apply animated:YES];

    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
    }];
//    XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
//    [self.navigationController pushViewController:progress animated:YES];
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return section == 0 ? _goodsArr.count : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 100 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
        [cell handleOrderObj:_goodsArr[indexPath.row]];
        if(indexPath.row == 0) {
            [cell hiddenSeperateLine:NO];
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else if(indexPath.row == _goodsArr.count - 1) {
            [cell hiddenSeperateLine:YES];
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else {
            [cell hiddenSeperateLine:NO];
            cell.layer.mask = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        return cell;
    } else {
        if(indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = _reason ?: @"退货原因:";
            cell.textLabel.textColor = UIColorFromRGB(0x222222);
            cell.textLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            
            cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
            cell.detailTextLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
            return cell;
        } else {
            XKOrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKOrderInputTableViewCell" forIndexPath:indexPath];
            cell.leftLabel.text = @"退款金额:";
            cell.leftLabel.textColor = UIColorFromRGB(0x222222);
            cell.leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            
            cell.rightLabel.textColor = UIColorFromRGB(0x222222);
            cell.rightLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            cell.rightLabel.text = [NSString stringWithFormat:@"¥ %@",@(_totalPrice).stringValue];
            cell.rightTf.enabled = NO;
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 0 ? self.clearFooterView : self.submitView;
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
        [self reasonChose];
    }
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        
    }
    return _tableView;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,  20, SCREEN_WIDTH - 20, 44)];
        [_submitBtn setTitle:@"申请退款" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.titleLabel.font = XKRegularFont(17);
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        _submitBtn.layer.cornerRadius = 8.f;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
