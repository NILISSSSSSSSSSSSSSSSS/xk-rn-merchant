/*******************************************************************************
 # File        : XKCollectVideoModel.h
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

@interface XKCollectVideoModelTarget :NSObject
@property (nonatomic , copy) NSString              * targetId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * showPics;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , assign) NSInteger              countFavorite;

@end


@interface XKCollectVideoModelDataItem :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) XKCollectVideoModelTarget              * target;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * xkModule;
@property (nonatomic , assign) BOOL              isSelected;

@end


@interface XKCollectVideoModel :NSObject
@property (nonatomic , strong) NSArray <XKCollectVideoModelDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end
