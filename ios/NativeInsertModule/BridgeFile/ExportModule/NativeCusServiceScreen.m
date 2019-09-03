/*******************************************************************************
 # File        : NativeCusServiceScreen.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/12/17
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "NativeCusServiceScreen.h"
#import "RNCustomServiceRootView.h"

@implementation NativeCusServiceScreen

RCT_EXPORT_MODULE()

- (UIView *)view {
  RNCustomServiceRootView *vc = [[RNCustomServiceRootView alloc] init];
  return vc;
}

@end
