//
//  IDCardViewController.h
//  Erp4iOS
//
//  Created by leocll on 9/11/16.
//  Copyright © 2016年 成都好房通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capture.h"

@protocol IDCardCameraControllerDelegate <NSObject>

@optional

- (void)captureWithImage:(UIImage *)image;

@end

typedef enum {
	CaptureTypeCardNormal		= 0,   //正常照片
    CaptureTypeUser 			= 111,   //用户照片
    CaptureTypeCard 			= 222,   //身份证照片

} CaptureType;

@interface IDCardCameraController : UIViewController<CaptureDelegate>

/** 拍照类型*/
@property (nonatomic, assign) CaptureType captureType;
@property (weak, nonatomic) id<IDCardCameraControllerDelegate> delegate;

@end
