//
//  XKCustomServiceGoodsView.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomServiceGoodsView.h"
#import "XKCustomServiceGoodsCell.h"
#import "XKCustomSearchBar.h"
@interface XKCustomServiceGoodsView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSString *titleStr;
/**底部按钮*/
@property(nonatomic, strong) UIButton *sureBtn;

/**搜索视图*/
@property(nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) XKCustomSearchBar  *searchBar;
@end

@implementation XKCustomServiceGoodsView

- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title {
  self = [[XKCustomServiceGoodsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360 + kBottomSafeHeight)];
  if(self) {
    self.dataArr = ticketArr;
    self.titleStr = title;
    
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if(self) {
    [self addCustomSubviews];
    [self addUIConstraint];
    
  }
  return self;
}

- (void)addCustomSubviews {
  [self addSubview:self.tableView];
  [self addSubview:self.sureBtn];
  
}

- (void)addUIConstraint {
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.right.equalTo(self);
    make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
  }];
  
  [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self);
    make.bottom.equalTo(self.mas_bottom).offset(-kBottomSafeHeight);
    make.height.mas_equalTo(45);
  }];
  
}

- (void)setDataArr:(NSArray *)dataArr {
  _dataArr = dataArr;
  [self.tableView reloadData];
}

- (void)setSearchType:(ListType)searchType {
  _searchType = searchType;
  [self.tableView reloadData];
}

- (void)sureBtnClick:(UIButton *)sender {
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;//_dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    if (self.searchType == ListTypeSearch) {
        return  50;
    } else {
        return  0.01;
    }
  }
  return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return kBottomSafeHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *view = [UIView new];
  view.backgroundColor = UIColorFromRGB(0xf0f0f0);
  if (section == 0) {
    if (self.searchType == ListTypeSearch) {
      return  self.searchView;
    } else {
      return  view;
    }
  }
  return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *view = [UIView new];
  view.backgroundColor = UIColorFromRGB(0xf0f0f0);
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return  100 * ScreenScale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XKWeakSelf(ws);
  
  XKCustomServiceGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKCustomServiceGoodsCell" forIndexPath:indexPath];
  cell.index = indexPath;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
}

- (UITableView *)tableView {
  if(!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _tableView.xk_openClip = YES;
    _tableView.xk_radius = 6.f;
    _tableView.xk_clipType = XKCornerClipTypeTopBoth;
    _tableView.tableHeaderView = self.headerView;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerClass:[XKCustomServiceGoodsCell class] forCellReuseIdentifier:@"XKCustomServiceGoodsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
  }
  return _tableView;
}

- (UIView *)headerView {
  if(!_headerView) {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:self.titleLabel];
//    _headerView.xk_openClip = YES;
//    _headerView.xk_radius = 6.f;
//    _headerView.xk_clipType = XKCornerClipTypeTopBoth;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = XKSeparatorLineColor;
    [_headerView addSubview:lineView];
  }
  return _headerView;
}

- (UILabel *)titleLabel {
  if(!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 40, 50)];
    _titleLabel.text = @"选择要发送的服务";
    _titleLabel.textColor =  [UIColor blackColor];
    _titleLabel.font = XKRegularFont(15.f);

  }
  return _titleLabel;
}

// 懒加载
-(UIButton *)sureBtn {
  if (!_sureBtn) {
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [_sureBtn setBackgroundColor:XKMainTypeColor];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_sureBtn setTitle:@"确认" forState:0];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _sureBtn;
}

// 懒加载
- (UIView *)searchView  {
  if (!_searchView) {
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _searchView.backgroundColor = [UIColor whiteColor];
    [_searchView addSubview:self.searchBar];
  }
  return _searchView;
}

// 懒加载
-(XKCustomSearchBar *)searchBar {
  if (!_searchBar) {
    _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(45 * ScreenScale, 10, SCREEN_WIDTH - 90 * ScreenScale, 30)];
    _searchBar.textField.delegate = self;

    [_searchBar setTextFieldWithBackgroundColor:UIColorFromRGB(0xf1f1f1)  tintColor:RGBA(255, 204, 207, 1) textFont:[UIFont systemFontOfSize:15] textColor:RGBA(255, 204, 207, 1) textPlaceholderColor:RGBA(255, 204, 207, 1) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
    _searchBar.textField.placeholder = @"输入商品名称";
    _searchBar.textField.textColor = [UIColor whiteColor];
  
  }
  return _searchBar;
}
@end
