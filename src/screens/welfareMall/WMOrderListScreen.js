/**
 * 福利商城 订单列表
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  TouchableOpacity,
  BackHandler,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import ScrollableTabView from 'react-native-scrollable-tab-view';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import ScrollableTab from '../../components/ScrollableTab';
import FlatListView from '../../components/FlatListView';
import Process from '../../components/Process';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import WMShareModal from '../../components/WMShareModal';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar';
import ListEmptyCom from '../../components/ListEmptyCom';
import { NavigationComponent } from '../../common/NavigationComponent';
import { showSaleNumText } from '../../config/utils'
import WMOrderListItem from '../../components/WMOrderListItem'
const tabData = ['全部', '待开奖', '已中奖', '已完成'];

const { width, height } = Dimensions.get('window');

class WMOrderListScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        status: props.navigation.getParam('status', 0),
      };
    }

    screenWillFocus = () => {
      BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
      this.getStatusListData();
    }

    screenWillBlur = () => {
      BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }

    // 获取订单列表
    getStatusListData = (page = 1) => {
      const { dispatch, wmOrderList } = this.props;
      const { status } = this.state;
      const params = {
        page,
        limit: 10,
        status,
        lastUpdateAt: new Date().getTime(),
      };
      if (wmOrderList[status].data.length === 0) {
        Loading.show();
      }
      dispatch({
        type: 'welfare/getStatusList',
        payload: {
          params,
          nowStatusIndex: status,
          field: 'wmOrderList',
          requestApiName: 'qureyWMOrderList',
        },
      });
    }

    componentDidMount() {
      Loading.show();
    }

    componentWillUnmount() {
      super.componentWillUnmount();
      Loading.hide();
    }

    onBackButtonPressAndroid = () => {
      const isFocused = this.props.navigation.isFocused();
      let goBackRouteName = this.props.navigation.getParam('goBackRouteName', '')
      if (isFocused) {
        if (goBackRouteName) {
          this.props.navigation.navigate(goBackRouteName);
          return true
        }
        this.props.navigation.navigate('WM');
        return true;
      }
      return false;
    };
    
    handleChangeState = (key = '', value = '', callback = () => { }) => {
      this.setState(
        {
          [key]: value,
        },
        () => {
          callback();
        },
      );
    };

    render() {
      const { navigation, wmOrderList,dispatch } = this.props;
      const { status } = this.state;
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="夺奖派对"
            leftView={(
              <View>
                <TouchableOpacity
                  style={[styles.headerItem, styles.left]}
                  onPress={() => {
                      navigation.navigate('WM');
                  }}
                >
                  <Image source={require('../../images/mall/goback.png')} />
                </TouchableOpacity>
              </View>
            )}
          />
          <ScrollableTabView
            initialPage={this.props.navigation.getParam("status", 0)}
            onChangeTab={({ i }) => {
              if (i === this.state.status) {
                Loading.show();
              }
              this.handleChangeState('status', i, () => { this.getStatusListData(1); });
            }}
            renderTabBar={() => (
              <DefaultTabBar
                underlineStyle={{
                  backgroundColor: '#fff',
                  height: 6,
                  borderRadius: 10,
                  marginBottom: -3,
                  width: 42,
                  marginLeft: ((width / tabData.length) - 42) / 2
                }}
                tabStyle={{
                  backgroundColor: '#4A90FA',
                  height: 44,
                  paddingBottom: -4,
                }}
                activeTextColor="#fff"
                inactiveTextColor="rgba(255,255,255,.5)"
                tabBarTextStyle={{ fontSize: 14 }}
                style={{
                  backgroundColor: '#4A90FA',
                  height: 44,
                  borderBottomWidth: 0,
                  overflow: 'hidden',
                }}
              />
            )}
          >
            {tabData.map((itemTab, i) => (
              <FlatListView
                style={{
                  backgroundColor: CommonStyles.globalBgColor,
                }}
                store={wmOrderList[i].params}
                tabLabel={itemTab}
                // eslint-disable-next-line react/no-array-index-key
                key={itemTab + i}
                data={wmOrderList[i].data}
                // extraData={wmOrderList[i].data}
                // keyExtractor={(item) => item.orderId}
                ItemSeparatorComponent={() => (
                  <View style={{ height: 0 }} />
                )}
                ListEmptyComponent={<ListEmptyCom type="orderListEmpty" />}
                renderItem={({ item, index }) => {
                  return <WMOrderListItem item={item} listItemIndex={index} listLength={wmOrderList[i].data.length} status={status}dispatch={dispatch} />
                }}
                refreshData={() => {
                  this.getStatusListData(1);
                }}
                loadMoreData={() => {
                  this.getStatusListData(wmOrderList[i].params.page + 1);
                }}
              />
            ))}
          </ScrollableTabView>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexBetween: {
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'row',
  },
  flexEnd: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
  },
  flex_1: {
    flex: 1,
  },
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  redColor: {
    color: '#EE6161',
  },
  itemWrap: {
    backgroundColor: '#fff',
    marginLeft: 10,
    marginRight: 10,
    borderLeftColor: 'rgba(215,215,215,0.5)',
    borderLeftWidth: 1,
    borderRightColor: 'rgba(215,215,215,0.5)',
    borderRightWidth: 1,
    borderBottomColor: 'rgba(215,215,215,0.5)',
    borderBottomWidth: 1,
    position: 'relative',
  },
  goodsView: {
    backgroundColor: 'red',
    // margin: 10,
    borderRadius: 8,
    overflow: 'hidden',
    marginTop: 0,
  },
  googdsItemView: {
    paddingHorizontal: 14,
    paddingVertical: 15,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  goodsImg: {
    width: 80,
    height: 80,
    borderWidth: 1,
    borderColor: '#E7E7E7',
    borderRadius: 10,
  },
  goodsItemRight: {
    flex: 1,
    paddingLeft: 11,
  },
  goodsItemTitle: {
    fontSize: 12,
    color: '#222',
    lineHeight: 17,
  },
  processItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#f0f6ff',
    paddingVertical: 8,
    paddingHorizontal: 10,
    borderRadius: 4,
    marginTop: 5,
  },
  expenseLabel: {
    position: 'absolute',
    bottom: 15.5,
    left: 15.5,
    zIndex: 2,
    height: 20,
    width: 79,
    overflow: 'hidden',
    borderBottomLeftRadius: 10,
    borderBottomRightRadius: 10,
  },
  labelStyle: {
    paddingRight: 7,
    color: 'red',
    fontSize: 12,
    color: '#555',
  },
  goodsNper: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 10,
  },
  goodsTicket: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#fff',
    paddingLeft: 10,
    marginTop: 10,
  },
  goodsTicketLeft: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  goodsTicketLeftTitle: {
    fontSize: 12,
    color: '#555',
  },
  goodsTicketLeftNum: {
    paddingLeft: 6,
    color: '#EE6161',
    fontSize: 12,
  },
  goodsTicketRight: {
    fontSize: 12,
    color: '#999',
  },
  openPrizeItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#FFF4E1',
    paddingVertical: 8,
    paddingHorizontal: 10,
    borderRadius: 4,
    marginTop: 2,
  },
  openPrizeItemTitle: {
    fontSize: 12,
    color: '#555',
    paddingRight: 5,
  },
  openPrizeItemTime: {
    fontSize: 12,
    color: '#F5A623',
  },
  buyTimesItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#fff',
    paddingVertical: 8,
    paddingHorizontal: 10,
    borderRadius: 4,
    marginTop: 2,
  },
  buyTimesItemTitle: {
    fontSize: 12,
    color: '#555',
    paddingRight: 5,
  },
  buyTimesItemTime: {
    fontSize: 12,
    color: '#555',
  },
  nomargin: {
    marginTop: 0,
    borderTopLeftRadius: 0,
    borderTopRightRadius: 0,
    backgroundColor: '#F0F6FF',
    paddingTop: 0,
  },
  noBottomRadius: {
    borderBottomLeftRadius: 0,
    borderBottomRightRadius: 0,
  },
  prizeWrap: {
    paddingTop: 10,
  },

  prizeItemText: {
    fontSize: 12,
    color: '#555',
  },
  againBtn: {
    paddingHorizontal: 12,
    paddingVertical: 3,
    borderRadius: 30,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
  },
  againBtnText: {
    fontSize: 12,
    color: CommonStyles.globalHeaderColor,
  },
  labelText: {
    color: '#555',
    fontSize: 12,
  },
  itemWrapStyle: {
    marginTop: 10,
  },
  goodsTitle: {
    fontSize: 12,
    color: '#222',
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
  imgStyle: {
    height: 80,
    width: 80,
    borderRadius: 8,
  },
  goodsTitleStyle: {
    fontSize: 12,
    color: '#222',
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    // position: 'absolute'
  },
  left: {
    width: 50,
  },
});

export default connect(
  state => ({ wmOrderList: state.welfare.wmOrderList }),
  dispatch => ({ dispatch }),
)(WMOrderListScreen);
