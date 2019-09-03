//
//  XKIMCustomerState.h
//  XKSquare
//
//  Created by william on 2018/12/17.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMCustomerState : NSObject
@property(nonatomic,nullable,copy)NSString       *shopID;

+(XKIMCustomerState *)sharedManager;

@end

NS_ASSUME_NONNULL_END
