//
//  XKBaseCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKBaseCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView  *bgContainView;

- (void)hiddenSeperateLine:(BOOL)hidden;


/**
 自定义UI
 */
- (void)addCustomSuviews;


/**
 自定义约束
 */
- (void)addUIConstraint;


@end
