//
//  XKTradingIocnListModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKTradingIocnListModel : NSObject
@property (nonatomic , copy) NSString              *code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              moveEnable;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * icon;

@end

NS_ASSUME_NONNULL_END
