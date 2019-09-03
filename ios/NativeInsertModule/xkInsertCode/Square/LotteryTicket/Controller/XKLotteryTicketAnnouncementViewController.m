//
//  XKLotteryTicketAnnouncementViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketAnnouncementViewController.h"
#import "XKLotteryTicketAnnouncementHeader.h"
#import "XKLotteryTicketAnnouncementFooter.h"
#import "XKLotteryTicketNumbersTableViewCell.h"
#import "XKLotteryTicketAnnouncementInfoTableViewCell.h"
#import "XKCommonSheetView.h"
#import "XKLotteryTicketAnnouncementTipsView.h"
#import "XKLotteryTicketEditContactInfoViewController.h"

typedef NS_OPTIONS(NSUInteger, XKLotteryTicketStatusType) {
    XKLotteryTicketStatusTypeHasNoResult = 1 << 0, // 未开奖
    XKLotteryTicketStatusTypeWin = 1 << 1, // 中奖了，未领取
    XKLotteryTicketStatusTypeLose = 1 << 2, // 未中奖
};

@interface XKLotteryTicketAnnouncementViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) XKLotteryTicketStatusType statusType;

@property (nonatomic, strong) XKLotteryTicketAnnouncementHeader *header;

@property (nonatomic, strong) XKLotteryTicketAnnouncementFooter *footer;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *statusImgView;

@property (nonatomic, strong) NSArray *infos;

@end

@implementation XKLotteryTicketAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"开奖公告" WithColor:HEX_RGB(0xFFFFFF)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initializeViews];
        [self updateViews];
        [self refreshStatusImgView];
        if (self.statusType != XKLotteryTicketStatusTypeHasNoResult) {
            [self showTipsView];
        }
    });
}

- (void)initializeViews {
    
    self.header = [[XKLotteryTicketAnnouncementHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 70.0)];
    self.header.containerView.xk_radius = 6.0;
    self.header.containerView.xk_clipType = XKCornerClipTypeTopBoth;
    self.header.containerView.xk_openClip = YES;
    [self.header.containerView xk_forceClip];
    self.footer = [[XKLotteryTicketAnnouncementFooter alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 84.0)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[XKLotteryTicketNumbersTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLotteryTicketNumbersTableViewCell class])];
    [self.tableView registerClass:[XKLotteryTicketAnnouncementInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLotteryTicketAnnouncementInfoTableViewCell class])];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.containView addSubview:self.tableView];
    
    self.statusImgView = [[UIImageView alloc] init];
    [self.tableView addSubview:self.statusImgView];
    self.statusImgView.hidden = YES;
}

- (void)updateViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
}

#pragma mark - Privite Method

- (void)refreshStatusImgView {
    self.statusImgView.hidden = self.statusType == XKLotteryTicketStatusTypeHasNoResult;
    if (self.statusType == XKLotteryTicketStatusTypeWin) {
        self.statusImgView.image = IMG_NAME(@"xk_img_lotteryTicket_winLottery");
    } else if (self.statusType == XKLotteryTicketStatusTypeLose) {
        self.statusImgView.image = IMG_NAME(@"xk_img_lotteryTicket_loseLottery");
    }
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [self.statusImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetMinY(cell.frame));
        make.trailing.mas_equalTo(cell).offset(-20.0);
        make.width.height.mas_equalTo(77.0);
    }];
}

