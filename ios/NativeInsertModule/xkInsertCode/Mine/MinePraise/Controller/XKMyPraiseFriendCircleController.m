/*******************************************************************************
 # File        : XKMyPraiseFriendCircleController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMyPraiseFriendCircleController.h"
#import "XKFriendCircleGiftCell.h"
#import "XKMyPriaseFriendModel.h"
#import "XKFriendTalkDetailController.h"

@interface XKMyPraiseFriendCircleController ()

@end


@implementation XKMyPraiseFriendCircleController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

- (void)createDefaultData {
    
}


#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
#pragma mark - 折叠事件
- (void)foldClick:(NSIndexPath *)indexPath {
    XKMyPriaseFriendModel *model = [self dataArray][indexPath.row];
    model.showAllImg = !model.showAllImg;
    [self.tableView reloadData];
}


/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleDynamicPraisePage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        NSArray *array = [NSArray yy_modelArrayWithClass:[XKMyPriaseFriendModel class] json:dic[@"data"]];
        EXECUTE_BLOCK(complete,nil,array)
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
    XKMyPriaseFriendModel *model = self.dataArray[indexPath.row];
    cell.imgControlModel = model;
    [cell setInfoClick:^(NSIndexPath *indexPath) {
        XKMyPriaseFriendModel *model = weakSelf.dataArray[indexPath.row];
        XKFriendTalkDetailController *vc = [XKFriendTalkDetailController new];
        vc.did = model.dynamic.did;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    cell.isVideo = [model.dynamic.detailType isEqualToString:@"video"];
    cell.topUser = model.liker.userId;
    cell.btmUser = model.author.userId;
    [cell.headImageView sd_setImageWithURL:kURL(model.liker.avatar) placeholderImage:kDefaultHeadImg];
    cell.nameLabel.text = model.liker.displayName;
    cell.giftLabel.text = @"赞了你的可友圈";
    [cell.infoHeadImageView sd_setImageWithURL:kURL(model.author.avatar) placeholderImage:kDefaultPlaceHolderImg];
    cell.infoNamelabel.text = model.author.displayName?:@" ";
    cell.infoDesLabel.text = model.dynamic.content?:@" ";

    return cell;
}

/**子类实现 处理cell 的点击事件*/
- (void)dealCellClick:(NSIndexPath *)indexPath {
    
}

/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKFriendCircleGiftCell class] forCellReuseIdentifier:@"cell"];
}

/**子类重写 是否显示导航栏 默认显示了*/
- (BOOL)needNav {
    return NO;
}


@end
