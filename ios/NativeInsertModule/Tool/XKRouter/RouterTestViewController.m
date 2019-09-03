/*******************************************************************************
 # File        : RouterTestViewController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/22
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "RouterTestViewController.h"
#import "XKEmptyPlaceView.h"
#import "XKMenuView.h"
#import "UIImage+Edit.h"
#import "UIView+XKCornerBorder.h"
@interface RouterTestViewController () <UITableViewDelegate,UITableViewDataSource>
/**无数据视图*/
@property(nonatomic, strong)  XKEmptyPlaceView *emptyView;
/**tableView*/
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation RouterTestViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
      self.navigationController.navigationBar.hidden = YES;
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
//    UILabel *label = [UILabel new];
//    label.text = [NSString stringWithFormat:@"name:%@  num:%ld",self.name,self.num];
//    label.frame = CGRectMake(40, 50, 300, 300);
//    label.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:label];
    self.title = [self.name stringByAppendingString:@(self.num).stringValue];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"show1" style:UIBarButtonItemStylePlain target:self action:@selector(emptyShow1)];
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"show2" style:UIBarButtonItemStylePlain target:self action:@selector(emptyShow2)];
     UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"hide" style:UIBarButtonItemStylePlain target:self action:@selector(emptyHide)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(pop:)];
    [self.navigationItem setRightBarButtonItems:@[item1,item11, item2,item3]];
}

- (void)emptyShow1 {
    __weak typeof(self) weakSelf = self;
//    _emptyView.config.viewAllowTap = NO;
     [_emptyView resetConfig];
    [_emptyView showWithImgName:nil title:@"温馨提示" des:@"数据没的啊我勒个去 没东西啊捉急" btnText:@"搞点数据去" btnImg:@"xk_tabbar_home_selected" tapClick:^{
        [weakSelf emptyHide];
    }];
}

- (void)emptyShow2 {
  //  __weak typeof(self) weakSelf = self;
    [_emptyView resetConfig];
    XMEmptyViewConfig *config = _emptyView.config;
    config.verticalOffset = -130;
    config.btnColor = [UIColor whiteColor];
    config.btnFont = XKRegularFont(17);
    config.descriptionColor = HEX_RGB(0x777777);
    config.descriptionFont = XKRegularFont(14);
    config.btnBackImg = [self createBtnImg];
    config.spaceHeight = 0;
//    config.rectInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    config.capInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_emptyView showWithImgName:@"xk_ic_main_authResult" title:@"" des:@"\n无数据啊\n" btnText:@"返回" btnImg:nil tapClick:^{
        //
    }];
}

- (void)emptyHide {
    [_emptyView hide];
}


- (void)pop:(UIView *)view {
//
    XKMenuView *menuView = [XKMenuView menuWithTitles:@[@"联系客服",@"查看物流",@"退货"] images:@[IMG_NAME(@"xk_ic_contact_search"),IMG_NAME(@"xk_ic_contact_search"),IMG_NAME(@"xk_ic_contact_search")] width:100 relyonView:view clickBlock:^(NSInteger index, NSString *text) {
        NSLog(@"%@",text);
    }];
    menuView.menuColor = HEX_RGBA(0x2A2A2A, 0.6);
    menuView.textColor = [UIColor whiteColor];
    menuView.separatorPadding = 5;
    menuView.textImgSpace = 10;
    [menuView show];
}

- (UIImage *)createBtnImg {
    UIImage *image = [UIImage imageWithColor:HEX_RGB(0x4A90FA) rect:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    image = [image roundImageWithCorners:UIRectCornerAllCorners radius:8];
    return image;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid=@"1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
    }
    cell.textLabel.text = @"123";
    cell.xk_openBorder = YES;
    cell.xk_borderColor = [UIColor redColor];
    cell.xk_borderWidth = 1;
    cell.xk_borderRadius = 6;
    cell.xk_borderType = XKBorderTypeAllCorners;
    return cell;
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
