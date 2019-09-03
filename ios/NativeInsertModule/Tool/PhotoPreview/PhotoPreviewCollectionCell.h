/*******************************************************************************
 # File        : PhotoPreviewCollectionCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 浏览大图的基类 需要其他功能的时候需要继承然后定制
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@class PhotoPreviewView;
@class PhotoPreviewModel;

@interface PhotoPreviewCollectionCell : UICollectionViewCell

/**是否支持长按*/
@property (nonatomic, assign) BOOL isSupportLongPress;
/**长按弹出选项 配合isSupportLongPress适用 默认 1.发送给朋友 2.保存图片 */
@property (nonatomic, copy) NSArray *longPressOptions;
/**图片模型*/
@property (nonatomic, strong) PhotoPreviewModel *model;
/**单击回调*/
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
/**转发回调*/
@property (nonatomic, copy) void (^sendImageToFriendBlock)(PhotoPreviewModel *);
/**预览view*/
@property (nonatomic, strong) PhotoPreviewView *previewView;

/**
 * 重置
 */
- (void)recoverSubviews;

@end

@interface PhotoPreviewView : UIView

/**是否支持长按*/
@property (nonatomic, assign) BOOL isSupportLongPress;
/**长按弹出选项 配合isSupportLongPress适用 默认 1.发送给朋友 2.保存图片 */
@property (nonatomic, copy) NSArray *longPressOptions;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) PhotoPreviewModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^sendImageToFriendBlock)(PhotoPreviewModel *);

- (void)recoverSubviews;

@end
