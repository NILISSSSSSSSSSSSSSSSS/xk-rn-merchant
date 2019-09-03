//
//  XKConsumeCouponDateMainView.h
//  XKSquare
//
//  Created by william on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)(NSString *month);//time1 按月的日期 time2按日的开始日期 time3按日的结束日期 way(0 按月  1按日)

@interface XKConsumeCouponDateMainView : UIView

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, copy  ) backBlock    backBlock;


@end
