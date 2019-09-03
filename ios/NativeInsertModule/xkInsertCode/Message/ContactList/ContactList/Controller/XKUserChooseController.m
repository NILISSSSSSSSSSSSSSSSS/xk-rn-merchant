/*******************************************************************************
 # File        : XKUserChooseController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/30
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKUserChooseController.h"
#import "XKContactListCell.h"

@interface XKUserChooseController () <UITableViewDelegate, UITableViewDataSource> {
    UIButton *_sureBtn;
}
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation XKUserChooseController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    [self updateUI];
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
    
}

#pragma mark - 初始化界面
- (void)createUI {
    [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    [self createTableView];
    [self createRightButton];
}


- (void)createTableView {
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.tag = kNeedFixHudOffestViewTag;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = 60;
    [self.containView addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 10);
    
    [self.tableView registerClass:[XKContactListCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containView);
    }];
}

- (void)createRightButton {
    _sureBtn = [[UIButton alloc] init];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:RGBGRAY(220) forState:UIControlStateDisabled];
    [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self setRightView:_sureBtn withframe:CGRectMake(0, 0, 70, 26)];
}

#pragma mark - 公用
- (void)updateUI {
    [self.tableView reloadData];
    if ([self getSelectedArray].count == 0) {
        _sureBtn.enabled = NO;
    } else {
        _sureBtn.enabled = YES;
    }
}

- (void)sureBtnClick {
    EXECUTE_BLOCK(self.sureClickBlock,[self getSelectedArray],self);
}

- (void)setDataArray:(NSArray<XKContactModel *> *)dataArray {
    _dataArray = dataArray;
    [_dataArray enumerateObjectsUsingBlock:^(XKContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.defaultSelectedAndDisabale = NO;
    }];
}

- (NSArray *)getSelectedArray {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"selected = YES && defaultSelectedAndDisabale = NO"];
    return [self.dataArray filteredArrayUsingPredicate:pred];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.showChooseBtn = YES;
    cell.headerImgView.userInteractionEnabled = NO;
    cell.xk_openClip = YES;
    cell.xk_radius = 6;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
        cell.hideSeperate = NO;
        if (self.dataArray.count == 1) {
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        }
    } else if (indexPath.row != self.dataArray.count - 1) { // 不是最后一个
        cell.xk_clipType = XKCornerClipTypeNone;
    } else { // 最后一个
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XKContactModel * model = self.dataArray[indexPath.row];
    // 清除其他所有的选择
    for (XKContactModel *model in self.dataArray) {
        model.selected = NO;
    }
    model.selected = !model.selected;
    [self updateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55 * ScreenScale;
}


@end
