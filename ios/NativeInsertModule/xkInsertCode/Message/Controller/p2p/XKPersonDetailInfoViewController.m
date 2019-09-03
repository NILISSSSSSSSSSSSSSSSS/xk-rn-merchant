//
//  XKPersonDetailInfoViewController.m
//  XKSquare
//
//  Created by william on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonDetailInfoViewController.h"
#import "XKPersonDetailInfoHeaderView.h"
#import "XKPersonDetailInfoBottomToolBar.h"
#import "XKFriendCircleSpecialViewModel.h"
#import "XKPersonDetailInfoViewModel.h"
#import "XKPersonalInformationViewController.h"
#import "XKButton.h"
#import "XKFriendCircleSpecialController.h"
#import "XKPersonalDetailVideoViewModel.h"
#import "XKPersonalVideoViewController.h"

@interface XKPersonDetailInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView   *mainBackTableView;
@property (nonatomic, strong) UIView        *mainNavView;
@property (nonatomic, strong) UIButton        *moreButton;
/**tableView header*/
@property (nonatomic, strong) XKPersonDetailInfoHeaderView *headerInfoView;

/**按钮切换视图*/
@property (nonatomic, strong) UIView        *menuBtnView;
@property (nonatomic, strong) UIButton      *littleVideoButton;
@property (nonatomic, strong) UIButton      *circleButton;
@property (nonatomic, strong) UIView        *littleVideoLine;
@property (nonatomic, strong) UIView        *circleLine;

/**查看更多*/
@property (nonatomic, strong) UILabel        *seeMoreLabl;

@property (nonatomic, strong) UIView         *friendCircleEmptyView; // 无可友圈占位图

/**申请信息视图*/
@property(nonatomic, strong) UIView *applyInfoView;

@property (nonatomic, strong) XKPersonDetailInfoBottomToolBar   *toolBar;
/**viewmodel*/
@property(nonatomic, strong) XKPersonDetailInfoViewModel *viewModel;
/**可友圈viewModel*/
@property(nonatomic, strong) XKFriendCircleSpecialViewModel *circleViewModel;
/**小视频viewModel*/
@property(nonatomic, strong) XKPersonalDetailVideoViewModel *videoViewModel;
/***/
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;

/**是否默认可友圈*/
@property(nonatomic, assign) BOOL isShowCircle;

@end

@implementation XKPersonDetailInfoViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _isShowCircle = YES;
    [self hideNavigation];
    [self initViews];
    [self initDefaultData];
    [self initViewModel];
    [self requestTotalNeedTip:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.viewModel.hasStatusChanged) {
        if (self.hasStatusChangedBlock) {
            self.hasStatusChangedBlock(self.viewModel.personalInfo);
        }
    }
}

- (void)setUserId:(NSString *)userId {
  _userId = userId;
  if (userId == nil) {
    _userId = @" ";
  }
}

#pragma mark – Private Methods
-(void)initViews{
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
    }];
    [self.containView addSubview:self.mainBackTableView];
    [self.containView addSubview:self.toolBar];
    [self.view addSubview:self.mainNavView];
    _emptyView = [XKEmptyPlaceView configScrollView:self.mainBackTableView config:nil];
    _emptyView.config.verticalOffset = -10;
    // 数据未请求回来时 界面配置为隐藏
    [self uiShow:NO];
}

- (void)initViewModel {
    __weak typeof(self) weakSelf = self;
    _circleViewModel = [[XKFriendCircleSpecialViewModel alloc] init];
    _circleViewModel.isInsertPersonalVC = YES;
    _circleViewModel.userId = self.userId;
    [_circleViewModel setScrollViewScroll:^(UIScrollView *scrollView) {
        [weakSelf scrollViewDidScroll:scrollView];
    }];
    [_circleViewModel registerCellForTableView:self.mainBackTableView];
    
    _videoViewModel = [[XKPersonalDetailVideoViewModel alloc] init];
    _videoViewModel.userId = self.userId;
    [_videoViewModel setScrollViewScroll:^(UIScrollView *scrollView) {
        [weakSelf scrollViewDidScroll:scrollView];
    }];
    [_videoViewModel registerCellForTableView:self.mainBackTableView];
}

