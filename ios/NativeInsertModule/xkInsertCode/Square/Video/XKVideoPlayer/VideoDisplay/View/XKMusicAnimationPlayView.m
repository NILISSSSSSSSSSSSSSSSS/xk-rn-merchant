//
//  XKMusicPlayView.m
//  TestDouYinMusicPlayAnimation
//
//  Created by smkj on 2018/8/14.
//  Copyright © 2018年 smkj. All rights reserved.
//

#import "XKMusicAnimationPlayView.h"

@interface XKMusicAnimationPlayView ()<CAAnimationDelegate>

@property (nonatomic,strong) NSMutableArray *imageViewArray;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSTimer *animationTimer;
@property (nonatomic,strong) UIImageView *image1;
@property (nonatomic,strong) UIImageView *image2;
@property (nonatomic,strong) UIImageView *image3;
@property (nonatomic,strong) UIImageView *image4;
@property (nonatomic,assign) NSInteger index;

@end

@implementation XKMusicAnimationPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.imageViewArray = [NSMutableArray array];
    self.imageArray = @[@"xk_ic_video_display_note_one", @"xk_ic_video_display_note_two"];
    self.image1= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.image1.center = CGPointMake(70 * ScreenScale, 100 * ScreenScale - 5);
    self.image1.alpha = 0;
    [self addSubview:self.image1];
    
    self.image2= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.image2.center = CGPointMake(70 * ScreenScale, 100 * ScreenScale - 5);
    self.image2.alpha = 0;
    [self addSubview:self.image2];
    
    self.image3= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.image3.center = CGPointMake(70 * ScreenScale, 100 * ScreenScale - 5);
    self.image3.alpha = 0;
    [self addSubview:self.image3];
    
    self.image4= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.image4.center = CGPointMake(70 * ScreenScale, 100 * ScreenScale - 5);
    self.image4.alpha = 0;
    [self addSubview:self.image4];
    self.imageViewArray = [NSMutableArray array];
    
    [self.imageViewArray addObject:self.image1];
    [self.imageViewArray addObject:self.image2];
    [self.imageViewArray addObject:self.image3];
    [self.imageViewArray addObject:self.image4];
    
    self.index = 0;

}

- (void)startAnimation {
    
    [self playAnimation:nil];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playAnimation:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];

}

- (void)playAnimation:(NSTimer *)timer {

    int value = arc4random() % 2;

    UIImageView *imageView = self.imageViewArray[self.index];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.imageArray[value]]];;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70 * ScreenScale, 100 * ScreenScale + 5)];
    [path addQuadCurveToPoint:CGPointMake(40 * ScreenScale, 40 * ScreenScale) controlPoint:CGPointMake(0, 100 * ScreenScale)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    pathAnimation.removedOnCompletion = NO;
    
    // 逐渐变大
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];

    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]; //设置 X 轴和 Y 轴缩放比例都为1.0，而 Z 轴不变
    
    transformAnimation.removedOnCompletion = NO;

    // 旋转
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    
    rotateAnimation.toValue = [NSNumber numberWithFloat:2];
    
    rotateAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    rotateAnimation.removedOnCompletion = NO;
        
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[ pathAnimation, transformAnimation, rotateAnimation];
    animationGroup.duration = 3.0;
    animationGroup.delegate = self;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; //设置媒体调速运动；默认为
    animationGroup.removedOnCompletion = NO;
    [imageView.layer addAnimation:animationGroup forKey:@"animationGroup"];

    [UIView animateWithDuration:2 animations:^{
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
    self.index ++;
    if (self.index >= 3) {
        self.index = 0;
    }

}

- (void)stopAnimation {
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}



@end
