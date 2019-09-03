//
//  XKSendRedPacketViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSendRedPacketViewController.h"
#import "XKMineRedEnvelopeRecordsViewController.h"
//#import "XKCoinRechaargeViewController.h"
#import "XKSendMineCouponViewController.h"
#import "XKMenuView.h"
#import "XKCommonSheetView.h"
#import "XKChatGiveGiftView.h"
#import "XKPayPasswordInputViewController.h"
#import "XKMineCouponPackageCardModel.h"
#import "XKMineCouponPackageCouponModel.h"
#import "XKMineAccountManageViewController.h"
#import "XKVerifyPhoneNumberViewController.h"
#import "XKChangePhonenumViewController.h"

@interface XKSendRedPacketViewController () <XKPayPasswordInputViewControllerDelegate, XKSendMineCouponViewControllerDelegate>

@property (nonatomic, strong) UIImageView  *bgImgView;

@property (nonatomic, strong) UIButton  *cancelBtn;

@property (nonatomic, strong) UIButton  *listBtn;

@property (nonatomic, strong) UIView  *moneyView;

@property (nonatomic, strong) UILabel  *moneyViewLeftLabel;

@property (nonatomic, strong) UITextField  *moneyViewInputTf;

@property (nonatomic, strong) UIView *moneyTypeView;

@property (nonatomic, strong) UILabel *moneyTypeLabel;

@property (nonatomic, strong) UIImageView *moneyTypeArrowImgView;

@property (nonatomic, strong) UIView  *countView;

@property (nonatomic, strong) UILabel  *countViewLeftLabel;

@property (nonatomic, strong) UILabel  *countViewRightLabel;

@property (nonatomic, strong) UITextField  *countViewInputTf;

@property (nonatomic, strong) UILabel  *extraLabel;

@property (nonatomic, strong) UIView *rechargeView;

@property (nonatomic, strong) UILabel *rechargeLabel;

@property (nonatomic, strong) UIImageView *rechargeArrowImgView;

@property (nonatomic, strong) UIButton  *priceBtn;

@property (nonatomic, strong) UIButton  *sureBtn;

@property (nonatomic, strong) UIButton  *sendTicketBtn;

@property (nonatomic, strong) UIButton  *sendDiscountBtn;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) XKIMGiftModel *selectedGift;

@property (nonatomic, strong) NSArray *selectedCardCoupons;

@end

@implementation XKSendRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)handleData {
    [super handleData];
    self.selectedIndex = 0;
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.listBtn];
    [self.view addSubview:self.moneyView];
    [self.moneyView addSubview:self.moneyTypeView];
    [self.moneyTypeView addSubview:self.moneyTypeLabel];
    [self.moneyTypeView addSubview:self.moneyTypeArrowImgView];
    [self.moneyView addSubview:self.moneyViewLeftLabel];
    [self.moneyView addSubview:self.moneyViewInputTf];
    [self.view addSubview:self.countView];
    [self.countView addSubview:self.countViewLeftLabel];
    [self.countView addSubview:self.countViewRightLabel];
    [self.countView addSubview:self.countViewInputTf];
    [self.view addSubview:self.extraLabel];
    [self.view addSubview:self.rechargeView];
    [self.view addSubview:self.rechargeLabel];
    [self.view addSubview:self.rechargeArrowImgView];
    [self.view addSubview:self.priceBtn];
    [self.view addSubview:self.sureBtn];
