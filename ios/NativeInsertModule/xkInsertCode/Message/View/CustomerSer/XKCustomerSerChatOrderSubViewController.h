//
//  XKCustomerSerChatOrderSubViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XKCustomerSerChatOrderSubVCType) {
    XKCustomerSerChatOrderSubVCTypeWelfare  = 1 << 0, // 福利订单
    XKCustomerSerChatOrderSubVCTypePlatform = 1 << 1, // 自营订单
};

NS_ASSUME_NONNULL_BEGIN

@interface XKCustomerSerChatOrderSubViewController : UIViewController

@property (nonatomic, assign) XKCustomerSerChatOrderSubVCType type;

@property (nonatomic, strong) NSMutableArray *selectedArray;

- (void)removeSelectedArray;

@end

NS_ASSUME_NONNULL_END
