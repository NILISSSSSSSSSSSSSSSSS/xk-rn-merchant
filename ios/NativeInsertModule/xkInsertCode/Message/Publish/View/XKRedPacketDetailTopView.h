//
//  XKRedPacketDetailTopView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKRedPacketDetailTopView : UIView
@property (nonatomic, copy) void (^detailBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
