//
//  XKSeatNumDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSeatNumDetailViewController.h"
#import "XKSqureConsultLsitCell.h"
#import "XKSeatNumDetailLsitCell.h"

static NSString * const cellId   = @"cellID";

@interface XKSeatNumDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) UIButton        *bottomBtn;


@end

@implementation XKSeatNumDetailViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
    
}


#pragma mark - Events



#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"席位名" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomBtn.mas_top).offset(-10);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSeatNumDetailLsitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[XKSeatNumDetailLsitCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backView.xk_openClip = YES;
        cell.backView.xk_radius = 5;
        cell.backView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    [cell setValueWithImg:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [XKGlobleCommonTool showBigImgWithImgsArr:self.dataSource defualtIndex:indexPath.row viewController:self];
}

- (void)sureButtonClicked:(UIButton *)sender {
    
    if (self.refreshSetBlock) {
        self.refreshSetBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.backgroundColor = XKMainTypeColor;
        if (self.selected) {
            [_bottomBtn setTitle:@"取消选择" forState:UIControlStateNormal];
        } else {
            [_bottomBtn setTitle:@"确认选择" forState:UIControlStateNormal];
        }
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font = XKRegularFont(17);
        [_bottomBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

@end
