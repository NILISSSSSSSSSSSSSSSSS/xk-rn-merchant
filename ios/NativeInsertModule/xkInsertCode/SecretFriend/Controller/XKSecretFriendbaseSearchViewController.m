//
//  XKSecretFriendbaseSearchViewController.m
//  XKSquare
//
//  Created by william on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSecretFriendbaseSearchViewController.h"
#import "UIView+XKCornerRadius.h"
#import "XKFriendMessageListTableViewCell.h"
@interface XKSecretFriendbaseSearchViewController ()<UITableViewDelegate,UITableViewDataSource>


/**
 取消按钮
 */
@property(nonatomic,strong) UIButton *cancelButton;


/**
 搜索页面
 */
@property(nonatomic,strong) UIView  *searchView;

/**
 搜索TextField
 */
@property(nonatomic,strong)UITextField  *searchTextField;

/**
 搜索结果列表
 */
@property(nonatomic,strong) UITableView *serchMainTableView;

@end

@implementation XKSecretFriendbaseSearchViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark – Private Methods
-(void)setViews{
    [self hiddenBackButton:YES];
    
    [self.navigationView addSubview:self.cancelButton];
    [self.navigationView addSubview:self.searchView];
    [self.navigationView addSubview:self.searchTextField];
    [self.view addSubview:self.serchMainTableView];
}

-(void)setLayout{
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navigationView.mas_right).offset(-24 * ScreenScale);
        make.bottom.mas_equalTo(self.navigationView.mas_bottom).offset(-10 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(34, 24 * ScreenScale));
    }];
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navigationView.mas_bottom).offset(-7 * ScreenScale);
        make.right.mas_equalTo(self->_cancelButton.mas_left).offset(-10 * ScreenScale);
        make.left.mas_equalTo(self.navigationView.mas_left).offset(10 * ScreenScale);
        make.height.mas_equalTo(30 * ScreenScale);
    }];
    
    UIImageView *seachImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_iocn_searchBar"]];
    [_searchView addSubview:seachImageView];
    [seachImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_searchView.mas_left).offset(15 * ScreenScale);
        make.centerY.mas_equalTo(self->_searchView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16 * ScreenScale, 16 * ScreenScale));
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self->_searchView);
        make.left.mas_equalTo(seachImageView.mas_right).offset(7 * ScreenScale);
        make.right.mas_equalTo(self->_searchView.mas_right).offset(-15 * ScreenScale);
    }];
   
}
#pragma mark - Events
-(void)cancelButtonClicked:(UIButton *) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"XKFriendMessageListTableViewCell";
    XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[XKFriendMessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.xk_openClip = YES;
    cell.xk_radius = 8;
    if (indexPath.row == 0 ) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row != 14) {
        cell.xk_clipType = XKCornerClipTypeNone;
    } else {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ScreenScale;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKMediumFont(17) title:@"取消" titleColor:UIColorFromRGB(0xffffff) backColor:[UIColor clearColor]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = HEX_RGBA(0xeeeeee, 0.4);
        _searchView.xk_openClip = YES;
        _searchView.xk_radius = 15 * ScreenScale;
        _searchView.xk_clipType = XKCornerClipTypeAllCorners;
        
    }
    return _searchView;
}


-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField  = [BaseViewFactory textFieldWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) placeholder:nil textColor:UIColorFromRGB(0xffffff) placeholderColor:nil delegate:nil];

    }
    return _searchTextField;
}

-(UITableView *)serchMainTableView{
    if (!_serchMainTableView) {
        _serchMainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, NavigationAndStatue_Height, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height) style:UITableViewStyleGrouped];
        _serchMainTableView.delegate = self;
        _serchMainTableView.dataSource = self;
        _serchMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _serchMainTableView;
}
@end
