//
//  XKTradingAreaOrderPayTotalPriceCell.m
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderPayTotalPriceCell.h"

@interface XKTradingAreaOrderPayTotalPriceCell ()

@property (nonatomic, strong) UILabel           *totalPriceLabel;
@property (nonatomic, assign) CGFloat           totalPrice;


@end

@implementation XKTradingAreaOrderPayTotalPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {

    [self.contentView addSubview:self.totalPriceLabel];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {

    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView).offset(-15);
    }];
}


- (void)setTotalPriceValue:(CGFloat)totalPrice {
    
    [self.totalPriceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentCenter).lineSpacing(0);
        confer.text([NSString stringWithFormat:@"￥%.2f",fabs(totalPrice)]).font(XKMediumFont(24)).textColor(HEX_RGB(0x222222));
        confer.text(@"\n");
        if (totalPrice >= 0) {
             confer.text(@"总金额").font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
        } else {
            confer.text(@"退还金额").font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
        }
    }];
}


#pragma mark - Setter

- (UILabel *)totalPriceLabel {
    
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.numberOfLines = 2;
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
//        _totalPriceLabel.text = @"￥180\n总金额";
    }
    return _totalPriceLabel;
}



@end

