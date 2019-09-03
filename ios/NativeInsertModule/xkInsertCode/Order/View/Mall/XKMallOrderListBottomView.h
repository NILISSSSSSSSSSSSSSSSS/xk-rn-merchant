//
//  XKMallOrderBottomView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,MallOrderListBottomViewType) {
    MallOrderListBottomViewWaitPay,//待付款
    MallOrderListBottomViewWaitAccept,//待收货
    MallOrderListBottomViewWaitSend,//待发货
    MallOrderListBottomViewWaitFinish,//已完成
    MallOrderListBottomViewAfterSale,//售后
    
    MallOrderDetailBottomViewWaitPay,//代付款详情
    MallOrderDetailBottomViewWaitSend,//代发货详情
    MallOrderDetailWaitEvaluate,//待评价详情
    
};
@interface XKMallOrderListBottomView : UIView
+ (instancetype)MallOrderListBottomViewWithType:(MallOrderListBottomViewType)viewType;
- (void)choseAll:(BOOL)all;
//布局状态  0 未管理  1 管理 针对于购物车
@property (nonatomic, assign)NSInteger type;
/**
  合并付款
 */
@property (nonatomic, copy)void(^totalBtnBlock)(UIButton *sender);

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
 兑奖
 */
@property (nonatomic, copy)void(^redeemBlock)(UIButton *sender);

/**
 评论
 */
@property (nonatomic, copy)void(^evaluateBlock)(UIButton *sender);

/**
 购物车
 */
@property (nonatomic, copy)void(^joinBuyCarBlock)(UIButton *sender);
- (void)updatePrice:(long )price;

- (void)addCustomSubviews;

- (void)addUIConstraint;
@end
