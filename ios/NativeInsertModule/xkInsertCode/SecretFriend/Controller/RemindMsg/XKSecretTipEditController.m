/*******************************************************************************
 # File        : XKSecretTipEditController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretTipEditController.h"
#import "XKInputTextView.h"
#import "XKSectionHeaderArrowView.h"
#import "XKBottomAlertSheetView.h"
#import "XKSecretClockMsgSetController.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKSecretTipEditController ()
/**<##>*/
@property(nonatomic, strong) XKInputTextView *textView;
/**<##>*/
@property(nonatomic, strong) XKSectionHeaderArrowView *arrow;
/**<##>*/
@property(nonatomic, strong) XKSecretTipMsg *tipMsg;
@property(nonatomic, assign) NSInteger day;

/**设置按钮*/
@property(nonatomic, strong) UIButton *settingButton;
@end

@implementation XKSecretTipEditController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    
    [self requestNeedTip:YES];
}

- (void)willPopToPreviousController {
    [self updateTipSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //添加引导视图
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretTipEditController TransparentRectArr:@[[NSValue valueWithCGRect:self.settingButton.getWindowFrame]]];
  
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
    __weak typeof(self) weakSelf = self;
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"提醒消息" WithColor:[UIColor whiteColor]];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = XKRegularFont(17);
    [rightBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    self.settingButton = rightBtn;

    [self setRightView:rightBtn withframe:rightBtn.bounds];
    
    _textView = [[XKInputTextView alloc] init];
    _textView.placeholderText = @"请输入提醒内容";
    _textView.limitNumber = 0;
    _textView.countLabel.hidden = YES;
    [_textView setTextDidChangeBlock:^(NSString *text) {
    }];
    [self.containView addSubview:_textView];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 6;
    _textView.clipsToBounds = YES;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(15);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.height.equalTo(@100);
    }];
    
    _arrow = [XKSectionHeaderArrowView new];
    _arrow.backgroundColor = [UIColor whiteColor];
    _arrow.titleLabel.text = @"请选择失效时间";
    _arrow.detailLabel.font = XKRegularFont(13);
    _arrow.detailLabel.text = @"无反应失效时间";
    _arrow.layer.cornerRadius = 6;
    _arrow.clipsToBounds = YES;
    [_arrow bk_whenTapped:^{
        [weakSelf editTime];
    }];
    [self.containView addSubview:_arrow];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.left.equalTo(self.textView.mas_left);
        make.right.equalTo(self.textView.mas_right);
        make.height.equalTo(@50);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setClick {
    [KEY_WINDOW endEditing:YES];
    XKSecretClockMsgSetController *vc = [XKSecretClockMsgSetController new];
    vc.secretId = self.secretId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editTime {
    [KEY_WINDOW endEditing:YES];
    __weak typeof(self) weakSelf = self;
    XKBottomAlertSheetView *timeSheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"1天",@"2天",@"3天",@"4天",@"5天",@"6天",@"7天",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        if ([choseTitle isEqualToString:@"取消"]) {
            weakSelf.arrow.detailLabel.text = @"请选择失效时间";
            weakSelf.tipMsg.invalidDay = 0;
            return ;
        }
        weakSelf.arrow.detailLabel.text = choseTitle;
        weakSelf.tipMsg.invalidDay = index + 1;
    }];
    [timeSheet show];
}

- (void)updateUI {
    _textView.inputTextView.text = self.tipMsg.msgContent;
    if (self.tipMsg.invalidDay == 0) {
        self.arrow.detailLabel.text = @"请选择失效时间";
    } else {
        self.arrow.detailLabel.text = [NSString stringWithFormat:@"%ld天",self.tipMsg.invalidDay];
    }
}

#pragma mark ----------------------------- 网络请求 ------------------------------

- (void)requestNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretId"] = self.secretId;
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/normalMsgFind/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.tipMsg = [XKSecretTipMsg yy_modelWithJSON:[responseObject xk_jsonToDic] [@"normalMsg"]];
        if (self.tipMsg == nil) {
            self.tipMsg = [XKSecretTipMsg new];
        }
        [XKHudView hideHUDForView:self.containView animated:YES];
        [self updateUI];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}

- (void)updateTipSetting {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (!self.tipMsg) {
        return;
    }
    if (self.tipMsg.msgId) {
        params[@"mappingMsgId"] = self.tipMsg.msgId;
        params[@"msgContent"] = _textView.inputTextView.text;
        params[@"invalidDay"] = @(self.tipMsg.invalidDay);
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/mappingMsgUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(self.changeBlock);
        } failure:^(XKHttpErrror *error) {
        }];
    } else {
        params[@"secretId"] = self.secretId;
        params[@"msgContent"] = _textView.inputTextView.text;
        params[@"invalidDay"] = @(self.tipMsg.invalidDay);
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/normalMsgCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            EXECUTE_BLOCK(self.changeBlock);
        } failure:^(XKHttpErrror *error) {
        }];
    }
}

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------

@end

@implementation XKSecretTipMsg

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"msgId"  : @"id"};
}

- (void)setSendTime:(NSString *)sendTime {
    _sendTime = sendTime;
    _displayTime = [XKTimeSeparateHelper backYMDWeakHMStringByVirguleSegmentWithDate:[NSDate dateWithTimeIntervalSince1970:sendTime.longLongValue]];
}

@end
