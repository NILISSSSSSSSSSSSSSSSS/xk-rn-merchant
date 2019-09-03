/*******************************************************************************
 # File        : XKOrderTrackController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/4
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderTrackController.h"
#import <RZColorful.h>
#import "XKOrderTrackNormalCell.h"


static NSString *const normalCellId = @"normalCell";

@interface XKOrderTrackController () <UITableViewDelegate, UITableViewDataSource>
/***/
@property(nonatomic, strong) UIScrollView *scrollView;
/**信息view*/
@property(nonatomic, strong) UIView *topInfoView;
/**物流view*/
@property(nonatomic, strong) UIView *btmInfoView;
/**信息label*/
@property(nonatomic, strong) UILabel *infoLabel;
/**物流信息tableView*/
@property(nonatomic, strong) UITableView *tableView;

/**<##>*/
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XKOrderTrackController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    [self requestData];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    self.dataArray = [NSMutableArray array];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"订单跟踪" WithColor:[UIColor whiteColor]];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor =  HEX_RGB(0xF6F6F6);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
  
    [self.scrollView addSubview:self.topInfoView];
    [self.scrollView addSubview:self.btmInfoView];
    
    CGFloat space = 10;
    [self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(space);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.centerX.equalTo(self.scrollView);
    }];
    [self.topInfoView bk_whenTapped:^{
        [self aa];
    }];
    [self.btmInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topInfoView.mas_bottom).offset(space);
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@10);
        make.left.equalTo(self.scrollView.mas_left).offset(space);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-30);
    }];
}

- (void)aa {
    [self reloadData];
}
#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView layoutSubviews];

}

#pragma mark ----------------------------- 网络请求 ------------------------------
- (void)requestData {
    [self.infoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.lineSpacing(10);
        confer.text(@"订单编号：");
        confer.text(@"awdaw123241251");
        confer.text(@"\n");
        confer.text(@"快递公司：");
        confer.text(@"顺丰快递");
        confer.text(@"\n");
        confer.text(@"快递单号：");
        confer.text(@"5434357457345");
    }];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:2];

}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKOrderTrackNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = nil;
    if (self.dataArray.count == 1) {
        cell.lineStyle = XKOrderTrackCellLineTopStyle;
    } else {
        if (indexPath.row == 0) {
            cell.lineStyle = XKOrderTrackCellLineBtmStyle;
        } else if (indexPath.row == self.dataArray.count - 1) {
            cell.lineStyle = XKOrderTrackCellLineTopStyle;
        } else {
            cell.lineStyle = XKOrderTrackCellLineFullStyle;
        }
    }
    return cell;
}

#pragma mark --------------------------- setter&getter -------------------------
- (UIView *)topInfoView {
    if (!_topInfoView) {
        _topInfoView = [[UIView alloc] init];
        _topInfoView.backgroundColor = [UIColor whiteColor];
        [_topInfoView drawCommonShadowUselayer];
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.font = XKRegularFont(14);
        self.infoLabel.textColor = HEX_RGB(0x222222);
        [_topInfoView addSubview:self.infoLabel];
        WEAK_TYPES(_topInfoView);
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weak_topInfoView).insets(UIEdgeInsetsMake(14, 14, 14, 14));
        }];
    }
    return _topInfoView;
}

- (UIView *)btmInfoView {
    if (!_btmInfoView) {
        _btmInfoView = [[UIView alloc] init];
        _btmInfoView.backgroundColor = [UIColor clearColor];
        _btmInfoView.layer.masksToBounds = YES;
        [self.btmInfoView drawCommonShadowUselayer];
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 100;
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.tableView registerClass:[XKOrderTrackNormalCell class] forCellReuseIdentifier:normalCellId];
        self.tableView.layer.cornerRadius = 5;
        [_btmInfoView addSubview:self.tableView];
        WEAK_TYPES(_btmInfoView);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weak_btmInfoView);
        }];
    }
    return _btmInfoView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
            CGFloat height = self.tableView.contentSize.height;
            [self.btmInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
    }
}

@end
