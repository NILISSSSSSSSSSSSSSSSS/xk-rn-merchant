//
//  XKIMSDKChatToolView.m
//  xkMerchant
//
//  Created by xudehuai on 2019/3/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKIMSDKChatToolView.h"
#import <TZImagePickerController.h>
#import "XKIM.h"
#import "XKChatGiveGiftViewLayout.h"
#import "XKIMSDKChatToolCollectionViewCell.h"

#import "XKAuthorityTool.h"
#import "HVideoViewController.h"
#import "XKVideoDisplayModel.h"
#import "XKMyProductionViewController.h"
#import "XKSendRedPacketViewController.h"
#import "XKMineCollectRootViewController.h"
#import "XKContactListController.h"
#import "XKGiftViewManager.h"
#import "XKSecretDataSingleton.h"
#import "XKSendMineCouponViewController.h"
//#import "XKCardCouponsManager.h"
#import "XKCommonSheetView.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKMallOrderViewModel.h"
#import "XKCustomerSerChatOrderView.h"
#import "XKCustomerSerEvaluateView.h"
#import "XKWelfareOpinionViewController.h"

#import "XKIMGlobalMethod.h"
#import "XKCustomeSerMessageManager.h"

@implementation XKIMSDKChatToolModel

- (instancetype)initWithIDStr:(NSString *)idStr img:(NSString *)img title:(NSString *)title {
    self = [super init];
    if (self) {
        self.idStr = idStr;
        self.img = img;
        self.title = title;
    }
    return self;
}

@end

@interface XKIMSDKChatToolView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XKSendMineCouponViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) XKChatGiveGiftViewLayout *layout;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation XKIMSDKChatToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self addSubview:self.collectionView];
}

- (void)updateViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10.0, 16.5, 10.0, 16.5));
    }];
}

#pragma makr - Public Methods

- (void)prepareWithTools:(NSArray<NSString *> *)tools {
    [self.datas removeAllObjects];
    for (NSString *tool in tools) {
        if ([tool isEqualToString:photo]) {
            // 照片
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_photo" title:@"照片"]];
        } else if ([tool isEqualToString:camera]) {
            // 拍摄
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_camera" title:@"拍摄"]];
        } else if ([tool isEqualToString:works]) {
            // 我的作品
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_order" title:@"我的作品"]];
        } else if ([tool isEqualToString:redEnvelope]) {
            // 红包
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_redPacket" title:@"红包"]];
        } else if ([tool isEqualToString:collection]) {
            // 收藏
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_collection" title:@"收藏"]];
        } else if ([tool isEqualToString:friendCard]) {
            // 可友名片
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_friendNameCard" title:@"可友名片"]];
        } else if ([tool isEqualToString:gift]) {
            // 礼物
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_gift" title:@"礼物"]];
        } else if ([tool isEqualToString:cardCoupon]) {
            // 卡券
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_cardCoupon" title:@"卡券"]];
        } else if ([tool isEqualToString:order]) {
            // 订单
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_order" title:@"订单"]];
        } else if ([tool isEqualToString:evaluate]) {
            // 评价
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_evaluat" title:@"评价"]];
        } else if ([tool isEqualToString:complain]) {
            // 投诉客服
            [self.datas addObject:[[XKIMSDKChatToolModel alloc] initWithIDStr:tool img:@"xk_btn_IM_inputView_complaintCustomerSer" title:@"投诉客服"]];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - Privite Methods

- (void)photoAction {
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    if (self.toolType == XKIMSDKChatToolViewTypeP2P ||
        self.toolType == XKIMSDKChatToolViewTypeTeam) {
      // 单聊 群聊
      imagePickerVc.allowPickingVideo = YES;
      [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        [weakSelf getVideoFromPHAsset:asset complete:^(NSString *error, NSURL *url) {
          float time = [XKGlobleCommonTool calculateVideoTime:url];
          if (time > 120.0) {
            [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"视频时长过长,请限制%tus之内", 120]];
            return ;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
            [XKHudView showLoadingMessage:@"视频处理中..." to:KEY_WINDOW animated:YES];
          });
          
          [[XKUploadManager shareManager] uploadVideoBothFirstImg:asset FirstImg:coverImage WithKey:@"IMMessage_Video.mp4" Progress:^(CGFloat progress) {
            NSLog(@"%f",progress);
          } Success:^(NSString *videoKey, NSString *imgKey) {
            NSLog(@"视频上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
              [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
            });
            
            XKIMMessageNomalVideoAttachment *attachment = [[XKIMMessageNomalVideoAttachment alloc]init];
            attachment.videoUrl = kQNPrefix(videoKey);
            attachment.videoIcon = kQNPrefix(imgKey);
            attachment.videoWidth = [NSString stringWithFormat:@"%.0f",coverImage.size.width];
            attachment.videoHeight = [NSString stringWithFormat:@"%.0f",coverImage.size.height];
            
            NSURL *movieURL = [NSURL URLWithString:attachment.videoUrl];
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                             forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
            float second = 0;
            second = urlAsset.duration.value / urlAsset.duration.timescale;
            attachment.videoTime = second * 1000;
            [XKIMGlobalMethod sendVideoMessage:attachment session:weakSelf.session];
          } Failure:^(NSString *error) {
            NSLog(@"视频上传失败");
            dispatch_async(dispatch_get_main_queue(), ^{
              [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
              [XKHudView showErrorMessage:@"视频发送失败"];
            });
          }];
        }];
      }];
    } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
      // 客服
      imagePickerVc.allowPickingVideo = YES;
      [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        [weakSelf getVideoFromPHAsset:asset complete:^(NSString *error, NSURL *url) {
          float time = [XKGlobleCommonTool calculateVideoTime:url];
          if (time > 15.0) {
            [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"视频时长过长,请限制%tus之内", 15]];
            return ;
          }
          [XKCustomeSerMessageManager sendSerVideoMessageWithVideovideoTime:time * 1000 videoUrl:url.absoluteString firstImg:coverImage videoWidth:coverImage.size.width videoHeight:coverImage.size.height sessoin:weakSelf.session];
        }];
      }];
    }
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        if (weakSelf.toolType == XKIMSDKChatToolViewTypeP2P ||
            weakSelf.toolType == XKIMSDKChatToolViewTypeTeam) {
            // 单聊 群聊
            [XKIMGlobalMethod sendImagesMessage:photos session:weakSelf.session];
        } else if (weakSelf.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
            // 客服
            [XKCustomeSerMessageManager sendSerImageMessageWithImageArr:photos sessoin:weakSelf.session];
        }
    }];
    [[self getCurrentUIVC] presentViewController:imagePickerVc animated:YES completion:nil];
}

