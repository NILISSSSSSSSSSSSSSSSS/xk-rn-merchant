//
//  XKVideoCommentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCommentView.h"

#import "XKVideoCommentTableViewCell.h"
#import "XKVideoSubCommentTableViewCell.h"
#import "XKVideoCommentMoreTableViewCell.h"

#import "XKVideoDisplayModel.h"
#import "XKVideoCommentModel.h"

@interface XKVideoCommentView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<XKVideoCommentViewDelegate> delegate;

@property (nonatomic, strong) XKVideoDisplayVideoListItemModel *video;

@property (nonatomic, strong) UIView *tapView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *scrollViewContainerView;

@property (nonatomic, strong) UITableView *commentsTableView;

@property (nonatomic, strong) XKEmptyPlaceView *commentsEmptyView;

@property (nonatomic, strong) UIActivityIndicatorView *commentsLoadingView;

@property (nonatomic, strong) UITableView *replysTableView;

@property (nonatomic, strong) XKEmptyPlaceView *replysEmptyView;

@property (nonatomic, strong) UIActivityIndicatorView *replysLoadingView;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UITextField *commentTF;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, strong) XKVideoCommentModel *currentComment;

@property (nonatomic, strong) XKVideoCommentModel *commentToReply;

@property (nonatomic, strong) XKVideoReplyModel *replyToReply;


@property (nonatomic, assign) NSUInteger commentPage;

@property (nonatomic, assign) NSUInteger maxCommentCount;

@property (nonatomic, assign) NSUInteger replyPage;

@property (nonatomic, assign) NSUInteger maxReplyCount;

@end

@implementation XKVideoCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.tapView addGestureRecognizer:tap];
        self.commentsEmptyView = [XKEmptyPlaceView configScrollView:self.commentsTableView config:nil];
        self.commentsEmptyView.config.backgroundColor = [UIColor clearColor];
        self.commentsEmptyView.config.verticalOffset = 0.0;
        self.replysEmptyView = [XKEmptyPlaceView configScrollView:self.replysTableView config:nil];
        self.replysEmptyView.config.backgroundColor = [UIColor clearColor];
        self.replysEmptyView.config.verticalOffset = 0.0;
        __weak typeof(self) weakSelf = self;
        self.commentsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.commentPage = 1;
            [weakSelf postAllComments];
        }];
        self.commentsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.comments.count >= weakSelf.maxCommentCount) {
                [weakSelf.commentsTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            [weakSelf postAllComments];
        }];
        self.replysTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.replyPage = 1;
            [weakSelf postCommentReplysWithCommentId:self.currentComment.id loading:NO];
        }];
        self.replysTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.currentComment.allReplys.count >= weakSelf.maxReplyCount) {
                [weakSelf.replysTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            [weakSelf postCommentReplysWithCommentId:self.currentComment.id loading:NO];
        }];
    }
    return self;
}

