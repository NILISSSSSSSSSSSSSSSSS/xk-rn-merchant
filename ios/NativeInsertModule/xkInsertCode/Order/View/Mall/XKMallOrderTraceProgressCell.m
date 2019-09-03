//
//  XKMallOrderTraceProgressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderTraceProgressCell.h"

@interface XKMallOrderTraceProgressCell ()
@property (nonatomic, strong)UIView *cycleView;
@property (nonatomic, strong)UIView *topLineView;
@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *statusBtn;
@property (nonatomic, strong)YYLabel *addressLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong) NSMutableArray  *phoneArr;
@end

@implementation XKMallOrderTraceProgressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.xk_openClip = YES;
        self.xk_radius = 5;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _phoneArr = [NSMutableArray array];
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.cycleView];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.statusBtn];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)addUIConstraint {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(11);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.statusBtn.mas_bottom);
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(2);
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.cycleView.mas_bottom);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)bindModel:(XKOrderTransportInfoObj *)model isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
 //   self.addressLabel.text = model.location;
    self.timeLabel.text =  [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:model.time];
   
    if(isFirst) {
        [self.statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.top.equalTo(self.statusBtn.mas_bottom);
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-25);
        }];
        
        if(isLast) {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        } else {
        [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.cycleView.mas_bottom);
            make.width.mas_equalTo(1);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        }
         [self distinguishPhoneNumLabel:nil labelStr:model.location textColor:UIColorFromRGB(0x222222)]; ;
        
        _topLineView.alpha = 0;
        self.statusBtn.alpha = 1;
    } else {
        [self distinguishPhoneNumLabel:nil labelStr:model.location textColor:UIColorFromRGB(0x999999)];
        _topLineView.alpha = 1;
        self.statusBtn.alpha = 0;
        [self.statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 0));
        }];
        
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.top.equalTo(self.statusBtn.mas_bottom);
            make.left.equalTo(self.cycleView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-25);
        }];
        if(isLast) {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        } else {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }
    }
    

}


- (UIButton *)statusBtn {
    if(!_statusBtn) {
        _statusBtn = [[UIButton alloc] init];
        [_statusBtn setTitle:@"运送中" forState:0];
        _statusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _statusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_statusBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        _statusBtn.titleLabel.font = XKRegularFont(12);
        [_statusBtn setImage:[UIImage imageNamed:@"xk_ic_order_sending"] forState:0];
        _statusBtn.enabled = NO;
    }
    return _statusBtn;
}

- (YYLabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[YYLabel alloc] init];
        _addressLabel.font = XKRegularFont(12);
        _addressLabel.userInteractionEnabled = YES;
        _addressLabel.textColor = UIColorFromRGB(0x999999);
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = XKRegularFont(12);
        _timeLabel.textColor = UIColorFromRGB(0x999999);

    }
    return _timeLabel;
}

- (UIView *)cycleView {
    if(!_cycleView) {
        _cycleView = [[UIView alloc] init];
        _cycleView.layer.cornerRadius = 4.f;
        _cycleView.layer.masksToBounds = YES;
        _cycleView.backgroundColor = XKMainTypeColor;
    }
    return _cycleView;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _bottomLineView;
}

-(void)distinguishPhoneNumLabel:(UILabel *)label labelStr:(NSString *)labelStr textColor:(UIColor *)textColor{
    //获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRange stringRange = NSMakeRange(0, labelStr.length);
    //正则匹配
    NSError *error;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:labelStr];
    str.yy_color = textColor;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:labelStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
            
            [str yy_setTextHighlightRange:NSMakeRange(phoneRange.location, phoneRange.length) color:XKMainTypeColor backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",text];
                NSString *newStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newStr]]];
                [self addSubview:callWebview];
            }];
            
        }];
    }
   self.addressLabel.attributedText = str;
 
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 60, CGFLOAT_MAX) text:str];
    CGFloat commentHeight = layout.textBoundingSize.height;
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.statusBtn.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.height.mas_equalTo(commentHeight);
    }];
    
}




@end