// 获取视频资源
- (void)getVideoFromPHAsset:(PHAsset *)phAsset complete:(void(^)(NSString *error, NSURL *url))result {
    if (phAsset.mediaType == PHAssetMediaTypeVideo ||
        phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            dispatch_async(dispatch_get_main_queue(), ^{
                [XKHudView showLoadingTo:nil animated:YES];
            });
            NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [XKHudView hideHUDForView:nil];
            });
            if (data.length == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XKHudView showTipMessage:@"iCould同步中..."];
                });
                return;
            }
            result(nil,urlAsset.URL);
        }];
    } else {
        result(@"未知错误", nil);
    }
}

- (void)cameraAction {
    [XKAuthorityTool judegeCanRecord:^{
        [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAlbum needGuide:YES has:^{
            if (self.toolType == XKIMSDKChatToolViewTypeP2P ||
                self.toolType == XKIMSDKChatToolViewTypeTeam) {
                // 单聊群聊
                [self takeFromCameraAction];
            } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
                // 客服
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self; //设置代理
                imagePickerController.allowsEditing = NO;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //图片来源
                [[self getCurrentUIVC] presentViewController:imagePickerController animated:YES completion:nil];
            }
        } hasnt:^{
            
        }];
    }];
}

- (void)takeFromCameraAction {
    HVideoViewController *vc = [HVideoViewController createController];
    vc.HSeconds = 30;
    __weak typeof(self) weakSelf = self;
    vc.takeBlock = ^(id item, UIImage *firstImg) {
        NSLog(@"%@",item);
        if ([item isKindOfClass:[NSURL class]]) {
            // 视频
            [XKHudView showLoadingMessage:@"视频处理中..." to:KEY_WINDOW animated:YES];
            NSString *pathString = [NSString stringWithFormat:@"%@",item];
            [[XKUploadManager shareManager]uploadVideoWithUrl:[NSURL URLWithString:pathString] FirstImg:firstImg WithKey:@"IMMessage_Video.mp4" Progress:^(CGFloat progress) {
                NSLog(@"%f",progress);
            } Success:^(NSString *videoKey, NSString *imgKey) {
                NSLog(@"视频上传成功");
                [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
                
                XKIMMessageNomalVideoAttachment *attachment = [[XKIMMessageNomalVideoAttachment alloc]init];
                attachment.videoUrl = kQNPrefix(videoKey);
                attachment.videoIcon = kQNPrefix(imgKey);
                attachment.videoWidth = [NSString stringWithFormat:@"%.0f",firstImg.size.width];
                attachment.videoHeight = [NSString stringWithFormat:@"%.0f",firstImg.size.height];
                
                NSURL *movieURL = [NSURL URLWithString:attachment.videoUrl];
                NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
                float second = 0;
                second = urlAsset.duration.value / urlAsset.duration.timescale;
                attachment.videoTime = second * 1000;
                [XKIMGlobalMethod sendVideoMessage:attachment session:weakSelf.session];
            } Failure:^(NSString *error) {
                NSLog(@"视频上传失败");
                [XKHudView hideHUDForView:KEY_WINDOW animated:YES];
                [XKHudView showErrorMessage:@"视频发送失败"];
            }];
        } else {
            // 图片
            UIImage *image = (UIImage *)item;
            [XKIMGlobalMethod sendImagesMessage:@[image] session:self.session];
        }
    };
    [[self getCurrentUIVC] presentViewController:vc animated:YES completion:nil];
}

- (void)worksAction {
    if (self.toolType == XKIMSDKChatToolViewTypeP2P ||
        self.toolType == XKIMSDKChatToolViewTypeTeam) {
        // 单聊 群聊
        UIViewController *backVC = [self getCurrentUIVC];
        XKMyProductionViewController *vc = [[XKMyProductionViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        __weak typeof(vc) weakVC = vc;
        vc.sendProductionsBlock = ^(NSArray<XKVideoDisplayVideoListItemModel *> * _Nonnull productions) {
            [weakVC.navigationController popToViewController:backVC animated:YES];
            for (XKVideoDisplayVideoListItemModel *video in productions) {
                XKIMMessageShareLittleVideoAttachment *attachment = [[XKIMMessageShareLittleVideoAttachment alloc] init];
                attachment.videoId = [NSString stringWithFormat:@"%tu",video.video.video_id];
                attachment.videoIconUrl = video.video.zdy_cover ? video.video.zdy_cover : video.video.first_cover;
                attachment.videoUrl = video.video.video;
                attachment.videoAuthorAvatarUrl = video.user.user_img;
                attachment.videoAuthorName = video.user.user_name;;
                attachment.videoDescription = video.video.describe;
                [XKIMGlobalMethod sendCollectItem:attachment session:weakSelf.session];
            }
        };
        [backVC.navigationController pushViewController:vc animated:YES];
    } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
    }
}

- (void)redEnvelopeAction {
    if (self.toolType == XKIMSDKChatToolViewTypeP2P) {
        // 单聊
        XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] initIMSendRedEnvelopWithUserId:self.session.sessionId succeedBlock:^{
            
        } failedBlock:^{
            
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
    } else if (self.toolType == XKIMSDKChatToolViewTypeTeam) {
        // 群聊
        XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] initIMSendRedEnvelopWithTeamId:self.session.sessionId succeedBlock:^{
            
        } failedBlock:^{
            
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
    } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
    }
}

- (void)collectionAction {
    __weak typeof(self) weakSelf = self;
    if (self.toolType == XKIMSDKChatToolViewTypeP2P ||
        self.toolType == XKIMSDKChatToolViewTypeTeam) {
        // 单聊 群聊
        XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
        mineCollectRootViewController.controllerType = XKMeassageCollectControllerType;
        mineCollectRootViewController.sendColloctionItemBolck = ^(NSMutableArray *array) {
            [XKIMGlobalMethod sendShareWithShareArray:array session:weakSelf.session];
            [[weakSelf getCurrentUIVC].navigationController popViewControllerAnimated:YES];
        };
        [[self getCurrentUIVC].navigationController pushViewController:mineCollectRootViewController animated:YES];
    } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
    }
}

