//
//  XKMallGoodsDetailBottomView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsDetailBottomView.h"
#import "XKMallDetailBottomViewInfoCell.h"
#import "XKMallDetailBottomViewParamCell.h"
#import "XKMallDetailBottomViewCountCell.h"
@interface XKMallGoodsDetailBottomView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *sureBtn;
@property (nonatomic, assign)NSInteger rowCount;
@property (nonatomic, strong)UIView * footerView;
@property (nonatomic, strong)XKMallGoodsDetailViewModel  *model;
@end

@implementation XKMallGoodsDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
         _rowCount = 4;
        [self addCustomSubviews];
       
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.tableView];
    [self addSubview:self.footerView];
}

- (void)updateDataWithModel:(XKMallGoodsDetailViewModel *)model {
    _model = model;
    [self.tableView reloadData];
}

- (void)sureBtnClick:(UIButton *)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.skuAttr.attrList.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 110 : indexPath.row == _model.skuAttr.attrList.count + 1 ? 60 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        XKMallDetailBottomViewInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallDetailBottomViewInfoCell" forIndexPath:indexPath];
        return cell;
    }
    //计数cell
    if(indexPath.row == _model.skuAttr.attrList.count + 1) {
        XKMallDetailBottomViewCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallDetailBottomViewCountCell" forIndexPath:indexPath];
        return cell;
    }
    //属性cell
    XKMallGoodsDetailAttrListItem *item = _model.skuAttr.attrList[indexPath.row - 1];
    XKMallDetailBottomViewParamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallDetailBottomViewParamCell" forIndexPath:indexPath];
    [cell updateDataWithAttr:item];
    cell.choseIndexBlock = ^(NSInteger index) {
        
    };
    return cell;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKMallDetailBottomViewInfoCell class] forCellReuseIdentifier:@"XKMallDetailBottomViewInfoCell"];
        [_tableView registerClass:[XKMallDetailBottomViewCountCell class] forCellReuseIdentifier:@"XKMallDetailBottomViewCountCell"];
         [_tableView registerClass:[XKMallDetailBottomViewParamCell class] forCellReuseIdentifier:@"XKMallDetailBottomViewParamCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)footerView {
    if(!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 50 - kBottomSafeHeight, SCREEN_WIDTH, 50 + kBottomSafeHeight)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:self.sureBtn];
    }
    return _footerView;
}

- (UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [_sureBtn setTitle:@"确定" forState:0];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        _sureBtn.titleLabel.font = XKRegularFont(17);
        [_sureBtn setBackgroundColor:XKMainTypeColor];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
