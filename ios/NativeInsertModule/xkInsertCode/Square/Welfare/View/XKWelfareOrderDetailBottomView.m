//
//  XKWelfareOrderDetailBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareOrderDetailWaitSendBottomView.h"
#import "XKWelfareOrderDetailWaitAcceptBottomView.h"
#import "XKWelfareOrderDetailWaitOpenBottomView.h"
#import "XKWelfareOrderDetailBuyCarBottomView.h"
#import "XKWelfareOrderDetailFinishBottomView.h"
#import "XKWelfareOrderDetailSureOrderBottomView.h"
#import "XKWelfareDetailGoodsBottomView.h"
#import "XKMineCollectBottomView.h"
#import "XKWelfareOrderDetailWaitShareBottomView.h"
@interface XKWelfareOrderDetailBottomView ()
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIView *topLineView;
@property (nonatomic, strong)UIView *bottomLineView;
@end
@implementation XKWelfareOrderDetailBottomView

+ (instancetype)WelfareOrderDetailBottomViewWithType:(WelfareOrderDetailBottomViewType)viewType {
    switch (viewType) {
        case WelfareOrderDetailBottomViewWaitSend: {
            return [XKWelfareOrderDetailWaitSendBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewWaitAccept: {
            return [XKWelfareOrderDetailWaitAcceptBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewWaitOpen: {
            return [XKWelfareOrderDetailWaitOpenBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewBuyCar: {
            return [XKWelfareOrderDetailBuyCarBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewFinish: {
            return [XKWelfareOrderDetailFinishBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewSureOrder: {
            return [XKWelfareOrderDetailSureOrderBottomView new];
        }
            break;
        case WelfareOrderDetailBottomViewWaitShare: {
            return [XKWelfareOrderDetailWaitShareBottomView new];
        }
             break;
        case WelfareDetailBottomViewGoods: {
            return [XKWelfareDetailGoodsBottomView new];
        }
            break;
        case MineCollectBottomView: {
            return [XKMineCollectBottomView new];
        }
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 3;
        // 单边阴影 顶边
        float shadowPathWidth = self.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0, 0 - shadowPathWidth/2.0, SCREEN_WIDTH, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        self.layer.shadowPath = path.CGPath;
        [self addCustomSubviews];
        [self addUIConstraint];
        [self addBottomView];
        [self addBottomConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    
}

- (void)addUIConstraint {
    
}

- (void)addBottomView {
    [self addSubview:self.bottomView];
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
    self.bottomLineView.hidden = !iPhoneX;
}

- (void)addBottomConstraint {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(- kBottomSafeHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLineView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

- (UIView *)bottomView {
    if(!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}
@end
