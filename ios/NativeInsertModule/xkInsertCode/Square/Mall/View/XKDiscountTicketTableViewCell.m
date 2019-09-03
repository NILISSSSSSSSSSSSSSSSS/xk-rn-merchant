//
//  XKDiscountTicketTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKDiscountTicketTableViewCell.h"
#import "XKVerticalDashLineView.h"
@interface XKDiscountTicketTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView  *leftImgView;
/**立即领取*/
@property (nonatomic, strong)UIButton *choseBtn;
/**价格*/
@property (nonatomic, strong)UILabel *priceLabel;
/**满减*/
@property (nonatomic, strong)UILabel *conditionLabel;

/**名字*/
@property (nonatomic, strong)UILabel *nameLabel;
/**时间*/
@property (nonatomic, strong)UILabel *timeLabel;
/**详情按钮*/
@property (nonatomic, strong)UIButton *detailBtn;
/**详情*/
@property (nonatomic, strong)UILabel *detailLabel;
@end

@implementation XKDiscountTicketTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.leftImgView];
    [self.bgView addSubview:self.choseBtn];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.conditionLabel];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.detailBtn];
    [self.bgView addSubview:self.detailLabel];
    
}

- (void)bindData:(XKMallBuyCarItem *)item {
    self.nameLabel.text = item.couponName;
    self.priceLabel.text =  [NSString stringWithFormat:@"¥%ld",item.price];
    NSString *beginTime = [XKTimeSeparateHelper backYMDHMStringByPointWithTimestampString:item.validTime];
    NSString *endTime = [XKTimeSeparateHelper backYMDHMStringByPointWithTimestampString:item.invalidTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",beginTime,endTime];
    self.choseBtn.enabled = item.whetherDraw == 0 ? YES : NO;
    if (item.whetherDraw == 0) {
        _choseBtn.userInteractionEnabled = YES;
        [_choseBtn setBackgroundColor:XKMainTypeColor];
        [_choseBtn setTitle:@"立即领取" forState:0];
        [_choseBtn setTitleColor:[UIColor whiteColor] forState:0];
    } else {
        _choseBtn.userInteractionEnabled = NO;
        [_choseBtn setBackgroundColor:UIColorFromRGB(0xDCEAFF)];
        [_choseBtn setTitle:@"已领取" forState:0];
        [_choseBtn setTitleColor:XKMainTypeColor forState:0];
    }
    self.detailLabel.text = item.message;
    if ([item.couponType isEqualToString:@"DISCOUNT"]) {//折扣券
        self.conditionLabel.text = @"指定商品可用";
    } else if ([item.couponType isEqualToString:@"DEDUCTION"]) {//抵扣券
        self.conditionLabel.text = @"无门槛";
    } else if ([item.couponType isEqualToString:@"FULL_SUB"]) {//满减券
        self.conditionLabel.text = @"满100.00元可用";
    }
}

- (void)addUIConstraint {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.bgView.mas_top).offset(25);
    }];
    
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom);
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView);
        make.right.equalTo(self.conditionLabel.mas_right).offset(25);
        make.height.mas_equalTo(86);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.top.equalTo(self.bgView.mas_top).offset(8);
        make.right.lessThanOrEqualTo(self.bgView.mas_right).offset(-15);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.bgView.mas_top).offset(55);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.detailBtn.mas_top).offset(-10);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.leftImgView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.leftImgView.mas_bottom);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
    
  
    self.detailLabel.alpha = 0;
}

- (void)detailBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected) {
      
        self.detailLabel.alpha = 1;

        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15);
            make.right.equalTo(self.bgView.mas_right).offset(-15);
            make.top.equalTo(self.leftImgView.mas_bottom).offset(8);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
        }];
        
    } else {
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15);
            make.right.equalTo(self.bgView.mas_right).offset(-15);
            make.top.equalTo(self.leftImgView.mas_bottom);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.bgView.mas_bottom);
        }];

        self.detailLabel.alpha = 0;
    }
    
    if(self.detailClickBlock) {
        self.detailClickBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseClickBlock) {
        self.choseClickBlock(sender, self.index);
    }
}



- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = 1.f;
        _bgView.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgView.image = [UIImage imageNamed:@"xk_btn_mall_bg"];
    }
    return _leftImgView;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = XKMediumFont(24);

    }
    return _priceLabel;
}

- (UILabel *)conditionLabel {
    if(!_conditionLabel) {
        _conditionLabel = [[UILabel alloc] init];
        _conditionLabel.textColor =[UIColor whiteColor];
        _conditionLabel.font = XKRegularFont(10);

    }
    return _conditionLabel;
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setTitle:@"立即领取" forState:0];
        [_choseBtn setBackgroundColor:XKMainTypeColor];
        [_choseBtn setTitleColor:[UIColor whiteColor] forState:0];
        _choseBtn.titleLabel.font = XKRegularFont(12);
        _choseBtn.layer.cornerRadius = 11.f;
        _choseBtn.layer.masksToBounds = YES;
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
   
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = XKRegularFont(10);
        _timeLabel.textColor = UIColorFromRGB(0x999999);

    }
    return _timeLabel;
}

- (UIButton *)detailBtn {
    if(!_detailBtn) {
        _detailBtn = [UIButton new];
        [_detailBtn setTitle:@"详情" forState:0];
        _detailBtn.titleLabel.font = XKRegularFont(12);
        _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_detailBtn setTitleColor:XKMainTypeColor forState:0];
        [_detailBtn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_detailBtn setImage:[UIImage imageNamed:@"xk_btn_mall_down"] forState:0];
        [_detailBtn setImage:[UIImage imageNamed:@"xk_btn_mall_up"] forState:UIControlStateSelected];
        [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 15, 0, 10 + 5)];
        [_detailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _detailBtn.titleLabel.bounds.size.width + 20, 0, -_detailBtn.titleLabel.bounds.size.width)];
    }
    return _detailBtn;
}

- (UILabel *)detailLabel {
    if(!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = XKRegularFont(10);
        _detailLabel.textColor = UIColorFromRGB(0x777777);
        _detailLabel.numberOfLines = 0;
  
    }
    return _detailLabel;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
