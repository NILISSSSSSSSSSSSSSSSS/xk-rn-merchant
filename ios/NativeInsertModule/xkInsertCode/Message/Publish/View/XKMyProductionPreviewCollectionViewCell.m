//
//  XKMyProductionPreviewCollectionViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyProductionPreviewCollectionViewCell.h"
#import "XKMyProductionPreviewModel.h"
#import "BigPhotoPreviewBaseController.h"
@interface XKMyProductionPreviewCollectionViewCell()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) XKMyProductionPreviewModel *preview;

@end

@implementation XKMyProductionPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configCellWithPreviewModel:(XKMyProductionPreviewModel *)preview {
    _preview = preview;
    
    [self.playerLayer removeFromSuperlayer];
    [self.playBtn removeFromSuperview];
    
    self.playerLayer = _preview.playerLayer;
    self.playerLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:self.playerLayer];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
    [self.contentView addSubview:self.playBtn];
    self.playBtn.hidden = NO;
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(48.0);
    }];
}

- (void)play {
    self.playBtn.hidden = YES;
    [self.playerLayer.player play];
}

- (void)pause {
    self.playBtn.hidden = NO;
    [self.playerLayer.player pause];
}



@end
