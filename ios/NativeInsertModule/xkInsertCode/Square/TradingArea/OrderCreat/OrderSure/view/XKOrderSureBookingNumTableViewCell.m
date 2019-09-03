//
//  XKOrderSureBookingNumTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderSureBookingNumTableViewCell.h"

@interface XKOrderSureBookingNumTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIImageView       *imgView;


@end

@implementation XKOrderSureBookingNumTableViewCell

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
    [self.contentView addSubview:self.imgView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@14);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView.mas_left).offset(-10);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@10);
        make.width.equalTo(@7);
        make.centerY.equalTo(self.nameLabel);
    }];
}


- (void)setvalueWithDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {

    
}


#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseBookingNumber:)]) {
        [self.delegate chooseBookingNumber:textField.text];
    }
    return NO;
}

- (void)setValueWithSeatNames:(NSString *)seatNames {
    self.textField.text = seatNames;
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"餐桌号";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = @"请选择您的餐桌号";
        [_textField setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.delegate = self;
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField.textColor = HEX_RGB(0x555555);
    }
    return _textField;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"];
    }
    return _imgView;
}


@end
