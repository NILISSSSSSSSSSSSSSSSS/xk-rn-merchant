/*******************************************************************************
 # File        : XKMineCommentInputController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCommentInputController.h"
#import "XKInputTextView.h"

@interface XKMineCommentInputController ()
/**<##>*/
@property(nonatomic, strong) XKInputTextView *textView;
@end

@implementation XKMineCommentInputController

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
    [self setNavTitle:@"回复评论" WithColor:[UIColor whiteColor]];
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"发送" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [newBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    
    _textView = [[XKInputTextView alloc] init];
    _textView.placeholderText = @"输入回复内容";
    _textView.limitNumber = 150;
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 5;
    _textView.clipsToBounds = YES;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@150);
    }];
    [_textView becomeFirstResponder];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)send {
    NSString *text = _textView.inputTextView.text;
    NSDictionary *dic = self.getParmas();
    NSLog(@"%@ .. %@",text,dic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
