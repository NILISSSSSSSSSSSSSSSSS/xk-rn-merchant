/*******************************************************************************
 # File        : XKInputTextView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKInputTextView.h"
#import "UITextView+PlaceHolder.h"


@interface XKInputTextView ()<UITextViewDelegate>

/**textView*/
@property (nonatomic, strong) UITextView *textView;
/**字数*/
@property (nonatomic, strong) UILabel *countLabel;
/**文字内容*/
@property (nonatomic, copy) NSString *inputText;

@end

@implementation XKInputTextView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = RGBGRAY(255);
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark ----------------------------- 私有方法 ------------------------------
#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
	__weak typeof(self) weakSelf = self;
	// 文本
	_textView = [[UITextView alloc] init];
	_textView.zw_placeHolder = @"请输入跟进内容";
	_textView.zw_placeHolderColor = RGBGRAY(153);
	_textView.textColor = RGBGRAY(102);
//    _textView.backgroundColor = RGBGRAY(245);
    _textView.font = XKRegularFont(14);
	_textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.delegate  = self;
    
	[self addSubview:_textView];
	[_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(0);
		make.right.equalTo(weakSelf).offset(0);
		make.top.equalTo(weakSelf).offset(0);
		make.bottom.equalTo(weakSelf).offset(0);
	}];

	// 字数
	_countLabel = [[UILabel alloc] init];
	_countLabel.text = @"";
	_countLabel.textColor = RGBGRAY(153);
	_countLabel.font = XKRegularFont(13);
	[self addSubview:_countLabel];
	[_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-10);
		make.bottom.equalTo(self).offset(-6);
	}];
    [self configFirstInputNum:0];
	// 初始值
	self.limitNumber = 0;
}

- (void)textViewDidChange:(UITextView *)textView {

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
    if (self.limitNumber > 0) {
        if (self.textView.text.length > self.limitNumber) {
            self.textView.text = [self.textView.text substringToIndex:self.limitNumber];
        }
    }
    self.countLabel.text = @(self.limitNumber - textView.text.length).stringValue;
    EXECUTE_BLOCK(self.textDidChangeBlock, textView.text);
}

#pragma mark ----------------------------- 公用方法 ------------------------------
#pragma mark - 弹出键盘
- (void)showKeybord {
	[_textView becomeFirstResponder];
}

#pragma mark - 设置初始文本
- (void)configInitText:(NSString *)text {
	_textView.text = text;
    [self configFirstInputNum:text.length];
}

#pragma mark --------------------------- setter&getter -------------------------
- (void)setLimitNumber:(NSInteger)limitNumber {
	if (limitNumber <= 0) {
		_countLabel.hidden = YES;
		limitNumber = MAX_INPUT;
	} else {
		_countLabel.hidden = NO;
	}
	_limitNumber = limitNumber;
    self.countLabel.text = @(limitNumber - self.textView.text.length).stringValue;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
	_placeholderText = placeholderText;
    if (_placeholderText.isExist) {
        _textView.zw_placeHolder = _placeholderText;
    }
}

- (NSString *)contentText {
	if (![_inputText isExist]) {
		return @"";
	}
	return _inputText.copy;
}

- (UITextView *)inputTextView {
    return self.textView;
}

-(void)configFirstInputNum:(NSInteger )num {
    self.countLabel.text = @(self.limitNumber - self.textView.text.length).stringValue;
}

@end