- (void)friendCardAction {
    __weak typeof(self) weakSelf = self;
    if (self.toolType == XKIMSDKChatToolViewTypeP2P ||
        self.toolType == XKIMSDKChatToolViewTypeTeam) {
        // 单聊 群聊
        XKContactListController *vc = [[XKContactListController alloc] init];
        vc.useType = XKContactUseTypeSingleSelect;
        vc.rightButtonText = @"发送";
        vc.sureBtnIsGrayWhenNoChoose = YES;
        vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            [listVC.navigationController popViewControllerAnimated:YES];
            NSMutableArray *UIMIDArr = [NSMutableArray array];
            [UIMIDArr addObject:[XKUserInfo getCurrentIMUserID]];
            if (contacts.count > 0) {
                XKContactModel *model = contacts.firstObject;
                XKIMMessageFirendCardAttachment *attachment = [[XKIMMessageFirendCardAttachment alloc]init];
                attachment.businessUserAvatarUrl = model.avatar;
                attachment.businessUserNickname = model.nickname;
                attachment.businessUserId = model.userId;
                attachment.businessUserUid = model.uid;
                [XKIMGlobalMethod sendFriendCard:attachment session:weakSelf.session];
            }
        };
        [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    } else if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
    }
}

- (void)giftAction {
    if (self.toolType == XKIMSDKChatToolViewTypeP2P) {
        // 单聊
//        XKGiftViewManager *manager = [[XKGiftViewManager alloc] initWithAnimationView:[self getCurrentUIVC].view];
//        [manager showIMGiftsViewWhitTargetUserId:self.session.sessionId isSecretFriend:[XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret succeedBlock:^{
//            NSLog(@"礼物赠送失败");
//        } failedBlock:^{
//            NSLog(@"礼物赠送失败");
//        }];
    }
}

