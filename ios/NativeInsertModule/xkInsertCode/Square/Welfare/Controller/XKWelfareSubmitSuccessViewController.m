//
//  XKWelfareSubmitSuccessViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareSubmitSuccessViewController.h"

@interface XKWelfareSubmitSuccessViewController ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *tipLabel;
@end

@implementation XKWelfareSubmitSuccessViewController

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
    navBar.titleString = @"提交成功";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        for (UIViewController *vc in ws.navigationController.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"XKMainMallOrderViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
       
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.tipLabel];
    [self addUIConstraint];
}

- (void)addUIConstraint {
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
        make.left.equalTo(self.bgView.mas_left).offset(50 * ScreenScale);
        make.right.equalTo(self.bgView.mas_right).offset(- 50 * ScreenScale);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
}
#pragma mark lazy
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
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * ScreenScale, CGRectGetMaxY(_bgView.frame) + 10, SCREEN_WIDTH - 20 - 100 * ScreenScale, 20)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"你的信息已提交成功，客服人员会尽快为你处理，请注意查看订单状态！！！";
    }
    return _tipLabel;
}

@end
