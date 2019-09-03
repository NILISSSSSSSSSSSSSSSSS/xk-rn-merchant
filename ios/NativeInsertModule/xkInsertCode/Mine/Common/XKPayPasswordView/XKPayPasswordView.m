//
//  XKPayPasswordView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPayPasswordView.h"
#import "XKPayPasswordViewCell.h"

#define kPayPasswordViewInputViewWidth 53.0 * ScreenScale
#define kPayPasswordViewInputViewheight 53.0 * ScreenScale

@interface XKPayPasswordView () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *payPasswordViewCellArr;
@property (nonatomic, strong) UITextField *hiddenTextField;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic, copy) NSString *currentString;
@property (nonatomic, assign) BOOL isHaveToolBar;

@end

@implementation XKPayPasswordView

/*
 * 初始化带toolbar视图
 */
+ (XKPayPasswordView *)addPayPasswordViewToView:(UIView *)view {
    
    XKPayPasswordView *payPasswordView = [self new];
    payPasswordView.backgroundColor = view.backgroundColor;
    payPasswordView.isHaveToolBar = YES;
    [view addSubview:payPasswordView];
    [payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kPayPasswordViewInputViewWidth * 6);
        make.height.mas_equalTo(kPayPasswordViewInputViewheight);
    }];
    [payPasswordView addPayPasswordViewCell];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:payPasswordView action:@selector(startInputPayPassword)];
    [payPasswordView addGestureRecognizer:tapGestureRecognizer];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    payPasswordView.hiddenTextField.inputAccessoryView = toolBar;
    toolBar.items = @[space, payPasswordView.confirmButton];
    return payPasswordView;
}

/*
 * 初始化不带toolbar视图
 */
+ (XKPayPasswordView *)addPayPasswordViewWithoutToolBarToView:(UIView *)view {
    
    XKPayPasswordView *payPasswordView = [self new];
    payPasswordView.backgroundColor = view.backgroundColor;
    payPasswordView.isHaveToolBar = NO;
    [view addSubview:payPasswordView];
    [payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kPayPasswordViewInputViewWidth * 6);
        make.height.mas_equalTo(kPayPasswordViewInputViewheight);
    }];
    [payPasswordView addPayPasswordViewCell];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:payPasswordView action:@selector(startInputPayPassword)];
    [payPasswordView addGestureRecognizer:tapGestureRecognizer];
    return payPasswordView;
}

- (void)startInputPayPassword {
    [self.hiddenTextField becomeFirstResponder];
}

- (void)stopInputPayPassword {
    [self.hiddenTextField resignFirstResponder];
}

- (void)addPayPasswordViewCell {
    
    XKPayPasswordViewCell *cellOne = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(0, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    [cellOne cutCornerWithRoundedRect:cellOne.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    XKPayPasswordViewCell *cellTwo = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(kPayPasswordViewInputViewWidth, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    XKPayPasswordViewCell *cellThree = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(kPayPasswordViewInputViewWidth * 2, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    XKPayPasswordViewCell *cellFour = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(kPayPasswordViewInputViewWidth * 3, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    XKPayPasswordViewCell *cellFive = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(kPayPasswordViewInputViewWidth * 4, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    XKPayPasswordViewCell *cellSix = [[XKPayPasswordViewCell alloc] initWithFrame:CGRectMake(kPayPasswordViewInputViewWidth * 5, 0, kPayPasswordViewInputViewWidth, kPayPasswordViewInputViewheight)];
    [cellSix cutCornerWithRoundedRect:cellSix.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    self.payPasswordViewCellArr = @[cellOne, cellTwo, cellThree, cellFour, cellFive, cellSix];
    
    for (XKPayPasswordViewCell *cell in self.payPasswordViewCellArr) {
        [self addSubview:cell];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location > 5) {
        return NO;
    }
    
    // 刷新cell中label
    XKPayPasswordViewCell *cell = self.payPasswordViewCellArr[range.location];
    [cell reloadPayPasswordViewCellWithInputString:string];
    
    // 刷新数据源
    NSString *currentString;
    if (string == nil || [string isEqualToString:@""]) {
        currentString = [textField.text substringToIndex:[textField.text length] - 1];
    } else {
        currentString = [textField.text stringByAppendingString:string];
    }
    self.currentString = currentString;
    if ([self.delegate respondsToSelector:@selector(payPasswordView:inputPasswordString:)]) {
        [self.delegate payPasswordView:self inputPasswordString:self.currentString];
    }
    
    // 带toolbar，完成按钮
    if (self.isHaveToolBar) {
        if (range.location == 5 && ![string isEqualToString:@""]) {
            self.confirmButton.tintColor = [UIColor blackColor];
            self.confirmButton.enabled = YES;
        } else {
            self.confirmButton.tintColor = [UIColor lightGrayColor];
            self.confirmButton.enabled = NO;
        }
        
    // 不带toolbar，自动完成
    } else {
        if (range.location == 5 && ![string isEqualToString:@""]) {
            [self.delegate payPasswordView:self didClickConfirmButton:self.confirmButton inputString:self.currentString];
        }
    }
    return YES;
}

- (void)clickConfirmButton:(UIBarButtonItem *)sender {
    [self.delegate payPasswordView:self didClickConfirmButton:sender inputString:self.currentString];
}

- (UITextField *)hiddenTextField {
    
    if (!_hiddenTextField) {
        _hiddenTextField = [UITextField new];
        _hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
        _hiddenTextField.hidden = YES;
        _hiddenTextField.delegate = self;
        [self addSubview:_hiddenTextField];
    }
    return _hiddenTextField;
}

- (UIBarButtonItem *)confirmButton {
    
    if (!_confirmButton) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickConfirmButton:)];
        _confirmButton.tintColor = [UIColor lightGrayColor];
        self.confirmButton.enabled = NO;
    }
    return _confirmButton;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