- (void)cardCouponAction {
    if (self.toolType == XKIMSDKChatToolViewTypeP2P) {
        // 单聊
//        XKSendMineCouponViewController *vc = [[XKSendMineCouponViewController alloc] init];
//        vc.sendType = XKSendMineCouponViewControllerSendTypeTypeImPromotion;
//        vc.delegate = self;
//        [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
}

- (void)orderAction {
    if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
        XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
        XKCustomerSerChatOrderView *orderView = [[XKCustomerSerChatOrderView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 422.0 + kBottomSafeHeight)];
        orderView.closeBtnBlock = ^{
            [sheetView dismiss];
        };
        orderView.sendBtnBlock = ^(NSArray *array) {
            [sheetView dismiss];
            for (id order in array) {
                XKIMMessageCustomerSerOrderAttachment *attachment = [[XKIMMessageCustomerSerOrderAttachment alloc] init];
                if ([order isKindOfClass:[WelfareOrderDataItem class]]) {
                    WelfareOrderDataItem *welfareOrder = (WelfareOrderDataItem *)order;
                    attachment.orderType = 1;
                    attachment.orderId = welfareOrder.orderId;
                    attachment.orderCommodityCount = 1;
                    attachment.orderIconUrl = welfareOrder.url;
                    attachment.commodityName = welfareOrder.name;
                    attachment.commoditySpecification = @"";
                    attachment.orderTotalAmount = 0.0;
                }
                if ([order isKindOfClass:[MallOrderListDataItem class]]) {
                    MallOrderListDataItem *platformOrder = (MallOrderListDataItem *)order;
                    attachment.orderType = 2;
                    attachment.orderId = platformOrder.orderId;
                    attachment.orderCommodityCount = platformOrder.goods.count;
                    attachment.orderIconUrl = platformOrder.goods.count >= 1 ? (platformOrder.goods.firstObject.goodsPic) : @"";
                    if (platformOrder.goods.count >= 1) {
                        MallOrderListObj *goods = platformOrder.goods.firstObject;
                        if (platformOrder.goods.count == 1) {
                            attachment.commodityName = goods.goodsName;
                            attachment.commoditySpecification = goods.goodsShowAttr;
                        } else {
                            attachment.commodityName = [NSString stringWithFormat:@"共%tu件商品", platformOrder.goods.count];
                            attachment.commoditySpecification = @"";
                        }
                    } else {
                        attachment.commodityName = @"订单内无商品";
                        attachment.commoditySpecification = @"";
                    }
                    CGFloat allPrice = 0.0;
                    for (MallOrderListObj *goods in platformOrder.goods) {
                        allPrice += goods.price * goods.num;
                    }
                    attachment.orderTotalAmount = allPrice / 100.0;
                }
                [XKCustomeSerMessageManager sendSerOrderMessageWithOrderDictionary:attachment session:self.session];
            }
        };
        sheetView.contentView = orderView;
        [sheetView addSubview:orderView];
        [sheetView show];
    }
}

