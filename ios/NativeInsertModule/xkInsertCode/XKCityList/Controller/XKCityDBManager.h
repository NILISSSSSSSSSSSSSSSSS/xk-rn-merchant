/*******************************************************************************
 # File        : XKCityDBManager.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/21
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
#import "XKCityListModel.h"
#import <FMDB.h>
@interface XKCityDBManager : NSObject{
    
    FMDatabaseQueue *_dbQueue;  // 这个类在多个线程来执行查询和更新时会使用这个类。避免同时访问同一个数据。
    FMDatabasePool *_dbPool;    // 数据库连接池 减少连接开销（这要明确知道不会同一时刻有多个线程去操作数据库，如果会就是用FMDatabaseQueue）
}
/** 是否显示日志打印*/
@property(nonatomic, assign) BOOL isShowDebugLog;
//临时存储列表数据
@property(nonatomic, strong)NSMutableArray *characterMutableArray;
@property(nonatomic, strong)NSMutableArray *sectionMutableArray;
@property(nonatomic, strong)NSMutableArray *historyCityMutableArray;
@property(nonatomic, strong)NSMutableArray *cityMutableArray;
@property(nonatomic, strong)NSMutableArray *hotMutableArray;

+ (XKCityDBManager *)shareInstance;

// 创建表
- (void)createTable;

//获取所有的省份
- (NSArray <DataItem *> *)getAllProvince;

//获取所有的城市
- (NSArray <DataItem *> *)getAllCity;

//通过省份code查城市
- (NSArray <DataItem *> *)getCityWithProvinceCode:(NSString *)provinceCode;

//通过城市code查区县
- (NSArray <DataItem *> *)getDistrictWithCityCode:(NSString *)cityCode;

//通过城市name查code
- (NSString *)getCityCodeWithCityName:(NSString *)cityName;

//通过城市code查城市bname
- (NSString *)getCityNameWithCityCode:(NSString *)cityCode;
/**
 通过城市名字（2级），区县（3级）名字获取code

 @param cityName 城市名字（2级）
 @param DistrictName 区县名字（3级）
 @return code（如果只有区县名字传入，code是区县code。如果只有城市名字传入，code是城市code。如果都传入则返回区县code。都不传入返回为nil）
 */
- (NSString *)getCodeWithCityName:(NSString *)cityName DistrictName:(NSString *)DistrictName;

/**
 通过城市名字（2级）查区县名字（3级）

 @param cityName 城市名字（2级）
 @return 区县（3级）的模型数组
 */
- (NSArray <DataItem *> *)getDistrictNameWithCityName:(NSString *)cityName;


/**
 通过区县名字（3级）查询区县code（3级）

 @param districtName 区县名字（3级）
 @return 区县数组模型（3级）
 */
- (NSArray <DataItem *> *)getDistrictCodeWithDistrictName:(NSString *)districtName;

//所有城市添加数据
- (void)insertCityDataInTable:(DataItem *)model;

//所有城市更新数据
- (void)updateCityTable:(DataItem *)model;

//省份添加数据
- (void)insertProvinceDataInTable:(DataItem *)model;

//省份更新数据
- (void)updateProvinceTable:(DataItem *)model;

//地区添加数据
- (void)insertDistrictDataInTable:(DataItem *)model;

//地区更新数据
- (void)updateDistrictTable:(DataItem *)model;
@end
