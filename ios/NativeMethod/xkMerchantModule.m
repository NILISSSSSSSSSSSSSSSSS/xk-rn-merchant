//
//  TestModul.m
//  xkMerchant
//
//  Created by qiushaoyu on 2018/8/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "xkMerchantModule.h"
#import "TZImagePickerController.h"
#import <QiniuSDK.h>
#import "MBProgressHUD.h"
#import "QNFileUploader.h"
#import <MJExtension.h>
#import "XKDeviceInfoManager.h"
#import "LocationManager.h"
#import "XKAuthorityTool.h"
#import "PGGCodeScanning.h"
#import "XKShareManager.h"
#import "XKRegisterModel.h"
#import "NatvieJump.h"
#import "XKLoginConfig.h"
#import "XKCityDBManager.h"
#import "IAPCenter+XK.h"
#import <ContactsUI/ContactsUI.h>
#import "HVideoViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKContactListController.h"
#import "XKCustomerSerRootViewController.h"
#import "AppDelegate.h"
#import "XKMerchantModuleHelper.h"
#import "XKPersonDetailInfoViewController.h"
#define KEY_WINDOW   [UIApplication sharedApplication].keyWindow

@interface xkMerchantModule()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CNContactPickerDelegate>

/**<##>*/
@property(nonatomic, copy) RCTPromiseResolveBlock resolve;
@property(nonatomic, copy) RCTPromiseRejectBlock reject;
@property(nonatomic, copy) NSString *token;


@end

@implementation xkMerchantModule


-(void)dealloc {
  
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}


// 分享
RCT_EXPORT_METHOD(share:(NSString *)type  url:(NSString *)url  title:(NSString *)title info:(NSString *)info iconUrl:(NSString *)iconUrl resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    JSHAREPlatform platForm;
    if ([type isEqualToString:@"QQ"]) {
      platForm = JSHAREPlatformQQ;
    } else if ([type isEqualToString:@"QQ_Z"]) {
      platForm = JSHAREPlatformQzone;
    } else if ([type isEqualToString:@"WX"]) {
      platForm = JSHAREPlatformWechatSession;
    } else if ([type isEqualToString:@"WX_P"]) {
      platForm = JSHAREPlatformWechatTimeLine ;
    }  else if ([type isEqualToString:@"WB"]) {
      platForm = JSHAREPlatformSinaWeibo;
    } else {
      reject(@"fail",@"不支持的平台",nil);
      return;
    }
    [[XKShareManager shared] shareLinkUrl:url LinkText:info LinkTitle:title LinkImageURL:iconUrl WithPlatform:platForm complete:^(NSString *err) {
      if (err.length != 0) {
        reject(@"fail",err,nil);
      } else {
        resolve(@"分享成功");
      }
    }];
  });
}

RCT_EXPORT_METHOD(shareToKYFriend:(NSString *)paraStr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  if (paraStr) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      NSData *jsonData = [paraStr dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
      XKContactListController *vc = [[XKContactListController alloc]init];
      vc.useType = XKContactUseTypeSingleSelect;
      vc.rightButtonText = @"发送";
      vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        [[self getCurrentRootVC] dismissViewControllerAnimated:YES completion:nil];
        if (contacts.count) {
          if ([dict[@"type"] integerValue] == 0) {
            // 商品
            XKIMMessageShareGoodsAttachment *attachment = [[XKIMMessageShareGoodsAttachment alloc] init];
            attachment.commodityType = 1;
            attachment.commodityId = dict[@"goodsId"];
            attachment.commodityIconUrl = dict[@"iconUrl"];
            attachment.commodityName = dict[@"name"];
            attachment.commoditySpecification = dict[@"description"];
            attachment.commodityPrice = [dict[@"price"] floatValue];
            attachment.messageSourceName = @"";
            for (XKContactModel *contac in contacts) {
              NIMSession *sesson = [NIMSession session:contac.userId type:NIMSessionTypeP2P];
              [XKIMGlobalMethod sendCollectItem:attachment session:sesson];
            }
            resolve(@"分享成功");
          } else if ([dict[@"type"] integerValue] == 1) {
            // 福利
            XKIMMessageShareWelfareAttachment *attachment = [[XKIMMessageShareWelfareAttachment alloc] init];
            attachment.welfareId = dict[@"sequenceId"];
            attachment.sequenceId = dict[@"sequenceId"];
            attachment.goodsId = dict[@"goodsId"];
            attachment.welfareIconUrl = dict[@"iconUrl"];
            attachment.welfareName = dict[@"name"];
            attachment.welfareDescription = dict[@"description"];
            attachment.welfarePrice = [dict[@"price"] floatValue];
            attachment.messageSourceName = @"";
            for (XKContactModel *contac in contacts) {
              NIMSession *sesson = [NIMSession session:contac.userId type:NIMSessionTypeP2P];
              [XKIMGlobalMethod sendCollectItem:attachment session:sesson];
            }
          }
        } else {
          reject(@"fail", @"分享失败", nil);
        }
      };
      [[self getCurrentRootVC] presentViewController:vc animated:YES completion:nil];
    });
  }
}

