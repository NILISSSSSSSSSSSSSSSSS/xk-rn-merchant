//
//  XKCheckoutCounterViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCheckoutCounterViewController.h"
#import "XKCheckoutCounterTableViewHeaderView.h"
#import "XKCheckoutCounterDiscountHeader.h"
#import "XKCheckoutCounterDiscountFooter.h"
#import "XKCheckoutCounterDiscountAmountTableViewCell.h"
#import "XKCheckoutCounterPaymentMethodTableViewCell.h"
#import "XKCheckoutCounterTableViewFooterView.h"
#import "XKTradingAreaPrePayModel.h"
#import "XKPayPasswordInputViewController.h"
#import "XKMineAccountManageViewController.h"
#import "XKVerifyPhoneNumberViewController.h"
#import "XKChangePhonenumViewController.h"
#import "XKPayCenter.h"
#import "XKCommonWebViewController.h"
#import "XKDataBase.h"

@interface XKCheckoutCounterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, XKPayPasswordInputViewControllerDelegate>
// 表格视图
@property (nonatomic, strong) UITableView *tableView;
// 选择的支付方式序列
@property (nonatomic, assign) NSUInteger selectedIndex;
// 是否使用特殊支付方式
@property (nonatomic, assign) BOOL useSpecialPaymentMethod;
// 填写的特殊支付方式金额
@property (nonatomic, assign) CGFloat specialPaymentMethodAmount;


// 特殊支付方式（抵扣券等）
@property (nonatomic, strong) NSMutableArray <ChannelConfigsItem *>*specialPaymentMethods;
// 普通支付方式（支付宝支付、微信支付、消费券等）
@property (nonatomic, strong) NSMutableArray <ChannelConfigsItem *>*normalPaymentMethods;

@end

@implementation XKCheckoutCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"晓可收银台" WithColor:HEX_RGB(0xffffff)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = XKSeparatorLineColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    XKCheckoutCounterTableViewHeaderView *header = [[XKCheckoutCounterTableViewHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 84.0)];
    header.amount = (CGFloat)self.orderAmount / 100.0;
    self.tableView.tableHeaderView = header;
    __weak typeof(self) weskSelf = self;
    XKCheckoutCounterTableViewFooterView *footer = [[XKCheckoutCounterTableViewFooterView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 84.0)];
    footer.payBtnBlock = ^{
        if (!self.normalPaymentMethods.count) {
            return ;
        }
        if ((weskSelf.useSpecialPaymentMethod && weskSelf.specialPaymentMethods.firstObject.isInner) || (weskSelf.normalPaymentMethods.count && weskSelf.normalPaymentMethods[weskSelf.selectedIndex].isInner)) {
            // 使用了本平台的特殊支付方式或者本平台的普通支付方式
            XKPayPasswordInputViewController *vc = [XKPayPasswordInputViewController showPayPasswordInputViewController:weskSelf];
            vc.delegate = weskSelf;
        } else {
            [weskSelf postUnifiedPaymentWithVerificationType:-1 key:nil];
        }
    };
    self.tableView.tableFooterView = footer;
    [self.tableView registerClass:[XKCheckoutCounterDiscountAmountTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKCheckoutCounterDiscountAmountTableViewCell class])];
    [self.tableView registerClass:[XKCheckoutCounterPaymentMethodTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKCheckoutCounterPaymentMethodTableViewCell class])];
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
    
}

#pragma mark - POST

/**
 统一支付接口

 @param verificationType 使用特殊支付方式时的校验方式 支付密码/指纹/脸部识别
 @param key 支付密码/TouchID key/FaceID key
 */
