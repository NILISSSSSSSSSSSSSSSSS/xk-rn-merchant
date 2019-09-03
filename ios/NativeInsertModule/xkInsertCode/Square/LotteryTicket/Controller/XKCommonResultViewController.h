//
//  XKCommonResultViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, XKCommonResultVCType) {
    XKCommonResultVCTypeSucceed = 1 << 0,
    XKCommonResultVCTypeFailed = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKCommonResultViewController : BaseViewController

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) XKCommonResultVCType vcType;

@property (nonatomic, copy) NSString *resultStr;

- (void)addBtnWithBtnTitle:(NSString *)btnTitle btnColor:(UIColor *)btnColor btnBlock:(nullable void (^)(UIViewController *resultVC))btnBlock;

@end

NS_ASSUME_NONNULL_END
