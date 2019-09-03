/**
 * 福利商城二级列表页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  ScrollView,
  Text,
  TouchableOpacity,
  Image,
  Button,
  FlatList,
} from 'react-native';
import { connect } from 'rn-dva';
import { showSaleNumText } from '../../config/utils'

import moment from 'moment';
import ScrollableTabView from 'react-native-scrollable-tab-view';
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar';
import * as nativeApi from '../../config/nativeApi';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import Process from '../../components/Process';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import MallHeaderTitle from '../../components/MallHeaderTitle';
import WMPrizeType from '../../components/WMPrizeType';

import math from '../../config/math';

const { width, height } = Dimensions.get('window');
const localCode = global.regionCode;
const tabsData = [
  {
    label: '推荐',
    value: '0',
  },
  {
    label: '夺奖商品',
    value: '',
  },
  {
    label: '平台大奖',
    value: '2',
  },
];
class WMListsScreen extends Component {
    static flatListRef

    // eslint-disable-next-line react/sort-comp
    constructor(props) {
      super(props);
      const id = props.navigation.getParam('index', 0);
      this.state = {
        // categoryId: props.navigation.getParam('code', '0'),
        goodsListsType: false,
        selectIndex: (id === 2 || id === 10) ? 0 : id + 1,
        category: '',
      };
    }

    scrollHeight = 0;

    componentDidMount() {
      this.setActiveTabsIndex();
      Loading.show();
    }

    // 设置当前tabs索引
    setActiveTabsIndex = () => {
      const { navigation } = this.props;
      const id = navigation.getParam('index', 0);
      if (id === 0) {
        this.getWmPrizeGoodsList(1, '', true);
      } else if (id === 1) {
        this.getPaltDrawData();
      } else {
        this.getGoodsRecommendGoodsList();
      }
      this.handleChangeState('selectIndex', (id === 2 || id === 10) ? 0 : id + 1); // 当在首页点击更多的时候
    }

    // 获取推荐商品
    getGoodsRecommendGoodsList = (page = 1, address = localCode) => {
      const { dispatch } = this.props;
      const params = {
        page,
        limit: 10,
        jCondition: { districtCode: address },
      };
      dispatch({ type: 'welfare/getGoodsRecommendGoodsList', payload: { params } });
    }

    // 获取夺奖商品
    getWmPrizeGoodsList = (page = 1, category = this.state.category) => {
      const { dispatch } = this.props;
      const params = {
        page,
        limit: 10,
        jCondition: {
          categoryCode: category,
          keyWord: '',
        },
      };
      dispatch({ type: 'welfare/getWmPrizeGoodsList', payload: { params } });
    }

    // 获取平台大奖
    getPaltDrawData = (page = 1) => {
      const params = {
        jCondition: {
          usage: 'expense',
        },
        limit: 10,
        page,
      };
      const { dispatch } = this.props;
      dispatch({ type: 'welfare/getPaltDrawDataList', payload: { params } });
    }

    refreshOrLoadMore = (page = 1) => {
      const { selectIndex } = this.state;
      if (selectIndex === 0) {
        this.getGoodsRecommendGoodsList(page);
      } else if (selectIndex === 1) {
        this.getWmPrizeGoodsList(page, '', true);
      } else {
        this.getPaltDrawData(page);
      }
    }

    // 点击tabs
    handleClickItem = (index) => {
      const category = tabsData[index].value;
      if (index === 0) { // 推荐
        this.getGoodsRecommendGoodsList();
      } else if (index === 1) { // 福利商品
        this.getWmPrizeGoodsList(1, category, true);
      } else { // 平台大奖
        this.getPaltDrawData();
      }
      this.setState({ category });
    }

    handleChangeState = (key, value, callback = () => { }) => {
      this.setState({
        [key]: value,
      }, () => {
        callback();
      });
    }

    gotoDetail = (item) => {
      const { navigation } = this.props;
      if (this.state.selectIndex === 2) {
        console.log(item);
        item.termNumber = item.sequenceId
        navigation.navigate('WMXFGoodsDetail', { goodsData: item, goodsId: item.goodsId });
        return;
      }
      navigation.navigate('WMGoodsDetail', {
        goodsId: item.goodsId,
        sequenceId: item.sequenceId,
      });
    }
    getLabelTextByGoodsType = (item) => {
      console.log('item',item.virtualType)
      switch (item.virtualType) {
        case 'aa_card': return '订单半额消费券返还' // AA卡
        case 'free_card': return '订单全额消费券返还' // 免单卡
        // case 'substance': return '中奖后凭券0元兑换'// 实物
        default: return '中奖后凭券0元兑换'// 实物
      }
    }
    renderItem = ({ item, index, colIndex }) => {
      const {
        navigation, wmRecommendList, wmPrizeGoodsList, paltDrawDataList,
      } = this.props;
      const { goodsListsType, selectIndex } = this.state;
      const goodLists = selectIndex === 0 ? wmRecommendList : selectIndex === 1 ? wmPrizeGoodsList : paltDrawDataList;
      const time = moment(item.expectDrawTime * 1000).format('MM-DD HH:mm');
      const valueStyle = item.drawType === 'bytime' && selectIndex === 2 ? { color: '#F5A623' } : null;
      let timeBg = item.drawType === 'bytime' && selectIndex === 2 ? { backgroundColor: '#FFF4E1' } : null;
      const value = math.multiply(math.divide(item.currentCustomerNum , item.eachSequenceNumber), 100) ;
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = item.eachSequenceNumber > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.currentCustomerNum,fixedNumber)}/${showSaleNumText(item.eachSequenceNumber,fixedNumber)}`
      let topRadius;
      let bottomRadius;
      let bottomBorder;
      if (index === 0) {
        topRadius = styles.topRadius;
        topBorder = styles.topBorder;
      }
      if (index === goodLists.data.length - 1) {
        bottomRadius = styles.bottomRadius;
      } else {
        bottomBorder = styles.bottomBorder;
      }
      if (!goodsListsType) {
        return (
          <TouchableOpacity
            key={`colIndex_${colIndex}${index}`}
            activeOpacity={0.65}
            style={[styles.goodsListItemWrap, styles.flexStart_noCenter, topRadius, bottomRadius, bottomBorder]}
            onPress={() => { this.gotoDetail(item); }}
          >
            <View style={{
              position: 'absolute', top: 15, left: 15, zIndex: 1,
            }}
            >
              { // 获取开奖类型标签
                this.getPrizeLable(item.drawType)
              }
            </View>
            <WMGoodsWrap
              itemWrapStyle={timeBg}
              imgUrl={item.mainUrl}
              imgStyle={styles.imgStyle}
              title={() => ( // 单独处理样式
                selectIndex !== 2 // 夺奖商品显示不同样式
                  ? (
                    <Text style={styles.goodsViewText} numberOfLines={2}>
                      <Text style={[styles.red_color]}>{`[${math.divide(item.perPrice, 100)}消费券夺${math.divide(item.price, 100)}元]`}</Text>
                      {item.goodsName}
                    </Text>
                  )
                  : item.goodsName
              )}
              showProcess
              type={item.drawType}
              processValue={processValue}
              label="参与人次："
              timeLabel="开奖时间："
              timeValue={time}
              showText={showText}
              valueStyle={valueStyle}
              labelStyle={styles.labelStyle}
              goodsTitleStyle={styles.goodsTitleStyle}
              renderInsertContent={() => {
                if (selectIndex === 2) {
                  return (
                    <React.Fragment>
                      {
                        item.virtualType !== 'money_car' && item.prizeType === 'virtual' // 只有平台大奖，虚拟物品AA卡免单卡 才显示标题下方的说明
                        ? (
                          <View style={{ height: 14,width: 110,paddingHorizontal: 5,marginTop: 5,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
                            <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>{this.getLabelTextByGoodsType(item)}</Text>
                          </View>
                        )
                        : null
                      }
                      {
                        item.prizeType === 'virtual' // 虚拟物品才显示上限
                        ? (
                          <Text style={[styles.labelStyle, { marginTop: 5, marginBottom: 5 }]}>
                            单笔上限：
                            <Text style={[styles.red_color, { fontSize: 14 }]}>{`￥${math.divide(item.price, 100)}`}
                              <Text style={[styles.red_color, { fontSize: 12 }]}>{`${item.virtualType === 'aa_card' ? ' x 50%' : ''}`}</Text>
                            </Text>
                          </Text>
                        )
                        : null
                      }
                      <View style={[CommonStyles.flex_between, (item.prizeType !== 'virtual') ? { marginTop: 5 } : null]}>
                        <Text style={styles.labelStyle}>{`开奖期数：${item.sequenceNo}`}</Text>
                      </View>
                    </React.Fragment>
                  );
                } else {
                  return null
                  // return (
                  //   <View style={{ height: 14,width: 100,paddingHorizontal: 5,marginTop: 5,marginBottom: 2,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
                  //     <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>{this.getLabelTextByGoodsType(item)}</Text>
                  //   </View>
                  // )
                }
              }}
            >
            {/* 只有平台大奖有参与方式, 如果没有显示 备用奖品 */}
            {
              this.state.selectIndex === 2
                ? (
                  <View style={[styles.joinWay,styles.joinWrap, timeBg]} numberOfLines={1}>
                    <Text style={{fontSize: 10,color: '#777'}}>参与方式：{item.joinWay ? item.joinWay : '备用奖品'}</Text>
                  </View>
                )
                : null
            }
          </WMGoodsWrap>
          </TouchableOpacity>
        );
      }
      // 网格布局
      let wrapPaddingStyle = colIndex === 0 ? styles.firstItemWrapPadding : styles.secondItemWrapPadding;
      
      return (
        <TouchableOpacity
          activeOpacity={0.65}
          style={[styles.goodsListItemWrap_Col, wrapPaddingStyle]}
          key={`colIndex_${colIndex}${index}`}
          onPress={() => { this.gotoDetail(item); }}
        >
          <View style={styles.goodsView}>
            <View style={styles.prizeLabel}>
              { // 获取开奖类型标签
                this.getPrizeLable(item.drawType)
              }
            </View>
            <Image style={styles.goodsViewImage} source={{ uri: item.mainUrl }} />
            {
              selectIndex !== 2
                ? (
                  <React.Fragment>
                    <Text style={styles.goodsViewText} numberOfLines={2}>
                      <Text style={[styles.red_color]}>{`[${math.divide(item.perPrice, 100)}消费券夺${math.divide(item.price, 100)}元]`}</Text>
                      {item.goodsName}
                    </Text>
                  </React.Fragment>
                )
                : (
                  <React.Fragment>
                    <Text numberOfLines={2} style={[styles.goodsViewText, { color: '#222' }]}>{item.goodsName}</Text>
                    {
                      item.virtualType !== 'money_car' && item.prizeType === 'virtual' // 只有平台大奖，虚拟物品AA卡免单卡 才显示标题下方的说明
                      ? (
                        <View style={{ height: 14,paddingHorizontal: 5,width: 110,marginTop: 5,marginBottom: 2,marginLeft: 5,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
                          <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>{this.getLabelTextByGoodsType(item)}</Text>
                        </View>
                      )
                      : null
                    }
                  </React.Fragment>
                )
            }
            <WMPrizeType
              itemWrapStyle={{ ...timeBg, ...{ borderRadius: 0 }}}
              type={item.drawType}
              timeLabel="开奖时间:"
              timeValue={time}
              labelStyle={styles.labelStyle}
              label="参与人次:"
              showText={showText}
              valueStyle={valueStyle}
              nowValue={processValue}
            />
            {/* 只有平台大奖有参与方式 */}
            {
              this.state.selectIndex === 2
                ? (
                  <View style={[styles.joinWay, timeBg]} numberOfLines={1}>
                    <Text style={{fontSize: 10,color: '#777'}}>参与方式：{item.joinWay ? item.joinWay : '备用奖品'}</Text>
                  </View>
                )
                : null
            }

          </View>
        </TouchableOpacity>
      );
    }

    getPrizeLable = (drawType) => {
      switch (drawType) {
        case 'bymember': return (
          <Image source={require('../../images/wm/processPrizeicon.png')} />
        );
        case 'bytime': return (
          <Image source={require('../../images/wm/timePrizeicon.png')} />
        );
        case 'bytime_or_bymember': return (
          <Image source={require('../../images/wm/byTimeOrProcess.png')} />
        );
        case 'bytime_and_bymember': return (
          <Image source={require('../../images/wm/byTimeAndProcess.png')} />
        );

        default: return null;
      }
    }
    renderTopCenter = () => {
      const {
        navigation,
      } = this.props;
      const {
        goodsListsType,
      } = this.state;
      return (
        <View style={[styles.headerItem, styles.headerCenterView]}>
          <TouchableOpacity
            activeOpacity={0.8}
            style={styles.headerCenterItem1}
            onPress={() => {
              navigation.navigate('WMSearch');
            }}
          >
            <View style={styles.headerCenterItem1_search}>
              <Image source={require('../../images/mall/search.png')} />
            </View>
            <View style={styles.headerCenterItem1_textView}>
              <Text style={styles.headerCenterItem1_text} numberOfLines={1}>搜索你想要的商品</Text>
            </View>
          </TouchableOpacity>
          <View style={{ marginLeft: 15 }}>
            <MallHeaderTitle
              data={[
                {
                  icon: require('../../images/mall/messages.png'),
                  onPress: () => { nativeApi.createXKCustomerSerChat(); },
                },
                {
                  icon: require('../../images/mall/shoppingcart.png'),
                  onPress: () => {
                    navigation.navigate('IndianaShopCart');
                  },
                },
                {
                  icon: require('../../images/mall/orders.png'),
                  onPress: () => {
                    navigation.navigate('WMOrderList', { goBackRouteName: 'WMLists' });
                  },
                },
                {
                  icon: require('../../images/mall/fg_ling.png'),
                  onPress: () => { },
                },
                {
                  icon: goodsListsType ? require('../../images/mall/list2.png') : require('../../images/mall/list1.png'),
                  onPress: () => {
                    this.handleChangeState('goodsListsType', !goodsListsType);
                    setTimeout(() => {
                      // eslint-disable-next-line no-unused-expressions
                      this.flatListRef && this.flatListRef.scrollToOffset({ offset: this.scrollHeight, animated: false });
                    }, 100);
                  },
                }]}
            />
          </View>
        </View>
      )
    }
    render() {
      const {
        navigation, wmRecommendList, wmPrizeGoodsList, paltDrawDataList,
      } = this.props;
      const {
        selectIndex,
        goodsListsType,
      } = this.state;
      const goodLists = selectIndex === 0 ? wmRecommendList : selectIndex === 1 ? wmPrizeGoodsList : paltDrawDataList;
      const flistListStore = goodLists.params;
      let selectId = navigation.getParam('index', 0);
      return (
        <View style={styles.container}>
          <Header navigation={navigation} goBack centerView={this.renderTopCenter()} rightView={<View style={{ width: 0 }} />}/>
          <ScrollableTabView
            onChangeTab={({ i }) => { this.setState({ selectIndex: i }, () => { this.handleClickItem(this.state.selectIndex); }) }}
            initialPage={(selectId === 2 || selectId === 10) ? 0 : selectId + 1}
            tabBarUnderlineStyle={styles.tabBarUnderlineStyle}
            renderTabBar={() => (
              <DefaultTabBar
                tabStyle={{
                  backgroundColor: '#fff',
                  height: 44,
                  paddingBottom: -4,
                }}
                activeTextColor="#4A90FA"
                inactiveTextColor="#555"
                tabBarTextStyle={{ fontSize: 14 }}
                style={{
                  backgroundColor: '#fff',
                  height: 44,
                  borderBottomWidth: 0,
                  overflow: 'hidden',
                }}
              />
            )}
          >
            {
              tabsData.map((item, index) => (
                <FlatListView
                  // eslint-disable-next-line react/no-array-index-key
                  openWaterFall
                  key={index}
                  flatRef={(e) => { e && (this.flatListRef = e); }}
                  tabLabel={item.label}
                  style={styles.flatList}
                  store={flistListStore}
                  data={goodLists.data}
                  ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                  renderItem={this.renderItem}
                  numColumns={!goodsListsType ? 1 : 2}
                  refreshData={() => {
                    this.refreshOrLoadMore(1);
                  }}
                  loadMoreData={() => {
                    console.log('flistListStore.page + 1', flistListStore.page + 1)
                    this.refreshOrLoadMore(flistListStore.page + 1);
                  }}
                />
              ))
            }
          </ScrollableTabView>
        </View>
      );
    }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  borderNone: {
    borderRadius: 0,
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexStart_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flex_1: {
    flex: 1,
  },
  joinWay: {
    backgroundColor: '#f0f6ff',
    paddingBottom: 10,
    paddingHorizontal: 10,
  },
  joinWrap: {
    borderRadius:4,
    position: 'relative',
    top: -3,
    paddingTop: 3,
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  headerCenterView: {
    flex: 1,
  },
  headerCenterItem1: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    flex: 1,
    height: 30,
    borderRadius: 15,
    backgroundColor: 'rgba(255,255,255,0.3)',
  },
  headerCenterItem1_search: {
    width: 32,
    paddingHorizontal: 8,
  },
  headerCenterItem1_textView: {
    justifyContent: 'center',
    alignItems: 'flex-start',
    flex: 1,
    height: 20,
    marginRight: 8,
  },
  headerCenterItem1_text: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.8)',
  },
  headerCenterItem2: {
    width: 114,
  },
  flatListLine: {
    height: 0,
    backgroundColor: '#F1F1F1',
  },
  headerCenterItem2_icon: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    height: '100%',
  },
  headerRightView: {
    width: 50,
  },
  headerRight_line: {
    width: 1,
    height: 23,
    backgroundColor: 'rgba(255,255,255,0.23)',
  },
  headerRight_icon: {
    flex: 1,
  },
  categoryTitle: {
    width,
    flexDirection: 'row',
    flexWrap: 'nowrap',
    backgroundColor: CommonStyles.globalBgColor,
  },
  categoryTitleItemWrap: {
    // paddingHorizontal: 5,
    // width: width / 4.2,
    backgroundColor: '#4A90FA',
    justifyContent: 'center',
    alignItems: 'center',
  },
  categoryTitleItem: {
    height: 38,
    overflow: 'hidden',
  },
  categoryTitleITemTop: {
    position: 'relative',
    paddingTop: 10,
    textAlign: 'center',
    color: '#fff',
    fontSize: 14,
  },
  categoryTitleITemBottom: {
    height: 4,
    borderRadius: 2,
    backgroundColor: '#fff',
    position: 'absolute',
    bottom: -4,
    left: 0,
  },
  titleActive: {
    // color: CommonStyles.globalHeaderColor,
    color: '#fff',
  },
  titleBottomActive: {
    bottom: -2,
  },
  itemBoxRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    margin: 15,
    marginBottom: 0,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  itemBoxCol: {
    backgroundColor: '#fff',
    width: '100%',
  },
  itemViewRow: {
    flexDirection: 'row',
    // justifyContent: 'center',
    // padding: 10,
  },
  itemViewRowTop: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  itemViewRowBottom: {
    borderBottomLeftRadius: 8,
    borderBottomRightRadius: 8,
  },
  itemViewColumn: {
    width: '100%',
    backgroundColor: '#f6f6f6',
    // ...CommonStyles.shadowStyle,
  },
  itemLeft: {
    paddingLeft: 10,
    paddingRight: 4,
  },
  itemRight: {
    paddingLeft: 4,
    paddingRight: 10,
  },
  itemImgView: {
    backgroundColor: '#F6F6F6',
    maxHeight: 168,
    overflow: 'hidden',
  },
  itemImgView1: {
    width: 100,
    height: 100,
    borderRadius: 10,
    backgroundColor: '#fff',
  },
  itemImgView2: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  itemImgView_img: {
    width: '100%',
    height: '100%',
  },
  itemImgView_img_Col: {
    width: '100%',
    height: '100%',
  },
  itemRightView: {
    height: '100%',
    flex: 1,
    backgroundColor: '#fff',
  },
  itemRightView1: {
    paddingLeft: 11,
    paddingBottom: 15,
  },
  itemRightView2: {
    borderWidth: 1,
    borderColor: '#eee',
  },
  itemRight_title_text: {
    fontSize: 14,
    color: '#222',
    paddingTop: 3,
  },
  flatList: {
    backgroundColor: '#EEEEEE',
  },
  itemRight_xf_text: {
    fontSize: 12,
    color: '#222',
    paddingTop: 3,
  },
  itemRight_price: {
    alignItems: 'flex-start',
    width: '100%',
  },
  itemRight_processBox: {
    marginTop: 5,
    paddingVertical: 10,
    backgroundColor: '#F0F6FF',
    borderRadius: 4,
    paddingRight: 10,
    // height: 200,
    // paddingLeft: 10,
  },
  itemRight_processBox_col: {
    backgroundColor: '#F0F6FF',
    width: '100%',
    height: 50,
    paddingLeft: 6,
    marginTop: 3,
    paddingRight: 10,
  },
  itemRight_processBox_top: {
    justifyContent: 'flex-start',
    flexDirection: 'row',
  },
  itemRight_processBox_top_col: {
    paddingTop: 6,
    justifyContent: 'flex-start',
    flexDirection: 'row',
  },
  itemRight_processBox_bottom: {
    justifyContent: 'flex-start',
    flexDirection: 'row',
    paddingTop: 3,
  },
  itemRight_processBox_bottom_time: {
    color: CommonStyles.globalHeaderColor,
    // paddingLeft: 10,
    fontSize: 12,
  },
  processWrap: {
    justifyContent: 'center',
    alignItems: 'center',
    // paddingLeft: 10,
  },
  littleTitle: {
    fontSize: 12,
    color: '#777',
    width: 37,
  },
  topBorderRadisu: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  learnMore: {
    backgroundColor: '#f6f6f6',
    height: 44,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  learnMoreText: {
    fontSize: 14,
    color: '#777',
    textAlign: 'center',
  },
  goodsListItemWrap: {
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
    overflow: 'hidden',
    marginHorizontal: 10,
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 7,
  },
  goodsTitleStyle: {
    fontSize: 14,
    color: '#222',
    lineHeight: 18,
  },
  topRadius: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  bottomRadius: {
    borderBottomRightRadius: 8,
    borderBottomLeftRadius: 8,
  },
  topBorder: {
    borderTopColor: 'rgba(215,215,215,0.5)',
    borderTopWidth: 1,
  },
  bottomBorder: {
    borderBottomColor: 'rgba(215,215,215,0.5)',
    borderBottomWidth: 1,
  },
  goodsListItemWrap_Col: {
    borderRadius: 8,
    marginBottom: 10
  },
  goodsView: {
    borderColor: '#f1f1f1',
    borderWidth: 1,
    borderRadius: 9,
    backgroundColor: '#fff',
    position: 'relative',
    overflow: 'hidden'
  },
  goodsViewImage: {
    width: '100%',
    height: 168,
    borderTopRightRadius: 8,
    borderTopLeftRadius: 8,
  },
  goodsViewText: {
    fontSize: 14,
    lineHeight: 18,
    paddingLeft: 6,
    paddingTop: 8,
    color: '#101010',
  },
  goodsTicketsText_col: {
    paddingLeft: 6,
    fontSize: 12,
    color: '#777',
  },
  processItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#f0f6ff',
    paddingVertical: 8,
    paddingHorizontal: 7,
    borderRadius: 4,
    marginTop: 5,
  },
  openPrizeItemTitle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 5,
  },
  openPrizeItemTime: {
    fontSize: 12,
    color: '#F5A623',
  },
  openPrizeItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#FFF4E1',
    paddingVertical: 8,
    paddingHorizontal: 7,
    borderRadius: 4,
    marginTop: 2,
  },
  imgStyle: {
    borderRadius: 8,
    height: 100,
    width: 100,
  },
  red_color: {
    color: '#EE6161',
  },
  prizeLabel: {
    position: 'absolute',
    left: 0,
    top: 0,
    zIndex: 2,
  },
  tabBarUnderlineStyle: {
    width: 28,
    height: 3,
    marginLeft: ((width / 3) - 28) / 2,
    backgroundColor: CommonStyles.globalHeaderColor,
  },
  firstItemWrapPadding: {
    marginLeft: 10,
    marginRight: 5
  },
  secondItemWrapPadding: {
    marginRight: 10,
    marginLeft: 5
  },
});

export default connect(
  state => ({
    wmRecommendList: state.welfare.wmRecommendList, // 推荐商品
    wmPrizeGoodsList: state.welfare.wmPrizeGoodsList, // 夺奖商品
    paltDrawDataList: state.welfare.paltDrawDataList, // 平台大奖
  }),
  dispatch => ({ dispatch }),
)(WMListsScreen);
