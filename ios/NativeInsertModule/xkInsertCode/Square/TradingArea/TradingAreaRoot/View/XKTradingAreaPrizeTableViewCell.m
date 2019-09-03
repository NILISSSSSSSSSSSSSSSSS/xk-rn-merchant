//
//  XKTradingAreaPrizeTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKTradingAreaPrizeTableViewCell.h"
#import "XKCommonStarView.h"
@interface XKTradingAreaPrizeTableViewCell()

@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UIImageView           *iconImgView;
@property (nonatomic, strong) XKCommonStarView      *starView;
/**人均消费*/
@property (nonatomic, strong) UILabel               *perCapitaLabel;
/**距离*/
@property (nonatomic, strong) UILabel               *locationLabel;
/**右边标签*/
@property (nonatomic, strong) UILabel               *rightTagLabel;
/**标签*/
@property (nonatomic, strong) UILabel               *tagLabel;
/**分数*/
@property (nonatomic, strong) UILabel               *starLabel;
/**左上角标签*/
@property (nonatomic, strong) UILabel               *leftTagLabel;
/**cell的线*/
@property (nonatomic, strong) UIView                *line;
@end
@implementation XKTradingAreaPrizeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)creatUI {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.starView];
    [self.myContentView addSubview:self.locationLabel];
    [self.myContentView addSubview:self.rightTagLabel];
    [self.myContentView addSubview:self.tagLabel];
    [self.myContentView addSubview:self.perCapitaLabel];
    [self.myContentView addSubview:self.starLabel];
    [self.myContentView addSubview:self.line];
    [self.iconImgView addSubview:self.leftTagLabel];

}
- (void)layout {
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15);
        make.top.equalTo(self.myContentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(40);
    }];
    
    [self.rightTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(40);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.rightTagLabel.mas_bottom).offset(15);
        make.width.equalTo(@80);
        make.height.mas_equalTo(10);
    }];
     
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.starView.mas_right).offset(1);
         make.top.equalTo(self.starView.mas_top);
         make.width.equalTo(@40);
         make.height.mas_equalTo(10);
     }];
    
    [self.perCapitaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
        make.top.equalTo(self.starLabel.mas_top);
        make.height.mas_equalTo(15);
        make.left.equalTo(self.starLabel.mas_right);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.iconImgView.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
    }];
    
    [self.leftTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImgView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(50);
    }];
}

- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [[UIView alloc]init];
        _myContentView.backgroundColor = [UIColor whiteColor];
    }
    return _myContentView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _iconImgView.xk_openClip = YES;
        _iconImgView.xk_radius = 10;
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:@"http://b-ssl.duitang.com/uploads/item/201608/23/20160823155507_8QAhH.jpeg"]];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"莫泰-北京王府井步行街店 大床房包含两人早餐";
    }
    return _nameLabel;
}

- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc]initWithFrame:CGRectMake(0, 0, 80 * ScreenScale, 10 * ScreenScale) numberOfStars:5];
        _starView.userInteractionEnabled = NO;
        _starView.scorePercent = 4 / 5.0;
    }
    return _starView;
}


- (UILabel *)perCapitaLabel {
    if(!_perCapitaLabel) {
        _perCapitaLabel = [[UILabel alloc] init];
        [_perCapitaLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _perCapitaLabel.textColor = UIColorFromRGB(0x777777);
        NSString *str = @"99+";
        NSString *statusStr = [NSString stringWithFormat:@"人均消费：%@",str];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGB(252, 109, 58)
                           range:NSMakeRange(5, statusStr.length - 5)];
        _perCapitaLabel.attributedText = attrString;
        _perCapitaLabel.textAlignment = NSTextAlignmentRight;
    }
    return _perCapitaLabel;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        [_locationLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _locationLabel.textColor = UIColorFromRGB(0x777777);
        [_locationLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"距离: 328m ");
            confer.text(@" | ");
            confer.text(@" 成交量: 12.5w单");
        }];;
    }
    return _locationLabel;
}

-(UILabel *)leftTagLabel {
    if (!_leftTagLabel) {
        _leftTagLabel = [[UILabel alloc] init];
        [_leftTagLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:9]];
        _leftTagLabel.textColor = [UIColor whiteColor];
        _leftTagLabel.text = @"抽奖中";
        _leftTagLabel.xk_openClip = YES;
        _leftTagLabel.xk_radius = 10;
        _leftTagLabel.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeBottomRight;
        _leftTagLabel.backgroundColor = RGB(252, 109, 58);
        _leftTagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftTagLabel;
}

-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        [_tagLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _tagLabel.textColor = RGB(252, 109, 58);
        _tagLabel.text = @"均省45~56元";
        _tagLabel.backgroundColor = RGB(254, 234, 229);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

-(UILabel *)rightTagLabel {
    if (!_rightTagLabel) {
        _rightTagLabel = [[UILabel alloc] init];
        [_rightTagLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _rightTagLabel.textColor = RGB(252, 109, 58);
        _rightTagLabel.text = @"抽奖活动中";
        _rightTagLabel.backgroundColor = RGB(254, 234, 229);
        _rightTagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightTagLabel;
}


-(UILabel *)starLabel {
    if (!_starLabel) {
        _starLabel = [[UILabel alloc] init];
        [_starLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _starLabel.textColor = RGB(252, 109, 58);
        _starLabel.text = @"4分";
        _starLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _starLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XKSeparatorLineColor;
    }
    return _line;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

@end
