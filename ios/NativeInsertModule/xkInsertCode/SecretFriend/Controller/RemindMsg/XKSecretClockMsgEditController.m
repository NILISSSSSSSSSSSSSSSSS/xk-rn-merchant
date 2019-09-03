/*******************************************************************************
 # File        : XKSecretClockMsgEditController.m
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

#import "XKSecretClockMsgEditController.h"
#import "XKInputTextView.h"
#import "XKSectionHeaderArrowView.h"
#import "XKBottomAlertSheetView.h"
#import "XKSecretClockMsgSetController.h"
#import "XKCommonSheetView.h"
#import "XKTimePickerView.h"
@interface XKSecretClockMsgEditController ()
/**<##>*/
@property(nonatomic, strong) XKInputTextView *textView;
/**<##>*/
@property(nonatomic, strong) XKSectionHeaderArrowView *arrow;
/**<##>*/
@property(nonatomic, strong) XKTimePickerView *picker;
/**<##>*/
@property(nonatomic, strong) NSDate *chooseDate;

@end

@implementation XKSecretClockMsgEditController

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
    __weak typeof(self) weakSelf = self;
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"新建定时消息" WithColor:[UIColor whiteColor]];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = XKRegularFont(17);
    [rightBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
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
    _arrow.titleLabel.text = @"提醒时间";
    _arrow.detailLabel.font = XKRegularFont(13);
    _arrow.detailLabel.text = self.chooseDate ? [XKTimeSeparateHelper backYMDWeakHMStringByVirguleSegmentWithDate:self.chooseDate] : @"选择提醒时间";
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
    
    if (self.msgClockInfo) { // 存在是编辑
        [self setNavTitle:@"编辑定时消息" WithColor:[UIColor whiteColor]];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.msgClockInfo.sendTime.longLongValue];
        self.chooseDate = date;
        self.arrow.detailLabel.text = [XKTimeSeparateHelper backYMDWeakHMStringByVirguleSegmentWithDate:date];
        self.textView.inputTextView.text = self.msgClockInfo.msgContent;
    }
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setClick {
    [KEY_WINDOW endEditing:YES];
    if (self.textView.inputTextView.text.length == 0) {
        [XKHudView showTipMessage:@"请输入提醒内容"];
        return;
    }
    
    if (self.chooseDate == nil) {
        [XKHudView showTipMessage:@"请选择提醒时间"];
        return;
    }
    
    if (self.msgClockInfo) { // 编辑
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"mappingMsgId"] = self.msgClockInfo.msgId;
        params[@"secretId"] = self.secretId;
        params[@"msgContent"] = self.textView.inputTextView.text;
        params[@"sendTime"] = @([self.chooseDate timeIntervalSince1970]);
        [XKHudView showLoadingTo:self.containView animated:YES];
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/mappingMsgUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            [XKHudView hideHUDForView:self.containView animated:YES];
            EXECUTE_BLOCK(self.editSuccess);
            [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"您已成功修改提醒消息" leftText:nil rightText:@"确定" leftBlock:nil rightBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } textAlignment:NSTextAlignmentCenter];
        } failure:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.containView animated:YES];
            [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
        }];
    } else { // 新建
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"secretId"] = self.secretId;
        params[@"msgContent"] = self.textView.inputTextView.text;
        params[@"sendTime"] = @([self.chooseDate timeIntervalSince1970]);
        [XKHudView showLoadingTo:self.containView animated:YES];
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/timerMsgCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            [XKHudView hideHUDForView:self.containView animated:YES];
            EXECUTE_BLOCK(self.editSuccess);
            [XKAlertView showCommonAlertViewWithTitle:@"提示" message:@"您已成功设置提醒消息" leftText:nil rightText:@"确定" leftBlock:nil rightBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } textAlignment:NSTextAlignmentCenter];
        } failure:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.containView animated:YES];
            [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
        }];
    }
}

- (void)editTime {
    [KEY_WINDOW endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self.picker setSureClick:^(NSDate *date) {
        weakSelf.chooseDate= date;
        weakSelf.arrow.detailLabel.text = [XKTimeSeparateHelper backYMDWeakHMStringByVirguleSegmentWithDate:date];
    } cancel:^(NSDate *date) {
        //
    }];
    [self.picker show];
}
#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------
- (XKTimePickerView *)picker {
    if (!_picker) {
        _picker = [XKTimePickerView new];
    }
    return _picker;
}

@end
