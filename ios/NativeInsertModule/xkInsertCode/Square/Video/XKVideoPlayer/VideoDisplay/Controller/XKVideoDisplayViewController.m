//
//  XKVideoDisplayViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoDisplayViewController.h"
#import "XKVideoDisplayTableViewCell.h"
#import "HTTPClient.h"
#import "XKUserInfo.h"
#import "XKVideoDisplayModel.h"
#import "XKUserInfo.h"
#import "XKVideoAdvertisementViewController.h"
#import "XKVideoCommentView.h"
#import "XKVideoMoreCustomView.h"
#import "XKCustomShareView.h"
#import "JSHAREService.h"
#import "XKContactListController.h"
#import <PLPlayerKit/PLPlayerOption.h>
#import "XKPersonDetailInfoViewController.h"
#import "XKVideoGoodsModel.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKDeviceDataLibrery.h"
#import "XKSendRedPacketViewController.h"
#import "XKMallBuyCarViewModel.h"
#import "XKMallBuyCarCountViewController.h"
#import "XKIMMessageLittleVideoAttachment.h"
#import "XKIMGlobalMethod.h"
#import "XKVideoDisplayTransiton.h"
#import "XKPercentDrivenInteractiveTransition.h"
#import "XKCommonSheetView.h"
#import "XKChatGiveGiftView.h"
#import "XKGiftViewManager.h"

static const NSInteger kVideoDisplayViewControllerPageSize = 5;

@interface XKVideoDisplayViewController () <UITableViewDataSource, UITableViewDelegate, XKVideoDisplayTableViewCellDelegate, XKVideoCommentViewDelegate, XKCustomShareViewDelegate, XKVideoAdvertisementViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSUInteger currentRow;
@property (nonatomic, assign) BOOL isHaveMoreData;

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) XKPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) XKVideoDisplayTransiton *transiton;

@end

@implementation XKVideoDisplayViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不熄屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollsToTop = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    XKVideoDisplayTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0]];
    [currentCell videoNeedsToPlay:YES];
    [currentCell resumePlayVideo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    XKVideoDisplayTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0]];
    [currentCell videoNeedsToPlay:NO];
    [currentCell pausePlayVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self releaseMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self releaseMemory];
}

#pragma mark - public method

- (void)Action_displayVideoWithParams:(NSDictionary *)params {
    
    UIViewController *callerViewController = params[@"viewController"];
    XKVideoDisplayVideoListItemModel *videoListItemModel = params[@"model"];
    NSString *videoId = params[@"videoId"];
    UIView *view = params[@"view"];
    
    if (!callerViewController) {
        return;
    }
    
    // 播放推荐小视频列表
    if (callerViewController && params.count == 1) {
        self.currentPage = 0;
        [self initializeViews];
        [self getRecommendVideoList];
    }
    
    // 播放单个小视频
    if (videoListItemModel) {
        if (view) {
            self.fromView = view;
            callerViewController.navigationController.delegate = self;
            
            // 初始化手势过渡的代理
            if (!self.interactiveTransition) {
                XKPercentDrivenInteractiveTransition *interactiveTransition = [XKPercentDrivenInteractiveTransition interactiveTransitionWithTransitionType:XKPercentDrivenInteractiveTransitionTypePop GestureDirection:XKPercentDrivenInteractiveTransitionGestureDirectionRight];
                
                [interactiveTransition addPanGestureForViewController:self];
                self.interactiveTransition = interactiveTransition;
            }
        }
        [self initializeViews];
        self.dataArr = @[videoListItemModel].mutableCopy;
        self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
    }
    
    // 根据视频ID获取并播放视频
    if (videoId && ![videoId isEqualToString:@""]) {
        [self initializeViews];
        self.tableView.scrollEnabled = NO;
        NSMutableDictionary *params = @{@"video_id": videoId}.mutableCopy;
        [XKZBHTTPClient postRequestWithURLString:[XKAPPNetworkConfig getSingleVideoUrl] timeoutInterval:20.0 parameters:params success:^(id responseObject) {
            XKVideoDisplayModel *model =  [XKVideoDisplayModel yy_modelWithJSON:responseObject];
            NSArray *videoList = model.body.video_list;
            XKVideoDisplayVideoListItemModel *itemModel = videoList[0];
            self.dataArr = @[itemModel].mutableCopy;
            [self.tableView reloadData];
        } failure:^(XKHttpErrror *error) {
            
        }];
    }
    
    self.fromViewController = callerViewController;
    [callerViewController.navigationController pushViewController:self animated:YES];
}

