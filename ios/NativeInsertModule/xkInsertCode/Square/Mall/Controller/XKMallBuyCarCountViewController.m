//
//  XKMallBuyCarCountViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallBuyCarCountViewController.h"
#import "XKMallOrderNoAddressCell.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderWinCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKOrderInfoTableViewCell.h"
#import "XKPayAlertSheetView.h"
#import "XKCommonSheetView.h"
#import "XKMallBottomTicketView.h"
#import "XKReceiptManageListController.h"
#import "XKMallBuyCarViewModel.h"
#import "XKMineConfigureRecipientListViewController.h"
#import "XKMineConfigureRecipientListModel.h"
#import "XKMallOrderSureAddressCell.h"
#import "XKMallBuyCarCountBottomView.h"
#import "XKCustomeSerMessageManager.h"
#import "XKMallOrderDetailGoodInfoCell.h"
#import "XKPayForMallViewController.h"
#import "XKMallOrderPayResultViewController.h"
#import "XKMallOrderViewModel.h"
#import "XKReceiptListViewModel.h"
#import "XKQRCodeScanViewController.h"
#import "XKQRCodeResultManager.h"
#import "XKCheckoutCounterViewController.h"
@interface XKMallBuyCarCountViewController () <UITableViewDelegate, UITableViewDataSource, ConfigureRecipientListDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKMallBuyCarCountBottomView *bottomView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSArray *listNameArr;
@property (nonatomic, strong)XKMallBottomTicketView *ticketBottomView;
@property (nonatomic, strong)XKCommonSheetView *ticketBgView;
@property (nonatomic, copy)NSString *tickType;
@property (nonatomic, copy) NSString  *leaveWord;
@property (nonatomic, copy) NSString  *safeCode;
@property (nonatomic, assign) CGFloat  fee;
@property (nonatomic, strong) XKMineConfigureRecipientItem  *addressItem;
@property (nonatomic, strong) XKReceiptInfoModel  *ticketItem;
@property (nonatomic, strong) XKMallBuyCarViewModel  *feeItem;
@property (nonatomic, strong) MallOrderListDataItem  *orderItem;
@property (nonatomic, strong) NSArray  *orderTicketArr;
@property (nonatomic, strong) XKMallBuyCarItem  *orderTicketItem;

@end

@implementation XKMallBuyCarCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAddressList];
}