- (instancetype)initWithVideo:(XKVideoDisplayVideoListItemModel *)video delegate:(id)delegate {
    self = [[XKVideoCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _video = video;
        _delegate = delegate;
    }
    return self;
}

- (void)initializeViews {
    
    [self addSubview:self.tapView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.effectView];
    [self.containerView addSubview:self.backBtn];
    [self.containerView addSubview:self.titleLab];
    [self.containerView addSubview:self.closeBtn];
    [self.containerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainerView];
    [self.scrollViewContainerView addSubview:self.commentsTableView];
    [self.scrollViewContainerView addSubview:self.commentsLoadingView];
    [self.scrollViewContainerView addSubview:self.replysTableView];
    [self.scrollViewContainerView addSubview:self.replysLoadingView];
    [self.containerView addSubview:self.inputView];
    [self.inputView addSubview:self.commentTF];
    [self.inputView addSubview:self.sendBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)updateViews {
    
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.containerView.mas_top);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(465.0 * ScreenScale);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.leading.mas_equalTo(10.0);
        make.width.height.mas_equalTo(25.0);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.width.height.mas_equalTo(25.0);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn).offset(-5.0);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(5.0);
        make.right.mas_equalTo(self.closeBtn.mas_left).offset(-5.0);
        make.bottom.mas_equalTo(self.backBtn).offset(5.0);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40.0);
        make.leading.trailing.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
    }];
    
    [self.scrollViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView);
    }];
    
    [self.commentsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    [self.commentsLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.commentsTableView);
        make.width.height.mas_equalTo(50.0);
    }];
    
    [self.replysTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.scrollViewContainerView);
        make.left.mas_equalTo(self.commentsTableView.mas_right);
        make.width.mas_equalTo(self.scrollView);
        make.trailing.mas_equalTo(self.scrollViewContainerView);
    }];
    
    [self.replysLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.replysTableView);
        make.width.height.mas_equalTo(50.0);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.containerView);
        make.height.mas_equalTo(kBottomSafeHeight + 50.0);
    }];
    
    [self.commentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.0);
        make.leading.mas_equalTo(10.0);
        make.bottom.mas_equalTo(-(kBottomSafeHeight + 8.0));
        make.right.mas_equalTo(self.sendBtn.mas_left).offset(-10.0);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.commentTF);
        make.trailing.mas_equalTo(self.inputView).offset(-10.0);
        make.width.mas_equalTo(55.0);
        make.height.mas_equalTo(36.0);
    }];
}

#pragma mark - public method

- (void)showInView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    self.hidden = NO;
    [view addSubview:self];
    [UIView animateWithDuration:0.33 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0.0, -(465.0 * ScreenScale));
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoCommentViewDidShown:)]) {
            [self.delegate videoCommentViewDidShown:self];
        }
        self.commentPage = 1;
        [self postAllComments];
    }];
}

- (void)hide {
    [self endEditing:YES];
    [UIView animateWithDuration:0.33 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoCommentViewDidHidden:)]) {
            [self.delegate videoCommentViewDidHidden:self];
        }
    }];
}


#pragma mark - privite method
// 空白处点击事件
- (void)tapAction {
    if (self.commentTF.isFirstResponder) {
        [self endEditing: YES];
        return;
    }
    [self hide];
}
// 返回按钮点击事件
- (void)backBtnAction {
    [UIView animateWithDuration:0.33 animations:^{
        self.scrollView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        self.backBtn.hidden = YES;
        self.currentComment = nil;
        [self.replysTableView reloadData];
        [self.replysEmptyView hide];
    }];
}
// 关闭按钮点击事件
- (void)closeBtnAction {
    [self hide];
}
// 发送按钮点击事件
- (void)sendBtnAction {
    [self endEditing:YES];
    if (self.commentTF.text && self.commentTF.text.length) {
        if (self.commentToReply && self.replyToReply) {
//            回复评论下的某条回复
            [self postAddReplyWithCommentId:self.commentToReply.id userId:self.replyToReply.creator.id];
        } else if ((self.commentToReply && !self.replyToReply) || self.currentComment) {
//            回复某条评论
            [self postAddReplyWithCommentId:(self.commentToReply && !self.replyToReply) ? self.commentToReply.id : self.currentComment.id userId:nil];
        } else {
//            添加评论
            [self postAddComment];
        }
    }
}
// 键盘即将显示
- (void)keyboardWillShow:(NSNotification *) sender {
    CGRect keyboardRect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.33 animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0.0, -height);
    } completion:^(BOOL finished) {
        
    }];
}
// 键盘即将隐藏
- (void)keyboardWillHide:(NSNotification *) sender {
    [UIView animateWithDuration:0.33 animations:^{
        self.inputView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    } completion:^(BOOL finished) {
        self.commentToReply = nil;
        self.replyToReply = nil;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"神评我来造~"];
        [placeholder addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, placeholder.length)];
        [placeholder addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, placeholder.length)];
        self.commentTF.attributedPlaceholder = placeholder;
    }];
}
// 显示或者隐藏评论加载圈
- (void)setCommentsLoadingViewHidden:(BOOL) hidden {
    if (hidden) {
        [self.commentsLoadingView stopAnimating];
    } else {
        [self.commentsLoadingView startAnimating];
    }
    self.commentsLoadingView.hidden = hidden;
}
// 显示或者隐藏回复加载圈
- (void)setReplysLoadingViewHidden:(BOOL) hidden {
    if (hidden) {
        [self.replysLoadingView stopAnimating];
    } else {
        [self.replysLoadingView startAnimating];
    }
    self.replysLoadingView.hidden = hidden;
}
// 显示特定评论的回复
- (void)showReplysWithComment:(XKVideoCommentModel *) comment {
    [UIView animateWithDuration:0.33 animations:^{
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0.0);
    } completion:^(BOOL finished) {
        self.backBtn.hidden = NO;
        self.currentComment = comment;
        self.currentComment.videlAuthorId = self.video.user.user_id;
        [self.replysTableView reloadData];
        [self postCommentDetailWithCommentId:comment.id];
    }];
}

