/**
 * 现金交易记录
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import { connect } from 'rn-dva';
import ScrollableTabView from 'react-native-scrollable-tab-view';
import PickerOld from 'react-native-picker-xk';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import FlatListView from '../../components/FlatListView';
import * as requestApi from '../../config/requestApi';
import Picker from '../../components/Picker';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';

const { width, height } = Dimensions.get('window');
const date = new Date();
const fullYear = date.getFullYear();
const fullMonth = date.getMonth() + 1;
const fullDay = date.getDate();
const DATETIME_FORMAT = 'YYYY-MM-DD HH:mm:ss';

class FinanceTradeRecordScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    };


    constructor(props) {
      super(props);
      const params = props.navigation.state.params || {};
      this.state = {
        currentTab: 0, // 当前tabs
        billType: params.billType || 'fi', // fi收入，fo支出
        billStatus: params.billStatus || 'normal', // 账单类型 normal  frozen
        currency: params.currency || '', // 记录 类型 xkq晓可券（现金），xkb晓可币，xfq消费券，swq实物券
        startTime: '',
        endTime: '',
        tradeProduct: '', // 此字段暂时不传，可能更改  分类 b2c自营零售价，b2c 自营批发价，jb2c福利零售价，jb2b福利批发价，o2o 商圈价格，gift 礼物，redPackets红包
        recordList: [],
      };
    }

    componentDidMount() {
      Loading.show();
      this.getList(true, false);
    }

    getList = (isFirst = false, isLoadingMore = false, loading = true, refreshing = true) => {
      const {
        currentTab, currentShop, currency, billType,
      } = this.state;
      let params = {};
      params = this.getTitleAndParams().param;
      console.log('params',params)
      params.startTime ? params.startTime = parseInt(moment(params.startTime).valueOf() / 1000) : null;
      params.endTime ? params.endTime = parseInt(moment(params.endTime).valueOf() / 1000) : null;
      this.props.fetchList({
        witchList: `accountRecord${currency}${billType}`,
        isFirst,
        isLoadingMore,
        paramsPrivate: params,
        api: currency == 'xkwl' ? requestApi.merchantWlsBillQPage : requestApi.shopAppUserAccQpage,
        loading,
        refreshing,
      });
    };

    componentWillUnmount() {
      PickerOld.hide();
    }

    _createDateData = () => {
      const date = [];
      for (let i = fullYear - 10; i <= fullYear; i++) {
        const month = [];
        for (let j = 1; j < (i === fullYear ? fullMonth + 1 : 13); j++) {
          const day = [];
          const nowDays = 1; // 默认开始的天数为 1 号
          const endDay = (i === fullYear) && (j === fullMonth) ? fullDay : 31; // 如果时间为当前 年 ，当前 月 ，则结束时间为当前 日 ， 否则结束日为 31 天
          if (j === 2) {
            for (let k = nowDays; k < 29; k++) {
              day.push(`${k }日`);
            }
            if (i % 4 === 0) {
              day.push(`${29 }日`);
            }
          } else if (j in {
            1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1,
          }) {
            for (let k = nowDays; k <= endDay; k++) {
              day.push(`${k}日`);
            }
          } else {
            for (let k = nowDays; k < endDay; k++) {
              day.push(`${k}日`);
            }
          }
          const _month = {};
          _month[`${j}月`] = day;
          month.push(_month);
        }
        const _date = {};
        _date[`${i}年`] = month;
        date.push(_date);
      }
      return date;
    }

    handleSelectData = (type) => {
      const { startTime, endTime } = this.state;
      const defaultDate = type === 'startTime' ? startTime : endTime;
      Picker._showDatePicker((date) => {
        let time = this.hanldeTimeRange(date, type);
        console.log('lll',date,time)
        if (type === 'startTime') {
          if (moment(endTime).isBefore(time)) {
            Toast.show('开始时间不能大于结束时间');
            return;
          }
        }
        if (type === 'endTime') {
          if (moment(time).isBefore(startTime)) {
            Toast.show('结束时间不能小于开始时间');
            return;
          }
        }
        this.changeState(type, time);
      }, this._createDateData, defaultDate ? moment(defaultDate)._d : moment()._d);
    }
    // 处理时间边界
    hanldeTimeRange = (date, type) => {
      let dateArr = date.split('-')
      let selectYear = parseInt(dateArr[0])
      let selectMon = parseInt(dateArr[1])
      let selectDay = parseInt(dateArr[2])
      let now_year = moment().year();
      let now_mon = moment().month() + 1;
      let now_day = moment().get('date');
      if(selectYear === now_year && selectMon === now_mon && selectDay === now_day){
        return type === 'startTime'?`${selectYear}-${selectMon}-${selectDay} 00:00:00`: moment().format(DATETIME_FORMAT)
      }
      else {
        // 开始时间00:00:00  结束时间 23:59:59
        return type === 'startTime'
        ? `${selectYear}-${selectMon}-${selectDay} 00:00:00`
        : `${selectYear}-${selectMon}-${selectDay} 23:59:59`; // 时间戳
      }
    }
    getTitleAndParams = () => {
      const {
        billType, billStatus, startTime, endTime, currentTab,
      } = this.state;
      const currency = this.props.navigation.getParam('currency', '');
      const param = {
        billStatus,
        billType,
        currency,
      };
      startTime ? param.startTime = startTime : null;
      endTime ? param.endTime = endTime : null;
      switch (currency) {
        case 'xkq': return {
          title: '现金交易记录',
          param: {
            ...param,
            billStatus: currentTab == 0 ? 'normal' : '',
          },
        };
        case 'xkb': return {
          title: '晓可币消费记录',
          param,
        };

        case 'xfq': return {
          title: '消费券使用记录',
          param,
        };
        case 'swq': return {
          title: '实物券消费记录',
          param,
        };
        case 'xkwl': return {
          title: billStatus == 'frozen' ? '晓可物流冻结记录' : '晓可物流交易金额记录',
          param,
        };
        default: return {
          title: '未定义',
          param,
        };
      }
    }

    renderItem = ({ item, index }) => {
      const currency = this.props.navigation.getParam('currency', '');
      const borderTop = index === 0 ? styles.borderTop : {};
      const borderBottom = index === this.state.recordList.length - 1 ? styles.borderBottom : {};
      const borderTopRadius = index === 0 ? styles.borderTopRadius : {};
      const borderBottomRadius = index === this.state.recordList.length - 1 ? styles.borderBottomRadius : {};
      const isNotPrice = currency == 'xkb' || currency == 'xfq' || currency == 'swq';
      return (
        <TouchableOpacity
            style={[styles.ListItem, borderBottom, borderTop, styles.borderHor, borderTopRadius, borderBottomRadius]}
            key={index}
            disabled={currency == 'xkq' && this.state.currentTab == 0}
            onPress={() => {
              this.props.navigation.navigate('FinanceTradeRecordDetail', { data: item, id: item.id, currency });
            }}
          >
            <View style={[CommonStyles.flex_end_noCenter]}>
                <Text style={{
                    fontSize: 14, color: '#222', flex: 1, lineHeight: 18,
                  }}
                  >
{item.tradeName}

                  </Text>
                {
                        item.billType === 'fi'
                          ? (
<Text style={{ fontSize: 20, color: '#EE6161', marginLeft: 20 }}>
+
{isNotPrice?'':'¥'}
{item.amount }
</Text>
)
                          : (
<Text style={{ fontSize: 20, color: '#2491FF', marginLeft: 20 }}>
-
{isNotPrice?'':'¥'}
{item.amount }
</Text>
)
                    }
              </View>
            <View style={[CommonStyles.flex_between]}>
                {/* <Text>{moment().format('YYYY-MM-DD HH:mm:ss')}</Text> */}
                <Text style={{ fontSize: 12, color: '#999' }}>{moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                <Text style={{ fontSize: 12, color: '#999' }}>
流水号：
                    {item.id}
                                    </Text>
              </View>
          </TouchableOpacity>
      );
    }

    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    renderFlatlist=(tabLabel = '支出') => {
      const { currency, billType } = this.state;
      const longLists = this.props.longLists;
      const listName = `accountRecord${currency}${billType}`;
      const lists = longLists[listName] && longLists[listName].lists || [];
      return (
        <FlatListView
                style={{
                  backgroundColor: CommonStyles.globalBgColor,
                  marginTop: currency == 'xfq' || currency == 'swq' ? 60 : 0,
                  marginBottom: 10,
                }}
                renderItem={this.renderItem}
                tabLabel={tabLabel}
                ItemSeparatorComponent={() => (
                  <View style={styles.flatListLine} />
                )}
                store={{
                  ...(longLists[listName] || {}),
                  page: longLists[listName] && longLists[listName].listsPage || 1,
                }}
                data={lists}
                numColumns={1}
                refreshData={() => this.getList(false, false)
                }
                loadMoreData={() => this.getList(false, true)
                }
          />
      );
    }

    render() {
      const { navigation } = this.props;
      const {
        currentTab, recordList, startTime, endTime, billStatus,
      } = this.state;
      const params = this.getTitleAndParams();
      const currency = this.props.navigation.getParam('currency', '');
      console.log(startTime)
      return (
        <View style={styles.container}>
            <Header
                    navigation={navigation}
                    goBack
                    title={params.title}
              />
            {
                    currency == 'xfq' || currency == 'swq'
                      ? (
                        <View style={[styles.selectTimeWrap, CommonStyles.flex_between]}>
  <View style={[CommonStyles.flex_start]}>
                              <TouchableOpacity
                                    style={styles.startTimeInput}
                                    onPress={() => {
                                      this.handleSelectData('startTime');
                                    }}
                                >
                                  <Text numberOfLines={1} style={{ textAlign: 'center', fontSize: 12 }}>{(startTime) ? startTime.split(' ')[0] : '开始时间'}</Text>
                                </TouchableOpacity>
                              <Text style={{ fontSize: 12, color: '#777', paddingHorizontal: 10 }}>至</Text>
                              <TouchableOpacity
                                    style={styles.startTimeInput}
                                    onPress={() => {
                                      this.handleSelectData('endTime');
                                    }}
                                >
                                  <Text numberOfLines={1} style={{ fontSize: 12 }}>{(endTime) ? endTime.split(' ')[0] : '结束时间'}</Text>
                                </TouchableOpacity>
                            </View>
  <TouchableOpacity style={styles.searchBtn} onPress={() => { this.getList(false, false); }}><Text style={{ fontSize: 14, color: '#fff' }}>查询</Text></TouchableOpacity>
</View>
                      )
                      : null
                }
            {
                    currency == 'xkwl' && billStatus == 'frozen'
                      ? this.renderFlatlist()
                      : (
<ScrollableTabView
                    initialPage={0}
                    onChangeTab={({ i }) => {
                      const billType = (i === 0) ? 'fi' : 'fo';
                      Loading.show();
                      this.setState({ currentTab: i, billType }, () => { this.getList(false, false); });
                    }}
                    renderTabBar={() => (
                      <ScrollableTabBar
                            tabsContainerStyle={{
                              borderBottomColor: 'rgba(215,215,215,0.3)',
                              borderBottomWidth: 1,
                              width,
                            }}
                            underlineStyle={{
                              backgroundColor: '#4A90FA',
                              height: 8,
                              borderRadius: 10,
                              marginBottom: -6,
                            }}
                            tabStyle={{
                              backgroundColor: '#fff',
                              height: 43,
                            }}
                            activeTextColor="#4A90FA"
                            inactiveTextColor="#555"
                            tabBarTextStyle={{ fontSize: 14 }}
                            style={{
                              backgroundColor: '#fff',
                              height: 44,
                              borderBottomWidth: 0,
                            }}
                        />
                    )}
                    >
                      {this.renderFlatlist('收入')}
                      {this.renderFlatlist('支出')}
                    </ScrollableTabView>
)
                }
          </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  selectTimeWrap: {
    position: 'absolute',
    top: CommonStyles.headerPadding + 89,
    backgroundColor: '#fff',
    width,
    zIndex: 1,
    height: 60,
    padding: 15,
    borderBottomColor: 'rgba(215,215,215,0.3)',
    borderBottomWidth: 1,
  },
  searchBtn: {
    paddingHorizontal: 17,
    paddingVertical: 5,
    backgroundColor: CommonStyles.globalHeaderColor,
    borderRadius: 50,
  },
  startTimeInput: {
    borderRadius: 50,
    borderWidth: 1,
    borderColor: '#f1f1f1',
    // width: 120,
    maxWidth: 120,
    minWidth: 95,
    fontSize: 12,
    color: '#222',
    height: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  ListItem: {
    marginHorizontal: 10,
    padding: 15,
    backgroundColor: '#fff',
  },
  flatListLine: {
    marginHorizontal: 10,
    height: 0.7,
    backgroundColor: '#f1f1f1',
  },
  borderTop: {
    borderTopColor: 'rgba(215,215,215,0.5)',
    borderTopWidth: 1,
  },
  borderBottom: {
    borderBottomColor: 'rgba(215,215,215,0.5)',
    borderBottomWidth: 1,
  },
  borderHor: {
    borderLeftColor: 'rgba(215,215,215,0.5)',
    borderLeftWidth: 0.7,
    borderRightColor: 'rgba(215,215,215,0.5)',
    borderRightWidth: 0.7,
  },
  borderTopRadius: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  borderBottomRadius: {
    borderBottomLeftRadius: 8,
    borderBottomRightRadius: 8,
  },
});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
    longLists: state.shop.longLists || {},
    serviceCatalogList: state.shop.serviceCatalogList || [],
    juniorShops: state.shop.juniorShops || [state.user.userShop || {}],
  }),
  dispatch => ({
    fetchList: (params = {}) => dispatch({ type: 'shop/getList', payload: params }),
    shopSave: (params = {}) => dispatch({ type: 'shop/save', payload: params }),
  }),
)(FinanceTradeRecordScreen);
