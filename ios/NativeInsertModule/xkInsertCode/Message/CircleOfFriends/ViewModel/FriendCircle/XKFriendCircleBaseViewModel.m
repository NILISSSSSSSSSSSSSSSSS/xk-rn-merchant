/*******************************************************************************
 # File        : XKFriendCircleBaseModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleBaseViewModel.h"
#import "XKFriendsTalkDateCell.h"

#import "XKFriendTalkModel.h"
#import "XKCommentInputView.h"
#import <IQKeyboardManager.h>
#import "XKFriendTalkReplyCell.h"
#import "XKFriendCircleFooterView.h"
#import "XKFriendTalkDetailController.h"

static NSString *const normalTextCellId = @"normalTextCellId";
static NSString *const imgTextCellId = @"imgTextCellId";
static NSString *const replyCellId = @"replyCellId";

#define kMaxReply 2

@interface XKFriendCircleBaseViewModel() {
    NSMutableDictionary *_cellHightDict;
}

@end

@implementation XKFriendCircleBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self supreCreateDefaultData];
    }
    return self;
}

- (void)supreCreateDefaultData {
    _dataArray = [NSMutableArray array];
    _cellHightDict = [NSMutableDictionary dictionary];
    _page = 1;
    _limit = 20;
}

- (void)registerCellForTableView:(UITableView *)tableView {
    // 子类重写
}

- (void)requestDelete:(NSString *)did Complete:(void (^)(NSString *err, id data))completeBlock {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"did"] = did;
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/friendCircleDynamicDelete/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(completeBlock,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(completeBlock,error.message,nil);
    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section + 1 > self.dataArray.count) {
        return 0;
    }
    XKFriendTalkModel *model = self.dataArray[section];
    return (model.comments.count > kMaxReply ? kMaxReply : model.comments.count) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // 子类实现
    static NSString *rid=@"";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section + 1 > self.dataArray.count) {
        return CGFLOAT_MIN;
    }
    XKFriendTalkModel *model = self.dataArray[section];
    if (model.comments.count > kMaxReply) {
        return 55;
    }
    if (model.comments.count > 0) {
        return 24;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEX_RGB(0xEEEEEE);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XKFriendTalkModel *model = self.dataArray[section];
    XKFriendCircleFooterView *footerView;
    if (model.comments.count > kMaxReply) {
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        if(!footerView){
            footerView = [[XKFriendCircleFooterView alloc] initWithReuseIdentifier:@"footer"];
        }
    }
    if (model.comments.count > 0 ) {
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"emptyFooter"];
        if(!footerView){
            footerView = [[XKFriendCircleFooterView alloc] initWithReuseIdentifier:@"emptyFooter"];
            footerView.label.hidden = YES;
        }
    }
    
    if (section == self.dataArray.count - 1) {
        footerView.containView.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        footerView.containView.xk_clipType = XKCornerClipTypeNone;
    }
    footerView.index = section;
    __weak typeof(self) weakSelf = self;
    [footerView setClick:^(NSInteger index) {
        XKFriendTalkModel *model = self.dataArray[index];
        XKFriendTalkDetailController *vc = [XKFriendTalkDetailController new];
        vc.did = model.did;
        [vc setTalkDetailChange:^(XKFriendTalkModel *talkModel) {
            [weakSelf.dataArray replaceObjectAtIndex:index withObject:talkModel];
            weakSelf.refreshTableView();
        }];
        [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
    }];
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_cellHightDict setObject:@(cell.frame.size.height) forKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[_cellHightDict objectForKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]] floatValue];
    if (height == 0) {
        return 100;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    EXECUTE_BLOCK(self.scrollViewScroll,scrollView)
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
