//
//  XKWelfareOrderWaitOpenCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderWaitOpenCell.h"
#import "XKWelfareOrderWaitOpenTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressOrTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressAndTimeCell.h"
#import "XKWelfareOrderWaitOpenProgressCell.h"
#import "XKWelfareProgressView.h"
#import "XKTimeSeparateHelper.h"

@interface XKWelfareOrderWaitOpenCell ()

@end

@implementation XKWelfareOrderWaitOpenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgContainView.xk_radius = 6.f;
        self.bgContainView.xk_openClip = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self.bgContainView addSubview:self.sumView];
        [self.sumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgContainView.mas_right).offset(-15);
            make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
        }];
        self.sumView.hidden = YES;
    }
    return self;
}

- (void)bindData:(WelfareOrderDataItem *)item {

}

- (void)handleDataModel:(XKWelfareBuyCarItem *)model hasLose:(BOOL)hasLose manangeModel:(BOOL)manangeModel {
    
}

- (void)bindItem:(XKWelfareBuyCarItem *)item {
    
}

- (void)choseBtnClick:(UIButton *)sender {
    if (self.choseBlock) {
        self.choseBlock(_buyCarModel.index, sender);
    }
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIButton *)loseBtn {
    if(!_loseBtn) {
        _loseBtn = [[UIButton alloc] init];
        [_loseBtn setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [_loseBtn setTitle:@"失效" forState:0];
        _loseBtn.userInteractionEnabled = NO;
        _loseBtn.titleLabel.font = XKRegularFont(12);
        [_loseBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_loseBtn cutCornerWithRoundedRect:CGRectMake(0, 0, 33, 18) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        
    }
    return _loseBtn;
}

- (XKWelfareBuyCarSumView *)sumView {
    if(!_sumView) {
        XKWeakSelf(ws);
        _sumView = [[XKWelfareBuyCarSumView alloc] init];
        _sumView.addBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            if(current < 99) {
                current += 1;
            }
            ws.sumView.inputTf.text = @(current).stringValue;
            ws.buyCarModel.quantity = current;
            if(ws.calculateBlock) {
                ws.calculateBlock(ws.buyCarModel.index, current);
            }
        };
        _sumView.subBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            if(current > 1) {
                current -= 1;
            }
            ws.sumView.inputTf.text = @(current).stringValue;
            ws.buyCarModel.quantity = current;
            if(ws.calculateBlock) {
                ws.calculateBlock(ws.buyCarModel.index, current);
            }
        };
        _sumView.textFieldChangeBlock = ^(NSString *string) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            if(current > 1) {
                current -= 1;
            }
            ws.sumView.inputTf.text = @(current).stringValue;
            ws.buyCarModel.quantity = current;
            if(ws.calculateBlock) {
                ws.calculateBlock(ws.buyCarModel.index, current);
            }
        };
        
    }
    return _sumView;
}

@end
