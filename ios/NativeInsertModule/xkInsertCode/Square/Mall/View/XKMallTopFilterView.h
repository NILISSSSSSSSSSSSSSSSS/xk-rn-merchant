//
//  XKMallTopFilterView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallTopFilterView : UIView
@property (nonatomic, copy)void(^hotBClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^sellBClickBlock)(UIButton *sender);
@property (nonatomic, copy)void(^priceBClickBlock)(UIButton *sender);
@end
