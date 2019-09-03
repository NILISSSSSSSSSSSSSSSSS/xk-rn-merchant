/*******************************************************************************
 # File        : XKMineCommentBaseController.m
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

#import "XKMineCommentBaseController.h"
#import "XKCommentCommonCell.h"
#import <RZColorful.h>
#import "UIView+XKCornerRadius.h"
#import "XKEmptyPlaceView.h"
#import "ProjectEnum.h"
#import "XKCommentReplyCell.h"
#import "XKCommentBaseInfo.h"
#import "XKMineCommentInputController.h"


@interface XKMineCommentBaseController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *_estimatedRowHeightCacheLeft;
    NSMutableDictionary *_estimatedRowHeightCacheRight;
    BOOL _neverRequestLeft;
    BOOL _neverRequestRight;
}
/**segment*/
@property(nonatomic, strong) UISegmentedControl *segment;
/**tableView*/
@property(nonatomic, strong) UITableView *tableViewLeft;
/**tableView*/
@property(nonatomic, strong) UITableView *tableViewRight;
/**无数据框*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyViewLeft;
/**无数据框*/
@property(nonatomic, strong) XKEmptyPlaceView *emptyViewRight;
/**当前tableView*/
@property(nonatomic, strong) UITableView *tableView;

/**请求页数*/
@property(nonatomic, assign) NSInteger pageOffsetLeft;
@property(nonatomic, assign) NSInteger pageOffsetRight;
/**请求条数*/
@property(nonatomic, assign) NSInteger pageSize;

@end

@implementation XKMineCommentBaseController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    _estimatedRowHeightCacheLeft = [NSMutableDictionary dictionary];
    _estimatedRowHeightCacheRight = [NSMutableDictionary dictionary];
    // 初始化界面
    [self createSuperUI];
    // 初始化默认数据
    [self createSuperDefaultData];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
    [_replyView removeFromSuperview];
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {
    _pageOffsetLeft = 1;
    _pageOffsetRight = 1;
    _pageSize = 5;
    _neverRequestLeft = YES;
    _neverRequestRight = YES;
    self.segmentIdnex = 0;
}

#pragma mark - 初始化界面
- (void)createSuperUI {
    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    [self hideNavigation];
    [self createSegment];
    [self createTableView];
}

- (void)createSegment {
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@" 回复我的",@"我的点评 "]];
    self.segment.selectedSegmentIndex = 0;
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.cornerRadius = 15;
    self.segment.backgroundColor = [UIColor clearColor];
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.cornerRadius = 15;
    self.segment.layer.borderWidth = 1;
    self.segment.layer.borderColor = XKMainTypeColor.CGColor; //     边框颜色
    self.segment.tintColor = XKMainTypeColor;
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.width.equalTo(@173);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [self.segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)createTableView {
    self.tableViewLeft = [self makeTableView];
    self.tableViewRight = [self makeTableView];
    
    self.emptyViewLeft = [XKEmptyPlaceView configScrollView:self.tableViewLeft config:nil];
    self.emptyViewRight = [XKEmptyPlaceView configScrollView:self.tableViewRight config:nil];
}

- (UITableView *)makeTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    tableView.estimatedRowHeight = 300;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.segment.mas_bottom).offset(10);
    }];
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf baseRequestRefresh:YES needTip:NO];
    }];
    
    tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf baseRequestRefresh:NO needTip:NO];
    }];
    foot.hidden = YES;
    [foot setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = foot;
    return tableView;
}

#pragma mark - -------公用方法-------------

- (void)requestFirst {
    [self segmentChange]; // 先触发一次请求
}

- (void)requestRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       [self baseRequestRefresh:YES needTip:NO];
                   });

}

- (void)segmentClick:(UISegmentedControl *)segment {
    self.segmentIdnex = segment.selectedSegmentIndex;
    [self segmentChange];
}

#pragma mark - segment切换
- (void)segmentChange {
    if (self.segmentIdnex == 0) {
        if (_neverRequestLeft) { // 需要请求
            [self baseRequestRefresh:YES needTip:YES];
            _neverRequestLeft = NO;
        }
    } else {
        if (_neverRequestRight) { // 需要请求
            [self baseRequestRefresh:YES needTip:YES];
            _neverRequestRight = NO;
        }
    }
   
}

