/*******************************************************************************
 # File        : XKRedPointItem.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/26
 # Corporation :  水木科技
 # Description :
 红点管理对象
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRedPointItem.h"

@implementation XKRedPointItem

- (void)cleanItemRedPoint {
    self.hasRedPoint = NO;
    [self updateUIForSepical];
}

- (BOOL)getItemPointStatus {
    return self.hasRedPoint;
}

- (void)resetItemRedPointStatus {
    //
}

- (void)updateUIForSepical {
    //
}


@end
