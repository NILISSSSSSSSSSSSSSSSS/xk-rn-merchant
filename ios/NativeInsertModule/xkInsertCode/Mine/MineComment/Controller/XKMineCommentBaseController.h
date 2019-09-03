/*******************************************************************************
 # File        : XKMineCommentBaseController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"
#import "XKGoodsAndCommentView.h"
#import "XKCommentCommonCell.h"
#import "XKCommentInputView.h"

@protocol XKMineCommentBaseControllerProtocol
#pragma mark - 子类实现 帮cell赋值
- (void)refreshCell:(XKCommentCommonCell *)cell forIndexPath:(NSIndexPath *)indexPath;
#pragma mark - 子类实现 实现数据请求并回调
- (void)requestIsRefresh:(BOOL)isRefresh params:(NSMutableDictionary *)params complete:(void(^)(NSString *error,NSArray *array))complete;
#pragma mark - 子类实现 处理cell 的点击事件
- (void)dealCellClick:(NSIndexPath *)indexPath;
#pragma mark - 子类实现 处理cell 回复点击 处理弹出回复框
- (void)reply:(NSIndexPath *)indexPath;
#pragma mark - 子类实现 发送回复 事件 内容在commentInfo取
- (void)sendComment;


@end

@interface XKMineCommentBaseController : BaseViewController <XKMineCommentBaseControllerProtocol>

/**评论输入框*/
@property(nonatomic, strong) XKCommentInputView *replyView;
/**评论缓存*/
@property(nonatomic, strong) XKCommentInputInfo *commentInfo;

/**通过判断取*/
- (NSArray *)dataArray;
/**回复数据源*/
@property(nonatomic, strong) NSMutableArray *dataArrayForReply;
/**我的评论数据源*/
@property(nonatomic, strong) NSMutableArray *dataArrayForMyComment;
/**当前segment坐标*/
@property(nonatomic, assign) NSInteger segmentIdnex;
/**是否是展示回复我的*/
- (BOOL)isShowReply;

/**第一次请求*/
- (void)requestFirst;
/**刷新*/
- (void)requestRefresh;

- (void)cleanInput;


@end
