//
//  XKCustomNavBar.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomNavBar.h"
@interface XKCustomNavBar ()<UITextFieldDelegate> {
    NSInteger rightType;
    BOOL rightButtonSelected;
}

//福利订单的导航栏按钮
/**消息*/
@property (nonatomic, strong) UIButton *messageBtn;
/**购物车*/
@property (nonatomic, strong) UIButton *buyCarBtn;
/**订单*/
@property (nonatomic, strong) UIButton *orderBtn;
/**结构变化*/
@property (nonatomic, strong) UIButton *layoutBtn;
//订单一级界面的导航栏按钮
/**福利商城*/
@property (nonatomic, strong) UIButton *welfareBtn;
/**商城*/
@property (nonatomic, strong) UIButton *mallBtn;
/**商圈*/
@property (nonatomic, strong) UIButton *businessBtn;
/**更多*/
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *segmentationLine;         //按钮间隔分割线线
@property (nonatomic, strong)UIView *navigationLine;    //导航栏下划线
@end

@implementation XKCustomNavBar

// 初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NavigationAndStatue_Height);
        self.backgroundColor = XKMainTypeColor;
    }
    return self;
}

#pragma mark - 源生导航栏定制与封装
//基类导航栏  默认
- (void)customBaseNavigationBar {
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, kIphoneXNavi(10), 64, 64);
//    _backButton.imageEdgeInsets = UIEdgeInsetsMake(kIphoneXNavi(27),0,0,0);
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *leftImg = [UIImage imageNamed:@"xk_navigationBar_global_back"];
    [_backButton setImage:leftImg forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, kIphoneXNavi(22), SCREEN_WIDTH-128, 40)];
    [self addSubview:_titleLabel];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:18]];
    _titleLabel.text = self.titleString;

}

- (void)customWelfareNaviBar {
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, kIphoneXNavi(10), 40, 64);
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *leftImg = [UIImage imageNamed:@"xk_navigationBar_global_back"];
    [_backButton setImage:leftImg forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backButton.frame) + 5, kIphoneXNavi(27), SCREEN_WIDTH - 190, 30)];
    _searchBar.textField.delegate = self;
    [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]  tintColor:RGBA(255, 204, 207, 1) textFont:[UIFont systemFontOfSize:15] textColor:RGBA(255, 204, 207, 1) textPlaceholderColor:RGBA(255, 204, 207, 1) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
    _searchBar.textField.placeholder = @"搜索你想要的商品";
    _searchBar.textField.textColor = [UIColor whiteColor];
     [self addSubview:_searchBar];
    
    _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchBar.frame) + 10, kIphoneXNavi(33), 20, 20)];
    [_messageBtn addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_messageBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_order_message"] forState:0];
    [self addSubview:_messageBtn];
    
    _buyCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_messageBtn.frame) + 10, kIphoneXNavi(33), 20, 20)];
    [_buyCarBtn addTarget:self action:@selector(buyCarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buyCarBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_buyCar"] forState:UIControlStateNormal];
    [self addSubview:_buyCarBtn];
    
    _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_buyCarBtn.frame) + 10, kIphoneXNavi(33), 20, 20)];
    [_orderBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_order"] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_orderBtn];
    
    _segmentationLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderBtn.frame) + 10, kIphoneXNavi(33), 0.5, 20)];
    _segmentationLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:_segmentationLine];
    
    _layoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_segmentationLine.frame) + 10, kIphoneXNavi(33), 20, 20)];
    [_layoutBtn addTarget:self action:@selector(layoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layoutxk_btn_mall_one"] forState:UIControlStateNormal];
    [self addSubview:_layoutBtn];
}

- (void)customWelfareNewNaviBar {
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, kIphoneXNavi(10), 40 , 64);
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *leftImg = [UIImage imageNamed:@"xk_navigationBar_global_back"];
    [_backButton setImage:leftImg forState:UIControlStateNormal];
    [self addSubview:_backButton];
    
    _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backButton.frame) + 5, kIphoneXNavi(27), SCREEN_WIDTH - 170, 30)];
    _searchBar.textField.delegate = self;
    [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]  tintColor:RGBA(255, 204, 207, 1) textFont:[UIFont systemFontOfSize:15] textColor:RGBA(255, 204, 207, 1) textPlaceholderColor:RGBA(255, 204, 207, 1) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
    _searchBar.textField.placeholder = @"搜索你想要的商品";
    _searchBar.textField.textColor = [UIColor whiteColor];
    [self addSubview:_searchBar];
    
    _orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, kIphoneXNavi(33), 20, 20)];
    [_orderBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_order"] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_orderBtn];

    _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, kIphoneXNavi(33), 20, 20)];
    [_messageBtn addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_messageBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_order_message"] forState:0];
    [self addSubview:_messageBtn];
    
    _buyCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, kIphoneXNavi(33), 20, 20)];
    [_buyCarBtn addTarget:self action:@selector(buyCarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buyCarBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_buyCar"] forState:UIControlStateNormal];
    [self addSubview:_buyCarBtn];
}

- (void)customMainOrderNaviBar {
    CGFloat btnW = (SCREEN_WIDTH - 100)/3;
    _welfareBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, kIphoneXNavi(20), btnW, 44)];
    [_welfareBtn addTarget:self action:@selector(welfareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_welfareBtn setTitle:@"积券夺奖" forState:0];
    _welfareBtn.selected = YES;
    [_welfareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_welfareBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:0];
    _welfareBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.f];
    _welfareBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [self addSubview:_welfareBtn];
    
    _mallBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_welfareBtn.frame), kIphoneXNavi(20), btnW, 44)];
    [_mallBtn addTarget:self action:@selector(mallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mallBtn setTitle:@"实体商家" forState:0];
    _mallBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.f];
    _mallBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentCenter;
    [_mallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_mallBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:0];
    [self addSubview:_mallBtn];
    
    _businessBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mallBtn.frame) , kIphoneXNavi(20), btnW, 44)];
    [_businessBtn setTitle:@"线上商城" forState:0];
    [_businessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_businessBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:0];
    _businessBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.f];
    _businessBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_businessBtn addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_businessBtn];
}