RCT_EXPORT_METHOD(customerServiceContactUser:(NSString *)userId shopId:(NSString *)shopId) {
  dispatch_sync(dispatch_get_main_queue(), ^{
    [XKHudView showLoadingTo:KEY_WINDOW animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"customerId"] = userId;
    para[@"shopId"] = shopId;
    [HTTPClient postEncryptRequestWithURLString:@"im/ma/mCustomerServiceContactUser/1.0" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
      [XKHudView hideHUDForView:KEY_WINDOW];
      if (responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (dict[@"tid"] && [dict[@"tid"] length]) {
          
          [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId,] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (!error) {
              NIMSession *session = [NIMSession session:dict[@"tid"] type:NIMSessionTypeTeam];
              XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeCustomerServiceContactUser];
              vc.title = users.firstObject.userInfo.nickName;
              [(UINavigationController *)[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else {
              NIMSession *session = [NIMSession session:dict[@"tid"] type:NIMSessionTypeTeam];
              XKCustomerSerRootViewController *vc = [[XKCustomerSerRootViewController alloc] initWithSession:session vcType:XKCustomerSerRootVCTypeCustomerServiceContactUser];
              vc.title = @" "; // 勿删
              [(UINavigationController *)[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            }
          }];
        } else {
          NSLog(@"联系客户失败");
          [XKHudView showErrorMessage:@"联系客户失败"];
        }
      }
    } failure:^(XKHttpErrror *error) {
      [XKHudView hideHUDForView:KEY_WINDOW];
      [XKHudView showErrorMessage:error.message];
    }];
  });
}

// 获取设备唯一编码
RCT_EXPORT_METHOD(
                  getUniqueIdentifier:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *uuid = [[XKDeviceInfoManager sharedManager] getUdidString];
  resolve(uuid);
}

// 获取定位信息
RCT_EXPORT_METHOD(
                  getLocation:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeLocation needGuide:YES has:^{
    [[LocationManager shareInstance] updateLoactionComplete:^(NSString *err, NSDictionary *loactionInfo) {
      if (err) {
        reject(@"定位失败",err,nil);
      } else {
        resolve(loactionInfo);
      }
    }];
  } hasnt:^{
    reject(@"定位失败",@"没有开启权限",nil);
  }];
}

// 扫码
RCT_EXPORT_METHOD(
                  scanQRCode:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeCamera needGuide:YES has:^{
      PGGCodeScanning *vc = [PGGCodeScanning new];
      [vc setResultBlock:^(NSString *result) {
        resolve(result);
      }];
      UINavigationController *nav =  [[UINavigationController alloc] initWithRootViewController:vc];
      [[self getCurrentRootVC] presentViewController:nav animated:YES completion:nil];
    } hasnt:^{
      //
    }];
  });
}

