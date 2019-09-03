//
//  XKSquareHomeToolModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XKSquareHomeToolModel : NSObject

@property (nonatomic , copy  ) NSString              * code;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , assign) NSInteger             sort;
@property (nonatomic , assign) NSInteger             moveEnable;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * icon;
@property (nonatomic , assign) NSInteger             weight;
@property (nonatomic , assign) BOOL                  isChose;
@property (nonatomic , assign) BOOL                  iconInLocation;


@end


