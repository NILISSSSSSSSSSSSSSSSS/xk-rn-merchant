//
//  XKGuidanceManager.m
//  XKSquare
//
//  Created by Lin Li on 2019/1/19.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

static  NSString  * const kGuidanceViewdictXKCloseFriendPersonalInformationViewControllerKey = @"XKCloseFriendPersonalInformationViewController";
static  NSString  * const kGuidanceViewdictXKSecretChatSettingViewControllerKey = @"XKSecretChatSettingViewController";
static  NSString  * const kGuidanceViewdictXKSecretChatViewControllerKey = @"XKSecretChatViewController";
static  NSString  * const kGuidanceViewdictXKSecretTipEditControllerKey = @"XKSecretTipEditController";
static  NSString  * const kGuidanceViewdictXKSecretTipSettingControllerKey = @"XKSecretTipSettingController";
static  NSString  * const kGuidanceViewdictXKSecretFriendRootViewControllerKey = @"XKSecretFriendRootViewController";
static  NSString  * const kGuidanceViewdictXKSecretFriendRootViewControllerKey2 = @"XKSecretFriendRootViewController2";
static  NSString  * const kGuidanceViewdictXKPrivacySettingViewControllerKey = @"XKPrivacySettingViewController";
static  NSString  * const kGuidanceViewdictXKPrivacyCreateSecretFriendCircleViewControllerKey = @"XKPrivacyCreateSecretFriendCircleViewController";
static  NSString  * const kGuidanceViewdictXKMallBuyCarCountViewControllerKey = @"XKMallBuyCarCountViewController";
static  NSString  * const kGuidanceViewdictXKSubscriptionViewControllerKey = @"XKSubscriptionViewController";



@implementation XKGuidanceManager
/**
 控制是否显示GuidanceView
 */
+ (void)configShowGuidanceViewType:(XKGuidanceManagerType)type TransparentRectArr:(NSArray * )transparentRectArr{
    switch (type) {
        case XKGuidanceManagerXKCloseFriendPersonalInformationViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKCloseFriendPersonalInformationViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretChatSettingViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretChatSettingViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretChatViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretChatViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretTipEditController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretTipEditControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretTipSettingController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretTipSettingControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretFriendRootViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretFriendRootViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSecretFriendRootViewController2:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSecretFriendRootViewControllerKey2 AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKPrivacySettingViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKPrivacySettingViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKPrivacyCreateSecretFriendCircleViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKPrivacyCreateSecretFriendCircleViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKMallBuyCarCountViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKMallBuyCarCountViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        case XKGuidanceManagerXKSubscriptionViewController:{
            [XKGuidanceManager configGuidanceVcKey:kGuidanceViewdictXKSubscriptionViewControllerKey AndType:type TransparentRectArr:transparentRectArr];
            break;
        }
        default:
            break;
    }
   
}


/**
 判断是否第一次进入，如果第一次进入需要显示引导视图

 @param key 本地化的字典key，存储的是可变字典，新增的key值
 @param type 当前的控制器
 @param transparentRectArr 镂空的path数组
 */
+ (void)configGuidanceVcKey:(NSString *)key AndType:(XKGuidanceManagerType)type TransparentRectArr:(NSArray * )transparentRectArr{
    if (![XKGlobleCommonTool backShowGuidanceViewFromDictKey:key]) {
        [XKGuidanceManager configGuidanceViewType:type TransparentRectArr:transparentRectArr];
        NSMutableDictionary *oldDict = [XKGlobleCommonTool getGuidanceViewValue];
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        [newDict addEntriesFromDictionary:oldDict];
        newDict[key] = @(1);
        [XKGlobleCommonTool saveGuidanceViewValue:newDict];
    }
}
/**
 新手引导页
 */
