//
//  XKSizerSiftView.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSizerSiftView.h"


@interface XKSizerSiftView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSArray     *dataSource;


@end



@implementation XKSizerSiftView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    return self;
}


- (void)initViews {
    [self addSubview:self.tableView];
}


- (void)layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = HEX_RGB(0x222222);
        cell.textLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(3, 43, self.width - 6, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        [cell addSubview:line];
    }
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    if ([dic[@"image"] length]) {
        cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(siftTableView:didSelectRowAtIndexPath:selectedTitle:)]) {
        NSDictionary *dic = _dataSource[indexPath.row];
        [self.delegate siftTableView:tableView didSelectRowAtIndexPath:indexPath selectedTitle:dic[@"title"]];
    }
}


#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

@end
