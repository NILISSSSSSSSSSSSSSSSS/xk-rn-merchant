//
//  XKGoodsHistoryReusableView.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^buttonBlock)(UIButton *button);

@interface XKGoodsHistoryReusableView : UICollectionReusableView
/**自营商城按钮回调*/
@property(nonatomic, copy) buttonBlock autotrophyButtonBlock;
/**商圈按钮回调*/
@property(nonatomic, copy) buttonBlock businessButtonBlock;
@end

NS_ASSUME_NONNULL_END
