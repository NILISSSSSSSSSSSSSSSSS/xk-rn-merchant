//
//  XKBankCardDetailCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBankCardDetailCell.h"
#import "XKCommonStarView.h"

@interface XKBankCardDetailCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UIView            *numberView;
@property (nonatomic, strong) UILabel           *numberLabel;

@end

@implementation XKBankCardDetailCell

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
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.numberView];
    [self.numberView addSubview:self.numberLabel];
    
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@(31*ScreenScale));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.centerY.equalTo(self.imgView);
    }];

    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.imgView);
    }];
    
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(20);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-60);
        make.height.equalTo(@30);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberView.mas_right);
        make.centerY.equalTo(self.numberView);
    }];

}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"xk_btn_order_pay_bank"];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"建设银行";
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x999999);
        _decLabel.textAlignment = NSTextAlignmentRight;
        _decLabel.text = @"信用卡";
    }
    return _decLabel;
}

- (UIView *)numberView {
    if (!_numberView) {
        _numberView = [[UIView alloc] init];
        CGFloat margen = (SCREEN_WIDTH - 33 - 31*ScreenScale - 49 - 68 - (20*6)) / 20;
        for (int i = 0; i < 20; ++i) {
            UIView *imgView = [[UIView alloc] init];
            imgView.backgroundColor = HEX_RGB(0xcccccc);
            CGFloat x = (margen + 6) * i;
            if (i == 4 || i == 9 || i == 14 || i == 19) {
                imgView.hidden = YES;
            }
            imgView.frame = CGRectMake(x, 12, 6, 6);
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = 3;
            [_numberView addSubview:imgView];
        }
    }
    return _numberView;
}

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.text = @"3880";
        _numberLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _numberLabel.textColor = HEX_RGB(0x222222);
    }
    return _numberLabel;
}



@end




