/*******************************************************************************
 # File        : CommentInputView.m
 # Project     : ErpApp
 # Author      : Jamesholy
 # Created     : 2018/2/8
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentInputView.h"
#import <IQKeyboardManager.h>
#import <BlocksKit+UIKit.h>
#import "CMInputView.h"
#import "XKIMEmojiKeyBoard.h"
#import "XKEmotionKeyBoradManager.h"

#define kInputOriginHeight 36
#define kIphoneXInputBtm (iPhoneX_Serious ? 20 : 0)

static NSString *RAND_INPU_TAG;

@interface XKCommentInputView ()<UITextViewDelegate,XKEmojiKeyboardViewDelegate>
/**bgView*/
@property(nonatomic, strong) UIButton *bgView;
/**<##>*/
@property(nonatomic, strong) UIButton *emojiBtn;
/**textView*/
@property(nonatomic, strong) CMInputView *inputView;
/**按钮*/
@property(nonatomic, strong) UIButton *sendButton;
@property(nonatomic, strong) UIView *emojiKeyboardContainView;
/**<##>*/
@property(nonatomic, strong) XKIMEmojiKeyBoard *emojiKeyboardView;
/**@文本*/
@property(nonatomic, copy) NSString *atStr;
/***/
@property(nonatomic, copy) NSString *viewId;
@end

@implementation XKCommentInputView

+ (instancetype)inputView{
    XKCommentInputView *inputView =  [[XKCommentInputView alloc] initWithFrame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 49 + kIphoneXInputBtm)];
    return inputView;
}

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

- (void)setAutoHidden:(BOOL)autoHidden {
    _autoHidden = autoHidden;
    self.hidden = YES;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    self.viewId = [NSString stringWithFormat:@"%d%@",arc4random()%100,[XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]]];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc {
    NSLog(@"IKInputTextView嗝屁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化界面
- (void)createUI {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowColor = RGBGRAY(100).CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.4;
    
    self.bgView = [UIButton new];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView bk_addEventHandler:^(id sender) {
        [weakSelf endEditing];
    } forControlEvents:UIControlEventTouchUpInside];
    
    _emojiBtn = [[UIButton alloc] init];
    _emojiBtn.tintColor = XKMainTypeColor;
    [_emojiBtn setBackgroundImage:[[UIImage imageNamed:@"xk_btn_IM_toolbar_emoji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_emojiBtn setBackgroundImage:[[UIImage imageNamed:@"xk_btn_IM_toolbar_emoji"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [_emojiBtn addTarget:self action:@selector(emojiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emojiBtn];
    /**textView*/
    _inputView = [[CMInputView alloc]init];

    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.placeholder = @"请输入评论";
    _inputView.layer.cornerRadius = 2;
    _inputView.layer.borderWidth = 1;
    _inputView.layer.borderColor = RGBGRAY(231).CGColor;
    _inputView.backgroundColor = RGBGRAY(247);
    _inputView.delegate = self;
    _inputView.placeholderColor = RGBGRAY(204);
    _inputView.placeholderFont = [UIFont systemFontOfSize:14];
    _inputView.returnKeyType = UIReturnKeySend;
    WEAK_TYPES(_inputView);
    // 设置文本框最大行数
    [_inputView textValueDidChanged:^(NSString *text, CGFloat textHeight, BOOL heightChange,CMInputView *inptView) {
        if (heightChange) {
            [weak_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(textHeight);
            }];
            [weakSelf resetSelfViewByInputViewHeight:textHeight];
        }
        if (![[weakSelf getRealText] isExist]) {
            weakSelf.sendButton.userInteractionEnabled = NO;
            weakSelf.sendButton.backgroundColor = RGBGRAY(220);
        } else {
            weakSelf.sendButton.userInteractionEnabled = YES;
            weakSelf.sendButton.backgroundColor = RGB(56, 140, 255);
        }
        EXECUTE_BLOCK(weakSelf.textChange,[weakSelf getRealText]);
    }];
    _inputView.maxNumberOfLines = 4;
    [self addSubview:_inputView];
    
    /**按钮*/
    _sendButton = [[UIButton alloc] init];
    _sendButton.titleLabel.font = XKMediumFont(14);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:RGBGRAY(51) forState:UIControlStateNormal];
    _sendButton.backgroundColor = RGB(56, 140, 255);
    _sendButton.layer.cornerRadius = 3;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

#pragma mark - 逻辑-------------

#pragma mark - 开启响应
- (void)beginEditing {
   [IQKeyboardManager sharedManager].enable = NO;
    if (self.autoHidden) {
        self.hidden = NO;
    }
    RAND_INPU_TAG = self.viewId;
    [_inputView becomeFirstResponder];
}

#pragma mark - 背景点击结束响应
- (void)endEditing {
    if (self.autoHidden) {
        self.hidden = YES;
    }
    if (self.emojiBtn.selected == YES) { // 表情键盘状态
        [self hideEmojiWithKeyBoradResponder:NO];
        [self resignTextInput];
    } else {
        [KEY_WINDOW endEditing:YES];
//        [self.inputView resignFirstResponder];
    }
}

#pragma mark - 文本变化
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""] && range.length == 1 ){
        //非选择删除
        return [self onTextDelete];
    }
    if ([text isEqualToString:@"\n"]) { //获取键盘中发送事件（回车事件）
        [self sendClick];  //处理键盘的发送事件
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    RAND_INPU_TAG = self.viewId;
    return YES;
}

#pragma mark - 得到真正的输入
- (NSString *)getRealText {
    return [_inputView.text removeBeforeEndEnterAndSpacesChar];;
}

#pragma mark - emoji切换点击事件
- (void)emojiBtnClick {
    if (_emojiBtn.selected == NO) { // 当前文字
        [self showEmoji];
    } else { // 当前表情
        [self hideEmojiWithKeyBoradResponder:YES];
    }
    RAND_INPU_TAG = self.viewId;
}

//显示emoji键盘
- (void)showEmoji {
    _emojiBtn.selected = YES;
    [_inputView resignFirstResponder];
    self.bgView.frame = self.superview.bounds;
    [self.superview addSubview:self.bgView];
    [self.superview bringSubviewToFront:self];
    [self.superview addSubview:self.emojiKeyboardContainView];
    [UIView animateWithDuration:0.28 animations:^{
        self.emojiKeyboardContainView.transform =  CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.emojiKeyboardContainView.height);
    }];
    _emojiKeyboardView.enableSend =  self.inputView.text.length ? YES:NO;
}

