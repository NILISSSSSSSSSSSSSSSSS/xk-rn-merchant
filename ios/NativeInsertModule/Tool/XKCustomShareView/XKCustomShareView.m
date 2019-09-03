//
//  XKCustomShareView.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomShareView.h"
#import "XKShareItemCollectionViewCell.h"
#import "JSHAREService.h"
#import <UIImage+Reduce.h>

@implementation XKShareDataModel

@end

@implementation XKShareItemModel

+ (instancetype)modelWithId:(NSString *)id img:(NSString *)img title:(NSString *)title {
    XKShareItemModel *model = [[XKShareItemModel alloc] init];
    model.id = id;
    model.img = img;
    model.title = title;
    return model;
}

@end

@interface XKCustomShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIScrollView *customScrollView;

@property (nonatomic, strong) UIView *scrollViewContainerView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *separateLine;

@property (nonatomic, strong) UIButton *closeBtn;


@property (nonatomic, strong) NSMutableArray <XKShareItemModel *>*datas;

@end

@implementation XKCustomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self initializeData];
        [self initializeViews];
        [self updateViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self.effectView addGestureRecognizer:tap];
    }
    return self;
}

- (void)initializeData {
    _autoThirdShare = NO;
    _customView = nil;
    _delegate = nil;
    _layoutType = XKCustomShareViewLayoutTypeCenter;
}

- (void)initializeViews {
    [self addSubview:self.effectView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.customScrollView];
    [self.customScrollView addSubview:self.scrollViewContainerView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.separateLine];
    [self.containerView addSubview:self.closeBtn];
}

- (void)updateViews {
    
    [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom);
        make.leading.mas_equalTo(27.0);
        make.trailing.mas_equalTo(-27.0);
    }];
    
    [self.customScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.leading.mas_equalTo(15.0);
        make.trailing.mas_equalTo(-15.0);
        make.height.mas_equalTo(0.0);
    }];
    
    [self.scrollViewContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.customScrollView);
        make.width.mas_equalTo(self.customScrollView);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customScrollView.mas_bottom).offset(15.0);
        make.centerX.mas_equalTo(self.containerView);
        make.width.mas_equalTo(SCREEN_WIDTH - 75.0);
        make.height.mas_equalTo((SCREEN_WIDTH - 75.0) / 4.0 * 2.0);
    }];

    [self.separateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.separateLine.mas_bottom).offset(5.0);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(36.0);
        make.bottom.mas_equalTo(self.containerView).offset(-5.0);
    }];
}

#pragma mark - public method

