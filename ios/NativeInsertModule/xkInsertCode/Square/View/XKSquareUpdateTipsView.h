//
//  XKSquareUpdateTipsView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/2.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSquareUpdateTipsView : UIView

@property (nonatomic, copy) NSString *versionStr;

@property (nonatomic, copy) NSString *updateContent;

@property (nonatomic, copy) NSString *remarkContent;

@property (nonatomic, copy) NSString *updateBtnTitle;

@property (nonatomic, copy) void(^closeBtnBlock)(void);

@property (nonatomic, copy) void(^updateBtnBlock)(void);

- (void)setCloseBtnHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
