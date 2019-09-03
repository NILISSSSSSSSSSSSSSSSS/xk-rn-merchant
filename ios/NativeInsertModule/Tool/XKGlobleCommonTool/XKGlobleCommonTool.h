//
//  XKGlobleCommonTool.h
//  XKSquare
//
//  Created by hupan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
typedef enum : NSUInteger {
    BannerIconType_home,
    BannerIconType_mall,
    BannerIconType_welfare,
    BannerIconType_tradingArea,
} BannerIconType;

@class XKSquareBannerModel;

@interface XKGlobleCommonTool : NSObject

/**
 根据模型 创建bannerView
 */
+ (UIView *)creatXKBannerView:(UIView *)view itemModel:(XKSquareBannerModel *)model itemTarget:(nullable id)target action:(nonnull SEL)sel;

/**
 bannerView进行app内部跳转
 */
+ (void)bannerViewJumpAppInner:(NSString *)modelString currentViewController:(BaseViewController *)currentViewController;


+ (void)jumpUserInfoCenter:(NSString *)userId vc:(UIViewController *)vc;

/**
 fixedArr:系统固定的
 notFixedArr:非固定的（包括自定义的）
 */
+ (NSArray *)recombineIconArrWithFixedArr:(NSMutableArray *)fixedArr notFixedArr:(NSMutableArray *)notFixedArr iconType:(BannerIconType)type;

/**
 查看大图  url/UIImage
 */
+ (void)showBigImgWithImgsArr:(NSArray *)arr viewController:(UIViewController *)viewController;
+ (void)showBigImgWithImgsArr:(NSArray *)arr defualtIndex:(NSInteger)index viewController:(UIViewController *)viewController;

+ (void)showSingleImgWithImg:(id)img viewController:(UIViewController *)viewController;

/**播放视频*/
+ (void)playVideoWithUrlStr:(NSString *)urlStr;
+ (void)playVideoWithUrl:(NSURL *)url;

+ (NSString *)getCurrentUserDeviceToken;

//获取H5界面需要的code
+ (NSString *)getH5CodeStr;

//设置用户订阅数据
+ (void)saveSubscriptionData;

/**获取视频长度*/
+ (NSInteger)calculateVideoTime:(NSURL *)url;


/**
 存储引导页面的bool值
 
 @param guidanceViewValue @{控制器名字:bool值}
 */
+ (void)saveGuidanceViewValue:(NSMutableDictionary *)guidanceViewValue;


/**
 获取存储引导页面的bool值
 */
+ (NSMutableDictionary *)getGuidanceViewValue;
/**
 检查当前引导页在控制器是否已经显示过
 
 @param key 当前控制器的字符串
 @return 是否已经展示过引导页 yes表示已经展示过了 默认是没有展示
 */
+ (BOOL)backShowGuidanceViewFromDictKey:(NSString *)key;
@end
