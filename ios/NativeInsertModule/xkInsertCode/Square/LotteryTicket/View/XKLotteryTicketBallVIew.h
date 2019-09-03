//
//  XKLotteryTicketBallVIew.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketBallVIew : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIColor *ballColor;

@property (nonatomic, strong) UIFont *ballFont;

@property (nonatomic, assign) BOOL ballSelected;

@end

NS_ASSUME_NONNULL_END