#pragma mark - POST
// 获取所有的评论
- (void)postAllComments {
    [self setCommentsLoadingViewHidden:NO];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[NSString stringWithFormat:@"%tu", self.video.video.video_id] forKey:@"videoId"];
    [para setObject:[NSString stringWithFormat:@"%tu", self.commentPage] forKey:@"page"];
    [para setObject:[NSString stringWithFormat:@"%tu", 10] forKey:@"limit"];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getAllCommentsUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [self setCommentsLoadingViewHidden:YES];
        [self.commentsTableView.mj_header endRefreshing];
        [self.commentsTableView.mj_footer endRefreshing];
        if (self.commentPage == 1) {
            [self.commentsTableView.mj_footer resetNoMoreData];
            [self.comments removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.maxCommentCount = [dict[@"total"] unsignedIntegerValue];
            self.video.video.com_num = [dict[@"total"] unsignedIntegerValue];
            self.titleLab.text = [NSString stringWithFormat:@"%tu条评论", self.video.video.com_num];
            [self.comments addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoCommentModel class] json:dict[@"data"]]];
            for (XKVideoCommentModel *comment in self.comments) {
                comment.videlAuthorId = self.video.user.user_id;
            }
            [self.commentsTableView reloadData];
        }
        if (self.comments.count) {
            [self.commentsEmptyView hide];
        } else {
            __weak typeof(self) weakSelf = self;
            self.commentsEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.commentsEmptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [weakSelf postAllComments];
            }];
        }
        self.commentPage += 1;
    } failure:^(XKHttpErrror * _Nonnull error) {
        [self setCommentsLoadingViewHidden:YES];
        [self.commentsTableView.mj_header endRefreshing];
        [self.commentsTableView.mj_footer endRefreshing];
        if (self.comments.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.commentsEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.commentsEmptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postAllComments];
            }];
        }
    }];
}
// 获取某个评论的详情
- (void)postCommentDetailWithCommentId:(NSString *) commentId {
    [self setReplysLoadingViewHidden:NO];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:commentId forKey:@"commentId"];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getCommentDetailUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [self.currentComment.allReplys removeAllObjects];
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.currentComment = [XKVideoCommentModel yy_modelWithDictionary:dict];
            self.currentComment.videlAuthorId = self.video.user.user_id;
            [self.replysTableView reloadData];
            if (self.currentComment.replyCount || self.currentComment.previousReply.count) {
//                有回复数才去请求列表
                self.replyPage = 1;
                [self postCommentReplysWithCommentId:self.currentComment.id loading:YES];
            } else {
//                无回复数
                [self setReplysLoadingViewHidden:YES];
            }
        }
    } failure:^(XKHttpErrror * _Nonnull error) {
        [self setReplysLoadingViewHidden:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}
// 获取某个评论的回复
- (void)postCommentReplysWithCommentId:(NSString *) commentId loading:(BOOL) loading {
    if (loading) {
        [self setReplysLoadingViewHidden:NO];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:commentId forKey:@"commentId"];
    [para setObject:@(self.replyPage) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getCommentReplysUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [self setReplysLoadingViewHidden:YES];
        [self.replysTableView.mj_header endRefreshing];
        [self.replysTableView.mj_footer endRefreshing];
        if (self.replyPage == 1) {
            [self.replysTableView.mj_footer resetNoMoreData];
            [self.currentComment.allReplys removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.maxReplyCount = [dict[@"total"] unsignedIntegerValue];
            [self.currentComment.allReplys addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoReplyModel class] json:dict[@"data"]]];
            [self.replysTableView reloadData];
        }
        self.replyPage += 1;
    } failure:^(XKHttpErrror * _Nonnull error) {
        [self setReplysLoadingViewHidden:YES];
        [self.replysTableView.mj_header endRefreshing];
        [self.replysTableView.mj_footer endRefreshing];
        if (self.currentComment.allReplys.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.replysEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.replysEmptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postCommentReplysWithCommentId:commentId loading:loading];
            }];
        }
    }];
}