- (XKPersonDetailInfoViewModel *)viewModel {
    if (!_viewModel) {
        __weak typeof(self) weakSelf = self;
        _viewModel = [XKPersonDetailInfoViewModel new];
        _viewModel.vc = self;
        _viewModel.userId = self.userId;
        [_viewModel setUpdateStatusUI:^{
            [weakSelf updateUI];
        }];
        
        [_viewModel setAcceptApplySuccess:^{
            weakSelf.isAcceptApply = NO; // 成功接受好友申请 变为好友 逻辑已在内部处理
            EXECUTE_BLOCK(weakSelf.addFriend,weakSelf.applyId);
            [weakSelf updateUI];
        }];
    }
    return _viewModel;
}

#pragma mark - 参数初始化
- (void)initDefaultData {
    
}

#pragma mark - --------数据显示 刷新相关

#pragma mark  配置初始显示
- (void)uiShow:(BOOL)uishow {
    self.headerInfoView.hidden = !uishow;
    if ([self isMineInfo]) {
        self.toolBar.hidden = YES;
        self.mainBackTableView.height = SCREEN_HEIGHT;
    } else {
        self.toolBar.hidden = !uishow;
        self.mainBackTableView.height = uishow ? SCREEN_HEIGHT - self.toolBar.height : SCREEN_HEIGHT;
    }
}

- (void)fixNavColor {
    [self scrollViewDidScroll:self.mainBackTableView];
}

#pragma mark  更新界面显示
- (void)updateUI {
    // 数据未请求回来时 界面配置为显示
    [self uiShow:YES];
    
    // 更新header toolbar 更多按钮
    XKPesonalDetailInfoModel *info = self.viewModel.personalInfo;
    [self.headerInfoView updateUI:info isSecret:self.isSecret];
    if (![self isMineInfo]) { // 不是我的信息
        [self updateToolBar];
        //  更新头部 主要控制申请信息和非申请信息状态切换
        [self updateHeaderView];
        // 更新更多按钮状态
        [self updateMoreBtn];
    } else {
        _moreButton.hidden = YES;
        [self updateHeaderView];
    }
    [self.mainBackTableView reloadData];
}

#pragma mark 更新toolbar
- (void)updateToolBar {
    XKPesonalDetailInfoModel *info = self.viewModel.personalInfo;
    self.toolBar.secret = self.isSecret;
    self.toolBar.secretId = self.secretId;
    self.toolBar.friendRelation = info.friendRelation;
    self.toolBar.secretRelation = info.secretRelation;
    self.toolBar.followRelation = info.followRelation;
    self.toolBar.info = self.viewModel.personalInfo;
    self.toolBar.toolStatus = self.isAcceptApply ? XKPersonDetailInfoBottomToolIsFriendApply : XKPersonDetailInfoBottomToolNoraml;
    [self.toolBar updateUI];
}

#pragma mark  更新头部 主要控制申请信息和非申请信息状态切换
- (void)updateHeaderView {
    if (self.isAcceptApply) {
        self.applyInfoView.hidden = NO;
        [self.headerInfoView addSubview:self.applyInfoView];
        self.applyInfoView.y = self.headerInfoView.getTopInfoViewBtm;
        self.menuBtnView.y = self.applyInfoView.bottom + 10;
        self.headerInfoView.height = self.menuBtnView.bottom;
    } else {
        _applyInfoView.hidden = YES;
        self.menuBtnView.y = self.headerInfoView.getTopInfoViewBtm;
        self.headerInfoView.height = self.menuBtnView.bottom;
    }
    [self.mainBackTableView reloadData];
}

