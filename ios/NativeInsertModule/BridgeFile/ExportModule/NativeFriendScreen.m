/*******************************************************************************
 # File        : MyTableView.m
 # Project     : NativeInsertDemo
 # Author      : Jamesholy
 # Created     : 2018/12/8
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "NativeFriendScreen.h"
#import "RNMessageRootView.h"

@implementation NativeFriendScreen

RCT_EXPORT_MODULE()

- (UIView *)view {
  RNMessageRootView *vc = [[RNMessageRootView alloc] init];
  return vc;
}

@end
