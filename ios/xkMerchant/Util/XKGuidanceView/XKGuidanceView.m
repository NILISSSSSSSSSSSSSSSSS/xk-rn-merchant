//
//  XKGuidanceView.m
//  XKSquare
//
//  Created by Lin Li on 2019/1/18.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKGuidanceView.h"
NSInteger countNum = 0;

@interface XKGuidanceView ()

/// 图层
@property (nonatomic, weak)   CAShapeLayer   *fillLayer;
/// 当前路径
@property (nonatomic, strong) UIBezierPath   *overlayPath;
/// 透明区path数组
@property (nonatomic, strong) NSMutableArray *transparentPaths;
/// 图片数组
@property (nonatomic, strong) NSMutableArray *imageArr;
/// 图片frame数组
@property (nonatomic, strong) NSMutableArray *frameArr;
/// 手势点击计数
@property (nonatomic, assign) NSInteger index;
/// 图片顺序数组例：@[@2,@1,@3]表示第一个引导图是两个图片，第二个引导图是2个图片，第三个引导图是3个图片，数组的数量表示多少个引导页面，图片数量必须等于orderArr里面数字的总和，这里表示有6个图片
@property (nonatomic, strong) NSMutableArray *orderArr;
/// 是否单张循环，默认YES(引导页大于一个设置为No)
@property (nonatomic, assign) BOOL isSingle;

@end
@implementation XKGuidanceView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame: [UIScreen mainScreen].bounds];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.index = 0;
    self.isSingle = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIColor *maskColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.fillLayer.path      = self.overlayPath.CGPath;
    self.fillLayer.fillRule  = kCAFillRuleEvenOdd;
    self.fillLayer.fillColor = maskColor.CGColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickedMaskView)];
    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - 公有方法
//无顺序，单个引导页
- (void)addImage:(NSString *)imageName imageFrame:(NSValue *)imageframeValue TransparentRect:(NSValue *)transparentRectValue {
    NSArray * imageArr = @[imageName];
    NSArray * imgFrameArr = @[imageframeValue];
    NSArray * transparentRectArr = @[transparentRectValue];
    [self addImages:imageArr imageFrame:imgFrameArr TransparentRect:transparentRectArr];
}

//无顺序，单个引导页
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr TransparentRect:(NSArray *)rectArr{
    if (images.count != imageframeArr.count || images.count != rectArr.count) {
        return;
    }
    self.isSingle = YES;
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [UIImage imageNamed:obj];
        [self.imageArr addObject:image];
    }];
    
    self.frameArr = [imageframeArr mutableCopy];
    [self addImage:_imageArr[0] withFrame:[_frameArr[0] CGRectValue]];
    
    for (NSInteger i=0; i<rectArr.count; i++) {
        
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRoundedRect:[rectArr[i] CGRectValue] cornerRadius:5];
        [self.transparentPaths addObject:transparentPath];
    }
    [self addTransparentPath:_transparentPaths[0]];
    
}
//有顺序，单个引导页多张图片，多个引导页
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr TransparentRect:(NSArray *)rectArr orderArr:(NSArray *)orderArr{
    if (images.count != imageframeArr.count || images.count != rectArr.count) {
        return;
    }
    //判断顺序数组总数是否等于图片数组
    NSInteger numCount = 0;
    for (NSNumber * num in orderArr) {
        NSInteger order = [num integerValue];
        numCount += order;
    }
    if (numCount != images.count) {
        return;
    }
    
    self.isSingle = NO;
    self.orderArr = [orderArr mutableCopy];
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [UIImage imageNamed:obj];
        [self.imageArr addObject:image];
    }];
    self.frameArr = [imageframeArr mutableCopy];
    
    for (NSInteger i=0; i<rectArr.count; i++) {
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRoundedRect:[rectArr[i] CGRectValue] cornerRadius:5];
        [self.transparentPaths addObject:transparentPath];
    }
    
    // 控制多个显示逻辑
    for (NSInteger i=0; i<[orderArr[0] integerValue]; i++) {
        [self addImage:_imageArr[i] withFrame:[_frameArr[i] CGRectValue]];
        [self addTransparentPath:_transparentPaths[i]];
    }
    
}
//添加图片视图
- (void)addImage:(UIImage*)image withFrame:(CGRect)frame{
    
    UIImageView * imageView   = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image           = image;
    
    [self addSubview:imageView];
}
//赋值新的path
- (void)addTransparentPath:(UIBezierPath *)transparentPath {
    
    [self.overlayPath appendPath:transparentPath];
    self.fillLayer.path = self.overlayPath.CGPath;
}

#pragma mark - 显示/隐藏-点击事件

//显示
- (void)showMaskViewInView:(UIView *)view{
    
    self.alpha = 0;
    if (view != nil) {
        [view addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

//点击事件
- (void)tapClickedMaskView{
    _index++;
    if (_isSingle) {
        if (_index < _imageArr.count) {
            
            [self refreshMask];
            [self addTransparentPath:_transparentPaths[_index]];
            
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self addImage:_imageArr[_index] withFrame:[_frameArr[_index] CGRectValue]];
        }else{
            [self dismissMaskView];
            
        }
    }else{
        if (_index < _orderArr.count) {
            
            [self refreshMask];
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            // 控制多个显示逻辑
            NSInteger baseNum = [_orderArr[_index-1] integerValue];
            countNum = countNum + baseNum;
            NSInteger endNum = [_orderArr[_index] integerValue]+countNum;
            for (NSInteger i=countNum; i<endNum; i++) {
                
                [self addTransparentPath:_transparentPaths[i]];
                [self addImage:_imageArr[i] withFrame:[_frameArr[i] CGRectValue]];
            }
        }else{
            countNum = 0;
            [self dismissMaskView];
        }
    }
}

//隐藏
- (void)dismissMaskView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//将当前path设置为初始值，重置视图
- (void)refreshMask {
    
    UIBezierPath *overlayPath = [self generateOverlayPath];
    self.overlayPath = overlayPath;
    
}

//获取默认的path
- (UIBezierPath *)generateOverlayPath {
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    return overlayPath;
}

#pragma mark - 懒加载Getter Methods

- (UIBezierPath *)overlayPath {
    if (!_overlayPath) {
        _overlayPath = [self generateOverlayPath];
    }
    
    return _overlayPath;
}

- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        [self.layer addSublayer:fillLayer];
        
        _fillLayer = fillLayer;
    }
    
    return _fillLayer;
}

- (NSMutableArray *)transparentPaths {
    if (!_transparentPaths) {
        _transparentPaths = [NSMutableArray array];
    }
    
    return _transparentPaths;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    
    return _imageArr;
}

- (NSMutableArray *)frameArr {
    if (!_frameArr) {
        _frameArr = [NSMutableArray array];
    }
    
    return _frameArr;
}

- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    
    return _orderArr;
}


@end

@implementation UIView (Guidance)

/**
 获取当前view在window上的坐标
 */
- (CGRect)getWindowFrame {
    return [self.superview convertRect:self.frame toView:KEY_WINDOW];
}


@end
