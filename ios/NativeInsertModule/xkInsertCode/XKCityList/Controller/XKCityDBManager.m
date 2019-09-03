/*******************************************************************************
 # File        : XKCityDBManager.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/21
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCityDBManager.h"
#import <YYModel.h>
#define TableAllCity                    @"TableAllCity"
#define TableProvince                   @"TableProvince"
#define TableDistrict                   @"TableDistrict"

#define TableCode                       @"code"
#define TableName                       @"name"
#define TableParentCode                 @"parentCode"
#define TableLevel                      @"level"

@implementation XKCityDBManager
static XKCityDBManager *manager = nil;
+ (XKCityDBManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

// 创建表
- (void)createTable {
//    NSString* docuPath =  [self _getAppDocumentPath];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:docuPath]) { // 如果不存在直接创建
//
//        [[NSFileManager defaultManager] createDirectoryAtPath:docuPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    NSString *path = [NSString stringWithFormat:@"%@/%@",docuPath,@"XKCityList.sqlite"];
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *txtPath =[documentsDirectory stringByAppendingPathComponent:@"XKCityList.sqlite"];
    if([fileManager fileExistsAtPath:txtPath] == NO){
        NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"XKCityList" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    // 新建数据库并打开
    NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"XKCityList.sqlite"];
    if (self.isShowDebugLog) {
        NSLog(@"create--XKCityList-- path == %@ ",path);
    }
    _dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    _dbPool = [[FMDatabasePool alloc] initWithPath:path];
    [self createAllTables];
}

- (void)createAllTables {
    //所有城市
    [self createCityTable];
    //省份
    [self createProvinceTable];
    //区县
    [self createDistrictTable];
}

#pragma mark 所有城市
- (void)createCityTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        if ([db tableExists:TableAllCity]) {}else{
            NSString *sql = [NSString stringWithFormat:
                             @"CREATE TABLE IF NOT EXISTS %@ ( "
                             "%@ TEXT, "
                             "%@ TEXT, "
                             "%@ TEXT"
                             " ); ",
                             TableAllCity,
                             TableCode,
                             TableName,
                             TableParentCode
                             ];
            if (self.isShowDebugLog) {
                NSLog(@"%@",sql);
            }
            BOOL result = [db executeUpdate:sql];
            
            if (result) {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableCity success");
                }
            } else {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableCity failed");
                }
            }
        }
    }];
}
- (void)insertCityDataInTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?); ",
                               TableAllCity,
                               TableCode,
                               TableName,
                               TableParentCode
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name,
                                        model.parentCode
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"save TableCity success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"save TableCity failed");
            }
            return;
        }
        
    }];
}

- (void)updateCityTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;",TableAllCity,TableCode];
        whoopsSomethingWrongHappened = [db executeUpdate:deleteSql,model.code];
        if (!whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"delete TableCity failed");
            }
        }
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?); ",
                               TableAllCity,
                               TableCode,
                               TableName,
                               TableParentCode
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name,
                                        model.parentCode
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"update TableCity success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"update TableCity failed");
            }
            *rollback = YES;
            return;
        }
        
    }];
}

- (NSArray<DataItem *> *)getCityWithProvinceCode:(NSString *)provinceCode{
    __block NSMutableArray * modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ;",TableAllCity,TableParentCode];
        FMResultSet* resultSet = [db executeQuery:selectSql,provinceCode];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            [modelArray addObject:model];
        }
        [resultSet close];
    }];
    return [modelArray copy];
}

- (NSArray<DataItem *> *)getAllCity {
    __block NSMutableArray * modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ ;",TableAllCity];
        FMResultSet* resultSet = [db executeQuery:selectSql];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            [modelArray addObject:model];
        }
        [resultSet close];
    }];
    return [modelArray copy];
}

- (NSString *)getCityCodeWithCityName:(NSString *)cityName {
    __block NSString * cityCode = @"";
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",TableAllCity,TableName];
        FMResultSet* resultSet = [db executeQuery:selectSql,cityName];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            cityCode = model.code;
        }
        [resultSet close];
    }];
    return cityCode;
}

- (NSString *)getCityNameWithCityCode:(NSString *)cityCode {
    __block NSString * cityName = @"";
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",TableAllCity,TableCode];
        FMResultSet* resultSet = [db executeQuery:selectSql,cityCode];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            cityName = model.name;
        }
        [resultSet close];
    }];
    return cityName;
}

#pragma mark 所有省份

- (void)createProvinceTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        if ([db tableExists:TableProvince]) {}else{
            NSString *sql = [NSString stringWithFormat:
                             @"CREATE TABLE IF NOT EXISTS %@ ( "
                             "%@ TEXT, "
                             "%@ TEXT"
                             " ); ",
                             TableProvince,
                             TableCode,
                             TableName
                             ];
            if (self.isShowDebugLog) {
                NSLog(@"%@",sql);
            }
            BOOL result = [db executeUpdate:sql];
            
            if (result) {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableProvince success");
                }
            } else {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableProvince failed");
                }
            }
        }
    }];
}

- (void)insertProvinceDataInTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?); ",
                               TableProvince,
                               TableCode,
                               TableName
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"save TableProvince success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"save TableProvince failed");
            }
            return;
        }
        
    }];
}
- (void)updateProvinceTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;",TableProvince,TableCode];
        whoopsSomethingWrongHappened = [db executeUpdate:deleteSql,model.code];
        if (!whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"delete TableProvince failed");
            }
        }
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?); ",
                               TableProvince,
                               TableCode,
                               TableName
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name,
                                        model.parentCode
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"update TableProvince success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"update TableProvince failed");
            }
            *rollback = YES;
            return;
            
        }
        
    }];
}


- (NSArray<DataItem *> *)getAllProvince {
    __block NSMutableArray * modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ ;",TableProvince];
        FMResultSet* resultSet = [db executeQuery:selectSql];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            [modelArray addObject:model];
        }
        [resultSet close];
    }];
    return [modelArray copy];
}
#pragma mark 所有区县

- (void)createDistrictTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        if ([db tableExists:TableDistrict]) {}else{
            NSString *sql = [NSString stringWithFormat:
                             @"CREATE TABLE IF NOT EXISTS %@ ( "
                             "%@ TEXT, "
                             "%@ TEXT, "
                             "%@ TEXT, "
                             "%@ TEXT"
                             " ); ",
                             TableDistrict,
                             TableCode,
                             TableName,
                             TableLevel,
                             TableParentCode
                             ];
            if (self.isShowDebugLog) {
                NSLog(@"%@",sql);
            }
            BOOL result = [db executeUpdate:sql];
            
            if (result) {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableDistrict success");
                }
            } else {
                if (self.isShowDebugLog) {
                    NSLog(@"create TableDistrict failed");
                }
            }
        }
    }];
}


- (void)insertDistrictDataInTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?,?); ",
                               TableDistrict,
                               TableCode,
                               TableName,
                               TableLevel,
                               TableParentCode
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name,
                                        model.level,
                                        model.parentCode
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"save TableDistrict success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"save TableDistrict failed");
            }
            return;
        }
        
    }];
}

- (void)updateDistrictTable:(DataItem *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;",TableDistrict,TableCode];
        whoopsSomethingWrongHappened = [db executeUpdate:deleteSql,model.code];
        if (!whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"delete TableCity failed");
            }
        }
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?,?); ",
                               TableDistrict,
                               TableCode,
                               TableName,
                               TableLevel,
                               TableParentCode
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.code,
                                        model.name,
                                        model.level,
                                        model.parentCode
                                        ];
        if (whoopsSomethingWrongHappened) {
            if (self.isShowDebugLog) {
                NSLog(@"update TableDistrict success");
            }
        } else {
            if (self.isShowDebugLog) {
                NSLog(@"update TableDistrict failed");
            }
            *rollback = YES;
            return;
        }
        
    }];
}

- (NSArray<DataItem *> *)getDistrictWithCityCode:(NSString *)cityCode {
    __block NSMutableArray * modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ;",TableDistrict,TableParentCode];
        FMResultSet* resultSet = [db executeQuery:selectSql,cityCode];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            [modelArray addObject:model];
        }
        [resultSet close];
    }];
    return [modelArray copy];
}

- (NSArray <DataItem *> *)getDistrictNameWithCityName:(NSString *)cityName {
    //获取cityName的code
    NSString *cityCode = [self getCityCodeWithCityName:cityName];
    //通过城市code获取区县
    NSArray *districtModelArray = [self getDistrictWithCityCode:cityCode];
    return districtModelArray;
}


- (NSArray<DataItem *> *)getDistrictCodeWithDistrictName:(NSString *)districtName {
    __block NSMutableArray * modelArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ;",TableDistrict,TableName];
        FMResultSet* resultSet = [db executeQuery:selectSql,districtName];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            if (self.isShowDebugLog) {
                NSLog(@"BB = %@",bb);
            }
            DataItem* model = [DataItem yy_modelWithDictionary:bb];
            [modelArray addObject:model];
        }
        [resultSet close];
    }];
    return [modelArray copy];
}

- (NSString *)getCodeWithCityName:(NSString *)cityName DistrictName:(NSString *)districtName {
    NSString *code;
    //都没有值，返回nil
    if ((cityName == nil) && (districtName == nil)) {
        return nil;
    }
    //都有值返回区县code
    if (!(cityName ==nil) && !(districtName == nil)) {
        //获取cityName的code
        NSArray *districtModelArray = [self getDistrictNameWithCityName:cityName];
        for (DataItem *model in districtModelArray) {
            if ([districtName isEqualToString:model.name]) {
                return model.code;
            }
        }
    }
    //只有区县的名字，返回区县code
    if ((cityName == nil) && !(districtName == nil)) {
        NSArray *districtModelArray = [self getDistrictCodeWithDistrictName:districtName];
        DataItem *model = districtModelArray.firstObject;
        return model.code;
    }
    //只有城市名字，返回城市code
    if (!(cityName == nil) && (districtName == nil)) {
        return [self getCityCodeWithCityName:cityName];
    }
    return code;
}
#pragma mark 公共方法



#pragma mark 私有函数
-(NSString *)_getAppDocumentPath {
    
    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        result = [NSString stringWithFormat:@"%@",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}
@end
