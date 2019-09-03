/*******************************************************************************
 # File        : XKInfoInputView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/6
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKInfoInputView.h"

@interface XKInfoInputView () <UITextFieldDelegate>
/**文本*/
@property(nonatomic, strong) UILabel *titleLabel;
/**输入框*/
@property(nonatomic, strong) UITextField *textField;
@end

@implementation XKInfoInputView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = HEX_RGB(0x222222);
    self.titleLabel.font = XKRegularFont(14);
    [self addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = HEX_RGB(0x2222222);
    self.textField.font = XKRegularFont(14);
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:
     UIControlEventEditingChanged];
    [self addSubview:self.textField];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(14);
        make.width.mas_equalTo(60 *ScreenScale);
        
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(25);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}


#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}

- (void)setType:(XKInfoInputViewType)type {
    _type = type;
    if (type == XKInfoInputViewTypeNormal) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else if (type == XKInfoInputViewTypePhone) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    } else if (type == XKInfoInputViewTypeIdCard) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else {
        
    }
}

#pragma mark - 代理
- (void)textFieldChange:(UITextField *)textField {
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 有高亮选择的字 则不搜索
        if (position) {
            return;
        }
    }
    NSInteger maxNum = 0;
    if (self.type == XKInfoInputViewTypeNormal) {
        maxNum = self.maxNum;
    } else if (self.type == XKInfoInputViewTypePhone) {
        maxNum = 11;
    } else if (self.type == XKInfoInputViewTypeIdCard) {
        maxNum = 18;
    }
    if (maxNum != 0 && textField.text.length > maxNum) {
        textField.text = [textField.text substringToIndex:maxNum];
    }
    EXECUTE_BLOCK(self.textChange,textField.text);
}

// textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // string.length为0，表明没有输入字符，应该是正在删除，应该返回YES。
    if (string.length == 0) {
        return YES;
    }
    if (self.type == XKInfoInputViewTypePhone) {
        return [self validateNumberByRegExp:string];
    } else if (self.type == XKInfoInputViewTypeIdCard) {
        // length为当前输入框中的字符长度
        NSUInteger length = textField.text.length;
        // 当输入到17位数的时候
        if (length == 17) {
            if ([self validateNumberByRegExp:string] || [string.lowercaseString isEqualToString:@"x"]) {
                return YES;
            }
            return NO;
        } else if (length < 17) {
            return [self validateNumberByRegExp:string];
        }
        // 如果是其他情况则直接返回小于等于18（最多输入18位）
        return length <= 18;
    }
    return YES;
}

// 限制只能输入数字
- (BOOL)validateNumberByRegExp:(NSString*)string {
    BOOL isValid = NO;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    if (self.type == XKInfoInputViewTypeIdCard) {
        NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789X"]
                                       invertedSet ];
        textField.text  = [[[textField.text  componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""] stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
    }
    EXECUTE_BLOCK(self.textChange,textField.text);
}

@end
