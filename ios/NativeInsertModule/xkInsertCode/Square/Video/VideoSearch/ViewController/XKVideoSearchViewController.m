//
//  XKVideoSearchViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchViewController.h"
#import "XKVideoSearchHeader.h"
#import "XKVideoSearchHotUserTableViewCell.h"
#import "XKVidelSearchHotTopicsTableViewCell.h"
#import "XKVideoSearchCollectionHeader.h"
#import "XKVideoCitywideCollectionViewLayout.h"
#import "XKVideoCitywideCollectionViewCell.h"
#import "XKVideoSearchUserModel.h"
#import "XKVideoSearchTopicModel.h"
#import "XKVideoSearchResultModel.h"
#import "XKVideoSearchMoreViewController.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKPesonalDetailInfoModel.h"
#import "XKVideoDisplayMediator.h"

@interface XKVideoSearchViewController () <XKBaiduLocationDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, XKVideoSearchCollectionHeaderDelegate>

@property (nonatomic, strong) NSMutableArray *hotUsers;

@property (nonatomic, strong) NSMutableArray *hotTopics;

@property (nonatomic, assign) CGFloat hotTopicsHeight;

@property (nonatomic, strong) XKVideoSearchTopicModel *randomTopic;

@property (nonatomic, strong) XKVideoCitywideCollectionViewLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger maxPage;


@property (nonatomic, strong) XKEmptyPlaceView *collectionViewEmptyView;

@property (nonatomic, strong) XKVideoSearchResultModel *resultModel;

@property (nonatomic, strong) NSMutableArray *itemHeights;

@end

@implementation XKVideoSearchViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeSubviews];
    [self updateViews];
    if (self.searchTopic) {
//        话题搜索
        [self showSearchResults];
        self.searchBar.textField.text = self.searchTopic.topic_name;
        [self postSearchWithKeyword:self.searchBar.textField.text];
    } else {
//        热门用户和热门话题
        [self showHotUsersAndHotTopics];
        [self postHotUsersAndHotTopics];
    }
    [self startLocation];
    self.collectionViewEmptyView = [XKEmptyPlaceView configScrollView:self.collectionView config:nil];
}

- (void)initializeSubviews {
    self.searchBar.textField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf postSearchWithKeyword:weakSelf.searchBar.textField.text];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.page > weakSelf.maxPage) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postSearchWithKeyword:weakSelf.searchBar.textField.text];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.collectionView.mj_footer = footer;
}

- (void)updateViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.tableView);
    }];
}

#pragma mark - POST

/**
 获取热门用户和热门话题
 */
- (void)postHotUsersAndHotTopics {
    [self.hotUsers removeAllObjects];
    [self.hotTopics removeAllObjects];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude) forKey:@"lon"];
    [para setObject:@([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude) forKey:@"lat"];
    [para setObject:@(1) forKey:@"page"];
    [XKZBHTTPClient postRequestWithURLString:[XKAPPNetworkConfig getHotUsersAndHotTopicsUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.hotUsers addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchUserModel class] json:responseObject[@"body"][@"data"][@"user"]]];
        [self.hotTopics addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchTopicModel class] json:responseObject[@"body"][@"data"][@"topic"]]];
        self.randomTopic = self.hotTopics[arc4random() % self.hotTopics.count];
        NSMutableAttributedString *placeholderStr = [[NSMutableAttributedString alloc] initWithString:self.randomTopic.topic_name];
        [placeholderStr addAttribute:NSFontAttributeName value:self.searchBar.textField.font range:NSMakeRange(0, placeholderStr.length)];
        [placeholderStr addAttribute:NSForegroundColorAttributeName value:self.searchBar.textField.textColor range:NSMakeRange(0, placeholderStr.length)];
        self.searchBar.textField.attributedPlaceholder = placeholderStr;
        [self.tableView reloadData];
        if (self.hotUsers.count && self.hotTopics.count) {
//            有数据
            [self.tableViewEmptyView hide];
        } else {
//            无数据
            __weak typeof(self) weakSelf = self;
            self.tableViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.tableViewEmptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [weakSelf postHotUsersAndHotTopics];
            }];
        }
    } failure:^(XKHttpErrror *error) {
        if (self.hotUsers.count == 0 && self.hotTopics.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.tableViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.tableViewEmptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postHotUsersAndHotTopics];
            }];
        }
    }];
}

/**
 搜索
 */