// 登录
RCT_EXPORT_METHOD(loginSuccess:(NSDictionary *)loginParmas autoLogin:(BOOL)autoLogin)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableDictionary *fixParmas = loginParmas.mutableCopy;
    fixParmas[@"nickname"] = loginParmas[@"nickName"];
    XKUserInfo *model = [XKUserInfo yy_modelWithJSON:fixParmas];
    if (autoLogin) {
      [self configUser:[XKUserInfo currentUser] model:model];
      //    [XKLoginConfig autoLoginConfig:YES];
      //
      [XKLoginConfig loginConfig];
    } else {
      [XKUserInfo cleanUser];
      [self configUser:[XKUserInfo new] model:model];
      [XKLoginConfig loginConfig];
    }
    // 内购重试
    [[IAPCenter shareCenter] applePayRetryUploadResultToMyServer];
  });
  
}


- (void)configUser:(XKUserInfo *)userInfo model:(XKUserInfo *)model {
  userInfo.phone = model.phone;
  userInfo.realPhone = model.realPhone; // Wu
  userInfo.userId = model.userId;
  userInfo.uid = model.uid; // Wu
  userInfo.nickname = model.nickname;
  userInfo.token = model.token;
  userInfo.avatar = model.avatar;
  userInfo.userImAccount = model.userImAccount;
  userInfo.securityCode = model.securityCode;
  userInfo.isAdmin = model.isAdmin;
  userInfo.merchant = model.merchant;
  
  // ↓暂无
  userInfo.address = model.address;
  userInfo.age = model.age;
  userInfo.constellation = model.constellation;
  userInfo.birthday = model.birthday;
  userInfo.qrCode = model.qrCode;
  userInfo.signature = model.signature;
  userInfo.sex = model.sex;
  [XKUserInfo saveCurrentUser:userInfo];
  [XKRedPointManager refreshAllTabbarRedPoint];
}

// 更新用户信息
RCT_EXPORT_METHOD(updateUser:(NSDictionary *)userParmas)
{
  XKRegisterModel *model = [XKRegisterModel yy_modelWithJSON:userParmas];
  XKUserInfo *userInfo = [XKUserInfo currentUser];
  userInfo.phone = model.phone;
  userInfo.realPhone = model.realPhone; // Wu
  userInfo.userId = model.ID;
  userInfo.nickname = model.nickname;
  userInfo.avatar = model.avatar;
  [XKUserInfo saveCurrentUser:userInfo];
}

// 获取联盟商群红点
RCT_EXPORT_METHOD(
                  getRedPointStatus:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSMutableDictionary *info = @{}.mutableCopy;
  info[@"union"] = @([XKRedPointManager getMsgTabBarRedPointItem].imItem.unionGroupRedStatus).stringValue;
  info[@"friend"] = @([XKRedPointManager getMsgTabBarRedPointItem].imItem.hasRedPoint || [XKRedPointManager getMsgTabBarRedPointItem].newFriendItem.hasRedPoint).stringValue;
  info[@"xkSer"] = @([XKRedPointManager getMsgTabBarRedPointItem].imItem.xkSerRedStatus).stringValue;
  info[@"shopSer"] = @([XKRedPointManager getMsgTabBarRedPointItem].imItem.shopSerRedStatus).stringValue;
  resolve(info);
}


// 退出
RCT_EXPORT_METHOD(loginOut:(NSDictionary *)loginParmas)
{
  
  [XKLoginConfig loginDropOutConfig];
}

// 跳转个人中心ƒ
RCT_EXPORT_METHOD(jumpPersonalCenter:(NSString *)userId)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (userId.length == 0) {
      [XKHudView showErrorMessage:@"用户信息错误"];
      return;
    }
    
    XKPersonDetailInfoViewController *userVC = [XKPersonDetailInfoViewController new];
    userVC.userId = userId;
    [(UINavigationController *)[self getCurrentUIVC].navigationController pushViewController:userVC animated:YES];
  });

}


// 跳转本地联盟商群
RCT_EXPORT_METHOD(jumpLocalUnionGroup)
{
  [NatvieJump jumpLocalUnionGroup];
}

