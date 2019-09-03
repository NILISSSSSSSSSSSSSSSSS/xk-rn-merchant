//
//  XKGlobleCommonTool.m
//  XKSquare
//
//  Created by hupan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGlobleCommonTool.h"

#import "BigPhotoPreviewBaseController.h"
#import "XKDeviceDataLibrery.h"
#import "PhotoPreviewModel.h"
#import "XKSquareBannerModel.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKVideoDisplayMediator.h"
#import "XKDeviceInfoManager.h"
#import "XKSquareHomeToolModel.h"
#import "XKBannerJumpAPPInnerModel.h"
#import "XKVideoDisplayMediator.h"

@implementation XKGlobleCommonTool

+ (UIView *)creatXKBannerView:(UIView *)view itemModel:(XKSquareBannerModel *)model itemTarget:(nullable id)target action:(nonnull SEL)sel {

    NSArray * arr = model.templateContent.arr;
    
    for (ItemModel *item in arr) {
        
        NSArray *startPointArr = [item.gridStart componentsSeparatedByString:@","];
        NSArray *endPointArr = [item.gridEnd componentsSeparatedByString:@","];
        if (startPointArr.count == 2 && endPointArr.count == 2) {
            
            CGFloat subImgViewX = [startPointArr[0] floatValue] / model.templateContent.x * view.width;
            CGFloat subImgViewY = [startPointArr[1] floatValue] / model.templateContent.y * view.height;
            
            CGFloat subImgViewW = ([endPointArr[0] floatValue] - [startPointArr[0] floatValue]) / model.templateContent.x * view.width;
            CGFloat subImgViewH = ([endPointArr[1] floatValue] - [startPointArr[1] floatValue]) / model.templateContent.y * view.height;
            
            UIImageView *subImgView = [[UIImageView alloc] init];
            subImgView.clipsToBounds = YES;
            subImgView.userInteractionEnabled = YES;
            subImgView.frame = CGRectMake(subImgViewX , subImgViewY, subImgViewW, subImgViewH);
            subImgView.contentMode = UIViewContentModeScaleAspectFill;
            [subImgView sd_setImageWithURL:kURL(item.src) placeholderImage:IMG_NAME(kDefaultPlaceHolderRectImgName)];
            
            if (target && sel) {
                UIButton *btn = [[UIButton alloc] initWithFrame:subImgView.bounds];
                [btn setTitle:[NSString stringWithFormat:@"%ld+%@", (long)item.type, item.jumpIOS] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
                [subImgView addSubview:btn];
            }
            
            [view addSubview:subImgView];
            
            if (item.txt.length) {
                CGFloat subTipX = 0;
                CGFloat subTipY = 0;
                CGFloat subTipW = 0;
                CGFloat subTipH = 20;
                
                CGSize size = [item.txt boundingRectWithSize:CGSizeMake(MAXFLOAT, subTipH) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]} context:nil].size;
                if (size.width >= subImgViewH) {
                    subTipW = subImgViewH;
                } else {
                    subTipW = size.width + 15;
                }
                UIRectCorner type = UIRectCornerBottomRight;
                if (item.position.integerValue == 1) {
                    subTipX = 0;
                    subTipY = 0;
                    type = UIRectCornerBottomRight;
                    
                } else if (item.position.integerValue == 2) {
                    subTipX = subImgViewW - subTipW;
                    subTipY = 0;
                    type = UIRectCornerBottomLeft;
                    
                } else if (item.position.integerValue == 3) {
                    subTipX = subImgViewW - subTipW;
                    subTipY = subImgViewH - subTipH;
                    type = UIRectCornerTopLeft;
                    
                } else if (item.position.integerValue == 4) {
                    subTipX = 0;
                    subTipY = subImgViewH - subTipH;
                    type = UIRectCornerTopRight;
                    
                }
                
                UIButton *subTip = [[UIButton alloc] initWithFrame:CGRectMake(subTipX, subTipY, subTipW, subTipH)];
                [subTip cutCornerWithRoundedRect:subTip.bounds byRoundingCorners:type cornerRadii:CGSizeMake(5, 5)];
                
                subTip.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                subTip.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
                subTip.backgroundColor = HEX_RGBA(0x4A90FA, 0.6);
                [subTip setTitle:item.txt forState:UIControlStateNormal];
                [subTip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [subImgView addSubview:subTip];
            }
        }
    }
    return view;
}


