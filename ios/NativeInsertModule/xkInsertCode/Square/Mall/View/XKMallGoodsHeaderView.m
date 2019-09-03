//
//  XKMallGoodsHeaderView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsHeaderView.h"

@interface XKMallGoodsHeaderView ()
@property (nonatomic, strong) UILabel  *titleLabel;


@end

@implementation XKMallGoodsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addUI {
    [self addSubview:self.saveBtn];
    [self addSubview:self.titleLabel];
    
}

- (void)hideRirhtBtn:(BOOL)hide title:(NSString *)title {
    self.saveBtn.hidden = hide;
    self.titleLabel.text = title;
}

- (void)saveBtnClick:(UIButton *)sender {
    if (self.saveBlock) {
        self.saveBlock(sender);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 15)];
        _titleLabel.font  = XKRegularFont(14);
        _titleLabel.textColor  = UIColorFromRGB(0x999999);
        _titleLabel.text = @"私人订制";
    }
    return _titleLabel;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 10 - 50, 13, 50, 20)];

        
        _saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _saveBtn.titleLabel.font = XKRegularFont(14);
        [_saveBtn setTitleColor:XKMainTypeColor forState:0];
        [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

@end
