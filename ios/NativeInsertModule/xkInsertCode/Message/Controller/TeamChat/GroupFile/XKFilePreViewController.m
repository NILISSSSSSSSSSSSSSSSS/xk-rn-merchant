/*******************************************************************************
 # File        : XKFilePreViewController.m
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

#import "XKFilePreViewController.h"

@interface XKFilePreViewController ()
@property(nonatomic ,strong) UIDocumentInteractionController* documentController;
@end

@implementation XKFilePreViewController

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

- (void)setModel:(XKGroupFileModel *)model {
  _model = model;
  self.url = model.fileUrl;
}

#pragma mark - 初始化界面
- (void)createUI {
  UIButton *shareBtn = [[UIButton alloc] init];
  [shareBtn setImage:IMG_NAME(@"xk_icon_snatchTreasure_order_trans") forState:UIControlStateNormal];
  [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [shareBtn sizeToFit];
  [shareBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
  [self setRightView:shareBtn withframe:shareBtn.bounds];
}

- (void)shareClick {
  //创建实例
  //获得临时文件
  
  [self downloadFileComplete:^(BOOL succes, NSString *localPath) {
    if (succes) {
      self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:localPath]];
      
      BOOL canOpen = [self.documentController presentOpenInMenuFromRect:CGRectZero
                                                             inView:self.view
                                                           animated:YES];
      if (!canOpen) {
        NSLog(@"沒有程序可以打開要分享的文件");
      }
    } else {
      [XKHudView showErrorMessage:@"文件下载失败"];
    }
  }];

}

- (void)downloadFileComplete:(void(^)(BOOL succes, NSString *localPath))result {
  /* 下载路径 */

  NSArray *paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
  NSString *cachesDir = [paths objectAtIndex:0];
  
  NSString *name =[self.model.ID substringToIndex:5];
  name = [name stringByAppendingString:self.model.fileName];

  NSString *filePath = [cachesDir stringByAppendingPathComponent:name];
  NSFileManager* fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:filePath]){ // 有文件
    result(YES,filePath);
    return;
  }
  
  /* 创建网络下载对象 */
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  
  /* 开始请求下载 */
  /* 下载地址 */
  [XKHudView showLoadingMessage:@"文件下载中" to:self.view animated:YES];
  NSURL *url = [NSURL URLWithString:self.url];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
  } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    dispatch_async(dispatch_get_main_queue(), ^{
      //如果需要进行UI操作，需要获取主线程进行操作
    });
    /* 设定下载到的位置 */
    return [NSURL fileURLWithPath:filePath];
    
  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    [XKHudView hideHUDForView:self.view];
    NSLog(@"下载完成");
    if (error) {
      result(NO,nil);
    } else {
      result(YES,filePath.absoluteString);
    }
  }];
  [downloadTask resume];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
