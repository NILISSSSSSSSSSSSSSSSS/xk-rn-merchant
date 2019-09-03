//
//  XKMessageShoppingMallTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageShoppingMallTableViewCell.h"

@interface XKMessageShoppingMallTableViewCell ()
/**背景视图*/
@property(nonatomic, strong) UIView *bigContentView;
/**描述视图*/
@property(nonatomic, strong) UILabel *desLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**商品视图*/
@property(nonatomic, strong) UIView *goodsContentView;
/**图片视图*/
@property(nonatomic, strong) UIImageView *imageV;
/**商品标题*/
@property(nonatomic, strong) UILabel *goodsTitleLabel;
/**订单号码*/
@property(nonatomic, strong) UILabel *orderLabel;
/**红点*/
@property(nonatomic, strong) UIView *redPoint;

@end

@implementation XKMessageShoppingMallTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)setModel:(XKSysDetailMessageModelDataItem *)model {
    _model = model;
    _desLabel.text = model.msgContent;
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.createdAt];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.extras.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    _goodsTitleLabel.text = model.extras.goodsName;
    _orderLabel.text = model.extras.orderId;
    if (model.isRead == 1) {
        _redPoint.hidden = YES;
    }else {
        _redPoint.hidden = NO;
    }
}

- (void)creatUI {
    [self.contentView addSubview:self.bigContentView];
    
    [self.bigContentView addSubview:self.redPoint];
    [self.bigContentView addSubview:self.desLabel];
    [self.bigContentView addSubview:self.timeLabel];
    [self.bigContentView addSubview:self.goodsContentView];
    
    [self.goodsContentView addSubview:self.goodsTitleLabel];
    [self.goodsContentView addSubview:self.imageV];
    [self.goodsContentView addSubview:self.orderLabel];
}
- (void)layout {
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.contentView);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bigContentView);
        make.height.width.mas_equalTo(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
    }];
    
    [self.goodsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.desLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.width.mas_equalTo(48);
        make.centerY.equalTo(self.goodsContentView);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(5);
        make.bottom.equalTo(self.orderLabel.mas_top).offset(-10);
    }];
}





- (UIView *)bigContentView {
    if (!_bigContentView) {
        _bigContentView = [[UIView alloc]init];
        _bigContentView.backgroundColor = [UIColor whiteColor];
        _bigContentView.xk_openClip = YES;
        _bigContentView.xk_radius = 5;
        _bigContentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _bigContentView;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        [_desLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"兑奖成功，请等待开奖。").font(XKRegularFont(14)).textColor(HEX_RGB(0x222222));
            confer.text(@"点击查看开奖详情").textColor(XKMainTypeColor).font(XKRegularFont(14));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
        [_desLabel addGestureRecognizer:tap];
        _desLabel.numberOfLines = 2;
        _desLabel.userInteractionEnabled = YES;
    }
    return _desLabel;
}



- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = XKRegularFont(14);
        _timeLabel.textColor = HEX_RGB(0xBBBBBB);
        _timeLabel.text = @"刚刚";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIView *)goodsContentView {
    if (!_goodsContentView) {
        _goodsContentView = [[UIView alloc]init];
        _goodsContentView.backgroundColor = HEX_RGB(0xF8F8F8);
        _goodsContentView.xk_openClip = YES;
        _goodsContentView.xk_radius = 5;
        _goodsContentView.xk_clipType = XKCornerClipTypeAllCorners;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsTap:)];
        [_goodsContentView addGestureRecognizer:tap];
    }
    return _goodsContentView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];

        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.layer.cornerRadius = 5;
        _imageV.layer.masksToBounds = YES;
    }
    return _imageV;
}

- (UILabel *)goodsTitleLabel {
    if (!_goodsTitleLabel ) {
        _goodsTitleLabel = [[UILabel alloc]init];
        _goodsTitleLabel.font = XKRegularFont(14);
        _goodsTitleLabel.textColor = HEX_RGB(0x222222);
        _goodsTitleLabel.text = @"在单项右上角处显示小红点，下次进入该页面时为已查看，不显示提";
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _goodsTitleLabel.numberOfLines = 2;
    }
    return _goodsTitleLabel;
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc]init];
        _orderLabel.font = XKRegularFont(14);
        _orderLabel.textColor = HEX_RGB(0x777777);
        _orderLabel.text = @"订单编号：1838847297974917947";
        _orderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderLabel;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIView alloc]init];
        _redPoint.backgroundColor = XKMainRedColor;
        _redPoint.xk_openClip = YES;
        _redPoint.xk_radius = 5;
        _redPoint.xk_clipType = XKCornerClipTypeAllCorners;
        _redPoint.hidden = YES;
    }
    return _redPoint;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}

- (void)labelTap:(UIGestureRecognizer *)sender {
    if (self.titleLabelTapBlock) {
        self.titleLabelTapBlock();
    }
    NSLog(@"taptap-------------------------");
}

- (void)goodsTap:(UIGestureRecognizer *)sender {
    if (self.goodsTapBlock) {
        self.goodsTapBlock();
    }
    NSLog(@"goodsTapgoodsTap-------------------------");
}
@end
