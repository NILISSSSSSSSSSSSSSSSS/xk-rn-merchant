//
//  XKMessageChatHistoryViewController.m
//  XKSquare
//
//  Created by william on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageChatHistoryViewController.h"
#import "XKTransformHelper.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKP2PChatViewController.h"
#import "XKSecretFrientManager.h"
#import "XKSecretChatViewController.h"
@interface XKMessageChatHistoryViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIButton          *cancelButton;

@property (nonatomic, strong) UITableView       *mainTabelView;

@property (nonatomic, strong) UITextField       *searchTextField;

@property (nonatomic, strong) UIView            *searchBackView;

@property (nonatomic, strong) NSMutableArray    *dataArr;

@property (nonatomic, copy) NSString            *keyword;
@end

@implementation XKMessageChatHistoryViewController

#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _keyword = [NSString string];
    [self confiViews];
    [self autoLayout];
}

#pragma mark – Private Methods
-(void)confiViews{
    [self hiddenBackButton:YES];
    if(self.secretID){
        self.navStyle = BaseNavWhiteStyle;
        [self hideNavigationSeperateLine];
    }
    [self.navigationView addSubview:self.cancelButton];
    [self.navigationView addSubview:self.searchBackView];
    [self.view addSubview:self.mainTabelView];
}

-(void)autoLayout{
    XKWeakSelf(weakSelf);
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchBackView);
        make.right.mas_equalTo(weakSelf.navigationView.mas_right).offset(-24 * ScreenScale);
//        make.size.mas_equalTo(CGSizeMake(35 * ScreenScale, 25 * ScreenScale));
    }];
    
    [_searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.navigationView.mas_left).offset(10 * ScreenScale);
        make.right.mas_equalTo(weakSelf.cancelButton.mas_left).offset(-10 * ScreenScale);
        make.bottom.mas_equalTo(weakSelf.navigationView.mas_bottom).offset(-7 );
        make.height.mas_equalTo(30 * ScreenScale);
    }];
    
    [_mainTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.navigationView.mas_bottom).offset(10 * ScreenScale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    
}
#pragma mark - Events
-(void)cancelButtonClicked:(UIButton *)sender{
  
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"XKFriendMessageListTableViewCell";
    XKFriendMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[XKFriendMessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.searchKeyWord = _keyword;
    cell.message = _dataArr[indexPath.row];
    cell.xk_openClip = YES;
    cell.xk_radius = 8;
    
    if (_dataArr.count == 1) {
        cell.xk_clipType = XKCornerClipTypeAllCorners;
    }
    else{
        if (indexPath.row == 0) {
            cell.xk_clipType = XKCornerClipTypeTopBoth;

        }
        else if (indexPath.row == (_dataArr.count - 1)) {
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
        }
        else{
            cell.xk_clipType = XKCornerClipTypeNone;
        }
    }
    
    
    return cell;
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 * ScreenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NIMMessage *message = _dataArr[indexPath.row];
    NIMSession *session;
    if (_session.sessionType == NIMSessionTypeP2P) {
        session = [NIMSession session:message.session.sessionId type:NIMSessionTypeP2P];
    }
    else if(_session.sessionType == NIMSessionTypeTeam){
        session = [NIMSession session:message.session.sessionId type:NIMSessionTypeTeam];
    }
    else{
        
    }
    if (_secretID) {
        XKSecretChatViewController *vc = [[XKSecretChatViewController alloc]initWithSession:session];
        vc.secretID = _secretID;
        vc.searchMessage = message;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        XKP2PChatViewController *vc = [[XKP2PChatViewController alloc] initWithSession:session];
        vc.searchMessage = message;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 0, 0) font:XKMediumFont(17) title:@"取消" titleColor:self.secretID ? UIColorFromRGB(0x222222):UIColorFromRGB(0xffffff) backColor:self.secretID ?[UIColor whiteColor]:XKMainTypeColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIView *)searchBackView{
    if (!_searchBackView) {
        _searchBackView = [[UIView alloc]init];
        _searchBackView.backgroundColor = HEX_RGBA(0xeeeeee, 0.5);
        _searchBackView.xk_openClip = YES;
        _searchBackView.xk_radius = 15 * ScreenScale;
        _searchBackView.xk_clipType = XKCornerClipTypeAllCorners;
        
        XKWeakSelf(weakSelf);
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_iocn_searchBar"]];
        if (self.secretID) {
            searchIcon.tintColor = UIColorFromRGB(0x222222);
            [searchIcon setImage:[[UIImage imageNamed:@"xk_iocn_searchBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
        [_searchBackView addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.searchBackView.mas_centerY);
            make.left.mas_equalTo(weakSelf.searchBackView.mas_left).offset(15 * ScreenScale);
            make.size.mas_equalTo(CGSizeMake(14 * ScreenScale, 16 * ScreenScale));
        }];
        
        [_searchBackView addSubview:self.searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.searchBackView.mas_right).offset(-15 * ScreenScale);
            make.left.mas_equalTo(searchIcon.mas_right).offset(7 * ScreenScale);
            make.top.and.bottom.mas_equalTo(weakSelf.searchBackView);
        }];
    }
    return _searchBackView;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [BaseViewFactory textFieldWithFrame:CGRectMake(0, 0, 0, 0) font:XKRegularFont(14) placeholder:@"" textColor:self.secretID?UIColorFromRGB(0x222222):[UIColor whiteColor] placeholderColor:UIColorFromRGB(0xeeeeee) delegate:self];
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _searchTextField;
}

-(UITableView *)mainTabelView{
    if (!_mainTabelView) {
        _mainTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _mainTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTabelView.dataSource = self;
        _mainTabelView.delegate = self;
        _mainTabelView.backgroundColor = [UIColor clearColor];
    }
    return _mainTabelView;
}
#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField{
    [_dataArr removeAllObjects];
    if (_secretID) {
        [self getSecretHitoryWithString:textField.text];
    }
    else{
        [self getP2PHistoryWithString:textField.text];
    }
}