- (void)baseRequestRefresh:(BOOL)isRefresh needTip:(BOOL)needTip {
    BOOL currentShowReply = [self isShowReply]; // 记录 防止多次请求 数据源错乱
    
    if (currentShowReply) { // 判断请求当时数据源类型  防止多次请求 数据源错乱
        if (!self.dataArrayForReply) {
            self.dataArrayForReply = [NSMutableArray array];
        }
    } else {
        if (!self.dataArrayForMyComment) {
            self.dataArrayForMyComment = [NSMutableArray array];
        }
    }
    UITableView *tableView = self.tableView; // 记录 防止移除不了hud
    if (needTip) {
        [XKHudView showLoadingTo:tableView animated:YES];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"pageOffset"];
    } else {
        [params setObject:@((currentShowReply ?_pageOffsetLeft : _pageOffsetRight) + 1) forKey:@"pageOffset"];
    }
    [params setObject:@(_pageSize) forKey:@"pageSize"];
    
    [self requestIsRefresh:isRefresh params:params complete:^(NSString *error, NSArray *array) {
        [XKHudView hideHUDForView:tableView animated:YES];
        NSMutableArray *dataArray;
        XKEmptyPlaceView *emptyView;
        if (currentShowReply) { // 取出请求当时数据源类型  防止多次请求 数据源错乱
            dataArray = self.dataArrayForReply;
            emptyView = self.emptyViewLeft;
        } else {
            dataArray = self.dataArrayForMyComment;
            emptyView = self.emptyViewRight;
        }
        RefreshDataStatus refreshStatus;
        if (error) {
            refreshStatus = Refresh_NoNet;
            if (dataArray.count == 0) {
                emptyView.config.allowScroll = NO;
                [emptyView showWithImgName:kNetErrorPlaceImgName title:@"温馨提示" des:@"网络错误 点击重试" tapClick:^{
                    [self baseRequestRefresh:YES needTip:YES];
                }];
            } else {
                [XKHudView showErrorMessage:error to:tableView animated:YES];
            }
        } else {
            if (currentShowReply) { // 设置请求偏移量
                if (isRefresh) {
                    self.pageOffsetLeft = 0;
                } else {
                    self.pageOffsetLeft += 1;
                }
            } else {
                if (isRefresh) {
                    self.pageOffsetRight = 0;
                } else {
                    self.pageOffsetRight += 1;
                }
            }
            if (isRefresh) {
                [dataArray removeAllObjects];
            }
            if (array.count < self.pageSize) {
                refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                refreshStatus = Refresh_HasDataAndHasMoreData;
            }
            [dataArray addObjectsFromArray:array];
            if (dataArray.count == 0) {
                emptyView.config.allowScroll = YES;
                [emptyView showWithImgName:kEmptyPlaceImgName title:@"" des:@"暂无数据" tapClick:^{
                    //
                }];
            } else {
                [emptyView hide];
            }
        }
        [self resetMJHeaderFooter:refreshStatus tableView:tableView dataArray:self.dataArray];
        [self.tableView reloadData];
    }];
}

#pragma mark - ----------_cell 点击事件-----------

#pragma mark - 折叠事件
- (void)foldClick:(NSIndexPath *)indexPath {
    XKCommentBaseInfo*model = [self dataArray][indexPath.row];
    if ([model isKindOfClass:[XKCommentBaseInfo class]]) {
        model.showAllImg = !model.showAllImg;
        [self.tableView reloadData];
    }
}

#pragma mark - 回复事件
- (void)reply:(NSIndexPath *)indexPath {
   
}

#pragma mark - 子类重写 实现数据请求
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
     @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"requestIsRefresh方法子类请重写" userInfo:nil];
}

#pragma mark - 子类重写 帮cell赋值
- (void)refreshCell:(XKCommentCommonCell *)cell forIndexPath:(NSIndexPath *)indexPath {
   @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"refreshCell方法子类请重写" userInfo:nil];
}
#pragma mark - 子类实现 返回回复评论需要上传的参数
- (NSDictionary *)getCommentUploadParams:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"getCommentUploadParams方法子类请重写" userInfo:nil];
}
#pragma mark - 子类实现 处理cell 的点击事件
- (void)dealCellClick:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"dealCellClick方法子类请重写" userInfo:nil];
}


