//
//  XKSizerView.h
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SizerViewBlock)(UIButton *sender);

@interface XKSizerView : UIView

@property (nonatomic, copy  ) SizerViewBlock  sizerViewBlock;

- (void)setTitle:(NSString *)title;

@end
