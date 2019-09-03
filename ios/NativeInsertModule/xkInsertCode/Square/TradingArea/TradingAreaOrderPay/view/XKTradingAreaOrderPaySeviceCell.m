//
//  XKTradingAreaOrderPaySeviceCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderPaySeviceCell.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKTradingAreaOrderPaySeviceCell ()<UITextFieldDelegate>

@property (nonatomic, strong) YYLabel           *decLabel;
@property (nonatomic, strong) UIView            *backView;
@property (nonatomic, strong) XKHotspotButton   *lookDetailBtn;
@property (nonatomic, strong) UILabel           *decLabel3;

@end

@implementation XKTradingAreaOrderPaySeviceCell

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
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {

    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.decLabel];
}


- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.height.equalTo(@1);
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
}



- (void)lookDetailBtnCliked:(UIButton *)sender {
    
    if (self.lookDetailBlock) {
        self.lookDetailBlock();
    }
}

- (void)setValueWithModel:(OrderItems *)model appointRange:(NSString *)appointRange {
    
    CGFloat platformItemsPrice = 0;
    CGFloat originalItemsPrice = 0;
    
    CGFloat platformTotalPrice = 0;
    
    platformItemsPrice = model.platformShopPrice.floatValue / 100.0;
    originalItemsPrice = model.originalPrice.floatValue / 100.0;
    platformTotalPrice = model.platformShopPrice.floatValue;
    for (PurchasesItem *item in model.purchases) {
        platformTotalPrice += item.platformShopPrice.floatValue;
    }
    platformTotalPrice = platformTotalPrice / 100.0;
    NSMutableAttributedString *attStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        //
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(10);
        
        confer.text(model.goodsName).font(XKMediumFont(17)).textColor(HEX_RGB(0x222222));
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"规格：%@", model.skuName]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
        confer.text(@"\n");
        if (model.seatName) {
            confer.text([NSString stringWithFormat:@"席位：%@", model.seatName]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text(@"\n");
        }
        
        NSArray *timeArr = [appointRange componentsSeparatedByString:@"-"];
        if (timeArr.count == 2) {//酒店
            NSString *str1 = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:timeArr.firstObject];
            NSString *str2 = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:timeArr.lastObject];
            /*if (str2.length >= 5) {
                str2 = [str2 substringFromIndex:str2.length - 5];
            }*/
            confer.text([NSString stringWithFormat:@"住店时间：%@", str1]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"离店时间：%@", str2]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text(@"\n");
            
        } else if (timeArr.count == 1) {//服务
            confer.text([NSString stringWithFormat:@"预约时间：%@", [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:appointRange]]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text(@"\n");
        }
        
        if (model.purchases.count) {
            confer.text(@"价格：").font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text([NSString stringWithFormat:@"￥%.2f", platformItemsPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(14));
            confer.text([NSString stringWithFormat:@" (市场价￥%.2f)", originalItemsPrice]).textColor(HEX_RGB(0x999999)).font(XKRegularFont(14)).strikeThrough(RZLineStyleSignl).strikeThroughColor(HEX_RGB(0x999999));
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"加购商品数：%d件", (int)model.purchases.count]).font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
            confer.text(@"  查看详情").font(XKRegularFont(14));
            confer.text(@"\n");
        }
        confer.text(@"订单总额：").font(XKRegularFont(14)).textColor(HEX_RGB(0x555555));
        confer.text([NSString stringWithFormat:@"￥%.2f", platformTotalPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(14));
        
    }].mutableCopy;
    NSRange range = [attStr.string rangeOfString:@"  查看详情"];
    
    if (range.location) {
        [attStr yy_setTextHighlightRange:range color:XKMainTypeColor backgroundColor:XKMainTypeColor userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            //
            if (self.lookDetailBlock) {
                self.lookDetailBlock();
            }
        } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        }];
    }
   
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) text:attStr];
    self.decLabel.attributedText = attStr;
    [self.decLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(layout.textBoundingSize.height));
    }];
    
}

#pragma mark - Setter

- (YYLabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[YYLabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _decLabel;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

@end
