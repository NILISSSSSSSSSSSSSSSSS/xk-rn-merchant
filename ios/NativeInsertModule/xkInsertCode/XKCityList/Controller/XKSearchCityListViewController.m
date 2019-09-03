//
//  XKSearchCityListViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSearchCityListViewController.h"
#import "XKSearchListModel.h"
#import "BaseTabBarConfig.h"

@interface XKSearchCityListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar       *searchBar;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIButton          *cancelButton;
@property (nonatomic, strong) NSArray           *cityArray;
/**是否显示空数据占位*/
@property(nonatomic, assign) BOOL isShow;
@end

@implementation XKSearchCityListViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self LayoutView];
    [self hideNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark – Private Methods

- (void)initViews {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.containView setBackgroundColor:[UIColor clearColor]];
    [self.searchBar becomeFirstResponder];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cancelButton];
}

- (void)LayoutView {
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.top.equalTo(@(45));
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(self.cancelButton.mas_left).offset(-10);
        make.top.equalTo(@(30));
        make.height.equalTo(@(50));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.searchBar.mas_bottom).offset(10);
    }];
}
//通过关键字获取可能的城市数组
- (void)getSearchCity:(NSString *)code block:(void(^)(NSArray *array))block{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @"1";
    parameters[@"limit"] = @"20";
    parameters[@"keyword"] = code;
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/regionPage/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        XKSearchListModel *model = [XKSearchListModel yy_modelWithJSON:responseObject];
        block(model.data);
    } failure:^(XKHttpErrror *error) {
    }];
}


#pragma mark - Events
- (void)cancelAction:(UIButton *)sender {
    [self cancelSearch];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"城市名/拼音";
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;

    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (NSArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}
#pragma mark --- UISearchBarDelegate

//searchBar文本改变时即调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        NSLog(@"%@",searchText);
        [self getSearchCity:searchText block:^(NSArray *array) {
            if (array.count <= 0) {
                self.isShow = YES;
                [self.tableView reloadData];
            }else{
                self.isShow = NO;
                self.cityArray = array;
                [self.tableView reloadData];
            }
        }];
    }else{
        self.cityArray = @[];
        self.isShow = NO;
        [self.tableView reloadData];
    }
}

//点击键盘搜索按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getSearchCity:searchBar.text block:^(NSArray *array) {
        if (array.count <= 0) {
            self.isShow = YES;
            [self.tableView reloadData];
        }else{
            self.isShow = NO;
            self.cityArray = array;
            [self.tableView reloadData];
            [self.searchBar resignFirstResponder];
            NSLog(@"点击搜索按钮编辑的结果是%@",searchBar.text);
        }
        
    }];
}
//取消搜索
- (void)cancelSearch {
    [_searchBar resignFirstResponder];
    _searchBar.text = nil;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!self.isShow) {
        XKSearchDataItem *model = self.cityArray[indexPath.row];
        cell.textLabel.text = model.name;
    }else{
        cell.textLabel.text = @"抱歉，未找到相关位置，可尝试修改后重试";
    }
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isShow) {
        return 1;
    }else{
        return self.cityArray.count;
    }
}
#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShow) {
    }else{
        XKSearchDataItem *model = self.cityArray[indexPath.row];
        if (self.block) {
            self.block(model.name,model.latitude.doubleValue,model.longitude.doubleValue,[model.level isEqualToString:@"3"] ? model.parentCode : model.code,model.level,model.parentCode);
        }
        if ([self respondsToSelector:@selector(presentingViewController)]){
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
@end
