//
//  ApplePurchaseCenter.m
//  HFTPayCenter
//
//  Created by Jamesholy on 2018/4/19.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import "IAPCenter.h"
#import "XKHudView.h"
#import "ApplePurchaseViewModel.h"
#import "AppleProductSuccessCacheModel.h"


#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1

@interface IAPCenter ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
/**当前购买id*/
@property(nonatomic, copy) NSString *currentProductId;
@property(nonatomic, copy) NSString *tradeId;
@property(nonatomic, copy) NSString *orderId;
/**回调block*/
@property(nonatomic, copy) void(^failWithoutPurchase)(NSString * err);
/**回调block*/
@property(nonatomic, copy) void(^failWithPurchase)(NSString * err);
/**回调block*/
@property(nonatomic, copy) void(^success)(AppleProductSuccessCacheModel *info);

/**支付验证结果block*/
@property(nonatomic, copy) ValidationResult validationResult;

/**<##>*/
@property(nonatomic, strong) NSTimer *retryTimer;
@end

@implementation IAPCenter

static IAPCenter * _instance;

+ (instancetype)shareCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [IAPCenter new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 添加观察者 单例就直接添加不移除了
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (NSTimer *)retryTimer {
  if (!_retryTimer) {
    _retryTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(retryUpload) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_retryTimer forMode:NSRunLoopCommonModes];
  }
  return _retryTimer;
}

#pragma mark - 重新上传apple支付成功却服务器上传失败的的信息
- (void)applePayRetryUploadResultToMyServer {
    NSArray *cacheModelArr = [ApplePurchaseViewModel getAllNoCommitProductRecord];
    if (cacheModelArr.count == 0) {
      [_retryTimer setFireDate:[NSDate distantFuture]];
    } else {
      [self.retryTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)retryUpload {
  NSArray *cacheModelArr = [ApplePurchaseViewModel getAllNoCommitProductRecord];
  for (AppleProductSuccessCacheModel *cache in cacheModelArr) {
    [ApplePurchaseViewModel applePayUploadResult:cache toMyServerComplete:^(NSString *err, id data) {
      if (err) {
        NSLog(@"重新提交%@ 又失败了",cache.tradeNo);
        return ;
      }
      NSLog(@"重新提交%@ 成功了",cache.tradeNo);
    }];
  }
}


/**接收服务器的验证的推送结果 在相应的回调里必须调用 否则无法回调下方的验证结果*/
- (void)handleRemoteNotification:(id)notification {
  NSString *err = nil;
  AppleProductSuccessCacheModel *info = [AppleProductSuccessCacheModel new];
  if ([notification isKindOfClass:[NSDictionary class]]) {
    info.tradeNo = notification[@"tradeNo"];
    if (![notification[@"paymentStatus"] isEqualToString:@"success"]) {
      err = @"服务器验证失败";
    }
  }
  if (self.validationResult) {
    self.validationResult(err, info);
    self.validationResult = nil;
  }
  NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
  muDic[@"err"] = err;
  muDic[@"info"] = info;
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPValidationResultNoti object:muDic];
}

/**等待服务器的支付验证结果 回调由于推送失败可能不会执行*/
- (void)observeValidationResult:(ValidationResult)result {
    self.validationResult = result;
}

/***/
- (void)payWithProductId:(NSString *)productId orderId:(NSString *)orderId tradeId:(NSString *)tradeId success:(void(^)(AppleProductSuccessCacheModel *info))success failWithoutPurchase:(void(^)(NSString *err))failWithoutPurchase failWithPurchase:(void(^)(NSString *err))failWithPurchase {
  
    if (productId.length == 0 || orderId.length == 0 || tradeId.length == 0) {
      EXECUTE_BLOCK(failWithoutPurchase,@"支付参数缺失");
      return;
    }
  
    self.failWithoutPurchase = failWithoutPurchase;
    self.failWithPurchase = failWithPurchase;
    self.success = success;
    if([SKPaymentQueue canMakePayments]){
      // productID就是你在创建购买项目时所填写的产品ID
      self.currentProductId = productId;
      self.orderId = orderId;
      self.tradeId = tradeId;
      [self requestProductID:productId];
    }else{
        self.failWithoutPurchase(@"不允许程序内付费");
        // NSLog(@"不允许程序内付费");
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先开启应用内付费购买功能。" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction*sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*_Nonnullaction) {
      }];
      [alert addAction:sureAction];
      [[self getCurrentUIVC] presentViewController:alert animated:YES completion:nil];

    }
}

