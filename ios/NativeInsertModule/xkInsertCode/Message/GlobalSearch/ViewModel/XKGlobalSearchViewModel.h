/*******************************************************************************
 # File        : XKGlobalSearchViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/6
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
#import <NIMKit.h>
#import "XKContactModel.h"

@class XKGlobalSearchLocalInfo;

@interface XKGlobalSearchViewModel : NSObject

@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;
/**<##>*/
@property(nonatomic, copy) void(^searchResult)(void);

/**本地信息搜索结果*/
@property(nonatomic, strong) NSMutableArray <XKGlobalSearchLocalInfo *>*localSearchDataArray;
/**currentSearchKey*/
@property(nonatomic, copy) NSString *currentSearchKey;

- (void)queryloacalDataWithKeyWord;
- (void)cleanLocalResult;
- (BOOL)hasSearchResult;

@end


@interface XKGlobalSearchLocalInfo :NSObject

@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

typedef NS_ENUM(NSInteger,XKGlobalSearchResultType) {
    XKGlobalSearchResultTypeGroup = 0 , // 群
    XKGlobalSearchResultTypeChat = 0 , //  聊天
};

@interface XKGlobalSearchResult :NSObject

/**<##>*/
@property(nonatomic, assign) XKGlobalSearchResultType type;

@property(nonatomic, copy) NSString *text;

@property(nonatomic, strong) NIMMessage *message;
@property(nonatomic, strong) XKContactModel *user;

@property(nonatomic, strong) NIMTeam *team;


@end


