/*******************************************************************************
 # File        : XKReceiptInfoViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKReceiptInfoModel.h"
typedef NS_ENUM(NSInteger,XKReceiptInfoCellType) {
    XKReceiptInfoCellTypeSegment = 0, // 切换
    XKReceiptInfoCellTypeTitle, // 抬头
    XKReceiptInfoCellTypeTaxNum, // 税号
    XKReceiptInfoCellTypeAddr, // 地址
    XKReceiptInfoCellTypeBank, // 银行
    XKReceiptInfoCellTypeBankNum, // 银行账号
    XKReceiptInfoCellTypeDefault // 默认
};

@interface XKReceiptInfoViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>

/**edit状态*/
@property(nonatomic, assign) BOOL editStatus;

- (void)regisCellFor:(UITableView *)tableView;

- (void)setEditReceiptId:(NSString *)editId; // 要么传id

/**提交信息*/
- (void)requestUploadReceipt:(void (^)(NSString *, id))response;
/**删除*/
- (void)requestDeleteReceipt:(void (^)(NSString *, id))response;
/**请求信息*/
- (void)requestReceiptInfo:(void (^)(NSString *, id))response;
/**修改信息*/
- (void)requestUpdateReceiptInfo:(void (^)(NSString *, id))response;

/**检测数据*/
- (BOOL)checkData;
/**refresh*/
@property(nonatomic, copy) void(^refreshBlock)(void);

@end
