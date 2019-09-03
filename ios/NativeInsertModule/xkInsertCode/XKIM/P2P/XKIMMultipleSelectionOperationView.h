//
//  XKIMMultipleSelectionOperationView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMultipleSelectionOperationView : UIView

@property (nonatomic, copy) void(^deleteBtnBlock)(void);

- (void)setOperationsEnabled:(BOOL) enabled;

@end

NS_ASSUME_NONNULL_END
