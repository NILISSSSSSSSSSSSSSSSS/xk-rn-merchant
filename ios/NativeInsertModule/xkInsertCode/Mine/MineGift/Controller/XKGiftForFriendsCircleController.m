

/*******************************************************************************
 # File        : XKGiftForFriendController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGiftForFriendsCircleController.h"
#import "XKFriendCircleGiftCell.h"
#import "XKFriendCircleGiftModel.h"
#import "XKGiftVideoModel.h"

@interface XKGiftForFriendsCircleController ()

@end


@implementation XKGiftForFriendsCircleController

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

- (void)createDefaultData {
 
}


- (void)createUI {

}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
#pragma mark - 折叠事件
- (void)foldClick:(NSIndexPath *)indexPath {
    XKWithImgBaseModel *model = [self dataArray][indexPath.row];
    model.showAllImg = !model.showAllImg;
    [self.tableView reloadData];
}

/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
    // FIXME: sy 接口假的
    [HTTPClient getEncryptRequestWithURLString:@"user/ua/videoGiftQPage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKGiftVideoModel class] json:dic[@"data"]];
        EXECUTE_BLOCK(complete,nil,arr);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

/**子类重写 实现返回cell*/
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    __weak typeof(self) weakSelf = self;
    XKFriendCircleGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.containView.xk_openClip = YES;
    cell.containView.xk_radius = 6;
    
    if (indexPath.row == 0) {
        cell.containView.xk_clipType = XKCornerClipTypeTopBoth;
        if (self.dataArray.count == 1) {
            cell.containView.xk_clipType = XKCornerClipTypeAllCorners;
        }
    } else if (indexPath.row != self.dataArray.count - 1) { // 不是最后一个
        cell.containView.xk_clipType = XKCornerClipTypeNone;
    } else { // 最后一个
        cell.containView.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    [cell setFoldClick:^(NSIndexPath *indexPath) {
        [weakSelf foldClick:indexPath];
    }];
    [cell setRefreshBlock:^(NSIndexPath *indexPath) {
        [weakSelf.tableView reloadData];
    }];
    cell.indexPath = indexPath;
    XKGiftVideoModel *model = self.dataArray[indexPath.row];
    cell.imgControlModel = model;
    cell.nameLabel.text = model.nickName;
    [cell.headImageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    [cell.infoHeadImageView sd_setImageWithURL:kURL(model.receiver.avatar) placeholderImage:kDefaultPlaceHolderImg];
    cell.infoNamelabel.text = [NSString stringWithFormat:@"@%@",model.receiver.nickName];
    cell.infoDesLabel.text = model.receiver.content;
    [cell setGiftType:model.getGiftArr];
    return cell;
}

/**子类实现 处理cell 的点击事件*/
- (void)dealCellClick:(NSIndexPath *)indexPath {
    
}

/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView {
    [self.tableView registerClass:[XKFriendCircleGiftCell class] forCellReuseIdentifier:@"cell"];
}

/**子类重写 是否显示导航栏 默认显示了*/
- (BOOL)needNav {
    return NO;
}


@end