- (UIView *)getTransitonFromView {
    return self.fromView;
}

- (UIView *)getTransitonToView {
    return self.view;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ((fromVC == self.fromViewController && toVC == self) ||
        (toVC == self.fromViewController && fromVC == self)) {
        XKVideoDisplayTransitonType type = operation == UINavigationControllerOperationPush ? XKVideoDisplayTransitonTypePush : XKVideoDisplayTransitonTypePop;
        if (!self.transiton) {
            self.transiton = [XKVideoDisplayTransiton new];
        }
        self.transiton.type = type;
        return self.transiton;
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

#pragma mark - UIScrollViewDelegate

/**
 * 获取当前Cell并标记为需要播放
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.currentRow = self.tableView.contentOffset.y / SCREEN_HEIGHT;
    XKVideoDisplayTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0]];
    [currentCell videoNeedsToPlay:YES];
    
    // 最后一条数据时请求下一页数据
    if (self.currentRow == self.dataArr.count - 1) {
        if (self.isHaveMoreData == YES) {
            [self getRecommendVideoList];
        }
    }
}

#pragma mark - UITableViewDelegate

/**
 * 停止已消失Cell播放
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKVideoDisplayTableViewCell *lastCell = (XKVideoDisplayTableViewCell *)cell;
    [lastCell videoNeedsToPlay:NO];
    [lastCell stopPlayVideo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.height;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKVideoDisplayVideoListItemModel *model = self.dataArr[indexPath.row];
    XKVideoDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKVideoDisplayTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configTableViewCellWithModel:model];
    return cell;
}

#pragma mark - XKVideoDisplayTableViewCellDelegate 播放中相关事件

/**
 * 点击返回按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickBackButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    for (XKVideoDisplayTableViewCell *videoDisplayTableViewCell in self.tableView.visibleCells) {
        [videoDisplayTableViewCell removePlayVideo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 点击直播按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickLiveButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    NSString *userId = [NSString stringWithFormat:@"%@", model.user.user_id];
    NSString *video_id = [NSString stringWithFormat:@"%@", model.user.rooms_id];
    NSString *play = [NSString stringWithFormat:@"%@", model.user.play];
    NSString *urlString = [NSString stringWithFormat:@"xklive://com.dynamic?targetclass=XKAudienceViewController&userId=%@&video_id=%@&play=%@", userId, video_id, play];
    NSURL *xkLiveUrl = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:xkLiveUrl]) {
        [[UIApplication sharedApplication] openURL:xkLiveUrl options:@{} completionHandler:nil];
    } else {
        // 跳转app store对应页面
        // yuan'mock
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"] options:@{} completionHandler:nil];
    }
}

/**
 * 点击广告按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickAdvertisementButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {

    NSArray *recomGoodsList = model.recom_goods;
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableDictionary *infos = @{}.mutableCopy;
    NSMutableArray *detail = @[].mutableCopy;
    for (XKVideoDisplayRecomGoodsItemModel *model in recomGoodsList) {
        NSMutableDictionary *goodsDict = @{}.mutableCopy;
        NSString *xkModule = model.goods_type ? model.goods_type : @"";
        NSString *goodsOrShopId = model.goods_id ? model.goods_id : @"";
        if ([xkModule isEqualToString:@"mall"]) {
            [goodsDict setObject:xkModule forKey:@"xkModule"];
            [goodsDict setObject:goodsOrShopId forKey:@"goodsId"];
        } else if ([xkModule isEqualToString:@"shop"]) {
            [goodsDict setObject:xkModule forKey:@"xkModule"];
            [goodsDict setObject:goodsOrShopId forKey:@"shopId"];
        }
        [detail addObject:goodsDict];
    }
    [infos setObject:detail forKey:@"detail"];
    [params setObject:infos forKey:@"infos"];
    
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getVideoGoodsListUrl] timeoutInterval:20.0 parameters:params success:^(id  _Nonnull responseObject) {
        
        NSArray *goodsList = [NSArray yy_modelArrayWithClass:[XKVideoGoodsModel class] json:responseObject];
        XKVideoAdvertisementViewController *videoAdvertisementViewController = [XKVideoAdvertisementViewController new];
        videoAdvertisementViewController.delegate = self;
        [videoAdvertisementViewController configVideoAdvertisementViewControllerWithRecomGoodsModel:goodsList];
        videoAdvertisementViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:videoAdvertisementViewController animated:YES completion:nil];
    } failure:^(XKHttpErrror * _Nonnull error) {
        
    }];
}

/**
 * 红包按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickRedEnvelopeButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
}

/**
 * 用户头像按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickHeaderButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    XKPersonDetailInfoViewController *personDetailInfoViewController = [[XKPersonDetailInfoViewController alloc] init];
    personDetailInfoViewController.userId = model.user.user_id;
    [self.navigationController pushViewController:personDetailInfoViewController animated:YES];
}

/**
 * 点击关注/取消关注
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickAttentionButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    NSMutableDictionary *params = @{@"rid": model.user.user_id}.mutableCopy;
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getFocusUserUrl] timeoutInterval:20.0 parameters:params success:^(id  _Nonnull responseObject) {
        
        model.user.is_follow = 1;
        [self updateVideoListItemModel:model];
        
    } failure:^(XKHttpErrror * _Nonnull error) {
        
    }];
}

/**
 * 点击点赞按钮，点赞+/-1
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickLikeButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    NSMutableDictionary *params = @{@"videoId": [NSString stringWithFormat:@"%ld", (long)model.video.video_id],
                                    @"author": model.user.user_id}.mutableCopy;
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getVideoLikeUrl] timeoutInterval:20.0 parameters:params success:^(id  _Nonnull responseObject) {
        
        NSError *error;
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            NSNumber *statusNum = dict[@"status"];
            if ([statusNum isEqualToNumber:@1]) {
                model.video.praise_num += 1;
                model.video.is_praise = YES;
            } else {
                model.video.praise_num -= 1;
                if (model.video.praise_num < 0) {
                    model.video.praise_num = 0;
                }
                model.video.is_praise = NO;
            }
            [self updateVideoListItemModel:model];
        }
    } failure:^(XKHttpErrror * _Nonnull error) {
        
    }];
}

/**
 * 点击评论按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickCommentButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    // 弹出评价视图
    XKVideoCommentView *commentView = [[XKVideoCommentView alloc] initWithVideo:model delegate:self];
    [commentView showInView:self.view];
}

/**
 * 点击分享按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickShareButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    // 弹出分享视图
    XKVideoMoreCustomView *customView = [[XKVideoMoreCustomView alloc] initWithFrame:CGRectMake(0.0, 0.0, 187.0, 264.0)];
    [customView configViewWithVideoModel:model];
    NSMutableArray *shareItems = [NSMutableArray arrayWithArray:@[
                                                                  XKShareItemTypeCircleOfFriends,
                                                                  XKShareItemTypeWechatFriends,
                                                                  XKShareItemTypeQQ,
                                                                  XKShareItemTypeSinaWeibo,
                                                                  XKShareItemTypeMyFriends,
                                                                  XKShareItemTypeCopyLink,
                                                                  XKShareItemTypeSaveToLocal,
                                                                  // XKShareItemTypeReport
                                                                  ]
                                  ];
    XKCustomShareView *moreView = [[XKCustomShareView alloc] init];
    moreView.autoThirdShare = YES;
    moreView.customView = customView;
    moreView.delegate = self;
    moreView.layoutType = XKCustomShareViewLayoutTypeCenter;
    moreView.shareItems = shareItems;
    XKVideoDisplayVideoListItemModel *video = self.dataArr[self.currentRow];
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = video.video.describe;
    shareData.content = [NSString stringWithFormat:@"来自：%@ ID：%@", video.user.user_name, video.user.user_id];
    shareData.url = video.video.wmImg_video ? video.video.wmImg_video : video.video.video;
    shareData.img = video.video.zdy_cover ? video.video.zdy_cover : video.video.first_cover;
    moreView.shareData = shareData;
    [moreView showInView:self.view];
}

/**
 * 点击礼物按钮
 */
- (void)tableViewCell:(XKVideoDisplayTableViewCell *)cell clickGiftButtonWithModel:(XKVideoDisplayVideoListItemModel *)model {
    // 弹出送礼视图
    
    XKGiftViewManager *manager = [[XKGiftViewManager alloc] init];
    [manager showLittleVideoGiftsViewWithTargetUserId:model.user.user_id videoId:[NSString stringWithFormat:@"%tu", model.video.video_id] redEnvelopeCellBlock:^{
        XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] init];
//        vc.sendType = SendRedpacketTypeMany;
        [self.navigationController pushViewController:vc animated:YES];
    } succeedBlock:^{
        NSLog(@"小视频送礼物成功");
    } failedBlock:^{
        NSLog(@"小视频送礼物失败");
    }];
    
    /*
    [XKHudView showLoadingTo:self.view animated:YES];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(100) forKey:@"limit"];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig chatGiftListUrl] timeoutInterval:5.0 parameters:para success:^(id responseObject) {
        [XKHudView hideHUDForView:self.view animated:YES];
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSArray <XKIMGiftModel *>*array = [NSArray yy_modelArrayWithClass:[XKIMGiftModel class] json:dict[@"data"]];
            if (array.count && self) {
                XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
                sheetView.backgroundColor = [UIColor clearColor];
                
                XKChatGiveGiftView *giftView = [[XKChatGiveGiftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300.0 * ScreenScale + kBottomSafeHeight) gifts:array type:XKChatGiveGiftViewTypeLittleVideo];
                giftView.handselBtnBlock = ^(XKIMGiftModel *gift, NSInteger num) {
                    [sheetView dismiss];
                    [XKHudView showLoadingTo:[self getCurrentUIVC].view animated:YES];
                    
                    NSMutableDictionary *userPara = [NSMutableDictionary dictionary];
                    [userPara setObject:model.user.user_id forKey:@"userId"];
                    NSMutableDictionary *giftPara = [NSMutableDictionary dictionary];
                    [giftPara setObject:@(model.video.video_id) forKey:@"sceneId"];
                    [giftPara setObject:@"video" forKey:@"giftScene"];
                    [giftPara setObject:gift.giftId forKey:@"giftId"];
                    [giftPara setObject:@(num) forKey:@"num"];
                    NSMutableDictionary *para = [NSMutableDictionary dictionary];
                    [para setObject:userPara forKey:@"receivingUser"];
                    [para setObject:giftPara forKey:@"giftPackage"];
                    // 请求送礼物接口
                    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig sendGiftUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
                        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];
//                        if (responseObject) {
//                            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
//                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                        }
                        NSLog(@"赠送成功");
                    } failure:^(XKHttpErrror *error) {
                        [XKHudView hideHUDForView:[self getCurrentUIVC].view animated:YES];
                        [XKHudView showErrorMessage:error.message];
                    }];
                };
                giftView.sendRedEnvelopeBlock = ^{
                    [sheetView dismiss];
                    XKSendRedPacketViewController *vc = [[XKSendRedPacketViewController alloc] init];
                    vc.sendType = SendRedpacketTypeMany;
                    [self.navigationController pushViewController:vc animated:YES];
                };
                sheetView.contentView = giftView;
                [sheetView addSubview:giftView];
                [sheetView showWithNoShield];
                
                UIView *tempView = [[UIView alloc] init];
                [sheetView insertSubview:tempView belowSubview:giftView];
                [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(sheetView);
                }];
                [tempView bk_whenTapped:^{
                    [sheetView dismiss];
                }];
            }
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.view animated:YES];
        [XKHudView showErrorMessage:@"获取礼物列表失败"];
    }];
     */
}

