/*******************************************************************************
 # File        : XKFriendTalkMsgRecordController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkMsgRecordController.h"
#import "XKFriendTalkRecordModel.h"
#import "XKFriendTalkRecordCell.h"
#import "XKFriendTalkDetailController.h"

@interface XKFriendTalkMsgRecordController ()
/**<##>*/
@property(nonatomic, strong) UIButton *rightBtn;
@end

@implementation XKFriendTalkMsgRecordController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    //
    [self refreshDataNeedTip:YES];
    
    [[XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem cleanUnReadTipStatus];
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
    [self setNavTitle:@"消息记录" WithColor:[UIColor whiteColor]];
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"清空" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
    [newBtn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    _rightBtn = newBtn;
    _rightBtn.hidden = YES;
    
}

- (void)clean {
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleMsgLogClear/1.0" timeoutInterval:20 parameters:nil success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.rightBtn.hidden = YES;
        self.tableView.userInteractionEnabled = NO;
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
    
}

/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleMsgLogList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKFriendTalkRecordModel class] json:dic[@"data"]];
        complete(nil,arr);
        self.rightBtn.hidden = self.dataArray.count == 0 ? YES : NO;
    } failure:^(XKHttpErrror *error) {
        complete(error.message,nil);
    }];
}
/**子类重写 实现返回cell*/
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
  XKFriendTalkRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//  cell.indexPath = indexPath;
  cell.model = self.dataArray[indexPath.row];
  cell.xk_openClip = YES;
  cell.xk_radius = 6;
  if (indexPath.row == 0) {
    cell.xk_clipType = XKCornerClipTypeTopBoth;
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

/**子类实现 处理cell 的点击事件*/
- (void)dealCellClick:(NSIndexPath *)indexPath {
    XKFriendTalkDetailController *vc = [XKFriendTalkDetailController new];
    XKFriendTalkRecordModel *model = self.dataArray[indexPath.row];
    vc.did = model.did;
    [self.navigationController pushViewController:vc animated:YES];
}

/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView {
    
    [tableView registerClass:[XKFriendTalkRecordCell class] forCellReuseIdentifier:@"cell"];
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
}


@end
