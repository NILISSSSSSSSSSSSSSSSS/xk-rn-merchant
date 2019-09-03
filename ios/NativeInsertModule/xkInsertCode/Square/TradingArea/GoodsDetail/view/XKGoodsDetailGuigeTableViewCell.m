//
//  XKGoodsDetailGuigeTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGoodsDetailGuigeTableViewCell.h"
#import "XKTradingAreaGoodsInfoModel.h"

@interface XKGoodsDetailGuigeTableViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *infoLabel;


@end

@implementation XKGoodsDetailGuigeTableViewCell

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
    
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.nameLabel];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.nameLabel);
    }];
}



#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"规格";
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _infoLabel.textColor = HEX_RGB(0x555555);
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.text = @"200g";
    }
    return _infoLabel;
}


- (void)setValuesWithModel:(GoodsModel *)model {
    
    self.infoLabel.text = model.defaultSkuName;
    
}


@end
