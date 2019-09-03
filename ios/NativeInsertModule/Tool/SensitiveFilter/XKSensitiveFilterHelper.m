/*******************************************************************************
 # File        : XKSensitiveFilterHelper.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2019/4/1
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSensitiveFilterHelper.h"
#import <stdio.h>

static NSString *XKSensitiveVIEDO = @"VIDEO";
static NSString *XKSensitiveKEYOU = @"KEYOU";
static NSString *XKSensitiveBCIRCLE = @"BCIRCLE";

static NSString *XKSensitiveVideoFileName = @"CensorWordsForVideo.txt";
static NSString *XKSensitiveKeyouFileName = @"CensorWordsForKeyou.txt";
static NSString *XKSensitiveBcircleFileName = @"CensorWordsForBcircle.txt";

static NSString *XKSensitiveVersionFileName =  @"CensorWordsVersion.plist";


@interface XKSensitiveInfo:NSObject
/**
 VIEDO    String    小视频
 KEYOU    String    可友圈
 BCIRCLE  String    商圈
 */
@property(nonatomic, copy) NSString *wordLibraryType;
@property(nonatomic, copy) NSString *docUrl;
@property(nonatomic, copy) NSString *docName;
@property(nonatomic, copy) NSString *version;

/**辅助字段*/
@property(nonatomic, strong) NSString *fileName;

@end
@implementation XKSensitiveInfo

- (NSString *)fileName {
    if ([self.wordLibraryType isEqualToString:XKSensitiveVIEDO]) {
        return XKSensitiveVideoFileName;
    }
    if ([self.wordLibraryType isEqualToString:XKSensitiveKEYOU]) {
        return XKSensitiveKeyouFileName;
    }
    if ([self.wordLibraryType isEqualToString:XKSensitiveBCIRCLE]) {
        return XKSensitiveBcircleFileName;
    }
    return nil;
}

@end

@interface XKSensitiveFilterHelper()

@property (nonatomic,strong) NSMutableDictionary *censorWordsCache; // 正常敏感词缓存
@property (nonatomic,strong) NSMutableDictionary *censorWordsForVideoCache; // 针对于小视频的敏感词缓存
@property (nonatomic,strong) NSMutableDictionary *censorWordsForBcircleCache; // 针对于商品的敏感词缓存
@property (nonatomic,strong) NSMutableDictionary *versionDic; // 词库版本
/**<##>*/
@property(nonatomic, strong)  NSFileManager *manger;
@end

@implementation XKSensitiveFilterHelper

static XKSensitiveFilterHelper * _instance = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XKSensitiveFilterHelper alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manger = [NSFileManager defaultManager];
        self.censorWordsCache = [NSMutableDictionary dictionary];
        self.censorWordsForVideoCache = [NSMutableDictionary dictionary];
        self.censorWordsForBcircleCache = @{}.mutableCopy;
        // 针对首次安装，将默认敏感词拷贝至沙盒
        [self copyBundleToDiskFileIfNeed];
        // 针对二次安装（更新） 检查工程bundle有无更新词库版本
        [self checkBundleVersion];
        // 将数据换缓存到内存，并转化为后续使用的格式
        [self converDiskToMemory];
        // 检查网络更新 下次生效
        [self checkUpdate];

    }
    return self;
}

#pragma mark - --------------------词库更新机制逻辑-------------------

#pragma mark - 本地没有敏感词库 将工程默认数据放入本地文件
- (void)copyBundleToDiskFileIfNeed {
    [self copyBundleFileTopDisk:XKSensitiveKeyouFileName needRecover:NO];
    [self copyBundleFileTopDisk:XKSensitiveVideoFileName needRecover:NO];
    [self copyBundleFileTopDisk:XKSensitiveBcircleFileName needRecover:NO];
    [self copyBundleFileTopDisk:XKSensitiveVersionFileName needRecover:NO];
}

- (void)checkBundleVersion {
    // 比较bundle plist 和DISK plist 存的版本
    NSString *bundleVersionPath = [[NSBundle mainBundle] pathForResource:XKSensitiveVersionFileName ofType:nil];
    NSMutableDictionary *bundleVersionDic = [NSMutableDictionary dictionaryWithContentsOfFile:bundleVersionPath];
    [bundleVersionDic enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSString * bundleVerison, BOOL * _Nonnull stop) {
        NSString *localVersion = self.versionDic[fileName];
        if (localVersion == nil || [localVersion compare:bundleVerison] == NSOrderedAscending) { // 沙盒无版本 代表 新增了词库。 升序代表bundle中的词库比沙盒新
            [self copyBundleFileTopDisk:fileName needRecover:YES];
            [self updateLocalVersion:fileName version:bundleVerison];
        }
    }];
}

#pragma mark - 本地信息放入内存
- (void)converDiskToMemory {
    [self convertDiskFile:XKSensitiveKeyouFileName toMemoryCache:self.censorWordsCache];
    [self convertDiskFile:XKSensitiveVideoFileName toMemoryCache:self.censorWordsForVideoCache];
    [self convertDiskFile:XKSensitiveBcircleFileName toMemoryCache:self.censorWordsForBcircleCache];
}

#pragma mark - 检查更新
- (void)checkUpdate {
    [HTTPClient getEncryptRequestWithURLString:@"sys/ua/sensitiveWordLibraryDetail/2.0.13" timeoutInterval:20 parameters:nil success:^(id responseObject) {
        NSArray *netVersions = [NSArray yy_modelArrayWithClass:[XKSensitiveInfo class] json:responseObject];
        // 比较
        for (XKSensitiveInfo *netVersion in netVersions) {
            NSString *fileName = netVersion.fileName;
            if (fileName.length != 0) { // 是需要的文件
                NSString *localVersion = self.versionDic[fileName];
                if (netVersion.version.length != 0 && [localVersion compare:netVersion.version] == NSOrderedAscending) { // 升序代表网络中的词库比沙盒新
                    // 网络下载新的并缓存版本
                    [self downloadNewCensorwordsWithPath:netVersion.docUrl fileName:fileName version:netVersion.version];
                }
            }
        }
    } failure:^(XKHttpErrror *error) {
        NSLog(@"更新敏感词接口error:%@",error);
    }];
}

