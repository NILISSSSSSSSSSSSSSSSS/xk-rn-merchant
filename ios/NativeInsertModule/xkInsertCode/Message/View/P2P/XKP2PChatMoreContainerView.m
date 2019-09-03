//
//  XKP2PChatMoreContainerView.m
//  XKSquare
//
//  Created by william on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKP2PChatMoreContainerView.h"
#import "UIButton+XKButton.h"
#import <TZImagePickerController.h>
#import "XKIMGlobalMethod.h"
#import "HVideoViewController.h"
#import "XKContactListController.h"
#import "XKMineCollectRootViewController.h"
#import "XKSendRedPacketViewController.h"
#import "XKCommonSheetView.h"
#import "XKChatGiveGiftView.h"
#import "XKMyProductionViewController.h"
#import "XKVideoDisplayModel.h"
#import "XKGiftViewManager.h"


@interface XKP2PChatMoreContainerView()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


/**
 相册
 */
@property(nonatomic, strong)UIButton    *photoButton;


/**
 照相
 */
@property(nonatomic, strong)UIButton    *cameraButton;


/**
 我的作品
 */
@property(nonatomic, strong)UIButton    *myProductsButton;


/**
 红包
 */
@property(nonatomic, strong)UIButton    *redPacketButton;


/**
 收藏
 */
@property(nonatomic, strong)UIButton    *myCollectionButton;


/**
 可友名片
 */
@property(nonatomic, strong)UIButton    *friendNameCardButton;


/**
 礼物按钮
 */
@property(nonatomic, strong)UIButton    *giftButton;
@end

@implementation XKP2PChatMoreContainerView

#pragma mark – Life Cycle
-(id)initWithFrame:(CGRect)frame andSession:(NIMSession *)session{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _session = session;
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark – Private Methods

-(void)initViews{
    [self addSubview:self.photoButton];
    [self addSubview:self.cameraButton];
    [self addSubview:self.friendNameCardButton];
}

-(void)layoutViews{
    [_cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20 * ScreenScale);
        make.right.mas_equalTo(self.mas_centerX).offset(-10 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(65 * ScreenScale, 85 * ScreenScale));
    }];
    
    [_photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_cameraButton.mas_top);
        make.right.mas_equalTo(self->_cameraButton.mas_left).offset(-20 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(65 * ScreenScale, 85 * ScreenScale));
    }];
  
    [_friendNameCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_cameraButton.mas_top);
      make.left.mas_equalTo(self.mas_centerX).offset(10 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * ScreenScale, 85 * ScreenScale));
    }];
}

#pragma mark - Events
-(void)photoButtonClicked:(UIButton *)sender{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        [XKIMGlobalMethod sendImagesMessage:photos session:self->_session];
    }];
    [[self getCurrentUIVC] presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)cameraButtonClicked:(UIButton *)sender{
    HVideoViewController *vc = [HVideoViewController createController];
    vc.HSeconds = 30;
    XKWeakSelf(weakSelf);
    vc.takeBlock = ^(id item, UIImage *firstImg) {
        NSLog(@"%@",item);
        if ([item isKindOfClass:[NSURL class]]) {
            //视频
            [XKHudView showLoadingMessage:@"视频处理中..." to:nil animated:YES];
            NSString *pathString = [NSString stringWithFormat:@"%@",item];
            [[XKUploadManager shareManager]uploadVideoWithUrl:[NSURL URLWithString:pathString] FirstImg:firstImg WithKey:@"IMMessage_Video.mp4" Progress:^(CGFloat progress) {
                NSLog(@"%f",progress);
            } Success:^(NSString *videoKey, NSString *imgKey) {
                NSLog(@"视频上传成功");
                [XKHudView hideAllHud];
                
                XKIMMessageNomalVideoAttachment *attachment = [[XKIMMessageNomalVideoAttachment alloc]init];
                attachment.videoUrl = kQNPrefix(videoKey);
                attachment.videoIcon = kQNPrefix(imgKey);
                attachment.videoWidth = [NSString stringWithFormat:@"%.0f",firstImg.size.width];
                attachment.videoHeight = [NSString stringWithFormat:@"%.0f",firstImg.size.height];
//                attachment.ext = @"mp4";
//                attachment.md5 = @"";
                
                NSURL *movieURL = [NSURL URLWithString:attachment.videoUrl];
                NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
                float second = 0;
                second = urlAsset.duration.value/urlAsset.duration.timescale;
                attachment.videoTime = second * 1000;
                [XKIMGlobalMethod sendVideoMessage:attachment session:weakSelf.session];
            } Failure:^(NSString *error) {
                NSLog(@"视频上传失败");
                [XKHudView hideAllHud];
                [XKHudView showErrorMessage:@"视频发送失败"];
            }];
        }
        else{
            //图片
            UIImage *image = (UIImage *)item;
            [XKIMGlobalMethod sendImagesMessage:@[image] session:self->_session];
            
        }
    };
    [[self getCurrentUIVC] presentViewController:vc animated:YES completion:nil];
}

-(void)orderButtonClicked:(UIButton *)sender{
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
}

-(void)redPacketButtonClicked:(UIButton *)sender{
  [[self getCurrentUIVC].childViewControllers.firstObject touchesBegan:[NSSet set] withEvent:nil];
  XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] initIMSendRedEnvelopWithUserId:self.session.sessionId succeedBlock:^{
    
  } failedBlock:^{
    
  }];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
}

