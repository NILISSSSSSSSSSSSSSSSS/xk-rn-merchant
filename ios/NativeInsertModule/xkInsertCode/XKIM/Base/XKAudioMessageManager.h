//
//  XKAudioMessageManager.h
//  XKSquare
//
//  Created by william on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKAudioMessageManager : NSObject

@property (nonatomic,assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *currentUrl;

+(XKAudioMessageManager *)sharedHttpClient;

-(void)playWithUrlString:(NSString *)urlString;

-(void)stop;

@end