// 下载文件操作
- (void)downloadNewCensorwordsWithPath:(NSString *)path fileName:(NSString *)fileName version:(NSString *)verison {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        [self.manger removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName] error:nil];
        return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            NSString *targetPath = [[self getCachePath] stringByAppendingPathComponent:fileName];
            [self.manger removeItemAtPath:targetPath error:nil];
            NSError *err;
            [self.manger moveItemAtPath:filePath.relativePath toPath:targetPath  error:&err];
            if (!err) {
               [self updateLocalVersion:fileName version:verison];
               [self converDiskToMemory];
            } else {
                NSLog(@"网络文件复制出错%@",err);
            }
        } else {
            NSLog(@"下载新词库失败:%@",error);
        }
    }];
    [downloadTask resume];
}

- (void)converVesionToMemory {
    [self versionDic];
}

// 复制文件到沙盒 如已经存在 不会替换，要想替换needRecover = yes
- (void)copyBundleFileTopDisk:(NSString *)fileName needRecover:(BOOL)needRecover {
    if (needRecover) {
        NSError *err;
        [self.manger removeItemAtPath:[[self getCachePath] stringByAppendingPathComponent:fileName] error:&err];
        if (err) {
            NSLog(@"%@", err.localizedDescription)
        }
    }
    if (![self.manger fileExistsAtPath:[[self getCachePath] stringByAppendingPathComponent:fileName]]) {
        [self copyBundleFileToDiskFileWithFileName:fileName];
    }
}

-  (void)copyBundleFileToDiskFileWithFileName:(NSString *)name {
    NSError *error;
    [self.manger copyItemAtURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:nil]] toURL:[NSURL fileURLWithPath:[[self getCachePath] stringByAppendingPathComponent:name]] error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription)
    }
}

- (void)updateLocalVersion:(NSString *)fileName version:(NSString *)version {
    @synchronized (self) {
        self.versionDic[fileName] = version;
        [self.versionDic writeToFile:[[self getCachePath] stringByAppendingPathComponent:XKSensitiveVersionFileName] atomically:NO];
    }
}

- (NSString *)getCachePath {
    // 查找指定文件夹有没得敏感词文件
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CensorWords"]; // 路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { // 文件夹不存在
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bo) {
            NSLog(@"%@文件夹创建失败",path);
        }
    }
    return path;
}

- (void)convertDiskFile:(NSString *)fileName toMemoryCache:(NSMutableDictionary *)cache {
    [cache removeAllObjects];
    NSString *filepath = [[self getCachePath] stringByAppendingPathComponent:fileName];
    NSString *dataFile = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataarr = [dataFile componentsSeparatedByString:@"\n"];
    for (NSString *str in dataarr) {
        NSString * insertStr = [str removeSpaceChar];
        if(insertStr.length > 0)
            [self insertWords:insertStr toCache:cache];
    }
}

- (void)insertWords:(NSString *)words toCache:(NSMutableDictionary *)cache {
    NSMutableDictionary *node = cache;
    for (int i = 0; i < words.length; i ++) {
        NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
        
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        node = node[word];
    }
    //敏感词最后一个字符标识
    node[EXIST] = [NSNumber numberWithInt:1];
}

- (NSMutableDictionary *)versionDic {
    if (_versionDic == nil) {
        _versionDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[self getCachePath] stringByAppendingPathComponent:XKSensitiveVersionFileName]];
    }
    return _versionDic;
}

#pragma mark - --------------------敏感词过滤逻辑-------------------

#pragma mark - 敏感词过滤
- (NSString *)filter:(NSString *)str {
    return [self filter:str withCache:self.censorWordsCache];
}

#pragma mark - 敏感词过滤 针对商品评价
- (NSString *)filterForBcircle:(NSString *)str {
    return [self filter:str withCache:self.censorWordsForBcircleCache];
}

#pragma mark - 敏感词过滤针对小视频
- (NSString *)filterForVideo:(NSString *)str {
    return [self filter:str withCache:self.censorWordsForVideoCache];
}

- (NSString *)filter:(NSString *)str withCache:(NSMutableDictionary *)cache {
    
    if (cache == nil) {
        cache = self.censorWordsCache;
    }
    if (self.isFilterClose || !cache) {
        return str;
    }
    
    NSMutableString *result = result = [str mutableCopy];
    
    for (int i = 0; i < str.length; i ++) {
        NSString *subString = [str substringFromIndex:i];
        NSMutableDictionary *node = [cache mutableCopy] ;
        int num = 0;
        
        for (int j = 0; j < subString.length; j ++) {
            NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
            
            if (node[word] == nil) {
                break;
            }else{
                num ++;
                node = node[word];
            }
            
            //敏感词匹配成功
            if ([node[EXIST]integerValue] == 1) {
                
                NSMutableString *symbolStr = [NSMutableString string];
                for (int k = 0; k < num; k ++) {
                    [symbolStr appendString:@"*"];
                }
                
                [result replaceCharactersInRange:NSMakeRange(i, num) withString:symbolStr];
                
                i += j;
                break;
            }
        }
    }
    
    return result;
}


- (void)stopFilter:(BOOL)b{
    self.isFilterClose = b;
}



@end
