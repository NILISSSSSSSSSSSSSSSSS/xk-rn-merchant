//
//  XKWelfareNewMainFunctionCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"

@interface XKWelfareNewMainFunctionCell : XKBaseCollectionViewCell

@property (nonatomic, copy) void(^leftViewBlock)(void);

@property (nonatomic, copy) void(^midViewBlock)(void);

@property (nonatomic, copy) void(^rightViewBlock)(void);

@end
