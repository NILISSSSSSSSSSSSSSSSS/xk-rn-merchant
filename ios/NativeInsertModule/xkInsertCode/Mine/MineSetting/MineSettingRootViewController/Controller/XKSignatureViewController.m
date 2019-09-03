/*******************************************************************************
 # File        : XKSignatureViewController.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSignatureViewController.h"
#import "XKInputTextView.h"

@interface XKSignatureViewController ()
@property(nonatomic, strong) XKInputTextView *textView;

@end

@implementation XKSignatureViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"个性签名" WithColor:[UIColor whiteColor]];
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"保存" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [newBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    _textView = [[XKInputTextView alloc] init];
    _textView.placeholderText = @"请设置你的签名";
    _textView.inputTextView.text = self.signatureStr;
    _textView.limitNumber = 30;
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 5;
    _textView.clipsToBounds = YES;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@100);
    }];
    [_textView becomeFirstResponder];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)signatureBlock:(signatureBlock)block {
    self.block = block;
}
#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)save {
    NSString *text = _textView.inputTextView.text;
    NSLog(@"%@",text);
    if (self.block) {
        self.block(text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
