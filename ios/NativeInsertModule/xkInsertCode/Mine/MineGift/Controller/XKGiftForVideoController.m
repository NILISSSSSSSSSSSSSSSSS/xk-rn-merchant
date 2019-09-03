/*******************************************************************************
 # File        : XKGiftForVideoController.m
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

#import "XKGiftForVideoController.h"
#import "XKVideoGiftCell.h"
#import "XKGiftVideoModel.h"
@interface XKGiftForVideoController ()
@end

@implementation XKGiftForVideoController

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
    XKGiftVideoModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.nickName;
    [cell.headImageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    [cell.infoView.imgView sd_setImageWithURL:kURL(model.receiver.avatar) placeholderImage:kDefaultPlaceHolderImg];
    cell.infoView.nameLabel.text = [NSString stringWithFormat:@"@%@",model.receiver.nickName];
    cell.infoView.infoLabel.text = model.receiver.content;
    [cell setGiftType:model.getGiftArr];
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
