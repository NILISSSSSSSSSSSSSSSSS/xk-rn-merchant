//
//  XKHomeBannerView.h
//  Doctor
//
//  Created by 胡攀 on 2017/6/28.
//  Copyright © 2017年 MDKS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XKHomeBannerViewTapBlock)(NSInteger type, NSString *jumpStr);

@interface XKHomeBannerView : UIView

@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, assign) NSInteger                 iCarouselType;
@property (nonatomic, assign) UIViewContentMode         imageViewScaleType;
@property (nonatomic, copy  ) XKHomeBannerViewTapBlock  tapBlock;

- (void)setPageContrllerNumberOfPages:(NSInteger)number hidden:(BOOL)hidden;

@end
