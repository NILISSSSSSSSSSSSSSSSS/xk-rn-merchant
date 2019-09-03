/*******************************************************************************
 # File        : XKFriendCircleDetailViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleDetailViewModel.h"
#import "XKFriendTalkModel.h"
#import "XKCommentInputView.h"
#import <IQKeyboardManager.h>
#import "XKFriendTalkReplyCell.h"
#import "XKFriendCircleFooterView.h"
#import "XKFriendsTalkCommonRLCell.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKSquareFriendsCricleTool.h"
#import "XKGiftViewManager.h"

static NSString *const normalTextCellId = @"normalTextCellId";
static NSString *const imgTextCellId = @"imgTextCellId";
static NSString *const replyCellId = @"replyCellId";

@interface XKFriendCircleDetailViewModel () {
  NSMutableDictionary *_cellHightDict;
}
/**<##>*/
@property(nonatomic, weak) BaseViewController *vc;
/**评论输入框*/
@property(nonatomic, strong) XKCommentInputView *replyView;
/**评论缓存*/
@property(nonatomic, strong) XKCommentInputInfo *commentInfo;
@end

@implementation XKFriendCircleDetailViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createDefaultData];
  }
  return self;
}

- (void)dealloc {
  
}


- (void)createDefaultData {
  _cellHightDict = [NSMutableDictionary dictionary];
}

- (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[XKFriendsTalkCommonRLCell class] forCellReuseIdentifier:normalTextCellId];
  [tableView registerClass:[XKFriendsTalkCommonRLCell class] forCellReuseIdentifier:imgTextCellId];
  
  [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"emptyFooter"];
  [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
}

- (void)configVCToolBar:(BaseViewController *)vc {
  _vc = vc;
  _replyView = [XKCommentInputView inputView];
  _replyView.autoHidden = NO;
  _replyView.hidden = NO;
  _replyView.bottom = SCREEN_HEIGHT;
  
  [self cleanInput];
  __weak typeof(self) weakSelf = self;
  _replyView.sureClick = ^(NSString *text) {
    weakSelf.commentInfo.content = text;
    [weakSelf reqeustComment];
  };
  [_replyView setTextChange:^(NSString *text) {
    weakSelf.commentInfo.content = text;
  }];
}

- (void)cleanInput {
  self.commentInfo = [XKCommentInputInfo new];
  self.commentInfo.did = self.did;
  [self.replyView endEditing];
  [_replyView setOriginText:@""];
  [_replyView setAtUserName:@""];
}

- (void)dealToolBar {
  XKFriendTalkModel *model = self.dataArray.firstObject;
  if (model.isStrange) {
    [_replyView removeFromSuperview];
    _replyView = nil;
  } else {
    [_vc.view addSubview:_replyView];
  }
}

/**请求*/
- (void)requestCompleteBlock:(void (^)(id error,id data))completeBlock  {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  params[@"did"] = self.did;
  [self requestWithParams:params block:^(NSString *error, NSString *data) {
    if (error) {
      EXECUTE_BLOCK(completeBlock,error,nil);
    } else {
      self.replyView.hidden = NO;
      XKFriendTalkModel *model = [XKFriendTalkModel yy_modelWithJSON:data];
      XKFriendTalkModel *oldModel = self.dataArray.firstObject;
      if (oldModel) {
        model.singleImgheight = oldModel.singleImgheight;
        model.singleImgWidth = oldModel.singleImgWidth;
      }
      model.did = self.did;
      [self.dataArray removeAllObjects];
      [self.dataArray addObject:model];
      [self dealToolBar];
      EXECUTE_BLOCK(completeBlock,nil,model);
    }
  }];
}

- (void)updateDetail {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                 ^{
                   [self requestCompleteBlock:^(id error, id data) {
                     EXECUTE_BLOCK(self.refreshTableView);
                   }];
                 });
}

- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleDetail/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    EXECUTE_BLOCK(block,nil,responseObject);
  } failure:^(XKHttpErrror *error) {
    EXECUTE_BLOCK(block,error.message,nil);
  }];
}

