/*******************************************************************************
 # File        : XKTimePickerView.h
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

#import <Foundation/Foundation.h>

@interface XKTimePickerView : NSObject

- (void)setDate:(NSDate *)date;
- (void)setSureClick:(void(^)(NSDate *date))sure cancel:(void(^)(NSDate *date))cancel;

- (void)show;
@end
