/*******************************************************************************
 # File        : XKCommentDetailBaseController.m
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

#import "XKCommentDetailBaseController.h"
#import "XKCommentDetailInfoCell.h"
#import "XKUserCommentCell.h"
#import "XKCommentDetailBaseViewModel.h"
#import "XKCommentInputView.h"
#import "XKCommentForShopsModel.h"
#import "XKCommentForWelfareModel.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKTradingAreaGoodsDetailViewController.h"
#import "XKWelfareGoodsDetailViewController.h"

@interface XKCommentDetailBaseController () <UITableViewDelegate, UITableViewDataSource>
/***/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) XKCommentDetailBaseViewModel *viewModel;
/**评论输入框*/
@property(nonatomic, strong) XKCommentInputView *replyView;
/**评论缓存*/
@property(nonatomic, strong) XKCommentInputInfo *commentInfo;

@end

@implementation XKCommentDetailBaseController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createSuperDefaultData];
    // 初始化界面
    [self createSuperUI];
    //
    [self requestDetailNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {
    _viewModel = [XKCommentDetailBaseViewModel new];
    _viewModel.commentId = self.commentId;
    _viewModel.detailType = self.detailType;
}

#pragma mark - 初始化界面
- (void)createSuperUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"评价详情" WithColor:[UIColor whiteColor]];
    self.containView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self createTableView];
    [self configVCToolBar];
}

- (void)configVCToolBar {
    _replyView = [XKCommentInputView inputView];
    _replyView.autoHidden = YES;
    _replyView.hidden = YES;
    _replyView.bottom = SCREEN_HEIGHT;
    [self.view addSubview:_replyView];
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

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.containView.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    __weak typeof(self) weakSelf = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requesListIsRefresh:NO];
    }];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerClass:[XKCommentDetailInfoCell class] forCellReuseIdentifier:@"info"];
    [self.tableView registerClass:[XKUserCommentCell class] forCellReuseIdentifier:@"comment"];
}
#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestDetailNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    [self.viewModel requestDetailInfoComplete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.containView];
        if (error) {
            [XKHudView showErrorMessage:error to:self.containView animated:YES];
        } else {
            [self requesListIsRefresh:YES];
        }
        [self.tableView reloadData];
    }];
}

