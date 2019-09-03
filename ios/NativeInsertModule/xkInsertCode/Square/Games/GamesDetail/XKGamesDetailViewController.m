//
//  XKGamesDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesDetailViewController.h"

@interface XKGamesDetailViewController ()

@property (nonatomic, strong) UIScrollView   *bgView;
@property (nonatomic, strong) UIView         *bottomView;
@property (nonatomic, strong) UIButton       *collectBtn;
@property (nonatomic, strong) UIButton       *downBtn;
@property (nonatomic, strong) UIImageView    *imgView;
@property (nonatomic, strong) UILabel        *decLabel;
@property (nonatomic, strong) UILabel        *detailLabel;

@end

@implementation XKGamesDetailViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    
    [self addCustomUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)rightButtonClicked:(UIButton *)sender {
    
}

- (void)collectBtnClicked:(UIButton *)sender {
    
}

- (void)downBtnClicked:(UIButton *)sender {
    
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    
    [self setNavTitle:self.titleName WithColor:[UIColor whiteColor]];
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setImage:[UIImage imageNamed:@"xk_btn_squreConsult_share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviCustomView:rightButton withframe:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 30)];
}

- (void)addCustomUI {
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.decLabel];
    [self.bgView addSubview:self.detailLabel];
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.collectBtn];
    [self.bottomView addSubview:self.downBtn];
    
    [self layoutCustomViews];

}

- (void)layoutCustomViews {
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.bottomView);
        make.width.equalTo(@(105*ScreenScale));
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.downBtn.mas_left);
        make.width.equalTo(self.downBtn.mas_width);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height + 10);
        make.right.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10);

    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgView).offset(15);
        make.width.equalTo(@(SCREEN_WIDTH-50));
        make.height.equalTo(@(182*ScreenScale));
    }];
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.equalTo(self.bgView).offset(15);
        make.width.equalTo(@(SCREEN_WIDTH-50));

    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLabel.mas_bottom).offset(8);
        make.left.equalTo(self.bgView).offset(15);
        make.width.equalTo(@(SCREEN_WIDTH-50));

        make.bottom.equalTo(self.bgView).offset(-15);
    }];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSoure

#pragma mark - Custom Delegates

#pragma mark - Getters and Setters


- (UIScrollView *)bgView {
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.showsVerticalScrollIndicator = NO;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5;
//        [_bgView drawCommonShadowUselayer];
    }
    return _bgView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        _collectBtn.backgroundColor = XKMainTypeColor;
        [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _collectBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_collectBtn addTarget:self action:@selector(collectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}


- (UIButton *)downBtn {
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        _downBtn.backgroundColor = HEX_RGB(0xEE6161);
        [_downBtn setTitle:@"去下载" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_downBtn addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}



- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.backgroundColor = [UIColor greenColor];
    }
    return _imgView;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.textAlignment = NSTextAlignmentLeft;
        _decLabel.text = @"这款游戏收费放佛也发起违反潜伏期我已噢请问放弃我发起违反  全文佛教噢物权法群文件费趣问佛偈";
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.textColor = HEX_RGB(0x555555);
    }
    return _decLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.text = @"udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf udafdfqwefqweflkfkkfk kfokpokfpkqp psf qjfpqj qg jqopf qpfjqjfjqfjqejf jfjf  pfqpofjqeopfjqejfjqefj pqejfpojqeofjperjfjepjqpjfopevojoe gv kdkpaksfjqf aifnaofdapf";
        _detailLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _detailLabel.textColor = HEX_RGB(0x777777);
    }
    return _detailLabel;
}



@end
