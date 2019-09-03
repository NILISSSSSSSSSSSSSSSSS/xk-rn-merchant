/*******************************************************************************
 # File        : XKSearchListModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/25
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

@interface XKSearchDataItem :NSObject
@property (nonatomic , copy) NSString              * cnSequence;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              isHot;
@property (nonatomic , assign) NSInteger              isMunicipality;
@property (nonatomic , copy) NSString              * latitude;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * longitude;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * parentCode;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              updatedAt;

@end


@interface XKSearchListModel :NSObject
@property (nonatomic , strong) NSArray <XKSearchDataItem *>              *data;
@property (nonatomic , assign) NSInteger              total;

@end

