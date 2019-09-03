//
//  XKVideoSearchBaseViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchBaseViewController.h"

#import "XKCustomSearchBar.h"
#import "XKVideoSearchHotUserTableViewCell.h"
#import "XKVidelSearchHotTopicsTableViewCell.h"
#import "XKVideoSearchHotTopicTableViewCell.h"
#import "XKVideoSearchUserTableViewCell.h"
#import "XKVideoSearchTopicTableViewCell.h"

const CGFloat backBtnLeftSpaceMargin = 15.0;
const CGFloat backBtnWidth = 60.0;
const CGFloat searchBarLeftMargin = 13.0;
const CGFloat searchBarRightMargin = 25.0;

@interface XKVideoSearchBaseViewController ()

@end

@implementation XKVideoSearchBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeBaseViews];
    [self updateBaseViews];
    self.tableViewEmptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initializeBaseViews {
    self.navigationView.backgroundColor = XKMainTypeColor;
    [self.navigationView addSubview:self.searchBar];
    [self.containView addSubview:self.tableView];
}

- (void)updateBaseViews {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
}

- (XKCustomSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(54.0, kIphoneXNavi(27), SCREEN_WIDTH - 54.0 - searchBarRightMargin, 30)];
        [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]  tintColor:RGBA(255, 204, 207, 1) textFont:XKRegularFont(15.0) textColor:[UIColor whiteColor] textPlaceholderColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft masksToBounds:YES];
        _searchBar.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *placeholderStr = [[NSMutableAttributedString alloc] initWithString:@"请输入搜索关键字"];
        [placeholderStr addAttribute:NSFontAttributeName value:_searchBar.textField.font range:NSMakeRange(0, placeholderStr.length)];
        [placeholderStr addAttribute:NSForegroundColorAttributeName value:_searchBar.textField.textColor range:NSMakeRange(0, placeholderStr.length)];
        _searchBar.textField.attributedPlaceholder = placeholderStr;
        [_searchBar.textField enableSecretJump:YES];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.tableHeaderView = self.clearHeaderView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableView registerClass:[XKVideoSearchHotUserTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchHotUserTableViewCell class])];
        [_tableView registerClass:[XKVidelSearchHotTopicsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVidelSearchHotTopicsTableViewCell class])];
        [_tableView registerClass:[XKVideoSearchUserTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchUserTableViewCell class])];
        [_tableView registerClass:[XKVideoSearchHotTopicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchHotTopicTableViewCell class])];
        [_tableView registerClass:[XKVideoSearchTopicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchTopicTableViewCell class])];
    }
    return _tableView;
}

@end
