//
//  XKStoreBookingTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreBookingTableViewCell.h"
#import "XKTradingAreaShopInfoModel.h"

@interface XKStoreBookingTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *newPriceLabel;
@property (nonatomic, strong) UILabel     *oldPriceLabel;
@property (nonatomic, strong) UIButton    *buyButton;
@property (nonatomic, strong) UILabel     *outOfPrintLabel;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) ATShopGoodsItem *model;


@end

@implementation XKStoreBookingTableViewCell

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
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.newPriceLabel];
    [self.contentView addSubview:self.oldPriceLabel];
    [self.contentView addSubview:self.buyButton];
    [self.contentView addSubview:self.outOfPrintLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@(60*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-15);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(8);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-80);
        
    }];
    
    [self.newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(-8);
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.newPriceLabel.mas_right).offset(5);
        make.centerY.equalTo(self.newPriceLabel);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@22);
        make.width.equalTo(@60);

    }];
    
    [self.outOfPrintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.buyButton);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"]];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x474747);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"洗脚大保健套餐";
    }
    return _nameLabel;
}


- (UILabel *)newPriceLabel {
    
    if (!_newPriceLabel) {
        _newPriceLabel = [[UILabel alloc] init];
        _newPriceLabel.textAlignment = NSTextAlignmentLeft;
//        _newPriceLabel.text = @"￥158";
        _newPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _newPriceLabel.textColor = HEX_RGB(0xEE6161);
    }
    return _newPriceLabel;
}

- (UILabel *)oldPriceLabel {
    
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] init];
        _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
        _oldPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _oldPriceLabel.textColor = HEX_RGB(0x999999);
//        NSString *str = @"298";
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
//        [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
//        _oldPriceLabel.attributedText = attributedStr;
    }
    return _oldPriceLabel;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] init];
        _buyButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_buyButton setTitle:@"预定" forState:UIControlStateNormal];
        [_buyButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_buyButton setBackgroundColor:[UIColor whiteColor]];
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 11;
        _buyButton.layer.borderWidth = 1;
        _buyButton.layer.borderColor = XKMainTypeColor.CGColor;
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}


- (UILabel *)outOfPrintLabel {
    if (!_outOfPrintLabel) {
        _outOfPrintLabel = [[UILabel alloc] init];
        _outOfPrintLabel.textAlignment = NSTextAlignmentCenter;
        _outOfPrintLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _outOfPrintLabel.textColor = HEX_RGB(0x999999);
//        NSString *str = @"800人已购买";
//        _outOfPrintLabel.text = str;
    }
    return _outOfPrintLabel;
}



- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (void)setValueWithModel:(ATShopGoodsItem *)model {
    self.model = model;
    
    [self.imgView sd_setImageWithURL:kURL(model.mainPic) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];

    self.nameLabel.text = model.goodsName;
    
    self.newPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountPrice.floatValue / 100.0];
    
    NSString *str = [NSString stringWithFormat:@"￥%.2f", model.originalPrice.floatValue / 100.0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    self.oldPriceLabel.attributedText = attributedStr;
    
    self.outOfPrintLabel.text = [NSString stringWithFormat:@"%@人已购买", model.saleM];
    
}


#pragma mark - Events

- (void)buyButtonClicked:(UIButton *)sender {
    
    if (self.buyBlock) {
        self.buyBlock(self.model.goodsId);
    }
}






@end
