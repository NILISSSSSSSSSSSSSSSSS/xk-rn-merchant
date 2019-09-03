//
//  XKSqureSearchViewController.m
//  XKSquare
//
//  Created by hupan on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureSearchViewController.h"

#import "XKSubscriptionTableViewCell.h"
#import "XKSubscriptionHeaderView.h"
#import "XKSubscriptionFooterView.h"
#import "XKSquareSearchDetailMainViewController.h"
#import "XKSearchItemModel.h"


#define vertical_spacing  15
#define horizonal_spacing 15

static NSString * const historySearchCellID     = @"historySearchCellID";
static NSString * const hostSearchCellID        = @"hostSearchCellID";
static NSString * const searchCellID            = @"searchCellID";
static NSString * const sectionHeaderViewID     = @"sectionHeaderView";
static NSString * const sectionFooterViewID     = @"sectionFooterView";

static CGFloat const SectoionHeaderHeight = 40;

@interface XKSqureSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) XKCustomSearchBar  *searchBar;
@property (nonatomic, strong) NSMutableArray     *historySearchArray;
@property (nonatomic, strong) NSMutableArray     *hostSearchArray;
@property (nonatomic, assign) CGFloat            historySearchCellHeight;
@property (nonatomic, assign) CGFloat            hostSearchCellHeight;
@property (nonatomic, copy  ) NSArray            *searchDataArray;


@end

