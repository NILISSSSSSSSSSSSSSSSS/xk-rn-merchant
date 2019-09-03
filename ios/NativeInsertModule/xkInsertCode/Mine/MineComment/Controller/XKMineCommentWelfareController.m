/*******************************************************************************
 # File        : XKMineCommentWelfareController.m
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

#import "XKMineCommentWelfareController.h"
#import "XKCommentForWelfareModel.h"
#import "XKReplyForWelfareModel.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKCommentDetailBaseController.h"

@interface XKMineCommentWelfareController ()

@end

@implementation XKMineCommentWelfareController

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
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/jCommentRepliedMeList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKReplyForWelfareModel class] json:dic[@"data"]];
            complete(nil,arr);
        } failure:^(XKHttpErrror *error) {
            complete(error.message,nil);
        }];
        
    } else {
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/jMyGoodsCommentList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKCommentForWelfareModel class] json:dic[@"data"]];
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
        XKReplyForWelfareModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.getDisplayTime;
        [cell.headImageView sd_setImageWithURL:kURL(model.creator.avatar) placeholderImage:kDefaultHeadImg];
        cell.desLabel.text = model.content;
        cell.nameLabel.text = model.creator.nickname;
        cell.userId = model.creator.userId;

        XKGoodsAndCommentView *commentView = (XKGoodsAndCommentView *)cell.diyView;
        [commentView.commentLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(model.comment.commenter.nickname).textColor(XKMainTypeColor);
            confer.text(@"：");
            confer.text(model.comment.content);
        }];
        
        [commentView.goodsView.imgView sd_setImageWithURL:kURL(@" ") placeholderImage:kDefaultPlaceHolderImg];
        commentView.goodsView.nameLabel.text = model.comment.goods.name;
        commentView.goodsView.nameLabel.numberOfLines = 2;
        [commentView.goodsView.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"开奖期数：  %@期",model.comment.goods.nper]);
        }];
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
        
    } else {

        XKCommentForWelfareModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.getDisplayTime;
        [cell.headImageView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.desLabel.text = model.content;
        cell.nameLabel.text = model.commenter.nickname;
        XKGoodsView *welfareView = (XKGoodsView *)cell.diyView;
        [welfareView.imgView sd_setImageWithURL:kURL(@" ") placeholderImage:kDefaultPlaceHolderImg];
        welfareView.nameLabel.text = model.goods.name;
        welfareView.nameLabel.numberOfLines = 2;
        [welfareView.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"开奖期数：  %@期",model.goods.nper]);
        }];
        cell.userId = model.commenter.userId;
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
    }
}

#pragma mark ----------------------------- 其他方法 ------------------------------

- (void)dealCellClick:(NSIndexPath *)indexPath {
    XKCommentDetailBaseController *vc = [[XKCommentDetailBaseController alloc] init];
    NSString *commentId;
    if (self.isShowReply) {
        XKReplyForWelfareModel *reply = self.dataArray[indexPath.row];
        commentId = reply.comment.commentId;
    } else {
        XKCommentForWelfareModel *comment = self.dataArray[indexPath.row];
        commentId = comment.commentId;
    }
    vc.commentId = commentId;
    vc.detailType = XKCommentDetailTypeWelfare;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 商品详情
- (void)diyViewClick:(NSIndexPath *)indexPath {
    NSString *goodsId;
    if (self.isShowReply) {
        XKReplyForWelfareModel *reply = self.dataArray[indexPath.row];
        goodsId = reply.comment.commentId;
    } else {
        XKCommentForWelfareModel *comment = self.dataArray[indexPath.row];
        goodsId = comment.commentId;
    }
    XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
    detail.goodsId = goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)reply:(NSIndexPath *)indexPath {
   XKReplyForWelfareModel *reply = self.dataArray[indexPath.row];
    if (![self.commentInfo.did isEqualToString:reply.replyId]) { // 回复的是其他评论
        self.commentInfo.content = nil;
    }
    self.commentInfo.indexPath = indexPath;
    [self.replyView setPlaceHolderText:[NSString stringWithFormat:@"回复@%@",reply.creator.nickname]];
    [self.replyView setOriginText:self.commentInfo.content];
    [self.replyView beginEditing];
}

- (void)sendComment {
    XKReplyForWelfareModel *reply = self.dataArray[self.commentInfo.indexPath.row];
    [KEY_WINDOW endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"commentId"] = reply.comment.commentId;
    params[@"content"] = [self.commentInfo.content sensitiveFilter];
    params[@"rUserId"] = reply.creator.userId;
    [XKHudView showLoadingTo:self.view animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/jGoodsCommentReplyCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
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
