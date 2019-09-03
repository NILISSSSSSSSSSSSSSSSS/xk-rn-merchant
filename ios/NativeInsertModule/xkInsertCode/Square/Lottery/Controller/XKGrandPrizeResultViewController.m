//
//  XKGrandPrizeResultViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeResultViewController.h"
#import "XKMyGrandPrizesViewController.h"
#import "XKGrandPrizeDetailViewController.h"

@interface XKGrandPrizeResultViewController ()

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UIImageView *resultImgView;

@property (nonatomic, strong) UILabel *resultLab;

@property (nonatomic, strong) UIButton *checkOrderBtn;

@property (nonatomic, strong) UIButton *continueBtn;

@property (nonatomic, strong) UIButton *backSquareBtn;

@end

@implementation XKGrandPrizeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"领取成功" WithColor:[UIColor whiteColor]];
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    [self.containView addSubview:self.resultView];
    [self.resultView addSubview:self.resultImgView];
    [self.resultView addSubview:self.resultLab];
    [self.resultView addSubview:self.checkOrderBtn];
    [self.resultView addSubview:self.continueBtn];
    [self.resultView addSubview:self.backSquareBtn];
}

- (void)updateViews {
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    [self.resultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.0);
        make.centerX.mas_equalTo(self.resultView);
        make.width.height.mas_equalTo(33.0);
    }];
    
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultImgView.mas_bottom).offset(19.0);
        make.leading.trailing.mas_equalTo(self.resultView);
    }];
    
    [@[self.checkOrderBtn, self.continueBtn, self.backSquareBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15.0 leadSpacing:15.0 tailSpacing:15.0];
    
    [@[self.checkOrderBtn, self.continueBtn, self.backSquareBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultLab.mas_bottom).offset(41.0);
        make.height.mas_equalTo(30.0);
        make.bottom.mas_equalTo(-20.0);
    }];
    
}

#pragma mark - privite method

- (void)checkOrderBtnAction {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XKMyGrandPrizesViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

- (void)continueBtnAction {
    XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backSquareBtnAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getter setter

- (UIView *)resultView {
    if (!_resultView) {
        _resultView = [[UIView alloc] init];
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.layer.cornerRadius = 6.0;
        _resultView.layer.shadowRadius = 6.0;
        _resultView.layer.shadowColor = HEX_RGB(0xd7d7d7).CGColor;
        _resultView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        _resultView.layer.shadowOpacity = 1.0;
    }
    return _resultView;
}

- (UIImageView *)resultImgView {
    if (!_resultImgView) {
        _resultImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_ic_lottery_grandPrize_success")];
    }
    return _resultImgView;
}

- (UILabel *)resultLab {
    if (!_resultLab) {
        _resultLab = [[UILabel alloc] init];
        _resultLab.text = @"恭喜您，领取成功";
        _resultLab.font = XKMediumFont(17.0);
        _resultLab.textColor = HEX_RGB(0x222222);
        _resultLab.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLab;
}

- (UIButton *)checkOrderBtn {
    if (!_checkOrderBtn) {
        _checkOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkOrderBtn.titleLabel.font = XKRegularFont(14.0);
        [_checkOrderBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_checkOrderBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _checkOrderBtn.layer.cornerRadius = 4.0;
        _checkOrderBtn.layer.masksToBounds = YES;
        _checkOrderBtn.layer.borderWidth = 1.0;
        _checkOrderBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [_checkOrderBtn addTarget:self action:@selector(checkOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkOrderBtn;
}

- (UIButton *)continueBtn {
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.titleLabel.font = XKRegularFont(14.0);
        [_continueBtn setTitle:@"继续抽奖" forState:UIControlStateNormal];
        [_continueBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _continueBtn.layer.cornerRadius = 4.0;
        _continueBtn.layer.masksToBounds = YES;
        _continueBtn.layer.borderWidth = 1.0;
        _continueBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_continueBtn addTarget:self action:@selector(continueBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueBtn;
}

- (UIButton *)backSquareBtn {
    if (!_backSquareBtn) {
        _backSquareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backSquareBtn.titleLabel.font = XKRegularFont(14.0);
        [_backSquareBtn setTitle:@"返回广场" forState:UIControlStateNormal];
        [_backSquareBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _backSquareBtn.layer.cornerRadius = 4.0;
        _backSquareBtn.layer.masksToBounds = YES;
        _backSquareBtn.layer.borderWidth = 1.0;
        _backSquareBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [_backSquareBtn addTarget:self action:@selector(backSquareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backSquareBtn;
}

@end
