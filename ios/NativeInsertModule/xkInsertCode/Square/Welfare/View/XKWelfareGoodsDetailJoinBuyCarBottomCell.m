//
//  XKWelfareGoodsDetailJoinBuyCarBottomCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailJoinBuyCarBottomCell.h"
#import "XKWelfareBuyCarSumView.h"
@interface XKWelfareGoodsDetailJoinBuyCarBottomCell ()
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)XKWelfareBuyCarSumView *sumView;
@end

@implementation XKWelfareGoodsDetailJoinBuyCarBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.sumView];
}

- (void)addUIConstraint {
    [self.sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.countLabel);
        make.top.equalTo(self.contentView.mas_top).offset(20);
    }];
    

}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = UIColorFromRGB(0x222222);
        _countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.f];
        _countLabel.text = @"夺奖次数";
    }
    return _countLabel;
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

@end
