//
//  XKStoreActivityCardTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreActivityCardTableViewCell.h"
#import "XKStoreActivityListShopCardModel.h"

@interface XKStoreActivityCardTableViewCell ()

@property (nonatomic, strong) UIImageView   *cardView;
@property (nonatomic, strong) UILabel       *limitLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *discountNumLabel;
@property (nonatomic, strong) UIButton      *useButton;

@end

@implementation XKStoreActivityCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)initViews {
    
    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.limitLabel];
    [self.cardView addSubview:self.dateLabel];
    [self.cardView addSubview:self.discountNumLabel];
    [self.cardView addSubview:self.useButton];
}

- (void)layoutViews {
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    
    [self.discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(-15);
        make.top.equalTo(self.cardView).offset(15);

    }];
    
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.cardView).offset(-15);
        make.width.equalTo(@70);
        make.height.equalTo(@22);
    }];
    
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
        make.centerY.equalTo(self.cardView);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.limitLabel.mas_left);
        make.right.lessThanOrEqualTo(self.useButton).offset(-5);
        make.bottom.equalTo(self.cardView).offset(-15);
    }];
}


#pragma mark - Events

- (void)clickUseButton:(UIButton *)sender {
    
}


#pragma mark - getter && setter

- (UIImageView *)cardView {
    if (!_cardView) {
        _cardView = [[UIImageView alloc] init];
        _cardView.image = [UIImage imageNamed:@"xk_bg_terminal_card"];
    }
    return _cardView;
}

- (UIButton *)useButton {
    if (!_useButton) {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_useButton setTitle:@"领取" forState:UIControlStateNormal];
        _useButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        [_useButton setTitleColor:HEX_RGB(0xFF7E00) forState:UIControlStateNormal];
        _useButton.backgroundColor = [UIColor whiteColor];
        _useButton.layer.cornerRadius = 11;
        _useButton.layer.masksToBounds = YES;
        
        [_useButton addTarget:self action:@selector(clickUseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}



- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
//        _limitLabel.text = @"指定商品可使用";
        _limitLabel.textColor = [UIColor whiteColor];
        _limitLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17];
    }
    return _limitLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
//        _dateLabel.text = @"有效期  2018-09-12至2018-09-25";
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10];
    }
    return _dateLabel;
}

- (UILabel *)discountNumLabel {
    if (!_discountNumLabel) {
        _discountNumLabel = [[UILabel alloc] init];
        _discountNumLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:22];
        _discountNumLabel.textColor = [UIColor whiteColor];
//        NSString *text = @"3.0折";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//        [attStr addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12]} range:NSMakeRange(text.length-1, 1)];
//        _discountNumLabel.attributedText = attStr;
    }
    return _discountNumLabel;
}


- (void)setVauleWithModel:(ShopCardModel *)model {
    
    if ([model.memberType isEqualToString:@"GENERAL"]) {
        self.limitLabel.text = @"普通卡";
    } else if ([model.memberType isEqualToString:@"VIP"]) {
        self.limitLabel.text = @"VIP卡";
    }
    self.dateLabel.text = [NSString stringWithFormat:@"有效期  %@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.validTime] ,[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:model.invalidTime]];
    
    NSString *text = [NSString stringWithFormat:@"%@", model.discount];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (text.length) {
        [attStr addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]} range:NSMakeRange(text.length-1, 1)];
    }
    self.discountNumLabel.attributedText = attStr;
    
    if (model.whetherDraw) {
        [self.useButton setTitle:@"已领取" forState:UIControlStateNormal];
        self.useButton.enabled = NO;
        [self.useButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else {
        [self.useButton setTitle:@"领取" forState:UIControlStateNormal];
        self.useButton.enabled = YES;
        [self.useButton setTitleColor:HEX_RGB(0xFF7E00) forState:UIControlStateNormal];
    }
}


@end

