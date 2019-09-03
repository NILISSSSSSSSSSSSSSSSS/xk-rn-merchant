/*******************************************************************************
 # File        : XKGroupChatSettingViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/29
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
#import "XKContactModel.h"
#import <NIMSDK/NIMSDK.h>

#define kItemSpace 10
#define kItemTopBtm 15
#define kItemLineNum 5
#define kItemLines 6

#define kItemWidth  ((int)((SCREEN_WIDTH - 10 * 2 - kItemSpace * 2 - (kItemLineNum - 1) * kItemSpace) / kItemLineNum))
#define kItemHeight (kItemWidth + 19)

@class XKGroupChatSettingModel;

@protocol XKGroupChatSettingViewModelDelegate<NSObject>

- (void)refreshTableView;

@end

@interface XKGroupChatSettingViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>

/**是否是官方群*/
@property(nonatomic, assign) BOOL isOffical;
@property (nonatomic, copy) NSString  *merchantType;

@property(nonatomic, copy) NSArray *userAndAddDeleteArray;
@property(nonatomic, copy) NSArray *totalUserAndAddDeleteArray;
@property(nonatomic, assign,readonly) BOOL hasMoreUser;

/**<##>*/
@property(nonatomic, weak) id<XKGroupChatSettingViewModelDelegate> delegate;

@property(nonatomic, strong) NIMSession *session;

/**刷新block*/
@property(nonatomic, copy) void(^refreshTableView)(void);


- (void)registerCellForTableView:(UITableView *)tableView;

- (void)rebuildUserAndAddDeleteArray;
- (void)rebuildTotalUserAndAddDeleteArray;
- (void)resetDataArray;

- (XKGroupChatSettingModel *)getSettingModel;

/**获取设置信息*/
- (void)requestSettingInfoComplete:(void(^)(NSString *error,id data))complete;

- (void)dealCollectionViewClick:(NSIndexPath *)indexPath dataArray:(NSArray *)userAndAddDeleteArray vc:(UIViewController *)controller;
- (void)jumpPersonCenter:(XKContactModel *)model;

@end

@interface XKGroupChatSettingModel: NSObject

@property(nonatomic, strong) NSMutableArray <XKContactModel *>*userArray;
@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, copy) NSString *groupQRCode;
@property(nonatomic, copy) NSString *groupIcon;
@property(nonatomic, copy) NSString *myNickName;
@property(nonatomic, assign) BOOL showNickName;
@property(nonatomic, assign) BOOL topChat;
@property(nonatomic, assign) BOOL msgSlience;
@property(nonatomic, assign) BOOL isOwner; // 群主
@property(nonatomic, assign) BOOL isManager; // 管理员

@end

