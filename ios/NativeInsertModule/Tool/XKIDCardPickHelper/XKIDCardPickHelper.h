//
//  XKPhotoPickHelper
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XKIDCardPickHelper : NSObject

/** 选中图片回调*/
@property (nonatomic, copy)void(^choseImageBlcok)(UIImage *image);
/**
 判断是否有相机功能
 */
+ (BOOL)isCameraAvailable;


- (void)showView;
@end
