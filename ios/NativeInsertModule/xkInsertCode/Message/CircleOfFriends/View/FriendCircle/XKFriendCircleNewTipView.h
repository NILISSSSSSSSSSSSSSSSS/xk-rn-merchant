/*******************************************************************************
 # File        : XKFriendCircleNewTipView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/30
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface XKFriendCircleNewTipView : UIView

/***/
@property(nonatomic, copy) void(^click)(void);

- (void)updateUI:(id)model;

@end
