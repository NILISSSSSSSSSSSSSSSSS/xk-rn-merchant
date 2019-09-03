/*******************************************************************************
 # File        : xkMerchantEmitterModule.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/12/24
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "xkMerchantEmitterModule.h"
#import "ReactRootViewManager.h"
#import "BaseRNViewController.h"
#import "AppDelegate.h"
@implementation xkMerchantEmitterModule

RCT_EXPORT_MODULE();

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self addNoti];
  }
  return self;
}

- (void)addNoti {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTokenFail:) name:@"xkMerchantLoginTokenFailNoti" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redPointStatusChange) name:@"friendRedPointStatusChangeNoti" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemMessage:) name:@"systemMessageNoti" object:nil];
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"loginTokenFail",@"redPointStatusChange",@"systemMessage"];//有几个就写几个
}

- (void)loginTokenFail:(NSNotification *)noti {
  [self sendEventWithName:@"loginTokenFail"
                     body:noti.object];
}

- (void)redPointStatusChange {
  [self sendEventWithName:@"redPointStatusChange"
                     body:nil];
}

- (void)systemMessage:(NSNotification *)noti {
  [self sendEventWithName:@"systemMessage"
                     body:noti.object];
}

+ (void)loginTokenFail:(NSString *)code message:(NSString*)message {
  NSMutableDictionary *dic = @{}.mutableCopy;
  dic[@"code"] = code;
  dic[@"message"] = message;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"xkMerchantLoginTokenFailNoti" object:dic];
  [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
}

+ (void)friendRedPointStatusChange:(BOOL)has {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"friendRedPointStatusChangeNoti" object:nil];
}

+ (void)RNJumpToWelfareDetailWithSequenceId:(NSString *)sequenceId goodsId:(NSString *)goodsId {
  [[ReactRootViewManager manager] preLoadRootViewWithName:@"WMGoodsDetail" initialProperty:@{@"sequenceId":sequenceId,@"goodsId":goodsId}];
  BaseRNViewController *rootViewController = [BaseRNViewController new];
  rootViewController.view=[[ReactRootViewManager manager] rootViewWithName:@"WMGoodsDetail"];;
  [[self getCurrentUIVC].navigationController pushViewController:rootViewController animated:YES];
}

+ (void)RNJumpToGoodsDetailWithGoodsId:(NSString *)goodsId {
  [[ReactRootViewManager manager] preLoadRootViewWithName:@"SOMGoodsDetail" initialProperty:@{@"goodsId":goodsId}];
  BaseRNViewController *rootViewController = [BaseRNViewController new];
  rootViewController.view=[[ReactRootViewManager manager] rootViewWithName:@"SOMGoodsDetail"];;
  [[self getCurrentUIVC].navigationController pushViewController:rootViewController animated:YES];
}

+ (void)RNJumpToPersonalVcUserId:(NSString *)userId {
    [[ReactRootViewManager manager] preLoadRootViewWithName:@"Profile" initialProperty:@{@"userId":userId}];
  BaseRNViewController *rootViewController = [BaseRNViewController new];
  rootViewController.view=[[ReactRootViewManager manager] rootViewWithName:@"Profile"];
  [[self getCurrentUIVC].navigationController pushViewController:rootViewController animated:YES];
}

+ (void)RNSystemMessage:(NSString *)jsonStr {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"systemMessageNoti" object:jsonStr];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
