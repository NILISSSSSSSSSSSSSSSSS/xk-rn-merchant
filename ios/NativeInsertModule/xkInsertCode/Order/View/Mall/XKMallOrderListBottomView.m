//
//  XKMallOrderBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderListBottomView.h"
#import "XKMallOrderListWaitPayBottomView.h"
#import "XKMallOrderDetailWaitEvaluateBottomView.h"
#import "XKMallOrderBottomViewAfterSaleView.h"
#import "XKMallOrderDetailWaitPayBottomView.h"
#import "XKMallOrderDetailWaitSendBottomView.h"
#import "XKMallOrderDetailWaitAcceptBottomView.h"
@interface XKMallOrderListBottomView ()
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIView *topLineView;
@property (nonatomic, strong)UIView *bottomLineView;
@end
@implementation XKMallOrderListBottomView

+ (instancetype)MallOrderListBottomViewWithType:(MallOrderListBottomViewType)viewType {
    switch (viewType) {
        case MallOrderListBottomViewWaitPay: {
            return [XKMallOrderListWaitPayBottomView new];
        }
            break;
        case MallOrderListBottomViewWaitSend: {
         
        }
            break;
        case MallOrderListBottomViewWaitAccept: {
            return [XKMallOrderDetailWaitAcceptBottomView new];
        }
            break;
        case MallOrderDetailWaitEvaluate: {
            return [XKMallOrderDetailWaitEvaluateBottomView new];
        }
            break;
        case MallOrderDetailBottomViewWaitPay: {
            return [XKMallOrderDetailWaitPayBottomView new];
        }
            break;
        case MallOrderDetailBottomViewWaitSend: {
            return [XKMallOrderDetailWaitSendBottomView new];
        }
            break;
        case MallOrderListBottomViewWaitFinish: {
          
        }
            break;
        case MallOrderListBottomViewAfterSale: {
            return  [XKMallOrderBottomViewAfterSaleView new];
        }
            break;

    }
    return nil;
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

- (void)choseAll:(BOOL)all {
    
}

- (void)addBottomView {
    [self addSubview:self.bottomView];
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
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
