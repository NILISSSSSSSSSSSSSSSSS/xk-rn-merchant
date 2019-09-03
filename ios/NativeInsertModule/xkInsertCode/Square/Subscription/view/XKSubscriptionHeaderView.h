//
//  XKSubscriptionHeaderView.h
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^delBlock)(UIButton *sender);
@interface XKSubscriptionHeaderView : UITableViewHeaderFooterView

- (void)cutCorner:(BOOL)cut;
- (void)setTitleName:(NSString *)name;
- (void)setTitleColor:(UIColor *)color font:(UIFont *)font;
/**删除的回调*/
@property(nonatomic, copy) delBlock delBlock;
/**是否显示删除按钮*/
@property(nonatomic, assign) BOOL isShowDelButton;
@end
