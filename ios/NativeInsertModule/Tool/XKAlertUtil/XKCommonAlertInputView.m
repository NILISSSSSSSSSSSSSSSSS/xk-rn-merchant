/*******************************************************************************
 # File        : CommonAlertInputView.h
 # Project     : Erp4iOS
 # Author      : Jamesholy
 # Created     : 2017/9/18
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommonAlertInputView.h"
#import <Masonry/Masonry.h>
#import <XKCommonDefine.h>
#import <NSString+Utils.h>
#import <UIView+YYAdd.h>
#import <UIFont+XKFont.h>

#define kViewSize6(x) x
#pragma mark - 宏定义
#define BUTTON_TAG 100
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface XKCommonAlertInputView ()

@property (nonatomic, copy) LeftClickBlock leftActionBlock;// 标题
@property (nonatomic, copy) RightClickBlock rightActionBlock;
@property (nonatomic, copy) CloseClickBlock closeActionBlock;
@property (nonatomic, copy) DismissClickBlock dismissActionBlock;

@property (nonatomic, copy) NSString *titleStr;// 标题
@property (nonatomic, copy) NSString *messageStr;// 内容
@property (nonatomic, copy) NSString *leftBtnStr;// 左边按钮文字
@property (nonatomic, copy) NSString *rightBtnStr;// 右边按钮文字
@property (nonatomic, copy) NSString *placeHolder;// 左边按钮文字
@property (nonatomic, assign) NSInteger maxNum;// 右边按钮文字
@property(nonatomic, strong) UIColor *rightButtonColor; // 右边文字颜色
@property(nonatomic, assign) BOOL beginFirstResponder; // 右边文字颜色

@property (nonatomic, strong) UILabel *titleLabel;// 标题Label
@property (nonatomic, strong) UITextField *messageTextView;// 内容textfield
@property (nonatomic, strong) UIButton *leftButton;// 左边按钮
@property (nonatomic, strong) UIButton *rightButton;// 右边按钮
@property (nonatomic, strong) UIView *containerView;// 容器view

@property (nonatomic, assign) BOOL isBackgroundViewTaped;// 背景是否可以点击消失
@property (nonatomic, strong) UIButton *closeButton;// 关闭按钮


@end

@implementation XKCommonAlertInputView
#pragma mark - 初始化


- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftClickBlock)leftBlock rightBlock:(RightClickBlock)rightBlock isBeginFirstResponder:(BOOL)beginFirstResponder {
    return [[XKCommonAlertInputView alloc] initWithTitle:title placeHolder:placeHolder maxNum:maxNum message:messageString leftButton:leftButtonString rightButton:rightButtonString leftBlock:leftBlock rightBlock:rightBlock closeBlock:nil isBeginFirstResponder:beginFirstResponder];
}

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder maxNum:(NSInteger)maxNum message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftClickBlock)leftBlock rightBlock:(RightClickBlock)rightBlock  closeBlock:(CloseClickBlock)closeBlock isBeginFirstResponder:(BOOL)beginFirstResponder {
    self = [super init];
    if (self) {
        [self addNoti];
        _beginFirstResponder = beginFirstResponder;
        _isBackgroundViewTaped = NO;
        _titleStr = title;
        _placeHolder = placeHolder;
        _maxNum = maxNum;
        _messageStr = messageString;
        _leftBtnStr = leftButtonString;
        _rightBtnStr = rightButtonString;
        _leftActionBlock = [leftBlock copy];
        _rightActionBlock = [rightBlock copy];
        _closeActionBlock = [closeBlock copy];
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化界面
- (void)initUI {
    // 背景颜色
    self.backgroundColor = RGBA(0, 0, 0, 0.4);
    UIColor *themeColor = RGB(51, 150, 251);
    // 手势view
    UIView *tapGestureView = [[UIView alloc] init];
    tapGestureView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapGestureView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTaped)];
    [tapGestureView addGestureRecognizer:tapGesture];
    
    // 容器view
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 10;
    _containerView.hidden = YES;
    [self addSubview:_containerView];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = XKRegularFont(17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = RGBGRAY(51);
    _titleLabel.text = _titleStr;
    [_containerView addSubview:_titleLabel];
    
    // 内容
    _messageTextView = [[UITextField alloc] init];
    _messageTextView.placeholder = _placeHolder;
    _messageTextView.textAlignment = NSTextAlignmentCenter;
//    _messageTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _messageTextView.borderStyle = UITextBorderStyleRoundedRect;
    if (_messageStr.length == 0) {
        _messageStr = nil;
    }
    [_messageTextView addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    __weak typeof(self) weakSelf = self;;
    _messageTextView.text = _messageStr;

    
    [_containerView addSubview:_messageTextView];
    
    // 横向分割线
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = RGB(221, 221, 221);
    [_containerView addSubview:hLine];
    
    // 左边按钮
    _leftButton = [[UIButton alloc] init];
    _leftButton.tag = BUTTON_TAG+0;
    _leftButton.backgroundColor = [UIColor clearColor];
    _leftButton.titleLabel.font = XKRegularFont(18);
    [_leftButton setTitleColor:themeColor forState:UIControlStateNormal];
    [_leftButton setTitle:_leftBtnStr forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_leftButton];
    
    // 右边按钮
    _rightButton = [[UIButton alloc] init];
    _rightButton.tag = BUTTON_TAG+1;
    _rightButton.backgroundColor = [UIColor clearColor];
    _rightButton.titleLabel.font = XKRegularFont(18);
    [_rightButton setTitle:_rightBtnStr forState:UIControlStateNormal];
    _rightButtonColor = themeColor;
    [_rightButton setTitleColor:_rightButtonColor forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_rightButton];
    if (_messageStr.length == 0) {
        _rightButton.userInteractionEnabled = NO;
//        [_rightButton setTitleColor:RGBGRAY(155) forState:UIControlStateNormal];
    }
    // 竖向分割线
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = RGB(221, 221, 221);
    [_containerView addSubview:vLine];
    if (_leftBtnStr == nil) {
        _leftButton.hidden = YES;
        vLine.hidden = YES;
    } else if (_rightBtnStr == nil) {
        _rightButton.hidden = YES;
        vLine.hidden = YES;
    }
    
    // 关闭按钮
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.hidden = NO;
    [_containerView addSubview:_closeButton];
    
    // 添加约束
    
    [tapGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((375-100) * ScreenScale);
        make.center.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(20);
        make.centerX.equalTo(self.containerView);
//        make.bottom.equalTo(self.messageTextView.mas_top).offset(21);
    }];
 
    CGFloat messageTextViewBtm = 21;
    [_messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.titleStr) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(21);
        } else {
            make.top.equalTo(weakSelf.containerView.mas_top).offset(27);
        }
        make.left.equalTo(weakSelf.containerView.mas_left).offset(30);
        make.right.equalTo(weakSelf.containerView.mas_right).offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(hLine.mas_top).offset(-messageTextViewBtm);
    }];
    
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.messageTextView.mas_bottom).offset(27);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(0.5);
        if (!self.leftBtnStr && !self.rightBtnStr) {
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.containerView.mas_bottom);
        } else {
            make.bottom.equalTo(self.leftButton.mas_top);
            make.bottom.equalTo(self.rightButton.mas_top).priority(500);
        }
        
    }];
    CGFloat rightButtonH = kViewSize6(45);
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(hLine.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
        if (self.rightBtnStr == nil) {
            make.right.equalTo(self.containerView.mas_right);
        } else {
            make.right.equalTo(vLine.mas_left);
        }
        
        make.height.mas_equalTo(rightButtonH);
    }];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine.mas_bottom);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(0.5,45));
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine.mas_bottom);
        if (self.leftBtnStr == nil) {
            make.left.equalTo(self.containerView.mas_left);
        } else {
            make.left.equalTo(vLine.mas_right);
        }
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.mas_equalTo(rightButtonH);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kViewSize6(4));
        make.right.equalTo(self.containerView.mas_right).offset(-kViewSize6(4));
        make.size.mas_equalTo(CGSizeMake(kViewSize6(35), kViewSize6(35)));
    }];
}

- (void)textChange:(UITextField *)textField {
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
    NSString *text = textField.text;
    if (text.length == 0 || ![text isExist]) {
//        [self.rightButton setTitleColor:RGBGRAY(155) forState:UIControlStateNormal];
        self.rightButton.userInteractionEnabled = NO;
    } else {
//        [self.rightButton setTitleColor:self.rightButtonColor forState:UIControlStateNormal];
        self.rightButton.userInteractionEnabled = YES;
    }
    if (textField.text.length > self.maxNum) {
        textField.text = [textField.text substringToIndex:self.maxNum];
    }
}

#pragma mark - 按钮点击Action
- (void)buttonAction:(UIButton *)sender {
    NSInteger flag = sender.tag - BUTTON_TAG;
    if (flag == 0) {// 左边按钮
        EXECUTE_BLOCK(_leftActionBlock,_messageTextView.text);
    } else {// 右边按钮
        EXECUTE_BLOCK(_rightActionBlock,_messageTextView.text);
    }
    [self dismiss];
}

#pragma mark - 背景点击消失
- (void)bgTaped {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_isBackgroundViewTaped) {
        EXECUTE_BLOCK(_leftActionBlock,nil);
        [self dismiss];
    } else {
        return;
    }
}

#pragma mark - 关闭按钮
- (void)closeButtonAction {
    EXECUTE_BLOCK(_closeActionBlock);
    [self dismiss];
}

#pragma mark - 移除self
- (void)dismiss {
    
    EXECUTE_BLOCK(_dismissActionBlock);
    [self removeFromSuperview];
}

#pragma mark - 从superview移除
- (void)viewRemoveFromSuperView {
    _containerView.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - ----------------暴露的只读属性----------------
#pragma mark - 内容信息
- (NSString *)message {
    return _messageStr;
}

#pragma mark - ----------------暴露的公用方法----------------
#pragma mark - 弹框
- (void)show {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03, 1.03, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.97, 0.97, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.containerView.layer addAnimation:animation forKey:nil];
    self.containerView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.containerView.alpha = 1;
    }];
    CGFloat al = self.alpha;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = al;
    }];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [keyWindow addSubview:self];
    _containerView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        if (self.beginFirstResponder) {
            [self.messageTextView becomeFirstResponder];
        }
    });
}

#pragma mark - 设置左边按钮颜色
- (void)setLeftButtonColor:(UIColor *)color {
    if (color) {
        [_leftButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - 设置右边按钮颜色
- (void)setRightButtonColor:(UIColor *)color {
    if (color) {
        _rightButtonColor = color;
        [_rightButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - 设置标题颜色
- (void)setTitleColor:(UIColor *)color {
    if (color) {
        _titleLabel.textColor = color;
    }
}

#pragma mark - 设置背景颜色
- (void)setBGColor:(UIColor *)color {
    if (color) {
        self.backgroundColor = color;
    }
}

#pragma mark - 设置背景是可以点击消失
- (void)setBackgroundViewCouldTaped:(BOOL)isTaped {
    _isBackgroundViewTaped = isTaped;
}

#pragma mark - 设置是否隐藏关闭按钮
- (void)setCloseButtonHidden:(BOOL)isHidden {
    _closeButton.hidden = isHidden;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)dealloc {
    NSLog(@"CommonAlertInputView销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘通知
- (void)addNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *dict=[aNotification userInfo];
    NSValue *value=[dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    int height = keyboardrect.size.height;
    // 超过键盘即可
    CGFloat hiddenArea =  _containerView.bottom - (SCREENHEIGHT - height);
    if (hiddenArea > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -hiddenArea);
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}
@end

