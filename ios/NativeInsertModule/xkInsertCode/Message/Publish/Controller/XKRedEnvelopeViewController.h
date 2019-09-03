//
//  XKRedEnvelopeViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, XKRedEnvelopeVCType) {
    XKRedEnvelopeVCTypeOpened = 1 << 0,
    XKRedEnvelopeVCTypeGetDone = 1 << 1,
    XKRedEnvelopeVCTypeDetail = 1 << 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKRedEnvelopeViewController : BaseViewController
// 类型
@property (nonatomic, assign) XKRedEnvelopeVCType type;
// 我领取到的
@property (nonatomic, strong) NSMutableArray *mineArray;
// 所有人领取到的
@property (nonatomic, strong) NSMutableArray *allArray;

@end

NS_ASSUME_NONNULL_END
