/*******************************************************************************
 # File        : XKMineCollectSearchViewController.m
 # Project     : XKSquare
 # Author      : Lin Li
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

#import "XKMineCollectSearchViewController.h"
#import "UIView+XKCornerRadius.h"
#import "XKMineCollectSearchTableViewCell.h"
#import "XKAlertView.h"
#import "XKCustomSearchBar.h"
@interface XKMineCollectSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIButton          *cancelButton;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) UIView            *contentView;
@property (nonatomic, strong) XKCustomSearchBar *searchBar;

@end

@implementation XKMineCollectSearchViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    [self hideNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
- (void)createDefaultData {
    self.dataArray = [NSMutableArray arrayWithArray:@[@"最近搜索",@"数据线",@"火锅",@"麻辣烫"]] ;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.searchBar];
    [self.contentView addSubview:self.cancelButton];
    [self.view addSubview:self.tableView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@84);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.centerY.equalTo(self.contentView).offset(10);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
    }];
}
#pragma mark - Events
- (void)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cleanButtonAction:(UIButton *)sender {
    [XKAlertView showCommonAlertViewWithTitle:@"确定清空搜索历史吗？" rightText:@"确认" rightBlock:^{
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}
#pragma mark – Getters and Setters
-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = XKMainTypeColor;
    }
    return _contentView;
}

- (XKCustomSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH - 100, 35)];
        [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] tintColor:HEX_RGB(0xFFFFFF) textFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:[UIColor whiteColor] textPlaceholderColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft masksToBounds:YES];
        _searchBar.textField.text = @"";
        _searchBar.textField.returnKeyType = UIReturnKeySearch;
        _searchBar.textField.placeholder = @"可输入关键字搜索";
        [_searchBar.textField setValue: [[UIColor whiteColor] colorWithAlphaComponent:0.5] forKeyPath:@"_placeholderLabel.textColor"];

    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XKMineCollectSearchTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKMineCollectSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.xk_radius = 5;
    cell.xk_openClip = YES;
    cell.labelText = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    }else if (indexPath.row == self.dataArray.count - 1){
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    }else{
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count <= 0) {
        return 0;
    }
    else{
        return 64;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    UIButton* cleanButton = [[UIButton alloc]init];
    [cleanButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [cleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    cleanButton.layer.masksToBounds = true;
    cleanButton.layer.cornerRadius = 10 * ScreenScale;
    cleanButton.backgroundColor = HEX_RGB(0x4A90FA);
    [cleanButton addTarget:self action:@selector(cleanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cleanButton];
    [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    headerView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return headerView;
}
@end