-(void)myCollectionButtonClicked:(UIButton *)sender{
  [[self getCurrentUIVC].childViewControllers.firstObject touchesBegan:[NSSet set] withEvent:nil];
  XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] initIMSendRedEnvelopWithUserId:self.session.sessionId succeedBlock:^{
    
  } failedBlock:^{
    
  }];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
}

-(void)friendNameCardButtonClicked:(UIButton *)sender{
  XKWeakSelf(weakSelf);
  XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
  
  mineCollectRootViewController.controllerType = XKMeassageCollectControllerType;
  mineCollectRootViewController.sendColloctionItemBolck = ^(NSMutableArray *array) {
    [XKIMGlobalMethod sendShareWithShareArray:array session:self.session];
    [[weakSelf getCurrentUIVC].navigationController popViewControllerAnimated:YES];
  };
  [[self getCurrentUIVC].navigationController pushViewController:mineCollectRootViewController animated:YES];
}

-(void)giftButtonClicked:(UIButton *)sender {
    
    XKGiftViewManager *manager = [[XKGiftViewManager alloc] initWithAnimationView:[self getCurrentUIVC].view];
    [manager showIMGiftsViewWhitTargetUserId:self.session.sessionId succeedBlock:^{
        NSLog(@"IM送礼物成功");
    } failedBlock:^{
        NSLog(@"IM送礼物失败");
    }];
    
    /*
    [[self getCurrentUIVC].childViewControllers.firstObject touchesBegan:[NSSet set] withEvent:nil];
    [XKHudView showLoadingTo:[self getCurrentUIVC].view animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(100) forKey:@"limit"];
    // 请求礼物列表接口
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig chatGiftListUrl] timeoutInterval:5.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSArray <XKIMGiftModel *>*array = [NSArray yy_modelArrayWithClass:[XKIMGiftModel class] json:dict[@"data"]];
            if (array.count) {
                // 显示礼物选择视图
                XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                sheetView.backgroundColor = [UIColor clearColor];

                XKChatGiveGiftView *giftView = [[XKChatGiveGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300.0 * ScreenScale + kBottomSafeHeight) gifts:array type:XKChatGiveGiftViewTypeIM];
                giftView.handselBtnBlock = ^(XKIMGiftModel *gift, NSInteger num) {
                    [sheetView dismiss];

                    [XKHudView showLoadingTo:[self getCurrentUIVC].view animated:YES];

                    NSMutableDictionary *userPara = [NSMutableDictionary dictionary];
                    [userPara setObject:self.session.sessionId forKey:@"userId"];
                    NSMutableDictionary *giftPara = [NSMutableDictionary dictionary];
                    [giftPara setObject:@"im_single" forKey:@"giftScene"];
                    [giftPara setObject:gift.giftId forKey:@"giftId"];
                    [giftPara setObject:@(num) forKey:@"num"];
                    NSMutableDictionary *para = [NSMutableDictionary dictionary];
                    [para setObject:userPara forKey:@"receivingUser"];
                    [para setObject:giftPara forKey:@"giftPackage"];

                    // 请求送礼物接口
                    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig sendGiftUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
                        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];

                        XKIMMessageGiftAttachment *attachment = [[XKIMMessageGiftAttachment alloc] init];
                        attachment.giftId = gift.giftId;
                        attachment.giftName = gift.name;
                        attachment.giftIconUrl = gift.smallPicture;
                        attachment.giftNumber = num;
                        [XKIMGlobalMethod sendGift:attachment session:self.session];
                    } failure:^(XKHttpErrror *error) {
                        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];
                        [XKHudView showErrorMessage:error.message];
                    }];
                };
                sheetView.contentView = giftView;
                [sheetView addSubview:giftView];
                [sheetView showWithNoShield];
            }
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
     */
}
#pragma mark - Custom Delegates
#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    NSLog(@"%@",image);
    [XKIMGlobalMethod sendImagesMessage:@[image] session:self->_session];
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark – Getters and Setters


-(UIButton *)photoButton{
    if (!_photoButton) {
        _photoButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"照片" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_photoButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_photo"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _photoButton;
}

-(UIButton *)cameraButton{
    if (!_cameraButton) {
        _cameraButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"拍摄" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_cameraButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_camera"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _cameraButton;
}

-(UIButton *)myProductsButton{
    if (!_myProductsButton) {
        _myProductsButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"我的作品" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_myProductsButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_order"] forState:UIControlStateNormal];
        [_myProductsButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_myProductsButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _myProductsButton;
}

-(UIButton *)redPacketButton{
    if (!_redPacketButton) {
        _redPacketButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"红包" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_redPacketButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_redPacket"] forState:UIControlStateNormal];
        [_redPacketButton addTarget:self action:@selector(redPacketButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_redPacketButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _redPacketButton;
}

-(UIButton *)myCollectionButton{
    if(!_myCollectionButton){
        _myCollectionButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"收藏" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_myCollectionButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_collection"] forState:UIControlStateNormal];
        [_myCollectionButton addTarget:self action:@selector(myCollectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_myCollectionButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _myCollectionButton;
}

-(UIButton *)friendNameCardButton{
    if (!_friendNameCardButton) {
        _friendNameCardButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"可友名片" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_friendNameCardButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_friendNameCard"] forState:UIControlStateNormal];
        [_friendNameCardButton addTarget:self action:@selector(friendNameCardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_friendNameCardButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _friendNameCardButton;
}

-(UIButton *)giftButton{
    if (!_giftButton) {
        _giftButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"礼物" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_giftButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_gift"] forState:UIControlStateNormal];
        [_giftButton addTarget:self action:@selector(giftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_giftButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _giftButton;
}

@end
