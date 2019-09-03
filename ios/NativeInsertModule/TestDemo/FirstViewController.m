/*******************************************************************************
 # File        : FirstViewController.m
 # Project     : NativeInsertDemo
 # Author      : Jamesholy
 # Created     : 2018/12/8
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "FirstViewController.h"
#import <Masonry.h>
#import <AFNetworking.h>
//#import <UIImageView+WebCache.h>
//#import "WebUrlViewController.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

/***/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation FirstViewController

#pragma mark ----------------------------- 生命周期 ------------------------------

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createUI];
    [self request];
  }
  return self;
}

//- (void)viewDidLoad {
//  [super viewDidLoad];
//  [self createUI];
//}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
//  self.backgroundColor = [UIColor yellowColor];
  self.tableView = [[UITableView alloc] init];
//  self.tableView.backgroundColor = [UIColor redColor];
  [self addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (void)request {
  NSString *urlString = @"https://api.github.com/search/repositories?q=iOS&sort=stars";
  //初始化一个AFHTTPSessionManager
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//  //设置请求体数据为json类型
//  manager.requestSerializer = [AFJSONRequestSerializer serializer];
//  //设置响应体数据为json类型
//  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  //请求体，参数（NSDictionary 类型）
  [manager GET:urlString parameters:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSDictionary *dic = responseObject;
     NSArray *arr = dic[@"items"];
    self.dataArray = arr;
    [self.tableView reloadData];
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
}

- (NSDictionary *)xk_jsonToDic:(id)resp {
  
  NSData *jsonData = [resp dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err) {
    NSLog(@"json解析失败：%@",err);
    return nil;
  }
  return dic;
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  static NSString *rid=@"cell";
  UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
  if(cell==nil){
    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
  }
  NSDictionary *items = self.dataArray[indexPath.row];
  cell.textLabel.text = items[@"name"];;
//  [cell.imageView sd_setImageWithURL:[NSURL URLWithString:items[@"owner"][@"avatar_url"]]];
  cell.detailTextLabel.text = items[@"owner"][@"type"];
  return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [[self getCurrentVC] pushViewController:vc animated:YES];
}

- (UINavigationController *)getCurrentVC {
  return [NSObject getCurrentUIVC].navigationController;
}

@end
