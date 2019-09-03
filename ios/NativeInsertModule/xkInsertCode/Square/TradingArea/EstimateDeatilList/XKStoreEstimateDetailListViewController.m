//
//  XKStoreEstimateDetailListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEstimateDetailListViewController.h"
#import "XKStoreEstimateSectionHeaderView.h"
#import "XKStoreEstimateCell.h"
#import "XKSquareTradingAreaTool.h"

#pragma mark - 模型
#import "XKTradingAreaCommentLabelsModel.h"
#import "XKTradingAreaCommentListModel.h"
#import "XKTradingAreaCommentGradeModel.h"

static NSString * const estimateCellID                = @"estimateCellID";
static NSString * const estimateSectionHeaderViewID   = @"estimateSectionHeaderView";

@interface XKStoreEstimateDetailListViewController () <UITableViewDelegate, UITableViewDataSource, StoreEstimateDelegate>

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;

@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, copy  ) NSArray          *commentLabelsArr;
@property (nonatomic, strong) NSMutableArray   *commentListArr;
@property (nonatomic, assign) CGFloat          labelsViewHeight;
@property (nonatomic, strong) XKTradingAreaCommentGradeModel *gradeModel;


@end

@implementation XKStoreEstimateDetailListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
    [self requestAllData:YES];
}

#pragma mark - Events



#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"评价详情" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    self.page = 1;

    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestAllData:NO];
    }];
    self.tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestAllData:NO];
    }];
    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = foot;
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height+10, 0, 0, 0));
    }];
}

#pragma mark - request


- (void)requestAllData:(BOOL)firstLoad {
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    
    if (self.type == EstimateDetailListType_goods) {
        
        [self requestCommentListWithParameters:@{@"page":@(self.page), @"limit":@"10", @"goodsId":self.goodsId ? self.goodsId : @""}];
        [self requestTeadingAreaGoodsCommentGrade];
        
    } else if (self.type == EstimateDetailListType_shop) {
        
        [self requestCommentListWithParameters:@{@"page":@(self.page), @"limit":@"10", @"shopId":self.shopId ? self.shopId : @""}];
        [self requestTeadingAreaShopCommentGrade];
        if (firstLoad) {
            [self requestShopCommentLabelsWithParameters:@{@"shopId":self.shopId ? self.shopId : @""}];
        }
    }
    dispatch_group_notify(self.group, dispatch_get_global_queue(0,0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [XKHudView hideHUDForView:self.tableView];
            [self.tableView stopRefreshing];
            [self.tableView reloadData];
        });
    });
}


- (void)requestTeadingAreaGoodsCommentGrade {
    [XKSquareTradingAreaTool tradingAreaGoodsCommentGrade:@{@"goodsId":self.goodsId ? self.goodsId : @""} group:self.group success:^(XKTradingAreaCommentGradeModel *model) {
        self.gradeModel = model;
    }];
}

- (void)requestTeadingAreaShopCommentGrade {
    [XKSquareTradingAreaTool tradingAreaShopCommentGrade:@{@"shopId":self.shopId ? self.shopId : @""} group:self.group success:^(XKTradingAreaCommentGradeModel *model) {
        self.gradeModel = model;
    }];
}


- (void)requestCommentListWithParameters:(NSDictionary *)parameters {
    
    [XKSquareTradingAreaTool tradingAreaGoodsOrShopCommentList:parameters group:self.group success:^(NSArray<CommentListItem *> *listArr) {
        if (!self.commentListArr) {
            self.commentListArr = [NSMutableArray array];
        }
        if (self.page == 1) {
            [self.commentListArr removeAllObjects];
        }
        if (!listArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.commentListArr addObjectsFromArray:listArr];
            if (listArr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.commentListArr.count == 0) {
            self.emptyView.config.viewAllowTap = NO;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无相关评论数据" tapClick:nil];
        } else {
            [self.emptyView hide];
        }
    } faile:^(XKHttpErrror *error) {
        if (self.page > 1) {
            self.page--;
        }
    }];
}



- (void)requestShopCommentLabelsWithParameters:(NSDictionary *)dic {
    
    [XKSquareTradingAreaTool tradingAreaShopCommentLabels:dic group:self.group success:^(NSArray *result) {
        self.commentLabelsArr = result;
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreEstimateCell *cell = [tableView dequeueReusableCellWithIdentifier:estimateCellID];
    if (!cell) {
        cell = [[XKStoreEstimateCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:estimateCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
        cell.delegate = self;
    }
    [cell setValueWithModel:self.commentListArr[indexPath.row]];
    if (indexPath.row + 1 == self.commentListArr.count) {
        [cell hiddenLine:YES];
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    } else {
        [cell hiddenLine:NO];
        cell.xk_clipType = XKCornerClipTypeNone;
    }

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.labelsViewHeight + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XKStoreEstimateSectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:estimateSectionHeaderViewID];
    if (!sectionHeaderView) {
        sectionHeaderView = [[XKStoreEstimateSectionHeaderView alloc] initWithReuseIdentifier:estimateSectionHeaderViewID];
        sectionHeaderView.backView.xk_openClip = YES;
        sectionHeaderView.backView.xk_radius = 5;
        sectionHeaderView.backView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        
        XKWeakSelf(weakSelf);
        sectionHeaderView.labelsBlock = ^(NSInteger index) {
            weakSelf.page = 1;
            XKTradingAreaCommentLabelsModel *model = weakSelf.commentLabelsArr[index];
            if (weakSelf.type == EstimateHeaderType_shop) {
                [weakSelf requestCommentListWithParameters:@{@"page":@(weakSelf.page), @"limit":@"10", @"shopId":self.shopId ? self.shopId : @"", @"type":model.code}];
            }
        };
    }
    [sectionHeaderView setTitleName:[NSString stringWithFormat:@"评价（%ld）", (long)self.gradeModel.commentCount.integerValue] titleColor:HEX_RGB(0x222222) titleFont:XKRegularFont(14)];
    [sectionHeaderView setStarViewValue:self.gradeModel.averageScore.integerValue];
    
    CGFloat labelsViewH = [sectionHeaderView configLabelsWithDataSource:self.commentLabelsArr type:self.type == EstimateDetailListType_shop ? EstimateHeaderType_shop : EstimateHeaderType_goods];
    if (labelsViewH != self.labelsViewHeight) {
        self.labelsViewHeight = labelsViewH;
        [self.tableView reloadData];
    }
    return sectionHeaderView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - customDelegate

- (void)unfoldButtonClick:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row < self.commentListArr.count) {
        CommentListItem *model = self.commentListArr[indexPath.row];
        model.unfold = !model.unfold;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.commentListArr];
        [muArr replaceObjectAtIndex:indexPath.row withObject:model];
        self.commentListArr = [muArr copy];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)estimateCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgArr:(NSArray *)imgArr {
    [XKGlobleCommonTool showBigImgWithImgsArr:imgArr viewController:self];
    
}

#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }
    return _group;
}

- (XKEmptyPlaceView *)emptyView {
    if (!_emptyView) {
        _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    }
    return _emptyView;
}

@end