+ (void)configGuidanceViewType:(XKGuidanceManagerType)type TransparentRectArr:(NSArray * )transparentRectArr{
    NSArray * imageArr;
    NSArray * imgFrameArr;
    NSArray * orderArr;

    switch (type) {
        case XKGuidanceManagerXKCloseFriendPersonalInformationViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_wzxs";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(32 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 311 * ScreenScale, 239 * ScreenScale)];
           imageArr = @[imageName];
           imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKSecretChatSettingViewController:{
            CGRect transparentRect1 = [transparentRectArr.firstObject CGRectValue];
            CGRect transparentRect2 = [transparentRectArr[1] CGRectValue];

            NSString *imageName = @"xk_label_XKGuidanceView_myq_yhjf_1";
            NSString *imageName2 = @"xk_label_XKGuidanceView_myq_yhjf_3";
            
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(32 * ScreenScale, transparentRect1.origin.y + transparentRect1.size.height + 10, 311 * ScreenScale, 239 * ScreenScale)];
            
            NSValue *imageFrameValue2 = [NSValue valueWithCGRect:CGRectMake(32 * ScreenScale, transparentRect2.origin.y + transparentRect2.size.height + 10, 311 * ScreenScale, 239 * ScreenScale)];

            imageArr = @[imageName,imageName2];
            imgFrameArr = @[imageFrameValue,imageFrameValue2];
            orderArr = @[@"1",@"1"];
            break;
        }
        case XKGuidanceManagerXKSecretChatViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_yhjf_5";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(58 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 266 * ScreenScale, 228 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKSecretTipEditController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_txxx_1";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(39 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 304 * ScreenScale, 292 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKSecretTipSettingController:{
            CGRect transparentRect1 = [transparentRectArr.firstObject CGRectValue];            
            NSString *imageName = @"xk_label_XKGuidanceView_myq_xzts_1";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(32 * ScreenScale, transparentRect1.origin.y + transparentRect1.size.height + 10, 284 * ScreenScale, 299 * ScreenScale)];
            imageArr = @[imageName,imageName];
            imgFrameArr = @[imageFrameValue,imageFrameValue];
            orderArr = @[@"2"];
            break;
        }
        case XKGuidanceManagerXKSecretFriendRootViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_gdtk_1";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(26 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 324 * ScreenScale, 276 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKSecretFriendRootViewController2:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_3";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(75 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 249 * ScreenScale, 228 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKPrivacySettingViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_yssz_1";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(32 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 311 * ScreenScale, 239 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKPrivacyCreateSecretFriendCircleViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_myq_1";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(27 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 321 * ScreenScale, 262 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        case XKGuidanceManagerXKMallBuyCarCountViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            CGRect transparentRect2 = [transparentRectArr[1] CGRectValue];

            NSString *imageName = @"xk_label_XKGuidanceView_myq_gwjs2";
            NSString *imageName2 = @"xk_label_XKGuidanceView_myq_gwjs";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(27 * ScreenScale, transparentRect.origin.y - 315 * ScreenScale - 10, 321 * ScreenScale, 315 * ScreenScale)];
            
            NSValue *imageFrameValue2 = [NSValue valueWithCGRect:CGRectMake(27 * ScreenScale, transparentRect2.origin.y - 315 * ScreenScale - 10, 321 * ScreenScale, 315 * ScreenScale)];

            imageArr = @[imageName,imageName2];
            imgFrameArr = @[imageFrameValue,imageFrameValue2];
            orderArr = @[@"1",@"1"];
            break;
        }
        case XKGuidanceManagerXKSubscriptionViewController:{
            CGRect transparentRect = [transparentRectArr.firstObject CGRectValue];
            NSString *imageName = @"xk_label_XKGuidanceView_dyxq";
            NSValue *imageFrameValue = [NSValue valueWithCGRect:CGRectMake(66 * ScreenScale, transparentRect.origin.y + transparentRect.size.height + 10, 258 * ScreenScale, 229 * ScreenScale)];
            imageArr = @[imageName];
            imgFrameArr = @[imageFrameValue];
            orderArr = @[@"1"];
            break;
        }
        default:
            break;
    }
    XKGuidanceView *guidanceView = [XKGuidanceView new];
    [guidanceView addImages:imageArr imageFrame:imgFrameArr TransparentRect:transparentRectArr orderArr:orderArr];
    [guidanceView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
    
}


@end
