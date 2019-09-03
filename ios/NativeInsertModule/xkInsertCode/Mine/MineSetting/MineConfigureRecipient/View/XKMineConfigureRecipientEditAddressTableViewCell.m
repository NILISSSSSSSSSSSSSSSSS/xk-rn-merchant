//
//  XKMineConfigureRecipientEditAddressTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditAddressTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientEditAddressTableViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextView *addressTextView;

@property (nonatomic, strong) XKMineConfigureRecipientItem *recipientItem;

@end

@implementation XKMineConfigureRecipientEditAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureSubviews];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.addressTextView];
}

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem {

    self.recipientItem = recipientItem;
    if (recipientItem.street && ![recipientItem.street isEqualToString:@""]) {
        self.addressTextView.text = recipientItem.street;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)textViewEditChanged:(NSNotification *)notification {
    
    UITextView *textView = (UITextView *)notification.object;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字 则不搜索
        if (position) {
            return;
        }
    }
    NSInteger length = textView.text.length;
    if (length >= 101) {
        textView.text = [textView.text substringToIndex:100];
    }
    self.recipientItem.street = textView.text;
}

- (void)configureSubviews {
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];

    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_top).offset(-7);
        make.left.equalTo(self.addressLabel.mas_right).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.addressTextView];
    
    self.addressLabel.text = @"详细地址";
}

- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _addressLabel.numberOfLines = 1;
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UITextView *)addressTextView {
    
    if (!_addressTextView) {
        _addressTextView = [UITextView new];
        _addressTextView.delegate = self;
        _addressTextView.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _addressTextView.textColor = [UIColor darkGrayColor];
        _addressTextView.placeholder = @"请输入详细地址，例如街道、门牌号等";
        [self.contentView addSubview:_addressTextView];
    }
    return _addressTextView;
}

@end
