//
//  XKGrandPrizeShowOrderViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeShowOrderViewController.h"
#import "XKGoodsCommentCell.h"
#import "XKGrandPeizeShowOrderModel.h"

@interface XKGrandPrizeShowOrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *showOrders;


@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger showOrderCount;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKGrandPrizeShowOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"大奖晒单" WithColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[XKGoodsCommentCell class] forCellReuseIdentifier:NSStringFromClass([XKGoodsCommentCell class])];
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0));
    }];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postGrandPrizeShowOrders];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.showOrders.count >= weakSelf.showOrderCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postGrandPrizeShowOrders];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
    
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    
}

#pragma mark - POST

- (void)postGrandPrizeShowOrders {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.showOrders removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.showOrderCount = dict[@"total"] ? [dict[@"total"] unsignedIntegerValue] : 0;
            }
            [self.showOrders addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKGrandPeizeShowOrderModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.showOrders.count) {
            [self.emptyView hide];
        } else {
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.showOrders.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postGrandPrizeShowOrders];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKGoodsCommentCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userId = [XKUserInfo getCurrentUserId];
    cell.indexPath = indexPath;
    cell.cellMargin = 10.0;
    [cell setRefreshBlock:^(NSIndexPath *indexPath) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [self refreshCell:cell forIndexPath:indexPath];
    if (self.showOrders.count == 1) {
        cell.xk_radius = 8.0;
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        cell.xk_openClip = YES;
        [cell xk_forceClip];
    } else if (indexPath.row == 0) {
        cell.xk_radius = 8.0;
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        cell.xk_openClip = YES;
        [cell xk_forceClip];
    } else if (indexPath.row == self.showOrders.count - 1) {
        cell.xk_radius = 8.0;
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.xk_openClip = YES;
        [cell xk_forceClip];
    } else {
        cell.xk_radius = 0.0;
        cell.xk_clipType = XKCornerClipTypeNone;
        cell.xk_openClip = YES;
        [cell xk_forceClip];
    }
    return cell;
}

- (void)refreshCell:(XKGoodsCommentCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [cell.headImageView sd_setImageWithURL:kURL(@" ") placeholderImage:kDefaultHeadImg];
    cell.nameLabel.text = @"12415";
    cell.timeLabel.text = @"2012-24-12 颜色：藏青色  尺码：175";
    cell.desLabel.text = @"非常满意大小刚好，质量很好没问题，快递顺丰一级棒隔";
    cell.model = self.showOrders[indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (NSMutableArray *)showOrders {
    if (!_showOrders) {
        _showOrders = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            XKGrandPeizeShowOrderModel *model = [[XKGrandPeizeShowOrderModel alloc] init];
            model.singleImgWidth = XKViewSize(90.0);
            model.singleImgheight = XKViewSize(120.0);
            model.showAllImg = NO;
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int temp = 0; temp < arc4random() % 9 + 1; temp++) {
                XKMediaInfoModel *media = [[XKMediaInfoModel alloc] init];
                media.mainPic = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536747746131&di=33bd1490ce51a28079710dd26baceb2e&imgtype=0&src=http%3A%2F%2Fimg3.cache.netease.com%2Fm%2F2015%2F3%2F12%2F2015031211113646b72_550.jpg";
                media.isPic = arc4random() % 2;
                media.url = @"http://zb.xksquare.com/20180929183046_1_5baf5456c8ae8_wmImg.mp4?from=singlemessage&isappinstalled=0";
                [tempArray addObject:media];
            }
            model.imgsArray = [tempArray copy];
            [_showOrders addObject:model];
        }
    }
    return _showOrders;
}

@end
