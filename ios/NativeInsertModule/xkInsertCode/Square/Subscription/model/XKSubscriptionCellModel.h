//
//  XKSubscriptionCellModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKSubscriptionCellModel : NSObject

@property (nonatomic, copy  ) NSString   *itemId;
@property (nonatomic, copy  ) NSString   *titleName;
@property (nonatomic, copy  ) NSString   *selectImgName;
@property (nonatomic, copy  ) NSString   *normalImgName;
@property (nonatomic, assign) BOOL       selected;


@end
