//
//  XKLaunchAdvertisementViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishBlock)(void);

@interface XKLaunchAdvertisementViewController : UIViewController

@property (nonatomic, copy) FinishBlock finishBlock;

- (void)startCountDownWithImg:(UIImage *) img tapBlock:(void(^ __nullable)(void)) tapBlock;

- (void)startCountDownWithImgUrl:(NSString *) imgUrl tapBlock:(void(^ __nullable)(void)) tapBlock;

- (void)startCountDownWithVideoUrl:(NSString *) videoUrl tapBlock:(void(^ __nullable)(void)) tapBlock;

@end

NS_ASSUME_NONNULL_END
