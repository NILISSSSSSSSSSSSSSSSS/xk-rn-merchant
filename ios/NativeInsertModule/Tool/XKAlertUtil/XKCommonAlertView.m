//
//  CommonAlertView.m
//  UUHaoFang
//
//  Created by 正合适 on 16/7/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "XKCommonAlertView.h"
#import <Masonry/Masonry.h>
#import "UIView+dismiss.h"
#import <XKCommonDefine.h>
#import <NSString+Utils.h>
#import <UIView+YYAdd.h>
#import <UIFont+XKFont.h>

#define BUTTON_TAG 100

@interface XKCommonAlertView()

@property (nonatomic, copy) LeftActionBlock leftActionBlock;// 标题
@property (nonatomic, copy) RightActionBlock rightActionBlock;
@property (nonatomic, copy) CloseActionBlock closeActionBlock;
@property (nonatomic, copy) DismissActionBlock dismissActionBlock;
/**点击messageLabel的回调*/
@property (nonatomic, copy) LeftActionBlock messageActionBlock;

@property (nonatomic, copy) NSString *titleStr;// 标题
@property (nonatomic, copy) NSString *messageStr;// 内容
/**内容属性字符串*/
@property (nonatomic, strong) NSAttributedString *messageAttrStr;
@property (nonatomic, copy) NSString *leftBtnStr;// 左边按钮文字
@property (nonatomic, strong) NSString *rightBtnStr;// 右边按钮文字

@property (nonatomic, strong) UILabel *titleLabel;// 标题Label
@property (nonatomic, strong) UILabel *messageLabel;// 内容Label
@property (nonatomic, strong) UIButton *leftButton;// 左边按钮
@property (nonatomic, strong) UIButton *rightButton;// 右边按钮
@property (nonatomic, strong) UIView *containerView;// 容器view

@property (nonatomic, assign) BOOL isBackgroundViewTaped;// 背景是否可以点击消失
@property (nonatomic, assign) NSTextAlignment messageAligment;// 内容对齐方式
@property (nonatomic, strong) UIButton *closeButton;// 关闭按钮

@end

@implementation XKCommonAlertView

#pragma mark - 初始化
- (instancetype)initWithTitle:(NSString *)titleString message:(NSString *)messageString leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftActionBlock)leftBlock rightBlock:(RightActionBlock)rightBlock textAlignment:(NSTextAlignment)textAlignment {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _isBackgroundViewTaped = NO;
        _titleStr = titleString;
        _messageStr = messageString;
        _leftBtnStr = leftButtonString;
        _rightBtnStr = rightButtonString;
        _leftActionBlock = [leftBlock copy];
        _rightActionBlock = [rightBlock copy];
        [self initUI];
        _messageLabel.textAlignment = textAlignment;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)titleString messageAttribute:(NSAttributedString *)message messageBlock:(LeftActionBlock)messageBlock leftButton:(NSString *)leftButtonString rightButton:(NSString *)rightButtonString leftBlock:(LeftActionBlock)leftBlock rightBlock:(RightActionBlock)rightBlock textAlignment:(NSTextAlignment)textAlignment {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _isBackgroundViewTaped = NO;
        _titleStr = titleString;
        _messageAttrStr = message;
        _messageActionBlock = messageBlock;
        _leftBtnStr = leftButtonString;
        _rightBtnStr = rightButtonString;
        _leftActionBlock = [leftBlock copy];
        _rightActionBlock = [rightBlock copy];
        [self initUI];
        _messageLabel.textAlignment = textAlignment;
    }
    return self;
}

