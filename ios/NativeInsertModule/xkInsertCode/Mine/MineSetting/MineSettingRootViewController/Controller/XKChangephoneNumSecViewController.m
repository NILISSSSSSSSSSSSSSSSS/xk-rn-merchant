//
//  XKChangephoneNumSecViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChangephoneNumSecViewController.h"
NSString * const XKChangephoneNumSecViewPhone = @"XKChangephoneNumSecViewPhone";

@interface XKChangephoneNumSecViewController ()
@property(nonatomic,strong) UIButton       *nextButton;
@property(nonatomic,strong) UIImageView    *imageView;
@property(nonatomic,strong) UILabel        *titleLabel;

@end

@implementation XKChangephoneNumSecViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"修改手机号码" WithColor:[UIColor whiteColor]];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backBtnClick {
    [[NSNotificationCenter defaultCenter]postNotificationName:XKChangephoneNumSecViewPhone object:nil userInfo:@{@"phone":self.phone}];
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}
#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.nextButton];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(110 * ScreenScale));
        make.top.equalTo(@(NavigationAndStatue_Height + 48));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150 * ScreenScale));
        make.height.equalTo(@(24 * ScreenScale));
        make.top.equalTo(self.imageView.mas_bottom).offset(24 *ScreenScale);
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10 * ScreenScale));
        make.right.equalTo(@(-10 * ScreenScale));
        make.height.equalTo(@(44 * ScreenScale));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(27 * ScreenScale);
    }];

}
#pragma mark - Events

- (void)nextAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:XKChangephoneNumSecViewPhone object:nil userInfo:@{@"phone":self.phone}];
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    
}
#pragma mark – Getters and Setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"xk_btn_personal_success"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"手机修改成功";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _titleLabel.textColor = HEX_RGB(0x222222);
    }
    return _titleLabel;
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton setTitle:@"返回" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _nextButton.layer.masksToBounds = true;
        _nextButton.layer.cornerRadius = 8 * ScreenScale;
        _nextButton.backgroundColor = HEX_RGB(0x4A90FA);
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
@end
