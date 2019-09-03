/*******************************************************************************
 # File        : XKContactBaseViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
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
#import "UIView+XKCornerRadius.h"
#import "XKContactListCell.h"
#import "UTPinYinHelper.h"
#import "XKContactModel.h"


typedef NS_ENUM(NSInteger,XKContactUseType) {
    XKContactUseTypeNormal = 0, // 正常状态
    XKContactUseTypeNormalForAddSecret  = 1, // 用于添加密友的正常状态
    XKContactUseTypeSingleSelect  = 2, //单选状态
    XKContactUseTypeManySelect    = 3, // 多选状态
    XKContactUseTypeSingleSelectWithoutCheck = 4, //单选状态不带钩
    XKContactUseTypeUseOutDateAndManySelected = 5//使用外部数据源 并且多选
};


@interface XKContactBaseViewModel : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
/**实际数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**搜索数据源 */
@property(nonatomic, strong, readonly) NSMutableArray *searchResultArray;
/**索引数组 buildData生成*/
@property(nonatomic, copy, readonly) NSArray *indexArray;
/**分区数据 buildData生成*/
@property(nonatomic, copy, readonly) NSArray *sectionDataArray;

/**密友业务*/
@property(nonatomic, assign) BOOL isSecret;

@property(nonatomic, assign) XKContactUseType useType;
/**操作按钮点击*/
@property(nonatomic, copy) void(^operationBlock)(NSIndexPath *indexPath,XKContactModel *model);
/**刷新*/
@property(nonatomic, copy) void(^refreshBlock)(void);
@property(nonatomic, copy) void(^searchStatusChangeBlock)(void);
/**搜索状态*/
@property(nonatomic, assign) BOOL searchStatus;

/**排序显示的数据源*/
- (void)buildData;

- (void)textFieldChange:(UITextField *)textField;
// 按首字母分组排序数组
- (NSMutableArray *)sortObjectsIndexArray:(NSArray **)idxArray dataArray:(NSArray *)dataArray;
// 数据删选
- (BOOL)compareStr:(NSString *)str containStr:(NSString *)containStr;

@end
