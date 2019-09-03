//
//  XKWelfareOrderWaitOpenTimeCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/31.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareOrderWaitOpenTimeCell.h"
#import "XKWelfareProgressView.h"
@interface XKWelfareOrderWaitOpenTimeCell ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView  *timeBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation XKWelfareOrderWaitOpenTimeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
//订单
- (void)bindData:(WelfareOrderDataItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;

    NSString *price = @(item.joinCount).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"兑奖注数：%@",price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttrString addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0xEE6161)
                            range:NSMakeRange(5, priceStr.length - 5)];
    _priceLabel.attributedText = priceAttrString;

    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:item.expectDrawTime];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",time];
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttrString addAttribute:NSForegroundColorAttributeName
                           value:XKMainTypeColor
                           range:NSMakeRange(3, timeStr.length - 3)];
    _timeLabel.attributedText = timeAttrString;
    
}

//购物车
- (void)handleDataModel:(XKWelfareBuyCarItem *)model hasLose:(BOOL)hasLose manangeModel:(BOOL)manangeModel {
    self.buyCarModel = model;
    
    if (hasLose) {//已失效  管理模式下结构不同
        self.sumView.hidden = YES;
        [self.loseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.choseBtn.mas_right).offset(5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(33, 18));
        }];
        if (manangeModel) {
            [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.bgContainView);
                make.width.mas_equalTo(40);
            }];
        } else {
            [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.bgContainView);
                make.width.mas_equalTo(0);
            }];

        }
    } else {//未失效
        self.sumView.hidden = NO;
        [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.bgContainView);
            make.width.mas_equalTo(40);
        }];
        
       
        
        [self.loseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.choseBtn.mas_right).offset(5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(0, 18));
        }];
        
    }
    self.sumView.inputTf.text = @(model.quantity).stringValue;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = model.name;
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByChineseSegmentWithTimestampString:@(model.drawTime).stringValue];
    self.timeLabel.text = [NSString stringWithFormat:@"开奖时间：%@分",[time substringFromIndex:12]];
    NSString *price = @(model.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"消费券：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, priceStr.length - 4)];
    self.priceLabel.attributedText = attrString;
    self.choseBtn.selected = model.selected;
}

- (void)bindItem:(XKWelfareBuyCarItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    
    NSString *price = @(item.quantity).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"兑奖注数：%@",price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttrString addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0xEE6161)
                            range:NSMakeRange(5, priceStr.length - 5)];
    _priceLabel.attributedText = priceAttrString;
    
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(item.drawTime).stringValue];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",time];
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttrString addAttribute:NSForegroundColorAttributeName
                           value:XKMainTypeColor
                           range:NSMakeRange(3, timeStr.length - 3)];
    _timeLabel.attributedText = timeAttrString;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.choseBtn];
    [self.bgContainView addSubview:self.loseBtn];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.priceLabel];
    [self.bgContainView addSubview:self.timeBgView];
    [self.timeBgView addSubview:self.timeLabel];
    
}


- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgContainView);
        make.width.mas_equalTo(0);
    }];
    
    [self.loseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choseBtn.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(0, 18));
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loseBtn.mas_right).offset(10);
        make.top.equalTo(self.bgContainView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left).offset(10);
        make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-15);
    }];
    
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(28);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBgView.mas_left).offset(10);
        make.right.equalTo(self.timeBgView.mas_right).offset(-5);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:XKRegularFont(14)];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:XKRegularFont(12)];
        _priceLabel.textColor = UIColorFromRGB(0x777777);
        
    }
    return _priceLabel;
}

- (UIView *)timeBgView {
    if (!_timeBgView) {
        _timeBgView = [UIView new];
        _timeBgView.backgroundColor = UIColorFromRGB(0xF0F6FF);
        _timeBgView.layer.cornerRadius = 3.f;
    }
    return _timeBgView;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:XKRegularFont(12)];
        _timeLabel.textColor = UIColorFromRGB(0x777777);
        _timeLabel.backgroundColor = UIColorFromRGB(0xF0F6FF);
    }
    return _timeLabel;
}

@end