// 修改店铺
RCT_EXPORT_METHOD(changeShopSuccess:(NSString *)currentShopId)
{
//   dispatch_async(dispatch_get_main_queue(), ^{
     [XKUserInfo currentUser].currentShopId = currentShopId;
//   });
}

// 跳转客服 好像没用
RCT_EXPORT_METHOD(jumpShopService)
{
  [NatvieJump jumpShopService];

}

// 商铺客服
RCT_EXPORT_METHOD(createShopCustomerWithCustomerID:(NSString *)currentShopId)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [XKCustomeSerMessageManager createShopCustomerWithCustomerID:currentShopId];
  });
}

// 平台客服
RCT_EXPORT_METHOD(createXKCustomerSerChat)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [XKCustomeSerMessageManager createXKCustomerSerChat];
  });
}

// 通讯录
RCT_EXPORT_METHOD(openContact:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [KEY_WINDOW endEditing:YES];
    CNContactPickerViewController * contactPickerViewController = [CNContactPickerViewController new];
    contactPickerViewController.delegate = self;
    self.resolve = nil;
    self.reject = nil;
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAddressBook needGuide:YES has:^{
      self.resolve = resolve;
      self.reject = reject;
      
      [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
      [[self getCurrentRootVC] presentViewController:contactPickerViewController animated:YES completion:nil];
      
    } hasnt:^{
      // 未授权
    }];
  });
}

/** 选择联系人回调 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
  
  CNContact *contact = contactProperty.contact;
  NSString *nameString = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
  NSString *phoneNumString;
  NSLog(@"nameString %@",nameString);
  if ([contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * phoneNumberTempString = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    phoneNumString = [[phoneNumberTempString componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (phoneNumString.length == 13 && [[phoneNumString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"86"]) {
      phoneNumString = [phoneNumString substringFromIndex:2];
    }
    NSLog(@"phoneNumString %@",phoneNumString);
    //    self.recipientItem.phone = phoneNumString;
    //    [self.tableView reloadData];
  }
  NSMutableDictionary *dic = @{}.mutableCopy;
  dic[@"name"] = nameString;
  dic[@"phoneNumber"] = phoneNumString;
  if (self.resolve) {
    self.resolve(dic);
  }
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


// 切换到朋友界面
RCT_EXPORT_METHOD(clickFriendScreen)
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RNMessageRootViewShow" object:nil];
  });
}


/**
 // 开关IM消息通知声音
 xkMerchantModule.switchIMMute(flag);  // flag 整数类型 0 开启 1关闭
 // 获取IM消息通知声音状态
 let flag = xkMerchantModule.getIMMute();  // flag 整数类型 0 开启 1关闭
 */
// 切换到朋友界面
RCT_EXPORT_METHOD(getIMMute:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([[XKUserInfo currentUser].isVoice isEqualToString:@"YES"]) {
      resolve(@(1));
    } else {
      resolve(@(0));
    }
  });
}

RCT_EXPORT_METHOD(switchIMMute:(BOOL)mute)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (mute) {
      [XKUserInfo currentUser].isVoice = @"YES";
      [XKUserInfo currentUser].isShake = @"YES";
    } else {
      [XKUserInfo currentUser].isVoice = @"NO";
      [XKUserInfo currentUser].isShake = @"NO";
    }
  });
}



RCT_EXPORT_METHOD(applePay:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [[IAPCenter shareCenter] xk_PayWithProductId:params[@"productId"] orderId:params[@"orderNo"] tradeId:params[@"tradeNo"] validateResult:^(NSInteger status, AppleProductSuccessCacheModel * _Nonnull info) {
      if (status == 0) {
        resolve(@{@"status":@"0",@"msg":@"内购支付成功,服务器验证成功"});
        NSLog(@"内购支付成功,服务器验证成功");
      } else if (status == 1) {
        resolve(@{@"status":@"1",@"msg":@"内购支付成功,服务器验证失败"});
        NSLog(@"内购支付成功,服务器验证失败");
      } else if (status == 2) {
        resolve(@{@"status":@"2",@"msg":@"支付成功,未等待验证结果"});
        NSLog(@"支付成功,未等待验证结果");
      }
    } failWithoutPurchase:^(NSString * _Nonnull err) {
      resolve(@{@"status":@"4",@"msg":[NSString stringWithFormat:@"内购失败：%@",err]});
      NSLog(@"支付失败 -%@",err);
    } failWithPurchase:^(NSString * _Nonnull err) {
      resolve(@{@"status":@"3",@"msg":@"内购支付成功，发送验证结果给服务器失败"});
      NSLog(@"支付成功，上传服务器失败 -%@",err);
    }];
  });
}

