//
//  XKMineMainViewSocialContactTableHeaderView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 社交类型 */
typedef NS_ENUM(NSInteger, XKMineMainViewSocialContactTableHeaderViewSocialContactControlsState) {
    XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateFans = 0,   /**< 粉丝 */
    XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatePraise,     /**< 获赞 */
    XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatedFocus,     /**< 关注 */
    XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateCollect,    /**< 收藏 */
    XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateComment     /**< 点评 */
};

/** 消耗品类型 */
typedef NS_ENUM(NSInteger, XKMineMainViewSocialContactTableHeaderViewConsumablesControlsState) {
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCouponPackage = 0,    /**< 卡券包 */
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCoin,                 /**< 晓可币 */
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateConsume,              /**< 消费券 */
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateMyGift,               /**< 我的礼物 */
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateWinningRecords,       /**< 我的获奖 */
    XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateRedEnvelope           /**< 红包 */
};

@class XKPersonalDataModel;

@protocol XKMineMainViewSocialContactTableHeaderViewDelegate <NSObject>

- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickHistoryButton:(UIButton *)sender;
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickSettingButton:(UIButton *)sender;
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickSocialContactControls:(XKMineMainViewSocialContactTableHeaderViewSocialContactControlsState)state;
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickConsumablesControls:(XKMineMainViewSocialContactTableHeaderViewConsumablesControlsState)state;

@end

@interface XKMineMainViewSocialContactTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<XKMineMainViewSocialContactTableHeaderViewDelegate> delegate;

/**
 *  配置用户个人信息
 *
 *  @param personalDataModel 个人信息模型
 *
 */
- (void)configHeaderViewWithPersonalDataModel:(XKPersonalDataModel *)personalDataModel;

/**
 *  配置社交及消耗品数量
 *
 *  @param dict 数量字典
 *
 */
- (void)configHeaderViewWithSocialContactCountDict:(NSDictionary *)dict;

/**
  根据scrollView滑动改变背景图片尺寸
 */
- (void)configHeaderViewBackgroundImageWithY:(CGFloat)y;

@end