// 隐藏emoji键盘 是否打开输入相应
- (void)hideEmojiWithKeyBoradResponder:(BOOL)ResponderStatus {
    _emojiBtn.selected = NO;
    if (ResponderStatus) {
        self.emojiKeyboardContainView.transform =  CGAffineTransformMakeTranslation(0,self.emojiKeyboardContainView.height);
    } else {
        [UIView animateWithDuration:0.3 animations:^{
                      self.emojiKeyboardContainView.transform =  CGAffineTransformMakeTranslation(0,self.emojiKeyboardContainView.height);
        } completion:^(BOOL finished) {

            [self.emojiKeyboardContainView removeFromSuperview];
        }];
    }
    if (ResponderStatus) {
        [_inputView becomeFirstResponder];
    }
}

#pragma mark - 发布按钮点击
- (void)sendClick {
    EXECUTE_BLOCK(self.sureClick, [self getRealText]);
}

#pragma mark - 收起输入框
- (void)resignTextInput {
    [self.bgView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (self.autoHidden) {
            self.hidden = YES;
        }
    }];
}

#pragma mark - keyBoard
- (void)keyboardShow:(NSNotification*)aNotification {
    if (![RAND_INPU_TAG isEqualToString:self.viewId]) {
        return;
    }
    NSDictionary *dict = [aNotification userInfo];
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardrect = [value CGRectValue];
    int height = keyboardrect.size.height;
    self.bgView.frame = self.superview.bounds;
    if (_emojiKeyboardContainView) {
        [self hideEmojiWithKeyBoradResponder:NO];
    }
    self.bgView.frame = self.superview.bounds;
    [self.superview addSubview:self.bgView];
    [self.superview insertSubview:self.bgView belowSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)keyBoardHide:(NSNotification*)aNotification {
    if (self.emojiBtn.selected == YES) {
        //
    } else {
        [self resignTextInput];
    }
}


#pragma mark - 布局界面

#pragma mark - 设置回复文本
- (void)setAtUserName:(NSString *)userName {
    _atStr = userName;
    if (userName.length == 0) {
        _inputView.placeholder = @"说点什么";
    } else {
        _inputView.placeholder = [NSString stringWithFormat:@"回复%@",userName];
    }
}

#pragma mark - 设置回复文本
- (void)setPlaceHolderText:(NSString *)text {
    if (text.length == 0) {
        _inputView.placeholder = @"";
    } else {
        _inputView.placeholder = text;
    }
}

- (void)setOriginText:(NSString *)orignText {
    _inputView.text = orignText;
    [self.inputView resetFrameForSettingTextByself];
}

- (void)setSendBtnText:(NSString *)sendBtnText {
    [_sendButton setTitle:sendBtnText forState:UIControlStateNormal];
}

- (void)createConstraints {
    [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sendButton.mas_centerY);
        make.left.equalTo(self.mas_left).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emojiBtn.mas_right).offset(8);
        make.height.mas_equalTo(kInputOriginHeight);
        make.right.equalTo(self.sendButton.mas_left).offset(-13);
        make.bottom.equalTo(self.mas_bottom).offset(-(49 - kInputOriginHeight) / 2.0 - kIphoneXInputBtm);
    }];
    
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-6 - kIphoneXInputBtm);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 35));
    }];
}

