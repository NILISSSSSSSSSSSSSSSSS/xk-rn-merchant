/**
 * 店铺订单列表
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  ScrollView,
  TouchableOpacity,
  Platform,
  BackHandler,
  Modal,
} from 'react-native';
import { connect } from 'rn-dva';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import FlatListView from '../../../components/FlatListView';
import NavigatorService from '../../../common/NavigatorService';
import { NavigationComponent } from '../../../common/NavigationComponent';
import { TABS_TITLE_ONLINE, TABS_TITLE_OFFLINE } from '../../../const/order';
import OrderCard from './components/OrderCard';
import IconWithRedPoint from '../../../components/IconWithRedPoint';

const search = require('../../../images/mall/search.png');
const upchooseicon = require('../../../images/order/upchooseicon.png');
const downchoose = require('../../../images/order/downchoose.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

class OrderListScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
      gesturesEnabled: false, // 禁用ios左滑返回
    };

    state = {
      typeVisible: false, // 订单类型筛选器
      screenVisible: false, // 店铺选择
    }

    blurState = {
      screenVisible: false,
    }

    screenWillBlur = (payload) => {
      super.screenWillBlur(payload);
      this.props.changeMessageModules(['shops.ordermanage.orderId'], false);
    }

    componentWillUnmount() {
      RightTopModal.hide();
    }

    componentDidMount() {
      const { fetchOrderList, userShop, params } = this.props;
      const shopId = userShop.id || params.shopId;
      fetchOrderList(shopId);
      this.listenBack();
    }

    changeOrderType = (val) => {
      const { fetchOrderList, userShop, params } = this.props;
      const shopId = params.shopId || userShop.id;
      fetchOrderList(shopId, val === 1 ? 'ONLINE' : 'OFFLINE');
      this.setState({
        typeVisible: false,
      });
    }

    listenBack=() => { // 监听返回
      BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid);
    }

    removeListen=() => {
      BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid);
    }

    // 触发返回键执行方法
    onBackAndroid = () => {
      if (this.props.navigation.isFocused()) {
        this.goBack();
        return true;
      }
      return false;
    };

    chooseItemTitle = (item, index) => {
      const { fetchOrderList, userShop, params } = this.props;
      const shopId = params.shopId || userShop.id;
      fetchOrderList(shopId, params.type, item.status);
    }

    chooseItem = (item = {}) => {
      const { fetchOrderList, params } = this.props;
      fetchOrderList(item.id, params.type, params.orderStatus);
      this.setState({
        screenVisible: false,
      });
    }

    renderTabTitle = (tabsTitle = [], orderStatus = '', isOnline, messageModules) => tabsTitle.map((item, index) => {
      const active = item.status === orderStatus;
      // console.log(tabsTitle, orderStatus, isOnline, messageModules);
      return (
        <View style={[styles.tabItemview, { marginRight: index == tabsTitle.length - 1 ? 20 : 15 }]} key={item.index}>
          <TouchableOpacity
            onPress={() => {
              this.chooseItemTitle(item, index);
            }}
            style={styles.tabTouchItem}
          >
            <IconWithRedPoint test={isOnline && !active && item.status ? new RegExp(`^orderlist.tabs.${item.status}`, 'gm') : null} messageModules={messageModules}>
              <View style={{ paddingHorizontal: 6 }}>
                <Text style={[styles.cff14, { opacity: active ? 1 : 0.7 }]}>{item.name}</Text>
              </View>
            </IconWithRedPoint>
          </TouchableOpacity>
          { active ? <View style={styles.chooseItem} /> : null }
        </View>
      );
    })

    gotoDetaills = (item = {}) => {
      const {
        params, userShop, userInfo, navigation, fetchOrderList,
      } = this.props;
      const userId = userInfo.id || '';
      const shopId = params.shopId || userShop.id;
      const { sceneStatus, orderId } = item;
      console.log('gotoDetaills', params);
      const isShouhou = params.orderStatus === 'SHOUHOU';
      const initData = () => {
        fetchOrderList(shopId, params.type, params.orderStatus);
      };
      const orderParams = {
        page: 'OrderList', orderId, shopId, initData, isShouhou, userId,
      };
      switch (sceneStatus) {
        case 'SERVICE_OR_STAY':
          // 服务或者住宿类
          navigation.navigate('AccommodationOrder', orderParams);
          break;
        case 'TAKE_OUT':
        case 'ON_LINE_TAKE_OUT':
          // 外卖   售后
          navigation.navigate('GoodsTakeOut', orderParams);
          break;
        case 'LOCALE_BUY':
          // 现场消费E
          navigation.navigate('GoodsSceneConsumption', orderParams);
          break;
        case 'SERVICE_AND_LOCALE_BUY':
          navigation.navigate('StayStatementOrder', orderParams);
          // 服务+现场消费+加购
          break;
        case 'SHOP_HAND_ORDER':
          // 线下订单
          navigation.navigate('OfflneOrder', orderParams);
          break;
        default:
          break;
      }
    }

    // 下拉刷新
    refreshData = () => {
      const { fetchOrderList, userShop, params } = this.props;
      const shopId = params.shopId || userShop.id;
      fetchOrderList(shopId, params.type, params.orderStatus);
    }

    // 上啦加载
    loadMoreData = () => {
      const {
        fetchOrderList, userShop, params, pagination,
      } = this.props;
      const shopId = params.shopId || userShop.id;
      fetchOrderList(shopId, params.type, params.orderStatus, pagination.page + 1);
    }

    renderShaiItem = () => {
      const { juniorShops = [] } = this.props;
      return juniorShops.map((item, index) => (
        <TouchableOpacity
          key={index}
          onPress={() => this.chooseItem(item)}
          style={[styles.shaixuanItem, { borderBottomWidth: index == juniorShops.length - 1 ? 0 : 1 }]}
        >
          <Text style={{ paddingHorizontal: 15 }}>{item.name}</Text>
        </TouchableOpacity>
      ));
    }

    closeTypeModal=(typeVisible) => {
      this.setState({
        typeVisible,
      });
    }

    showTypeModal=() => {
      this.setState({
        typeVisible: true,
      }, () => {
        RightTopModal.show({
          options: [
            { title: '线上订单', onPress: () => this.changeOrderType(1) },
            { title: '线下订单', onPress: () => this.changeOrderType(-1) },
          ],
          children: (
            <View style={styles.modalTitleicon}>
              {this.renderHeaderCenter()}
            </View>
          ),
          closeCallback: () => this.closeTypeModal(false),
          contentStyle: { right: width / 2 - 60, top: CommonStyles.headerPadding + (Platform.OS == 'ios' ? 48 : 24) },
          sanjiaoStyle: { right: 126 / 2 - 10 },
          modalShaixuanStyle: { paddingHorizontal: 10 },
        });
      });
    }

    renderHeaderCenter=() => {
      const { typeVisible } = this.state;
      return (
        <TouchableOpacity
style={styles.titleicon}
                onPress={this.showTypeModal}
        >
          <Text style={styles.titletxt}>我的订单</Text>
          <Image source={typeVisible ? upchooseicon : downchoose} style={{ marginLeft: 6 }} />
        </TouchableOpacity>
      );
    }

    goBack=() => {
      this.removeListen();
      NavigatorService.resetTab('Shop', {});
    }

    render() {
      const {
        navigation, pagination, list, params, messageModules,
      } = this.props;
      const isShouhou = params.orderStatus === 'SHOUHOU';
      const { screenVisible, typeVisible } = this.state;
      const { type = 'ONLINE', orderStatus = '' } = params || {};
      const isOnline = type === 'ONLINE';
      const TABS_TITLE_LIST = isOnline ? TABS_TITLE_ONLINE : TABS_TITLE_OFFLINE;

      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack={false}
            centerView={typeVisible ? null : this.renderHeaderCenter(false)}
            leftView={(
              <TouchableOpacity style={styles.headerLeftView} onPress={this.goBack}>
                <Image source={require('../../../images/mall/goback.png')} />
              </TouchableOpacity>
            )}
            rightView={(
              <View style={{ width: 50, justifyContent: 'center', left: 0 }}>
                <View style={{ position: 'absolute', flexDirection: 'row' }}>
                  <TouchableOpacity
                    onPress={() => navigation.navigate('OrderSearch')}
                    style={{ width: 50, alignItems: 'flex-end' }}
                  >
                    <Image style={{ marginRight: 25 }} source={search || { uri: '' }} />
                  </TouchableOpacity>
                </View>
              </View>
            )}
          />
          <View style={styles.toptabView}>
            <View style={styles.topleft}>
              <ScrollView
                ref={ref => this.tabScroll = ref}
                showsHorizontalScrollIndicator={false}
                style={{ paddingLeft: 15, flex: 1 }}
                horizontal
              >
                {
                  this.renderTabTitle(TABS_TITLE_LIST, orderStatus, isOnline, messageModules)
                }
              </ScrollView>
            </View>
            <TouchableOpacity
              onPress={() => this.setState({ screenVisible: true })}
              style={styles.topRight}
            >
              <View style={{
                width: 1, height: 18, backgroundColor: 'rgba(255,255,255,0.20)', marginRight: 15,
              }}
              />
              <Text style={styles.cff14}>筛选</Text>
            </TouchableOpacity>
          </View>
          <View style={styles.listContent}>
            <FlatListView
              data={list}
              style={styles.flatListSty}
              renderItem={({ item }) => <OrderCard isShouhou={isShouhou} data={item} onPress={this.gotoDetaills} />}
              store={pagination}
              refreshData={this.refreshData}
              loadMoreData={this.loadMoreData}
            />
          </View>
          <Modal
            animationType="fade"
            transparent
            visible={screenVisible}
            onRequestClose={() => { this.setState({ screenVisible: false }); }}
          >
            <TouchableOpacity
              activeOpacity={1}
              onPress={() => this.setState({ screenVisible: false })}
              style={styles.modalView}
            >
              <View style={styles.sanjiao} />
              <ScrollView style={styles.modalShaixuan} showsVerticalScrollIndicator={false}>{this.renderShaiItem()}</ScrollView>
            </TouchableOpacity>
          </Modal>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  titletxt: {
    fontSize: 17,
    color: '#fff',
  },
  titleicon: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalTitleicon: {
    justifyContent: 'center',
    alignItems: 'center',
    height: 24,
    width,
    position: 'absolute',
    top: Platform.OS == 'ios' ? CommonStyles.headerPadding + 10 : CommonStyles.headerPadding - 14,
    left: 0,
  },
  toptabView: {
    width,
    height: 38,
    backgroundColor: '#4A90FA',
    flexDirection: 'row',
  },
  flatListSty: {
    width: getwidth(355),
    flex: 1,
    backgroundColor: '#EEEEEE',
  },
  listContent: {
    width,
    alignItems: 'center',
    flex: 1,
  },
  topleft: {
    width: width - getwidth(70),
    height: 38,
  },
  topRight: {
    width: getwidth(70),
    height: 38,
    flexDirection: 'row',
    alignItems: 'center',
  },
  cff14: {
    color: '#FFFFFF',
    fontSize: 14,
  },
  tabItemview: {
    height: 38,
    marginRight: 25,
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabTouchItem: {
    height: 36,
    justifyContent: 'center',
    alignItems: 'center',
    overflow: 'visible',
    paddingHorizontal: 4,
  },
  chooseItem: {
    width: '100%',
    height: 8,
    marginBottom: 0,
    backgroundColor: '#fff',
    borderRadius: 10,
    position: 'absolute',
    bottom: -5,
  },
  headerLeftView: {
    width: 50,
    alignItems: 'center',
  },
  orderRight: {
    width: getwidth(355) - 30 - getwidth(80),
    height: 80,
    paddingHorizontal: 14,
    justifyContent: 'space-around',
  },
  modalView: {
    width,
    height,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  modalShaixuan: {
    position: 'absolute',
    top: 90 + CommonStyles.headerPadding,
    right: 10,
    backgroundColor: '#fff',
    borderRadius: 6,
    maxHeight: 250,
  },
  sanjiao: {
    position: 'absolute',
    top: 86 + CommonStyles.headerPadding,
    right: 30,
    width: 20,
    height: 20,
    borderWidth: 1,
    backgroundColor: 'white',
    borderLeftColor: '#DDDDDD',
    borderTopColor: '#DDDDDD',
    borderRightColor: 'white',
    borderBottomColor: 'white',
    transform: [{ rotateZ: '45deg' }],
  },
  shaixuanItem: {
    height: 44,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default connect(
  state => ({
    pagination: state.order.orderList.pagination || {},
    params: state.order.orderList.params || {},
    list: state.order.orderList.list || [],
    juniorShops: state.shop.juniorShops || [],
    userShop: state.user.userShop || {},
    userInfo: state.user.user || {},
    messageModules: state.application.messageModules,
  }), {
    fetchOrderList: (shopId = '', type = 'ONLINE', orderStatus = '', page = 1, limit = 10) => ({
      type: 'order/fetchOrderList',
      payload: {
        type, orderStatus, shopId, page, limit,
      },
    }),
    changeMessageModules: (modules = [], flag = false) => ({ type: 'application/changeMessageModules', payload: { modules, flag } }),
  },
)(OrderListScreen);
