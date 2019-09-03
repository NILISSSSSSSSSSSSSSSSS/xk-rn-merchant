//
//  XKWelfareOrderDetailBottomView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,WelfareOrderDetailBottomViewType) {
    WelfareOrderDetailBottomViewWaitSend,//代发货
    WelfareOrderDetailBottomViewWaitAccept,//待收货
    WelfareOrderDetailBottomViewWaitOpen,//待开奖
    WelfareOrderDetailBottomViewWaitShare,//待分享
    WelfareOrderDetailBottomViewBuyCar,//购物车
    WelfareOrderDetailBottomViewFinish,//结算
    WelfareOrderDetailBottomViewSureOrder,//完成订单
    
    MineCollectBottomView,//收藏
    WelfareDetailBottomViewGoods,//福利商品详情
};
@interface XKWelfareOrderDetailBottomView : UIView
+ (instancetype)WelfareOrderDetailBottomViewWithType:(WelfareOrderDetailBottomViewType)viewType;

//布局状态  0 未管理  1 管理 针对于购物车
@property (nonatomic, assign)NSInteger type;
/**
 联系客服
 */
@property (nonatomic, copy)void(^chatBtnBlock)(UIButton *sender);

/**
 提醒
 */
@property (nonatomic, copy)void(^tipBtnBlock)(UIButton *sender);

/**
 确认收货
 */
@property (nonatomic, copy)void(^sureBtnBlock)(UIButton *sender);

/**
 更多
 */
@property (nonatomic, copy)void(^moreBtnBlock)(UIButton *sender);

/**
 结算
 */
@property (nonatomic, copy)void(^finishBlock)(UIButton *sender);

/**
 删除
 */
@property (nonatomic, copy)void(^deleteBlock)(UIButton *sender);

/**
 收藏
 */
@property (nonatomic, copy)void(^collectBlock)(UIButton *sender);

/**
 全选/反选
 */
@property (nonatomic, copy)void(^choseBlock)(UIButton *sender);

/**
 支付
 */
@property (nonatomic, copy)void(^payBlock)(UIButton *sender);

/**
 分享
 */
@property (nonatomic, copy)void(^shareBlock)(UIButton *sender);

/**
 兑奖
 */
@property (nonatomic, copy)void(^redeemBlock)(UIButton *sender);

/**
 购物车
 */
@property (nonatomic, copy)void(^joinBuyCarBlock)(UIButton *sender);

- (void)addCustomSubviews;

- (void)addUIConstraint;

- (void)sureBuyTitle:(NSString *)title;

- (void)allChose:(BOOL)all;
@end