//    [self.view addSubview:self.sendTicketBtn];
//    [self.view addSubview:self.sendDiscountBtn];
    

    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cancelBtn.mas_bottom).offset(160 * SCREEN_WIDTH / 375);
        make.height.mas_equalTo(45);
    }];
    
    [self.moneyViewLeftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moneyViewLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyView.mas_left).offset(10);
        make.centerY.equalTo(self.moneyView.mas_centerY);
    }];
    
    [self.moneyTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyView.mas_right).offset(-10);
        make.top.bottom.mas_equalTo(self.moneyView);
    }];
    
    [self.moneyTypeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.moneyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.moneyTypeView);
    }];
    
    [self.moneyTypeArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moneyTypeView);
        make.left.mas_equalTo(self.moneyTypeLabel.mas_right);
        make.size.mas_equalTo(self.moneyTypeArrowImgView.image.size);
        make.trailing.mas_equalTo(self.moneyTypeView);
    }];
    
    [self.moneyViewInputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyTypeView.mas_left).offset(-5);
        make.centerY.equalTo(self.moneyView.mas_centerY);
        make.left.equalTo(self.moneyViewLeftLabel.mas_right).offset(10);
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.moneyView.mas_bottom).offset(20.0);
        make.height.mas_equalTo(45.0);
    }];
    
    [self.countViewLeftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.countViewLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countView.mas_left).offset(10);
        make.centerY.equalTo(self.countView.mas_centerY);
    }];
    
    [self.countViewRightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.countViewRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countView.mas_right).offset(-10);
        make.centerY.equalTo(self.countView.mas_centerY);
        make.height.mas_equalTo(45.0);
    }];
    
    [self.countViewInputTf setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.countViewInputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countViewRightLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.countView.mas_centerY);
        make.left.equalTo(self.countViewLeftLabel.mas_right).offset(10);
    }];
    
    [self.extraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countView.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.extraLabel);
    }];
    
    [self.rechargeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.rechargeView);
    }];
    
    [self.rechargeArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rechargeView);
        make.left.mas_equalTo(self.rechargeLabel.mas_right).offset(5.0);
        make.size.mas_equalTo(self.rechargeArrowImgView.image.size);
        make.trailing.mas_equalTo(self.rechargeView);
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countView.mas_bottom).offset(80 * SCREEN_WIDTH / 375 );
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.priceBtn.mas_bottom).offset(30 * SCREEN_WIDTH / 375);
    }];
    
//    [self.sendTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(40 * SCREEN_WIDTH / 375);
//        make.bottom.equalTo(self.view.mas_bottom).offset(- 50 * SCREEN_WIDTH / 375 );
//        make.size.mas_equalTo(CGSizeMake(120 * SCREEN_WIDTH / 375, 40));
//    }];
//
//    [self.sendDiscountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(- 40 * SCREEN_WIDTH / 375);
//        make.bottom.equalTo(self.view.mas_bottom).offset(- 50 * SCREEN_WIDTH / 375 );
//        make.size.mas_equalTo(CGSizeMake(120 * SCREEN_WIDTH / 375, 40));
//    }];
    
}

- (void)cancelBtnClick:(UIButton *)sender {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)moneyTypeViewTapAction:(UIGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [UIImage imageNamed:@""];
    XKMenuView *menuView = [XKMenuView menuWithTitles:@[@"晓可币", @"礼物", @"卡券"] images:nil width:60 relyonView:sender.view clickBlock:^(NSInteger index, NSString *text) {
        switch (index) {
            case 0:
            {
                self.selectedIndex = index;
                self.moneyTypeLabel.text = text;
                self.extraLabel.hidden = NO;
                self.rechargeView.hidden = NO;
                self.priceBtn.hidden = NO;
            }
                break;
            case 1:
            {
                // 请求礼物列表并显示
                [XKHudView showLoadingTo:self.view animated:YES];
                NSMutableDictionary *para = [NSMutableDictionary dictionary];
                [para setObject:@(1) forKey:@"page"];
                [para setObject:@(100) forKey:@"limit"];
                [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig chatGiftListUrl] timeoutInterval:5.0 parameters:para success:^(id responseObject) {
                    [XKHudView hideHUDForView:self.view animated:YES];
                    if (responseObject) {
                        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        NSArray <XKIMGiftModel *>*array = [NSArray yy_modelArrayWithClass:[XKIMGiftModel class] json:dict[@"data"]];
                        if (array.count && self) {
                            XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                            sheetView.backgroundColor = [UIColor clearColor];
                            
                            XKChatGiveGiftView *giftView = [[XKChatGiveGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250.0 * ScreenScale + kBottomSafeHeight) gifts:array type:XKChatGiveGiftViewTypeRedEnvelope];
                            giftView.cellSelectedBlock = ^(XKIMGiftModel *gift) {
                                // 选择礼物后，更改界面显示
                                [sheetView dismiss];
                                self.selectedIndex = index;
                                self.selectedGift = gift;
                                self.moneyTypeLabel.text = text;
                                self.extraLabel.hidden = NO;
                                self.rechargeView.hidden = NO;
                                self.priceBtn.hidden = NO;
                            };
                            sheetView.contentView = giftView;
                            [sheetView addSubview:giftView];
                            [sheetView showWithNoShield];
                            
                            UIView *tempView = [[UIView alloc] init];
                            [sheetView insertSubview:tempView belowSubview:giftView];
                            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.mas_equalTo(sheetView);
                            }];
                            [tempView bk_whenTapped:^{
                                [sheetView dismiss];
                            }];
                        }
                    }
                } failure:^(XKHttpErrror *error) {
                    [XKHudView hideHUDForView:self.view animated:YES];
                    [XKHudView showErrorMessage:@"获取礼物列表失败"];
                }];
            }
                break;
            case 2:
            {
                XKSendMineCouponViewController *sendMineCouponViewController = [XKSendMineCouponViewController new];
                sendMineCouponViewController.delegate = self;
                [self.navigationController pushViewController:sendMineCouponViewController animated:YES];
            }
                break;
                
            default:
                break;
        };
        [self.moneyTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moneyView.mas_right).offset(-10);
            make.top.bottom.mas_equalTo(self.moneyView);
        }];
        
        [self.moneyTypeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.moneyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.mas_equalTo(self.moneyTypeView);
        }];
        
        [self.moneyTypeArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.moneyTypeView);
            make.left.mas_equalTo(self.moneyTypeLabel.mas_right);
            make.size.mas_equalTo(self.moneyTypeArrowImgView.image.size);
            make.trailing.mas_equalTo(self.moneyTypeView);
        }];
    }];
    menuView.textFont = XKRegularFont(12);
    menuView.textColor = UIColorFromRGB(0x222222);
    [menuView show];
}

