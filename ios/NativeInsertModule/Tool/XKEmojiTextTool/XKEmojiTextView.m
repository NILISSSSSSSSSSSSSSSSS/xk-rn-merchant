/*******************************************************************************
 # File        : XKEmojiTextView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/12/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKEmojiTextView.h"
#import "XKIMEmojiKeyBoard.h"
#import "XKEmotionKeyBoradManager.h"

@class XKEmojiBgView;
@protocol XKEmojiBgViewDelegate <NSObject>

@optional
- (void)bgViewClick:(XKEmojiBgView *)bgView;
@end

@interface XKEmojiBgView:UIView
/**<##>*/
@property(nonatomic, weak) id<XKEmojiBgViewDelegate> delegate;
@end

@implementation XKEmojiBgView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(bgViewClick:)]) {
        [self.delegate bgViewClick:self];
    }
    return nil;
}

@end

@class XKEmojiBgView;
@interface XKEmojiTextView () <XKEmojiKeyboardViewDelegate, XKEmojiBgViewDelegate>

/**<##>*/
@property(nonatomic, strong) UIView *toolView;
@property(nonatomic, strong) XKEmojiBgView *bgView;
@property(nonatomic, strong) UIView *emojiKeyboardContainView;
/**<##>*/
@property(nonatomic, strong) XKIMEmojiKeyBoard *emojiKeyboardView;
/**<##>*/
@property(nonatomic, assign) BOOL emojiShowStatus;

@end

@implementation XKEmojiTextView

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

- (void)dealloc {
    [_emojiKeyboardContainView removeFromSuperview];
    [_bgView removeFromSuperview];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.inputAccessoryView = self.toolView;
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;

}


#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark - 背景点击结束响应
- (void)endEditing {
    if (self.emojiShowStatus == YES) { // 表情键盘状态
        [self hideEmojiWithKeyBoradResponder:NO];
    } else {
        [KEY_WINDOW endEditing:YES];
    }
}

// 隐藏emoji键盘 是否打开输入相应
- (void)hideEmojiWithKeyBoradResponder:(BOOL)ResponderStatus {
    self.emojiShowStatus = NO;
    [self.bgView removeFromSuperview];
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
        [self becomeFirstResponder];
    }
}

#pragma mark - 收起输入框
- (void)resignTextInput {
    [self.bgView removeFromSuperview];
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [self creatToolView:NO];
    }
    return _toolView;
}

#pragma mark - emoji切换点击事件
- (void)emojiBtnClick:(UIButton *)emojiBtn {
    if (emojiBtn.selected == NO) { // 当前文字
        [self showEmoji];
    } else { // 当前表情
        [self hideEmojiWithKeyBoradResponder:YES];
    }
}

//显示emoji键盘
- (void)showEmoji {
    [self resignFirstResponder];
    self.emojiShowStatus = YES;
    self.bgView.frame = KEY_WINDOW.frame;
    [KEY_WINDOW addSubview:self.bgView];
    [KEY_WINDOW addSubview:self.emojiKeyboardContainView];
    [UIView animateWithDuration:0.28 animations:^{
        self.emojiKeyboardContainView.transform =  CGAffineTransformIdentity;
    }];
    _emojiKeyboardView.enableSend =  self.text.length ? YES:NO;
}


#pragma mark - 表情键盘代理
//点击了表情
- (void)xkEmojiKeyBoardView:(XKIMEmojiKeyBoard *)emojiKeyBoardView
                didUseEmoji:(NSString *)emoji {
    NSRange range = self.selectedRange;
    NSString *replaceText = [self.text stringByReplacingCharactersInRange:range withString:emoji];
    range = NSMakeRange(range.location + emoji.length, 0);
    self.text = replaceText;
    self.selectedRange = range;
    emojiKeyBoardView.enableSend = replaceText.length ? YES:NO;
    [self.delegate textViewDidChange:self];
}

//点击了删除按钮
- (void)xkEmojiKeyBoardViewDidPressBackSpace:(XKIMEmojiKeyBoard *)emojiKeyBoardView {
    BOOL isText = [self onTextDelete];
    if (isText) {
        [self deleteBackward];
    }
    emojiKeyBoardView.enableSend =  self.text.length ? YES:NO;
    [self.delegate textViewDidChange:self];
}

//点击了发送按钮
-(void)xkEmojiKeyBoardPressSendButton:(XKIMEmojiKeyBoard *)emojiKeyBoardView{
    [self endEditing];
}

#pragma mark - lazyload
- (XKEmojiBgView *)bgView {
    if (!_bgView) {
        _bgView = [[XKEmojiBgView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.delegate = self;
    }
    return _bgView;
}

- (void)bgViewClick:(XKEmojiBgView *)bgView {
    [self hideEmojiWithKeyBoradResponder:NO];
}

- (UIView *)creatToolView:(BOOL)selected {
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [view showBorderSite:rzBorderSitePlaceTop|rzBorderSitePlaceBottom];
    view.topBorder.borderLine.backgroundColor = RGBGRAY(151);
    view.topBorder.borderSize = 1.0 / [UIScreen mainScreen].scale;
    view.bottomBorder.borderLine.backgroundColor = RGBGRAY(151);
    view.bottomBorder.borderSize = 1.0 / [UIScreen mainScreen].scale;
    UIButton *emojiBtn = [[UIButton alloc] init];
    emojiBtn.tintColor = XKMainTypeColor;
    [emojiBtn setBackgroundImage:[[UIImage imageNamed:@"xk_btn_IM_toolbar_emoji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [emojiBtn setBackgroundImage:[[UIImage imageNamed:@"xk_btn_IM_toolbar_emoji"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [emojiBtn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:emojiBtn];
    emojiBtn.selected = selected;
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    return view;
    
}

- (UIView *)emojiKeyboardContainView {
    if (!_emojiKeyboardContainView) {
        _emojiKeyboardContainView = [[UIView alloc] init];
        _emojiKeyboardContainView.backgroundColor = [UIColor whiteColor];
        UIView *toolView = [self creatToolView:YES];
        [_emojiKeyboardContainView addSubview:toolView];
        [_emojiKeyboardContainView addSubview:self.emojiKeyboardView];
        self.emojiKeyboardView.y = toolView.height;
        _emojiKeyboardContainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.emojiKeyboardView.height + kBottomSafeHeight + toolView.height);
        _emojiKeyboardContainView.bottom = SCREEN_HEIGHT;
        _emojiKeyboardContainView.transform =  CGAffineTransformMakeTranslation(0,SCREEN_HEIGHT);
    }
    return _emojiKeyboardContainView;
}

- (XKIMEmojiKeyBoard *)emojiKeyboardView {
    if (!_emojiKeyboardView) {
        _emojiKeyboardView = [[XKIMEmojiKeyBoard alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
        _emojiKeyboardView.delegate = self;
        [_emojiKeyboardView setSendBtnText:@"完成"];
    }
    return _emojiKeyboardView;
}

#pragma mark - 删除表情判断
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
    NSString *text = self.text;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self setText:newText];
        self.selectedRange = newSelectRange;
    }
}

- (NSRange)delRangeForEmoticon
{
    NSString *text = self.text;
    NSRange range = [self rangeForPrefix:@"[" suffix:@"]"];
    NSRange selectedRange = [self selectedRange];
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
    NSString *text = self.text;
    NSRange range = [self selectedRange];
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



