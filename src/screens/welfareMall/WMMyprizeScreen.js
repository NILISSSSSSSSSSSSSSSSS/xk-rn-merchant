/**
 * 我的大奖
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import { connect } from 'rn-dva';
import ScrollableTabView from 'react-native-scrollable-tab-view';
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import FlatListView from '../../components/FlatListView';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import * as requestApi from '../../config/requestApi';
import ShareTemplate from '../../components/ShareTemplate';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import RadiusBotton from '../../components/RadiusBotton/index';
import { NavigationComponent } from '../../common/NavigationComponent';
import WMPrizeType from '../../components/WMPrizeType';
import math from '../../config/math';
import { showSaleNumText } from '../../config/utils'

// import { debounce } from '../../config/utils';
const { width, height } = Dimensions.get('window');
const tabsData = [
  {
    label: '全部',
    value: '',
  },
  {
    label: '待开奖',
    value: 'NO_LOTTERY',
  },
  {
    label: '已中奖',
    value: 'NOT_GET',
  },
  {
    label: '已完成',
    value: 'ALREADY_GET',
  },
  {
    label: '未中奖',
    value: 'LOSING_LOTTERY',
  },
];
class WMMyprizeScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        selectIndex: 0,
      };
    }
    screenWillFocus () {
      this.handleGetList();
      Loading.show();
    }
    componentDidMount() {
      
    }

    componentWillUnmount() {
      Loading.hide();
    }

    handleGetList = (page = 1) => {
      const { dispatch, prizeOrderList } = this.props;
      const { selectIndex } = this.state;
      const goodsState = tabsData[selectIndex].value;
      const params = {
        page,
        limit: 10,
        goodsState,
        awardUsage: 'expense',
      };
      if (prizeOrderList[selectIndex].data.length === 0) {
        Loading.show();
      }
      dispatch({ type: 'welfare/getPrizeOrderList', payload: { params, nowStatusIndex: selectIndex } });
    }

    handleChangeState = (key, val, callback = () => { }) => {
      this.setState({
        [key]: val,
      }, () => {
        callback();
      });
    };

    // 全部订单跳转详情
    handleNavigationOrderDetail = (item) => {
      const { dispatch } = this.props
      dispatch({ type: 'welfare/listNavigation', payload: { params: { ...item, routerIn: 'WMMyprize' } } })
    }

    renderItem = ({ item, index }) => {
      const { selectIndex } = this.state;
      const { navigation, prizeOrderList } = this.props;
      const time = moment(item.expectDrawTime * 1000).format('MM-DD HH:mm');
      const value = math.divide(item.joinCount , item.maxStake) * 100;
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = item.maxStake > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.joinCount,fixedNumber)}/${showSaleNumText(item.maxStake,fixedNumber)}`
      let marginBottom = index == prizeOrderList[selectIndex].data.length - 1 ? { marginBottom: 10 } : null;
      return (
        <TouchableOpacity
        activeOpacity={0.65}
        style={[styles.orderItemWrap, marginBottom]}
        onPress={() => {
          this.handleNavigationOrderDetail(item);
        }}
        >
          <View style={[CommonStyles.flex_between, styles.orderItemTitleWrap]}>
            <Text style={styles.orderItemTitle}>奖品状态</Text>
            { this.getOrderItemStatus(item) }
          </View>
          <View style={[CommonStyles.flex_1, CommonStyles.flex_start_noCenter]}>
            <View style={styles.goodsImgWrapStyle}>
              <Image style={styles.goodsImgStyle} source={{ uri: item.url }} />
            </View>
            <View style={[CommonStyles.flex_1, styles.goodsInfoWrap]}>
              <Text style={styles.goodsInfoTitle} numberOfLines={2}>{item.name}</Text>
              <WMPrizeType
              // type="bytime_and_bymember"
              type={item.drawType}
              timeLabel="开奖时间:"
              timeValue={time}
              labelStyle={styles.labelStyle}
              label="开奖进度:"
              showText={showText}
              nowValue={processValue}
              />
              {/* 如果是实物，显示规格，否则显示金额 */}
              <Text style={[styles.goodsInfoLable, { marginTop: 10,lineHeight: 15 }]}>{this.getShowLabelText(item)}</Text>
              <View style={[CommonStyles.flex_between, { marginTop: 5 }]}>
                <Text style={[styles.goodsInfoLable]} numberOfLines={1}>{`开奖期数：${item.currentNper}`}</Text>
                <Text style={[styles.goodsInfoLable]}>
                  参与人次：
                  <Text style={[styles.goodsInfoLable, styles.redColor]}>{item.orderNumber}</Text>
                </Text>
              </View>
            </View>
          </View>
        </TouchableOpacity>
      );
    }
    // 如果是实物 显示规格，如果是AA卡或者免单卡显示 返券订单金额上限
    getShowLabelText = (item) => {
      if (item.goodsType === 'substance') {
        return item.specification ? `规格：${item.specification || '无'}` : '';
      }
      if(item.goodsType === 'virtual'){
        switch (item.virtualType){
          case 'aa_card' || 'free_card': return `返券订单金额上限${math.divide(item.price || 0, 100)}` // AA 卡, 免单卡
          case 'money_car': return `金额：${math.divide(item.price || 0, 100)}` // 现金红包
          default: return ''
        }
      }
    }
    getOrderItemStatus = (item) => {
      switch (item.state) {
        // 待开奖状态
        case 'NO_LOTTERY': return this.getOrderItemStatusLabel('待开奖', '#fef5e9', '#F5A623');

        // 已中奖 待分享 状态
        case 'NOT_SHARE': return this.getOrderItemStatusLabel('待分享', '#fef5e9', '#F5A623');
        // 已中奖 待领取 状态
        case 'WAIT_FOR_RECEVING': return this.getOrderItemStatusLabel('待领取', '#f1f1f1', '#777777');
        // 已完成 待发货 状态
        case 'NOT_DELIVERY': return this.getOrderItemStatusLabel('待发货');
        // 已完成 待收货 状态
        case 'DELIVERY': return this.getOrderItemStatusLabel('待收货');
        // 已完成 待晒单 状态
        case 'WINNING_LOTTERY': return this.getOrderItemStatusLabel('待晒单');
        // 已完成 待晒单 状态
        case 'RECEVING': return this.getOrderItemStatusLabel('待晒单');
        // 已完成 晒单审核中 状态
        case 'SHARE_AUDIT_ING': return this.getOrderItemStatusLabel('晒单审核中');
        // 已完成 晒单未通过 状态
        case 'SHARE_AUDIT_FAIL': return this.getOrderItemStatusLabel('晒单失败');
        
        // 已完成状态
        case 'SHARE_LOTTERY': return this.getOrderItemStatusLabel('已完成');

        // 未中奖
        case 'LOSING_LOTTERY': return this.getOrderItemStatusLabel('未中奖', '#fdefef', '#EE6161'); 

        default: return this.getOrderItemStatusLabel('已完成');
      }
    }

    getOrderItemStatusLabel = (status = '已完成',bgColor = '#ecf3fe', textColor = CommonStyles.globalHeaderColor) => (
      <View style={[ CommonStyles.flex_center,styles.statusWrap, { backgroundColor: bgColor } ]}>
        <Text style={[{ fontSize: 12, color: textColor }]}>{status}</Text>
      </View>
    )
    
    render() {
      const { navigation, prizeOrderList, prizeOrderListNum } = this.props;
      const { shareModal, showParams, selectIndex } = this.state;
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title={`我的夺奖(${prizeOrderListNum.activity || 0})`}
          />
          <ScrollableTabView
            onChangeTab={({ i }) => {
              if(i === this.state.selectIndex){
                Loading.show();
              }
              this.setState({ selectIndex: i }, () => { this.handleGetList(1); });
            }}
            initialPage={0}
            tabBarUnderlineStyle={{ backgroundColor: 'rgba(10,10,10,0)' }}
            renderTabBar={() => (
              <DefaultTabBar
                underlineStyle={{
                  backgroundColor: '#fff',
                  height: 8,
                  borderRadius: 10,
                  marginBottom: -5,
                  width: '10%',
                  marginLeft: '6%',
                }}
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
                  style={{ backgroundColor: CommonStyles.globalBgColor }}
                  // eslint-disable-next-line react/no-array-index-key
                  key={index}
                  tabLabel={item.label}
                  data={prizeOrderList[selectIndex].data}
                  renderItem={this.renderItem}
                  store={prizeOrderList[selectIndex].params}
                  refreshData={this.handleGetList}
                  loadMoreData={() => {
                    this.handleGetList(prizeOrderList[selectIndex].params.page + 1);
                  }}
                  ListFooterComponent={() => null}
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
  orderItemWrap: {
    backgroundColor: '#fff',
    marginHorizontal: 10,
    borderRadius: 8,
  },
  orderItemTitleWrap: {
    paddingHorizontal: 15,
    paddingVertical: 13,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  orderItemTitle: {
    color: '#555',
    fontSize: 14,
  },
  goodsImgWrapStyle: {
    paddingHorizontal: 15,
    paddingTop: 15,
  },
  goodsImgStyle: {
    width: 80,
    height: 80,
    borderWidth: 1,
    borderColor: '#f1f1f1',
    borderRadius: 4,
  },
  goodsInfoWrap: {
    paddingRight: 15,
    paddingVertical: 15,
  },
  goodsInfoTitle: {
    fontSize: 14,
    color: '#222',
    lineHeight: 17,
  },
  labelStyle: {
    paddingRight: 7,
    fontSize: 12,
    color: '#555',
  },
  goodsInfoLable: {
    paddingLeft: 10,
    color: '#555',
    fontSize: 12,
  },


  topBtnWrap: {
    paddingVertical: 10,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  topBtn: {
    height: 30,
    width: 87,
    textAlign: 'center',
    lineHeight: 30,
    color: CommonStyles.globalHeaderColor,
  },
  topBtnActive: {
    backgroundColor: CommonStyles.globalHeaderColor,
    color: '#fff',
  },
  goodsWrap: {
    borderWidth: 0.7,
    borderColor: 'rgba(215,215,215,0.5)',
    marginHorizontal: 10,
    borderRadius: 8,
    backgroundColor: '#fff',
  },
  imgStyle: {
    // height: 78,
    // width: 78,
    height: '100%',
    width: '100%',
  },
  goodsTitleStyle: {
    fontSize: 14,
    color: '#222',
    lineHeight: 18,
  },
  goodsShowMore: {
    borderWidth: 1,
    borderColor: '#4A90FA',
    paddingHorizontal: 12,
    paddingVertical: 2,
    backgroundColor: '#fff',
    borderRadius: 20,
    marginBottom: 15,
    marginRight: 15,
  },
  goodsShowMoreBtn: {
    color: '#4A90FA',
    fontSize: 12,
  },
  prizeItemText: {
    fontSize: 12,
    color: '#555',
  },
  redColor: {
    color: '#EE6161',
  },
  statusWrap: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderTopLeftRadius: 6,
    borderBottomRightRadius: 6,
  },
});

export default connect(
  state => ({
    prizeOrderList: state.welfare.prizeOrderList, // 我的夺奖订单列表数据
    prizeOrderListNum: state.welfare.prizeOrderListNum, // 我的夺奖数量
  }),
  dispatch => ({ dispatch }),
)(WMMyprizeScreen);
