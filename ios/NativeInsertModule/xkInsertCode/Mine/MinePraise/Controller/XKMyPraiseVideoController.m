/*******************************************************************************
 # File        : XKMyPraiseVideoController.m
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

#import "XKMyPraiseVideoController.h"
#import "XKVideoGiftCell.h"
#import "XKFavorVideoModel.h"
#import "XKVideoDisplayMediator.h"

@interface XKMyPraiseVideoController ()
@end

@implementation XKMyPraiseVideoController

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

/**子类重写 实现数据请求*/
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete {
   
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/userVideoPraisePage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        NSDictionary *dic = [responseObject xk_jsonToDic];
        NSArray *array = [NSArray yy_modelArrayWithClass:[XKFavorVideoModel class] json:dic[@"data"]];
        EXECUTE_BLOCK(complete,nil,array)
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

/**子类重写 实现返回cell*/
- (UITableViewCell *)returnCellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    __weak typeof(self) weakSelf = self;
    XKVideoGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
    XKFavorVideoModel *model = self.dataArray[indexPath.row];
    cell.giftLabel.text = @"赞了你的小视频";
    cell.topUser = model.liker.userId;
    cell.btmUser = model.author.userId;
    [cell setInfoViewClick:^(NSIndexPath *indexPath) {
        XKFavorVideoModel *clickModel = weakSelf.dataArray[indexPath.row];
        // 跳转视频
        [XKVideoDisplayMediator displaySingleVideoWithViewController:weakSelf videoId:clickModel.video.videoId];
    }];
    [cell.headImageView sd_setImageWithURL:kURL(model.liker.avatar) placeholderImage:kDefaultHeadImg];
    cell.nameLabel.text = model.liker.displayName;
    cell.timeLabel.text = model.getDisplayTime;
    [cell.infoView.imgView sd_setImageWithURL:kURL(model.video.showPic) placeholderImage:kDefaultPlaceHolderImg];
    cell.infoView.nameLabel.text = model.author.displayName;
    cell.infoView.infoLabel.text = model.video.describe;
    [cell setGiftType:nil];
    return cell;
}

/**子类实现 处理cell 的点击事件*/
- (void)dealCellClick:(NSIndexPath *)indexPath {
    
}

/**子类实现 tableView更多详细配置的设值*/
- (void)configMoreForTableView:(UITableView *)tableView {
     [tableView registerClass:[XKVideoGiftCell class] forCellReuseIdentifier:@"cell"];
}

/**子类重写 是否显示导航栏 默认显示了*/
- (BOOL)needNav {
    return NO;
}


@end
