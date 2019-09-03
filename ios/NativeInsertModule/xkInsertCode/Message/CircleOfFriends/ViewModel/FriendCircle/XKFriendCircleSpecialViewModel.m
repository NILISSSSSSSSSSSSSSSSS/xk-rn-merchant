/*******************************************************************************
 # File        : XKFriendCircleSpecialViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleSpecialViewModel.h"
#import "XKFriendsTalkDateCell.h"
#import "XKFriendTalkDateModel.h"
#import "XKCommentInputView.h"
#import <IQKeyboardManager.h>
#import "XKFriendTalkReplyCell.h"
#import "XKFriendCircleFooterView.h"
#import "XKFriendTalkDetailController.h"
#import "XKSquareFriendsCricleTool.h"

static NSString *const normalTextCellId = @"normalTextCellId";
static NSString *const imgTextCellId = @"imgTextCellId";
static NSString *const replyCellId = @"replyCellId";

#define kMaxReply 2

@interface XKFriendCircleSpecialViewModel ()
/**<##>*/
@property(nonatomic, weak) BaseViewController *vc;
/**评论输入框*/
@property(nonatomic, strong) XKCommentInputView *replyView;
/**评论缓存*/
@property(nonatomic, strong) XKCommentInputInfo *commentInfo;
@end

@implementation XKFriendCircleSpecialViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefaultData];
    }
    return self;
}

- (void)createDefaultData {
   
}

- (void)dealloc {
    
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKFriendsTalkDateCell class] forCellReuseIdentifier:normalTextCellId];
    [tableView registerClass:[XKFriendsTalkDateCell class] forCellReuseIdentifier:imgTextCellId];
    [tableView registerClass:[XKFriendTalkReplyCell class] forCellReuseIdentifier:replyCellId];
    [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"emptyFooter"];
    [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
}

- (void)configVCToolBar:(BaseViewController *)vc {
    _vc = vc;
    _replyView = [XKCommentInputView inputView];
    _replyView.hidden = YES;
    _replyView.autoHidden = YES;
    _replyView.bottom = SCREEN_HEIGHT;
    [vc.view addSubview:_replyView];
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
    [self.replyView endEditing];
    [_replyView setOriginText:@""];
    [_replyView setAtUserName:@""];
}


/**请求列表*/
- (void)requestRefresh:(BOOL)isRefresh complete:(void (^)(id error,id data))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
        self.timeStamp = [XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
        params[@"pageTime"] = self.timeStamp;
    }
    if (self.isInsertPersonalVC) {
        params[@"limit"] = @(4);
    } else {
       [params setObject:@(self.limit) forKey:@"limit"];
    }
    
    params[@"rid"] =  self.userId;
    
    [self requestWithParams:params block:^(NSString *error, id data) {
        self.isFetchNet = YES;
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            NSDictionary *dataDic = [data xk_jsonToDic];
            if (dataDic == nil) {
                EXECUTE_BLOCK(complete,@"网络错误",nil);
                return ;
            }
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKFriendTalkDateModel class] json:dataDic[@"list"]];
            self.userInfo = [XKContactModel yy_modelWithJSON:dataDic[@"xkUserInfo"]];
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if (array.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [self.dataArray addObjectsFromArray:array];
            EXECUTE_BLOCK(complete,nil,array);
        }
    }];
}

- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleUserAlbum/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}

#pragma mark - 请求单条
- (void)updateItemForIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       XKFriendTalkModel *model = self.dataArray[indexPath.section];
                       NSMutableDictionary *params = [NSMutableDictionary dictionary];
                       params[@"did"] = model.did;
                       [self requestSingleWithParams:params block:^(NSString *error, NSString *data) {
                           if (error) {
                               [XKHudView showErrorMessage:error to:self.vc.view animated:YES];
                           } else {
                               XKFriendTalkModel *newModel = [XKFriendTalkDateModel yy_modelWithJSON:data];
                               newModel.did = params[@"did"];
                               newModel.singleImgWidth = model.singleImgWidth;
                               newModel.singleImgheight = model.singleImgheight;
                               __block NSInteger index = -1;
                               [self.dataArray enumerateObjectsUsingBlock:^(XKFriendTalkModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                   if ([obj.did isEqualToString:model.did]) {
                                       index = idx;
                                       *stop = YES;
                                   }
                               }];
                               if (index != -1) {
                                   [self.dataArray replaceObjectAtIndex:index withObject:newModel];
                               }
                               self.refreshTableView();
                           }
                       }];
                   });
}

- (void)requestSingleWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
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
    
    params[@"content"] = [self.commentInfo.content sensitiveFilter];
    if (self.commentInfo.isReply) {
        params[@"commentType"] = @"reply";
        params[@"replyUserId"] = self.commentInfo.replyId;
    } else {
        params[@"commentType"] = @"comment";
    }
    params[@"did"] = self.commentInfo.did;
    NSIndexPath *indexPath = self.commentInfo.indexPath;
    [XKHudView showLoadingTo:self.vc.view animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleComment/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        [self updateItemForIndexPath:indexPath];;
        [self cleanInput];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        [XKHudView showErrorMessage:error.message to:self.vc.view animated:YES];
    }];
}

