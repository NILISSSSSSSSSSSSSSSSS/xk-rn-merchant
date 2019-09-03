//
//  XKCustomNavBar.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCustomSearchBar.h"
typedef void(^LeftBlock)(void);

typedef void(^RightBlock)(UIButton *sender);

typedef void(^SearchBlock)(void);

typedef void(^MessageBlock)(void);

typedef void(^BuyCarBlock)(void);

typedef void(^OrderBlock)(void);

typedef void(^LayoutBlock)(void);

typedef void(^WelfareBlock)(void);

typedef void(^MallBlock)(void);

typedef void(^BusinessBlock)(void);

typedef void(^MoreBlock)(void);

typedef void(^InputBlock)(NSString *text);

@interface XKCustomNavBar : UIView

@property (nonatomic, strong) UIButton *backButton;   //返回按钮
@property (nonatomic, strong) UIButton *rightButton;  //右边按钮
@property (nonatomic, strong) UIButton *searchButton; //搜索按钮
@property (nonatomic, strong) UILabel *titleLabel;    //标题
@property (nonatomic, strong) UIView * lineView;      //线条
@property (nonatomic, copy)  NSString  * titleString;
@property (nonatomic, strong) XKCustomSearchBar  *searchBar;
/**是否隐藏右侧按钮*/
@property (nonatomic, assign) BOOL isHideRightButton;

//创建基类导航栏
- (void)customBaseNavigationBar;

//创建两个按钮和标题的导航栏，提供标题和右边按钮文字接口
- (void)customNaviBarWithTitle:(NSString *)title andRightButtonTitle:(NSString *)buttonTitle andRightColor:(UIColor *)color;
// 创建两个按钮和标题的导航栏，提供标题和右边按钮的图片接口
- (void)customNaviBarWithTitle:(NSString *)title andRightButtonImageTitle:(NSString *)buttonImageTitle;

//福利定制导航栏
- (void)customWelfareNaviBar;
//福利定制新导航栏
- (void)customWelfareNewNaviBar;
//订单定制导航栏
- (void)customMainOrderNaviBar;
//搜索定制导航栏
- (void)customSearchNaviBar;
- (void)deleteSubviews;


//左边按钮block
@property (nonatomic, copy) LeftBlock leftButtonBlock;
//右边按钮block
@property (nonatomic, copy) RightBlock rightButtonBlock;
//搜索按钮block
@property (nonatomic, copy) SearchBlock searchButtonBlock;
//消息按钮block
@property (nonatomic, copy) MessageBlock messageButtonBlock;
//购物车按钮block
@property (nonatomic, copy) BuyCarBlock buyCarButtonBlock;
//订单按钮block
@property (nonatomic, copy) OrderBlock orderButtonBlock;
//布局按钮block
@property (nonatomic, copy) LayoutBlock layoutButtonBlock;
//福利按钮block
@property (nonatomic, copy) WelfareBlock welfareButtonBlock;
//商城按钮block
@property (nonatomic, copy) MallBlock mallButtonBlock;
//商圈按钮block
@property (nonatomic, copy) BusinessBlock businessButtonBlock;
//更多按钮block
@property (nonatomic, copy) MoreBlock moreButtonBlock;
//输入框搜索block
@property (nonatomic, copy) InputBlock inputTextFieldBlock;
- (void)selectLeftButton:(LeftBlock)block;

- (void)selectRightButton:(RightBlock)block;

- (void)selectSearchButton:(SearchBlock)block;

- (void)setRightButtonTitle:(NSString *)title;

- (void)setRightButton:(NSString *)title color: (UIColor*) color;
@end
