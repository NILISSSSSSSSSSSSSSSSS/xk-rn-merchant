//
//  XKOnlineOderDetailOrderInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOderDetailOrderInfoCell.h"

@interface XKOnlineOderDetailOrderInfoCell ()

@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *decLabel;
@property (nonatomic, strong) UIView   *lineView;

@end

@implementation XKOnlineOderDetailOrderInfoCell

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

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.nameLabel.mas_top);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
}


#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString *content = @"配送服务\n配送时间\n配送地址";
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        _nameLabel.attributedText = contentString;
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString *content = @"商家配送\n立即配送\n杨先生(13873894050)\n成都市高新区益州大道559号";
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        _decLabel.attributedText = contentString;
    }
    return _decLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


@end
