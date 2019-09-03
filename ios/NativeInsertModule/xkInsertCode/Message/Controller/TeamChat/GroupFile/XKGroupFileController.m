/*******************************************************************************
 # File        : XKGroupFileController.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/2/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGroupFileController.h"
#import "XKGroupFileModel.h"
#import "XKGroupFileCell.h"
#import "XKFilePreViewController.h"

@interface XKGroupFileController ()
/**<##>*/
@property(nonatomic, strong) UIButton *rightBtn;
@end

@implementation XKGroupFileController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  //
  [self refreshDataNeedTip:YES];
  
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

- (void)createDefaultData {
  
}


#pragma mark - 初始化界面
- (void)createUI {
  [self setNavTitle:@"群文件" WithColor:[UIColor whiteColor]];
//  UIButton *newBtn = [[UIButton alloc] init];
//  [newBtn setTitle:@"上传" forState:UIControlStateNormal];
//  [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//  newBtn.titleLabel.font = XKRegularFont(17);
//  [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
//  [newBtn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
//  [self setRightView:newBtn withframe:newBtn.bounds];
//  _rightBtn = newBtn;
//  _rightBtn.hidden = YES;
  
}

- (void)upload {
  
  
  
}

/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
  params[@"tid"] = self.teamId;
  [HTTPClient getEncryptRequestWithURLString:@"im/ma/teamFilePage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    NSDictionary *dic = [responseObject xk_jsonToDic];
    NSArray *arr = [NSArray yy_modelArrayWithClass:[XKGroupFileModel class] json:dic[@"data"]];
    complete(nil,arr);
  } failure:^(XKHttpErrror *error) {
    complete(error.message,nil);
  }];
}

/**子类重写 实现返回cell*/
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
  XKGroupFileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
  XKFilePreViewController *vc = [XKFilePreViewController new];
  XKGroupFileModel *model = self.dataArray[indexPath.row];
  vc.model = model;
  vc.title = @"文件预览";
  [self.navigationController pushViewController:vc animated:YES];
}

/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[XKGroupFileCell class] forCellReuseIdentifier:@"cell"];
  [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).offset(10);
    make.right.equalTo(self.view.mas_right).offset(-10);
  }];
}


@end
