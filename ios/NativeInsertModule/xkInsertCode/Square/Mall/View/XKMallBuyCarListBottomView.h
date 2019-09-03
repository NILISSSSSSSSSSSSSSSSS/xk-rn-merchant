//
//  XKMallBuyCarListBottomView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallBuyCarListBottomView : UIView
//布局状态  0 未管理  1 管理 针对于购物车
@property (nonatomic, assign)NSInteger type;
/**合计*/
@property (nonatomic, strong)UILabel *countLabel;
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


- (void)allChose:(BOOL)chose;
@end
