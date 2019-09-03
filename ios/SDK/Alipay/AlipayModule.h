#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface AlipayModule : NSObject<RCTBridgeModule>

+(void) handleCallback:(NSURL *)url;

@end
