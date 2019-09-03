//
//  XKReceiveXKCardTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKReceiveXKCardTableViewCell.h"
#import "XKReceiveCardModel.h"

@interface XKReceiveXKCardTableViewCell ()

@property (nonatomic, strong) UIImageView *cardImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *discountLabel;

@property (nonatomic, strong) UIButton *operationBtn;


@property (nonatomic, strong) XKReceiveCardModel *XKCard;

@end

@implementation XKReceiveXKCardTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cardImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.cardImgView];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.text = @"有效期";
        self.dateLabel.font = XKRegularFont(10.0);
        self.dateLabel.textColor = HEX_RGB(0xf3f3f3);
        [self.cardImgView addSubview:self.dateLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.cardImgView addSubview:self.titleLabel];
        
        self.discountLabel = [[UILabel alloc] init];
        self.discountLabel.text = @"折扣";
        self.discountLabel.textColor = HEX_RGB(0xffffff);
        self.discountLabel.textAlignment = NSTextAlignmentRight;
        [self.cardImgView addSubview:self.discountLabel];
        
        self.operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.operationBtn.titleLabel.font = XKRegularFont(14.0);
        [self.operationBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.operationBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [self.operationBtn setTitleColor:HEX_RGB(0xF1F7FF) forState:UIControlStateDisabled];
        [self.cardImgView addSubview:self.operationBtn];
        self.operationBtn.layer.cornerRadius = 12.0;
        self.operationBtn.layer.masksToBounds = YES;
        
        [self.cardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0));
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15.0);
            make.bottom.mas_equalTo(-8.0);
            make.trailing.mas_equalTo(self.cardImgView.mas_centerX).offset(50.0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.cardImgView);
            make.leading.trailing.mas_equalTo(self.dateLabel);
            make.height.mas_equalTo(40.0);
        }];
        
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4.0);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-15.0);
            make.height.mas_equalTo(40.0);
        }];
        
        [self.operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15.0);
            make.bottom.mas_equalTo(-15.0);
            make.width.mas_equalTo(62.0);
            make.height.mas_equalTo(24.0);
        }];
    }
    return self;
}

- (void)configCellWithCardModel:(XKReceiveCardModel *)XKCard {
    self.XKCard = XKCard;
    if (self.XKCard.isXKCard) {
        self.cardImgView.image = IMG_NAME(@"xk_bg_company_card");
    } else {
        self.cardImgView.image = IMG_NAME(@"xk_bg_terminal_card");
    }
    BOOL isFree = NO;
    if (isFree) {
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:self.XKCard.name];
        [titleStr addAttribute:NSFontAttributeName value:XKMediumFont(22.0) range:NSMakeRange(0, titleStr.length)];
        [titleStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFFFC7B) range:NSMakeRange(0, titleStr.length)];
        self.titleLabel.attributedText = titleStr;
    } else {
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:self.XKCard.name];
        [nameStr addAttribute:NSFontAttributeName value:XKMediumFont(22.0) range:NSMakeRange(0, nameStr.length)];
        [nameStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFFFFFf) range:NSMakeRange(0, nameStr.length)];
        
        NSMutableAttributedString *prizeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", 100.0]];
        [prizeStr addAttribute:NSFontAttributeName value:XKMediumFont(18.0) range:NSMakeRange(0, prizeStr.length)];
        [prizeStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFFFC7B) range:NSMakeRange(0, prizeStr.length)];
        
        NSMutableAttributedString *unitStr = [[NSMutableAttributedString alloc] initWithString:@"元"];
        [unitStr addAttribute:NSFontAttributeName value:XKMediumFont(12.0) range:NSMakeRange(0, unitStr.length)];
        [unitStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFFFC7B) range:NSMakeRange(0, unitStr.length)];
        
        [titleStr appendAttributedString:nameStr];
        [titleStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        [titleStr appendAttributedString:prizeStr];
        [titleStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        [titleStr appendAttributedString:unitStr];
        self.titleLabel.attributedText = titleStr;
    }
    self.dateLabel.text = [NSString stringWithFormat:@"有效期 %@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.XKCard.validTime)]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%@", @(self.XKCard.invalidTime)]]];
    self.discountLabel.text = self.XKCard.discount;
    [self.operationBtn setTitleColor:self.XKCard.isXKCard ? XKMainTypeColor : HEX_RGB(0xFF7E00) forState:UIControlStateNormal];
    [self.operationBtn setTitleColor:HEX_RGB(0xF1F7FF) forState:UIControlStateDisabled];
    if (!isFree) {
//        需要购买
        [self.operationBtn setTitle:@"购买" forState:UIControlStateNormal];
        [self.operationBtn setTitle:@"已购买" forState:UIControlStateDisabled];
        self.operationBtn.enabled = !self.XKCard.isBought;
        self.operationBtn.backgroundColor = self.XKCard.isBought ? HEX_RGBA(0x4A90FA, 0.56) : HEX_RGB(0xffffff);
    } else {
//        免费
        [self.operationBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.operationBtn setTitle:@"已领取" forState:UIControlStateDisabled];
        self.operationBtn.enabled = !self.XKCard.isReceived;
        self.operationBtn.backgroundColor = self.XKCard.isReceived ? HEX_RGBA(0x4A90FA, 0.56) : HEX_RGB(0xffffff);
    }
}

@end