#pragma mark - XKVideoAdvertisementViewControllerDelegate 点击广告回调

/**
 * 进入商品详情页
 */
- (void)viewController:(XKVideoAdvertisementViewController *)viewController clickGotoGoodsButtonWithModel:(XKVideoGoodsModel *)model {
    
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.type = XKMallGoodsDetailViewControllerTypeSoldByVideoAdvertisement;
    detail.goodsId = model.ID;
    [self.navigationController pushViewController:detail animated:YES];
}

/**
 * 点击去下单，进入结算页
 */
- (void)viewController:(XKVideoAdvertisementViewController *)viewController clickPlaceAnOrderButtonWithModel:(XKVideoGoodsModel *)model {
    
    XKMallBuyCarCountViewController *mallBuyCarCountViewController = [XKMallBuyCarCountViewController new];
    
    // 模型转换(XKVideoGoodsModel -> XKMallBuyCarItem)
    XKMallBuyCarItem *mallBuyCarItem = [XKMallBuyCarItem new];
    mallBuyCarItem.goodsId = model.ID;
    mallBuyCarItem.goodsName = model.name;
    mallBuyCarItem.url = model.pic;
    mallBuyCarItem.price = model.price;
    mallBuyCarItem.quantity = model.num;
    mallBuyCarItem.goodsSkuCode = model.goodsSkuCode;
    mallBuyCarItem.goodsAttr = model.goodsSkuName;
    mallBuyCarCountViewController.goodsArr = @[mallBuyCarItem];
    mallBuyCarCountViewController.totalPrice = model.price * mallBuyCarItem.quantity;
    [self.navigationController pushViewController:mallBuyCarCountViewController animated:YES];
}