// 点赞某个评论
- (void)postLikeCommentWithCommentId:(NSString *) commentId {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:commentId forKey:@"commentId"];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getLikeCommentUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            刷新评论列表
            for (XKVideoCommentModel *comment in [self.comments copy]) {
                if ([comment.id isEqualToString:commentId]) {
                    comment.liked = [dict[@"status"] integerValue] == 1;
                    comment.praiseCount += [dict[@"status"] integerValue] == 1 ? 1 : (comment > 0 ? -1 : 0);
                    [self.commentsTableView reloadData];
                    break;
                }
            }
            if (self.currentComment) {
//                刷新回复列表
                self.currentComment.liked = [dict[@"status"] integerValue] == 1;
                self.currentComment.praiseCount += [dict[@"status"] integerValue] == 1 ? 1 : (self.currentComment > 0 ? -1 : 0);
                [self.replysTableView reloadData];
            }
            self.video.video.praise_num += [dict[@"status"] integerValue] == 1 ? 1 : (self.currentComment > 0 ? -1 : 0);
        }
    } failure:^(XKHttpErrror * _Nonnull error) {
        [XKHudView showErrorMessage:error.message];
    }];
}
// 添加评论
- (void)postAddComment {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[NSString stringWithFormat:@"%tu", self.video.video.video_id] forKey:@"videoId"];
    [para setObject:[self.commentTF.text sensitiveFilter] forKey:@"content"];
    [XKHudView showLoadingTo:self animated:YES];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getAddCommentUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        self.commentTF.text = @"";
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            XKVideoCommentModel *comment = [XKVideoCommentModel yy_modelWithDictionary:dict];
            comment.videlAuthorId = self.video.user.user_id;
            [self.comments insertObject:comment atIndex:0];
            [self.commentsTableView reloadData];
            [self.commentsEmptyView hide];
            self.video.video.com_num += 1;
            self.titleLab.text = [NSString stringWithFormat:@"%tu条评论", self.video.video.com_num];
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoCommentView:didCommentCountChanged:)]) {
                [self.delegate videoCommentView:self didCommentCountChanged:self.video.video.com_num];
            }
        }
        [XKHudView hideHUDForView:self];
    } failure:^(XKHttpErrror * _Nonnull error) {
        [XKHudView hideHUDForView:self];
        [XKHudView showErrorMessage:error.message];
    }];
}
// 回复某个评论或者回复评论下的某个用户 回复评论时只需要评论ID 回复评论下的某个用户时需要评论ID和用户ID
- (void)postAddReplyWithCommentId:(NSString *) commentId userId:(NSString *) userId  {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[self.commentTF.text sensitiveFilter] forKey:@"content"];
    [para setObject:commentId forKey:@"commentId"];
    if (userId) {
        [para setObject:userId forKey:@"rUserId"];
    }
    [XKHudView showLoadingTo:self animated:YES];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getAddCommentReplyUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        self.commentTF.text = @"";
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            刷新回复列表
            XKVideoReplyModel *reply = [XKVideoReplyModel yy_modelWithDictionary:dict];
            self.currentComment.replyCount += 1;
            [self.currentComment.allReplys insertObject:reply atIndex:0];
            [self.replysTableView reloadData];
            [self.replysEmptyView hide];
