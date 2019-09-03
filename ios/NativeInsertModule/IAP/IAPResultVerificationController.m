/*******************************************************************************
 # File        : IAPResultVerificationController.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/1/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "IAPResultVerificationController.h"
#import "XKEmptyPlaceView.h"
#import "IAPCenter.h"


@interface IAPResultVerificationController ()

/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
/***/
@property(nonatomic, strong) NSTimer *timer;

/**<##>*/
@property(nonatomic, assign) BOOL check;
@end

@implementation IAPResultVerificationController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];

  __weak typeof(self) weakSelf = self;
  
  // 监听结果推送
  [[IAPCenter shareCenter] observeValidationResult:^(NSString *err, AppleProductSuccessCacheModel *info) {
    if ([info.tradeNo isEqualToString:weakSelf.payInfo.tradeNo]) {
      if (err) {
        [weakSelf fail];
      } else {
        [weakSelf sucess];
      }
    }
  }];
  
  // 轮询订单状态
  [self cycleRequestOrderStatus];
}

- (void)dellocTimer {
  [_timer invalidate];
  _timer = nil;
}

- (NSTimer *)timer{
  if (!_timer) {
    _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
  }
  return _timer;
}

- (void)timerRun {
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"tradeNo"] = self.payInfo.tradeNo;
  [HTTPClient getEncryptRequestWithURLString:@"trade/ma/tradeOrderQuery/1.0" timeoutInterval:5 parameters:params success:^(id responseObject) {
    NSDictionary *responseDic = [responseObject xk_jsonToDic];
    NSString *status = [responseDic[@"paymentItems"] firstObject][@"paymentStatus"];
    if ([status isEqualToString:@"success"]) {
      [self sucess];
      [self dellocTimer];
    } else if ([status isEqualToString:@"fail"]) {
      [self fail];
      [self dellocTimer];
    } else {
      
    }
  } failure:^(XKHttpErrror *error) {
    //
  }];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

- (void)cycleRequestOrderStatus {
  [self.timer fire];
}

#pragma mark - 初始化界面
- (void)createUI {
  
  [self setNavTitle:@"支付验证" WithColor:[UIColor whiteColor]];
  self.emptyView = [XKEmptyPlaceView configScrollView:self.bgScrollView config:nil];
  _emptyView.config.titleFont = XKNormalFont(20);
  _emptyView.config.descriptionFont = XKNormalFont(17);
  _emptyView.config.spaceHeight = 20;
  [self.emptyView showWithImgName:@"加载中" title:@"支付结果验证中" des:@"请等待" tapClick:^{
  }];
}

- (void)sucess {
  if (self.check) {
    return;
  }
  self.check = YES;
  [self.emptyView showWithImgName:@"xk_btn_account_password_finger_opened" title:@"支付成功" des:nil tapClick:nil];
  if (self.result) {
      EXECUTE_BLOCK(self.result,0,self.payInfo);
      self.result = nil;
  }

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                 ^{
                   [self.navigationController popViewControllerAnimated:YES];
                 });

}

- (void)fail {
  if (self.check) {
    return;
  }
  self.check = YES;
  if (self.result) {
    EXECUTE_BLOCK(self.result,1,self.payInfo);
    self.result = nil;
  }
  [self.emptyView showWithImgName:@"xk_ic_default_netError" title:@"支付结果验证失败" des:@"如扣款，商品未到账，请联系客服处理" tapClick:nil];
}

- (void)didPopToPreviousController {
  if (self.result) {
    EXECUTE_BLOCK(self.result,2,self.payInfo);
  }
   [self dellocTimer];
}

@end
