//
//  XKBannerJumpAPPInnerModel.h
//  XKSquare
//
//  Created by hupan on 2018/12/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKBannerJumpAPPInnerModel : NSObject

@property (nonatomic , copy  ) NSString              * type;
@property (nonatomic , copy  ) NSString              * modular;
@property (nonatomic , copy  ) NSString              * oldId;
@property (nonatomic , strong) NSArray <NSString *>* oldType;
@property (nonatomic , copy  ) NSString              * ID;

@end
