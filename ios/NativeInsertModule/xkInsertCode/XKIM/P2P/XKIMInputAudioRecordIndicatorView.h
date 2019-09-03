//
//  XKIMInputAudioRecordIndicatorView.h
//  XKSquare
//
//  Created by william on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMInputView.h>
NS_ASSUME_NONNULL_BEGIN

@interface XKIMInputAudioRecordIndicatorView : UIView
@property (nonatomic, assign) NIMAudioRecordPhase phase;

@property (nonatomic, assign) NSTimeInterval recordTime;
@end

NS_ASSUME_NONNULL_END
