/*******************************************************************************
 # File        : ReactRootViewManager.m
 # Project     : NativeInsertDemo
 # Author      : Jamesholy
 # Created     : 2019/3/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "ReactRootViewManager.h"

@interface ReactRootViewManager ()
// 以 viewName-rootView 的形式保存需预加载的RN界面
@property (nonatomic, strong) NSMutableDictionary<NSString *, RCTRootView*> * rootViewMap;
@end

@implementation ReactRootViewManager

- (void)dealloc {
  _rootViewMap = nil;
  [_bridge invalidate];
}

+ (instancetype)manager {
  static ReactRootViewManager * _rootViewManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _rootViewManager = [[ReactRootViewManager alloc] init];
  });
  return _rootViewManager;
}

- (instancetype)init {
  if (self = [super init]) {
    _rootViewMap = [NSMutableDictionary dictionaryWithCapacity:0];
  }
  return self;
}

- (void)preLoadRootViewWithName:(NSString *)viewName {
  [self preLoadRootViewWithName:viewName initialProperty:nil];
}

- (void)preLoadRootViewWithName:(NSString *)viewName initialProperty:(NSDictionary *)initialProperty {
  if (!viewName && [_rootViewMap objectForKey:viewName]) {
    return;
  }
  // 由bridge创建rootView
  RCTRootView * rnView = [[RCTRootView alloc] initWithBridge:self.bridge
                                                  moduleName:viewName
                                           initialProperties:initialProperty];
  [_rootViewMap setObject:rnView forKey:viewName];
}

- (RCTRootView *)rootViewWithName:(NSString *)viewName {
  if (!viewName) {
    return nil;
  }
  return [self.rootViewMap objectForKey:viewName];
}

#pragma mark - RCTBridgeDelegate


@end
