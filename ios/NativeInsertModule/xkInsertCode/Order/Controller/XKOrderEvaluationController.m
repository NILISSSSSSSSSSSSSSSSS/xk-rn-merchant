/*******************************************************************************
 # File        : XKOrderEvaluationController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKOrderEvaluationController.h"
#import "XKOrderEvalutionCell.h"
#import "XKOrderEvaModel.h"
#import "XKMenuView.h"
#import "UIView+XKCornerRadius.h"
#import "XKMallOrderEvaluateSuccessViewController.h"
@interface XKOrderEvaluationController () <UITableViewDelegate, UITableViewDataSource>
/*tableview<##>*/
@property(nonatomic, strong) UITableView *tableView;
/**dataArray*/
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XKOrderEvaluationController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    self.dataArray = [NSMutableArray array];
    if (self.evaluationType == XKEvaluationTypeMallDetail) {
        if (_item) {
            for (int i = 0; i < _item.goodsInfo.count; i ++) {
                
                XKOrderEvaModel *model = [[XKOrderEvaModel alloc] init];
                model.goodsInfo =  _item.goodsInfo[i];
                XKOrderEvaStarInfo *info = [XKOrderEvaStarInfo new];
                info.title = @"评分";
                info.starNum = 5;
                info.des = @"非常好";
                model.evaStarArr = @[info]; // 需要评分项传入数组
                [self.dataArray addObject:model];
            }
        }
        
    } else if (self.evaluationType == XKEvaluationTypeMallList) {
        if (_listItem) {
            for (int i = 0; i < _item.goodsInfo.count; i ++) {
                
                XKOrderEvaModel *model = [[XKOrderEvaModel alloc] init];
                model.goodsInfo =  _listItem.goods[i];
                XKOrderEvaStarInfo *info = [XKOrderEvaStarInfo new];
                info.title = @"评分";
                info.starNum = 5;
                info.des = @"非常好";
                model.evaStarArr = @[info]; // 需要评分项传入数组
                [self.dataArray addObject:model];
            }
        }

    } else {
        for (int i = 0; i < _model.goods.count; i ++) {
            
            XKOrderEvaModel *model = [[XKOrderEvaModel alloc] init];
            model.goodsInfo =  _model.goods[i];
            XKOrderEvaStarInfo *info = [XKOrderEvaStarInfo new];
            info.title = @"评分";
            info.starNum = 5;
            info.des = @"非常好";
            model.evaStarArr = @[info]; // 需要评分项传入数组
            [self.dataArray addObject:model];
        }
    }

}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"评价" WithColor:[UIColor whiteColor]];
    UIButton *commitBtn = [[UIButton alloc] init];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.titleLabel.font = XKRegularFont(16);
    [self setRightView:commitBtn withframe:CGRectMake(0, 0, XKViewSize(38), XKViewSize(30))];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HEX_RGB(0xF6F6F6);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 380;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    // 注册cell
    [self.tableView registerClass:[XKOrderEvalutionCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)commitClick:(UIButton *)btn {
    [self.view endEditing:YES];
    XKWeakSelf(ws);
    [XKHudView showLoadingTo:self.view animated:YES];
    btn.userInteractionEnabled = NO;

    dispatch_group_t group = dispatch_group_create();

    for (XKOrderEvaModel *model in self.dataArray) {
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [XKUploadMediaInfo uploadMediaWithMediaArr:model.mediaInfoArr Complete:^(NSString *error, id data) {
                   dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });

    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 请求完成 这里判断一下资源是否已经全部上传成功
        BOOL finish = YES;
        for (XKOrderEvaModel *model in self.dataArray) {
            finish =   [XKUploadMediaInfo checkMediaAllUploadWithMediaArr:model.mediaInfoArr];
        }
        if (!finish) {
            [XKHudView hideAllHud];
            [XKAlertView showCommonAlertViewWithTitle:@"图片上传失败，是否重新开始上传" leftText:@"取消" rightText:@"重试" leftBlock:^{
                
            } rightBlock:^{
                [ws commitClick:btn];
            }];
        } else {
             [ws submitComment:btn];
        }
       
    });

   
   
}

- (void)submitComment:(UIButton *)sender {
    [XKHudView showLoadingTo:self.view animated:YES];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i ++) {
        
        XKOrderEvaModel *model = self.dataArray[i];
        MallOrderListObj *obj =  model.goodsInfo;
        XKOrderEvaStarInfo *info = model.evaStarArr.firstObject;
        
        NSMutableArray *picArr = [NSMutableArray array];
        NSString *videoUrl;
        NSString *videoIcon;
        for (XKUploadMediaInfo *info in model.mediaInfoArr) {
            if (!info.isAdd) {
                if (!info.isVideo) {
                    [picArr addObject:info.imageNetAddr];
                } else {
                    videoIcon = info.videoFirstImgNetAddr;
                    videoUrl  = info.videoNetAddr;
                }
            }

        }
        NSDictionary *dic = @{
                              @"goods"    : @{
                                      @"skuCode" : obj.goodsSkuCode,
                                      @"id"      : obj.goodsId
                                      },
                              @"score"    : @(info.starNum),
                              @"content"  : model.commentText ?:@"系统默认好评",
                              @"pictures" : picArr ,
                              @"video"    : @{
                                      @"url"     : videoUrl ?:@"",
                                      @"mainPic" : videoIcon ?:@""
                                      }
                              };
        [tmpArr addObject:dic];
    }
    NSDictionary *dic;
    if (self.evaluationType == XKEvaluationTypeMallDetail) {
        dic = @{
              @"orderId" : _item.orderId,
              @"comments" : tmpArr,
              };
    } else if (self.evaluationType == XKEvaluationTypeMallList) {
        dic = @{
                @"orderId" : _listItem.orderId,
                @"comments" : tmpArr,
                };
    } else {
        dic = @{
                @"orderId" : _model.orderId,
                @"comments" : tmpArr,
                };
    }

    [XKOrderEvaModel submitOrderCommentWithParm:dic Success:^(id data) {
        sender.userInteractionEnabled = YES;
        XKMallOrderEvaluateSuccessViewController *success = [XKMallOrderEvaluateSuccessViewController new];
        [self.navigationController pushViewController:success animated:YES];
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKOrderEvalutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.dataArray[indexPath.row];

    [cell setRefreshTableView:^{
        [weakSelf.tableView reloadData];
    }];
    return cell;
}

- (void)viewDidLayoutSubviews {
   
}

#pragma mark --------------------------- setter&getter -------------------------


@end
