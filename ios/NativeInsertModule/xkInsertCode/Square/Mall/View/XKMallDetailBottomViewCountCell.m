//
//  XKMallDetailBottomViewCountCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallDetailBottomViewCountCell.h"
#import "XKWelfareBuyCarSumView.h"
@interface XKMallDetailBottomViewCountCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)XKWelfareBuyCarSumView *sumView;
@end

@implementation XKMallDetailBottomViewCountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sumView];
    [self.contentView addSubview:self.lineView];
    
}

- (void)addUIConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]];
        _nameLabel.textColor = UIColorFromRGB(0x7777777);
        _nameLabel.text = @"购买数量";
    }
    return _nameLabel;
}

- (XKWelfareBuyCarSumView *)sumView {
    if(!_sumView) {
        XKWeakSelf(ws);
        _sumView = [[XKWelfareBuyCarSumView alloc] init];
        _sumView.addBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            current += 1;
            ws.sumView.inputTf.text = @(current).stringValue;
        };
        _sumView.subBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            if(current > 1) {
                current -= 1;
            }
            ws.sumView.inputTf.text = @(current).stringValue;
        };
    }
    return _sumView;
}

- (UIView *)lineView {
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}
@end
