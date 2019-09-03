//
//  XKShareView.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKShareView.h"
@interface XKShareView()
//分享的类型
@property (nonatomic, assign) JSHAREMediaType type;
//平台的图标,标题，按钮容器
@property (nonatomic, strong) NSMutableDictionary * platformData;
//当前支持的平台的容器
@property (nonatomic, strong) NSMutableArray * currentContentSupportPlatform;
//分享图标的主界面
@property (nonatomic, strong) UIView * shareView;
//取消上面的线
@property (nonatomic, strong) UIView * lineView;
//取消按钮
@property (nonatomic, strong) UIButton * cancelBtn;
//屏幕宽度
@property (nonatomic, assign) CGFloat screenWidth;
//屏幕高度
@property (nonatomic, assign) CGFloat screenHeight;
//横向空格的距离
@property (nonatomic, assign) CGFloat space;
@end
//距上的高度
#define TopSpace 29
//中间的空格距离
#define MidSpace 36
//距下的高度
#define BottomSpace 34
//图标的尺寸
#define ImageSize 58
//标题的尺寸
#define ImageLabelSpace 13
//标题字体的大小
#define ItemFontSize 10
//取消按钮的高度
#define CancelItemHeight 61
//取消按钮的字体大小
#define CancelFontSize 13
//线的颜色
#define LineColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
//字体颜色
#define FontColor [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]

@implementation XKShareView {
    ShareBlock _block;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.space = (self.screenWidth-4*ImageSize)/5;
        self.shareView = [[UIView alloc] init];
        self.currentContentSupportPlatform = [[NSMutableArray alloc] init];
        
        self.platformData = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}
//通过block创建ShareView
+ (XKShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block {
    XKShareView * shareView = [[XKShareView alloc] init];
    [shareView setShareCallBack:block];
    [shareView setShareView];
    [shareView setFacade];
    [shareView setCancelView];
    return shareView;
}
//shareView的配置
- (void)setFacade {
    self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
}

#define RemainTag 9999
//主界面的配置
- (void)setShareView {
    //white cover
    self.shareView.backgroundColor = [UIColor whiteColor];
    //gary line
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = LineColor;
    self.lineView.tag = RemainTag;
    [self.shareView addSubview:self.lineView];
    [self addSubview:self.shareView];
}
//每个平台按钮的配置
- (void)setShareItem {
    //清除以前的item
    for (UIView * view in self.shareView.subviews) {
        if (view.tag != 9999) {
            [view removeFromSuperview];
        }
    }
    //布局item
    for (int i=0; i<self.currentContentSupportPlatform.count; i++) {
        NSNumber * platformkey = self.currentContentSupportPlatform[i];
        NSInteger row = i/4;
        NSInteger column = i%4;
        UIButton * shareItem = self.platformData[platformkey][@"item"];
        shareItem.frame = CGRectMake((column+1)*self.space+column*ImageSize, TopSpace+row*(ImageSize+MidSpace+ItemFontSize+ImageLabelSpace), ImageSize, ImageSize);
        shareItem.tag = platformkey.integerValue;
        [shareItem addTarget:self action:@selector(shareTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [shareItem setImage:[UIImage imageNamed:self.platformData[platformkey][@"image"]] forState:UIControlStateNormal];
        
        UILabel * shareLabel = [[UILabel alloc] init];
        shareLabel.frame = CGRectMake(shareItem.frame.origin.x, CGRectGetMaxY(shareItem.frame)+ImageLabelSpace, CGRectGetWidth(shareItem.frame), ItemFontSize);
        shareLabel.textColor = FontColor;
        shareLabel.font = [UIFont systemFontOfSize:ItemFontSize];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = self.platformData[platformkey][@"title"];
        
        [self.shareView addSubview:shareItem];
        [self.shareView addSubview:shareLabel];
    }
    NSInteger totalRow = (self.currentContentSupportPlatform.count-1)/4 + 1;
    CGFloat shareViewHeight = TopSpace+totalRow*(ImageSize+ItemFontSize+ImageLabelSpace)+(totalRow-1)*MidSpace+BottomSpace+CancelItemHeight;
    self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.screenWidth, shareViewHeight);
    self.cancelBtn.frame = CGRectMake(0, self.shareView.frame.size.height-CancelItemHeight, self.screenWidth, CancelItemHeight);
    self.lineView.frame = CGRectMake(self.space, self.shareView.frame.size.height-62, self.screenWidth-self.space*2, 1);
    [super setHidden:YES];
}
//取消按钮的配置
- (void)setCancelView {
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.tag = RemainTag;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:CancelFontSize];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:self.cancelBtn];
}

