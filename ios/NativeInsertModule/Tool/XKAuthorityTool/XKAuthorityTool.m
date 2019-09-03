//
//  AuthorityTool.m
//  权限判断
//
//  Created by Jamesholy on 2017/7/24.
//  Copyright © 2017年 Jamesholy. All rights reserved.
//

#import "XKAuthorityTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <UserNotifications/UserNotifications.h>
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import "XKAlertUtil.h"
#import <UserNotifications/UserNotifications.h>

#define kEXECUTE_BLOCK(A,...) if(A){A(__VA_ARGS__);}
#ifndef AccessImage
#define AccessImage(x) ([UIImage imageNamed:[NSString stringWithFormat:@"AccessAlert.bundle/%@",(x)]])
#endif

static NSString *const privacyCalendarTip = @"没有开启日历权限，是否去开启?";

@interface XKAuthorityTool()
/** 提示标题 */
@property(nonatomic, strong) UILabel *alertTitleLabel;
/** 提示标题 */
@property(nonatomic, copy) NSString *alertTitle;
/** 上面的图片 */
@property(nonatomic, strong) UIImageView *topImageView;
/** 白色背景 */
@property(nonatomic, strong) UIView *whiteView;
/** 去开通按钮 */
@property(nonatomic, strong)  UIButton *sureButton;

@end

@implementation XKAuthorityTool

#pragma mark -  单纯的判断是否开启了权限
+ (void)judgeAuthorityType:(PrivacyAuthorityType)type has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    [self judgeAuthorityType:type needGuide:NO has:has hasnt:hasnt];
}

#pragma mark - 判断是否有相机功能
+ (BOOL)isCameraAvailable {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [XKAlertUtil presentAlertViewWithTitle:nil message:@"没有相机功能" confirmTitle:@"确定" handler:nil];
        return NO;
    }
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    return YES;
}

#pragma mark - 判断权限 是否进行引导打开
+ (void)judgeAuthorityType:(PrivacyAuthorityType)type needGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    switch (type) {
        case PrivacyAuthorityTypeCamera: // 相机
            [self judgeCameraAuthorityNeedGuide:needGuide has:has hasnt:hasnt];
            break;
        case PrivacyAuthorityTypeAlbum: // 相册
            [self judgeAlbumAuthorityNeedGuide:needGuide has:has hasnt:hasnt];
            break;
        case PrivacyAuthorityTypeMicroPhone: // 麦克风
            [self judgeMicroPhoneAuthorityNeedGuide:needGuide has:has hasnt:hasnt];
            break;
        case PrivacyAuthorityTypeAddressBook: // 通讯录
            [self judgeAdressBookAuthorityNeedGuide:needGuide has:has hasnt:hasnt];
            break;
        case PrivacyAuthorityTypeRemotePush: // 远程推送
            [self judgeRemotePushAuthorityNeedGuide:needGuide has:has hasnt:hasnt];
            break;
        case PrivacyAuthorityTypeLocation: // 定位
            [self judgeLocationAuthorityNeedGuide:needGuide has:has hasnt:hasnt  authorityType:PrivacyAuthorityTypeLocation];
            break;
        case PrivacyAuthorityTypeLocationAlways: // 一直定位
            [self judgeLocationAlwaysAuthorityNeedGuide:needGuide has:has hasnt:hasnt authorityType:PrivacyAuthorityTypeLocationAlways];
            break;
        default:
            break;
    }
}

#pragma mark - 判断相机权限
+ (void)judgeCameraAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    //    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
    //        if (needGuide) {
    //            [self showAlertText:privacyCameraTip];
    //        }
    //        kEXECUTE_BLOCK(hasnt);
    //        return;
    //    }
    //    kEXECUTE_BLOCK(has);
    if (![[self class] isCameraAvailable]) {
        return;
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                kEXECUTE_BLOCK(has);
            } else {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeCamera];
                }
                kEXECUTE_BLOCK(hasnt)
            }
        });
    }];
}

#pragma mark - 判断相册权限
+ (void)judgeAlbumAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                kEXECUTE_BLOCK(has);
            } else {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeAlbum];
                }
                kEXECUTE_BLOCK(hasnt);
            }
        }];
    });
}

#pragma mark - 麦克风权限
+(void)judgeMicroPhoneAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    //    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]; // 相机是AVMediaTypeVideo。。。
    //    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
    //        if (needGuide) {
    //            [self showAlertText:privacyCameraTip];
    //        }
    //        kEXECUTE_BLOCK(hasnt);
    //        return;
    //    }
    //    kEXECUTE_BLOCK(has);
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                kEXECUTE_BLOCK(has);
            } else {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeMicroPhone];
                }
                kEXECUTE_BLOCK(hasnt)
            }
        });
    }];
}

