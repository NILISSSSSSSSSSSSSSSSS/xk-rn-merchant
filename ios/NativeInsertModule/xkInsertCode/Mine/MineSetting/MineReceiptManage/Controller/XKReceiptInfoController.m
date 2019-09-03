/*******************************************************************************
 # File        : XKReceiptInfoController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptInfoController.h"
#import "XKReceiptInfoViewModel.h"

@interface XKReceiptInfoController ()

@property(nonatomic, strong) UITableView *tableView;
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**数据源*/
@property(nonatomic, strong) XKReceiptInfoViewModel *viewModel;

@end

@implementation XKReceiptInfoController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 构建数据
    [self requestData];
}


- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
//    __weak typeof (self) weakSelf = self;
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"发票信息管理" WithColor:[UIColor whiteColor]];
  
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    self.tableView.tag = kNeedFixHudOffestViewTag;
    
    [self.viewModel regisCellFor:self.tableView];
    
    // 创建footer
    [self createFooter];
}

#pragma mark - 创建footer
- (void)createFooter {
    UIView *footerView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEX_RGB(0x999999);
    titleLabel.font = XKRegularFont(13);
    titleLabel.text = @"温馨提示";
    titleLabel.frame = CGRectMake(20, 20, SCREEN_WIDTH - 20 * 2, 15);
    [footerView addSubview:titleLabel];
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.numberOfLines = 0;
    infoLabel.text = @"1、选择抬头类型：企业/个人，企业抬头必须要填写合法的企业税号\n2、勾选是否默认抬头、下单申请发票时，会自定使用默认抬头";
    infoLabel.width = titleLabel.width;
    infoLabel.textColor = titleLabel.textColor;
    infoLabel.font = titleLabel.font;
    [infoLabel sizeToFit];
    [footerView addSubview:infoLabel];
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = XKMainTypeColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"保存并使用" forState:UIControlStateNormal];
    btn.titleLabel.font = XKRegularFont(18);
    [footerView addSubview:btn];
    
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    infoLabel.frame = CGRectMake(20, titleLabel.bottom + 10, infoLabel.width, infoLabel.height);
    btn.frame = CGRectMake(10, infoLabel.bottom + 10, SCREEN_WIDTH - 20, 45);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, btn.bottom + 20);
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark ----------------------------- 其他方法 ------------------------------
- (void)addDeleteBtn {
    // 加入删除按钮
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"删除" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [self setRightView:newBtn withframe:newBtn.bounds];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setReceiptId:(NSString *)receiptId {
    [self.viewModel setEditReceiptId:receiptId];
}

#pragma mark - 删除事件
- (void)delete {
    [XKAlertView showCommonAlertViewWithTitle:@"是否删除该发票" leftText:@"取消" rightText:@"确认" leftBlock:^{
        
    } rightBlock:^{
        [XKHudView showLoadingTo:self.tableView animated:YES];
        [self.viewModel requestDeleteReceipt:^(NSString *err , id data) {
            [XKHudView hideHUDForView:self.tableView];
            if (err) {
                [XKHudView showWarnMessage:err to:self.tableView animated:YES];
            } else {
                EXECUTE_BLOCK(self.infoChange);
                [XKHudView showWarnMessage:@"删除发票成功" to:self.tableView time:1.5 animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

#pragma mark - 保存事件
- (void)save {
    [KEY_WINDOW endEditing:YES];
    if (![self.viewModel checkData]) {
        return;
    }
    [XKHudView showLoadingTo:self.tableView animated:YES];
    
    if (self.viewModel.editStatus) { // 修改
        [self.viewModel requestUpdateReceiptInfo:^(NSString *err , id data) {
            [XKHudView hideHUDForView:self.tableView];
            if (err) {
                [XKHudView showWarnMessage:err to:self.tableView animated:YES];
            } else {
                EXECUTE_BLOCK(self.infoChange);
                [XKHudView showSuccessMessage:@"修改发票成功" to:self.tableView time:1.5 animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    } else { // 新增
        [self.viewModel requestUploadReceipt:^(NSString *err , id data) {
            [XKHudView hideHUDForView:self.tableView];
            if (err) {
                [XKHudView showWarnMessage:err to:self.tableView animated:YES];
            } else {
                EXECUTE_BLOCK(self.infoChange);
                [XKHudView showSuccessMessage:@"创建发票成功" to:self.tableView time:1.5 animated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }
}

- (void)requestData {
    if (!self.viewModel.editStatus) { // 新增
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.tableView.hidden = YES;
    [self.viewModel requestReceiptInfo:^(NSString *err, XKReceiptInfoModel *model) {
        if (err) {
            return ;
        }
        [weakSelf.tableView reloadData];
        weakSelf.tableView.hidden = NO;
        [weakSelf addDeleteBtn];
    }];
}

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (XKReceiptInfoViewModel *)viewModel {
    if (!_viewModel) {
        __weak typeof(self) weakSelf = self;
        _viewModel = [XKReceiptInfoViewModel new];
        [_viewModel setRefreshBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }
    return _viewModel;
}

@end