- (void)postUnifiedPaymentWithVerificationType:(XKPayPasswordInputViewControllerVerificationType)verificationType key:(NSString *)key {
    
    // 最终的支付方式，用于支付后回调判断
    NSString *paymentMethodStr;
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    // 提交订单后生成的body字符串
    [para setObject:self.orderBody forKey:@"body"];
    
    // 使用的特殊支付方式金额大于0
    if ([self getRealDiscountAmount] > 0.0) {
        // 使用的特殊支付方式类型
        [para setObject:self.useSpecialPaymentMethod ? self.specialPaymentMethods.firstObject.payChannel : @"" forKey:@"prePayChannel"];
        // 使用的特殊支付方式金额
        [para setObject:@([self getRealDiscountAmount] * 100.0) forKey:@"prePayAmount"];
    }
    
    if ([self getLeftAmount] == 0.0) {
        // 剩余支付金额为0 即特殊支付方式金额足以支付订单金额
        paymentMethodStr = self.specialPaymentMethods.firstObject.payChannel;
    } else {
        // 特殊支付方式金额不足以支付订单金额
        paymentMethodStr = self.normalPaymentMethods[self.selectedIndex].payChannel;
        // 普通支付方式
        [para setObject:self.normalPaymentMethods[self.selectedIndex].payChannel forKey:@"payChannel"];
        // 普通支付方式支付金额
        [para setObject:@((self.orderAmount / 100.0 - [self getRealDiscountAmount]) * 100.0) forKey:@"payAmount"];
    }
    
    // 支付时 使用本平台余额或者卡券时，需要authType、authValue参数
    if (verificationType == XKPayPasswordInputViewControllerVerificationTypeFaceId) {
        [para setObject:@"faceId" forKey:@"authType"];
        [para setObject:key && key.length ? key : @"" forKey:@"authValue"];
    } else if (verificationType == XKPayPasswordInputViewControllerVerificationTypeTouchId) {
        [para setObject:@"fingerId" forKey:@"authType"];
        [para setObject:[[XKDataBase instance] select:key && key.length ? key : @"" key:[XKUserInfo getCurrentUserId]] forKey:@"authValue"];
    } else if (verificationType == XKPayPasswordInputViewControllerVerificationTypePassword) {
        [para setObject:@"password" forKey:@"authType"];
        [para setObject:key && key.length ? key : @"" forKey:@"authValue"];
    }
    [XKHudView showLoadingTo:self.containView animated:YES];
    
    
    
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig unifiedPaymentUrl] /*@"http://192.168.2.217:8087/api/trade/ua/uniPayment/1.0"*/  timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView];
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            XKCheckoutCounterPaymentMethodType type = [[self getPaymentDataDicWithPaymentMethod:paymentMethodStr][@"type"] integerValue];
            
            if ([dict[@"tradePaymentStatus"] isEqualToString:@"success"]) {
                // 支付成功
                [XKHudView showSuccessMessage:@"支付成功"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                    [self.delegate handleCheckoutCounterVCResult:self isSucceed:YES paymentMethod:type];
                }
            } else if ([dict[@"tradePaymentStatus"] isEqualToString:@"fail"]) {
                // 支付失败
                [XKHudView showErrorMessage:@"支付失败"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                    [self.delegate handleCheckoutCounterVCResult:self isSucceed:NO paymentMethod:type];
                }
            } else if ([dict[@"tradePaymentStatus"] isEqualToString:@"keepOn"]) {
                // 保持继续支付(第三方支付渠道)
                if ([dict[@"next"][@"payChannel"] isEqualToString:@"alipay"]) {
                    // 支付宝支付
                    [[XKPayCenter sharedPayCenter] AliPayWithOrderString:dict[@"next"][@"channelPrams"][@"sign"] succeedBlock:^{
                        [XKHudView showSuccessMessage:@"支付成功"];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                            [self.delegate handleCheckoutCounterVCResult:self isSucceed:YES paymentMethod:type];
                        }
                    } failedBlock:^(NSString *reason) {
                        [XKHudView showErrorMessage:@"支付失败"];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                            [self.delegate handleCheckoutCounterVCResult:self isSucceed:NO paymentMethod:type];
                        }
                    }];
                } else if ([dict[@"next"][@"payChannel"] isEqualToString:@"tfAlipay"]) {
                    // 天府银行 支付宝支付
                    XKCommonWebViewController *vc = [[XKCommonWebViewController alloc] init];
                    vc.htmlStr = dict[@"next"][@"channelPrams"][@"aliForm"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else if ([dict[@"next"][@"payChannel"] isEqualToString:@"wxpay"]) {
                    NSString *openId = dict[@"next"][@"channelPrams"][@"appId"];
                    NSString *partnerId = dict[@"next"][@"channelPrams"][@"partnerId"];
                    NSString *prepayId = dict[@"next"][@"channelPrams"][@"prepayId"];
                    NSString *nonceStr = dict[@"next"][@"channelPrams"][@"nonceStr"];
                    NSInteger timeStamp = [dict[@"next"][@"channelPrams"][@"timeStamp"] integerValue];
                    NSString *package = dict[@"next"][@"channelPrams"][@"attach"];
                    NSString *sign = dict[@"next"][@"channelPrams"][@"sign"];
                    
                    // 微信支付
                    [[XKPayCenter sharedPayCenter] WeChatPayWithOpenId:openId partnerId:partnerId prepayId:prepayId nonceStr:nonceStr timeStamp:timeStamp package:package sign:sign succeedBlock:^{
                        [XKHudView showSuccessMessage:@"支付成功"];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                            [self.delegate handleCheckoutCounterVCResult:self isSucceed:YES paymentMethod:type];
                        }
                    } failedBlock:^(NSString *reason) {
                        [XKHudView showErrorMessage:@"支付失败"];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(handleCheckoutCounterVCResult:isSucceed:paymentMethod:)]) {
                            [self.delegate handleCheckoutCounterVCResult:self isSucceed:NO paymentMethod:type];
                        }
                    }];
                } else if ([dict[@"next"][@"payChannel"] isEqualToString:@"tfWxpay"]) {
                    // 天府银行 微信支付
                    XKCommonWebViewController *vc = [[XKCommonWebViewController alloc] init];
                    vc.urlStr = dict[@"next"][@"channelPrams"][@"payUrl"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView];
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark - Events

// 获取实际最大可用折扣金额 即输入框内可以输入的最大数字 单位为元
- (CGFloat)getRealMaxDiscountAmount {
    if (self.specialPaymentMethods.count) {
        CGFloat discountRatio = 1.0;
        if (self.specialPaymentMethods.firstObject.amount.doubleValue / 100.0 * discountRatio >= self.orderAmount / 100.0) {
            // 特殊支付方式最大折扣金额 * 特殊支付方式比率大于等于订单金额，则实际最大折扣金额为订单金额
            return self.orderAmount / 100.0;
        } else {
            // 特殊支付方式最大折扣金额 * 特殊支付方式比率小于订单金额，则实际最大折扣金额为特殊支付方式最大折扣金额
            return self.specialPaymentMethods.firstObject.amount.doubleValue / 100.0;
        }
    } else {
        return 0.0;
    }
}

// 获取实际特殊支付方式金额 单位为元
- (CGFloat)getRealDiscountAmount {
    if (self.useSpecialPaymentMethod) {
        // 使用了特殊支付方式
        CGFloat discountRatio = 1.0;
        return self.specialPaymentMethodAmount * discountRatio;
    } else {
        // 未使用特殊支付方式
        return 0.0;
    }
}
// 获取剩余支付金额 单位为元
- (CGFloat)getLeftAmount {
    return self.orderAmount / 100.0 - [self getRealDiscountAmount];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.specialPaymentMethodAmount = 0.0;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.doubleValue >= [self getRealMaxDiscountAmount]) {
        // 填写的金额大于等于实际最大可用折扣金额
        self.specialPaymentMethodAmount = [self getRealMaxDiscountAmount];
    } else {
        self.specialPaymentMethodAmount = textField.text.doubleValue;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.specialPaymentMethods.count && self.normalPaymentMethods.count) {
        return 2;
    } else if (self.specialPaymentMethods.count || self.normalPaymentMethods.count) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.specialPaymentMethods.count) {
            return 3;
        } else {
            return self.normalPaymentMethods.count;
        }
    } else if (section == 1) {
        return self.normalPaymentMethods.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.specialPaymentMethods.count) {
        // 特殊支付方式CELL
        XKCheckoutCounterDiscountAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKCheckoutCounterDiscountAmountTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
            // 最后一行
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType = XKCornerClipTypeBottomBoth;
            cell.containerView.xk_openClip = YES;
        }  else {
            // 非最后一行
            cell.containerView.xk_radius = 0.0;
            cell.containerView.xk_clipType = XKCornerClipTypeNone;
            cell.containerView.xk_openClip = YES;
        }
        if (indexPath.row == 0) {
            // 输入的特殊支付方式金额
            cell.discountAmountTF.enabled = YES;
            cell.discountAmountTF.delegate = self;
            cell.discountAmountTF.font = XKRegularFont(14.0);
            cell.discountAmountTF.text = [NSString stringWithFormat:@"%.2f", self.specialPaymentMethodAmount];
        } else if (indexPath.row == 1) {
            // 抵扣金额
            cell.discountAmountTF.enabled = NO;
            cell.discountAmountTF.delegate = nil;
            cell.discountAmountTF.font = XKRegularFont(14.0);
            cell.discountAmountTF.text = [NSString stringWithFormat:@"-¥%.2f", [self getRealDiscountAmount]];
        } else {
            // 剩余支付
            cell.discountAmountTF.enabled = NO;
            cell.discountAmountTF.delegate = nil;
            cell.discountAmountTF.font = XKMediumFont(17.0);
            cell.discountAmountTF.text = [NSString stringWithFormat:@"¥%.2f", [self getLeftAmount]];
        }
        return cell;
    } else {
        // 普通支付方式CELL
        XKCheckoutCounterPaymentMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKCheckoutCounterPaymentMethodTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.normalPaymentMethods.count == 1) {
            // 只有一行
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType = XKCornerClipTypeAllCorners;
            cell.containerView.xk_openClip = YES;
        } else if (indexPath.row == 0) {
            // 第一行
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType = XKCornerClipTypeTopBoth;
            cell.containerView.xk_openClip = YES;
        } else if (indexPath.row == self.normalPaymentMethods.count - 1) {
            // 最后一行
            cell.containerView.xk_radius = 8.0;
            cell.containerView.xk_clipType = XKCornerClipTypeBottomBoth;
            cell.containerView.xk_openClip = YES;
        } else {
            // 中间行
            cell.containerView.xk_radius = 0.0;
            cell.containerView.xk_clipType = XKCornerClipTypeNone;
            cell.containerView.xk_openClip = YES;
        }
        // 获取到支付方式显示数据
        NSDictionary *dataDic = [self getPaymentDataDicWithPaymentMethod:self.normalPaymentMethods[indexPath.row].payChannel];
        if (dataDic[@"img"] && [dataDic[@"img"] length]) {
            cell.imgView.image = IMG_NAME(dataDic[@"img"]);
        } else {
            cell.imgView.image = kDefaultPlaceHolderImg;
        }
        
        if (![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"alipay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"wxpay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfAlipay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfWxpay"] &&
            self.normalPaymentMethods[indexPath.row].isInner) {
            CGFloat discountRatio = 1.0;
            // 非微信支付、支付宝支付 内部支付方式
            cell.titleLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
                confer.text(dataDic[@"title"]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
                if (self.orderAmount / 100.0 - [self getRealDiscountAmount] > self.normalPaymentMethods[indexPath.row].amount.doubleValue / 100.0 * discountRatio) {
                    // 余额不足
                    confer.text([NSString stringWithFormat:@"（余额：%.2f)", self.self.normalPaymentMethods[indexPath.row].amount.doubleValue / 100.0]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0xCCCCCC));
                } else {
                    // 余额充足
                    confer.text([NSString stringWithFormat:@"（余额：%.2f)", self.self.normalPaymentMethods[indexPath.row].amount.doubleValue / 100.0]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x777777));
                }
            }];
            cell.subTitleLab.text = [NSString stringWithFormat:@"1%@=¥%.2f", dataDic[@"title"], discountRatio];
            
        } else {
            cell.titleLab.text = dataDic[@"title"];
            cell.subTitleLab.text = [NSString stringWithFormat:@"%@安全支付", dataDic[@"title"]];
        }
        if ([self getLeftAmount] > 0.0) {
            if ((![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"alipay"] &&
                 ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"wxpay"] &&
                 ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfAlipay"] &&
                 ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfWxpay"] &&
                 self.normalPaymentMethods[indexPath.row].isInner)) {
                CGFloat discountRatio = 1.0;
                if (self.normalPaymentMethods[indexPath.row].amount.doubleValue / 100.0 * discountRatio >= [self getLeftAmount]) {
                    // 余额充足
                    cell.chooseBtn.enabled = YES;
                    cell.chooseBtn.selected = indexPath.row == self.selectedIndex;
                    
                } else {
                    // 余额不足
                    cell.chooseBtn.enabled = NO;
                    cell.chooseBtn.selected = NO;
                }
            } else {
                cell.chooseBtn.enabled = YES;
                cell.chooseBtn.selected = indexPath.row == self.selectedIndex;
            }
        } else {
            cell.chooseBtn.enabled = NO;
            cell.chooseBtn.selected = NO;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.specialPaymentMethods.count) {
        return 60.0;
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.specialPaymentMethods.count) {
        CGFloat discountRatio = 1.0;
        NSDictionary *dataDic = [self getPaymentDataDicWithPaymentMethod:self.specialPaymentMethods[section].payChannel];
        XKCheckoutCounterDiscountHeader *header = [[XKCheckoutCounterDiscountHeader alloc] init];
        header.titleLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(dataDic[@"title"]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
            confer.text([NSString stringWithFormat:@"（余额：%.2f)", self.specialPaymentMethods[section].amount.doubleValue / 100.0]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x777777));
        }];
        header.ratioLab.text = [NSString stringWithFormat:@"1%@=¥%.2f", dataDic[@"title"], discountRatio];
        header.switchControl.on = self.useSpecialPaymentMethod;
        header.switchBlock = ^(BOOL isOn) {
            self.useSpecialPaymentMethod = isOn;
            if (!self.useSpecialPaymentMethod && self.selectedIndex == -1) {
                self.selectedIndex = 0;
            }
            [self.tableView reloadData];
        };
        return header;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.0;
    } else {
        return 60.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && self.specialPaymentMethods.count) {
        return 10.0;
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    } else {
        if (![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"alipay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"wxpay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfAlipay"] &&
            ![self.normalPaymentMethods[indexPath.row].payChannel isEqualToString:@"tfWxpay"] &&
            self.normalPaymentMethods[indexPath.row].isInner) {
            // 内部支付方式
            
            // 特殊支付方式兑换比例
            CGFloat discountRatio = 1.0;
            if (self.orderAmount / 100.0 - [self getRealDiscountAmount] > self.normalPaymentMethods[indexPath.row].amount.doubleValue / 100.0 * discountRatio) {
                // 余额不足
                return;
            }
        }
        self.selectedIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

#pragma mark - XKPayPasswordInputViewControllerDelegate

- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView verificationType:(XKPayPasswordInputViewControllerVerificationType)type isPass:(BOOL)isPass severCheckKey:(NSString *)key inputPassword:(NSString *)password {
    if (isPass) {
        if (type == XKPayPasswordInputViewControllerVerificationTypePassword) {
            [self postUnifiedPaymentWithVerificationType:type key:password];
        } else {
            [self postUnifiedPaymentWithVerificationType:type key:key];
        }
    }
}

- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView error:(XKPayPasswordInputViewControllerError)error {
    if (error == XKPayPasswordInputViewControllerErrorNoPayPassword) {
        XKMineAccountManageViewController *vc = [[XKMineAccountManageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (error == XKPayPasswordInputViewControllerErrorForgotPayPassword) {
        NSString *phoneNum = [XKUserInfo currentUser].phone;
        XKVerifyPhoneNumberViewController *verifyPhoneNumberViewController = [XKVerifyPhoneNumberViewController new];
        verifyPhoneNumberViewController.state = XKVerifyPhoneNumberViewControllerStateChangePayPassword;
        verifyPhoneNumberViewController.phoneNum = phoneNum;
        [self.navigationController pushViewController:verifyPhoneNumberViewController animated:YES];
    } else if (error == XKPayPasswordInputViewControllerErrorForgotPayPasswordNoPhoneNumber) {
        XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
        changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
        [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
    }
}

#pragma mark - getter setter

- (NSDictionary *)getPaymentDataDicWithPaymentMethod:(NSString *)paymentMethod {
    if ([paymentMethod isEqualToString:@"xkq"]) {
        return @{
                 @"img" : @"",
                 @"title" : @"账户余额",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeAccountBalance),
                 };
    } else if ([paymentMethod isEqualToString:@"xkb"]) {
        return @{
                 @"img" : @"xk_iocn_coinBackimg",
                 @"title" : @"晓可币",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeXKCoin),
                 };
    } else if ([paymentMethod isEqualToString:@"swq"]) {
        return @{
                 @"img" : @"",
                 @"title" : @"实物券",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypePhysicalCoupon),
                 };
    } else if ([paymentMethod isEqualToString:@"xfq"]) {
        return @{
                 @"img" : @"xk_btn_order_pay_consumptionCoupon",
                 @"title" : @"消费券",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeConsumptionCoupon),
                 };
    } else if ([paymentMethod isEqualToString:@"xfqs"]) {
        return @{
                 @"img" : @"",
                 @"title" : @"店铺消费券",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeShopConsumptionCoupon),
                 };
    } else if ([paymentMethod isEqualToString:@"alipay"]) {
        return @{
                 @"img" : @"xk_btn_order_pay_alipay",
                 @"title" : @"支付宝",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeAlipay),
                 };
    } else if ([paymentMethod isEqualToString:@"wxpay"]) {
        return @{
                 @"img" : @"xk_btn_order_pay_wechat",
                 @"title" : @"微信",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeWechat),
                 };
    } else if ([paymentMethod isEqualToString:@"tfAlipay"]) {
        return @{
                 @"img" : @"xk_btn_order_pay_alipay",
                 @"title" : @"支付宝",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeTianFuAlipay),
                 };
    } else if ([paymentMethod isEqualToString:@"tfWxpay"]) {
        return @{
                 @"img" : @"xk_btn_order_pay_wechat",
                 @"title" : @"微信",
                 @"type" : @(XKCheckoutCounterPaymentMethodTypeTianFuWechat),
                 };
    } else {
        return [NSDictionary dictionary];
    }
}