- (void)postSearchWithKeyword:(NSString *) keyword {
    [self showSearchResults];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:keyword forKey:@"searchWord"];
    [para setObject:@([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude) forKey:@"lon"];
    [para setObject:@([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude) forKey:@"lat"];
    [para setObject:@(self.page) forKey:@"page"];

    [XKZBHTTPClient postRequestWithURLString:[XKAPPNetworkConfig getSearchUrl] timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        self.maxPage = [responseObject[@"body"][@"data"][@"video"][@"total"] unsignedIntegerValue];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (![self.searchBar.textField.text isEqualToString:keyword]) {
            return ;
        }
        if (self.page == 0) {
            // 第一页，清空所有数组
            [self.collectionView.mj_footer resetNoMoreData];
            [self.resultModel.users removeAllObjects];
            [self.resultModel.topics removeAllObjects];
            [self.resultModel.videos removeAllObjects];
            [self.itemHeights removeAllObjects];
            // 添加搜索到的用户和话题
            [self.resultModel.users addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchUserModel class] json:responseObject[@"body"][@"data"][@"user"]]];
            [self.resultModel.topics addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchTopicModel class] json:responseObject[@"body"][@"data"][@"topic"]]];
            for (XKVideoSearchTopicModel *topic in self.self.resultModel.topics) {
                topic.searchKeyword = keyword;
            }
        }
        [self.resultModel.videos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoDisplayVideoListItemModel class] json:responseObject[@"body"][@"data"][@"video"][@"video_list"]]];
        if (self.searchTopic || (self.resultModel.users.count == 0 && self.resultModel.topics.count == 0 && self.resultModel.videos.count == 0)) {
            self.layout.headerHeight = 0.0;
        } else {
            self.layout.headerHeight = 10.0 + (self.resultModel.users.count ? 64.0 : 0.0) + (self.resultModel.topics.count ? (self.resultModel.topics.count > 4 ? 34.0 * 5 : 34.0 *(self.resultModel.topics.count + 1)) : 0.0);
        }
        for (XKVideoDisplayVideoListItemModel *tempVideo in self.resultModel.videos) {
            [self.itemHeights addObject:@(275.0 * ScreenScale)];
        }
        self.layout.itemHeights = [self.itemHeights copy];
        [self.collectionView reloadData];
        if ((!self.searchTopic && (self.resultModel.users.count || self.resultModel.topics.count || self.resultModel.videos.count)) || (self.searchTopic && self.resultModel.videos.count)) {
//            有数据
            [self.collectionViewEmptyView hide];
        } else {
//            无数据
            __weak typeof(self) weakSelf = self;
            self.collectionViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.collectionViewEmptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [weakSelf postSearchWithKeyword:keyword];
            }];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (self.resultModel.users.count == 0 && self.resultModel.topics.count == 0 && self.resultModel.videos.count == 0) {
            __weak typeof(self) weakSelf = self;
//            修改原有数据以及头部视图高度，刷新页面以保证不会遮挡网络错误视图
            self.layout.headerHeight = 0.0;
            [self.collectionView reloadData];
            self.collectionViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.collectionViewEmptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postSearchWithKeyword:keyword];
            }];
        }
    }];
}

/**
 关注用户
 */
