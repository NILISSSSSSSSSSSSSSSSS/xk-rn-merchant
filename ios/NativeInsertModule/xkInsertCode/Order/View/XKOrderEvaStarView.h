/*******************************************************************************
 # File        : XKOrderEvaStarView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
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

@interface XKOrderEvaStarView : UIView
/**startChange*/
@property(nonatomic, copy) void(^starChange)(NSInteger starNum);
/**标题*/
@property(nonatomic, copy) NSString *title;
/**星星数*/
@property(nonatomic, assign) NSInteger starNum;
/**描述*/
@property(nonatomic, copy) NSString *des;
@end
