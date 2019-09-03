/*******************************************************************************
 # File        : NatvieJump.m
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

#import "NatvieJump.h"
#import "XKEvaluateServiceViewController.h"
#import "XKCustomerServiceViewController.h"
#import "xkMerchantEmitterModule.h"
#import "XKOfficialGroupChatMainViewController.h"

@implementation NatvieJump

+ (void)jumpLocalUnionGroup {
  dispatch_async(dispatch_get_main_queue(), ^{
    XKOfficialGroupChatMainViewController *vc = [XKOfficialGroupChatMainViewController new];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  });
}

+ (void)jumpShopService {
  dispatch_async(dispatch_get_main_queue(), ^{
    XKCustomerServiceViewController *vc = [XKCustomerServiceViewController new];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  });
}


@end
