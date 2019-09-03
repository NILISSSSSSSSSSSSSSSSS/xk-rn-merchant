//
//  XKCustomerSerEvaluateView.m
//  XKSquare
//
//  Created by william on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerEvaluateView.h"
#import "XKCommonStarView.h"
#import "XKTransformHelper.h"
@interface XKCustomerSerEvaluateView()<UIGestureRecognizerDelegate,XKCommonStarViewDelegate>


/**
 白色主背景
 */
@property (nonatomic, strong) UIView    *mainBackView;


/**
 标题
 */
@property (nonatomic, strong) UILabel   *titleLabel;

/**
 退出
 */
@property (nonatomic, strong) UIButton  *dismissButton;

/**
 星级评价
 */
@property (nonatomic, strong) XKCommonStarView  *starView;


/**
 提交
 */
@property (nonatomic, strong) UIButton  *submitButton;


@end
@implementation XKCustomerSerEvaluateView
#pragma mark – Life Cycle
-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self initViews];
        [self viewLayout];
    }
    return self;
}
#pragma mark - Events
-(void)dismissButtonClicked:(UIButton *)sender{
    [self dismissSelf];
}

-(void)submitButtonClicked:(UIButton *)sender{
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/lastCustomerServiceInfo/1.0"
                                timeoutInterval:10
                                     parameters:@{@"userId":[XKUserInfo getCurrentUserId]}
                                        success:^(id responseObject) {
                                            if (responseObject) {
                                                [self evaluateResonse:responseObject];
                                            }
                                            else{
                                                [XKHudView showErrorMessage:@"网络错误"];
                                            }
                                        } failure:^(XKHttpErrror *error) {
                                            [XKHudView showErrorMessage:@"网络错误"];
                                        }];
}

-(void)evaluateResonse:(id)responseObject{
    NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",responseObject]];
    int score = _starView.scorePercent * 5;
    if (dict[@"workOrderId"]){
        [HTTPClient postEncryptRequestWithURLString:@"sys/ua/workOrderEvaluate/1.0" timeoutInterval:10 parameters:@{@"id":dict[@"workOrderId"],@"level":[NSNumber numberWithInt:score]} success:^(id responseObject) {
            [XKHudView showSuccessMessage:@"评价成功"];
            [self dismissSelf];
        } failure:^(XKHttpErrror *error) {
            [XKHudView showErrorMessage:@"网络错误"];
        }];
    }
    else{
        [XKHudView showErrorMessage:@"网络错误"];
    }
}

#pragma mark – Private Methods
-(void)initViews{
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    dismissTap.delegate = self;
    [self addGestureRecognizer:dismissTap];
    [self addSubview:self.mainBackView];
    [self.mainBackView addSubview:self.titleLabel];
    [self.mainBackView addSubview:self.dismissButton];
    [self.mainBackView addSubview:self.starView];
    [self.mainBackView addSubview:self.submitButton];
}

-(void)viewLayout{
    UIView *centerLine = [[UIView alloc]init];
    centerLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [_mainBackView addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self->_mainBackView);
        make.top.mas_equalTo(self->_mainBackView.mas_top).offset(40 * ScreenScale);
        make.height.mas_equalTo(0.5 * ScreenScale);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_mainBackView.mas_top);
        make.bottom.mas_equalTo(centerLine.mas_bottom);
        make.left.mas_equalTo(self->_mainBackView.mas_left).offset(10 * ScreenScale);
    }];
    
    [_dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_mainBackView.mas_right).offset(-8 * ScreenScale);
        make.centerY.mas_equalTo(self->_titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18 * ScreenScale, 18 * ScreenScale));
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_mainBackView.mas_centerY);
        make.centerX.mas_equalTo(self->_mainBackView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150, 30 * ScreenScale));
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(self->_mainBackView);
        make.height.mas_equalTo(50 * ScreenScale);
    }];
}

#pragma mark - Custom Delegates
-(void)starRateView:(XKCommonStarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    NSLog(@"%f",newScorePercent);
}

#pragma 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:_mainBackView];
    if (point.y >= 0) {
        return NO;
    }
    return YES;
}
#pragma mark – Getters and Setters


-(UIView *)mainBackView{
    if (!_mainBackView) {
        _mainBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT + ScreenScale * 277, SCREEN_WIDTH, 277 * ScreenScale)];
        _mainBackView.backgroundColor = [UIColor whiteColor];
    }
    return _mainBackView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"请为本次服务评价" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

-(UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_customerSer_evaluateDimiss"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

-(XKCommonStarView *)starView{
    if (!_starView) {
        _starView = [[XKCommonStarView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH - 150, 30 * ScreenScale) numberOfStars:5];
        _starView.userInteractionEnabled = YES;
        _starView.delegate = self;
    }
    return _starView;
}


-(UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17] title:@"提交评价" titleColor:[UIColor whiteColor] backColor:XKMainTypeColor];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
#pragma mark - 显示
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = RGBA(0, 0, 0, 0);
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.backgroundColor = RGBA(0, 0, 0, 0);
        weakSelf.mainBackView.bottom = weakSelf.height;
    }];
}

#pragma mark - 消失
- (void)dismissSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.mainBackView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