//bannerView进行app内部跳转
+ (void)bannerViewJumpAppInner:(NSString *)modelString currentViewController:(BaseViewController *)currentViewController {
    /*
     type:跳转类型
            detail 详情页，list 列表页，jump 打开新的App，coupon 领券中心
     modular: 模块
             detail:【video 小视频，welfGoods 福利商城商品详情，selfGoods自营商城商品详情，shops 店铺详情，shopGoods店铺商品详情】
             list:【selfClass 自营商品某分类商品列表，welfClass 福利商城某分类商品列表， selfRe 自营商城推荐商品列表，welfRe 福利商城推荐商品列表，outlets直营店】
             jump:【live 打开直播APP】
             coupon: 跳转领券中心
     */
    XKBannerJumpAPPInnerModel *model = [XKBannerJumpAPPInnerModel yy_modelWithJSON:modelString];
    NSString *classNameStr;
    NSDictionary *params;
    if ([model.type isEqualToString:@"detail"]) {// 详情页
        if ([model.modular isEqualToString:@"video"]) {//小视频
            [XKVideoDisplayMediator displaySingleVideoWithViewController:currentViewController videoId:model.ID];
            return;
        } else if ([model.modular isEqualToString:@"welfGoods"]) {//福利商城商品详情
            classNameStr = @"XKWelfareGoodsDetailViewController";
            params = @{@"goodsId":model.ID ? model.ID : @""};
        } else if ([model.modular isEqualToString:@"selfGoods"]) {//自营商城商品详情
            classNameStr = @"XKMallGoodsDetailViewController";
            params = @{@"goodsId":model.ID ? model.ID : @""};
        } else if ([model.modular isEqualToString:@"shops"]) {//店铺详情
            classNameStr = @"XKStoreRecommendViewController";
            params = @{@"shopId":model.ID ? model.ID : @""};
        } else if ([model.modular isEqualToString:@"shopGoods"]) {//店铺商品详情
            classNameStr = @"XKTradingAreaGoodsDetailViewController";
            params = @{@"shopId":model.ID ? model.ID : @"",
                       @"goodsId":@""};
        }
    } else if ([model.type isEqualToString:@"list"]) {// 列表页
        if ([model.modular isEqualToString:@"selfClass"]) {//自营商品某分类商品列表
            classNameStr = @"XKMallMainViewController";
            params = @{@"categoryCode":model.ID ? model.ID : @""};
        } else if ([model.modular isEqualToString:@"welfClass"]) {//福利商城某分类商品列表
            classNameStr = @"XKWelfareMainViewController";
            params = @{};
        } else if ([model.modular isEqualToString:@"selfRe"]) {//自营商城推荐商品列表
            classNameStr = @"XKMallHomeSearchResultViewController";
            params = @{@"searchText":@"标题",
                       @"code":model.ID ? model.ID : @""};
        } /*else if ([model.modular isEqualToString:@"welfRe"]) {//福利商城推荐商品列表
            classNameStr = @"";
            params = @{};
        }*/ else if ([model.modular isEqualToString:@"outlets"]) {//直营店
            classNameStr = @"XKMallMerchantViewController";
            params = @{@"shopId":model.ID ? model.ID : @""};
        }
    } else if ([model.type isEqualToString:@"jump"]) { //打开新的App
        if ([model.modular isEqualToString:@"live"]) {//打开直播APP
            
            NSURL *xkLiveUrl = [NSURL URLWithString:@"xklive://"];
            if ([[UIApplication sharedApplication] canOpenURL:xkLiveUrl]) {
                [[UIApplication sharedApplication] openURL:xkLiveUrl options:@{} completionHandler:nil];
            } else {
                // app store
                // yuan'mock
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"] options:@{} completionHandler:nil];
            }
        }
        return;
    }/* else if ([model.type isEqualToString:@"coupon"]) { //领券中心
        classNameStr = @"";
        params = @{};
    }*/
    
    
    if (classNameStr.length) {
        NSString *router = [[XKRouter sharedInstance] urlDynamicTargetClassName:classNameStr Storyboard:nil Identifier:nil XibName:nil Params:params];
        [[XKRouter sharedInstance] runRemoteUrl:router ParentVC:currentViewController];
    }
}


+ (void)showBigImgWithImgsArr:(NSArray *)arr viewController:(UIViewController *)viewController {
    [self showBigImgWithImgsArr:arr defualtIndex:0 viewController:viewController];
   
}