- (void)setShareCallBack:(ShareBlock)block {
    if (block) {
        _block = nil;
        _block = [block copy];
    }
}
//点击的回调
- (void)shareTypeSelect:(UIButton *)sender {
    if (_block) {
        _block(sender.tag, self.type);
    }
    [self hiddenView];
}
//通过指定的分享类型展示ShareView
- (void)showWithContentType:(JSHAREMediaType)type {
    [self setPlatformDataWithLogin:NO];
    self.type = type;
    [self.currentContentSupportPlatform removeAllObjects];
    switch (type) {
        case JSHAREEmoticon:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession)]];
            break;
        case JSHAREApp:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine)]];
            break;
        case JSHAREFile:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      ]];
            break;
        case JSHAREVideo:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformTwitter)]];
            break;
        case JSHAREAudio:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone)]];
            break;
        case JSHARELink:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformSinaWeibo),
                                                                      @(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      ]];
            break;
        case JSHARGraphic:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformJChatPro)]];
            break;
        case JSHAREImage:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformSinaWeibo),
                                                                      @(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformFacebook),
                                                                      @(JSHAREPlatformFacebookMessenger),
                                                                      @(JSHAREPlatformTwitter),
                                                                      @(JSHAREPlatformJChatPro)]];
            break;
        case JSHAREText:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformSinaWeibo),
                                                                      @(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformTwitter),
                                                                      @(JSHAREPlatformJChatPro)]];
            break;
            
        default:
            break;
    }
    [self setShareItem];
    self.hidden = NO;
}
//平台的图标,标题，按钮容器添加数据
- (void)setPlatformDataWithLogin:(BOOL)isLogin {
    NSArray * typeArr = @[@(JSHAREPlatformSinaWeibo),
                          @(JSHAREPlatformWechatSession),
                          @(JSHAREPlatformWechatTimeLine),
                          @(JSHAREPlatformWechatFavourite),
                          @(JSHAREPlatformQQ),
                          @(JSHAREPlatformQzone),
                          ];
    NSArray * titleArr = nil;
    if(isLogin){
        titleArr = @[@"新浪微博",@"微信",@"微信朋友圈",@"微信收藏",@"QQ",@"QQ空间"];
    }else {
        titleArr = @[@"新浪微博",@"微信好友",@"微信朋友圈",@"微信收藏",@"QQ好友",@"QQ空间"];
    }
    NSArray * imageArr = @[@"xk_ic_share_weibo",@"xk_ic_share_wechat",@"xk_ic_share_wechat_moment",@"xk_ic_share_wechat_fav",@"xk_ic_share_qq",@"xk_ic_share_qzone"];
    for (int i=0; i<typeArr.count; i++) {
        [self.platformData setObject:@{@"title":titleArr[i], @"image":imageArr[i], @"item":[UIButton buttonWithType:UIButtonTypeCustom]} forKey:typeArr[i]];
    }
}
//重写系统的hidden的方法，添加动画
- (void)setHidden:(BOOL)hidden {
    if (!hidden) {
        [super setHidden:hidden];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.screenHeight-CGRectGetHeight(self.shareView.frame), CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.screenHeight, CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.0];;
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    }
}
//隐藏shareView
- (void)hiddenView {
    self.type = 0;
    self.hidden = YES;
}
//点击屏幕隐藏shareView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenView];
}



@end