#pragma mark - XKVideoCommentViewDelegate 评论视图回调

/**
 * 评论视图显示回调
 */
- (void)videoCommentViewDidShown:(XKVideoCommentView *)videoCommentView {
    
}

/**
 * 评论视图隐藏回调
 */
- (void)videoCommentViewDidHidden:(XKVideoCommentView *)videoCommentView {
    
}

/**
 * 评论视图输入框输入了@符号回调
 */
- (void)videoCommentViewDidInputedAtCharacter:(XKVideoCommentView *)videoCommentView {
    
}

/**
 * 评论视图点击了某个用户回调
 */
- (void)videoCommentView:(XKVideoCommentView *)videoCommentView didClickedUser:(NSString *)userId {
    
    XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 评论视图评论数+1
 */
- (void)videoCommentView:(XKVideoCommentView *)videoCommentView didCommentCountChanged:(NSUInteger)commentCount {
    
    XKVideoDisplayVideoListItemModel *model = self.dataArr[self.currentRow];
    model.video.com_num = commentCount;
    [self updateVideoListItemModel:model];
}

#pragma mark - XKCustomShareViewDelegate 分享视图回调

/**
 * 分享视图分享成功回调
 */
- (void)customShareView:(XKCustomShareView *)customShareView didAutoThirdShareSucceed:(NSString *)shareItem {
    XKVideoDisplayVideoListItemModel *video = self.dataArr[self.currentRow];
    [self postAddVideoShareCountWithVideoId:[NSString stringWithFormat:@"%tu", video.video.video_id]];
}

/**
 * 分享视图点击回调
 */
- (void)customShareView:(XKCustomShareView *)customShareView didClickedShareItem:(NSString *)shareItem {
    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
      // 我的朋友
      XKContactListController *vc = [[XKContactListController alloc] init];
      vc.useType = XKContactUseTypeSingleSelect;
      vc.rightButtonText = @"完成";
      vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
        [listVC.navigationController popViewControllerAnimated:YES];
        XKVideoDisplayVideoListItemModel *video = self.dataArr[self.currentRow];
        XKIMMessageShareLittleVideoAttachment *attachment = [[XKIMMessageShareLittleVideoAttachment alloc] init];
        attachment.videoId = [NSString stringWithFormat:@"%tu",video.video.video_id];
        attachment.videoIconUrl = video.video.zdy_cover?video.video.zdy_cover:video.video.first_cover;
        attachment.videoUrl = video.video.video;
        attachment.videoAuthorAvatarUrl = video.user.user_img;
        attachment.videoAuthorName = video.user.user_name;;
        attachment.videoDescription = video.video.describe;
        [XKIMGlobalMethod sendCollectItem:attachment session:[NIMSession session:contacts.firstObject.userId type:NIMSessionTypeP2P]];
      };
      [self.navigationController pushViewController:vc animated:YES];
    } else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
