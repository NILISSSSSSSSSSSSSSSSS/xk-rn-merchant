//
//  XKBankCardUnbindViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBankCardUnbindViewController.h"
#import "XKPayPasswordView.h"



@interface XKBankCardUnbindViewController ()<XKPayPasswordViewDelegate>

@property (nonatomic, strong) XKPayPasswordView *payPasswordView;
@property (nonatomic, strong) UILabel           *tipLabel;
@property (nonatomic, strong) UIButton          *unbindButton;


@end

@implementation XKBankCardUnbindViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf1f1f1);
    
    [self configNavigationBar];
    [self addCustomSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.payPasswordView startInputPayPassword];
}

#pragma mark - Events

- (void)unbindButtonClicked:(UIButton *)sender {
    
    [XKAlertView showCommonAlertViewWithTitle:@"是否确定解除绑定？" leftText:@"取消" rightText:@"确定" leftBlock:^{
        
    } rightBlock:^{
        
        //
        NSLog(@"解绑成功");
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"XKBankCardListViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"验证支付密码" WithColor:[UIColor whiteColor]];
}

- (void)addCustomSubviews {
    

    [self.view addSubview:self.payPasswordView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.unbindButton];
    
    [self addUIConstraint];
}

- (void)addUIConstraint {

    
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height + 60);
        make.height.equalTo(@55);
        
    }];
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.payPasswordView.mas_bottom).offset(10);
    }];
    
    
    [self.unbindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(55);
        make.height.equalTo(@44);
    }];
}


#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSoure


#pragma mark - Custom Delegates

- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIBarButtonItem *)sender inputString:(NSString *)inputString {
    
    [self.payPasswordView stopInputPayPassword];
    //判断密码是否正确
    if (1) {
        self.unbindButton.backgroundColor = XKMainTypeColor;
        self.unbindButton.userInteractionEnabled = YES;
    } else {
        self.unbindButton.backgroundColor = HEX_RGB(0xDCDCDC);
        self.unbindButton.userInteractionEnabled = NO;
    }
    
}

#pragma mark - Getters and Setters

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x777777);
        _tipLabel.font = XKRegularFont(14);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"输入支付密码";
    }
    return _tipLabel;
}

- (XKPayPasswordView *)payPasswordView {
    
    if (!_payPasswordView) {
        _payPasswordView = [XKPayPasswordView addPayPasswordViewToView:self.view];
        _payPasswordView.delegate = self;
    }
    return _payPasswordView;
}

- (UIButton *)unbindButton {
    
    if (!_unbindButton) {
        _unbindButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH - 20, 44)];
        [_unbindButton addTarget:self action:@selector(unbindButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _unbindButton.layer.masksToBounds = YES;
        _unbindButton.layer.cornerRadius = 5;
        _unbindButton.backgroundColor = HEX_RGB(0xDCDCDC);
        _unbindButton.userInteractionEnabled = NO;
        [_unbindButton setTitle:@"解除绑定" forState:UIControlStateNormal];
        [_unbindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _unbindButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _unbindButton;
}



@end