#pragma mark 更新更多按钮显示
- (void)updateMoreBtn {
    if ([self isMineInfo]) {
        _moreButton.hidden = YES;
    } else {
        if (self.viewModel.vc_useForApply) {
            _moreButton.hidden = NO;
        } else { // 非申请状态
            if (self.viewModel.vc_useForFriendAndIsFriend) {
                _moreButton.hidden = NO;
            } else if (self.viewModel.vc_useForFriendAndIsNotFriend) {
                _moreButton.hidden = NO;
            } else if (self.viewModel.vc_useForSecretAndIsFriend) {
                _moreButton.hidden = NO;
            } else if (self.viewModel.vc_useForSecretAndIsNotFriend) {
                _moreButton.hidden = YES;
            }
        }
    }
}

#pragma mark - ---------逻辑判断相关

#pragma mark  是否是我自己的信息
- (BOOL)isMineInfo {
    if ([self.userId isEqualToString:[XKUserInfo getCurrentUserId]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - ---------Events 事件处理
-(void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 切换
-(void)switchVideoAndCircle:(UIButton *)sender {
    
    if (sender.tag == 1001) { //点击小视频
         self.isShowCircle = NO;
    } else {  //点击可友圈
         self.isShowCircle = YES;
       
    }
    __weak typeof(self) weakSelf = self;
    _littleVideoButton.selected = !self.isShowCircle;
    _littleVideoLine.hidden = self.isShowCircle;
    _circleButton.selected = self.isShowCircle;
    _circleLine.hidden = !self.isShowCircle;
    if (self.isShowCircle) {
        self.mainBackTableView.delegate = self.circleViewModel;
        self.mainBackTableView.dataSource = self.circleViewModel;
        [self.mainBackTableView reloadData];
        [weakSelf setSeeMoreFooter];
        [self.circleViewModel requestRefresh:YES complete:^(id error, id data) {
            [weakSelf.mainBackTableView reloadData];
            [weakSelf fixNavColor];
            [weakSelf setSeeMoreFooter];
        }];
    } else {
        self.mainBackTableView.delegate = self.videoViewModel;
        self.mainBackTableView.dataSource = self.videoViewModel;
        [self.mainBackTableView reloadData];
        [weakSelf setSeeMoreFooter];
        [self.videoViewModel requestComplete:^(id error, id data) {
            [weakSelf.mainBackTableView reloadData];
            [weakSelf fixNavColor];
            [weakSelf setSeeMoreFooter];
        }];
    }
}

#pragma mark - 设置查看更多footer
- (void)setSeeMoreFooter {
    if (self.isShowCircle) {
        if (_circleViewModel.dataArray.count > 3) {
            self.mainBackTableView.tableFooterView = self.seeMoreLabl;
        } else {
          if (_circleViewModel.isFetchNet && _circleViewModel.dataArray.count == 0) {
            // 是我的界面
            self.mainBackTableView.tableFooterView = self.friendCircleEmptyView;
          } else  {
            self.mainBackTableView.tableFooterView = nil;
          }
        }
    } else {
        if (_videoViewModel.dataArray.count > 4) {
            self.mainBackTableView.tableFooterView = self.seeMoreLabl;
        } else {
            self.mainBackTableView.tableFooterView = nil;
        }
    }
}

- (void)seeMore {
    if (self.isShowCircle) {
        XKFriendCircleSpecialController * vc = [XKFriendCircleSpecialController new];
        vc.userId = self.userId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        XKPersonalVideoViewController *vc = [XKPersonalVideoViewController new];
        vc.rid = self.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark  更多按钮
- (void)moreBtnClick:(UIButton *)btn {
    [self.viewModel dealMoreBtnClick:btn];
}

#pragma mark  进入资料修改
- (void)jumpToPersonalInfo {
    if ([self isMineInfo]) {
        __weak typeof(self) weakSelf = self;
        XKPersonalInformationViewController *vc = [[XKPersonalInformationViewController alloc] init];
        [vc setInfoChange:^{
            [weakSelf.viewModel updateData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - -----------网络请求
- (void)requestTotalNeedTip:(BOOL)needTip {
    __weak typeof(self) weakSelf = self;
    [XKHudView showLoadingTo:self.mainBackTableView animated:YES];
    [self.viewModel requestInfoComplete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.mainBackTableView];
        if (error) {
            [XKHudView showErrorMessage:error to:self.mainBackTableView animated:YES];
            [self fixNavColor];
            if (self.viewModel.personalInfo == nil) {
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:error des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestTotalNeedTip:YES];
                }];
            }
        } else {
            [self.emptyView hide];
            [self updateUI];
            [self.mainBackTableView reloadData];
            // 请求视频或者朋友圈信息
           [self requestVideoOrCircle];
        }
    }];
}


#pragma mark  请求朋友圈和小视频信息
- (void)requestVideoOrCircle {
    [self switchVideoAndCircle:self.isShowCircle ? self.circleButton : self.littleVideoButton];
}

#pragma mark - 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual: self.mainBackTableView]) {
        CGFloat y = _mainBackTableView.contentOffset.y;
        if (y > 0 && y < NavigationAndStatue_Height) {
            _mainNavView.backgroundColor = HEX_RGBA(0x4A90FA, y / (float)NavigationAndStatue_Height);
        }
        else if (y > NavigationAndStatue_Height){
            _mainNavView.backgroundColor = XKMainTypeColor;
        }
        else{
            _mainNavView.backgroundColor = [UIColor clearColor];
        }
        CGFloat dy = 0;
        if (scrollView.mj_offsetY > 0) {//向上移动
            dy = 0;
        } else {//向下移动
            dy = scrollView.mj_offsetY;
        }
        [self.headerInfoView configHeaderViewBackgroundImageWithY:dy];
    }
    if (self.headerInfoView.hidden == YES) {
        _mainNavView.backgroundColor = XKMainTypeColor;
    }
}


#pragma mark - -----------界面创建相关
-(UITableView *)mainBackTableView{
    if (!_mainBackTableView) {
        _mainBackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            _mainBackTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _mainBackTableView.backgroundColor = HEX_RGB(0xEEEEEE);
        _mainBackTableView.delegate = self;
        _mainBackTableView.dataSource = self;
        _mainBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainBackTableView.tableHeaderView = self.headerInfoView;
    }
    return _mainBackTableView;
}

-(XKPersonDetailInfoBottomToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[XKPersonDetailInfoBottomToolBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - kBottomSafeHeight, SCREEN_WIDTH, 50 + kBottomSafeHeight)];
        _toolBar.delegate = self.viewModel;
    }
    return _toolBar;
}

-(UIView *)mainNavView{
    if (!_mainNavView) {
        _mainNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationAndStatue_Height)];
        _mainNavView.backgroundColor = [UIColor clearColor];

        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(25, NavigationAndStatue_Height-32, 60, 20)];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backButton setTitle:@"   " forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"xk_navigationBar_global_back"] forState:UIControlStateNormal];
        [_mainNavView addSubview:backButton];
        
        UILabel *titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 200, NavigationBar_HEIGHT) text:@"详细资料" font:[UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:18] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mainNavView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self->_mainNavView.mas_centerX);
            make.bottom.mas_equalTo(self->_mainNavView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(200, NavigationBar_HEIGHT));
        }];
        
        _moreButton = [[UIButton alloc]init];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_order_mainDetail"] forState:UIControlStateNormal];
        [_mainNavView addSubview:_moreButton];
        _moreButton.hidden = YES;
        [_moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(backButton.mas_centerY);
            make.right.mas_equalTo(self->_mainNavView.mas_right).offset(-25 * ScreenScale);
            make.size.mas_equalTo(CGSizeMake(21* ScreenScale, 21 * ScreenScale));
        }];
    }
    return _mainNavView;
}