//            刷新评论列表
            for (XKVideoCommentModel *comment in [self.comments copy]) {
                if ([comment.id isEqualToString:commentId]) {
                    comment.replyCount += 1;
                    [comment.previousReply insertObject:reply atIndex:0];
                    [self.commentsTableView reloadData];
                    [self.commentsEmptyView hide];
                    break;
                }
            }
        }
        [XKHudView hideHUDForView:self];
    } failure:^(XKHttpErrror * _Nonnull error) {
        [XKHudView hideHUDForView:self];
        [XKHudView showErrorMessage:error.message];
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.commentsTableView) {
        return self.comments.count;
    }
    return self.currentComment ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.commentsTableView) {
        XKVideoCommentModel *comment = self.comments[section];
        return comment.previousReply.count ? 2 : 1;
    }
    return self.currentComment.allReplys.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XKVideoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoCommentTableViewCell class]) forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        XKVideoCommentModel *comment;
        if (tableView == self.commentsTableView) {
            comment = self.comments[indexPath.section];
        } else {
            comment = self.currentComment;
        }
        [cell configCellWithCommentModel:comment];
        cell.userClickedBlock = ^(NSString *userId) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoCommentView:didClickedUser:)]) {
                [weakSelf.delegate videoCommentView:weakSelf didClickedUser:userId];
            }
        };
        cell.likeViewBlock = ^{
            [weakSelf postLikeCommentWithCommentId:comment.id];
        };
        return cell;
    } else {
        XKVideoSubCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSubCommentTableViewCell class]) forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        if (tableView == self.commentsTableView) {
            XKVideoCommentModel *comment = self.comments[indexPath.section];
            XKVideoReplyModel *reply = comment.previousReply[indexPath.row - 1];
            [cell configCellWithReplyModel:reply];
        } else {
            XKVideoReplyModel *reply = self.currentComment.allReplys[indexPath.row - 1];
            [cell configCellWithReplyModel:reply];
        }
        cell.userClickedBlock = ^(NSString *userId) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoCommentView:didClickedUser:)]) {
                [weakSelf.delegate videoCommentView:weakSelf didClickedUser:userId];
            }
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120.0;
    } else {
        return 40.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.commentsTableView) {
        XKVideoCommentModel *comment = self.comments[section];
        if (comment.previousReply.count) {
            return 15.0;
        } else {
            return 0.0;
        }
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.commentsTableView) {
        XKVideoCommentModel *comment = self.comments[section];
        if (comment.previousReply.count) {
            XKVideoCommentMoreTableViewCell *footer = [[XKVideoCommentMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XKVideoCommentMoreTableViewCell class])];
            XKVideoCommentModel *comment = self.comments[section];
            [footer configMoreLabelWithCount:comment.previousReply.count];
            footer.moreViewBlock = ^{
                [self showReplysWithComment:comment];
            };
            return footer;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.commentsTableView) {
        XKVideoCommentModel *comment = self.comments[indexPath.section];
        [self showReplysWithComment:comment];
    } else {
        if (indexPath.row == 0) {
//            回复某个评论
            self.commentToReply = self.currentComment;
            self.replyToReply = nil;
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"神评我来造~"];
            [placeholder addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, placeholder.length)];
            [placeholder addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, placeholder.length)];
            self.commentTF.attributedPlaceholder = placeholder;
        } else {
//            回复某个回复
            self.commentToReply = self.currentComment;
            self.replyToReply = self.currentComment.allReplys[indexPath.row - 1];
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复 %@：", self.replyToReply.creator.nickName]];
            [placeholder addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, placeholder.length)];
            [placeholder addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, placeholder.length)];
            self.commentTF.attributedPlaceholder = placeholder;
        }
        [self.commentTF becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 300) {
        return NO;
    }
    if ([string isEqualToString:@"@"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoCommentViewDidInputedAtCharacter:)]) {
            [self.delegate videoCommentViewDidInputedAtCharacter:self];
        }
        return NO;
    }
    return YES;
}

