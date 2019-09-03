/*******************************************************************************
 # File        : XKCollectGamesModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/26
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
@interface XKCollectGamesModelTarget :NSObject
@property (nonatomic , copy) NSString              * targetId;
@property (nonatomic , copy) NSString              * typeList;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              popularity;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * showPics;

@end


@interface XKCollectGamesModelDataItem :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) XKCollectGamesModelTarget              * target;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * xkModule;
@property (nonatomic , assign) BOOL              isSelected;
@property (nonatomic , assign) BOOL              isSendSelected;

@end


@interface XKCollectGamesModel :NSObject
@property (nonatomic , strong) NSArray <XKCollectGamesModelDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end