+ (void)showBigImgWithImgsArr:(NSArray *)arr defualtIndex:(NSInteger)index viewController:(UIViewController *)viewController {
    NSMutableArray *models = [NSMutableArray array];
    for (id img in arr) {
        PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
        if ([img isKindOfClass:[NSString class]]) {
            model.imageURL = img;
        } else if([img isKindOfClass:[UIImage class]]) {
            model.thumbImage = img;
        }
        [models addObject:model];
    }
    BigPhotoPreviewBaseController *photoPreviewController = [[BigPhotoPreviewBaseController alloc] init];
    photoPreviewController.models = models;
    photoPreviewController.isSupportLongPress = YES;
    photoPreviewController.isShowNav = YES;
    photoPreviewController.isShowTitle = YES;
    photoPreviewController.strNavTitle = @"";
    photoPreviewController.isHiddenDeleteButton = YES;
    photoPreviewController.isShowStatusBar = YES;
    photoPreviewController.currentIndex = index;
    
    [viewController presentViewController:photoPreviewController animated:YES completion:nil];
}

+ (void)showSingleImgWithImg:(id)img viewController:(UIViewController *)viewController {
    NSMutableArray *models = [NSMutableArray array];
    PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
    if ([img isKindOfClass:[NSString class]]) {
        model.imageURL = img;
    } else if([img isKindOfClass:[UIImage class]]) {
        model.thumbImage = img;
    }
    [models addObject:model];
    BigPhotoPreviewBaseController *photoPreviewController = [[BigPhotoPreviewBaseController alloc] init];
    photoPreviewController.models = models;
    photoPreviewController.isSupportLongPress = YES;
    photoPreviewController.isShowNav = YES;
    photoPreviewController.isShowTitle = NO;
    photoPreviewController.isHiddenDeleteButton = YES;
    
    [viewController presentViewController:photoPreviewController animated:YES completion:nil];
}