- (void)handleData {
    [super handleData];
   
    _page = 0;
    _safeCode = [XKUserInfo getCurrentMrCode];
    _listNameArr = @[@"备注留言：",@"发票信息：",@"运费：",@"选择优惠券：",@"推荐人：",@""];
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

//提醒发货
- (void)tipBtnClick:(UIButton *)sender {
     [XKHudView showSuccessMessage:@"已成功提醒发货！"];
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
        if (ws.addressItem) {
            [ws refreshPrice];
        }
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
    }];

}
//下单
- (void)giveOrder:(UIButton *)sender {
    if (!_addressItem) {
        [XKHudView showErrorMessage:@"请选择收货地址"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (XKMallBuyCarItem *item in self.goodsArr) {
        NSDictionary *dic = @{
                              @"goodsId" : item.goodsId,
                              @"goodsSum"   : @(item.quantity),
                              @"goodsSkuCode" : item.goodsSkuCode
                              };
        [goodsArr addObject:dic];
    };
    CGFloat fee = _feeItem.postAmount + _feeItem.goodsAmount;
    NSDictionary *dic = @{
                          @"mallCreateOrderParams" : @{
                                  @"goodsParams" : goodsArr,
                                  @"payAmount" : @(fee),
                                  
                                  @"referralCode"  : _safeCode ?: [XKUserInfo getCurrentMrCode],
                                  @"discountType" : [_orderTicketItem.cardType uppercaseString] ?: @"",
                                  @"userDiscountId" : _orderTicketItem.ID ?: @"",
                                  @"invoiceId" : ws.ticketItem.receiptId ?: @"",
                                  @"remark" : _leaveWord ?: @"",
                                  @"addressId" : _addressItem.ID ?: @"",
                                  
                                  }
                          };
    [XKMallBuyCarViewModel orderMallBuyWithParam:dic success:^(XKTradingAreaPrePayModel *model) {
      //  [XKHudView showSuccessMessage:@"下单成功"];
        XKCheckoutCounterViewController *vc = [[XKCheckoutCounterViewController alloc] init];
        vc.orderBody = model.body;
        vc.orderAmount = model.amount.floatValue;
        vc.paymentMethods = model.channelConfigs;
        [self.navigationController pushViewController:vc animated:YES];
//        ws.orderItem = model;
//        [XKPayAlertSheetView showWithResultBlock:^(NSInteger index) {
//            XKPayForMallViewController *pay = [XKPayForMallViewController new];
//            pay.payResult = ^(BOOL success) {
//                if (success) {
//                    [ws requestPayWithGoodsArr:ws.goodsArr andOrderId:ws.orderItem.orderId payChannel:@"ALI_PAY" successBlock:^(id  _Nonnull data) {
//                        XKMallOrderPayResultViewController *result = [XKMallOrderPayResultViewController new];
//                        result.payResult = 1;
//                        result.item = ws.orderItem;
//                        [ws.navigationController pushViewController:result animated:YES];
//                    } failedBlock:^(NSString * _Nonnull reason) {
//                        XKMallOrderPayResultViewController *result = [XKMallOrderPayResultViewController new];
//                         result.payResult = 2;
//                         result.item = ws.orderItem;
//                         [ws.navigationController pushViewController:result animated:YES];
//                    }];
//                } else {
//                    [XKHudView showErrorMessage:@"支付失败"];
//                }
//            };
//            [ws.navigationController pushViewController:pay animated:YES];
//        }];
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];
}
//请求价格
- (void)refreshPrice {
    if (!_addressItem) {
        [XKHudView showErrorMessage:@"请选择收货地址"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (XKMallBuyCarItem *item in self.goodsArr) {
        NSDictionary *dic = @{
                              @"goodsId" : item.goodsId,
                              @"goodsSum"   : @(item.quantity),
                              @"goodsSkuCode" : item.goodsSkuCode
                              };
        [goodsArr addObject:dic];
    };
    NSDictionary *dic = @{
                          @"mallOrderValidateAmountParams" : @{
                                  @"goodsParams" : goodsArr,
                                  @"discountType" : [_orderTicketItem.cardType uppercaseString] ?: @"",
                                  @"userDiscountId" : _orderTicketItem.ID ?: @"",
                                  @"addressId" : _addressItem.ID ?: @"",
                                  }
                          };
    [XKMallBuyCarViewModel countMallBuyCarFeeWithParam:dic success:^(XKMallBuyCarViewModel *model) {
        ws.feeItem = model;
        ws.bottomView.totalPrice = model.goodsAmount / 100;
        [ws.tableView reloadData];
        
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];
    
}

- (void)requestOrderTicket {
    if (!_addressItem) {
        [XKHudView showErrorMessage:@"请选择收货地址"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    NSMutableArray *goodsArr = [NSMutableArray array];
    for (XKMallBuyCarItem *item in self.goodsArr) {
        NSDictionary *dic = @{
                              @"goodsId" : item.goodsId,
                              @"goodsSum"   : @(item.quantity),
                              @"goodsSkuCode" : item.goodsSkuCode
                              };
        [goodsArr addObject:dic];
    };
    //          "discountType":"COUPON",                  @"userDiscountId" :
    NSDictionary *dic = @{
                          @"orderGoods" : goodsArr
                          };
    [XKMallBuyCarViewModel requestMallBuyCarOrderTicketWithParam:dic success:^(NSArray *arr) {
        ws.ticketBottomView.dataArr = arr;
        [ws.ticketBgView show];
    } failed:^(NSString *failedReason) {
        [XKHudView showErrorMessage:failedReason];
    }];
}
#pragma mark textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        _leaveWord = textField.text;
    } else {
        _safeCode =  textField.text;
    }
}
#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section == 0 ? 1 : section == 1 ? _goodsArr.count : _listNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return 60;
    if(indexPath.section == 1)
        return 110;
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if (_addressItem == nil ) {
            XKMallOrderNoAddressCell *cell = [[XKMallOrderNoAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            NSString *addressName = [NSString stringWithFormat:@"%@%@%@ %@",_addressItem.provinceName ?: @"" ,_addressItem.cityName ?: @"",_addressItem.districtName ?: @"",_addressItem.street ?: @""];
           
            XKMallOrderSureAddressCell *cell = [[XKMallOrderSureAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            [cell updateInfoWithAddressName:addressName phone:_addressItem.phone userName:_addressItem.receiver];
            return cell;
        }

    } else if(indexPath.section == 1) {
      
        XKMallOrderDetailGoodInfoCell *cell = [[XKMallOrderDetailGoodInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell bindItem:_goodsArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0) {
            cell.xk_clipType = XKCornerClipTypeTopBoth;
        }
        return cell;
    } else {
        XKOrderInfoTableViewCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"XKOrderInfoTableViewCell" forIndexPath:indexPath];
        inputCell.scanfBlock = ^{
            XKQRCodeScanViewController *vc = [[XKQRCodeScanViewController alloc]init];
            vc.vcType = QRCodeScanVCType_QRScan;
            XKWeakSelf(ws);
            vc.scanResult = ^(NSString *resultString){
                NSMutableDictionary *resultDict = [XKQRCodeResultManager registerQrResult:resultString];
                ws.safeCode = resultDict[@"securityCode"];
                NSIndexPath *index = [NSIndexPath indexPathForRow:4 inSection:2];
                [ws.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                [ws.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:vc animated:true];

        };
        if(indexPath.row == _listNameArr.count - 1) {
            [inputCell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        } else {
            [inputCell restoreFromCorner];
        }
        inputCell.rightTf.delegate = self;
        inputCell.rightTf.tag = indexPath.row + 1000;
        switch (indexPath.row) {
            case 0:
                {
                    [inputCell setupWithLeftLabelText:_listNameArr[indexPath.row] leftLabelFont:nil leftLabelTextColor:nil rightLabelText:nil rightLabelFont:nil rightLabelTextColor:nil rightLabelAligment:0 rightTextfieldEnable:YES rightTextfieldPlaceHolder:@"填写内容已和卖家确认" rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:NO rightImgViewImgName:nil];
                }
                break;
            case 1:
                {
                    NSString *type = @"不需要";
                    if (_ticketItem) {
                        if ([_ticketItem isPersonal]) {
                            type = @"个人";
                        } else {
                            type = @"企业";
                        }
                    }
                    [inputCell setupWithLeftLabelText:_listNameArr[indexPath.row] leftLabelFont:nil leftLabelTextColor:nil rightLabelText:type rightLabelFont:nil rightLabelTextColor:nil rightLabelAligment:NSTextAlignmentRight rightTextfieldEnable:NO rightTextfieldPlaceHolder:nil rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:YES rightImgViewImgName:@"xk_btn_order_grayArrow"];
                }
                break;
            case 2:
                {
                    CGFloat fee;
                    if (_feeItem) {
                       fee  = _feeItem.postAmount / 100.f;
                    } else {
                        fee = 0.00;
                    }
                   
                    [inputCell setupWithLeftLabelText:_listNameArr[indexPath.row] leftLabelFont:nil leftLabelTextColor:nil rightLabelText:@(fee).stringValue rightLabelFont:nil rightLabelTextColor:nil rightLabelAligment:NSTextAlignmentRight rightTextfieldEnable:NO rightTextfieldPlaceHolder:nil rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:NO rightImgViewImgName:nil];
                }
                break;
            case 3:
                {
                    [inputCell setupWithLeftLabelText:_listNameArr[indexPath.row] leftLabelFont:nil leftLabelTextColor:nil rightLabelText:_orderTicketItem.cardName rightLabelFont:nil rightLabelTextColor:nil rightLabelAligment:NSTextAlignmentRight rightTextfieldEnable:NO rightTextfieldPlaceHolder:nil rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:YES rightImgViewImgName:@"xk_btn_order_grayArrow"];
                }
                break;
            case 4:
                {
                    [inputCell setupWithLeftLabelText:_listNameArr[indexPath.row] leftLabelFont:nil leftLabelTextColor:nil rightLabelText:_safeCode rightLabelFont:nil rightLabelTextColor:nil rightLabelAligment:NSTextAlignmentLeft rightTextfieldEnable:NO rightTextfieldPlaceHolder:nil rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:YES rightImgViewImgName:@"xk_ic_login_sweep"];
                }
                break;
            case 5:
                {
                    NSInteger count = _orderTicketItem == nil ? 0 : 1;
                    NSString *des = [NSString stringWithFormat:@"共计%zd件商品 已使用优惠券%zd张",_goodsArr.count,count];
                    [inputCell setupWithLeftLabelText:nil leftLabelFont:nil leftLabelTextColor:nil rightLabelText:des rightLabelFont:XKRegularFont(14) rightLabelTextColor:UIColorFromRGB(0x777777) rightLabelAligment:NSTextAlignmentRight rightTextfieldEnable:NO rightTextfieldPlaceHolder:nil rightTextfieldFont:nil rightTextfieldTextColor:nil rightImgViewEnable:NO rightImgViewImgName:nil];

                }
                break;
                
            default:
                break;
        }
            return inputCell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 :0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKWeakSelf(ws);
    if (indexPath.section == 0) {
        XKMineConfigureRecipientListViewController *address = [XKMineConfigureRecipientListViewController new];
        address.delegate = self;
        [self.navigationController pushViewController:address animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 3) {
        [self requestOrderTicket];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        XKReceiptManageListController * manager = [XKReceiptManageListController new];
        manager.useType = XKReceiptManageListUseTypeSelect;
        manager.chooseBlock = ^(NSArray<XKReceiptInfoModel *> *receipts) {
            ws.ticketItem = receipts.firstObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:2];
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                [ws.navigationController popViewControllerAnimated:YES];
            });

        };
        [self.navigationController pushViewController:manager animated:YES];
    }
}
#pragma mark 选择地址的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath item:(XKMineConfigureRecipientItem *)item {
    _addressItem = item;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self refreshPrice];
}
#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareOrderDetailTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailTopCell"];
        [_tableView registerClass:[XKWelfareOrderWinCell class] forCellReuseIdentifier:@"XKWelfareOrderWinCell"];
        [_tableView registerClass:[XKOrderInfoTableViewCell class] forCellReuseIdentifier:@"XKOrderInfoTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKMallBuyCarCountBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [[XKMallBuyCarCountBottomView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight)];
        _bottomView.totalPrice =  ws.totalPrice / 100;
        _bottomView.payBlock = ^(UIButton *sender) {
            [ws.view endEditing:YES];
            [ws giveOrder:sender];
        
        };
    }
    return _bottomView;
}

- (XKMallBottomTicketView *)ticketBottomView {
    if (!_ticketBottomView) {
        XKWeakSelf(ws);
        _ticketBottomView = [[XKMallBottomTicketView alloc] initWithTicketArr:@[@"VIP八折卡",@"限时购物券20元",@"满200减20"] titleStr:@"可用卡券"];
        _ticketBottomView.choseBlock = ^(XKMallBuyCarItem *item) {
            [ws.ticketBgView dismiss];
            ws.orderTicketItem = item;
            NSIndexPath *row = [NSIndexPath indexPathForRow:3 inSection:2];
            [ws.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
            [ws refreshPrice];
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
