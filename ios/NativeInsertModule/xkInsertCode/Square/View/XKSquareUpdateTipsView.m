//
//  XKSquareUpdateTipsView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/2.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSquareUpdateTipsView.h"

@interface XKSquareUpdateTipsView ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *upImgView;

@property (nonatomic, strong) UILabel *versionLab;

@property (nonatomic, strong) UIImageView *downImgView;

@property (nonatomic, strong) UILabel *updateLab;

@property (nonatomic, strong) UITextView *updateConentTextView;

@property (nonatomic, strong) UILabel *remarkLab;

@property (nonatomic, strong) UIButton *updateBtn;

@end

@implementation XKSquareUpdateTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {

    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:IMG_NAME(@"xk_btn_hone_coupon_close") forState:UIControlStateNormal];
    [self.containerView addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.upImgView = [[UIImageView alloc] init];
    self.upImgView.image = IMG_NAME(@"xk_img_home_updateTips_up");
    [self.containerView addSubview:self.upImgView];
    
    self.downImgView = [[UIImageView alloc] init];
    self.downImgView.image = IMG_NAME(@"xk_img_home_updateTips_down");
    [self.containerView addSubview:self.downImgView];
    
    self.versionLab = [[UILabel alloc] init];
    self.versionLab.font = XKRegularFont(15.0);
    self.versionLab.textColor = HEX_RGB(0xFFFFFF);
    self.versionLab.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.versionLab];
    
    self.updateLab = [[UILabel alloc] init];
    self.updateLab.text = @"更新内容";
    self.updateLab.font = XKRegularFont(16.0);
    self.updateLab.textColor = HEX_RGB(0x222222);
    [self.containerView addSubview:self.updateLab];
    
    self.updateConentTextView = [[UITextView alloc] init];
    self.updateConentTextView.text = @"";
    self.updateConentTextView.editable = NO;
    self.updateConentTextView.selectable = NO;
    self.updateConentTextView.font = XKRegularFont(14.0);
    self.updateConentTextView.textColor = HEX_RGB(0x999999);
    self.updateConentTextView.showsVerticalScrollIndicator = YES;
    [self.containerView addSubview:self.updateConentTextView];
    self.updateConentTextView.contentInset = UIEdgeInsetsZero;
    
    self.remarkLab = [[UILabel alloc] init];
    self.remarkLab.text = @"";
    self.remarkLab.font = XKRegularFont(12.0);
    self.remarkLab.textColor = HEX_RGB(0x999999);
    self.remarkLab.numberOfLines = 2;
    [self addSubview:self.remarkLab];
    
    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateBtn.titleLabel.font = XKRegularFont(17.0);
    [self.updateBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.updateBtn setBackgroundImage:IMG_NAME(@"xk_btn_home_updateTips_update") forState:UIControlStateNormal];
    [self.containerView addSubview:self.updateBtn];
    [self.updateBtn addTarget:self action:@selector(updateBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.containerView);
    }];
    
    [self.upImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeBtn.mas_bottom).offset(27.0);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.width.mas_equalTo(295.0 * ScreenScale);
        make.height.mas_equalTo(162.0 * ScreenScale);
    }];
    
    [self.downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upImgView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView);
    }];
    
    [self.versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upImgView).offset(42.0);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    [self.updateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.upImgView);
        make.leading.mas_equalTo(35.0);
    }];
    
    [self.updateConentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.updateLab.mas_bottom).offset(10.0);
        make.leading.mas_equalTo(30.0);
        make.trailing.mas_equalTo(-30.0);
        make.bottom.mas_equalTo(self.remarkLab.mas_top).offset(-10.0);
    }];
    
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.updateBtn);
        make.bottom.mas_equalTo(self.updateBtn.mas_top).offset(-10.0);
    }];
    
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.updateConentTextView);
        make.height.mas_equalTo(self.updateBtn.mas_width).multipliedBy(54.0 / 235.0);
        make.bottom.mas_equalTo(self.downImgView).offset(-20.0);
    }];
}

- (void)setVersionStr:(NSString *)versionStr {
    _versionStr = versionStr;
    self.versionLab.text = [NSString stringWithFormat:@"v%@", versionStr];
}

- (void)setUpdateContent:(NSString *)updateContent {
    self.updateConentTextView.text = updateContent;
}

- (void)setRemarkContent:(NSString *)remarkContent {
    self.remarkLab.text = remarkContent;
    [self layoutIfNeeded];
    CGFloat height = [self.remarkLab.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.remarkLab.frame), 0.0) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.remarkLab.font} context:nil].size.height;
    if (height > self.remarkLab.font.pointSize * 2.0) {
        self.remarkLab.textAlignment = NSTextAlignmentLeft;
    } else {
        self.remarkLab.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setUpdateBtnTitle:(NSString *)updateBtnTitle {
    [self.updateBtn setTitle:updateBtnTitle forState:UIControlStateNormal];
}

- (void)closeBtnAction:(UIButton *) sender {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)updateBtnAction {
    if (self.updateBtnBlock) {
        self.updateBtnBlock();
    }
}

- (void)setCloseBtnHidden:(BOOL)hidden {
    self.closeBtn.hidden = hidden;
}

@end
