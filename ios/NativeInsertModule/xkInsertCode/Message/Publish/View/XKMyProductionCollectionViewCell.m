//
//  XKMyProductionCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyProductionCollectionViewCell.h"
#import "XKVideoDisplayModel.h"
@interface XKMyProductionCollectionViewCell ()

@property (nonatomic, strong) UIImageView  *bgImgView;

@property (nonatomic, strong) UIButton  *choseBtn;

@property (nonatomic, strong) XKVideoDisplayVideoListItemModel *video;

@end
@implementation XKMyProductionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.choseBtn];
   
}

- (void)addUIConstraint {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
}

- (void)choseBtnClick:(UIButton *)sender {
    if (self.choseBlock) {
        self.choseBlock();
    }
}

#pragma mark - public method

- (void)configCellWithVideoModel:(XKVideoDisplayVideoListItemModel *)video {
    _video = video;
    if (_video.video.zdy_cover && _video.video.zdy_cover.length) {
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:_video.video.zdy_cover]];
    } else if (_video.video.first_cover && _video.video.first_cover.length) {
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:_video.video.first_cover]];
    } else {
        self.bgImgView.image = kDefaultPlaceHolderImg;
    }
}

- (void)setChoseBtnSelected:(BOOL)selected {
    self.choseBtn.selected = selected;
}

#pragma mark - getter setter

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = kDefaultPlaceHolderImg;
     
    }
    return _bgImgView;
}

- (UIButton *)choseBtn {
    if (!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setBackgroundColor:[UIColor clearColor]];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_bg_IM_function_production_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_bg_IM_function_production_chose"] forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _choseBtn;
}
@end
