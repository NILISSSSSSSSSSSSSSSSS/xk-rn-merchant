/*******************************************************************************
 # File        : XKGoodsAllCommentViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsAllCommentViewModel.h"
#import "XKGoodsCommentCell.h"
#import "XKGoodsCommentModel.h"
#import "XKCommentDetailBaseController.h"
#import "XKWelfareCommentModel.h"

@interface  XKGoodsAllCommentViewModel () {
    NSMutableDictionary * _estimatedRowHeightCache;
}

/**请求参数*/
@property(nonatomic, strong) NSMutableDictionary *params;
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;

@end


@implementation XKGoodsAllCommentViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)createDefault {
    _estimatedRowHeightCache = @{}.mutableCopy;
    _limit = 20;
    _page = 1;
    _dataArray = [NSMutableArray array];
    _labelDataArray = [NSMutableArray array];
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKGoodsCommentCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 网络请求
#pragma mark - 请求
- (void)requestIsRefresh:(BOOL)isRefresh tag:(NSString *)tag complete:(void(^)(NSString *error,NSArray *array))complete {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        [params setObject:@(1) forKey:@"page"];
    } else {
        [params setObject:@(self.page + 1) forKey:@"page"];
    }
    self.tag = tag;
    [params setObject:@(_limit) forKey:@"limit"];
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    if ([self.tag isEqualToString:@"all"]) {
        //
    } else {
        params[@"type"] = self.tag;
    }
    
    params[@"goodsId"] = self.goodsId;
    
    self.params = params; // 保存一下最新请求的参数
    [self requestWithParams:params block:^(NSString *error, id data) {
        // 这里进行请求相应的判断
        // 多种标签切换请求时 会有相应先后顺序 应该过滤掉之前的相应 以免数据错乱
        if (self.params != params) {
            NSLog(@"网络响应结果丢弃");
            return ;
        }
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
        
            NSArray *array = [NSArray yy_modelArrayWithClass:[self getModelClass] json:[data xk_jsonToDic][@"data"]];
            if (isRefresh) {
                self.page = 1;
            } else {
                self.page += 1;
            }
            
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if (array.count < self.limit) {
                self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            } else {
                self.refreshStatus = Refresh_HasDataAndHasMoreData;
            }
           
            [self.dataArray addObjectsFromArray:array];
            EXECUTE_BLOCK(complete,nil,array);
        }
    }];
}

- (Class)getModelClass {
    if (self.type == XKAllCommentTypeForGoods) {
        return [XKGoodsCommentModel class];
    } else {
        return [XKWelfareCommentModel class];
    }
}

- (void)requestCommentLabelComplete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"goodsId"] =  self.goodsId;
    NSString *url = @"";
    if (self.type == XKAllCommentTypeForGoods) {
        url = @"im/ua/mallGoodsCommentLabels/1.0";
    } else {
        url = @"im/ua/jGoodsCommentLabels/1.0";
    }
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        [self.labelDataArray removeAllObjects];
        [self.labelDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKCommentLabelModel class] json:responseObject]];
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}


- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    NSString *url = @"";
    if (self.type == XKAllCommentTypeForGoods) {
        url = @"im/ua/mallGoodsCommentList/1.0";
    } else {
        url = @"im/ua/jmallGoodsCommentList/1.0";
    }
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}

#pragma mark - 处理cell点击
- (void)dealCellClick:(NSIndexPath *)indexPath {
    if (self.type == XKAllCommentTypeForWelfare) {

    }
}

#pragma mark - tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    XKGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell setRefreshBlock:^(NSIndexPath *indexPath) {
        weakSelf.reloadData();
    }];
    [self refreshCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)refreshCell:(XKGoodsCommentCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (self.type == XKAllCommentTypeForGoods) {
        XKGoodsCommentModel *model = self.dataArray[indexPath.row];
        [cell.headImageView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.nameLabel.text = model.commenter.nickname;
        cell.timeLabel.text = [NSString stringWithFormat:@"%@  %@",model.getDisplayTime,model.goods.skuValue];
        cell.desLabel.text = model.content;
        cell.userId = model.commenter.userId;
        cell.showOperationBtn = YES;
        [cell setOperationBtnClick:^(NSIndexPath *indexPath) {
            XKGoodsCommentModel *model = weakSelf.dataArray[indexPath.row];
            XKCommentDetailBaseController *vc = [XKCommentDetailBaseController new];
            vc.detailType = XKCommentDetailTypeGoods;
            vc.commentId = model.commentId;
            [[weakSelf getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
        cell.model = model;
    } else {
        XKWelfareCommentModel *model = self.dataArray[indexPath.row];
        [cell.headImageView sd_setImageWithURL:kURL(model.commenter.avatar) placeholderImage:kDefaultHeadImg];
        cell.nameLabel.text = model.commenter.nickname;
        cell.nameLabel.textColor = RGBGRAY(51);
        cell.timeLabel.text = [NSString stringWithFormat:@"中奖时间： %@",model.getDisplayTime];
        cell.desLabel.text = model.content;
        cell.desLabel.textColor = RGBGRAY(151);
        cell.userId = model.commenter.userId;
        cell.showOperationBtn = YES;
        [cell setOperationBtnClick:^(NSIndexPath *indexPath) {
            XKWelfareCommentModel *model = weakSelf.dataArray[indexPath.row];
            XKCommentDetailBaseController *vc = [XKCommentDetailBaseController new];
            vc.detailType = XKCommentDetailTypeWelfare;
            vc.commentId = model.commentId;
            [[weakSelf getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
        cell.model = model;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataArray].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dealCellClick:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

#pragma mark - 解决动态cell高度 reloadData刷新抖动的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   _estimatedRowHeightCache[indexPath] = @(cell.frame.size.height);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_estimatedRowHeightCache[indexPath] floatValue] + 1; // 不要返回0 否则可能没cell
}

@end
