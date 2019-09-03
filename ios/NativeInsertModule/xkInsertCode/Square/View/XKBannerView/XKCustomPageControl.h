//
//  XKCustomPageControl.h
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface XKCustomPageControl : UIPageControl
//指示点之间的间距
@property (nonatomic, assign) NSUInteger margin;

@property (nonatomic, assign) NSUInteger loopViewWith;

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;

@end;
