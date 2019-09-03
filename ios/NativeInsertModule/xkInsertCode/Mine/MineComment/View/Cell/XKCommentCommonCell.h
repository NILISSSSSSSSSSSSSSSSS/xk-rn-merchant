/*******************************************************************************
 # File        : XKCommentCommonCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
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

@interface XKCommentCommonCell : UITableViewCell
/**内容总视图*/
@property(nonatomic, strong) UIView *containView;
/**<##>*/
@property(nonatomic, copy) NSString *userId;
/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**评论内容*/
@property(nonatomic, strong) UILabel *desLabel;

/**图片数目*/
@property(nonatomic, copy) NSArray *imgsArray;
/**是否折叠  0 折叠*/
@property(nonatomic, assign) BOOL imgsShowAllStatus;

/**自定义视图*/
@property(nonatomic, strong) UIView *diyView;
/**隐藏分割线*/
@property(nonatomic, assign) BOOL hideSeperate;

/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;

/**diy视图点击事件*/
@property(nonatomic, copy) void(^diyViewClick)(NSIndexPath *indexPath);
/**展开点击事件*/
@property(nonatomic, copy) void(^foldClick)(NSIndexPath *indexPath);
@end