#pragma mark  headerView
- (XKPersonDetailInfoHeaderView *)headerInfoView {
    if (!_headerInfoView) {
        // 底部的空白处
        __weak typeof(self) weakSelf = self;
        _headerInfoView = [[XKPersonDetailInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 375 *ScreenScale)]; // 高度不定 初始下方有 75空白
      // 不要可友圈菜单标题
//        [_headerInfoView addSubview:self.menuBtnView];
//        _menuBtnView.frame = CGRectMake(10, self.headerInfoView.getTopInfoViewBtm, SCREEN_WIDTH - 20, 60 * ScreenScale);
        [_headerInfoView setInfoViewClick:^{
//            [weakSelf jumpToPersonalInfo]; // 商户不设置资料
        }];
    }
    return _headerInfoView;
}

- (UIView *)applyInfoView {
    if (!_applyInfoView) {
        _applyInfoView = [[UIView alloc]initWithFrame:CGRectMake(10 , 0, SCREEN_WIDTH - 20 , 20)]; // 高度 y 不定
        _applyInfoView.backgroundColor = [UIColor whiteColor];
        _applyInfoView.xk_openClip = YES;
        _applyInfoView.xk_radius = 8;
        _applyInfoView.xk_clipType = XKCornerClipTypeTopBoth;
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"   申请验证";
        titleLabel.textColor = XKMainRedColor;
        titleLabel.font = XKRegularFont(16);
        titleLabel.frame = CGRectMake(0, 0, _applyInfoView.width, 40);
        [titleLabel showBorderSite:rzBorderSitePlaceBottom];
        [_applyInfoView addSubview:titleLabel];
        titleLabel.bottomBorder.borderLine.backgroundColor = XKSeparatorLineColor;
        
        UILabel *applyInfoLabel = [[UILabel alloc] init];
        applyInfoLabel.numberOfLines = 0;
        applyInfoLabel.text = self.applyInfo;
        applyInfoLabel.textColor = HEX_RGB(0x777777);
        applyInfoLabel.font = XKRegularFont(14);
        applyInfoLabel.frame = CGRectMake(15, titleLabel.bottom + 8, _applyInfoView.width - 30, 90);
        [applyInfoLabel sizeToFit];
        [_applyInfoView addSubview:applyInfoLabel];
        _applyInfoView.height = applyInfoLabel.bottom + 15;
    }
    return _applyInfoView;
}