- (void)showTipsView {
    XKCommonSheetView *sheet = [[XKCommonSheetView alloc] init];
    XKLotteryTicketAnnouncementTipsView *tips = [[XKLotteryTicketAnnouncementTipsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (self.statusType == XKLotteryTicketStatusTypeWin) {
        tips.viewType = XKLotteryTicketAnnouncementTipsViewTypeWin;
        if (1) {
            // 需要领取
            tips.contentStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
                confer.text([NSString stringWithFormat:@"恭喜您，获得大乐透%.2f元大奖！", 500.0]).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
            }];
            tips.confirmBtnTitle = @"立即领取";
        } else {
            // 不需要领取，自动存入账户
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜您，获得大乐透奖金%.2f元，奖金将1-3个工作日自动存入您的账户！", 500.0]];
            [str addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x222222) range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:[str.string rangeOfString:[NSString stringWithFormat:@"%.2f元", 500.0]]];
            tips.contentStr = str;
            tips.confirmBtnTitle = @"确认";
        }
    } else if (self.statusType == XKLotteryTicketStatusTypeLose) {
        tips.viewType = XKLotteryTicketAnnouncementTipsViewTypeLose;
        tips.contentStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"实在抱歉，您未中奖！").font(XKRegularFont(14.0)).textColor(HEX_RGB(0x222222));
        }];
        tips.confirmBtnTitle = @"再次抽奖";
    }
    
    tips.closeBtnBlock = ^{
        [sheet dismiss];
    };
    tips.confirmBtnBlock = ^{
        [sheet dismiss];
        if (self.statusType == XKLotteryTicketStatusTypeWin) {
            if (1) {
                // 需要领取
                XKLotteryTicketEditContactInfoViewController *vc = [[XKLotteryTicketEditContactInfoViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                // 不需要领取，自动存入账户
                
            }
        } else if (self.statusType == XKLotteryTicketStatusTypeLose) {
            
        }
    };
    
    sheet.contentView = tips;
    [sheet addSubview:tips];
    sheet.animationWay = AnimationWay_centerShow;
    [sheet show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return self.infos.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XKLotteryTicketNumbersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLotteryTicketNumbersTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = XKLotteryTicketNumbersCellTypeText;
        if (indexPath.row == 0) {
            cell.title = @"开奖号码：";
        } else {
            cell.title = @"投注号码：";
        }
        return cell;
    } else {
        XKLotteryTicketAnnouncementInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLotteryTicketAnnouncementInfoTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *infoDic = self.infos[indexPath.row];
        cell.infoLab.text = infoDic[@"title"];
        cell.infoContentLab.text = infoDic[@"contentn"];
        if ([infoDic[@"id"] isEqualToString:@"money"]) {
            cell.infoContentLab.font = XKRegularFont(14.0);
            cell.infoContentLab.textColor = XKMainRedColor;
        } else {
            cell.infoContentLab.font = XKMediumFont(14.0);
            cell.infoContentLab.textColor = HEX_RGB(0x555555);
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15.0;
    } else {
        return 5.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = HEX_RGB(0xFFFFFF);
    [view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40.0;
    } else {
        return 30.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = HEX_RGB(0xFFFFFF);
    [view addSubview:containerView];
    if (section == 0) {
        containerView.xk_radius = 0.0;
        containerView.xk_clipType = XKCornerClipTypeNone;
        containerView.xk_openClip = YES;
        [containerView xk_forceClip];
    } else {
        containerView.xk_radius = 6.0;
        containerView.xk_clipType = XKCornerClipTypeBottomBoth;
        containerView.xk_openClip = YES;
        [containerView xk_forceClip];
    }
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter setter

- (NSArray *)infos {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{
                       @"id" : @"num",
                       @"title" : @"投注信息：",
                       @"content" : @"",
                       }
     ];
    [array addObject:@{
                       @"id" : @"buyTime",
                       @"title" : @"投注时间：",
                       @"content" : @"",
                       }
     ];
    [array addObject:@{
                       @"id" : @"id",
                       @"title" : @"投注编号：",
                       @"content" : @"",
                       }
     ];
    [array addObject:@{
                       @"id" : @"winTime",
                       @"title" : @"开奖时间：",
                       @"content" : @"",
                       }
     ];
    if (self.statusType == XKLotteryTicketStatusTypeWin) {
        [array addObject:@{
                           @"id" : @"money",
                           @"title" : @"中奖金额：",
                           @"content" : @"",
                           }
         ];
    }
    return [array copy];
}

- (XKLotteryTicketStatusType)statusType {
//    if (1) {
//        return XKLotteryTicketStatusTypeHasNoResult;
//    } else if (1) {
        return XKLotteryTicketStatusTypeWin;
//    } else if (1) {
//        return XKLotteryTicketStatusTypeLose;
//    } else {
//        return -1;
//    }
}

@end
