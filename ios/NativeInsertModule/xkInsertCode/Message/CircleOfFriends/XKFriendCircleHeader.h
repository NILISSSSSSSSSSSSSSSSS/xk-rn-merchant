//
//  XKFriendCircleHeader.h
//  XKSquare
//
//  Created by Jamesholy on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#ifndef XKFriendCircleHeader_h
#define XKFriendCircleHeader_h

#import "XKFriendTalkModel.h"

#define kScaleRatio (ScreenScale>1.0?1.1:1.0)
#define kFontPointSize6(Size) ((Size)*kScaleRatio)
#define kViewSize(Size) (Size * kScaleRatio)
#define kFontSize6(Size) [UIFont systemFontOfSize:kFontPointSize6(Size)]

#define kFMargin  10
#define kFHeaderSize  46
#define kFriendTalkContentFont 14


#endif /* XKFriendCircleHeader_h */
