//
//  XKBankCardListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBankCardListViewController.h"
#import "XKAddBankCardViewController.h"
#import "XKBankCardListCell.h"
#import "XKBankCardDetailInfoViewController.h"
#import "XKBankCardListModel.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKBankCardListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;
@property (nonatomic, strong) NSMutableArray     *dataSource;
@property (nonatomic, assign) NSInteger          page;

@end

@implementation XKBankCardListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
    [self configRefresh];
    
    self.page = 1;
    [self requestDataList:YES];
}


#pragma mark - request

- (void)configRefresh {
    
    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestDataList:YES];
    }];
    self.tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataList:YES];
    }];
    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = foot;
}

- (void)requestDataList:(BOOL)showHUD {
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    if(showHUD) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }

    [HTTPClient postEncryptRequestWithURLString:GetXKBankCardList
                                timeoutInterval:20
                                     parameters:@{@"limit":@10, @"page":@(self.page)}
                                        success:^(id responseObject) {
                                            
        
        [XKHudView hideHUDForView:self.containView];
        [self.tableView stopRefreshing];
        if (self.page == 1 && self.dataSource.count) {
            [self.dataSource removeAllObjects];
        }
                                
        
        if (responseObject == nil) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            self.page++;
            //模型赋值
            XKBankCardListModel *listModel = [XKBankCardListModel yy_modelWithDictionary:responseObject];
            [self.dataSource addObjectsFromArray:listModel.data];
        }
                                            
        if (self.dataSource.count == 0) {
            self.emptyView.config.viewAllowTap = NO;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"您还没有添加银行卡哦" tapClick:nil];
        } else {
            [self.emptyView hide];
        }
        [self.tableView reloadData];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView];
        [self.tableView stopRefreshing];
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark - Events

- (void)addBtnClicked {
    
    XKAddBankCardViewController *vc = [[XKAddBankCardViewController alloc] init];
    //刷新列表
    XKWeakSelf(weakSelf);
    vc.addBankCard = ^{
        weakSelf.page = 1;
        [weakSelf requestDataList:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"银行卡" WithColor:[UIColor whiteColor]];
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"xk_btn_bankCardAdd"] forState:UIControlStateNormal];
    [self setNaviCustomView:addBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
    
}

- (void)configTableView {
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[XKBankCardListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setValueWithModel:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKBankCardDetailInfoViewController *vc = [[XKBankCardDetailInfoViewController alloc] init];
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
        _tableView.rowHeight = 121 * ScreenScale;
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
