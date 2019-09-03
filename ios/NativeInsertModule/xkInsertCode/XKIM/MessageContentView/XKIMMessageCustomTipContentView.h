//
//  XKIMMessageCustomTipContentView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageCustomTipContentView : NIMSessionMessageContentView

@property (nonatomic, strong) UIView *tipLabView;

@property (nonatomic, strong) YYLabel *tipLab;

@end

NS_ASSUME_NONNULL_END
