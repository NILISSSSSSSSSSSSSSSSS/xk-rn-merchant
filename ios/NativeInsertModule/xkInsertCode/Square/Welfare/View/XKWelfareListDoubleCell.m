//
//  XKWelfareListDoubleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareListDoubleCell.h"
#import "XKWelfareListDoubleTimeCell.h"
#import "XKWelfareListDoubleProgressCell.h"
#import "XKWelfareListDoubleProgressAndTimeCell.h"
#import "XKWelfareListDoubleProgressOrTimeCell.h"
#import "XKWelfareProgressView.h"
#import "XKTimeSeparateHelper.h"
@interface XKWelfareListDoubleCell ()

@end

@implementation XKWelfareListDoubleCell
- (instancetype)WelfareListDoubleCellWithType:(WelfareListDoubleCellType)cellType {
    switch (cellType) {
        case WelfareListDoubleCellType_Time: {
            return [XKWelfareListDoubleTimeCell new];
        }
            break;
        case WelfareListDoubleCellType_Progress: {
            return [XKWelfareListDoubleProgressCell new];
        }
            break;
        case WelfareListDoubleCellType_ProgressAndTime: {
            return [XKWelfareListDoubleProgressAndTimeCell new];
        }
            break;
        case WelfareListDoubleCellType_ProgressOrTime: {
            return [XKWelfareListDoubleProgressOrTimeCell new];
        }
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}



- (void)bindData:(WelfareDataItem *)item {
    
}


@end
