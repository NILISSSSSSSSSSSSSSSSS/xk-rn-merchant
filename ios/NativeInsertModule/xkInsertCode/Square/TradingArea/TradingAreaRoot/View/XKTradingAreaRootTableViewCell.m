//
//  XKTradingAreaRootTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaRootTableViewCell.h"
#import "XKCommonStarView.h"

@interface XKTradingAreaRootTableViewCell()
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)XKCommonStarView      *starView;
/**成交量*/
@property(nonatomic, strong) UILabel *countLabel;
/**距离*/
@property(nonatomic, strong) UILabel *locationLabel;
/**左上角标签*/
@property(nonatomic, strong) UILabel *leftTagLabel;
/**标签*/
@property(nonatomic, strong) UILabel *tagLabel1;
/**标签*/
@property(nonatomic, strong) UILabel *tagLabel2;
@end

@implementation XKTradingAreaRootTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)setModel:(XKTradingShopListDataItem *)model {
    _model = model;
    _nameLabel.text = model.name;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:kDefaultPlaceHolderImgName]];
    _starView.scorePercent = model.level / 5.0;
    if (model.monthVolume > 10000) {
        _countLabel.text = @"成交量：9999+";
    }else {
        _countLabel.text = [NSString stringWithFormat:@"成交量：%ld",(long)model.monthVolume];
    }
    if (model.distance > 1000) {
        [_locationLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage([UIImage imageNamed:@"xk_icon_snatchTreasure_order_address"]).bounds(CGRectMake(0, 0, 10, 13));
            confer.text(@" ");
            confer.text([NSString stringWithFormat:@"%ldkm",model.distance/1000]);
        }];
    }else {
        [_locationLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage([UIImage imageNamed:@"xk_icon_snatchTreasure_order_address"]).bounds(CGRectMake(0, 0, 10, 13));
            confer.text(@" ");
            confer.text([NSString stringWithFormat:@"%ldm",(long)model.distance]);
        }];
    }
    _leftTagLabel.hidden = YES;
    _tagLabel1.text = @"均省45~56元";
    _tagLabel2.text = @"抽奖活动中";
    [_tagLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self getWidthWithText:self.tagLabel1.text height:15.0 font:10]);
    }];
    [_tagLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self getWidthWithText:self.tagLabel2.text height:15.0 font:10]);
    }];
}

- (void)creatUI {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.starView];
    [self.myContentView addSubview:self.countLabel];
    [self.myContentView addSubview:self.locationLabel];
    [self.iconImgView addSubview:self.leftTagLabel];
    [self.myContentView addSubview:self.tagLabel1];
    [self.myContentView addSubview:self.tagLabel2];
}

- (void)layout {
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.equalTo(self.contentView);
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
    }];
    
    [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel1.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.tagLabel1.mas_bottom).offset(5);
        make.width.equalTo(@80);
        make.height.mas_equalTo(10);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.iconImgView.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(150);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
        make.bottom.equalTo(self.iconImgView.mas_bottom);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(150);
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
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:@"http://img.tupianzj.com/uploads/allimg/150701/10-150F1205349.jpg"]];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
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


- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel.textColor = UIColorFromRGB(0x777777);
        _countLabel.text = @"成交量：9999+";
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        [_locationLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _locationLabel.textColor = UIColorFromRGB(0x777777);
        [_locationLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage(IMG_NAME(@"xk_icon_snatchTreasure_order_address"));
            confer.text(@" 328m");
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

-(UILabel *)tagLabel1 {
    if (!_tagLabel1) {
        _tagLabel1 = [[UILabel alloc] init];
        [_tagLabel1 setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _tagLabel1.textColor = HEX_RGB(0xEE6161);
        _tagLabel1.text = @"均省45~56元";
        _tagLabel1.backgroundColor = RGB(254, 234, 229);
        _tagLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel1;
}

-(UILabel *)tagLabel2 {
    if (!_tagLabel2) {
        _tagLabel2 = [[UILabel alloc] init];
        [_tagLabel2 setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _tagLabel2.textColor = HEX_RGB(0xEE6161);
        _tagLabel2.text = @"抽奖活动中";
        _tagLabel2.backgroundColor = RGB(254, 234, 229);
        _tagLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel2;
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
