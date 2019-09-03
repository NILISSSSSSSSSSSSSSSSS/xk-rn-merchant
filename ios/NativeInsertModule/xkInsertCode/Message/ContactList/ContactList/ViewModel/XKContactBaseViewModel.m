/*******************************************************************************
 # File        : XKContactBaseViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/19
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactBaseViewModel.h"
#import "UIView+Border.h"

@interface XKContactBaseViewModel ()

/**搜索数据源*/
@property(nonatomic, strong) NSMutableArray *searchResultArray;
/**索引数组*/
@property(nonatomic, copy) NSArray *indexArray;
/**分区数据*/
@property(nonatomic, copy) NSArray *sectionDataArray;

@end

@implementation XKContactBaseViewModel

- (instancetype)init
{
  self = [super init];
  if (self) {
    _indexArray = [NSMutableArray array];
    _searchResultArray = [NSMutableArray array];
  }
  return self;
}

- (void)createDefault {
  _dataArray = [NSMutableArray array];
  _searchResultArray = [NSMutableArray array];
}

- (void)buildData {
  // 创建索引
  _indexArray = [NSMutableArray array];
  NSArray *indexArray;
  // 没有备注 就把名字作为备注
  [self.dataArray enumerateObjectsUsingBlock:^(XKContactModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (self.isSecret) {
      if (obj.secretRemark.length == 0) {
        obj.secretRemark = obj.nickname;
      }
    } else {
      if (obj.friendRemark.length == 0) {
        obj.friendRemark = obj.nickname;
      }
    }
  }];
  self.sectionDataArray = [self sortObjectsIndexArray:&indexArray dataArray:self.dataArray];
  self.indexArray = indexArray;
}

#pragma mark - 搜索相关
- (void)textFieldChange:(UITextField *)textField {
  BOOL change = NO;
  if (textField.text.length == 0) {
    self.searchStatus = NO;
    EXECUTE_BLOCK(self.searchStatusChangeBlock);
    return;
  } else {
    if (self.searchStatus == NO) {
      change = YES;
    }
    self.searchStatus = YES;
    if (change == YES) {
      EXECUTE_BLOCK(self.searchStatusChangeBlock);
    }
  }
  
  NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
  if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 有高亮选择的字 则不搜索
    if (position) {
      return;
    }
  }
  [self searchContentChanged:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)searchContentChanged:(NSString *)text {
  [_searchResultArray removeAllObjects];
  for (XKContactModel *model in self.dataArray) {
    if ([self compareStr:model.friendRemark containStr:text]) {
      [_searchResultArray addObject:model];
    }
  }
  self.refreshBlock();
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (!self.searchStatus) {
    return self.indexArray.count;
  }
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!self.searchStatus) {
    return [self.sectionDataArray[section] count];
  }
  return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //    __weak typeof(self) weakSelf = self;
  static NSString *rid = @"cell";
  XKContactListCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
  if(cell == nil){
    cell = [[XKContactListCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
  }
  cell.indexPath = indexPath;
  cell.myContentView.xk_openClip = YES;
  cell.myContentView.xk_radius = 8;
  
  if (!self.searchStatus) {
    if (indexPath.section == self.indexArray.count - 1 && indexPath.row == [self.sectionDataArray[self.indexArray.count - 1] count] - 1) {
      cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
      cell.hideSeperate = YES;
    } else {
      cell.myContentView.xk_openClip = XKCornerClipTypeNone;
      cell.hideSeperate = NO;
    }
    cell.model = self.sectionDataArray[indexPath.section][indexPath.row];
  } else {
    if (indexPath.row == 0) {
      cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
      cell.hideSeperate = NO;
      if (self.searchResultArray.count == 1) {
        cell.myContentView.xk_clipType = XKCornerClipTypeAllCorners;
        cell.hideSeperate = YES;
      }
    } else if (indexPath.row != self.searchResultArray.count - 1) { // 不是最后一个
      cell.myContentView.xk_clipType = XKCornerClipTypeNone;
      cell.hideSeperate = NO;
    } else { // 最后一个
      cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
      cell.hideSeperate = YES;
    }
    cell.model = self.searchResultArray[indexPath.row];
  }
  cell.showChooseBtn = NO;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 55 *ScreenScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.searchStatus) {
    return CGFLOAT_MIN;
  }
  return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.searchStatus) {
    return [UIView new];
  }
  UILabel *label = [UILabel new];
  label.backgroundColor = [UIColor whiteColor];
  label.font = XKSemiboldFont(16);
  label.text = [NSString stringWithFormat:@"   %@",self.indexArray[section]];
  [label showBorderSite:rzBorderSitePlaceBottom];
  label.bottomBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
  if (section == 0) {
    label.xk_openClip = YES;
    label.xk_radius = 8;
    label.xk_clipType = XKCornerClipTypeTopBoth;
    
  }
  return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [UIView new];
}

#pragma mark - 索引相关
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (self.searchStatus) {
    return nil;
  }
  return self.indexArray;
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return index;
}

// 按首字母分组排序数组
- (NSMutableArray *)sortObjectsIndexArray:(NSArray **)idxArray dataArray:(NSArray *)dataArray {
  
  // 初始化UILocalizedIndexedCollation
  UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
  
  //得出collation索引的数量，这里是27个（26个字母和1个#）
  NSInteger sectionTitlesCount = [[collation sectionTitles] count];
  //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
  NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
  
  //初始化27个空数组加入newSectionsArray
  for (NSInteger index = 0; index < sectionTitlesCount; index++) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [newSectionsArray addObject:array];
  }
  
  SEL nameSelecter;
  if (self.isSecret) {
    nameSelecter = @selector(secretRemark);
  } else {
    nameSelecter = @selector(friendRemark);
  }
  
  //将每个名字分到某个section下
  for (XKContactModel *personModel in dataArray) {
    //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
    NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:nameSelecter];
    //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
    NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
    [sectionNames addObject:personModel];
  }
  //对每个section中的数组按照name属性排序
  for (NSInteger index = 0; index < sectionTitlesCount; index++) {
    NSMutableArray *personArrayForSection = newSectionsArray[index];
    NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:nameSelecter];
    newSectionsArray[index] = sortedPersonArrayForSection;
  }
  
  //删除空的数组
  NSArray *sectionTitles = [collation sectionTitles];
  NSMutableArray *indexArray = [NSMutableArray array];
  NSMutableArray *finalArr = [NSMutableArray new];
  for (NSInteger index = 0; index < sectionTitlesCount; index++) {
    if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
      [finalArr addObject:newSectionsArray[index]];
      [indexArray addObject:sectionTitles[index]];
    }
  }
  *idxArray = indexArray.copy;
  return finalArr;
}

#pragma mark - 数据筛选等
- (BOOL)compareStr:(NSString *)str containStr:(NSString *)containStr {
  if ([str containsString:containStr]) {
    return YES;
  } else {
    return [[UTPinYinHelper sharedPinYinHelper] isString:str MatchsKey:containStr IgnorCase:YES];
  }
  return NO;
}

- (NSMutableArray *)dataArray {
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
  }
  return _dataArray;
}

@end