#pragma mark  切换按钮视图
-(UIView *)menuBtnView {
    if (!_menuBtnView) {
        _menuBtnView = [[UIView alloc]initWithFrame:CGRectZero];
        _menuBtnView.backgroundColor = UIColorFromRGB(0xffffff);
        _menuBtnView.xk_openClip = YES;
        _menuBtnView.xk_radius = 8;
        _menuBtnView.xk_clipType = XKCornerClipTypeTopBoth;
        
//        [_menuBtnView addSubview:self.littleVideoButton];
        [_menuBtnView addSubview:self.circleButton];
        
//        UIView *bottonLine = [[UIView alloc]init];
//        bottonLine.backgroundColor = UIColorFromRGB(0xf6f6f6);
//        [_menuBtnView addSubview:bottonLine];
//        [bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.bottom.right.mas_equalTo(self->_menuBtnView);
//            make.height.mas_equalTo(0.5);
//        }];
      
//        [_littleVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self->_menuBtnView);
//            make.bottom.mas_equalTo(bottonLine.mas_top);
//            make.right.mas_equalTo(self->_menuBtnView.mas_centerX);
//            make.top.mas_equalTo(self->_menuBtnView.mas_top);
//        }];
      
        [_circleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self->_menuBtnView);
            make.bottom.mas_equalTo(self->_menuBtnView.mas_bottom);
            make.left.mas_equalTo(self->_menuBtnView);
            make.top.mas_equalTo(self->_menuBtnView.mas_top);
        }];
        
    }
    return _menuBtnView;
}

