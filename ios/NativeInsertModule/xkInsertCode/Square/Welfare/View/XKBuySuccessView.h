//
//  XKBuySuccessView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKBuySuccessView : UIView
@property (nonatomic, strong) void(^orderBlock)(UIButton *sender);
@property (nonatomic, strong) void(^keepBlock)(UIButton *sender);
@property (nonatomic, strong) void(^gorundBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