#pragma mark 从apple请求商品的ID
-(void)requestProductID:(NSString *)productID {
    [XKHudView showLoadingMessage:@"请求支付信息中" to:nil animated:YES];
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc] initWithArray:productIDArray];
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
    
}
#pragma mark 苹果那边的内购监听
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"请求商品信息完成");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [XKHudView hideHUDForView:nil];
    self.failWithoutPurchase(@"请求信息失败");
    NSLog(@"请求商品信息失败");
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [XKHudView hideHUDForView:nil];
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"没有商品");
        self.failWithoutPurchase(@"商品不存在");
        return;
    }
    for (SKProduct *sKProduct in product) {
        if([sKProduct.productIdentifier isEqualToString:self.currentProductId]){
          NSLog(@"localizedDescription:%@\nprice:%@\n%@\npriceLocale:%@",sKProduct.localizedDescription,sKProduct.price,sKProduct.localizedTitle,sKProduct.priceLocale);
            [self buyProduct:sKProduct];
            break;
        } else {
            self.failWithoutPurchase(@"商品不存在");
        }
    }
}


#pragma mark 内购的代码调用
-(void)buyProduct:(SKProduct *)product{
    [XKHudView showLoadingMessage:@"发起交易中" to:nil animated:YES];
    // 1.创建票据
//    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    SKMutablePayment *skpayment = [SKMutablePayment paymentWithProduct:product];
    skpayment.applicationUsername = [NSString stringWithFormat:@"%@#%@",self.orderId,self.tradeId];
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
    // 3.添加观察者，监听用户是否付钱成功(不在此处添加观察者)
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

#pragma mark 4.实现观察者监听付钱的代理方法,只要交易发生变化就会走下面的方法
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [XKHudView hideHUDForView:nil];
    /*
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买
     SKPaymentTransactionStateFailed,        购买失败
     SKPaymentTransactionStateRestored,      回复购买中
     SKPaymentTransactionStateDeferred       交易还在队列里面，但最终状态还没有决定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:{
                [XKHudView showLoadingMessage:@"交易进行中" to:nil animated:YES];
                NSLog(@"正在购买");
            }break;
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"购买成功");
                [self requestPaySuccessWithTransaction:transaction];
                // 购买后告诉交易队列，把这个成功的交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"购买失败");
                if ([self isCurrentPay:transaction]) {
                  if (self.failWithoutPurchase) {
                    self.failWithoutPurchase(@"购买失败");
                  }
                }
                // 购买失败也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"回复购买中,也叫做已经购买");
                // 回复购买中也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
            }break;
            default:
                
                break;
        }
    }
}

/**如果在服务器返回验证结果之前出现异常（用户杀掉App、手机关机了，App崩溃等）该笔IAP 交易不会被完成，App重新启动之后，重新监听支付队列的时候，可以重新获取到该笔交易 所以判断一下是不是当前的交易*/
- (BOOL)isCurrentPay:(SKPaymentTransaction *)transaction {
  SKPayment *payment = transaction.payment;
  NSString *orderId = [payment.applicationUsername componentsSeparatedByString:@"#"].firstObject;
  if ([orderId isEqualToString:self.orderId]) {
    return YES;
  } else {
    return NO;
  }
}


#pragma mark - 向服务器返回支付成功结果
- (void)requestPaySuccessWithTransaction:(SKPaymentTransaction *)transaction {
//    [self verifyTransactionResult:nil];
    // 内购成功了先缓存成功的结果
    AppleProductSuccessCacheModel *cache = [AppleProductSuccessCacheModel new];
    SKPayment *payment = transaction.payment;
    NSString *appUsername = payment.applicationUsername;
    cache.transactionIdentifier = transaction.transactionIdentifier;
    cache.orderNo = [appUsername componentsSeparatedByString:@"#"].firstObject;
    cache.tradeNo = [appUsername componentsSeparatedByString:@"#"].lastObject;
    NSURL * appstoreReceiptUrl= [[NSBundle mainBundle]appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:appstoreReceiptUrl];
    NSString *transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    cache.ticket = transactionReceiptString;  // 服务器验证必传
  
    [ApplePurchaseViewModel applePayUploadResult:cache toMyServerComplete:^(NSString *error, id data) {
      if ([self isCurrentPay:transaction]) { // 是否是当前的支付
        [XKHudView hideHUDForView:nil];
        // 注意 这里的失败是用户支付成功了 通知我们服务器的失败。 这种失败特殊处理 让别人重试 防止别人出了钱没搞事。
        if (error) {
          [self alertTipRetryCancel:^{
            EXECUTE_BLOCK(self.failWithPurchase,error);
            [[IAPCenter shareCenter] applePayRetryUploadResultToMyServer];
          } sure:^{
            [XKHudView showLoadingTo:nil animated:YES];
            [self requestPaySuccessWithTransaction:transaction];
          }];
          return;
        }
        EXECUTE_BLOCK(self.success,cache);  // 成功回调 !!!!!!!!!
      }
    }];
}

- (void)alertTipRetryCancel:(void(^)(void))cancel sure:(void(^)(void))sure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已支付成功，支付凭证上传失败，是否重新上传？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*sureAction = [UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*_Nonnullaction) {
        sure();
    }];
    UIAlertAction*cancleAction = [UIAlertAction actionWithTitle:@"稍后自动上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {
        cancel();
    }];
    [alert addAction:cancleAction];
       [alert addAction:sureAction];
    [[self getCurrentUIVC] presentViewController:alert animated:YES completion:nil];
}


