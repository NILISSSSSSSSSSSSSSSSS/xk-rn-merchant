//
//  XKCustomerSerChatOrderView.m
//  XKSquare
//
//  Created by william on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerChatOrderView.h"
#import "XKCustomerSerChatOrderSubViewController.h"
#import "XKMallListViewModel.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKCustomerSerChatOrderTableViewCell.h"

@interface XKCustomerSerChatOrderView() <UIScrollViewDelegate>

// 福利订单按钮
@property (nonatomic, strong) UIButton *welfareOrderBtn;
// 自营订单按钮
@property (nonatomic, strong) UIButton *platformOrderBtn;
// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
// 横线
@property (nonatomic, strong) UIView *lineH;
// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
// 滚动内容视图
@property (nonatomic, strong) UIView *containerView;
// 福利订单
@property (nonatomic, strong) XKCustomerSerChatOrderSubViewController *welfareOrderVC;
// 自营订单
@property (nonatomic, strong) XKCustomerSerChatOrderSubViewController *platformOrderVC;
// 底部视图
@property (nonatomic, strong) UIView *bottomView;
// 发送按钮
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation XKCustomerSerChatOrderView

#pragma mark – Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

#pragma mark – Private Methods

- (void)initializeViews {
    [self addSubview:self.welfareOrderBtn];
    [self addSubview:self.platformOrderBtn];
    [self addSubview:self.closeBtn];
    [self addSubview:self.lineH];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.welfareOrderVC.view];
    [self.containerView addSubview:self.platformOrderVC.view];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.sendBtn];
}

- (void)updateViews {
    [self.welfareOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.leading.mas_equalTo(25.0);
        make.width.mas_equalTo(70.0);
        make.height.mas_equalTo(22.0);
    }];
    
    [self.platformOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.welfareOrderBtn);
        make.left.mas_equalTo(self.welfareOrderBtn.mas_right).offset(20.0);
        make.width.mas_equalTo(70.0);
        make.height.mas_equalTo(22.0);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15.0);
        make.centerY.mas_equalTo(self.welfareOrderBtn);
        make.width.height.mas_equalTo(18.0);
    }];
    
    [self.lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.welfareOrderBtn.mas_bottom).offset(15.0);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineH.mas_bottom);
        make.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView);
    }];

    [self.welfareOrderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.scrollView);
    }];

    [self.platformOrderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.welfareOrderVC.view.mas_right);
        make.width.mas_equalTo(self.scrollView);
        make.trailing.mas_equalTo(self.containerView);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(50.0);
    }];

    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(105.0);
    }];
}

#pragma mark - Events

- (void)welfareOrderBtnAction:(UIButton *)sender {
    if (self.welfareOrderBtn.selected == YES) {
        return;
    }
    self.welfareOrderBtn.layer.borderColor = XKMainTypeColor.CGColor;
    self.welfareOrderBtn.selected = YES;
    self.platformOrderBtn.layer.borderColor = HEX_RGB(0xCCCCCC).CGColor;
    self.platformOrderBtn.selected = NO;
    [UIView animateWithDuration:0.33 animations:^{
        self.scrollView.contentOffset = CGPointZero;
        [self.platformOrderVC removeSelectedArray];
    }];
}

- (void)platformOrderBtnAction:(UIButton *)sender {
    if (self.platformOrderBtn.selected == YES) {
        return;
    }
    self.welfareOrderBtn.layer.borderColor = HEX_RGB(0xCCCCCC).CGColor;
    self.welfareOrderBtn.selected = NO;
    self.platformOrderBtn.layer.borderColor = XKMainTypeColor.CGColor;
    self.platformOrderBtn.selected = YES;
    [UIView animateWithDuration:0.33 animations:^{
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0.0);
        [self.welfareOrderVC removeSelectedArray];
    }];
}

- (void)closeBtnAction:(UIButton *)sender {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)sendBtnAction:(UIButton *)sender {
    if (self.sendBtnBlock) {
        if (self.welfareOrderBtn.selected) {
            self.sendBtnBlock(self.welfareOrderVC.selectedArray);
        }
        if (self.platformOrderBtn.selected) {
            self.sendBtnBlock(self.platformOrderVC.selectedArray);
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self welfareOrderBtnAction:self.welfareOrderBtn];
    } else if (scrollView.contentOffset.x == CGRectGetWidth(self.scrollView.frame)) {
        [self platformOrderBtnAction:self.platformOrderBtn];
    }
}

#pragma mark - getter setter

- (UIButton *)welfareOrderBtn {
    if (!_welfareOrderBtn) {
        _welfareOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _welfareOrderBtn.titleLabel.font = XKRegularFont(12.0);
        [_welfareOrderBtn setTitle:@"福利订单" forState:UIControlStateNormal];
        [_welfareOrderBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_welfareOrderBtn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_welfareOrderBtn addTarget:self action:@selector(welfareOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _welfareOrderBtn.layer.cornerRadius = 11.0;
        _welfareOrderBtn.layer.masksToBounds = YES;
        _welfareOrderBtn.clipsToBounds = YES;
        _welfareOrderBtn.layer.borderWidth = 1.0;
        _welfareOrderBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _welfareOrderBtn.selected = YES;
    }
    return _welfareOrderBtn;
}

- (UIButton *)platformOrderBtn {
    if (!_platformOrderBtn) {
        _platformOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _platformOrderBtn.titleLabel.font = XKRegularFont(12.0);
        [_platformOrderBtn setTitle:@"自营商品" forState:UIControlStateNormal];
        [_platformOrderBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_platformOrderBtn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_platformOrderBtn addTarget:self action:@selector(platformOrderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _platformOrderBtn.layer.cornerRadius = 11.0;
        _platformOrderBtn.layer.masksToBounds = YES;
        _platformOrderBtn.clipsToBounds = YES;
        _platformOrderBtn.layer.borderWidth = 1.0;
        _platformOrderBtn.layer.borderColor = HEX_RGB(0xCCCCCC).CGColor;
    }
    return _platformOrderBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:IMG_NAME(@"xk_btn_customerSer_evaluateDimiss") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)lineH {
    if (!_lineH) {
        _lineH = [[UIView alloc] init];
        _lineH.backgroundColor = XKSeparatorLineColor;
    }
    return _lineH;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (XKCustomerSerChatOrderSubViewController *)welfareOrderVC {
    if (!_welfareOrderVC) {
        _welfareOrderVC = [[XKCustomerSerChatOrderSubViewController alloc] init];
        _welfareOrderVC.type = XKCustomerSerChatOrderSubVCTypeWelfare;
    }
    return _welfareOrderVC;
}

- (XKCustomerSerChatOrderSubViewController *)platformOrderVC {
    if (!_platformOrderVC) {
        _platformOrderVC = [[XKCustomerSerChatOrderSubViewController alloc] init];
        _platformOrderVC.type = XKCustomerSerChatOrderSubVCTypePlatform;
    }
    return _platformOrderVC;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.titleLabel.font = XKRegularFont(17.0);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = XKMainTypeColor;
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
