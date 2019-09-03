//
//  XKGoodsCategoryViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, CategoryType) {
    CategoryTypeHome,
    CategoryTypeMall,
    CategoryTypeWelfare,
    CategoryTypeArea
};

@interface XKMallGoodsCategoryViewController : BaseViewController

@property (nonatomic, assign) CategoryType       type;
@property (nonatomic, copy  ) void(^refreshBlock)(void);

@end