- (void)sureBtnClick:(UIButton *)sender {
    if (!self.moneyViewInputTf.hasText || [self.moneyViewInputTf.text integerValue] < 1) {
        [XKHudView showErrorMessage:@"请输入金额"];
        return;
    }
    if (!self.countViewInputTf.hasText || [self.countViewInputTf.text integerValue] < 1) {
        [XKHudView showErrorMessage:@"请输入数量"];
        return;
    }
    XKPayPasswordInputViewController *vc = [XKPayPasswordInputViewController showPayPasswordInputViewController:self];
    vc.delegate = self;
}

- (void)listBtnClick:(UIButton *)sender {
    XKMineRedEnvelopeRecordsViewController *vc = [[XKMineRedEnvelopeRecordsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rechargeViewTapAction:(UIGestureRecognizer *)sender {
//    XKCoinRechaargeViewController *vc = [[XKCoinRechaargeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendTicketBtnClick:(UIButton *)sender {
    XKSendMineCouponViewController *sendMineCouponViewController = [XKSendMineCouponViewController new];
    [self.navigationController pushViewController:sendMineCouponViewController animated:YES];
}

- (void)sendDiscountBtnClick:(UIButton *)sender {
    XKSendMineCouponViewController *sendMineCouponViewController = [XKSendMineCouponViewController new];
    [self.navigationController pushViewController:sendMineCouponViewController animated:YES];
}

#pragma mark - POST

#pragma mark - XKPayPasswordInputViewControllerDelegate

- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView verificationType:(XKPayPasswordInputViewControllerVerificationType)type isPass:(BOOL)isPass severCheckKey:(NSString *)key inputPassword:(NSString *)password {
    if (isPass) {
        [self cancelBtnClick:self.cancelBtn];
//        if (self.sendBlock) {
//            self.sendBlock(self.selectedIndex, self.selectedGift);
//        }
    }
}

- (void)payPasswordView:(XKPayPasswordInputViewController *)payPasswordView error:(XKPayPasswordInputViewControllerError)error {
    if (error == XKPayPasswordInputViewControllerErrorNoPayPassword) {
        XKMineAccountManageViewController *vc = [[XKMineAccountManageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (error == XKPayPasswordInputViewControllerErrorForgotPayPassword) {
        XKVerifyPhoneNumberViewController *vc = [[XKVerifyPhoneNumberViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (error == XKPayPasswordInputViewControllerErrorForgotPayPasswordNoPhoneNumber) {
        XKChangePhonenumViewController *vc = [[XKChangePhonenumViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - XKSendMineCouponViewControllerDelegate

- (void)sendMineCouponViewController:(XKSendMineCouponViewController *)viewController selectedArray:(NSArray *)selectedArray {
    self.selectedIndex = 2;
    self.moneyViewInputTf.text = [NSString stringWithFormat:@"%tu", selectedArray.count];
    self.moneyTypeLabel.text = @"卡券";
    self.extraLabel.hidden = YES;
    self.rechargeView.hidden = YES;
    self.priceBtn.hidden = YES;
}

#pragma mark lazy
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = [UIImage imageNamed:@"xk_bg_IM_function_redBacket"];
    }
    return _bgImgView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(20), 40, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0xFFCC90) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = XKRegularFont(16);
        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 70, kIphoneXNavi(20), 70, 40)];
        [_listBtn setTitle:@"红包明细" forState:UIControlStateNormal];
        [_listBtn setTitleColor:UIColorFromRGB(0xFFCC90) forState:UIControlStateNormal];
        _listBtn.titleLabel.font = XKRegularFont(16);
        [_listBtn setBackgroundColor:[UIColor clearColor]];
        _listBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

- (UIView *)moneyView {
    if (!_moneyView) {
        _moneyView = [UIView new];
        _moneyView.backgroundColor = [UIColor whiteColor];
    }
    return _moneyView;
}

- (UILabel *)moneyViewLeftLabel {
    if (!_moneyViewLeftLabel) {
        _moneyViewLeftLabel = [UILabel new];
        _moneyViewLeftLabel.font = XKRegularFont(16);
        _moneyViewLeftLabel.textColor = UIColorFromRGB(0x222222);
        _moneyViewLeftLabel.text = @"金额";
    }
    return _moneyViewLeftLabel;
}

- (UITextField *)moneyViewInputTf {
    if (!_moneyViewInputTf) {
        _moneyViewInputTf = [UITextField new];
        _moneyViewInputTf.font = XKRegularFont(16);
        _moneyViewInputTf.keyboardType = UIKeyboardTypeNumberPad;
        _moneyViewInputTf.textAlignment = NSTextAlignmentRight;
        _moneyViewInputTf.placeholder = @"请输入红包金额";
        _moneyViewInputTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _moneyViewInputTf;
}

- (UIView *)moneyTypeView {
    if (!_moneyTypeView) {
        _moneyTypeView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyTypeViewTapAction:)];
        [_moneyTypeView addGestureRecognizer:tap];
    }
    return _moneyTypeView;
}

- (UILabel *)moneyTypeLabel {
    if (!_moneyTypeLabel) {
        _moneyTypeLabel = [[UILabel alloc] init];
        _moneyTypeLabel.text = @"哓可币";
        _moneyTypeLabel.font = XKRegularFont(16);
        _moneyTypeLabel.textColor = HEX_RGB(0x222222);
    }
    return _moneyTypeLabel;
}

- (UIImageView *)moneyTypeArrowImgView {
    if (!_moneyTypeArrowImgView) {
        _moneyTypeArrowImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_bg_IM_function_arrow")];
    }
    return _moneyTypeArrowImgView;
}

- (UIView *)countView {
    if (!_countView) {
        _countView = [UIView new];
        _countView.backgroundColor = [UIColor whiteColor];
    }
    return _countView;
}

- (UILabel *)countViewLeftLabel {
    if (!_countViewLeftLabel) {
        _countViewLeftLabel = [UILabel new];
        _countViewLeftLabel.font = XKRegularFont(16);
        _countViewLeftLabel.textColor = UIColorFromRGB(0x222222);
        _countViewLeftLabel.text = @"红包个数";
    }
    return _countViewLeftLabel;
}

- (UILabel *)countViewRightLabel {
    if (!_countViewRightLabel) {
        _countViewRightLabel = [UILabel new];
        _countViewRightLabel.font = XKRegularFont(16);
        _countViewRightLabel.textColor = UIColorFromRGB(0x222222);
        _countViewRightLabel.text = @"个";
        _countViewRightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countViewRightLabel;
}

- (UITextField *)countViewInputTf {
    if (!_countViewInputTf) {
        _countViewInputTf = [UITextField new];
        _countViewInputTf.font = XKRegularFont(16);
        _countViewInputTf.textAlignment = NSTextAlignmentRight;
        _countViewInputTf.keyboardType = UIKeyboardTypeNumberPad;
        _countViewInputTf.placeholder = @"请输入数量";
        _countViewInputTf.clearButtonMode = UITextFieldViewModeWhileEditing;
//        if (self.sendType == SendRedpacketTypeOne) {
//            _countViewInputTf.text = @"1";
//            _countViewInputTf.enabled = NO;
//        }
      
    }
    return _countViewInputTf;
}

- (UILabel *)extraLabel {
    if (!_extraLabel) {
        _extraLabel = [UILabel new];
        _extraLabel.font = XKRegularFont(14);
        _extraLabel.textColor = UIColorFromRGB(0x555555);
        _extraLabel.text = @"当前余额：100哓可币";
    }
    return _extraLabel;
}

- (UIView *)rechargeView {
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeViewTapAction:)];
        [_rechargeView addGestureRecognizer:tap];
    }
    return _rechargeView;
}

- (UILabel *)rechargeLabel {
    if (!_rechargeLabel) {
        _rechargeLabel = [[UILabel alloc] init];
        _rechargeLabel.text = @"充值";
        _rechargeLabel.font = XKRegularFont(14.0);
        _rechargeLabel.textColor = HEX_RGB(0x40ACE3);
    }
    return _rechargeLabel;
}

- (UIImageView *)rechargeArrowImgView {
    if (!_rechargeArrowImgView) {
        _rechargeArrowImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_bg_IM_function_recharge")];
    }
    return _rechargeArrowImgView;
}

- (UIButton *)priceBtn {
    if (!_priceBtn) {
        //    XKWeakSelf(ws);
        _priceBtn = [[UIButton alloc] init];
        [_priceBtn setTitle:@"100哓可币" forState:UIControlStateNormal];
        [_priceBtn setImage:[UIImage imageNamed:@"xk_bg_IM_function_price"] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        _priceBtn.titleLabel.font = XKRegularFont(24);
        _priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_priceBtn setBackgroundColor:[UIColor clearColor]];
    }
    return _priceBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        //    XKWeakSelf(ws);
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = XKRegularFont(16);
        [_sureBtn setBackgroundColor:UIColorFromRGB(0xF5484D)];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.cornerRadius = 4.f;
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
}

- (UIButton *)sendTicketBtn {
    if (!_sendTicketBtn) {
        _sendTicketBtn = [[UIButton alloc] init];
        [_sendTicketBtn setTitle:@"发优惠券" forState:UIControlStateNormal];
        [_sendTicketBtn setTitleColor:UIColorFromRGB(0x754610) forState:UIControlStateNormal];
        _sendTicketBtn.titleLabel.font = XKRegularFont(16);
        [_sendTicketBtn setBackgroundColor:UIColorFromRGB(0xFCE76C)];
        [_sendTicketBtn addTarget:self action:@selector(sendTicketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendTicketBtn.layer.cornerRadius = 20.f;
        _sendTicketBtn.layer.masksToBounds = YES;
    }
    return _sendTicketBtn;
}

- (UIButton *)sendDiscountBtn {
    if (!_sendDiscountBtn) {
        _sendDiscountBtn = [[UIButton alloc] init];
        [_sendDiscountBtn setTitle:@"发折扣卡" forState:UIControlStateNormal];
        [_sendDiscountBtn setTitleColor:UIColorFromRGB(0x754610) forState:UIControlStateNormal];
        _sendDiscountBtn.titleLabel.font = XKRegularFont(16);
        [_sendDiscountBtn setBackgroundColor:UIColorFromRGB(0xFCE76C)];
        [_sendDiscountBtn addTarget:self action:@selector(sendDiscountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendDiscountBtn.layer.cornerRadius = 20.f;
        _sendDiscountBtn.layer.masksToBounds = YES;
    }
    return _sendDiscountBtn;
}

@end