- (void)evaluateAction {
    if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
        XKCustomerSerEvaluateView *evaluateView = [[XKCustomerSerEvaluateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [evaluateView show];
    }
}

- (void)complainAction {
    if (self.toolType == XKIMSDKChatToolViewTypeCustomerSer) {
        // 客服
        [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            if (members.count > 1) {
                // 不只我一人
//                XKWelfareOpinionViewController *vc = [[XKWelfareOpinionViewController alloc] init];
//                vc.reportType = XKReportTypeCustomerSerComplaint;
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else {
                // 只有我一人
                [XKHudView showErrorMessage:@"客服尚未接单，请耐心等待"];
                return ;
            }
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    [XKCustomeSerMessageManager sendSerImageMessageWithImageArr:@[image] sessoin:self.session];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - XKSendMineCouponViewControllerDelegate

- (void)sendMineCouponViewController:(XKSendMineCouponViewController *)viewController selectedArray:(NSArray *)selectedArray {
//    [XKCardCouponsManager handselCardCoupons:selectedArray toUserId:self.session.sessionId animationView:[self getCurrentUIVC].view sendIMMessage:YES succeedBlock:^{
//
//    } failedBlock:^(NSString * _Nonnull errorMessage) {
//
//    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSUInteger sectionCount = self.layout.itemCountPerRow * self.layout.rowCount;
    if (self.datas.count % sectionCount) {
        return self.datas.count / sectionCount + 1;
    } else {
        return self.datas.count / sectionCount;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.layout.itemCountPerRow * self.layout.rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKIMSDKChatToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XKIMSDKChatToolCollectionViewCell class]) forIndexPath:indexPath];
    NSUInteger sectionCount = self.layout.itemCountPerRow * self.layout.rowCount;
    if (sectionCount * indexPath.section + (indexPath.row + 1) > self.datas.count) {
        cell.hidden = YES;
        [cell configCellWithImg:@"" title:@"" space:7.0 font:XKRegularFont(12.0) titleColor:HEX_RGB(0x777777)];
    } else {
        cell.hidden = NO;
        XKIMSDKChatToolModel *toolModel = self.datas[sectionCount * indexPath.section + indexPath.row];
        [cell configCellWithImg:toolModel.img title:toolModel.title space:7.0 font:XKRegularFont(12.0) titleColor:HEX_RGB(0x777777)];
        }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[self getCurrentUIVC].view endEditing:YES];
    NSUInteger sectionCount = self.layout.itemCountPerRow * self.layout.rowCount;
    if (sectionCount * indexPath.section + (indexPath.row + 1) > self.datas.count) {
        return;
    }
    
    XKIMSDKChatToolModel *toolModel = self.datas[sectionCount * indexPath.section + indexPath.row];
    NSString *tool = toolModel.idStr;
    if ([tool isEqualToString:photo]) {
        // 照片
        [self photoAction];
    } else if ([tool isEqualToString:camera]) {
        // 拍摄
        [self cameraAction];
    } else if ([tool isEqualToString:works]) {
        // 我的作品
        [self worksAction];
    } else if ([tool isEqualToString:redEnvelope]) {
        // 红包
        [self redEnvelopeAction];
    } else if ([tool isEqualToString:collection]) {
        // 收藏
        [self collectionAction];
    } else if ([tool isEqualToString:friendCard]) {
        // 可友名片
        [self friendCardAction];
    } else if ([tool isEqualToString:gift]) {
        // 礼物
        [self giftAction];
    } else if ([tool isEqualToString:cardCoupon]) {
        // 卡券
        [self cardCouponAction];
    } else if ([tool isEqualToString:order]) {
        // 订单
        [self orderAction];
    } else if ([tool isEqualToString:evaluate]) {
        // 评价
        [self evaluateAction];
    } else if ([tool isEqualToString:complain]) {
        // 投诉客服
        [self complainAction];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(CGRectGetWidth(collectionView.frame) / self.layout.itemCountPerRow, CGRectGetHeight(collectionView.frame) / self.layout.rowCount);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

#pragma mark - Getter Setter

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XKIMSDKChatToolCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XKIMSDKChatToolCollectionViewCell class])];
  }
  return _collectionView;
}

- (XKChatGiveGiftViewLayout *)layout {
  if (!_layout) {
    _layout = [[XKChatGiveGiftViewLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.itemCountPerRow = 4;
    _layout.rowCount = 2;
    _layout.sectionInset = UIEdgeInsetsZero;
  }
  return _layout;
}

- (NSMutableArray *)datas {
  if (!_datas) {
    _datas = [NSMutableArray array];
  }
  return _datas;
}

@end