@implementation XKSqureSearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBar];
    
    NSString *string = [[XKDataBase instance] select:XKHistorySearchDataBaseTable key:[XKUserInfo getCurrentUserId]];
    if (string) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKSearchItemModel class] json:string];
        _historySearchArray = [[NSMutableArray alloc] initWithArray:arr];
    } else {
        _historySearchArray = [NSMutableArray array];
    }
    
    _hostSearchArray = [NSMutableArray array];
    [self loadAreaHostSearchRequest];
    
    _searchDataArray = @[@"1", @"1", @"1", @"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    
    [self configTableView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.searchText.length) {
        [self.searchBar.textField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Private Metheods
- (void)configTableView {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}
- (void)configNavigationBar {
    
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self hideNavigationSeperateLine];
    [self setLeftView:self.searchBar withframe:CGRectMake(0, 0, SCREEN_WIDTH - 80, 30)];
    
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
    [cancelBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:cancelBtn withframe:CGRectMake(0, 0, XKViewSize(45), XKViewSize(30))];
}


- (void)configHistorySearchCell:(UITableViewCell *)cell dataSource:(NSArray *)array index:(NSInteger)index {
    //创建关键字
    UIButton *tempButton = nil;
    CGRect buttonRect = CGRectMake(0, 0, 0, 30);
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        XKSearchItemModel *model = array[i];
        NSString *titleStr = [NSString stringWithFormat:@"    %@    ", model.title];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:HEX_RGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13];
        
        button.backgroundColor = HEX_RGB(0xF1F1F1);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        
        if (!tempButton) {
            buttonRect = CGRectMake(horizonal_spacing, vertical_spacing, 0, 30);
        } else {
            buttonRect = CGRectMake(CGRectGetMaxX(tempButton.frame) + horizonal_spacing, buttonRect.origin.y, buttonRect.size.width,buttonRect.size.height);
        }
        CGSize buttonTitleSize = [button.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]} context:nil].size;
        buttonRect = CGRectMake(buttonRect.origin.x, buttonRect.origin.y, buttonTitleSize.width, buttonRect.size.height);
        if (CGRectGetMaxX(buttonRect) > SCREEN_WIDTH) {
            
            buttonRect = CGRectMake(horizonal_spacing, buttonRect.origin.y, buttonTitleSize.width, buttonRect.size.height);
            buttonRect = CGRectMake(buttonRect.origin.x, CGRectGetMaxY(buttonRect) + vertical_spacing, buttonTitleSize.width, buttonRect.size.height);
        }
        button.frame = buttonRect;
        tempButton = button;
        button.tag = i + (index * 10000);
        [button addTarget:self action:@selector(seachItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    if (index == 0 && _historySearchArray.count) {
        _historySearchCellHeight = CGRectGetMaxY(tempButton.frame) + vertical_spacing;
    } else if (index == 1 && _hostSearchArray.count) {
        _hostSearchCellHeight = CGRectGetMaxY(tempButton.frame) + vertical_spacing;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:(UITableViewRowAnimationFade)];
}


#pragma nark - Events
- (void)cancelBtnClicked {
    /*if (_searchText.length) {
        _searchText = nil;
        self.searchBar.textField.text = nil;
        [self.tableView reloadData];
        
    } else {*/
    
//    if (self.popRootViewController) {
//        [self.naviga tionController popToRootViewControllerAnimated:NO];
//    } else {
        [self.navigationController popViewControllerAnimated:NO];
//    }
//    }
}


- (void)seachItemClicked:(UIButton *)sender {
    _searchText = [sender.titleLabel.text removeSpaceChar];
    self.searchBar.textField.text = _searchText;
    if (self.searchType == SearchEntryType_Area) {
        [self gotoDetailVc];
    }else{
        //网络请求
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchText.length) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchText.length) {
        return _searchDataArray.count;
    } else {
        if (section == 0 && _historySearchArray.count) {
            return 1;

        } else if (section == 1 && _hostSearchArray.count) {
            return 1;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchText.length) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:searchCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"xk_ic_login_search"];
            cell.textLabel.textColor = HEX_RGB(0x555555);
            cell.textLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
            cell.detailTextLabel.textColor = HEX_RGB(0x999999);
            cell.detailTextLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 44, SCREEN_WIDTH - 10, 1)];
            line.backgroundColor = XKSeparatorLineColor;
            [cell addSubview:line];
        }
        cell.textLabel.text = @"测试测试测试";
        cell.detailTextLabel.text = @"约70个结果";
        
        return cell;
        
    } else {
        
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historySearchCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:historySearchCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self configHistorySearchCell:cell dataSource:_historySearchArray index:indexPath.section];
            }
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hostSearchCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hostSearchCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self configHistorySearchCell:cell dataSource:_hostSearchArray index:indexPath.section];
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchText.length) {
        return 45;
    } else {
        if (indexPath.section == 0) {
            return _historySearchCellHeight;
        } else {
            return _hostSearchCellHeight;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoDetailVc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_searchText.length) {
        return 0.01f;
    } else {
        if (section == 0 && _historySearchArray.count) {
            return SectoionHeaderHeight;
        } else if (section == 1 && _hostSearchArray.count) {
            return SectoionHeaderHeight;
        }
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_searchText.length) {
        return nil;
    } else {
        if ((section == 0 && _historySearchCellHeight) || (section == 1 && _hostSearchCellHeight)) {
            
            XKSubscriptionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderViewID];
            if (!sectionHeaderView) {
                sectionHeaderView = [[XKSubscriptionHeaderView alloc] initWithReuseIdentifier:sectionHeaderViewID];
                [sectionHeaderView setTitleColor:HEX_RGB(0x4A90FA ) font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:15]];
                sectionHeaderView.contentView.backgroundColor = [UIColor whiteColor];
                [sectionHeaderView cutCorner:NO];
            }
            NSString *title = @"";
            if (section == 0) {
                title = @"历史搜索";
                XKWeakSelf(ws);
                sectionHeaderView.isShowDelButton = YES;
                sectionHeaderView.delBlock = ^(UIButton *sender) {
                    if ([[XKDataBase instance] existsTable:XKHistorySearchDataBaseTable]) {
                        [[XKDataBase instance]deleteValueForTable:XKHistorySearchDataBaseTable key:[XKUserInfo getCurrentUserId]];
                    }
                    [ws.historySearchArray removeAllObjects];
                    [ws.tableView reloadData];
                };
            } else if (section == 1) {
                title = @"热门搜索";
                sectionHeaderView.isShowDelButton = NO;
            }
            [sectionHeaderView setTitleName:title];
            return sectionHeaderView;
        }
    }
    return nil;
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"搜索。。。%@", textField.text);
//    if (self.searchType == SearchEntryType_Area) {
//        _searchText = textField.text;
//        [self gotoDetailVc];
//    }else {
//        if (textField.text.length) {
//            //请求网络
//            _searchText = textField.text;
//            [self.tableView reloadData];
//
//        }
//    }
    _searchText = textField.text;
    [self gotoDetailVc];
    
    return YES;
}

