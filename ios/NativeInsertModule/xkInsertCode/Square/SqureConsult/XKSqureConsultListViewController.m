//
//  XKSqureConsultListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultListViewController.h"
#import "XKSqureConsultLsitCell.h"
#import "XKSqureConsultModel.h"
#import "XKSqureConsultDetailViewController.h"

static NSString * const cellId   = @"cellID";

@interface XKSqureConsultListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSource;
@property (nonatomic, assign) NSInteger          page;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;


@end

@implementation XKSqureConsultListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.page = 1;
    [self configNavigationBar];
    [self configTableView];
    [self requestAllData];
    
}

#pragma mark - request

- (void)requestAllData {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.page) forKey:@"page"];
    [dic setObject:@"10" forKey:@"limit"];
    
    [HTTPClient postEncryptRequestWithURLString:GetSquareConsultUrl
                                timeoutInterval:20.0
                                     parameters:dic
                                        success:^(id responseObject) {
                                            [self.tableView stopRefreshing];
                                            if (responseObject) {
                                                if (!self.dataSource) {
                                                    self.dataSource = [NSMutableArray array];
                                                }
                                                if (self.page == 1) {
                                                    [self.dataSource removeAllObjects];
                                                }
                                                
                                                XKSqureConsultModel *model = [XKSqureConsultModel yy_modelWithJSON:responseObject];
                                                if (!model.data.count) {
                                                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                } else {
                                                    [self.dataSource addObjectsFromArray:model.data];
                                                    if (model.data.count < 10) {
                                                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                    }
                                                }
                                                
                                                if (self.dataSource.count == 0) {
                                                    self.emptyView.config.viewAllowTap = NO;
                                                    [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无相关数据" tapClick:nil];
                                                } else {
                                                    [self.emptyView hide];
                                                }
                                                
                                                [self.tableView reloadData];
                                            }
                                    
                                } failure:^(XKHttpErrror *error) {
                                    [self.tableView stopRefreshing];
                                    if (self.page > 1) {
                                        self.page--;
                                    }
                                }];
}

#pragma mark - Events



#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"活动列表" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    
    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestAllData];
    }];
    self.tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestAllData];
    }];
    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = foot;
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureConsultLsitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[XKSqureConsultLsitCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backView.xk_openClip = YES;
        cell.backView.xk_radius = 5;
        cell.backView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    
    [cell setValueWithModel:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConsultItemModel *item = self.dataSource[indexPath.row];
    XKSqureConsultDetailViewController *vc = [[XKSqureConsultDetailViewController alloc] init];
    vc.url = item.url;
    vc.imgUrl = item.image;
    vc.titleName = item.title;
    vc.content = item.content;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
    }
    return _tableView;
}


- (XKEmptyPlaceView *)emptyView {
    if (!_emptyView) {
        _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    }
    return _emptyView;
}

@end
