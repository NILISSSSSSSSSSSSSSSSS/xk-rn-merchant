//
//  XKBaseCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"

@interface XKBaseCollectionViewCell () {
    UIView *_line;
}

@end

@implementation XKBaseCollectionViewCell

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSuviews];
        [self addUIConstraint];
        
        _line = [UIView new];
        _line.backgroundColor = HEX_RGB(0xF2F2F2);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)addCustomSuviews {
    
}

- (void)addUIConstraint {
    
}
#pragma mark privite
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgContainView setNeedsLayout];
    [self.bgContainView layoutIfNeeded];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)hiddenSeperateLine:(BOOL)hidden {
    _line.hidden = hidden;
    [self.contentView bringSubviewToFront:_line];
}


#pragma mark lazy
- (UIView *)bgContainView {
    if (!_bgContainView) {
        _bgContainView = [[UIView alloc] init];
        _bgContainView.backgroundColor = [UIColor whiteColor];
    }
    return _bgContainView;
}
@end
