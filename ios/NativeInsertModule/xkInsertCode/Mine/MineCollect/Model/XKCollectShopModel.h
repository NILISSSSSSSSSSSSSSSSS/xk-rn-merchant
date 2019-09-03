/*******************************************************************************
 # File        : XKCollectShopModel.h
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

@interface XKCollectShopModelTarget :NSObject
@property (nonatomic , assign) NSInteger              mouthCount;
@property (nonatomic , copy) NSString              * lng;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * showPics;
@property (nonatomic , assign) NSInteger              avgConsumption;
@property (nonatomic , assign) NSInteger              starLevel;
@property (nonatomic , strong) NSArray <NSString *>              * typeList;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * targetId;

@end


@interface XKCollectShopModelDataItem :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) XKCollectShopModelTarget              * target;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * xkModule;
@property (nonatomic , assign) BOOL              isSelected;
@property (nonatomic , assign) BOOL              isSendSelected;

@end


@interface XKCollectShopModel :NSObject
@property (nonatomic , strong) NSArray <XKCollectShopModelDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end
