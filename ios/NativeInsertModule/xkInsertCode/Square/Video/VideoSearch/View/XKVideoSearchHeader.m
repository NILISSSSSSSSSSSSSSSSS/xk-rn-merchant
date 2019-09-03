//
//  XKVideoSearchHeader.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchHeader.h"

@interface XKVideoSearchHeader ()

@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) UILabel *downLine;

@end

@implementation XKVideoSearchHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 44.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.titleLab];
    [self.containerView addSubview:self.moreView];
    [self.moreView addSubview:self.moreLab];
    [self.moreView addSubview:self.arrowImgView];
    [self.containerView addSubview:self.downLine];
}

- (void)updateViews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15.0);
        make.centerY.mas_equalTo(self.containerView);
        make.right.mas_equalTo(self.containerView.mas_centerX);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.trailing.mas_equalTo(-15.0);
    }];
    
    [self.moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.moreView);
        make.centerY.mas_equalTo(self.moreView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreLab.mas_right).offset(5.0);
        make.trailing.mas_equalTo(self.moreView);
        make.centerY.mas_equalTo(self.moreView);
    }];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - privite method

- (void)tapAction {
    if (self.moreBlock) {
        self.moreBlock();
    }
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_moreView addGestureRecognizer:tap];
    }
    return _moreView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = HEX_RGB(0x222222);
        _titleLab.font = XKRegularFont(14.0);
    }
    return _titleLab;
}

- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] init];
        _moreLab.text = @"查看更多";
        _moreLab.textColor = XKMainTypeColor;
        _moreLab.font = XKRegularFont(12.0);
        _moreLab.textAlignment = NSTextAlignmentRight;
    }
    return _moreLab;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = IMG_NAME(@"xk_ic_video_more");
    }
    return _arrowImgView;
}

- (UILabel *)downLine {
    if (!_downLine) {
        self.downLine = [[UILabel alloc] init];
        self.downLine.backgroundColor = HEX_RGB(0xf1f1f1);
    }
    return _downLine;
}

- (void)setMoreViewHidden:(BOOL)hidden {
    self.moreView.hidden = hidden;
}

- (void)setDownLineHidden:(BOOL)hidden {
    self.downLine.hidden = hidden;
}

@end
