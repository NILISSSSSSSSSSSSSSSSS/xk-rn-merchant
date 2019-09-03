//
//  XKStoreSectionHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreSectionHeaderView.h"


@interface XKStoreSectionHeaderView ()

@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView   *lineView;


@end

@implementation XKStoreSectionHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Private


- (void)initViews {
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.moreBtn];
    [self.backView addSubview:self.lineView];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-150);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-10);
        make.centerY.equalTo(self.nameLabel);
    }];
    
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}



- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreBtn addTarget:self action:@selector(moreBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


#pragma mark- Events

- (void)moreBtnCliked:(UIButton *)sender {
    if (sender.currentTitle.length == 0 && sender.currentImage == nil && sender.currentBackgroundImage == nil) {
        return;
    } else {
        if (self.moreBlock) {
            self.moreBlock(sender);
        }
    }
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)setTitleName:(NSString *)name titleColor:(UIColor *)color titleFont:(UIFont *)font {
    self.nameLabel.text = name;
    self.nameLabel.textColor = color;
    self.nameLabel.font = font;

}
- (void)setMoreButtonImageWithImageName:(NSString *)imgName space:(CGFloat)space imgDirection:(ButtonImgDirection)direction {

    [self.moreBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    if (imgName.length == 0) {
        direction = ButtonImgDirection_left;
    }
    if (direction == ButtonImgDirection_left) {
//        [self.moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, 0)];
        [self.moreBtn setImageAtLeftAndTitleAtRightWithSpace:space];
    } else if (direction == ButtonImgDirection_right) {
        [self.moreBtn setImageAtRightAndTitleAtLeftWithSpace:space];
    } else if (direction == ButtonImgDirection_top) {
        [self.moreBtn setImageAtTopAndTitleAtBottomWithSpace:space];
    }
}

- (void)setMoreButtonWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font buttonTag:(NSInteger)tag {
    self.moreBtn.tag = tag;
    if (title) {
        [self.moreBtn setTitle:title forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:color forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = font;
    } else {
        [self.moreBtn setTitle:@"" forState:UIControlStateNormal];
    }
}


@end