#pragma mark - 初始化界面
- (void)initUI {
    XKWeakSelf(ws);
    UIColor *themeColor = RGB(51, 150, 251);
    // 背景颜色
    self.backgroundColor = RGBA(0, 0, 0, 0.4);
    // 手势view
    UIView *tapGestureView = [[UIView alloc] init];
    tapGestureView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapGestureView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTaped)];
    [tapGestureView addGestureRecognizer:tapGesture];
    // 容器view
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = ScreenScale * 10;
    _containerView.hidden = YES;
    [self addSubview:_containerView];
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = RGBGRAY(51);
    _titleLabel.text = _titleStr;
    [_containerView addSubview:_titleLabel];
    // 内容
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
    _messageLabel.textColor = RGBGRAY(102);
    
    NSMutableAttributedString *mutStr = nil;
    if (_messageAttrStr) {
        mutStr = [[NSMutableAttributedString alloc] initWithAttributedString:_messageAttrStr];
    } else {
        if (!_messageStr) {
            _messageStr = @"";
        }
        mutStr = [[NSMutableAttributedString alloc] initWithString:_messageStr];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [mutStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, _messageStr.length)];
    _messageLabel.attributedText = mutStr;
    [_containerView addSubview:_messageLabel];
    if (_messageActionBlock) {
        _messageLabel.userInteractionEnabled = YES;
        [_messageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesMessageAction)]];
    }
    
    // 横向分割线
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = RGBGRAY(231);
    [_containerView addSubview:hLine];
    // 左边按钮
    _leftButton = [[UIButton alloc] init];
    _leftButton.tag = BUTTON_TAG+0;
    _leftButton.backgroundColor = [UIColor clearColor];
    _leftButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:16];
    [_leftButton setTitleColor:themeColor forState:UIControlStateNormal];
    [_leftButton setTitle:_leftBtnStr forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_leftButton];
    // 右边按钮
    _rightButton = [[UIButton alloc] init];
    _rightButton.tag = BUTTON_TAG+1;
    _rightButton.backgroundColor = [UIColor clearColor];
    _rightButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:16];
    [_rightButton setTitle:_rightBtnStr forState:UIControlStateNormal];
    [_rightButton setTitleColor:themeColor forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_rightButton];
    // 竖向分割线
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = RGBGRAY(231);
    [_containerView addSubview:vLine];
    if (_leftBtnStr == nil) {
        _leftButton.hidden = YES;
        vLine.hidden = YES;
    } else if (_rightBtnStr == nil) {
        _rightButton.hidden = YES;
        vLine.hidden = YES;
    }
    
    // 关闭按钮
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.hidden = YES;
    [_containerView addSubview:_closeButton];
    
    // 添加约束
    
    [tapGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(375 * kLMSScreenFit(0.95, 0.85, 0.7));
        make.height.lessThanOrEqualTo(@(SCREEN_HEIGHT - 50));
        make.center.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.containerView.mas_top).offset(20);
        make.left.right.equalTo(ws.containerView);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ws.titleStr) {
            make.top.equalTo(ws.titleLabel.mas_bottom).offset(20);
        } else {
            make.top.equalTo(ws.containerView.mas_top).offset(30);
        }
        make.left.equalTo(ws.containerView.mas_left).offset(13);
        make.right.equalTo(ws.containerView.mas_right).offset(-13);
    }];
    
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.messageLabel.mas_bottom).offset(20);
        make.left.right.equalTo(ws.containerView);
        make.height.mas_equalTo(0.3 * [UIScreen mainScreen].scale);
        if (!ws.leftBtnStr && !ws.rightBtnStr) {
            make.height.mas_equalTo(0);
            make.bottom.equalTo(ws.containerView.mas_bottom);
        } else {
            make.bottom.equalTo(ws.leftButton.mas_top);
            make.bottom.equalTo(ws.rightButton.mas_top).priority(500);
        }
        
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.containerView.mas_left);
        make.top.equalTo(hLine.mas_bottom);
        make.bottom.equalTo(ws.containerView.mas_bottom);
        if (ws.rightBtnStr == nil) {
            make.right.equalTo(ws.containerView.mas_right);
        } else {
            make.right.equalTo(vLine.mas_left);
        }
        
        make.height.mas_equalTo(45);
    }];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine.mas_bottom);
        make.centerX.equalTo(ws.containerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(0.3 * [UIScreen mainScreen].scale, 45));
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine.mas_bottom);
        if (ws.leftBtnStr == nil) {
            make.left.equalTo(ws.containerView.mas_left);
        } else {
            make.left.equalTo(vLine.mas_right);
        }
        make.right.equalTo(ws.containerView.mas_right);
        make.bottom.equalTo(ws.containerView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.containerView.mas_top).offset(5);
        make.right.equalTo(ws.containerView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
}