-(UIButton *)littleVideoButton{
    if (!_littleVideoButton) {
        _littleVideoButton = [XKButton new];
        _littleVideoButton.titleLabel.font = XKRegularFont(14);
        [_littleVideoButton setTitle:@"小视频" forState:UIControlStateNormal];
        [_littleVideoButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
        [_littleVideoButton setImage:[UIImage imageNamed:@"xk_img_personDetailInfo_littleVideo_normol"] forState:UIControlStateNormal];
        [_littleVideoButton setImage:[UIImage imageNamed:@"xk_img_personDetailInfo_littleVideo_selected"] forState:UIControlStateSelected];

        [_littleVideoButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [_littleVideoButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];

        _littleVideoButton.tag = 1001;
        [_littleVideoButton addTarget:self action:@selector(switchVideoAndCircle:) forControlEvents:UIControlEventTouchUpInside];
        [_littleVideoButton setAdjustsImageWhenHighlighted:NO];
        _littleVideoLine = [[UIView alloc]init];
        _littleVideoLine.backgroundColor = XKMainTypeColor;
        [_littleVideoButton addSubview:_littleVideoLine];
        [_littleVideoLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_littleVideoButton);
            make.centerX.mas_equalTo(self->_littleVideoButton);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(60 *ScreenScale);
        }];
    }
    return _littleVideoButton;
}

-(UIButton *)circleButton {
    if (!_circleButton) {
        _circleButton = [[XKButton alloc] init];
        _circleButton.titleLabel.font = XKRegularFont(14);
        [_circleButton setTitle:@"可友圈" forState:UIControlStateNormal];
        [_circleButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
        [_circleButton setImage:[UIImage imageNamed:@"xk_img_personDetailInfo_circle_normol"] forState:UIControlStateNormal];
        [_circleButton setImage:[UIImage imageNamed:@"xk_img_personDetailInfo_circle_selected"] forState:UIControlStateSelected];
      
        [_circleButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [_circleButton setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        
        _circleButton.tag = 1002;
        [_circleButton addTarget:self action:@selector(switchVideoAndCircle:) forControlEvents:UIControlEventTouchUpInside];
//
//        _circleLine = [[UIView alloc]init];
//        _circleLine.backgroundColor = XKMainTypeColor;
//        [_circleButton addSubview:_circleLine];
//        [_circleLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self->_circleButton);
//            make.centerX.mas_equalTo(self->_circleButton);
//            make.height.mas_equalTo(3);
//            make.width.mas_equalTo(60 *ScreenScale);
//        }];
    }
    return _circleButton;
}


- (UILabel *)seeMoreLabl {
    if (!_seeMoreLabl) {
        __weak typeof(self) weakSelf = self;
        _seeMoreLabl = [UILabel new];
        [_seeMoreLabl rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.alignment(NSTextAlignmentCenter);
            confer.text(@"点击查看更多 ").textColor(HEX_RGB(0x999999)).font(XKRegularFont(12));
            confer.appendImage(IMG_NAME(@"ic_btn_msg_circle_rightArrow")).bounds(CGRectMake(0, -2, 9, 12));
        }];
        _seeMoreLabl.frame = CGRectMake(0, 0, 50, 50);
        _seeMoreLabl.userInteractionEnabled = YES;
        [_seeMoreLabl bk_whenTapped:^{
            [weakSelf seeMore];
        }];
    }
    return _seeMoreLabl;
}


- (UIView *)friendCircleEmptyView {
  if (!_friendCircleEmptyView) {
    _friendCircleEmptyView = [UIView new];
    _friendCircleEmptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [_friendCircleEmptyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self->_friendCircleEmptyView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.xk_openClip = YES;
    scrollView.xk_radius = 8;
    scrollView.xk_clipType = XKCornerClipTypeAllCorners;
    [scrollView configDefaultEmptyView];
    XKEmptyPlaceView *empView = scrollView.emptyPlaceView;
    empView.config.verticalOffset = 0;
    empView.config.backgroundColor = [UIColor clearColor];
    empView.config.useSpecialImageSize = YES;
    empView.config.titleFont = XKNormalFont(14);
    empView.config.btnFont = XKNormalFont(14);
    empView.config.specialImageSize = CGSizeMake(120, 120);
    [empView showWithImgName:kEmptyPlaceImgName title:@"暂无数据" des:nil tapClick:nil];
  }
  _friendCircleEmptyView.height = SCREEN_HEIGHT -  self.mainBackTableView.tableHeaderView.height - 60;
  return _friendCircleEmptyView;
}



@end
