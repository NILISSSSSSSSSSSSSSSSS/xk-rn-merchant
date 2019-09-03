//
//  XKGoodsDetailIntroductionTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGoodsDetailIntroductionTableViewCell.h"
#import "XKCommonStarView.h"
#import "XKAutoScrollView.h"
#import "XKTradingAreaGoodsInfoModel.h"


@interface XKGoodsDetailIntroductionTableViewCell ()<XKAutoScrollViewDelegate>

@property (nonatomic, strong) XKAutoScrollView  *loopView;
@property (nonatomic, strong) UILabel           *indexLable;

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *newPriceLabel;

@property (nonatomic, strong) UILabel           *oldPriceLable;
@property (nonatomic, strong) UIButton          *tipButton;
@property (nonatomic, strong) UIButton          *selledButton;

@property (nonatomic, strong) GoodsModel        *goodsModel;


@end


@implementation XKGoodsDetailIntroductionTableViewCell

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
    
    [self.contentView addSubview:self.loopView];
    [self.loopView addSubview:self.indexLable];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.newPriceLabel];
    [self.contentView addSubview:self.oldPriceLable];
    [self.contentView addSubview:self.tipButton];
    [self.contentView addSubview:self.selledButton];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(ScreenScale*180));
    }];
    
    [self.indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopView).offset(-10);
        make.right.equalTo(self.loopView).offset(-8);
        make.width.equalTo(@30);
        make.height.equalTo(@18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(-2);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.oldPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newPriceLabel.mas_right).offset(2);
        make.bottom.equalTo(self.newPriceLabel.mas_bottom).offset(-3);
    }];
    
    
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.newPriceLabel.mas_bottom);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.selledButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.contentView).offset(-5).priorityLow();
        make.left.equalTo(self.tipButton.mas_right);
        make.top.bottom.equalTo(self.tipButton);
    }];
}



#pragma mark - Setter

- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, ScreenScale*180) delegate:self isShowPageControl:NO isAuto:NO];
//        [_loopView setScrollViewItems:@[
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
//  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"}]];
//        _loopView.backgroundColor = [UIColor redColor];
    }
    return _loopView;
}


- (UILabel *)indexLable {
    if (!_indexLable) {
        _indexLable = [[UILabel alloc] init];
        _indexLable.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _indexLable.textColor = [UIColor whiteColor];
        _indexLable.textAlignment = NSTextAlignmentCenter;
        _indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _indexLable.text = @"1/5";
        _indexLable.layer.masksToBounds = YES;
        _indexLable.layer.cornerRadius = 9;
    }
    return _indexLable;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(17);
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"酸辣土豆丝";
    }
    return _nameLabel;
}



- (UILabel *)oldPriceLable {
    
    if (!_oldPriceLable) {
        _oldPriceLable = [[UILabel alloc] init];
        _oldPriceLable.textAlignment = NSTextAlignmentLeft;
        _oldPriceLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _oldPriceLable.textColor = HEX_RGB(0x999999);
        
//        NSString *str = @"14门市价";
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
//        [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
//        _oldPriceLable.attributedText = attributedStr;
    }
    return _oldPriceLable;
}


- (UILabel *)newPriceLabel {
    
    if (!_newPriceLabel) {
        _newPriceLabel = [[UILabel alloc] init];
        _newPriceLabel.textAlignment = NSTextAlignmentLeft;
//        _newPriceLabel.text = @"￥59.5";
        _newPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:21];
        _newPriceLabel.textColor = HEX_RGB(0xEE6161);
    }
    return _newPriceLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [[UIButton alloc] init];
        _tipButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
//        [_tipButton setTitle:@"提前1小时可退" forState:UIControlStateNormal];
        [_tipButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_tipButton setImage:[UIImage imageNamed:@"xk_icon_TradingArea_right"] forState:UIControlStateNormal];
//        _tipButton.backgroundColor = HEX_RGB(0xf6f6f6);
        [_tipButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _tipButton;
}


- (UIButton *)selledButton {
    if (!_selledButton) {
        _selledButton = [[UIButton alloc] init];
        _selledButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _selledButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_selledButton setTitle:@"已售19999" forState:UIControlStateNormal];
//        _selledButton.backgroundColor = HEX_RGB(0xf6f6f6);
        [_selledButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_selledButton setImage:[UIImage imageNamed:@"xk_icon_TradingArea_right"] forState:UIControlStateNormal];
    }
    return _selledButton;
}

- (void)setValuesWithModel:(GoodsModel *)model {
    
    self.goodsModel = model;
    
    NSMutableArray *muArr= [NSMutableArray array];
    for (NSString *imgUrl in model.showPics) {
        NSDictionary *dic = @{@"image":imgUrl};
        [muArr addObject:dic];
    }
    [self.loopView setScrollViewItems:muArr.copy];
    
    self.indexLable.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)muArr.count];
    [self.loopView bringSubviewToFront:self.indexLable];
    
    self.nameLabel.text = model.goodsName;
    
    NSString *str = [NSString stringWithFormat:@"%.2f门市价", model.originalPrice.floatValue / 100.0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attributedStr addAttributes:dic range:NSMakeRange(0, str.length)];
    self.oldPriceLable.attributedText = attributedStr;
    self.newPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountPrice.floatValue / 100.0];

    /* 退款方式 服务类 商品类 住宿类 消费前CONSUME_BEFORE,预约规定前多少时间可退RESERVATION_BEFORE_BYTIME,预约前随时退RESERVATION_BEFORE,不能退NOT_REFUNDS*/
    NSString *refundWay = @"";
    if ([model.refunds isEqualToString:@"CONSUME_BEFORE"]) {
        refundWay = @" 消费前可退";
    } else if ([model.refunds isEqualToString:@"RESERVATION_BEFORE_BYTIME"]) {
        refundWay = [NSString stringWithFormat:@" 消费前%@小时可退", model.refundsTime];
    } else if ([model.refunds isEqualToString:@"RESERVATION_BEFORE"]) {
        refundWay = @" 随时可退";
    } else if ([model.refunds isEqualToString:@"NOT_REFUNDS"]) {
        refundWay = @" 不可退";
    }
    if (refundWay.length) {
        self.tipButton.hidden = NO;
        [self.tipButton setTitle:refundWay forState:UIControlStateNormal];
        CGSize size = [refundWay boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size;
        [self.tipButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width + 30));
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        [self.selledButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipButton.mas_right);
        }];
    } else {
        self.tipButton.hidden = YES;
        [self.selledButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
        }];
    }
    
    [self.selledButton setTitle:[NSString stringWithFormat:@" 已售%@", model.saleM] forState:UIControlStateNormal];

}

#pragma mark - Events


#pragma mark - XKAutoScrollViewDelegate

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    
    if (self.coverItemBlock) {
        self.coverItemBlock(autoScrollView, item, index);
    }
}

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index {
    
    self.indexLable.text = [NSString stringWithFormat:@"%d/%d",(int)index, (int)self.goodsModel.showPics.count];
}


@end