RCT_EXPORT_METHOD(popToNative)
{
 dispatch_async(dispatch_get_main_queue(), ^{
   [[self getCurrentUIVC].navigationController popViewControllerAnimated:YES];
   });
}


RCT_EXPORT_METHOD(cleanCache)
{
  [self removeSdImgCache];
  [self removeSandBoxCache];
}

RCT_EXPORT_METHOD(jumpSysSetting)
{
  NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}



- (void)removeSandBoxCache {
  //获取路径
  NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  //返回路径中的文件数组
  NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
  
  for (NSString *p in files) {
    
    NSError *error;
    NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", p]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
      
      BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
      if (isRemove) {
        NSLog(@"清除成功");
      } else {
        NSLog(@"清除失败");
      }
    }
  }
}

// 清除SD图片
- (void)removeSdImgCache {
  [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentRootVC {
  return [UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 * 选择图片和视频
 * type 选择类型 1 图片 2 视频  3 视频或者图片
 * crop 是否需要裁剪 0 不裁剪 1 裁剪
 * total 需要选择的文件数量
 * limit 限制上传的文件大小 0 不限制大小 >0 限制大小（单位KB）
 * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
 **/
//xkMerchantModule.pickImageAndVideo(type, crop = 0, totalNum = 0, limit = 0, duration = 0);
RCT_EXPORT_METHOD(pickImageAndVideo:(NSInteger)type crop:(NSInteger)crop totalNum:(NSInteger)totalNum limit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  if (type == 1) {
    [[XKMerchantModuleHelper shareHelper] uploadPictureWithMaxNum:totalNum crop:crop resolver:resolve rejecter:reject];
  } else if (type == 2) {
    [[XKMerchantModuleHelper shareHelper] uploadVideoWithLimit:limit duration:duration resolver:resolve rejecter:reject];
  } else if (type == 3){
    [[XKMerchantModuleHelper shareHelper] uploadPickImageAndVideoWithCrop:crop totalNum:totalNum limit:limit duration:duration resolver:resolve rejecter:reject];
  } else {
    reject(@"type is wrong",@"check your params",nil);
  }
}

/**
 * 拍照
 * type 选择类型 0:拍照，1:拍视频，2:既能拍照又能拍视频
 * crop 是否需要裁剪 0 不裁剪 1 裁剪 (仅当type为0时参数生效)
 * duration 限制上传视频的长度 0 不限制视频时长 >0 限制视频时长(单位秒)
 **/
//xkMerchantModule.takeImageAndVideo(type, crop = 0, duration = 0);
RCT_EXPORT_METHOD(takeImageAndVideo:(NSInteger)type crop:(NSInteger)crop duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  if (type == 0) {
    if (crop) {
      [[XKMerchantModuleHelper shareHelper] captureWithCropWithResolver:resolve rejecter:reject];
    } else {
      [[XKMerchantModuleHelper shareHelper] captureWithMode:0 duration:duration resolver:resolve  rejecter:reject];
    }
  } else if (type == 1) {
    [[XKMerchantModuleHelper shareHelper] captureWithMode:1 duration:duration resolver:resolve  rejecter:reject];
  } else if (type == 2) {
    [[XKMerchantModuleHelper shareHelper] captureWithMode:2 duration:duration resolver:resolve  rejecter:reject];
  } else {
    reject(@"type is wrong",@"check your params",nil);
  }
}



RCT_EXPORT_MODULE();
@end