#pragma mark - 通讯录权限
+ (void)judgeAdressBookAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeAddressBook];
                }
                kEXECUTE_BLOCK(hasnt);
                return;
            } else if (status == CNAuthorizationStatusNotDetermined) {
                CNContactStore *store = [CNContactStore new];
                [store requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        kEXECUTE_BLOCK(has);
                    } else {
                        if (needGuide) {
                            [self showAlertWithType:PrivacyAuthorityTypeAddressBook];
                        }
                        kEXECUTE_BLOCK(hasnt)
                    }
                }];
                return;
            }
            kEXECUTE_BLOCK(has);
        } else {
            ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
            if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeAddressBook];
                }
                kEXECUTE_BLOCK(hasnt);
                return;
            } else if (status == kABAuthorizationStatusNotDetermined) {
                ABAddressBookRef bookRef = ABAddressBookCreate();
                ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
                    if (granted) {
                        kEXECUTE_BLOCK(has);
                    } else {
                        if (needGuide) {
                            [self showAlertWithType:PrivacyAuthorityTypeCamera];
                        }
                        kEXECUTE_BLOCK(hasnt);
                    }
                });
                return;
            }
            kEXECUTE_BLOCK(has);
        }
    });
}

#pragma mark - 推送远程推送权限
+ (void)judgeRemotePushAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                    if (needGuide) {
                        [self showAlertWithType:PrivacyAuthorityTypeRemotePush];
                    }
                    kEXECUTE_BLOCK(hasnt);
                    return;
                }
                kEXECUTE_BLOCK(has);
            }];
        } else {
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIRemoteNotificationTypeNone) {
                if (needGuide) {
                    [self showAlertWithType:PrivacyAuthorityTypeRemotePush];
                }
                kEXECUTE_BLOCK(hasnt);
                return;
            };
            kEXECUTE_BLOCK(has);
        }
    });
}

#pragma mark - 定位权限
+ (void)judgeLocationAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt authorityType:(PrivacyAuthorityType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            if (needGuide) {
                [self showAlertWithType:type];
            }
            kEXECUTE_BLOCK(hasnt);
            return;
        }
        kEXECUTE_BLOCK(has);
    });
}

#pragma mark - 定位权限 一直
+ (void)judgeLocationAlwaysAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt  authorityType:(PrivacyAuthorityType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted ) { // 没有定位权限
            if (needGuide) {
                [self showAlertWithType:PrivacyAuthorityTypeLocationAlways];
            }
            kEXECUTE_BLOCK(hasnt);
            return;
        }
        if (status != kCLAuthorizationStatusAuthorizedAlways) { // 没有开启一直定位
            if (needGuide) {
                [self showAlertWithType:PrivacyAuthorityTypeLocationAlways];
            }
            kEXECUTE_BLOCK(hasnt);
            return;
        }
        kEXECUTE_BLOCK(has);
    });
}

+ (void)showAlertText:(NSString *)text {
    [XKAlertUtil presentAlertViewWithTitle:@"温馨提示" message:text cancelTitle:@"取消" defaultTitle:@"确定" distinct:NO cancel:^{
        // nothing
    } confirm:^{
        [self openURL:UIApplicationOpenSettingsURLString];
    }];
}


#pragma mark - 日历权限
+ (void)judgeCalendarAuthorityNeedGuide:(BOOL)needGuide has:(void (^)(void))has hasnt:(void (^)(void))hasnt {
    dispatch_async(dispatch_get_main_queue(), ^{
        EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        if (EKstatus == EKAuthorizationStatusDenied || EKstatus == EKAuthorizationStatusRestricted) {
            if (needGuide) {
                [self showAlertText:privacyCalendarTip];
            }
            kEXECUTE_BLOCK(hasnt);
            return;
        }
        kEXECUTE_BLOCK(has);
    });
}

+ (void)judegeCanRecord:(void (^)(void))canRecord {
    
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeMicroPhone needGuide:YES has:^{
        [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeCamera needGuide:YES has:^{
            kEXECUTE_BLOCK(canRecord);
        } hasnt:^{
        }];
    } hasnt:^{
    }];
}


+ (void)showAlertWithType:(PrivacyAuthorityType)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:[self dicData][@(type)]];
    });
}

+ (void)openURL:(NSString *)urlStr {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{}completionHandler:^(BOOL  success) {
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
    }
}
//文案数据
+ (NSDictionary *)dicData {
    static NSDictionary *dic = nil;
    if (!dic) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dic = @{
                    @(PrivacyAuthorityTypeRemotePush):@"请开启通知权限",
                    @(PrivacyAuthorityTypeCamera):@"为了使用系统相机拍摄,请开启相机权限",
                    @(PrivacyAuthorityTypeMicroPhone):@"为了使用系统相机拍摄，请开启麦克风权限",
                    @(PrivacyAuthorityTypeLocation):@"请开启定位权限",
                    @(PrivacyAuthorityTypeLocationAlways):@"请开启定位权限",
                    @(PrivacyAuthorityTypeAddressBook):@"请开启通讯录权限",
                    @(PrivacyAuthorityTypeAlbum):@"请开启相册权限",
//                    @(PrivacyAuthorityTypeCalendar):@"请开启日历权限"
                    };
        });
    }
    return dic;
}

/** 确认开通 */
- (void)sureClick {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        
    }
}

@end