/**
 
 注意：
 自己测试的时候使用的是沙盒购买(测试环境)
 App Store审核的时候也使用的是沙盒购买(测试环境)
 上线以后就不是用的沙盒购买了(正式环境)
 所以此时应该先验证正式环境，在验证测试环境
 
 正式环境验证成功，说明是线上用户在使用
 正式环境验证不成功返回21007，说明是自己测试或者审核人员在测试
 
 服务器应对处理过的 transactionIdentifier,productid,userId进行记录 防止客户端重复提交问题，与用户切换情况充值错误问题
 
 苹果AppStore线上的购买凭证地址是： https://buy.itunes.apple.com/verifyReceipt
 测试地址是：https://sandbox.itunes.apple.com/verifyReceipt
 
 
 NSString *sandbox;
 
 #if APPSTORE_ASK_TO_BUY_IN_SANDBOX && DEBUG
 sandbox = @"1";
 #else
 
 sandbox = @"0";
 #endif
 
 请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
 0 代表沙盒  1代表 正式的内购
 最后最验证后的
 
 内购验证凭据返回结果状态码说明
 21000 App Store无法读取你提供的JSON数据
 21002 收据数据不符合格式
 21003 收据无法被验证
 21004 你提供的共享密钥和账户的共享密钥不一致
 21005 收据服务器当前不可用
 21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
 21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
 21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
 */


#pragma mark 客户端验证购买凭据逻辑
- (void)verifyTransactionResult:(SKPaymentTransaction *)paymentTransactionp {
    
    NSString *transactionReceiptString= nil;
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL * appstoreReceiptUrl= [[NSBundle mainBundle]appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:appstoreReceiptUrl];
    transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSDictionary *requestContents = @{
                                      @"receipt-data": transactionReceiptString
                                      };
    // 转换为 JSON 格式
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:nil];
    // 不存在
    if (!requestData) { /* ... Handle error ... */ }
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString;
#if APPSTORE_ASK_TO_BUY_IN_SANDBOX && DEBUG
    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    // 国内访问苹果服务器比较慢，timeoutInterval 需要长一点
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // 在后台对列中提交验证请求，并获得官方的验证JSON结果
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"链接失败");
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       NSLog(@"验证失败");
                                   }
                                   NSInteger status = [jsonResponse[@"status"] integerValue];
                                   if (status == 0) {
                                       // 比对 jsonResponse 中以下信息基本上可以保证数据安全
                                       /*
                                        bundle_id
                                        application_version
                                        product_id
                                        transaction_id
                                        */
                                       
                                       NSLog(@"验证结果成功: %@",jsonResponse);
                                   } else {
                                        NSLog(@"验证结果失败: %@",jsonResponse);
                                   }

                               }
                           }];
    
}

@end
