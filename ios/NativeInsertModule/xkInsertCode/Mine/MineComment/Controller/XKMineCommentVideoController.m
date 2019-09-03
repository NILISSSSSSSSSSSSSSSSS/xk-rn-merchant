/*******************************************************************************
 # File        : XKMineCommentVideoController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCommentVideoController.h"
#import "XKCommentForVideoModel.h"
#import "XKReplyForVideoModel.h"
#import "XKVideoDisplayMediator.h"

@interface XKMineCommentVideoController ()

@end

@implementation XKMineCommentVideoController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    
}

#pragma mark ----------------------------- 协议方法 ------------------------------
#pragma mark - 子类重写 进行请求
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void (^)(NSString *, NSArray *))complete {
    if (self.isShowReply) {
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/videoCommentRepliedMeList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKReplyForVideoModel class] json:dic[@"data"]];
            complete(nil,arr);
        } failure:^(XKHttpErrror *error) {
            complete(error.message,nil);
        }];

    } else {
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/videoMyCommentList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKCommentForVideoModel class] json:dic[@"data"]];
            complete(nil,arr);
        } failure:^(XKHttpErrror *error) {
             complete(error.message,nil);
        }];
    }
}

#pragma mark - 子类重写 帮cell赋值
- (void)refreshCell:(XKCommentCommonCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (self.isShowReply) {
        XKReplyForVideoModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.getDisplayTime;
        [cell.headImageView sd_setImageWithURL:kURL(model.creator.avatar) placeholderImage:kDefaultHeadImg];
        cell.desLabel.text = model.content;
        cell.nameLabel.text = model.creator.nickname;
        cell.userId = model.creator.userId;
        XKGoodsAndCommentView *comentView = (XKGoodsAndCommentView *)cell.diyView;
        [comentView.commentLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(model.comment.commenter.nickname).textColor(XKMainTypeColor);
            confer.text(@"：");
            confer.text(model.comment.content);
        }];
        comentView.goodsView.nameLabel.numberOfLines = 1;
        comentView.goodsView.infoLabel.numberOfLines = 2;
        [comentView.goodsView.imgView sd_setImageWithURL:kURL(model.comment.shortVideo.showPic) placeholderImage:kDefaultPlaceHolderImg];
        comentView.goodsView.nameLabel.text = [NSString stringWithFormat:@"@%@",model.comment.shortVideo.uploader.nickName];
        comentView.goodsView.nameLabel.font = XKRegularFont(12);
        comentView.goodsView.infoLabel.text = model.comment.shortVideo.describe;
        comentView.goodsView.showSmallImg = YES;
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
        
    } else {
        XKCommentForVideoModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.getDisplayTime?:@"-";
        [cell.headImageView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.desLabel.text = model.content;
        cell.nameLabel.text = model.commenter.nickname;
        XKGoodsView *videoView = (XKGoodsView *)cell.diyView;
        [videoView.imgView sd_setImageWithURL:kURL(model.shortVideo.showPic) placeholderImage:kDefaultPlaceHolderImg];
        videoView.showSmallImg = YES;
        videoView.nameLabel.text = [NSString stringWithFormat:@"%@",model.shortVideo.uploader.nickName];
        videoView.nameLabel.font = XKRegularFont(12);
        videoView.nameLabel.numberOfLines = 1;
        videoView.infoLabel.numberOfLines = 2;
        videoView.infoLabel.text = model.shortVideo.describe;
        
        cell.imgsShowAllStatus = model.showAllImg;
        cell.imgsArray = model.imgsArray;
        cell.userId = model.commenter.userId;
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
    }
}
#pragma mark ----------------------------- 其他方法 ------------------------------
#pragma mark - 小视频详情
- (void)diyViewClick:(NSIndexPath *)indexPath {
    NSString *videoID;
    if (self.isShowReply) {
        XKReplyForVideoModel *reply = self.dataArray[indexPath.row];
        videoID = reply.comment.shortVideo.videoId;
    } else {
        XKCommentForVideoModel *comment = self.dataArray[indexPath.row];
        videoID = comment.shortVideo.videoId;
    }
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoId:videoID];
    
}

- (void)dealCellClick:(NSIndexPath *)indexPath {
    
}

- (void)reply:(NSIndexPath *)indexPath {
    XKReplyForVideoModel *reply = self.dataArray[indexPath.row];
    if (![self.commentInfo.did isEqualToString:reply.replyId]) { // 回复的是其他评论
        self.commentInfo.content = nil;
    }
    self.commentInfo.indexPath = indexPath;
    [self.replyView setPlaceHolderText:[NSString stringWithFormat:@"回复@%@",reply.creator.nickname]];
    [self.replyView setOriginText:self.commentInfo.content];
    [self.replyView beginEditing];
}

- (void)sendComment {
    XKReplyForVideoModel *reply = self.dataArray[self.commentInfo.indexPath.row];
    [KEY_WINDOW endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"commentId"] = reply.comment.commentId;
    params[@"content"] = [self.commentInfo.content sensitiveFilter];
    params[@"rUserId"] = reply.creator.userId;
    [XKHudView showLoadingTo:self.view animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/videoCommentReplyCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.view animated:YES];
        [self requestRefresh];
        [self cleanInput];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
    }];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
