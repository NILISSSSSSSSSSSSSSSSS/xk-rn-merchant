//
//  XKWelfareReceiveGoodSuccessViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareReceiveGoodSuccessViewController.h"

@interface XKWelfareReceiveGoodSuccessViewController ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong)UIButton *backBtn;
@end

@implementation XKWelfareReceiveGoodSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"收货成功";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.shareBtn];
    [self.bgView addSubview:self.backBtn];
    [self addUIContains];
}

- (void)addUIContains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10 + kIphoneXNavi(64));
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(190);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 90));
        make.top.equalTo(self.bgView.mas_top).offset(15);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
    
    CGFloat pad = (SCREEN_WIDTH - 20 - 95 * 2)/3;
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(pad);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(- 10);
        make.size.mas_equalTo(CGSizeMake(95, 20));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-pad);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(- 10);
        make.size.mas_equalTo(CGSizeMake(95, 20));
    }];
}

- (void)sharBtnClick:(UIButton *)sender {

}

- (void)backBtnClick:(UIButton *)sender {
    
}
#pragma mark  懒加载
- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 190)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 90)/2, 15, 90, 96)];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_welfare_submit"];
    }
    return _iconImgView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame) + 10, SCREEN_WIDTH - 20, 20)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.text = @"确认收货成功！";
    }
    return _tipLabel;
}

- (UIButton *)shareBtn {
    if(!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.layer.cornerRadius = 10.f;
        _shareBtn.layer.borderWidth = 1.f;
        [_shareBtn setTitle:@"去晒单" forState:0];
        _shareBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];

        _shareBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_shareBtn setTitleColor:XKMainTypeColor forState:0];
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn addTarget:self action:@selector(sharBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)backBtn {
    if(!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.layer.cornerRadius = 10.f;
        _backBtn.layer.borderWidth = 1.f;
        _backBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13];
        [_backBtn setTitle:@"返回订单列表" forState:0];

        _backBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_backBtn setTitleColor:XKMainTypeColor forState:0];
        _backBtn.layer.masksToBounds = YES;
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


@end