//        复制链接
        XKVideoDisplayVideoListItemModel *video = self.dataArr[self.currentRow];
        [UIPasteboard generalPasteboard].string = video.video.wmImg_video;
        [XKAlertView showCommonAlertViewWithTitle:@"链接已复制"];
    } else if ([shareItem isEqualToString:XKShareItemTypeSaveToLocal]) {
//        保存至本地
        XKVideoDisplayVideoListItemModel *video = self.dataArr[self.currentRow];
        [self postDownloadVideoWithVideoId:[NSString stringWithFormat:@"%tu", video.video.video_id] videoName:video.video.describe videoUrl:video.video.wmImg_video];
    } else if ([shareItem isEqualToString:XKShareItemTypeReport]) {
//        举报
    }
}

#pragma mark - private method

- (void)initializeViews {
    
    self.tableView = [UITableView new];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.bounces = YES;
    [self.tableView registerClass:[XKVideoDisplayTableViewCell class] forCellReuseIdentifier:@"XKVideoDisplayTableViewCell"];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 下拉刷新
    XKWeakSelf(weakSelf)
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        XKStrongSelf(strongSelf)
        [XKUserInfo currentUser].recommendVideoRand = @"";
        XKUserSynchronize;
        strongSelf.currentPage = 0;
        [strongSelf.dataArr removeAllObjects];
        [strongSelf getRecommendVideoList];
    }];
}