-(void)getSecretHitoryWithString:(NSString *)wordString{
    XKWeakSelf(weakSelf);
    if (wordString.length > 0) {
        NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
        option.limit = 0;
        option.order = NIMMessageSearchOrderDesc;
        option.messageTypes = @[@(NIMMessageTypeCustom)];
        [[NIMSDK sharedSDK].conversationManager searchMessages:_session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
            [weakSelf.dataArr removeAllObjects];
            NSLog(@"");
            for (NIMMessage *message in messages) {
                NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",message.messageObject]];
                if (dict[@"type"] &&
                    [dict[@"type"]integerValue] == XK_NORMAL_TEXT &&
                    [dict[@"data"][@"msgContent"] containsString:wordString]) {
                    
                    if (message.isOutgoingMsg) {
                        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
                            [weakSelf.dataArr addObject:message];
                        }
                    }
                    else{
                        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneSecret || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
                            [weakSelf.dataArr addObject:message];
                        }
                        else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
                            if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
                                [weakSelf.dataArr addObject:message];
                            }
                        }else{
                            
                        }
                    }
                }
            }
            weakSelf.keyword = wordString;
            [weakSelf.mainTabelView reloadData];
        }];
    }
    else{
        [weakSelf.mainTabelView reloadData];
    }
}

-(void)getP2PHistoryWithString:(NSString *)wordString{
    XKWeakSelf(weakSelf);
    if (wordString.length > 0) {
        NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
        option.limit = 0;
        option.order = NIMMessageSearchOrderDesc;
        option.messageTypes = @[@(NIMMessageTypeCustom)];
        [[NIMSDK sharedSDK].conversationManager searchMessages:_session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
            [weakSelf.dataArr removeAllObjects];
            NSLog(@"");
            for (NIMMessage *message in messages) {
                NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",message.messageObject]];
                if (dict[@"type"] &&
                    [dict[@"type"]integerValue] == XK_NORMAL_TEXT &&
                    [dict[@"data"][@"msgContent"] containsString:wordString]) {
                    
                    if (message.isOutgoingMsg) {
                        if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                            [weakSelf.dataArr addObject:message];
                        }
                    }
                    else{
                        if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneNomal || [XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneAll) {
                            [weakSelf.dataArr addObject:message];
                        }
                        else if ([XKSecretFrientManager showMessagesSceneWithUserID:message.session.sessionId] == XKShowMessagesSceneRespective){
                            if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                                [weakSelf.dataArr addObject:message];
                            }
                        }else{
                            
                        }
                    }
                }
            }
            weakSelf.keyword = wordString;
            [weakSelf.mainTabelView reloadData];
        }];
    }
    else{
        [weakSelf.mainTabelView reloadData];
    }
}
@end
