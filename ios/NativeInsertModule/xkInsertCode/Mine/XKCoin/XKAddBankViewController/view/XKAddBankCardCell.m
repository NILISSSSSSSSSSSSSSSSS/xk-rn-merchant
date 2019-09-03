//
//  XKAddBankCardCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAddBankCardCell.h"
#import "XKCommonStarView.h"

@interface XKAddBankCardCell ()<UITextFieldDelegate>

@property (nonatomic, strong) NSIndexPath       *indexPath;

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIView            *lineView;


@end

@implementation XKAddBankCardCell

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
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@80);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);

    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


- (void)setvalueWithDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = indexPath;
    self.textField.tag = indexPath.row;
    self.nameLabel.text = dic[@"title"];
    self.textField.placeholder = dic[@"place"];
    self.textField.text = dic[@"value"];
    if (indexPath.row == 0) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else {
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}

- (void)hiddenLineView:(BOOL)hiden {
    self.lineView.hidden = hiden;
}


#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //2 卡类型   4所属银行
    if (textField.tag == 2 || textField.tag == 4) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegete && [self.delegete respondsToSelector:@selector(textFieldSelected:)]) {
        [self.delegete textFieldSelected:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if (self.delegete && [self.delegete respondsToSelector:@selector(textFieldSelected:)]) {
//        [self.delegete textFieldSelected:textField];
//    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(textFieldSelected:)]) {
        [self.delegete textFieldSelected:textField];
    }
    return YES;
}




#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入充值的金额";
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField.textColor = HEX_RGB(0x555555);
    }
    return _textField;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



@end