- (void)showInView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    self.hidden = NO;
    [view addSubview:self];
    [self.containerView layoutIfNeeded];
    [UIView animateWithDuration:0.33 animations:^{
        self.effectView.alpha = 0.85;
        if (self.layoutType == XKCustomShareViewLayoutTypeCenter) {
            self.containerView.transform = CGAffineTransformMakeTranslation(0.0, -(SCREEN_HEIGHT - (SCREEN_HEIGHT - CGRectGetHeight(self.containerView.frame)) / 2.0));
        } else {
            self.containerView.transform = CGAffineTransformMakeTranslation(0.0, -CGRectGetHeight(self.containerView.frame));
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.33 animations:^{
        self.effectView.alpha = 0.0;
        self.containerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - privite method

- (XKShareItemModel *)getShareItemModelWithShareItem:(NSString *) shareItem {
    
    if ([shareItem isEqualToString:XKShareItemTypeCircleOfFriends]) {
        return [XKShareItemModel modelWithId:@"circleOfFriends" img:@"xk_ic_video_more_circleOfFriends" title:@"朋友圈"];
    } else if ([shareItem isEqualToString:XKShareItemTypeWechatFriends]) {
        return [XKShareItemModel modelWithId:@"wechatFriends" img:@"xk_ic_video_more_wechatFriends" title:@"微信好友"];
    } else if ([shareItem isEqualToString:XKShareItemTypeQQ]) {
        return [XKShareItemModel modelWithId:@"QQ" img:@"xk_ic_video_more_QQ" title:@"QQ"];
    } else if ([shareItem isEqualToString:XKShareItemTypeSinaWeibo]) {
        return [XKShareItemModel modelWithId:@"weibo" img:@"xk_ic_video_more_weibo" title:@"微博"];
    } else if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
        return [XKShareItemModel modelWithId:@"myFriends" img:@"xk_ic_video_more_myFriends" title:@"我的朋友"];
    } else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
        return [XKShareItemModel modelWithId:@"copyLink" img:@"xk_ic_video_more_copyLink" title:@"复制链接"];
    } else if ([shareItem isEqualToString:XKShareItemTypeSaveToLocal]) {
        return [XKShareItemModel modelWithId:@"saveToLocalHost" img:@"xk_ic_video_more_saveToLocal" title:@"保存至本地"];
    } else if ([shareItem isEqualToString:XKShareItemTypeReport]) {
        return [XKShareItemModel modelWithId:@"report" img:@"xk_ic_video_more_report" title:@"举报"];
    }
    return nil;
}

- (void)closeBtnAction {
    [self hide];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKShareItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XKShareItemCollectionViewCell class]) forIndexPath:indexPath];
    [cell configCellWithModel:self.datas[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    NSString *shareItem = self.shareItems[indexPath.row];
    if (self.autoThirdShare &&
        ([shareItem isEqualToString:XKShareItemTypeCircleOfFriends] ||
         [shareItem isEqualToString:XKShareItemTypeWechatFriends] ||
         [shareItem isEqualToString:XKShareItemTypeQQ] ||
         [shareItem isEqualToString:XKShareItemTypeSinaWeibo])) {
            
        JSHAREMessage *message = [JSHAREMessage message];
        message.mediaType = message.mediaType = JSHARELink;
        if (self.shareData) {
//            标题
            message.title = self.shareData.title.length > 50 ? [self.shareData.title substringToIndex:50] : self.shareData.title;
//            内容
            message.text = self.shareData.content.length > 50 ? [self.shareData.content substringToIndex:50] : self.shareData.content;
//            url
            message.url = /*self.shareData.url.length > 250 ? [self.shareData.url substringToIndex:250] : */self.shareData.url;
//            图片
          UIImage *orignalImg;
          if ([self.shareData.img isKindOfClass:[NSString class]]) {
            orignalImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)self.shareData.img]]];
          }
          if ([self.shareData.img isKindOfClass:[NSData class]]) {
            orignalImg = [UIImage imageWithData:self.shareData.img];
          }
          if ([shareItem isEqualToString:XKShareItemTypeQQ]) {
            // QQ
            message.thumbnail = [orignalImg imageCompressForSpecifyKB:1024.0];
            message.image = [orignalImg imageCompressForSpecifyKB:1024.0 * 5.0];
          } else {
            // 其他
            message.thumbnail = [orignalImg imageCompressForSpecifyKB:32.0];
            message.image = [orignalImg imageCompressForSpecifyKB:1024.0 * 10.0];
          }
        } else {
            [XKAlertView showCommonAlertViewWithTitle:@"自动分享请先设置shareData属性"];
        }
        if ([shareItem isEqualToString:XKShareItemTypeCircleOfFriends]) {
            // 朋友圈
            message.platform = JSHAREPlatformWechatTimeLine;
        } else if ([shareItem isEqualToString:XKShareItemTypeWechatFriends]) {
            // 微信好友
            message.platform = JSHAREPlatformWechatSession;
        } else if ([shareItem isEqualToString:XKShareItemTypeQQ]) {
            // QQ
            message.platform = JSHAREPlatformQQ;
        } else if ([shareItem isEqualToString:XKShareItemTypeSinaWeibo]) {
            // 微博
            message.platform = JSHAREPlatformSinaWeibo;
        }
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            if (error) {
                if (![JSHAREService isQQInstalled] && (message.platform == JSHAREPlatformQQ || message.platform == JSHAREPlatformQzone)){
                    [XKAlertView showCommonAlertViewWithTitle:@"没有安装QQ客户端"];
                    return;
                }
                if (![JSHAREService isWeChatInstalled] && (message.platform == JSHAREPlatformWechatSession || message.platform == JSHAREPlatformWechatTimeLine || message.platform == JSHAREPlatformWechatFavourite )) {
                    [XKAlertView showCommonAlertViewWithTitle:@"没有安装微信客户端"];
                    return;
                }
                if (![JSHAREService isSinaWeiBoInstalled] && message.platform == JSHAREPlatformSinaWeibo) {
                    [XKAlertView showCommonAlertViewWithTitle:@"没有安装微博客户端"];
                    return;
                }
            } else {
                switch (state) {
                    case JSHAREStateSuccess: {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(customShareView:didAutoThirdShareSucceed:)]) {
                            [self.delegate customShareView:self didAutoThirdShareSucceed:shareItem];
                        }
                    }
                        break;
                    case JSHAREStateFail: {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(customShareView:didAutoThirdShareFailed:)]) {
                            [self.delegate customShareView:self didAutoThirdShareFailed:shareItem];
                        }
                    }
                        break;
                    case JSHAREStateCancel: {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(customShareView:didAutoThirdShareCanceled:)]) {
                            [self.delegate customShareView:self didAutoThirdShareCanceled:shareItem];
                        }
                    }
                        break;
                    case JSHAREStateUnknown: {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(customShareView:didAutoThirdShareFailed:)]) {
                            [self.delegate customShareView:self didAutoThirdShareFailed:shareItem];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customShareView:didClickedShareItem:)]) {
            [self.delegate customShareView:self didClickedShareItem:self.shareItems[indexPath.row]];
        }
    }
}

