/*******************************************************************************
 # File        : BigPhotoPreviewBaseController.h
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
@class PhotoPreviewModel;


@interface BigPhotoPreviewBaseController : UIViewController

/**预览图片的模型数组*/
@property (nonatomic, strong) NSMutableArray<PhotoPreviewModel *> *models;
/**预览图片的当前下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**标题栏标题*/
@property (nonatomic, copy) NSString *strNavTitle;
/**导航栏颜色 默认透明*/
@property (nonatomic, strong) UIColor  *navColor;
/**是否可以保存图片*/
@property (nonatomic, assign) BOOL isSave;
/**是否显示Nav栏*/
@property (nonatomic, assign) BOOL isShowNav; // 默认不显示 NO
/**是否显示标题栏*/
@property (nonatomic, assign) BOOL isShowTitle; // 默认不显示 YES
/**是否显示状态栏*/
@property (nonatomic, assign) BOOL isShowStatusBar; // 默认不显示 NO
/**是否支持长按*/
@property (nonatomic, assign) BOOL isSupportLongPress; // 默认支持 YES
/**标题是否显示索引数字*/
@property (nonatomic, assign) BOOL isHiddenIndex; // 默认显示 NO
/**
 长按弹出选项
 配合isSupportLongPress适用
 kLongPressOptionsSendFriend 发送给朋友
 kLongPressOptionsSavePhoto  保存图片
 默认 @[kLongPressOptionsSavePhoto]
 */
@property (nonatomic, copy) NSArray *longPressOptions;
/**是否隐藏删除按钮*/
@property (nonatomic, assign) BOOL isHiddenDeleteButton; // 默认支持 NO

/**
 获取collectionView
 */
- (UICollectionView *)collectionView;

/**
 子类可以重写定制标题栏
 */
- (void)configCustomNaviBar;

/**
 转发事件 需要转发的时候子类重写
 */
- (void)sendImageToFriendAction:(PhotoPreviewModel *)model;

/**
 滚动完成后要处理的事
 */
- (void)scrollCompleteActionWithIndex:(NSInteger)index;

/********************使用默认标题栏后需要定制的相关按钮的事件处理**********************/
/**
 删除事件 需要删除的时候子类重写
 */
- (void)deletePhotoDataAction;

/**
 删除图片成功

 @param deleteModel 删除的图片
 @param completeBlock 删除成功后的处理
 */
- (void)handleDeletePhotoAction:(PhotoPreviewModel *)deleteModel completeBlock:(void(^)(NSInteger deleteIndex))completeBlock;

@end