- (void)requesListIsRefresh:(BOOL)refresh {
    [self.viewModel requestIsRefresh:refresh complete:^(NSString *error, id data) {
        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.commentArray];
        if (error) {
            [XKHudView showErrorMessage:@"请求评论列表失败" to:self.containView  animated:YES];
        } else {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 回复请求
- (void)reqeustComment {
    [KEY_WINDOW endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"commentId"] = self.commentId;
    params[@"content"] = [self.commentInfo.content sensitiveFilter];
    if (self.commentInfo.isReply) {
        params[@"rUserId"] = self.commentInfo.replyId;
    } else {
    }
    [XKHudView showLoadingTo:self.containView animated:YES];
 
    [HTTPClient getEncryptRequestWithURLString:[self.viewModel getReplyUrl] timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [self updateList];
        [self cleanInput];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}

- (void)updateList {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       [self requesListIsRefresh:YES];
                   });

}

#pragma mark - 操作逻辑

#pragma mark - 评论
- (void)commentForTotal {
    if (self.commentInfo.isReply == YES) { // 之前是回复 清空
        self.commentInfo.content = nil;
        self.commentInfo.isReply = NO;
    }
    [_replyView setPlaceHolderText:@"神评我来造~"];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}

#pragma mark - 回复人
- (void)replyForUser:(XKReplyBaseInfo *)reply {
    if (self.commentInfo.isReply == NO) { // 之前是回复 清空
        self.commentInfo.content = nil;
        self.commentInfo.isReply = YES;
    }
    if (![self.commentInfo.replyId isEqualToString:reply.creator.userId]) {
        self.commentInfo.content = nil;
    }
    self.commentInfo.replyId = reply.creator.userId;
    [_replyView setPlaceHolderText:[NSString stringWithFormat:@"回复@%@",reply.creator.nickname]];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}


#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.detailInfo == nil) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.viewModel.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        XKCommentDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
        XKCommentBaseInfo *detailInfo = self.viewModel.detailInfo;
        [cell setImgsArray:self.viewModel.detailInfo.imgsArray];
        [cell.headImageView sd_setImageWithURL:kURL(detailInfo.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.headImageView.userInteractionEnabled = YES;
        [cell bk_whenTapped:^{
            [XKGlobleCommonTool jumpUserInfoCenter:detailInfo.commenter.userId vc:weakSelf.getCurrentUIVC];
        }];
        cell.nameLabel.text = detailInfo.commenter.displayName;
        cell.timeLabel.text = detailInfo.getDisplayTime;
        cell.desLabel.text = detailInfo.content;
        cell.score = detailInfo.score;
        if (self.detailType == XKCommentDetailTypeWelfare) {
            [cell hideStar];
        }
        cell.indexPath = indexPath;
        [self updateInfoView:cell model:self.viewModel.detailInfo];
        return cell;
    } else {
        XKUserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
        cell.replyInfo = self.viewModel.commentArray[indexPath.row];
        if (indexPath.section != 0 &&  indexPath.row == 2) {
            cell.xk_openClip = YES;
            cell.xk_radius = 6;
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
        }
        return cell;
    }
}

- (void)updateInfoView:(XKCommentDetailInfoCell *)cell model:(id)model {
    if (self.detailType == XKCommentDetailTypeGoods) {
        XKCommentForGoodsModel *goodsInfo = (XKCommentForGoodsModel *)model;
        XKGoodsView *infoView = cell.infoView;
        cell.shopComment = goodsInfo.mallReply.content.length != 0 ? [NSString stringWithFormat:@"商家回复：%@",goodsInfo.mallReply.content] : nil;
        [infoView.imgView sd_setImageWithURL:kURL(goodsInfo.goods.mainPic) placeholderImage:kDefaultPlaceHolderImg];
        infoView.nameLabel.text = goodsInfo.goods.name;
        [infoView.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"价格：").font(XKRegularFont(12)).textColor(HEX_RGB(0x777777));
            confer.text(@"￥").font(XKRegularFont(12)).textColor(XKMainRedColor);
            confer.text(goodsInfo.goods.price).font(XKRegularFont(12)).textColor(XKMainRedColor);
        }];
        [cell.infoView bk_whenTapped:^{
            XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
            detail.goodsId = goodsInfo.goods.goodsId;
            [self.navigationController pushViewController:detail animated:YES];
        }];
    } else if (self.detailType == XKCommentDetailTypeCicle) {
        XKCommentForShopsModel *goodsInfo = (XKCommentForShopsModel *)model;
        XKGoodsView *infoView = cell.infoView;
        cell.shopComment = goodsInfo.shopReplier.content.length != 0 ? [NSString stringWithFormat:@"商家回复：%@",goodsInfo.shopReplier.content] : nil;
        [infoView.imgView sd_setImageWithURL:kURL(goodsInfo.goods.mainPic) placeholderImage:kDefaultPlaceHolderImg];
        infoView.nameLabel.text = goodsInfo.goods.name;
        [infoView.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"价格：").font(XKRegularFont(12)).textColor(HEX_RGB(0x777777));
            confer.text(@"￥").font(XKRegularFont(12)).textColor(XKMainRedColor);
            confer.text(goodsInfo.goods.price).font(XKRegularFont(12)).textColor(XKMainRedColor);
        }];
        [cell.infoView bk_whenTapped:^{
            XKTradingAreaGoodsDetailViewController *vc = [XKTradingAreaGoodsDetailViewController new];
            vc.goodsId = goodsInfo.goods.goodsId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }  else if (self.detailType == XKCommentDetailTypeWelfare) {
        XKCommentForWelfareModel *goodsInfo = (XKCommentForWelfareModel *)model;
        XKGoodsView *infoView = cell.infoView;
   
        [infoView.imgView sd_setImageWithURL:kURL(goodsInfo.goods.mainPic) placeholderImage:kDefaultPlaceHolderImg];
        infoView.nameLabel.text = goodsInfo.goods.name;
        [infoView.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"开奖期数：  %@期",goodsInfo.goods.nper]);
        }];
        [cell.infoView bk_whenTapped:^{
            XKWelfareGoodsDetailViewController *detail = [XKWelfareGoodsDetailViewController new];
            detail.goodsId = goodsInfo.goods.goodsId;
            [self.navigationController pushViewController:detail animated:YES];
        }];
    }
}


#pragma mark - cell 点击事件 处理选择状态
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    XKReplyBaseInfo *info = self.viewModel.commentArray[indexPath.row];
    [self replyForUser:info];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    __weak typeof(self) weakSelf = self;
    UIView *head = [[UIView alloc] init];
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.font = XKRegularFont(14);
    label.text = @"   全部评论";

    label.xk_openClip = YES;
    label.xk_radius = 8;
    label.xk_clipType = XKCornerClipTypeTopBoth;
    [head addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(head);
    }];
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.textColor = RGBGRAY(51);
    commentLabel.text = @"点评";
    commentLabel.font = XKRegularFont(12);
    commentLabel.textAlignment = NSTextAlignmentCenter;
    [head addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(head);
        make.width.equalTo(@60);
        make.right.equalTo(head.mas_right);
    }];
    commentLabel.userInteractionEnabled = YES;
    [commentLabel bk_whenTapped:^{
        [weakSelf commentForTotal];
    }];
    
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
