//
//  XKWelfareGoodsDetailShareView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKGoodsShareModel.h"
#import "XKWelfareShareModel.h"
@interface XKWelfareGoodsDetailShareView : UIView
@property (nonatomic, copy) void(^closeBlock)(void);
//自营
@property (nonatomic, strong) XKGoodsShareModel  *shareModel;
//福利
@property (nonatomic, strong) XKWelfareShareModel  *welfareShareModel;
@end
