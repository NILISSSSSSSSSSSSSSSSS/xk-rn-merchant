//
//  XKWelfarePhotoContainerView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKWelfareOrderDetailViewModel.h"
@interface XKWelfarePhotoContainerView : UIView
@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (nonatomic, copy) void (^didClickloadImgBlock)(void);
@property (strong,nonatomic)UIViewController  * vc;
@property (assign) CGFloat  fixedHeight;
@property (assign) CGFloat  fixedWidth;
@end