- (void)resetSelfViewByInputViewHeight:(CGFloat)height {
    CGFloat tmpBtmY = self.bottom;
    self.height = height + 13 + kIphoneXInputBtm;
    self.bottom = tmpBtmY;
}

- (UIView *)emojiKeyboardContainView {
    if (!_emojiKeyboardContainView) {
        _emojiKeyboardContainView = [[UIView alloc] init];
        _emojiKeyboardContainView.backgroundColor = [UIColor whiteColor];
        [_emojiKeyboardContainView addSubview:self.emojiKeyboardView];
        _emojiKeyboardContainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.emojiKeyboardView.height + kBottomSafeHeight);
        _emojiKeyboardContainView.bottom = self.superview.height;
        _emojiKeyboardContainView.transform =  CGAffineTransformMakeTranslation(0,_emojiKeyboardContainView.height);
    }
    return _emojiKeyboardContainView;
}

- (XKIMEmojiKeyBoard *)emojiKeyboardView {
    if (!_emojiKeyboardView) {
        _emojiKeyboardView = [[XKIMEmojiKeyBoard alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
        _emojiKeyboardView.delegate = self;
    }
    return _emojiKeyboardView;
}

#pragma mark - 表情代理

//点击了表情
- (void)xkEmojiKeyBoardView:(XKIMEmojiKeyBoard *)emojiKeyBoardView
                didUseEmoji:(NSString *)emoji {
    NSRange range = self.inputView.selectedRange;
    NSString *replaceText = [self.inputView.text stringByReplacingCharactersInRange:range withString:emoji];
    range = NSMakeRange(range.location + emoji.length, 0);
    self.inputView.text = replaceText;
    self.inputView.selectedRange = range;
    emojiKeyBoardView.enableSend = replaceText.length ? YES:NO;
    [self.inputView resetFrameForSettingTextByself];
}

//点击了删除按钮
- (void)xkEmojiKeyBoardViewDidPressBackSpace:(XKIMEmojiKeyBoard *)emojiKeyBoardView {
    BOOL isText = [self onTextDelete];
    if (isText) {
         [self.inputView deleteBackward];
    }
    emojiKeyBoardView.enableSend =  self.inputView.text.length ? YES:NO;
}

//点击了发送按钮
-(void)xkEmojiKeyBoardPressSendButton:(XKIMEmojiKeyBoard *)emojiKeyBoardView{
    [self sendClick];
}

- (BOOL)onTextDelete
{
    NSRange range = [self delRangeForEmoticon];
    if (range.length == 1) {
        //自动删除
        return YES;
    }
    [self deleteText:range];
    return NO;
}

- (void)deleteText:(NSRange)range
{
    NSString *text = self.inputView.text;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self.inputView setText:newText];
        self.inputView.selectedRange = newSelectRange;
    }
}

- (NSRange)delRangeForEmoticon
{
    NSString *text = self.inputView.text;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self.inputView selectedRange];
    if (range.length > 1)
    {
        NSString *name = [text substringWithRange:range];
        //        NIMInputEmoticon *icon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:name];
        NSString *iconName = [[XKEmotionKeyBoradManager sharedInstance]emoticonNameByDesc:name];
        range = iconName? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    return range;
}

- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSString *text = self.inputView.text;
    NSRange range = [self.inputView selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        //往前搜最多20个字符，一般来讲是够了...
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    return index == -1? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}


@end

@implementation XKCommentInputInfo

@end
