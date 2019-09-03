//
//  XKTradingAreaCommentLabelsModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTradingAreaCommentLabelsModel : NSObject

@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy  ) NSString               * code;
@property (nonatomic , copy  ) NSString               * displayName;//商品使用
@property (nonatomic , copy  ) NSString               * name;//店铺使用

@end