#pragma mark - getter setter

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.alpha = 0.0;
    }
    return _effectView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HEX_RGB(0xffffff);
    }
    return _containerView;
}

- (UIScrollView *)customScrollView {
    if (!_customScrollView) {
        _customScrollView = [[UIScrollView alloc] init];
    }
    return _customScrollView;
}

- (UIView *)scrollViewContainerView {
    if (!_scrollViewContainerView) {
        _scrollViewContainerView = [[UIView alloc] init];
    }
    return _scrollViewContainerView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumLineSpacing = 0.0;
        _layout.minimumInteritemSpacing = 0.0;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKShareItemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XKShareItemCollectionViewCell class])];
    }
    return _collectionView;
}

- (UILabel *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UILabel alloc] init];
        _separateLine.backgroundColor = HEX_RGB(0xf1f1f1);
    }
    return _separateLine;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.titleLabel.font = XKRegularFont(14.0);
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (NSMutableArray <XKShareItemModel *>*)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)setAutoThirdShare:(BOOL)autoThirdShare {
    _autoThirdShare = autoThirdShare;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    for (UIView *tempView in self.scrollViewContainerView.subviews) {
        [tempView removeFromSuperview];
    }
    if (_customView) {
        [self.customView layoutIfNeeded];
        [self.scrollViewContainerView addSubview:self.customView];
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollViewContainerView);
            make.centerX.mas_equalTo(self.scrollViewContainerView);
            make.width.mas_equalTo(CGRectGetWidth(self.customView.frame));
            make.height.mas_equalTo(CGRectGetHeight(self.customView.frame));
            make.bottom.mas_equalTo(self.scrollViewContainerView);
        }];
        self.customScrollView.scrollEnabled = CGRectGetHeight(self.customView.frame) < 300.0;
        [self.customScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGRectGetHeight(self.customView.frame) > 300.0 ? 300.0 : CGRectGetHeight(self.customView.frame));
        }];
    } else {
        [self.customScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
    }
}

- (void)setDelegate:(id<XKCustomShareViewDelegate>)delegate {
    _delegate = delegate;
}

- (void)setLayoutType:(XKCustomShareViewLayoutType)layoutType {
    _layoutType = layoutType;
    if (_layoutType == XKCustomShareViewLayoutTypeCenter) {
        self.containerView.layer.cornerRadius = 8.0;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(27.0);
            make.trailing.mas_equalTo(-27.0);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH - 75.0);
            make.height.mas_equalTo((SCREEN_WIDTH - 75.0) / 4.0 * 2.0);
        }];
        [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView).offset(-5.0);
        }];
        self.layout.itemSize = CGSizeMake((SCREEN_WIDTH - 75.0) / 4.0, (SCREEN_WIDTH - 75.0) / 4.0);
    } else if (_layoutType == XKCustomShareViewLayoutTypeBottom) {
        self.containerView.layer.cornerRadius = 0.0;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0.0);
            make.trailing.mas_equalTo(0.0);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_WIDTH / 4.0 * 2.0);
        }];
        [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView).offset(-(5.0 + kBottomSafeHeight));
        }];
        self.layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0, SCREEN_WIDTH / 4.0);
    }
    [self.collectionView reloadData];
}

- (void)setShareItems:(NSMutableArray<NSString *> *)shareItems {
    _shareItems = shareItems;
    CGFloat unitSize = 0.0;
    if (_layoutType == XKCustomShareViewLayoutTypeCenter) {
        unitSize = (SCREEN_WIDTH - 75.0) / 4.0;
    } else if (_layoutType == XKCustomShareViewLayoutTypeBottom) {
        unitSize = (SCREEN_WIDTH / 4.0);
    }
    if (_shareItems.count > 4) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(unitSize * 2.0);
        }];
    } else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(unitSize);
        }];
    }
    [self.datas removeAllObjects];
    for (NSString *shareItem in shareItems) {
        [self.datas addObject:[self getShareItemModelWithShareItem:shareItem]];
    }
    [self. collectionView reloadData];
}


@end
