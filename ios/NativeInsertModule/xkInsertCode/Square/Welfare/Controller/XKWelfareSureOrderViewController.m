//
//  XKWelfareSureOrderViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareSureOrderViewController.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareOrderSureCell.h"
#import "XKWelfaceOrderSureAddressCell.h"
#import "XKWelfaceOrderSureNoAddressCell.h"
#import "XKPayAlertSheetView.h"
#import "XKWelfareBuyCarViewModel.h"
#import "XKMineConfigureRecipientListViewController.h"
#import "XKMineConfigureRecipientListModel.h"
#import "XKWelfareOrderWaitOpenTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressCell.h"
#import "XKWelfareOrderWaitOpenProgressAndTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressOrTimeCell.h"
#import "XKWelfareBuySuccessViewController.h"
@interface XKWelfareSureOrderViewController () <UITableViewDelegate, UITableViewDataSource, ConfigureRecipientListDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UIView *messageFooterView;
@property (nonatomic, copy) NSString  *remark;
@property (nonatomic, strong) XKMineConfigureRecipientItem  *addressItem;

@end

@implementation XKWelfareSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAddressList];
}

- (void)handleData {
    [super handleData];
    _page = 0;
 
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
     _navBar.titleString = @"确认订单";
    [_navBar customBaseNavigationBar];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };

    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}
#pragma mark 网络请求
//请求默认地址
- (void)requestAddressList {
    [XKHudView showLoadingTo:self.tableView animated:YES];
    XKWeakSelf(ws);
    NSDictionary *parameters = @{@"page"    : @1,
                                 @"limit"   : @"5"
                                 };
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetRecipientListUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        XKMineConfigureRecipientListModel *model = [XKMineConfigureRecipientListModel yy_modelWithJSON:responseObject];
        for (XKMineConfigureRecipientItem *item in model.data) {
            if ([item.isDefault isEqualToString:@"1"]) {
                ws.addressItem = item;
            }
        }
        [ws.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
    }];
    
}
//下单
- (void)giveOrder {
    XKWeakSelf(ws);
    [self.view endEditing:YES];
    if (_addressItem == nil) {
        [XKHudView showErrorMessage:@"请先选择收货地址"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    
    NSInteger fee = 0;
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (XKWelfareBuyCarItem *item in self.goodsArr) {
        NSDictionary *dic = @{
                              @"num" : @(item.quantity),
                              @"sequenceId"   : item.sequenceId,
                            
                              };
        fee += item.quantity * item.price;
        [goodsArr addObject:dic];
    };
   
    NSDictionary *dic = @{
                          @"jOrderCreate" : @{
                                  @"remark" : _remark ?:@"",
                                  @"totalPrices" : @(fee),
                                  @"sequences" : goodsArr,
                                  @"addressId" : _addressItem.ID ?: @"",
                                  
                                  }
                          };
    
    [XKWelfareBuyCarViewModel orderWelfareGiveOrderParmDic:dic success:^(id respson) {
        XKWelfareBuySuccessViewController *result = [XKWelfareBuySuccessViewController new];
        [ws.navigationController pushViewController:result animated:YES];
//        NSMutableArray *goodsArr = [NSMutableArray array];
//        for (XKWelfareBuyCarItem *item in self.goodsArr) {
//            [goodsArr addObject:item.goodsId];
//        };
//
//        [XKWelfareBuyCarViewModel orderWelfarePayParmDic:@{@"orderIds" : goodsArr} success:^(id respson) {
//            [XKHudView showSuccessMessage:@"支付成功"];
//
//        } failed:^(NSString *failedReason) {
//            [XKHudView showErrorMessage:failedReason];
//        }];
        
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];

}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    _remark = textField.text;
}
#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : _goodsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? _page == 0 ? 60 : 85 : 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if(indexPath.section == 0) {
        if(!_addressItem) {
            XKWelfaceOrderSureNoAddressCell *cell = [[XKWelfaceOrderSureNoAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        } else {
            NSString *addressName = [NSString stringWithFormat:@"%@%@%@ %@",_addressItem.provinceName,_addressItem.cityName,_addressItem.districtName,_addressItem.street];
            
            XKWelfaceOrderSureAddressCell *cell = [[XKWelfaceOrderSureAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell updateInfoWithAddressName:addressName phone:_addressItem.phone userName:_addressItem.receiver];
            return cell;
        }
    } else {
        XKWelfareOrderWaitOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKWelfareOrderWaitOpenCell"];
        XKWelfareBuyCarItem *model = _goodsArr[indexPath.row];
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
        [cell bindItem:model];

        if(_goodsArr.count == 1) {
            cell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                cell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
            } else if(indexPath.row == _goodsArr.count - 1) {
                cell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                cell.bgContainView.xk_clipType = XKCornerClipTypeNone;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 0 : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 0 ? self.clearFooterView : self.messageFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XKMineConfigureRecipientListViewController *address = [XKMineConfigureRecipientListViewController new];
        address.delegate = self;
        [self.navigationController pushViewController:address animated:YES];
    }
}

#pragma mark 选择地址的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XKMineConfigureRecipientItem *)item {
    _addressItem = item;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
   
}
#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        [_tableView registerClass:[XKWelfareOrderSureCell class] forCellReuseIdentifier:@"XKWelfareOrderSureCell"];
        [_tableView registerClass:[XKWelfaceOrderSureAddressCell class] forCellReuseIdentifier:@"XKWelfaceOrderSureAddressCell"];
        [_tableView registerClass:[XKWelfaceOrderSureNoAddressCell class] forCellReuseIdentifier:@"XKWelfaceOrderSureNoAddressCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenTimeCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressAndTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressAndTimeCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpenProgressOrTimeCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpenProgressOrTimeCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewSureOrder];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.payBlock = ^(UIButton *sender) {
          //  [XKPayAlertSheetView show];
            [ws giveOrder];
        };
    }
    return _bottomView;
}

- (UIView *)messageFooterView {
    if(!_messageFooterView) {
        _messageFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _messageFooterView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        //设置所需的圆角位置以及大小
        [bgView cutCornerWithRoundedRect:_messageFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        
        UILabel *extrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,60, 20)];
        extrLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        extrLabel.textColor = UIColorFromRGB(0x222222);
        extrLabel.text = @"备注留言：";
        UITextField *inputTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(extrLabel.frame) + 5, 10, SCREEN_WIDTH - CGRectGetMaxX(extrLabel.frame) - 25, 20)];
        inputTf.textColor = UIColorFromRGB(0x222222);
        inputTf.delegate = self;
        inputTf.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [bgView addSubview:extrLabel];
        [bgView addSubview:inputTf];
        [_messageFooterView addSubview:bgView];
    }
    return _messageFooterView;
}
@end