#pragma mark - getter setter

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
    }
    return _tapView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 465.0 * ScreenScale) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
        _containerView.backgroundColor = HEX_RGBA(0x000000, 0.75);
    }
    return _containerView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.alpha = 0.95;
    }
    return _effectView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.hidden = YES;
        [_backBtn setImage:IMG_NAME(@"xk_ic_video_display_comment_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = XKRegularFont(14.0);
        _titleLab.textColor = HEX_RGB(0x777777);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:IMG_NAME(@"xk_ic_video_display_comment_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)scrollViewContainerView {
    if (!_scrollViewContainerView) {
        _scrollViewContainerView = [[UIView alloc] init];
    }
    return _scrollViewContainerView;
}

- (UITableView *)commentsTableView {
    if (!_commentsTableView) {
        _commentsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _commentsTableView.delegate = self;
        _commentsTableView.dataSource = self;
        _commentsTableView.estimatedRowHeight = 120.0;
        _commentsTableView.rowHeight = UITableViewAutomaticDimension;
        [_commentsTableView registerClass:[XKVideoCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoCommentTableViewCell class])];
        [_commentsTableView registerClass:[XKVideoSubCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSubCommentTableViewCell class])];
        _commentsTableView.tableFooterView = [UIView new];
        _commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentsTableView.backgroundColor = [UIColor clearColor];
    }
    return _commentsTableView;
}

- (UIActivityIndicatorView *)commentsLoadingView {
    if (!_commentsLoadingView) {
        _commentsLoadingView = [[UIActivityIndicatorView alloc] init];
        _commentsLoadingView.tintColor = [UIColor whiteColor];
        _commentsLoadingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        _commentsLoadingView.hidden = YES;
    }
    return _commentsLoadingView;
}

- (UITableView *)replysTableView {
    if (!_replysTableView) {
        _replysTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _replysTableView.delegate = self;
        _replysTableView.dataSource = self;
        _replysTableView.estimatedRowHeight = 120.0;
        _replysTableView.rowHeight = UITableViewAutomaticDimension;
        [_replysTableView registerClass:[XKVideoCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoCommentTableViewCell class])];
        [_replysTableView registerClass:[XKVideoSubCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSubCommentTableViewCell class])];
        _replysTableView.tableFooterView = [UIView new];
        _replysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _replysTableView.backgroundColor = [UIColor clearColor];
    }
    return _replysTableView;
}

- (UIActivityIndicatorView *)replysLoadingView {
    if (!_replysLoadingView) {
        _replysLoadingView = [[UIActivityIndicatorView alloc] init];
        _replysLoadingView.tintColor = [UIColor whiteColor];
        _replysLoadingView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        _replysLoadingView.hidden = YES;
    }
    return _replysLoadingView;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = HEX_RGB(0x000000);
    }
    return _inputView;
}

- (UITextField *)commentTF {
    if (!_commentTF) {
        _commentTF = [[UITextField alloc] init];
        _commentTF.font = XKRegularFont(12.0);
        _commentTF.textColor = [UIColor whiteColor];
        _commentTF.tintColor = [UIColor whiteColor];
        _commentTF.backgroundColor = HEX_RGB(0x272727);
        _commentTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _commentTF.leftViewMode = UITextFieldViewModeAlways;
        _commentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _commentTF.layer.cornerRadius = 4.0;
        _commentTF.layer.masksToBounds = YES;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"神评我来造~"];
        [placeholder addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, placeholder.length)];
        [placeholder addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, placeholder.length)];
        _commentTF.attributedPlaceholder = placeholder;
        _commentTF.delegate = self;
    }
    return _commentTF;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.titleLabel.font = XKRegularFont(14.0);
        [_sendBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = HEX_RGB(0x5b5b5b);
        _sendBtn.layer.cornerRadius = 4.0;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

@end