// 创建两个按钮和标题的导航栏，提供标题和右边按钮的图片接口
- (void)customNaviBarWithTitle:(NSString *)title andRightButtonImageTitle:(NSString *)buttonImageTitle {
    [self customBaseNavigationBar];
    _titleLabel.text = title;
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 64, kIphoneXNavi(10), 64, 64)];
    [self addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImage:[UIImage imageNamed:buttonImageTitle] forState:UIControlStateNormal];

}

//创建两个按钮和标题的导航栏，提供标题和右边按钮文字接口
- (void)customNaviBarWithTitle:(NSString *)title andRightButtonTitle:(NSString *)buttonTitle andRightColor:(UIColor *)color{
    
    [self customBaseNavigationBar];
    _titleLabel.text = title;
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, kIphoneXNavi(22) , 70, 40)];
    _rightButton.enabled = buttonTitle.length > 0;
    [self addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_rightButton setTitleColor:color forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    [self addSubview:_rightButton];
}

//创建一个搜索栏和一个返回按钮的导航栏
- (void)customSearchNaviBar {
    [self customBaseNavigationBar];
    _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backButton.frame) - 10, kIphoneXNavi(27), (375 - CGRectGetMaxX(_backButton.frame) - 20) * SCREEN_WIDTH / 375, 30)];
    _searchBar.textField.delegate = self;
    [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]  tintColor:RGBA(255, 204, 207, 1) textFont:[UIFont systemFontOfSize:15] textColor:RGBA(255, 204, 207, 1) textPlaceholderColor:RGBA(255, 204, 207, 1) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
    _searchBar.textField.placeholder = @"搜索你想要的商品";
    _searchBar.textField.textColor = [UIColor whiteColor];
    [self addSubview:_searchBar];
}

- (void)setRightButtonTitle:(NSString *)title {
    if (_rightButton) {
        [_rightButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setRightButton:(NSString *)title color: (UIColor*) color {
    if (!_rightButton)
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, kStatusBarHeight, 70, 40)];
    [self addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setTitleColor:color forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

/*
 所有导航栏均有返回和title

 */
- (void)createRightButtonWithType:(NSInteger)type {
    _navigationLine = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationAndStatue_Height - 1, SCREEN_WIDTH, 1)];
    [self addSubview:_navigationLine];
//    _navigationLine.backgroundColor = UU_THEME_DEFAULTCOLOR_LINEGRAY1;
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 64, kStatusBarHeight, 64, 40)];
    [self addSubview:_rightButton];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightType = type;
    switch (type) {
        case 0:
            _rightButton.hidden = YES;
            _rightButton.enabled = NO;
            break;
        case 1:
            _rightButton.hidden = YES;
            _rightButton.enabled = NO;
            _navigationLine.hidden = YES;
            break;
        case 2:

            break;
        case 3:
            //分享按钮
            [_rightButton setImage:[UIImage imageNamed:@"share_"] forState:UIControlStateNormal];
            
            break;
        case 4:
            //红包按钮
            //[_rightButton setImage:[UIImage imageNamed:@"hongbao_"] forState:UIControlStateNormal];
            _navigationLine.hidden = YES;
            break;
        case 5:
            //完成
            [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        //    [_rightButton setTitleColor:NaviBarWorldColor forState:UIControlStateNormal];
            _navigationLine.hidden = YES;
            break;
        case 6:
            //
//            [_rightButton setTitle:DIDIName forState:UIControlStateNormal];
//            [_rightButton setTitleColor:NaviBarWorldColor forState:UIControlStateNormal];
            _navigationLine.hidden = YES;
            break;
        case 8:
        {

        }
            break;
            
        default:
            break;
    }
    
}

