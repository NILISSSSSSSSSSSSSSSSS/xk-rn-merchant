/*******************************************************************************
 # File        : XKFriendCircleGiftCell.h
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

#import "XKFriendGiftCell.h"
#import "XKWithImgBaseModel.h"
#import "XKMyPriaseFriendModel.h"

@interface XKFriendCircleGiftCell : XKFriendGiftCell

@property(nonatomic, strong) UIImageView *infoHeadImageView;
@property(nonatomic, strong) UILabel *infoNamelabel;
@property(nonatomic, strong) UILabel *infoDesLabel;
/**图片信息模型 只控制图片状态 勿进行其他数据操作*/
@property(nonatomic, strong) XKWithImgBaseModel *imgControlModel;
/**<##>*/
@property(nonatomic, assign) BOOL isVideo;

/**点击事件*/
@property(nonatomic, copy) void(^infoClick)(NSIndexPath *indexPath);
/**展开点击事件*/
@property(nonatomic, copy) void(^foldClick)(NSIndexPath *indexPath);
@end
