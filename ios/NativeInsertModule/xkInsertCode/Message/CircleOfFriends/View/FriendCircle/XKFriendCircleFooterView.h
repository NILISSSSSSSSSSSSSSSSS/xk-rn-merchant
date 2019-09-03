/*******************************************************************************
 # File        : XKFriendCircleFooterView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
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

@interface XKFriendCircleFooterView : UITableViewHeaderFooterView
@property(nonatomic, assign) BOOL shortFooter;

@property(nonatomic, strong) UIView *containView;
/**<##>*/
@property(nonatomic, assign) NSInteger index;
/**label*/
@property(nonatomic, strong) UILabel *label;

/**点击回调*/
@property(nonatomic, copy) void(^click)(NSInteger index);
@end
