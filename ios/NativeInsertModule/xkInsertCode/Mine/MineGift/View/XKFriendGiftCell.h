/*******************************************************************************
 # File        : XKFriendGiftCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
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

@interface XKFriendGiftCell : UITableViewCell
/**内容总视图*/
@property(nonatomic, strong) UIView *containView;
/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**名字下方的文字*/
@property(nonatomic, strong) UILabel *giftLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;

/**<##>*/
@property(nonatomic, copy) NSString *topUser;
@property(nonatomic, copy) NSString *btmUser;

/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**刷新block*/
@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);

- (void)hideSeperateLine:(BOOL)hide;
- (void)setGiftType:(NSArray *)gifts;
@end
