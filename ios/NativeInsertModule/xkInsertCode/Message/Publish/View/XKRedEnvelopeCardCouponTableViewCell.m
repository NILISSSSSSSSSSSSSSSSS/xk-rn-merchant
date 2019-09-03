//
//  XKRedEnvelopeCardCouponTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedEnvelopeCardCouponTableViewCell.h"

@interface XKRedEnvelopeCardCouponTableViewCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *numLab;

@end

@implementation XKRedEnvelopeCardCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = HEX_RGB(0xFFFAF4);
        [self.contentView addSubview:self.containerView];
        self.containerView.layer.cornerRadius = 6.0;
        self.containerView.layer.masksToBounds = YES;
        self.containerView.clipsToBounds = YES;
        self.containerView.layer.borderWidth = 1.0;
        self.containerView.layer.borderColor = HEX_RGB(0xFBE6D0).CGColor;
        
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = XKRegularFont(14.0);
        self.nameLab.textColor = HEX_RGB(0xE17862);
        [self.containerView addSubview:self.nameLab];
        
        self.numLab = [[UILabel alloc] init];
        self.numLab.textAlignment = NSTextAlignmentRight;
        [self.containerView addSubview:self.numLab];
        
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.width.mas_equalTo(250.0);
            make.height.mas_equalTo(32.0);
        }];
        
        [self.nameLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.leading.mas_equalTo(10.0);
        }];
        
        [self.numLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.trailing.mas_equalTo(-10.0);
        }];
    }
    return self;
}

- (void)configCellWithName:(nullable NSString *)name num:(NSUInteger)num {
    self.nameLab.text = name;
    self.numLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"x").font(XKRegularFont(12.0)).textColor(HEX_RGB(0xE45A3B));
        confer.text([NSString stringWithFormat:@"%tu", num]).font(XKMediumFont(17.0)).textColor(HEX_RGB(0xE45A3B));
    }];
}

@end