#pragma mark - 回复请求
- (void)reqeustComment {
  [KEY_WINDOW endEditing:YES];
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"did"] = self.did;
  params[@"content"] = [self.commentInfo.content sensitiveFilter];
  if (self.commentInfo.isReply) {
    params[@"commentType"] = @"reply";
    params[@"replyUserId"] = self.commentInfo.replyId;
  } else {
    params[@"commentType"] = @"comment";
  }
  [XKHudView showLoadingTo:self.vc.containView animated:YES];
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleComment/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    self.infoChange = YES;
    [XKHudView hideHUDForView:self.vc.containView animated:YES];
    [self updateDetail];
    [self cleanInput];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.vc.containView animated:YES];
    [XKHudView showErrorMessage:error.message to:self.vc.containView animated:YES];
  }];
}

#pragma mark - 直接评论
- (void)commentForTalk {
  if (self.commentInfo.isReply == YES) { // 之前是回复 清空
    self.commentInfo.content = nil;
    self.commentInfo.isReply = NO;
  }
  [_replyView setAtUserName:@""];
  [_replyView setOriginText:self.commentInfo.content];
  [_replyView beginEditing];
}

#pragma mark - 回复人
- (void)replyForUser:(FriendsCirclelCommentsItem *)comment {
  if (self.commentInfo.isReply == NO) { // 之前是回复 清空
    self.commentInfo.content = nil;
    self.commentInfo.isReply = YES;
  }
  if (![self.commentInfo.replyId isEqualToString:comment.userId]) {
    self.commentInfo.content = nil;
  }
  self.commentInfo.replyId = comment.userId;
  [_replyView setAtUserName:comment.user.displayName];
  [_replyView setOriginText:self.commentInfo.content];
  [_replyView beginEditing];
}

#pragma mark - 点赞
- (void)likeForTalk {
  XKFriendTalkModel *model = self.dataArray.firstObject;
  __weak typeof(self) weakSelf = self;
  [XKHudView showLoadingTo:self.vc.containView animated:YES];
  [XKSquareFriendsCricleTool requestLikeWithDid:self.did complete:^(NSString *error, BOOL status) {
    [XKHudView hideHUDForView:self.vc.containView animated:YES];
    if (error) {
      [XKHudView showErrorMessage:error to:self.vc.containView animated:YES];
    } else {
      weakSelf.infoChange = YES;
      model.isLike = status;
      weakSelf.refreshTableView();
      [weakSelf updateDetail];
    }
  }];
}

#pragma mark - 礼物
- (void)giftForTalk {
  XKFriendTalkModel *model = self.dataArray.firstObject;
  __weak typeof(self) weakSelf = self;
  XKGiftViewManager *manager = [[XKGiftViewManager alloc] init];
  [manager showFriendsCycleGiftsViewWhitTargetUserId:model.userId friendsCycleId:model.did succeedBlock:^{
    NSLog(@"朋友圈送礼物成功");
    [weakSelf updateDetail];
  } failedBlock:^{
    NSLog(@"朋友圈送礼物失败");
  }];
}

