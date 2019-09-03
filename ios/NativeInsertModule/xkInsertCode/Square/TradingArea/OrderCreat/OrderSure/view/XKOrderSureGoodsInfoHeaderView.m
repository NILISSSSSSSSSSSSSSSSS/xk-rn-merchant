//
//  XKOrderSureGoodsInfoHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderSureGoodsInfoHeaderView.h"
#import "XKHotspotButton.h"
#import "XKCommonStarView.h"

@interface XKOrderSureGoodsInfoHeaderView ()

@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) UIView           *lineView;

@end

@implementation XKOrderSureGoodsInfoHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Private

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)initViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutViews {
    

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = @"成都老干嘛(英泰店)";
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
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


- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)setTitleName:(NSString *)name {
    self.nameLabel.text = name;
}

@end