- (void)postRequestWithURLStr:(NSString *)url parameters:(NSDictionary *)parameters timeoutInterval:(NSUInteger)timeoutInterval success:(void (^)(id responseObject))success {
    
    [HTTPClient postEncryptRequestWithURLString:url
                                timeoutInterval:timeoutInterval
                                     parameters:parameters
                                        success:^(id responseObject) {
                                            success(responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                            [XKHudView showErrorMessage:error.message];
                                        }];

}

+ (NSArray *)recombineIconArrWithFixedArr:(NSMutableArray *)fixedArr notFixedArr:(NSMutableArray *)notFixedArr iconType:(BannerIconType)type {
    
    XKUserInfo *info =  [XKUserInfo currentUser];
    
    NSString *sysIconJsonStr = nil;
    NSString *userIconJsonStr = nil;
    NSString *optionIconJsonStr = nil;

    if (type == BannerIconType_home) {
        sysIconJsonStr = info.xkHomeSysIcon;
        userIconJsonStr = info.xkHomeUserIcon;
        optionIconJsonStr = info.xkHomeOptionalIcon;
        
    } else if (type == BannerIconType_welfare) {
        sysIconJsonStr = info.xkwelfaresysicon;
        userIconJsonStr = info.xkwelfareusericon;
        optionIconJsonStr = info.xkwelfareoptionalicon;
        
    } else if (type == BannerIconType_mall) {
        sysIconJsonStr = info.xkmallsysicon;
        userIconJsonStr = info.xkmallusericon;
        optionIconJsonStr = info.xkmalloptionalicon;
        
    } else if (type == BannerIconType_tradingArea) {
        sysIconJsonStr = info.xkTradingAreaSysIcon;
        userIconJsonStr = info.xkTradingAreaUserIcon;
        optionIconJsonStr = info.xkTradingAreaOptionalIcon;
    }
    
    NSMutableArray *tmpUserArr = [NSMutableArray array];
    if (fixedArr.count < 9) {
        NSInteger other = 9 - fixedArr.count;
        if (other > 0) {
            NSArray *userArr = [NSArray yy_modelArrayWithClass:[XKSquareHomeToolModel class] json:userIconJsonStr];
            [tmpUserArr addObjectsFromArray:userArr];
            //去重  后台配置的和之前用户选择的有冲突
            for (XKSquareHomeToolModel *icon in fixedArr) {
                for (XKSquareHomeToolModel *item in userArr) {
                    if (icon.code == item.code) {
                        [tmpUserArr removeObject:item];
                    }
                }
            }
            
            if (tmpUserArr.count > 0) {
                //后台配多了 要顶掉一部分用户的
                if (tmpUserArr.count > other) {
                    for (NSInteger i = 0; i < other; i ++) {
                        XKSquareHomeToolModel *item = tmpUserArr[i];
                        [fixedArr addObject:item];
                    }
                } else {
                    [fixedArr addObjectsFromArray:tmpUserArr];
                }
            }
        }
        
        //保存用户自定义的
        if (type == BannerIconType_home) {
            info.xkHomeUserIcon = [tmpUserArr yy_modelToJSONString];

        } else if (type == BannerIconType_welfare) {
            info.xkwelfareusericon = [tmpUserArr yy_modelToJSONString];
            
        } else if (type == BannerIconType_mall) {
            info.xkmallusericon = [tmpUserArr yy_modelToJSONString];
            
        } else if (type == BannerIconType_tradingArea) {
            info.xkTradingAreaUserIcon = [tmpUserArr yy_modelToJSONString];
        }
        
        //后台+用户的还是不够  就从可选中来拿
        other = 9 - fixedArr.count;
        if (other > 0) {
            //去重
            NSMutableArray *tmpOptionalArr = [NSMutableArray array];
            [tmpOptionalArr addObjectsFromArray:notFixedArr];
            for (XKSquareHomeToolModel *icon in fixedArr) {
                for (XKSquareHomeToolModel *item in notFixedArr) {
                    if (icon.code == item.code) {
                        [tmpOptionalArr removeObject:item];
                    }
                }
            }
            NSMutableArray *addOptionalArr = [NSMutableArray array];
            NSMutableArray *weigthArr = [NSMutableArray array];

            [addOptionalArr addObjectsFromArray:tmpOptionalArr];
            //去权重 (去掉未选择数组中以前删除过的数据)
            for (XKSquareHomeToolModel *item in tmpOptionalArr) {
                if (item.weight == 2) {
                    [addOptionalArr removeObject:item];
                    [weigthArr addObject:item];
                }
            }
            
            //加入数组
            if (addOptionalArr.count > other) {
                for (NSInteger i = 0; i < other; i ++) {
                    XKSquareHomeToolModel *item = addOptionalArr[i];
                    [fixedArr addObject:item];
                }
            } else {
                [fixedArr addObjectsFromArray:addOptionalArr];
                other = 9 - fixedArr.count;
                if (other > 0) {//如果还是小于9
                    //加入去掉权重的数据
                    if (weigthArr.count > other) {
                        for (NSInteger i = 0; i < other; i ++) {
                            XKSquareHomeToolModel *item = weigthArr[i];
                            [fixedArr addObject:item];
                        }
                    } else {
                        [fixedArr addObjectsFromArray:weigthArr];
                    }
                }
            }
        }
    }
    
    XKSquareHomeToolModel *item = [XKSquareHomeToolModel yy_modelWithDictionary:@{@"name":@"更多",@"code":@"1", @"icon":@"xk_btn_home_more", @"iconInLocation":@(YES)}];
    [fixedArr addObject:item];
    
    //保存可选的（包括用户已选和未选的）
    if (type == BannerIconType_home) {
        info.xkHomeOptionalIcon = [notFixedArr yy_modelToJSONString];

    } else if (type == BannerIconType_welfare) {
        info.xkwelfareoptionalicon = [notFixedArr yy_modelToJSONString];

    } else if (type == BannerIconType_mall) {
        info.xkmalloptionalicon = [notFixedArr yy_modelToJSONString];

    } else if (type == BannerIconType_tradingArea) {
        info.xkTradingAreaOptionalIcon = [notFixedArr yy_modelToJSONString];
    }
    
    [XKUserInfo saveCurrentUser:info];
    
    return fixedArr.copy;

}



+ (void)jumpUserInfoCenter:(NSString *)userId vc:(UIViewController *)vc {
    if (userId.length == 0) {
        [XKHudView showErrorMessage:@"用户信息错误"];
        return;
    }
    if (vc == nil) {
        vc = [self getCurrentUIVC];
    }
    XKPersonDetailInfoViewController *userVC = [XKPersonDetailInfoViewController new];
    userVC.userId = userId;
    [vc.navigationController pushViewController:userVC animated:YES];
}

+ (void)playVideoWithUrl:(NSURL *)url {
    [XKVideoDisplayMediator displayLocalSingleVideoClearWithViewController:[self getCurrentUIVC] localFilePath:url.absoluteString];
}

+ (void)playVideoWithUrlStr:(NSString *)urlStr {
    [XKVideoDisplayMediator displaySingleVideoClearWithViewController:[self getCurrentUIVC] urlString:urlStr];
}

+ (NSString *)getCurrentUserDeviceToken {
    return [XKDeviceInfoManager sharedManager].getUdidString;
}


+ (NSString *)getH5CodeStr {
    
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    NSString *userToken = [XKUserInfo getCurrentUserToken];
    NSString *userId = [XKUserInfo getCurrentUserId];
    if (userToken) {
        [parameterDic setValue:userToken forKey:@"token"];
        [parameterDic setValue:userId forKey:@"userId"];
    }
    [parameterDic setValue:@"ios" forKey:@"os"];
    [parameterDic setValue:XKAppVersion forKey:@"clientVersion"];
    [parameterDic setValue:[[XKDeviceDataLibrery sharedLibrery] getDiviceName] forKey:@"mobileType"];
    [parameterDic setValue:[XKGlobleCommonTool getCurrentUserDeviceToken] forKey:@"guid"];
    [parameterDic setValue:@"appStore" forKey:@"channel"];
    NSString *infoStr = [parameterDic yy_modelToJSONString];
    NSString *codeStr = [infoStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return codeStr;
}

+ (void)saveSubscriptionData {
    
    NSString *jsonStr1 = [XKUserDefault objectForKey:kAlreadySubscriptionArr];
    if (!jsonStr1) {
        NSArray *arr1 = @[
                          @{@"itemId":@"0", @"titleName":@"商品推荐", @"selectImgName":@"xk_icon_subscription_product_heighlight",      @"normalImgName":@"xk_icon_subscription_product_normal", @"selected":@1},
                          @{@"itemId":@"1", @"titleName":@"商家推荐", @"selectImgName":@"xk_iocn_subscription_activity_heighLight", @"normalImgName":@"xk_iocn_subscription_activity_normal", @"selected":@1},
                          @{@"itemId":@"2", @"titleName":@"平台资讯", @"selectImgName":@"xk_iocn_subscription_consult_heighlight", @"normalImgName":@"xk_iocn_subscription_consult_normal", @"selected":@1},
                          @{@"itemId":@"3", @"titleName":@"朋友圈", @"selectImgName":@"xk_iocn_subscription_cricle_heighLight", @"normalImgName":@"xk_iocn_subscription_cricle_normal", @"selected":@1}
                          ];
        
        [XKUserDefault setObject:[arr1 yy_modelToJSONString]  forKey:kAlreadySubscriptionArr];
        [XKUserDefault synchronize];
    }
    
    NSString *jsonStr2 = [XKUserDefault objectForKey:kCanSubscriptionArr];
    if (!jsonStr2) {
        NSArray *arr2 = @[
                          @{@"itemId":@"4", @"titleName":@"推荐小视频", @"selectImgName":@"xk_iocn_subscription_video_heightLight", @"normalImgName":@"xk_iocn_subscription_video_normal", @"selected":@0},
                          @{@"itemId":@"5", @"titleName":@"游戏推荐", @"selectImgName":@"xk_iocn_subscription_friend_heightLight", @"normalImgName":@"xk_iocn_subscription_friend_normal", @"selected":@0}
                          ];
        
        [XKUserDefault setObject:[arr2 yy_modelToJSONString]  forKey:kCanSubscriptionArr];
        [XKUserDefault synchronize];
    }
}

+ (NSInteger)calculateVideoTime:(NSURL *)url {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    NSInteger totalSecond = urlAsset.duration.value / urlAsset.duration.timescale;
    NSLog(@"计算视频长度 = %ld",(long)totalSecond);
    return totalSecond;
}



/**
 存储引导页面的bool值
 
 @param guidanceViewValue @{控制器名字:bool值}
 */
+ (void)saveGuidanceViewValue:(NSMutableDictionary *)guidanceViewValue {
  [[NSUserDefaults standardUserDefaults] setObject:guidanceViewValue forKey:@"guidanceViewKey"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 获取存储引导页面的bool值
 */
+ (NSMutableDictionary *)getGuidanceViewValue {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"guidanceViewKey"];
}

/**
 检查当前引导页在控制器是否已经显示过
 
 @param key 当前控制器的字符串
 @return 是否已经展示过引导页 yes表示已经展示过了 默认是没有展示
 */
+ (BOOL)backShowGuidanceViewFromDictKey:(NSString *)key {
  __block NSNumber * isShow = @(0);
  NSMutableDictionary *dict = [XKGlobleCommonTool getGuidanceViewValue];
  [dict.allKeys enumerateObjectsUsingBlock:^(NSString *key2, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([key isEqualToString:key2]) {
      isShow = @(1);
      *stop = YES;
    }
  }];
  return [isShow boolValue];
}


@end
