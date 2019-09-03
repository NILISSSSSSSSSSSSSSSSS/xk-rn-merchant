//
//  XKRedEnvelopeGiftTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedEnvelopeGiftTableViewCell.h"

@interface XKRedEnvelopeGiftTableViewCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *giftImgView;

@property (nonatomic, strong) UILabel *numLab;

@end

@implementation XKRedEnvelopeGiftTableViewCell

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
        
        UIView *tempView = [[UIView alloc] init];
        [self.contentView addSubview:tempView];
        
        self.giftImgView = [[UIImageView alloc] init];
        self.giftImgView.contentMode = UIViewContentModeScaleAspectFill;
        [tempView addSubview:self.giftImgView];
        
        self.numLab = [[UILabel alloc] init];
        self.numLab.textAlignment = NSTextAlignmentRight;
        [tempView addSubview:self.numLab];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.width.mas_equalTo(140.0);
            make.height.mas_equalTo(32.0);
        }];
        
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.containerView);
            make.height.mas_equalTo(self.containerView);
        }];
        
        [self.giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(tempView);
            make.centerY.mas_equalTo(tempView);
            make.width.mas_equalTo(20.0);
            make.height.mas_equalTo(24.0);
        }];
        
        [self.numLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.giftImgView.mas_right).offset(10.0);
            make.top.bottom.mas_equalTo(tempView);
            make.trailing.mas_equalTo(tempView);
        }];
    }
    return self;
}

- (void)configCellWithImgUrl:(nullable NSString *)imgUrl num:(NSUInteger)num {
    if (imgUrl && imgUrl.length) {
        [self.giftImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.giftImgView.image = kDefaultPlaceHolderImg;
    }
    self.numLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"x").font(XKRegularFont(12.0)).textColor(HEX_RGB(0xE45A3B));
        confer.text([NSString stringWithFormat:@"%tu", num]).font(XKMediumFont(17.0)).textColor(HEX_RGB(0xE45A3B));
    }];
}

@end
