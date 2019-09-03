//
//  XKOrderDetailDecTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/11/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderDetailDecTableViewCell.h"

@interface XKOrderDetailDecTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UIView            *lineView;


@end

@implementation XKOrderDetailDecTableViewCell

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
        make.width.equalTo(@100);
        make.right.equalTo(self.decLabel.mas_left);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.nameLabel.mas_top);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
}


- (void)setValueWithName:(NSString *)name dec:(NSString *)dec {
    self.nameLabel.text = name;
    self.decLabel.text = dec;
    
    if (dec.length) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.width.equalTo(@100);
            make.right.equalTo(self.decLabel.mas_left);
        }];
        
        [self.decLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.nameLabel.mas_top);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        
    } else {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.width.equalTo(@100);
            make.right.equalTo(self.decLabel.mas_left);
            make.bottom.equalTo(self.contentView).offset(-15);

        }];
        [self.decLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.nameLabel);
        }];
    }
}

- (void)setDecTextColor:(UIColor *)color {
    if (color) {
        self.decLabel.textColor = color;
    }
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _decLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

@end


