//
//  XKCustomShareView.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKCustomShareView;
@class XKVideoDisplayVideoListItemModel;

static NSString *XKShareItemTypeCircleOfFriends = @"XKShareItemTypeCircleOfFriends";    // 朋友圈
static NSString *XKShareItemTypeWechatFriends   = @"XKShareItemTypeWechatFriends";      // 微信好友
static NSString *XKShareItemTypeQQ              = @"XKShareItemTypeQQ";                 // QQ
static NSString *XKShareItemTypeSinaWeibo       = @"XKShareItemTypeSinaWeibo";          // 新浪微博
static NSString *XKShareItemTypeMyFriends       = @"XKShareItemTypeMyFriends";          // 我的朋友
static NSString *XKShareItemTypeCopyLink        = @"XKShareItemTypeCopyLink";           // 拷贝链接
static NSString *XKShareItemTypeSaveToLocal     = @"XKShareItemTypeSaveToLocal";        // 保存至本地
static NSString *XKShareItemTypeReport          = @"XKShareItemTypeReport";             // 投诉

typedef NS_OPTIONS(NSUInteger, XKCustomShareViewLayoutType) {
    XKCustomShareViewLayoutTypeCenter = 1 << 0,
    XKCustomShareViewLayoutTypeBottom = 1 << 1,
};

@protocol XKCustomShareViewDelegate <NSObject>

@optional
// 未开启第三方自动分享或者开启第三方自动分享，但点击项不支持自动分享 点击事件
- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem;
// 第三方自动分享成功
- (void)customShareView:(XKCustomShareView *) customShareView didAutoThirdShareSucceed:(NSString *) shareItem;
// 第三方自动分享失败
- (void)customShareView:(XKCustomShareView *) customShareView didAutoThirdShareFailed:(NSString *) shareItem;
// 第三方自动分享取消
- (void)customShareView:(XKCustomShareView *) customShareView didAutoThirdShareCanceled:(NSString *) shareItem;

@end

/**
 自动分享所需要的数据模型
 */
@interface XKShareDataModel : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *content;
// 跳转URL
@property (nonatomic, copy) NSString *url;
// 图片
@property (nonatomic, strong) id img;

@end

/**
 内部使用的布局模型id
 */
@interface XKShareItemModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

+ (instancetype)modelWithId:(NSString *) id img:(NSString *) img title:(NSString *) title;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XKCustomShareView : UIView
// 点击第三方分享是否自动分享，默认为NO 开启自动分享 不需要关心内部实现
@property (nonatomic, assign) BOOL autoThirdShare;
// 自定义视图 默认为nil
@property (nonatomic, strong, nullable) UIView *customView;
// 代理 默认为nil
@property (nonatomic, weak, nullable) id<XKCustomShareViewDelegate> delegate;
// 显示方式 默认显示在中间
@property (nonatomic, assign) XKCustomShareViewLayoutType layoutType;
// 数据源
@property (nonatomic, strong) NSMutableArray <NSString *>*shareItems;
// 分享数据
@property (nonatomic, strong) XKShareDataModel *shareData;

/**
 显示
 */
- (void)showInView:(nullable UIView *) view;

/**
 隐藏
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
