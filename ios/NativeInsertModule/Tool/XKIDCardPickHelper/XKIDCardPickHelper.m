//
//  XKPhotoPickHelperView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIDCardPickHelper.h"
#import "XKAlertView.h"
#import <TZImagePickerController.h>
#import "XKBottomAlertSheetView.h"
#import <AVFoundation/AVFoundation.h>
#import "IDCardCameraController.h"
@interface XKIDCardPickHelper () <IDCardCameraControllerDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)XKBottomAlertSheetView *bottomView;
@end

@implementation XKIDCardPickHelper

- (instancetype)init {
    self = [super init];
    if(self) {
        self.dataSourceArr = [NSMutableArray arrayWithArray:@[@"拍照上传",@"我的相册",@"取消"]];
        self.bottomView = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:self.dataSourceArr firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            if([choseTitle isEqualToString:@"拍照上传"]) {
                if (![XKIDCardPickHelper isCameraAvailable]) {
                    return ;
                }
                [self imageFromCamera];
            } else if([choseTitle isEqualToString:@"我的相册"]) {
                [self imageFromLibiary];
            }
        }];

    }
    return self;
}

- (void)showView {
    [self.bottomView show];
}

#pragma mark - 判断是否有相机功能
+ (BOOL)isCameraAvailable {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [XKAlertView showCommonAlertViewWithTitle:@"您当前的设备没有摄像头，不能使用相机拍摄。"];
        return NO;
    }
    return YES;
}

#pragma mark - 拍摄
- (void)imageFromCamera {
    IDCardCameraController *vc = [[IDCardCameraController alloc] init];
    vc.captureType = CaptureTypeCard;
    vc.delegate = self;
    [self.getCurrentUIVC presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 代理
- (void)captureWithImage:(UIImage *)image {
    if(self.choseImageBlcok) {
        self.choseImageBlcok(image);
    }
}


#pragma mark ---上传照片
- (void)imageFromLibiary
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowPickingVideo = NO;
    imagePicker.isSelectOriginalPhoto = YES;
    XKWeakSelf(ws);
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
         if(self.choseImageBlcok) {
             self.choseImageBlcok(photos.firstObject);
         }
     }];
    [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}


@end
