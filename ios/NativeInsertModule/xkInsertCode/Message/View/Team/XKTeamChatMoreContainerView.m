//
//  XKTeamChatMoreContainerView.m
//  XKSquare
//
//  Created by william on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTeamChatMoreContainerView.h"
#import "UIButton+XKButton.h"
#import <TZImagePickerController.h>
#import "XKIMGlobalMethod.h"
#import "HVideoViewController.h"
#import "XKContactListController.h"
#import "XKIMMessageFirendCardAttachment.h"
#import "XKIMMessageNomalVideoAttachment.h"
#import "XKMineCollectRootViewController.h"
#import "XKIMMessageRedEnvelopeAttachment.h"
#import "XKSendRedPacketViewController.h"
#import "XKMyProductionViewController.h"
#import "XKVideoDisplayModel.h"

@interface XKTeamChatMoreContainerView()<TZImagePickerControllerDelegate,UINavigationControllerDelegate>


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
@end

@implementation XKTeamChatMoreContainerView

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
  XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] initIMSendRedEnvelopWithTeamId:self.session.sessionId succeedBlock:^{
    
  } failedBlock:^{
    
  }];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [[self getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
}

-(void)myCollectionButtonClicked:(UIButton *)sender{
    XKWeakSelf(weakSelf);
    XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
    mineCollectRootViewController.hidesBottomBarWhenPushed = YES;
    mineCollectRootViewController.controllerType = XKMeassageCollectControllerType;
    mineCollectRootViewController.sendColloctionItemBolck = ^(NSMutableArray *array) {
        [XKIMGlobalMethod sendShareWithShareArray:array session:self.session];
        [[weakSelf getCurrentUIVC].navigationController popViewControllerAnimated:YES];
    };
    [[self getCurrentUIVC].navigationController pushViewController:mineCollectRootViewController animated:YES];
}

-(void)friendNameCardButtonClicked:(UIButton *)sender{
    XKContactListController *vc = [[XKContactListController alloc]init];
    vc.useType = XKContactUseTypeSingleSelect;
    vc.rightButtonText = @"发送";
    vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        [listVC.navigationController popViewControllerAnimated:YES];
        NSMutableArray *UIMIDArr = [NSMutableArray array];
        [UIMIDArr addObject:[XKUserInfo getCurrentIMUserID]];
        if (contacts.count > 0) {
            XKContactModel *model = contacts[0];
            XKIMMessageFirendCardAttachment *attachment = [[XKIMMessageFirendCardAttachment alloc]init];
            attachment.businessUserAvatarUrl = model.avatar;
            attachment.businessUserNickname = model.nickname;
            attachment.businessUserId = model.userId;
            [XKIMGlobalMethod sendFriendCard:attachment session:self.session];
        }
        
    };
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
#pragma mark - Custom Delegates

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

@end