- (void)setPaymentMethods:(NSArray<ChannelConfigsItem *> *)paymentMethods {
    _paymentMethods = paymentMethods;
    for (ChannelConfigsItem *paymentMethod in _paymentMethods) {
        if (paymentMethod.isPreChannel) {
            [self.specialPaymentMethods addObject:paymentMethod];
        } else {
            [self.normalPaymentMethods addObject:paymentMethod];
        }
    }
    if (self.specialPaymentMethods.count) {
        // 有特殊支付方式 默认使用特殊支付方式且使用金额为实际最大折扣金额
        self.useSpecialPaymentMethod = YES;
        self.specialPaymentMethodAmount = [self getRealMaxDiscountAmount];
    }
    if (self.normalPaymentMethods.count) {
        if ([self getLeftAmount] == 0.0) {
            self.selectedIndex = -1;
        } else {
            self.selectedIndex = 0;
        }
    }
    [self.tableView reloadData];
}

- (NSMutableArray<ChannelConfigsItem *> *)specialPaymentMethods {
    if (!_specialPaymentMethods) {
        _specialPaymentMethods = [NSMutableArray array];
    }
    return _specialPaymentMethods;
}

- (NSMutableArray<ChannelConfigsItem *> *)normalPaymentMethods {
    if (!_normalPaymentMethods) {
        _normalPaymentMethods = [NSMutableArray array];
    }
    return _normalPaymentMethods;
}

@end

