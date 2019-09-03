//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item,UIImage *firstImg);

@interface HVideoViewController : UIViewController

+ (instancetype) createController;

@property (copy, nonatomic) void(^cancel)(void);

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
/**拍摄时间小于内部TimeMax 就只能拍照*/
@property (assign, nonatomic) float HSeconds;

// 下面两个互斥
// default NO
@property (assign, nonatomic) BOOL onlyTakePhoto;
// default NO
@property (assign, nonatomic) BOOL onlyTakeVideo;
@end
