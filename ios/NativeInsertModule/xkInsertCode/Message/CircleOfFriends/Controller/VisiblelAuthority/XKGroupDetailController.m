/*******************************************************************************
 # File        : XKGroupDetailController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupDetailController.h"
#import "XKGroupDetailViewModel.h"

@interface XKGroupDetailController ()
/**<##>*/
@property(nonatomic, strong) UITextField *nameTextField;
/**<##>*/
@property(nonatomic, strong) UILabel *numLabel;
/**<##>*/
@property(nonatomic, strong) XKGroupDetailViewModel *viewModel;
@end

@implementation XKGroupDetailController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    
    [self requestNeedTip:YES];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    _viewModel = [XKGroupDetailViewModel new];
    _viewModel.tagId = self.groupId;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:@"分组详情" WithColor:[UIColor whiteColor]];
    [self createTableView];
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    [self createHeaderView];
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    [self createNameViewToView:headerView];
    headerView.frame = CGRectMake(0, 0, 20, 100 + 10);
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.cornerRadius = 6;
    headerView.layer.masksToBounds = YES;
    self.tableView.tableHeaderView = headerView;
}

- (void)createNameViewToView:(UIView *)headerView {
    UIView *nameView = [UIView new];
    [headerView addSubview:nameView];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(10);
        make.left.right.equalTo(headerView);
        make.height.equalTo(@50);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"分组名称";
    label.textColor = HEX_RGB(51);
    label.font = XKRegularFont(14);
    [nameView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.left.equalTo(nameView.mas_left).offset(18);
        make.width.mas_equalTo(XKViewSize(62));
    }];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"例如家人、朋友";
    self.nameTextField.font = XKRegularFont(15);
    self.nameTextField.userInteractionEnabled = NO;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    [nameView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(20);
        make.top.bottom.equalTo(nameView);
        make.right.equalTo(nameView.mas_right).offset(-10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEX_RGB(0xF1F1F1);
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameView);
        make.top.equalTo(nameView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.backgroundColor = [UIColor whiteColor];
    _numLabel.text = @"分组成员";
    _numLabel.textColor = HEX_RGB(51);
    _numLabel.font = XKRegularFont(14);
    [headerView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView.mas_bottom).offset(25);
        make.left.equalTo(nameView.mas_left).offset(18);
        make.width.equalTo(@200);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)updateHeadView {
    _numLabel.text = [NSString stringWithFormat:@"分组成员(%ld)",self.viewModel.dataArray.count];
    _nameTextField.text = self.viewModel.model.groupName;
}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestNeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.containView animated:YES];
    }
    [self.viewModel requestComplete:^(NSString *err, NSArray *arr) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        if (err) {
            [XKHudView showErrorMessage:err to:self.containView animated:YES];
        } else {
            [self updateHeadView];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
