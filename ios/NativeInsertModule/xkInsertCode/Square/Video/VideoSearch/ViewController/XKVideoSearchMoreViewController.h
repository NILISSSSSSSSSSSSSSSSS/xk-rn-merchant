//
//  XKVideoSearchMoreViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchBaseViewController.h"

typedef NS_OPTIONS(NSUInteger, XKVideoSearchDataType) {
    XKVideoSearchDataTypeUser       = 1 << 0,
    XKVideoSearchDataTypeTopic      = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchMoreViewController : XKVideoSearchBaseViewController
// 搜索关键字
@property (nonatomic, copy) NSString *keyword;
// 搜索类型
@property (nonatomic, assign) XKVideoSearchDataType dataType;

@end

NS_ASSUME_NONNULL_END