- (void)postFocusUser:(XKVideoSearchUserModel *) user {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:user.id forKey:@"rid"];
    [XKHudView showLoadingTo:self.containView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getFocusUserUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        NSUInteger index = [self.hotUsers indexOfObject:user];
        user.followRelation += 1;
        self.hotUsers[index] = user;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(XKHttpErrror * _Nonnull error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}

/**
 取消关注用户
 */
- (void)postCancelFocusUser:(XKVideoSearchUserModel *) user {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:user.id forKey:@"rid"];
    [XKHudView showLoadingTo:self.containView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:[XKAPPNetworkConfig getCancelFocusUserUrl] timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        NSUInteger index = [self.hotUsers indexOfObject:user];
        user.followRelation -= 1;
        self.hotUsers[index] = user;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(XKHttpErrror * _Nonnull error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (!self.searchTopic) {
        [self showHotUsersAndHotTopics];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.randomTopic && !self.searchBar.textField.text) {
        XKVideoSearchViewController *vc = [[XKVideoSearchViewController alloc] init];
        vc.searchTopic = self.randomTopic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (keyword.length) {
        self.page = 0;
        [self postSearchWithKeyword:keyword];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showHotUsersAndHotTopics];
        });
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hotUsers.count && self.hotTopics.count) {
        return 2;
    } else if (self.hotUsers.count || self.hotTopics.count) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.hotUsers.count) {
        return self.hotUsers.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.hotUsers.count) {
        XKVideoSearchHotUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchHotUserTableViewCell class]) forIndexPath:indexPath];
        if (indexPath.row == self.hotUsers.count - 1) {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 64.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
        }
        XKVideoSearchUserModel *theUser = self.hotUsers[indexPath.row];
        cell.user = theUser;
        cell.focusBtnBlock = ^(XKVideoSearchUserModel *user) {
//            未关注该用户，则关注
            __weak typeof(self) weakSelf = self;
            if (user.followRelation == 0) {
                [weakSelf postFocusUser:theUser];
            } else {
                XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要取消关注" leftButton:@"否" rightButton:@"是" leftBlock:nil rightBlock:^{
                    [weakSelf postCancelFocusUser:theUser];
                } textAlignment:NSTextAlignmentCenter];
                [alertView show];
            }
        };
        return cell;
    } else {
        XKVidelSearchHotTopicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVidelSearchHotTopicsTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configHotTopicsCell:cell dataSource:self.hotTopics indexPath:indexPath];
        [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, self.hotTopicsHeight) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XKVideoSearchHeader *header = [[XKVideoSearchHeader alloc] init];
    if (section == 0 && self.hotUsers.count) {
        header.titleLab.text = @"热门用户";
        [header setMoreViewHidden:YES];
        if (self.hotUsers.count) {
            [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 44.0) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else {
            [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 44.0) byRoundingCorners: UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
        }
    } else {
        header.titleLab.text = @"热门话题";
        header.moreLab.text = @"查看更多";
        if (self.hotTopics.count) {
            [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 44.0) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else {
            [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 44.0) byRoundingCorners: UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
        }
        header.moreBlock = ^{
            XKVideoSearchMoreViewController *vc = [[XKVideoSearchMoreViewController alloc] init];
            vc.dataType = XKVideoSearchDataTypeTopic;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.hotUsers.count) {
        return 64.0;
    }
    return self.hotTopicsHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
        XKVideoSearchUserModel *user = self.hotUsers[indexPath.row];
        vc.userId = user.id;
        vc.hasStatusChangedBlock = ^(XKPesonalDetailInfoModel *personalInfo) {
            for (XKVideoSearchUserModel *user in [self.hotUsers copy]) {
                if ([user.id isEqualToString:personalInfo.userId]) {
                    user.followRelation = personalInfo.followRelation;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[self.hotUsers copy] indexOfObject:user] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                }
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultModel.videos.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && !self.searchTopic) {
        XKVideoSearchCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XKVideoSearchCollectionHeader class]) forIndexPath:indexPath];
        headerView.resultModel = self.resultModel;
        headerView.delegate = self;
        return headerView;
    } else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKVideoCitywideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XKVideoCitywideCollectionViewCell class]) forIndexPath:indexPath];
    [cell configCellWithVideo:self.resultModel.videos[indexPath.row]];
    return cell;
}

#pragma mark - XKVideoSearchCollectionHeaderDelegate

- (void)header:(XKVideoSearchCollectionHeader *) header didClikedMoreUser:(XKVideoSearchUserModel *) user {
    XKVideoSearchMoreViewController *vc = [[XKVideoSearchMoreViewController alloc] init];
    vc.keyword = self.searchBar.textField.text;
    vc.dataType = XKVideoSearchDataTypeUser;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)header:(XKVideoSearchCollectionHeader *) header didClikedUser:(XKVideoSearchUserModel *) user {
    XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
    vc.userId = user.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerDidClikedMoreTopic:(XKVideoSearchCollectionHeader *) header {
    XKVideoSearchMoreViewController *vc = [[XKVideoSearchMoreViewController alloc] init];
    vc.keyword = self.searchBar.textField.text;
    vc.dataType = XKVideoSearchDataTypeTopic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)header:(XKVideoSearchCollectionHeader *) header didClikedTopic:(XKVideoSearchTopicModel *) topic {
    XKVideoSearchViewController *vc = [[XKVideoSearchViewController alloc] init];
    vc.searchTopic = topic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoListItemModel:self.resultModel.videos[indexPath.row]];
}

#pragma mark - privite method

- (void)showHotUsersAndHotTopics {
    self.tableView.hidden = NO;
    self.collectionView.hidden = YES;
}

- (void)showSearchResults {
    self.tableView.hidden = YES;
    self.collectionView.hidden = NO;
}