/**
 * 刷新小视频model
 */
- (void)updateVideoListItemModel:(XKVideoDisplayVideoListItemModel *)model {
    
    // 刷新cell显示model
    XKVideoDisplayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0]];
    [cell updateUserInfoViews:model];
}

/**
 * 获取推荐小视频
 */
- (void)getRecommendVideoList {

    NSString *rand = [XKUserInfo getCurrentRecommendVideoRand] ? [XKUserInfo getCurrentRecommendVideoRand] : @"";
    NSString *pageString = [NSString stringWithFormat:@"%@", @(self.currentPage)];
    NSString *pageSizeString = [NSString stringWithFormat:@"%@", @(kVideoDisplayViewControllerPageSize)];
    NSMutableDictionary *params = @{@"rand": rand,
                                    @"page": pageString,
                                   @"limit": pageSizeString}.mutableCopy;
    [XKZBHTTPClient postRequestWithURLString:GetRecommendVideoUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        XKVideoDisplayModel *model =  [XKVideoDisplayModel yy_modelWithJSON:responseObject];
        NSString *rand = model.body.rand;
        [XKUserInfo currentUser].recommendVideoRand = rand;
        XKUserSynchronize;
        NSArray *videoList = model.body.video_list;
        [self.dataArr addObjectsFromArray:videoList];
        [self.tableView reloadData];
        
        // tableView reloadData后视频变为stop状态，需要重新播放
        if (self.currentRow != 0) {
            XKVideoDisplayTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0]];
            [currentCell videoNeedsToPlay:YES];
        }
        self.currentPage++;
        
        // 更新上拉状态
        if (videoList.count < kVideoDisplayViewControllerPageSize) {
            self.isHaveMoreData = NO;
        } else {
            self.isHaveMoreData = YES;
        }
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 * 小视频分享数+1
 */
- (void)postAddVideoShareCountWithVideoId:(NSString *)videoId {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:videoId forKey:@"video_id"];
    [XKZBHTTPClient postRequestWithURLString:[XKAPPNetworkConfig getAddShareCountUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        
        XKVideoDisplayVideoListItemModel *model = self.dataArr[self.currentRow];
        model.video.share_num += 1;
        [self updateVideoListItemModel:model];
    } failure:^(XKHttpErrror * _Nonnull error) {
        NSLog(@"小视频分享次数+1 %@", error.message);
    }];
}

/**
 * 下载小视频
 */
- (void)postDownloadVideoWithVideoId:(NSString *)videoId videoName:(NSString *)videoName videoUrl:(NSString *)videoUrl {
    [XKHudView showLoadingMessage:@"视频下载中，请耐心等待" to:nil animated:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString  *savePath = [NSString stringWithFormat:@"%@/%@-%@.mp4", documentsDirectory, videoId, videoName];
    [XKZBHTTPClient downloadFileWithUrlStr:videoUrl savePath:savePath progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XKHudView hideAllHud];
            [XKHudView showLoadingMessage:[NSString stringWithFormat:@"%.2f%%", (CGFloat)progress.completedUnitCount / (CGFloat)progress.completedUnitCount * 100.0] to:nil animated:YES];
        });
    } success:^(NSURL * _Nonnull filePath) {
        [XKHudView hideAllHud];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath.path)) {
            // 保存视频
            UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(filePath));
        }
    } failure:^(NSError * _Nonnull error) {
        [XKHudView hideAllHud];
        [XKHudView showErrorMessage:error.localizedDescription];
    }];
}

/**
 * 下载小视频完成后回调
 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [XKHudView showErrorMessage:error.localizedDescription];
    } else {
        [XKHudView showSuccessMessage:@"保存视频成功"];
        // 保存成功，删除本地的视频文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:videoPath error:nil];
    }
}

/**
 * 释放内存
 */
- (void)releaseMemory {
    
    NSInteger numberOfSections = self.tableView.numberOfSections;
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            XKVideoDisplayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell removePlayVideo];
        }
    }
    
    for (XKVideoDisplayTableViewCell *videoDisplayTableViewCell in self.tableView.visibleCells) {
        [videoDisplayTableViewCell removePlayVideo];
    }
}

#pragma mark - setter and getter

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

@end
