//
//  XKSizerView.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSizerView.h"

@interface XKSizerView ()

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton    *clickBtn;

@end


@implementation XKSizerView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    return self;
}


- (void)initViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.imgView];
    [self addSubview:self.clickBtn];
}


- (void)layoutViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@((int)SCREEN_WIDTH / 2));
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@((int)SCREEN_WIDTH / 2));
    }];
}

#pragma mark - getter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x555555);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"xk_icon_search_down"];
    }
    return _imgView;
}

- (UIButton *)clickBtn {
    
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] init];
        [_clickBtn setTitle:@"" forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}


- (void)setTitle:(NSString *)title {
    self.nameLabel.text = title;
}


- (void)clickBtnSelected:(UIButton *)sender {
    
    if (self.sizerViewBlock) {
        self.sizerViewBlock(sender);
    }
    
}



@end
