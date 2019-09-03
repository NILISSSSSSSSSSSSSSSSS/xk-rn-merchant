//
//  XKTimeDurationPickerViewController.h
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/26.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKTimeDurationPickerViewController;

@protocol XKTimeDurationPickerViewControllerDelegate <NSObject>

- (void)viewController:(XKTimeDurationPickerViewController *)viewController selectedTimeArr:(NSArray *)selectedTimeArr;

@end

@interface XKTimeDurationPickerViewController : UIViewController

@property (nonatomic, weak) id<XKTimeDurationPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedTimeArr;

@end

NS_ASSUME_NONNULL_END
