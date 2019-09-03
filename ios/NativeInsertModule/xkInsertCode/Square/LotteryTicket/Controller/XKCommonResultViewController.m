//
//  XKCommonResultViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCommonResultViewController.h"

@interface XKCommonResultViewController ()

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UIImageView *resultImgView;

@property (nonatomic, strong) UILabel *resultLab;

@property (nonatomic, strong) NSMutableArray <UIButton *>*btns;

@end

@implementation XKCommonResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:self.titleStr WithColor:HEX_RGB(0xFFFFFF)];
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    self.resultView = [[UIView alloc] init];
    self.resultView.backgroundColor = HEX_RGB(0xFFFFFF);
    [self.containView addSubview:self.resultView];
    self.resultView.layer.cornerRadius = 6.0;
    self.resultView.layer.shadowRadius = 6.0;
    self.resultView.layer.shadowColor = HEX_RGB(0xd7d7d7).CGColor;
    self.resultView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
    self.resultView.layer.shadowOpacity = 1.0;
    
    self.resultImgView = [[UIImageView alloc] init];
    self.resultImgView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.vcType == XKCommonResultVCTypeSucceed) {
        self.resultImgView.image = IMG_NAME(@"xk_ic_lottery_grandPrize_success");
    } else if (self.vcType == XKCommonResultVCTypeFailed) {
        self.resultImgView.image = IMG_NAME(@"");
    }
    [self.resultView addSubview:self.resultImgView];
    
    self.resultLab = [[UILabel alloc] init];
    self.resultLab.text = self.resultStr;
    self.resultLab.font = XKRegularFont(14.0);
    self.resultLab.textColor = HEX_RGB(0x555555);
    self.resultLab.textAlignment = NSTextAlignmentCenter;
    [self.resultView addSubview:self.resultLab];

    for (UIButton *btn in self.btns) {
        [self.resultView addSubview:btn];
    }
    
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
        make.width.height.mas_equalTo(66.0);
    }];
    
    [self.resultLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultImgView.mas_bottom).offset(20.0);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        if (self.btns.count == 0) {
            make.bottom.mas_equalTo(-30.0);
        }
    }];
    
    if (self.btns.count) {
        if (self.btns.count == 1) {
            [self.btns.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.resultLab.mas_bottom).offset(30.0);
                make.centerX.mas_equalTo(self.resultView);
                make.width.mas_equalTo(108.0);
                make.height.mas_equalTo(30.0);
                make.bottom.mas_equalTo(self.resultView).offset(-30.0);
            }];
        } else {
            [self.btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:50.0 leadSpacing:20.0 tailSpacing:20.0];
            [self.btns mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.resultLab.mas_bottom).offset(30.0);
                make.height.mas_equalTo(30.0);
                make.bottom.mas_equalTo(self.resultView).offset(-30.0);
            }];
        }
    }
}

- (void)refreshBtns {
    
}

- (void)addBtnWithBtnTitle:(NSString *)btnTitle btnColor:(UIColor *)btnColor btnBlock:(nullable void (^)(UIViewController * _Nonnull))btnBlock {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = XKRegularFont(14.0);
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.btns addObject:btn];
    btn.layer.cornerRadius = 4.0;
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = btnColor.CGColor;
    [btn bk_whenTapped:^{
        if (btnBlock) {
            btnBlock(self);
        }
    }];
    for (UIView *temp in self.containView.subviews) {
        [temp removeFromSuperview];
    }
    [self initializeViews];
    [self updateViews];
}

#pragma mark - getter setter

- (NSMutableArray<UIButton *> *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

@end