#pragma mark - Custom Delegates
- (void)gotoDetailVc {
    [self.view endEditing:YES];
    if (_searchText.length) {
        XKSquareSearchDetailMainViewController *vc = [[XKSquareSearchDetailMainViewController alloc] init];
        vc.searchText = [_searchText removeSpaceChar];
        vc.searchType = (NSUInteger)self.searchType;
        [self.navigationController pushViewController:vc animated:YES];
        //含有#标识的属于密友圈进入密码
        if ([_searchText isContainString:@"#"]) {
            return;
        }
        //加入历搜索数组
        NSDictionary *dic = @{@"title": _searchText};
        XKSearchItemModel *model = [XKSearchItemModel yy_modelWithDictionary:dic];
        NSArray *historyCopyArray = [self.historySearchArray copy];
        //去重
        XKWeakSelf(ws);
        if (self.historySearchArray.count <= 0) {
            [self.historySearchArray insertObject:model atIndex:0];
        }else {
            [historyCopyArray enumerateObjectsUsingBlock:^(XKSearchItemModel*  _Nonnull otherModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([otherModel.title isEqualToString:model.title]) {
                    [ws.historySearchArray removeObject:otherModel];
                }
            }];
            [self.historySearchArray addObject:model];
        }
        if (self.historySearchArray.count > 10) {
            [self.historySearchArray removeObjectAtIndex:0];
        }
        //存入数据库
        if ([[XKDataBase instance] existsTable:XKHistorySearchDataBaseTable]) {
            if (self.historySearchArray.count == 1) {
                [[XKDataBase instance] insert:XKHistorySearchDataBaseTable key:[XKUserInfo getCurrentUserId] value:[_historySearchArray yy_modelToJSONString]];
            }else{
                [[XKDataBase instance] update:XKHistorySearchDataBaseTable key:[XKUserInfo getCurrentUserId] value:[_historySearchArray yy_modelToJSONString]];
            }
        } else {
            if ([[XKDataBase instance] createTable:XKHistorySearchDataBaseTable]) {
                [[XKDataBase instance] replace:XKHistorySearchDataBaseTable key:[XKUserInfo getCurrentUserId] value:[_historySearchArray yy_modelToJSONString]];
            }
        }
    }
}

#pragma mark - Lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (XKCustomSearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 30)];
        [_searchBar setTextFieldWithBackgroundColor:HEX_RGB(0xf0f0f0) tintColor:HEX_RGB(0x555555) textFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:HEX_RGB(0x646464) textPlaceholderColor:HEX_RGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
        [_searchBar setSearchBarSearchImage:@"xk_ic_login_search"];
        _searchBar.textField.placeholder = @"输入商家、商品名称";
        _searchBar.textField.text = _searchText;
        [_searchBar.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [_searchBar.textField enableSecretJump:YES];
        _searchBar.textField.returnKeyType = UIReturnKeySearch;
        _searchBar.textField.delegate = self;
    }
    return _searchBar;
}
- (void)textFieldAction:(UITextField *)textField {
    if (self.searchType == SearchEntryType_Area) {
        
    }else {
        if (textField.text.length) {
            _searchText = [NSString stringWithFormat:@"%@",textField.text];
            //请求网络
            NSLog(@"%@", _searchText);
        } else {
            if (textField.text.length == 1 ) {
                _searchText = @"";
            }
        }
        [self.tableView reloadData];
    }
}

- (void)loadAreaHostSearchRequest {
    XKWeakSelf(ws);
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/keyWordDetail/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
      NSArray *array = [responseObject xk_jsonToDic];
        for (NSString *title in array) {
            NSDictionary *dict = @{@"title":title};
            XKSearchItemModel *model = [XKSearchItemModel yy_modelWithDictionary:dict];
            [ws.hostSearchArray addObject:model];
            [ws.tableView reloadData];
        }
    } failure:^(XKHttpErrror *error) {
        NSLog(@"%@", error.message);
    }];
}
@end
