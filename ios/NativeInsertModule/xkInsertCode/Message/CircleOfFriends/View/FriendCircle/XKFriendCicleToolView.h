/*******************************************************************************
 # File        : XKFriendCicleToolView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
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

@interface XKFriendCicleToolView : UIView
/**礼物*/
//@property(nonatomic, strong) UIButton *giftButton;
/**点赞*/
@property(nonatomic, strong) UIButton *favorButton;
/**评论*/
@property(nonatomic, strong) UIButton *commentButton;
/**信息视图*/
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, strong) UIButton *authBtn;

- (void)clearConsError;
@end