#pragma mark - 删除
- (void)deleteTalk {
  __weak typeof(self) weakSelf = self;
  [XKAlertView showCommonAlertViewWithTitle:@"温馨提示" message:@"确定删除此条可友圈？" leftText:@"取消" rightText:@"确定" leftBlock:nil rightBlock:^{
    [XKHudView showLoadingTo:self.vc.view animated:YES];
    [self requestDelete:self.did Complete:^(NSString *err, id data) {
      [XKHudView hideHUDForView:self.vc.view animated:YES];
      if (err) {
        [XKHudView showErrorMessage:err to:weakSelf.vc.view animated:YES];
      } else {
        EXECUTE_BLOCK(weakSelf.deleteClick);
      }
    }];
  } textAlignment:NSTextAlignmentCenter];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  XKFriendTalkModel *model = self.dataArray[section];
  return model.comments.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  XKFriendTalkModel *model = self.dataArray[section];
  if (model.comments.count > 0) {
    return 24;
  }
  return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XKFriendTalkModel *model = self.dataArray[indexPath.section];
  __weak typeof(self) weakSelf = self;
  if (indexPath.row == 0) {
    NSString *cellIdx = @" ";
    if (model.msgType == XKFriendTalkMsgNormalTextType) {
      cellIdx = normalTextCellId;
    } else if (model.msgType == XKFriendTalkMsgImgType) {
      cellIdx = imgTextCellId;
    }
    //    else if (index == 3) {
    ////        cellIdx = shareTextCellId;
    //    }
    XKFriendsTalkCommonRLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdx forIndexPath:indexPath];
    if (indexPath.section == 0) {
      cell.totoalView.xk_clipType = XKCornerClipTypeTopBoth;
      if (model.comments.count == 0 && self.dataArray.count == 1) {
        cell.totoalView.xk_clipType = XKCornerClipTypeAllCorners;
      }
    } else if (indexPath.section != self.dataArray.count - 1) { // 不是最后一个
      cell.totoalView.xk_clipType = XKCornerClipTypeNone;
    } else { // 最后一个
      if (model.comments.count == 0) {
        cell.totoalView.xk_clipType = XKCornerClipTypeBottomBoth;
      } else {
        cell.totoalView.xk_clipType = XKCornerClipTypeNone;
      }
    }
    
    cell.indexPath = indexPath;
    cell.mode = 0;
    cell.contentExistFold = NO;
    [cell setModel:model];
    [cell setCommentClickBlock:^(NSIndexPath *indexPath, NSString *atUserName, NSString *userId) {
      [weakSelf commentForTalk];
    }];
    [cell setFavorClickBlock:^(NSIndexPath *indexPath) {
      [[UIApplication sharedApplication].keyWindow endEditing:YES];
      [weakSelf likeForTalk];
    }];
    [cell setGiftClickBlock:^(NSIndexPath *indexPath) {
      [weakSelf giftForTalk];
    }];
    [cell setRefreshBlock:^(NSIndexPath *indexPath) {
      [tableView reloadData];
    }];
    [cell setDeleteClickBlock:^(NSIndexPath *indexPath) {
      [weakSelf deleteTalk];
    }];
    return cell;
  }
  
  
  XKFriendTalkReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCellId];
  if (cell == nil) {
    cell = [[XKFriendTalkReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyCellId];
    cell.shortCell = YES;
  }
  
  cell.indexPath = indexPath;
  NSInteger replyIndex = indexPath.row - 1;
  if (replyIndex == 0 && model.likes.count == 0) {
    cell.totalView.xk_clipType = XKCornerClipTypeTopBoth;
  } else {
    cell.totalView.xk_clipType = XKCornerClipTypeNone;
  }
  if (replyIndex == 0 && model.likes.count != 0) {
    [cell hideSperate:NO];
  } else {
    [cell hideSperate:YES];
  }
  [cell setModel:model];
  [cell setUserClickBlock:^(NSIndexPath *indexPath, NSString *userId) {
    [XKGlobleCommonTool jumpUserInfoCenter:userId vc:weakSelf.vc];
  }];
  //    [cell setCommentClickBlock:^(NSIndexPath *indexPath, FriendsCirclelCommentsItem *comment) {
  //        [weakSelf replyForUser:comment];
  //    }];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 10;
  }
  return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  XKFriendCircleFooterView *footerView;
  footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"emptyFooter"];
  if(!footerView){
    footerView = [[XKFriendCircleFooterView alloc] initWithReuseIdentifier:@"emptyFooter"];
    
    footerView.shortFooter = YES;
    footerView.label.hidden = YES;
  }
  footerView.containView.xk_clipType = XKCornerClipTypeBottomBoth;
  return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XKFriendTalkModel *model = self.dataArray.firstObject;
  if (model.isStrange) {
    return;
  }
  if (indexPath.row != 0) {
    XKFriendTalkReplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self replyForUser:cell.comment];
  }
}

@end