#pragma mark - 直接评论
- (void)commentForTalk:(NSIndexPath *)indexPath {
    if (![self.commentInfo.indexPath isEqual:indexPath]) { // 是其他说说
        self.commentInfo.content = nil;
        self.commentInfo.isReply = NO;
    }
    XKFriendTalkModel *model = self.dataArray[indexPath.section];
    self.commentInfo.indexPath = indexPath;
    self.commentInfo.did = model.did;
    [_replyView setAtUserName:@""];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}

#pragma mark - 回复人
- (void)replyForUser:(FriendsCirclelCommentsItem *)comment indexPath:(NSIndexPath *)indexPath {
    if (![self.commentInfo.indexPath isEqual:indexPath]) { // 是其他说说
        self.commentInfo.content = nil;
        self.commentInfo.isReply = YES;
    } else {
        if (self.commentInfo.isReply == NO) { // 同一个说说 之前保存的是评论
            self.commentInfo.content = nil;
            self.commentInfo.isReply = YES;
        }
        if (![self.commentInfo.replyId isEqualToString:comment.userId]) { // 切换了回复人
            self.commentInfo.content = nil;
        }
    }
    XKFriendTalkModel *model = self.dataArray[indexPath.section];
    self.commentInfo.indexPath = indexPath;
    self.commentInfo.replyId = comment.userId;
    self.commentInfo.did = model.did;
    [_replyView setAtUserName:comment.user.displayName];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}

#pragma mark - 点赞
- (void)likeForTalk:(NSIndexPath *)indexPath {
    XKFriendTalkModel *model = self.dataArray[indexPath.section];
    __weak typeof(self) weakSelf = self;
    [XKHudView showLoadingTo:self.vc.view animated:YES];
    [XKSquareFriendsCricleTool requestLikeWithDid:model.did complete:^(NSString *error, BOOL status) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        if (error) {
            [XKHudView showErrorMessage:error to:self.vc.view animated:YES];
        } else {
            model.isLike = status;
            weakSelf.refreshTableView();
            [weakSelf updateItemForIndexPath:indexPath];
        }
    }];
}

#pragma mark - 代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKFriendTalkModel *model = self.dataArray[indexPath.section];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        NSString *cellIdx;
        if (model.msgType == XKFriendTalkMsgNormalTextType) {
            cellIdx = normalTextCellId;
        } else if (model.msgType == XKFriendTalkMsgImgType) {
            cellIdx = imgTextCellId;
        }
        //    else if (index == 3) {
        ////        cellIdx = shareTextCellId;
        //    }
        XKFriendsTalkDateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdx forIndexPath:indexPath];
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
        cell.mode = 1;
        cell.contentExistFold = YES;
        [cell setModel:model];
        [cell setCommentClickBlock:^(NSIndexPath *indexPath, NSString *atUserName, NSString *userId) {
            [weakSelf commentForTalk:indexPath];
        }];
        [cell setFavorClickBlock:^(NSIndexPath *indexPath) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [weakSelf likeForTalk:indexPath];
        }];
        [cell setGiftClickBlock:^(NSIndexPath *indexPath) {
            //
        }];
        [cell setRefreshBlock:^(NSIndexPath *indexPath) {
            [tableView reloadData];
        }];
        return cell;
    }
    
    XKFriendTalkReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCellId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    NSInteger replyIndex = indexPath.row - 1;
    if (replyIndex == 0 && model.likes.count == 0) {
        cell.totalView.xk_clipType = XKCornerClipTypeTopBoth;
    } else {
        cell.totalView.xk_clipType = XKCornerClipTypeNone;
    }
    if (replyIndex == 0 && model.comments.count != 0) {
        [cell hideSperate:NO];
    } else {
        [cell hideSperate:YES];
    }
    [cell setModel:model];
    [cell setUserClickBlock:^(NSIndexPath *indexPath, NSString *userId) {
        [XKGlobleCommonTool jumpUserInfoCenter:userId vc:weakSelf.vc];
    }];
//    [cell setCommentClickBlock:^(NSIndexPath *indexPath, FriendsCirclelCommentsItem *comment) {
//        [weakSelf replyForUser:comment indexPath:indexPath];
//    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && !self.isInsertPersonalVC) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XKFriendTalkModel *model = self.dataArray[indexPath.section];
        XKFriendTalkDetailController *vc = [XKFriendTalkDetailController new];
        vc.did = model.did;
        __weak typeof(self) weakSelf = self;
        [vc setDeleteClick:^(XKFriendTalkModel *talkModel) {
            [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
            weakSelf.refreshTableView();
        }];
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    } else {
        XKFriendTalkReplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self replyForUser:cell.comment indexPath:indexPath];
    }

}

#pragma mark - scrollView停止拖动

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.mj_offsetY < -120) {
        EXECUTE_BLOCK(self.needRequestRefresh);
    }
}

@end
