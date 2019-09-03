//
//  XKComplaintsTextViewTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKComplaintsTextViewTableViewCell.h"
@interface XKComplaintsTextViewTableViewCell()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *label;
@end
@implementation XKComplaintsTextViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}
- (void)initViews {
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.label];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@(-15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"4-250个字";
        _label.textColor = HEX_RGB(0x999999);
        _label.font = XKFont(XK_PingFangSC_Regular, 14);
        _label.textAlignment = NSTextAlignmentRight;
    }
    return _label;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        [_textView setBackgroundColor:[UIColor clearColor]];
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请发表您的宝贵意见";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = HEX_RGB(0x222222);
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        // same font
        _textView.font = [UIFont systemFontOfSize:14.f];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}
- (void)setTextViewDidEndEditingBlock:(textViewDidEndEditingBlock)block {
    self.block = block;
}
- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%@",textView.text);
    if (self.block) {
        self.block(textView.text);
    }
}

@end
