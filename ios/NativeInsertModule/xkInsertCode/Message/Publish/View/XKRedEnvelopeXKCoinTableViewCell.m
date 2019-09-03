//
//  XKRedEnvelopeXKCoinTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedEnvelopeXKCoinTableViewCell.h"

@interface XKRedEnvelopeXKCoinTableViewCell ()

@property (nonatomic, strong) UILabel *numLab;

@end

@implementation XKRedEnvelopeXKCoinTableViewCell

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
        
        self.numLab = [[UILabel alloc] init];
        self.numLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numLab];
        
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configCellWithNum:(CGFloat)num {
    self.numLab.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text([NSString stringWithFormat:@"%.2f", num]).font(XKRegularFont(60.0)).textColor(HEX_RGB(0x222222));
        confer.text(@" ");
        confer.text(@"晓可币").font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
    }];
}

@end
