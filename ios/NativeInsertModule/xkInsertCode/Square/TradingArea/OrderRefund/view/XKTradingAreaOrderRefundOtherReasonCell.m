//
//  XKTradingAreaOrderRefundOtherReasonCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderRefundOtherReasonCell.h"

@interface XKTradingAreaOrderRefundOtherReasonCell ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UITextView        *textView;
@property (nonatomic, strong) UIView            *lineView;


@end

@implementation XKTradingAreaOrderRefundOtherReasonCell

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
    [self.contentView addSubview:self.textView];
//    [self.contentView addSubview:self.lineView];
    
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
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@115);

    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.contentView);
//        make.height.equalTo(@1);
//    }];
}



- (void)setNameLableText:(NSString *)text textColor:(UIColor *)textColor {
    
    self.nameLabel.text = text;
    self.nameLabel.textColor = textColor;
}



#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 20) {
        self.textView.text = [textView.text substringToIndex:20];
        [XKHudView showWarnMessage:@"已超出最大字符长度"];
    }
    if (self.valueChangedBlock) {
        self.valueChangedBlock(self.textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView endEditing:YES];
        return NO;
    }
    return YES;
}


#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x999999);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.placeholder = @"请输入原因";
        [_textView setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textView.delegate = self;
        _textView.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _textView.textColor = HEX_RGB(0x555555);
        _textView.backgroundColor = HEX_RGB(0xf1f1f1);
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}



- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


@end