- (void)startLocation {
    if ([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude == 0.0 &&
        [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude == 0.0) {
        XKBaiduLocation *baiduLocation = [XKBaiduLocation shareManager];
        baiduLocation.delegate = self;
        if (baiduLocation.locationAuthorized) {
            [baiduLocation startBaiduSingleLocationService];
        }
    }
}

- (void)configHotTopicsCell:(XKVidelSearchHotTopicsTableViewCell *)cell dataSource:(NSArray *)array indexPath:(NSIndexPath *)indexPath {

    CGFloat topicViewHeight = 26.0;
    CGFloat topicViewLeftRightMargin = 14.0;
    CGFloat topicViewTopBottomMargin = 15.0;
    CGFloat topicViewMarginH = 18.0;
    CGFloat topicViewMarginV = 16.0;

    CGFloat topicViewInternalMargin = 12.0;
    CGFloat topicViewLabImgMargin = 8.0;
    
    CGFloat topicTypeImgViewSize = 16.0;
    
    UIView *lastView;
    
    CGFloat newHight = 0.0;
    
    for (int index = 0; index < array.count; index++) {
        XKVideoSearchTopicModel *topic = array[index];
        UIView *topicView = [[UIView alloc] init];
        topicView.backgroundColor = HEX_RGB(0xf1f1f1);
        [cell.containerView addSubview:topicView];
        topicView.xk_radius = topicViewHeight / 2.0;
        topicView.xk_clipType = XKCornerClipTypeAllCorners;
        topicView.xk_openClip = YES;
        topicView.tag = 2000 + index;
        UITapGestureRecognizer *topicViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicViewTapAction:)];
        [topicView addGestureRecognizer:topicViewTap];
        
        UILabel *topicLab = [BaseViewFactory labelWithFram:CGRectZero text:topic.topic_name font:XKRegularFont(12.0) textColor:HEX_RGB(0x222222) backgroundColor:[UIColor clearColor]];
        [topicView addSubview:topicLab];
        
        UIImageView *typeImgView = [[UIImageView alloc] init];
        [topicView addSubview:typeImgView];
        
        //        获取文本大小
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        [attrs setObject:XKRegularFont(12.0) forKey:NSFontAttributeName];
        CGSize topicSize = [topic.topic_name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - (10.0 + topicViewLeftRightMargin + topicViewInternalMargin) * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        topicLab.frame = CGRectMake(topicViewInternalMargin, 0.0, topicSize.width + 1.0, topicViewHeight);
        
        //        添加话题类型图片，现去除，暂留
        if (0) {
            typeImgView.image = IMG_NAME(@"xk_bg_video_new");
            typeImgView.frame = CGRectMake(CGRectGetMaxX(topicLab.frame) + topicViewLabImgMargin, (topicViewHeight - topicTypeImgViewSize) / 2, topicTypeImgViewSize, topicTypeImgViewSize);
            topicSize = CGSizeMake(CGRectGetMaxX(typeImgView.frame) + topicViewInternalMargin, topicViewHeight);
        } else {
            topicSize = CGSizeMake(CGRectGetMaxX(topicLab.frame) + topicViewInternalMargin, topicViewHeight);
        }
        topicView.frame = CGRectMake(lastView ? CGRectGetMaxX(lastView.frame) + topicViewMarginH : topicViewLeftRightMargin, lastView ? CGRectGetMinY(lastView.frame) : topicViewTopBottomMargin, topicSize.width, topicSize.height);
        if (CGRectGetMaxX(topicView.frame) > SCREEN_WIDTH - 10.0 * 2 - topicViewLeftRightMargin) {
            topicView.frame = CGRectMake(topicViewLeftRightMargin, lastView ? CGRectGetMaxY(lastView.frame) + topicViewMarginV: topicViewTopBottomMargin, topicSize.width, topicSize.height);
        }
        newHight = CGRectGetMaxY(topicView.frame) + topicViewTopBottomMargin;
        lastView = topicView;
    }
    if (newHight != self.hotTopicsHeight) {
        self.hotTopicsHeight = newHight;
        [self.tableView reloadData];
    }
}

- (void)topicViewTapAction:(UIGestureRecognizer *) sender {
    XKVideoSearchTopicModel *topic = self.hotTopics[sender.view.tag - 2000];
    XKVideoSearchViewController *vc = [[XKVideoSearchViewController alloc] init];
    vc.searchTopic = topic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter / Getter

- (NSMutableArray *)hotUsers {
    if (!_hotUsers) {
        _hotUsers = [NSMutableArray array];
    }
    return _hotUsers;
}

- (NSMutableArray *)hotTopics {
    if (!_hotTopics) {
        _hotTopics = [NSMutableArray array];
    }
    return _hotTopics;
}

- (XKVideoCitywideCollectionViewLayout *)layout {
    if (!_layout) {
        _layout = [[XKVideoCitywideCollectionViewLayout alloc] init];
        _layout.type = XKVideoCitywideCollectionViewLayoutTypeVertical;
        _layout.headerHeight = 54;
        _layout.numberOfColumns = 2;
        _layout.columnGap = 10;
        _layout.rowGap = 10;
        _layout.insets = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.backgroundColor = HEX_RGB(0xf6f6f6);
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        [_collectionView registerClass:[XKVideoSearchCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XKVideoSearchCollectionHeader class])];
        [_collectionView registerClass:[XKVideoCitywideCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XKVideoCitywideCollectionViewCell class])];
    }
    return _collectionView;
}

- (XKVideoSearchResultModel *)resultModel {
    if (!_resultModel) {
        _resultModel = [[XKVideoSearchResultModel alloc] init];
    }
    return _resultModel;
}

- (NSMutableArray *)itemHeights {
    if (!_itemHeights) {
        _itemHeights = [NSMutableArray array];
    }
    return _itemHeights;
}

@end
