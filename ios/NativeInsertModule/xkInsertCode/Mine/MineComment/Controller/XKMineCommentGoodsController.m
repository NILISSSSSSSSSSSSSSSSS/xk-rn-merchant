/*******************************************************************************
 # File        : XKMineCommentGoodsController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCommentGoodsController.h"
#import "XKGoodsView.h"
#import "XKGoodsAndCommentView.h"
#import "XKCommentDetailBaseController.h"
#import "XKCommentForGoodsModel.h"
#import "XKReplyForGoodsModel.h"
#import "XKMallGoodsDetailViewController.h"

@interface XKMineCommentGoodsController ()

@end

@implementation XKMineCommentGoodsController

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
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/mallCommentRepliedMeList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[XKReplyForGoodsModel class] json:dic[@"data"]];
            complete(nil,arr);
        } failure:^(XKHttpErrror *error) {
            complete(error.message,nil);
        }];
    } else {
        [HTTPClient getEncryptRequestWithURLString:@"im/ua/mallMyGoodsCommentList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
            NSDictionary *dic = [responseObject xk_jsonToDic];
            NSArray<XKCommentForGoodsModel *> *arr = [NSArray yy_modelArrayWithClass:[XKCommentForGoodsModel class] json:dic[@"data"]];
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
        XKReplyForGoodsModel *model = self.dataArray[indexPath.row];
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
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
        XKGoodsInfo *goods = model.comment.goods;
        [comentView.goodsView.imgView sd_setImageWithURL:kURL(goods.mainPic) placeholderImage:kDefaultHeadImg];
        comentView.goodsView.nameLabel.text = goods.name;
        comentView.goodsView.nameLabel.numberOfLines = 2;
        comentView.goodsView.infoLabel.numberOfLines = 1;
        comentView.goodsView.infoLabel.text = [NSString stringWithFormat:@"%@ * %@",goods.skuValue,goods.count];
        

    } else {
        XKCommentForGoodsModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.getDisplayTime ? :@"-";
        [cell.headImageView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.desLabel.text = model.content;
        cell.nameLabel.text = model.commenter.nickname;
        cell.userId = model.commenter.userId;
        cell.imgsShowAllStatus = model.showAllImg;
        cell.imgsArray = model.imgsArray;
        XKGoodsView *diyView = (XKGoodsView *)cell.diyView;
        diyView.nameLabel.numberOfLines = 2;
        diyView.infoLabel.numberOfLines = 1;
        [diyView.imgView sd_setImageWithURL:kURL(model.goods.mainPic) placeholderImage:kDefaultPlaceHolderImg];
        diyView.nameLabel.text = model.goods.name;
        diyView.infoLabel.text = [NSString stringWithFormat:@"%@ * %@",model.goods.skuValue,model.goods.count];
        cell.indexPath = indexPath;
        [cell setDiyViewClick:^(NSIndexPath *indexPath) {
            [weakSelf diyViewClick:indexPath];
        }];
    }
}


- (void)dealCellClick:(NSIndexPath *)indexPath {
    XKCommentDetailBaseController *vc = [[XKCommentDetailBaseController alloc] init];
    NSString *commentId;
    if (self.isShowReply) {
        XKReplyForGoodsModel *reply = self.dataArray[indexPath.row];
        commentId = reply.comment.commentId;
    } else {
        XKCommentBaseInfo *comment = self.dataArray[indexPath.row];
        commentId = comment.commentId;
    }
    vc.commentId = commentId;
    vc.detailType = XKCommentDetailTypeGoods;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 商品详情
- (void)diyViewClick:(NSIndexPath *)indexPath {
    NSString *goodsId;
    if (self.isShowReply) {
        XKReplyForGoodsModel *reply = self.dataArray[indexPath.row];
        goodsId = reply.comment.goods.goodsId;
    } else {
        XKCommentForGoodsModel *comment = self.dataArray[indexPath.row];
        goodsId = comment.goods.goodsId;
    }
    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
    detail.goodsId = goodsId;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)reply:(NSIndexPath *)indexPath {
    XKReplyForGoodsModel *reply = self.dataArray[indexPath.row];
    if (![self.commentInfo.did isEqualToString:reply.replyId]) { // 回复的是其他评论
        self.commentInfo.content = nil;
    }
    self.commentInfo.indexPath = indexPath;
    [self.replyView setPlaceHolderText:[NSString stringWithFormat:@"回复@%@",reply.creator.nickname]];
    [self.replyView setOriginText:self.commentInfo.content];
    [self.replyView beginEditing];
}

- (void)sendComment {
    XKReplyForGoodsModel *reply = self.dataArray[self.commentInfo.indexPath.row];
    [KEY_WINDOW endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"commentId"] = reply.comment.commentId;
    params[@"content"] = [self.commentInfo.content sensitiveFilter];
    params[@"rUserId"] = reply.creator.userId;
    [XKHudView showLoadingTo:self.view animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/mallGoodsCommentReplyCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.view animated:YES];
        [self requestRefresh];
        [self cleanInput];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.view animated:YES];
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------


#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