#pragma mark - 出现的放大缩小动画
- (void)showScaleWithView:(UIView*)view {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03, 1.03, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.97, 0.97, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [view.layer addAnimation:animation forKey:nil];
    view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        view.alpha = 1;
    }];
    CGFloat al = self.alpha;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = al;
    }];
}


#pragma mark - 点击消息
- (void)touchesMessageAction {
    if(self.messageActionBlock) {
        self.messageActionBlock();
    }
}

#pragma mark - 按钮点击Action
- (void)buttonAction:(UIButton *)sender {
    NSInteger flag = sender.tag - BUTTON_TAG;
    if (flag == 0) {// 左边按钮
        if(_leftActionBlock) {
            self.leftActionBlock();
        }
    } else {// 右边按钮
        if(_rightActionBlock) {
            self.rightActionBlock();
        }
    }
    [self dismiss];
}

#pragma mark - 背景点击消失
- (void)bgTaped {
    if (_isBackgroundViewTaped) {
        [self dismiss];
    } else {
        return;
    }
}

#pragma mark - 关闭按钮
- (void)closeButtonAction {
    if(_closeActionBlock) {
        self.closeActionBlock();
    }
    [self dismiss];
}

#pragma mark - 移除self
- (void)dismiss {
    if(self.dismissActionBlock) {
        self.dismissActionBlock();
    }
    [self removeFromSuperview];
    if(self.popviewDismissBlock) {
        self.popviewDismissBlock();
    }
}

#pragma mark - ----------------暴露的只读属性----------------
#pragma mark - 内容信息
- (NSString *)message {
    return _messageStr;
}

#pragma mark - ----------------暴露的公用方法----------------
#pragma mark - 弹框
- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.containerView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        if (self.containerView) {
            [self showScaleWithView:self.containerView];
        }
        [self setPopviewDismissBlock:^{
        }];
    });
}

#pragma mark - 设置左边按钮颜色
- (void)setLeftButtonColor:(UIColor *)color {
    if (color) {
        [_leftButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - 设置右边按钮颜色
- (void)setRightButtonColor:(UIColor *)color {
    if (color) {
        [_rightButton setTitleColor:color forState:UIControlStateNormal];
    }
}

#pragma mark - 设置标题颜色
- (void)setTitleColor:(UIColor *)color {
    if (color) {
        _titleLabel.textColor = color;
    }
}

#pragma mark - 设置内容颜色
- (void)setMessageColor:(UIColor *)color {
    if (color) {
        _messageLabel.textColor = color;
    }
}

#pragma mark - 设置内容的对齐方式
- (void)setMessageAligment:(NSTextAlignment)aligment {
    _messageLabel.textAlignment = aligment;
}

/**
 *  设置标题字体大小
 *
 *  @param value 大小
 */
- (void)setTitleFontSize:(CGFloat)value {
    _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:value];
}

/**
 *  设置内容字体大小
 *
 *  @param value 大小
 */
- (void)setMessageFontSize:(CGFloat)value {
    _messageLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:value];
}

/**
 *  设置按钮字体大小
 *
 *  @param value 大小
 */
- (void)setButtonFontSize:(CGFloat)value {
    _leftButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:value];
    _rightButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:value];
}

#pragma mark - 设置背景颜色
- (void)setBGColor:(UIColor *)color {
    if (color) {
        self.backgroundColor = color;
    }
}

#pragma mark - 设置背景是可以点击消失
- (void)setBackgroundViewCouldTaped:(BOOL)isTaped {
    _isBackgroundViewTaped = isTaped;
}

#pragma mark - 设置是否隐藏关闭按钮
- (void)setCloseButtonHidden:(BOOL)isHidden {
    _closeButton.hidden = isHidden;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)setContentRadius:(CGFloat)radius {
    _containerView.layer.cornerRadius = radius;
}

@end

