//
//  XKWelfareListSingleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareListSingleCell.h"
#import "XKWelfareListSingleTimeCell.h"
#import "XKWelfareListSingleProgressCell.h"
#import "XKWelfareListSingleProgressAndTimeCell.h"
#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareProgressView.h"
#import "XKTimeSeparateHelper.h"
@interface XKWelfareListSingleCell ()

@end

@implementation XKWelfareListSingleCell
- (instancetype)WelfareListSingleCellWithType:(WelfareListSingleCellType)cellType {
    switch (cellType) {
        case WelfareListSingleCellType_Time: {
            return [XKWelfareListSingleTimeCell new];
        }
            break;
        case WelfareListSingleCellType_Progress: {
            return [XKWelfareListSingleProgressCell new];
        }
            break;
        case WelfareListSingleCellType_ProgressAndTime: {
            return [XKWelfareListSingleProgressAndTimeCell new];
        }
            break;
        case WelfareListSingleCellType_ProgressOrTime: {
            return [XKWelfareListSingleProgressOrTimeCell new];
        }
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgContainView];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;
    }
    return self;
}



- (void)bindData:(WelfareDataItem *)item WithType:(NSInteger)layoutType {
    if (layoutType == 1) {
        [self.bgContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.top.bottom.equalTo(self.contentView);
        }];
    }
}



@end
