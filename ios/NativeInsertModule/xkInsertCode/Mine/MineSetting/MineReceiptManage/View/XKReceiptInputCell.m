/*******************************************************************************
 # File        : XKReceiptInputCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptInputCell.h"

@interface XKReceiptInputCell () <UITextFieldDelegate>
/**输入框*/
@property(nonatomic, strong) UITextField *textField;
@end

@implementation XKReceiptInputCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.font = XKRegularFont(14);
    [self.contentView addSubview:self.textField];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView.mas_height);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0.5);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setConfig:(XKReceiptInfoDataConfig *)config {
    [super setConfig:config];
    self.textField.placeholder = config.placeHolder;
    if (config.inputType == XKReceiptInfoInputTypeNormal) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else if (config.inputType == XKReceiptInfoInputTypeNum) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
         self.textField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setModel:(XKReceiptInfoModel *)model {
    [super setModel:model];
    [self showText];
}

- (void)showText {
    switch (self.cellType) {
        case XKReceiptInfoCellTypeTitle:
            self.textField.text = self.model.head;
            break;
        case XKReceiptInfoCellTypeTaxNum:
            self.textField.text = self.model.taxNo;
            break;
        case XKReceiptInfoCellTypeAddr:
            self.textField.text = self.model.address;
            break;
        case XKReceiptInfoCellTypeBank:
            self.textField.text = self.model.bankName;
            break;
        case XKReceiptInfoCellTypeBankNum:
            self.textField.text = self.model.bankAccount;
            break;
        default:
            self.textField.text = @"没写啊";
            break;
    }
}

- (void)resetText {
    switch (self.cellType) {
        case XKReceiptInfoCellTypeTitle:
            self.model.head = self.textField.text;
            break;
        case XKReceiptInfoCellTypeTaxNum:
            self.model.taxNo = self.textField.text;
            break;
        case XKReceiptInfoCellTypeAddr:
            self.model.address = self.textField.text ;
            break;
        case XKReceiptInfoCellTypeBank:
            self.model.bankName = self.textField.text;
            break;
        case XKReceiptInfoCellTypeBankNum:
            self.model.bankAccount = self.textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - 输入限制
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
    NSInteger maxNum = self.config.maxLengthNum;
    
    if (maxNum != 0 && textField.text.length > maxNum) {
        textField.text = [textField.text substringToIndex:maxNum];
    }
    [self resetText];
}

// textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // string.length为0，表明没有输入字符，应该是正在删除，应该返回YES。
    if (string.length == 0) {
        return YES;
    }
    if (self.config.inputType == XKReceiptInfoInputTypeNum) {
        return [self validateNumberByRegExp:string];
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
    if (self.config.inputType == XKReceiptInfoInputTypeNum) {
        NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                       invertedSet ];
        textField.text  = [[textField.text  componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    }
    self.textField.text = [self.textField.text removeBeforeEndEnterAndSpacesChar];
    [self resetText];
}

@end
