/*******************************************************************************
 # File        : XKCityListModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/17
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

@interface DataItem :NSObject

/**
 拼音
 */
@property (nonatomic , copy) NSString              * cnSequence;
/**
 代码
 */
@property (nonatomic , copy) NSString              * code;
/**
 id
 */
@property (nonatomic , copy) NSString              * ID;
/**
 是否热门
 */
@property (nonatomic , assign) NSInteger              isHot;
/**
 纬度
 */
@property (nonatomic , copy) NSString              * latitude;
/**
 级别 1：省份 2：城市 3：区/县
 */
@property (nonatomic , copy) NSString              *level;
/**
 经度
 */
@property (nonatomic , copy) NSString              * longitude;
/**
 名称
 */
@property (nonatomic , copy) NSString              * name;
/**
 上级代码
 */
@property (nonatomic , copy) NSString              * parentCode;

@end


@interface XKCityListModel :NSObject
@property (nonatomic , strong) NSArray <DataItem *>              * data;
@property (nonatomic , strong) NSArray <DataItem *>              * provinceList;
@property (nonatomic , strong) NSArray <DataItem *>              * districtList;
@property (nonatomic , strong) NSArray <DataItem *>              * cityList;
@property (nonatomic , copy) NSString              * provinceVersion;
@property (nonatomic , copy) NSString              * cityVersion;
@property (nonatomic , copy) NSString              * districtVersion;
@property (nonatomic , copy) NSString              * v;

@end
