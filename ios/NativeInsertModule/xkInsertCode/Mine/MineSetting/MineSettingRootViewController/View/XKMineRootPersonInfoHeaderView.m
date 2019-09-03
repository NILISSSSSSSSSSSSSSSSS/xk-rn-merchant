//
//  XKMineRootPersonInfoHeaderView.m
//  XKSquare
//
//  Created by william on 2018/8/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineRootPersonInfoHeaderView.h"
#import "XKMineRootPersonInfoHeaderFirstView.h"

@interface XKMineRootPersonInfoHeaderView()

@property (nonatomic,strong)XKMineRootPersonInfoHeaderFirstView *firstInfoView;

@end
@implementation XKMineRootPersonInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        self.backgroundColor = HEX_RGB(0xEEEEEE);
        [self initViews];
        [self layoutViews];
        
    }
    return self;
}

#pragma mark – Life Cycle

#pragma mark - Events

#pragma mark – Private Methods
-(void)initViews{
    [self addSubview:self.firstInfoView];
}

-(void)layoutViews{
    
}

#pragma mark – Getters and Setters
-(XKMineRootPersonInfoHeaderFirstView *)firstInfoView{
    if (!_firstInfoView) {
        _firstInfoView = [[XKMineRootPersonInfoHeaderFirstView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160 * ScreenScale)];
    }
    return _firstInfoView;
}
#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates



@end