//返回按钮点击事件实现
- (void)backButtonClicked:(UIButton *)sender {
    __weak typeof(self)wekSelf = self;
    if (wekSelf.leftButtonBlock) {
        wekSelf.leftButtonBlock();
    }
}

- (void)selectLeftButton:(LeftBlock)block {
    
    self.leftButtonBlock = block;
}

//右边按钮点击事件实现
- (void)rightButtonClicked:(UIButton *)sender {
    if (rightType == 2) {
        if (rightButtonSelected == NO) {
            rightButtonSelected = YES;
            [_rightButton setImage:[UIImage imageNamed:@"list2_"] forState:UIControlStateNormal];
        }else {
            rightButtonSelected = NO;
            [_rightButton setImage:[UIImage imageNamed:@"map_"] forState:UIControlStateNormal];
        }
    }
    if (self.rightButtonBlock) {
        self.rightButtonBlock(sender);
    }
}

//消息按钮点击事件
- (void)messageButtonClicked:(UIButton *)sender {
    if (self.messageButtonBlock) {
        self.messageButtonBlock();
    }
}

//购物车按钮点击事件
- (void)buyCarButtonClicked:(UIButton *)sender {
    if (self.buyCarButtonBlock) {
        self.buyCarButtonBlock();
    }
}

//订单按钮点击事件
- (void)orderButtonClicked:(UIButton *)sender {
    if (self.orderButtonBlock) {
        self.orderButtonBlock();
    }
}

//布局按钮点击事件
- (void)layoutButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"xk_btn_mall_layoutxk_btn_mall_two"] forState:0];
    } else {
        [sender setImage:[UIImage imageNamed:@"xk_btn_mall_layoutxk_btn_mall_one"] forState:0];
    }
    if (self.layoutButtonBlock) {
        self.layoutButtonBlock();
    }
}
//福利按钮
- (void)welfareBtnClick:(UIButton *)sender {
    if (self.welfareButtonBlock) {
        self.welfareBtn.selected = YES;
        self.mallBtn.selected = NO;
        self.businessBtn.selected = NO;
        self.welfareButtonBlock();
    }
}

//商城按钮
- (void)mallBtnClick:(UIButton *)sender {
    if (self.mallButtonBlock) {
        self.welfareBtn.selected = NO;
        self.mallBtn.selected = YES;
        self.businessBtn.selected = NO;
        self.mallButtonBlock();
    }
}

//商圈按钮
- (void)businessBtnClick:(UIButton *)sender {
    if (self.businessButtonBlock) {
        self.welfareBtn.selected = NO;
        self.mallBtn.selected = NO;
        self.businessBtn.selected = YES;
        self.businessButtonBlock();
    }
}

//更多按钮
- (void)moreBtnClick:(UIButton *)sender {
    if (self.moreButtonBlock) {
        self.moreButtonBlock();
    }
}

- (void)selectRightButton:(RightBlock)block {
    
    self.rightButtonBlock = block;
}

//搜索按钮点击事件实现
- (void)searchButtonClicked:(UIButton *)sender {
    self.searchButtonBlock();
}

- (void)selectSearchButton:(SearchBlock)block {
    
    self.searchButtonBlock = block;
}

//删除子视图
- (void)deleteSubviews {
    NSArray* views = self.subviews;
    for (UIView* view in views) {
        [view removeFromSuperview];
    }
}

- (void)setIsHideRightButton:(BOOL)isHideRightButton {
    _isHideRightButton = isHideRightButton;
    _rightButton.hidden = _isHideRightButton;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(self.inputTextFieldBlock) {
        self.inputTextFieldBlock(textField.text);
    }
    return NO;
}

@end
