//
//  XKGroupChatInviteViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGroupChatInviteViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "XKP2PChatViewController.h"
@interface XKGroupChatInviteViewController ()
/**主视图*/
@property(nonatomic, strong) UIView *contentView;
/**头像*/
@property(nonatomic, strong) UIImageView *headerImageView;
/**群名*/
@property(nonatomic, strong) UILabel *titleLabel;
/**人数*/
@property(nonatomic, strong) UILabel *countLabel;
/**加入群聊按钮*/
@property(nonatomic, strong) UIButton *addGroupChatButton;
@end

@implementation XKGroupChatInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"群聊邀请" WithColor:[UIColor whiteColor]];
    [self setBackButton:[UIImage imageNamed:@"xk_ic_video_display_comment_close_white"] andName:nil];
    [self creatUI];
    
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:self.groupId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:kDefaultHeadImg];
        self.titleLabel.text = team.teamName;
        self.countLabel.text = [NSString stringWithFormat:@"共%ld人",team.memberNumber];
    }];
}

- (void)creatUI {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.addGroupChatButton];
  
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * ScreenScale);
        make.right.mas_equalTo(-10 * ScreenScale);
        make.height.mas_equalTo(246 * ScreenScale);
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35 * ScreenScale);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(46 * ScreenScale);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * ScreenScale);
        make.right.mas_equalTo(-20 * ScreenScale);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(15 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * ScreenScale);
        make.right.mas_equalTo(-20 * ScreenScale);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8 * ScreenScale);
        make.height.mas_equalTo(15 * ScreenScale);
    }];
    
    [self.addGroupChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25 * ScreenScale);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(44 * ScreenScale);
        make.width.mas_equalTo(225 * ScreenScale);
    }];
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.xk_openClip = YES;
        _contentView.xk_radius = 8;
        _contentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _contentView;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.xk_openClip = YES;
        _headerImageView.xk_radius = 8;
        _headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _headerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"吃吃吃，吃个葡萄皮";
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.font = XKMediumFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.text = @"共145人";
        _countLabel.textColor = HEX_RGB(0x999999);
        _countLabel.font = XKRegularFont(14);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIButton *)addGroupChatButton {
    if (!_addGroupChatButton) {
        _addGroupChatButton = [[UIButton alloc]init];
        [_addGroupChatButton setTitle:@"加入群聊" forState:0];
        [_addGroupChatButton setTitleColor:[UIColor whiteColor] forState:0];
        _addGroupChatButton.layer.masksToBounds = YES;
        _addGroupChatButton.layer.cornerRadius = 8;
        [_addGroupChatButton addTarget:self action:@selector(addGroupChatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _addGroupChatButton.backgroundColor = XKMainTypeColor;
    }
    return _addGroupChatButton;
}


/**
 加入群聊的事件
 */
- (void)addGroupChatButtonAction:(UIButton *)sender {
    [[NIMSDK sharedSDK].teamManager applyToTeam:self.groupId message:@"" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
        NIMSession *session = [NIMSession session:self.groupId type:NIMSessionTypeTeam];
        XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
        vc.hidesBottomBarWhenPushed = YES;
        [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }];
}
@end
