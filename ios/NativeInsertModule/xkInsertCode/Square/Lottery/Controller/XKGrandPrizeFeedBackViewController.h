//
//  XKGrandPrizeFeedBackViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, XKGrandPrizeFeedBackVCType) {
    XKGrandPrizeFeedBackVCTypeFeedBack = 1 << 0,
    XKGrandPrizeFeedBackVCTypeShowOrder = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKGrandPrizeFeedBackViewController : BaseViewController

@property (nonatomic, assign) XKGrandPrizeFeedBackVCType vcType;

@end

NS_ASSUME_NONNULL_END