#pragma mark - 配置自定义视图显示
- (UIView *)getDiyView {
    if (self.isShowReply) { // 回复我的
        XKGoodsAndCommentView *view = [[XKGoodsAndCommentView alloc] init];
        return  view;
    } else {
        XKGoodsView *view = [[XKGoodsView alloc] init];
        return  view;
    }
}

#pragma mark - 是否显示回复
- (BOOL)isShowReply {
    return self.segmentIdnex == 0;
}

#pragma mark - tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    static NSString *myCommentcellId = @"myCommentcell";
    static NSString *replyCellId =  @"replyCellId";
    NSString *rid;
    Class cellClass;
    if ([self isShowReply]) {
        cellClass = [XKCommentReplyCell class];
        rid = replyCellId;
    } else {
        rid = myCommentcellId;
        cellClass = [XKCommentCommonCell class];
    }
    XKCommentCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
        [cell setDiyView:[self getDiyView]];
        [cell setFoldClick:^(NSIndexPath *indexPath) {
            [weakSelf foldClick:indexPath];
        }];
        if (self.isShowReply) {
            XKCommentReplyCell *replyCell = (XKCommentReplyCell *)cell;
            [replyCell setReplyClick:^(NSIndexPath *indexPath) {
                [weakSelf reply:indexPath];
            }];
        }
    }

    if (indexPath.row == 0) {
        cell.containView.xk_clipType = XKCornerClipTypeTopBoth;
        cell.hideSeperate = NO;
        if ([self dataArray].count == 1) {
            cell.containView.xk_clipType = XKCornerClipTypeAllCorners;
        }
    } else if (indexPath.row != [self dataArray].count - 1) { // 不是最后一个
        cell.containView.xk_clipType = XKCornerClipTypeNone;
        cell.hideSeperate = NO;
    } else { // 最后一个
        cell.containView.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.hideSeperate = YES;
    }
    cell.indexPath = indexPath;
    [self refreshCell:cell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataArray].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dealCellClick:indexPath];
}

#pragma mark - 解决动态cell高度 reloadData刷新抖动的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isShowReply]) {
        _estimatedRowHeightCacheLeft[indexPath] = @(cell.frame.size.height);
    } else {
        _estimatedRowHeightCacheRight[indexPath] = @(cell.frame.size.height);
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isShowReply]) {
        return [_estimatedRowHeightCacheLeft[indexPath] floatValue] + 1; // 不要返回0 否则可能没cell
    } else {
        return [_estimatedRowHeightCacheRight[indexPath] floatValue] + 1;
    }
}


- (void)setSegmentIdnex:(NSInteger)segmentIdnex {
    _segmentIdnex = segmentIdnex;
    _tableViewLeft.hidden = ![self isShowReply];
    _tableViewRight.hidden = !_tableViewLeft.hidden;
    self.segment.selectedSegmentIndex = segmentIdnex;
}

- (NSArray *)dataArray {
    if ([self isShowReply]) {
        return _dataArrayForReply;
    } else {
        return _dataArrayForMyComment;
    }
}

- (UITableView *)tableView {
    if ([self isShowReply]) {
        return _tableViewLeft;
    } else {
        return _tableViewRight;
    }
}

- (XKCommentInputView *)replyView {
    if (!_replyView) {
        _replyView = [XKCommentInputView inputView];
        _replyView.autoHidden = YES;
        _replyView.hidden = YES;
        _replyView.bottom = SCREEN_HEIGHT;
        [KEY_WINDOW addSubview:_replyView];
        __weak typeof(self) weakSelf = self;
        _replyView.sureClick = ^(NSString *text) {
            weakSelf.commentInfo.content = text;
            [weakSelf sendComment];
        };
        [_replyView setTextChange:^(NSString *text) {
            weakSelf.commentInfo.content = text;
        }];
    }
    return _replyView;
}

- (void)sendComment {
    
}

- (void)cleanInput {
    self.commentInfo = [XKCommentInputInfo new];
    [self.replyView endEditing];
    [_replyView setOriginText:@""];
    [_replyView setAtUserName:@""];
}

- (XKCommentInputInfo *)commentInfo {
    if (!_commentInfo) {
        _commentInfo = [XKCommentInputInfo new];
    }
    return _commentInfo;
}

@end
