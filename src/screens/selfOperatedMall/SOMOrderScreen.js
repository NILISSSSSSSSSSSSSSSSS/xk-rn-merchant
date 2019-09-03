/**
 * 自营商城订单管理
 */
import React, { Component, PureComponent } from "react";
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  TouchableOpacity,
  BackHandler,
  Platform
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";

import { debounce } from '../../config/utils'
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import FlatListView from "../../components/FlatListView";
import ImageView from "../../components/ImageView";
import Ordercell from "../../components/Ordercell";
import Popover from "../../components/Popover";
import Model from "../../components/Model";
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar'
import * as nativeApi from "../../config/nativeApi";
import ListEmptyCom from '../../components/ListEmptyCom';
import ScrollableTabView from "react-native-scrollable-tab-view";
const { width, height } = Dimensions.get("window");
// let baseInfo = [] // 商城基本信息，需要合并到所有订单数据中
class SOMOrderScreen extends Component {
  static navigationOptions = {
    gesturesEnabled: false, // 禁用ios左滑返回
    header: null
  };
  _didFocusSubscription;
  _willBlurSubscription;
  constructor(props) {
    super(props);
    this._didFocusSubscription = props.navigation.addListener('willFocus', payload => {
      BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
      this.refresh();
    });
    this.state = {
      currentTab: this.props.navigation.getParam("tabsIndex", 0), //当前tab页
      visiblePopover: false,
      buttonRect: {},
      // currentItemIndex:0,
      currentItem: {
        orderStatus: 'PRE_SHIP',
        goods: [],
        status: ''
      }, // 点击prover弹出对应的订单
      modelVisible: false,
      modelType: "confirm",
      limit: 5,
      page: 1,
      hasMore: true,
      total: 0,
      refreshing: false,
      showAllPayBtn: false, // 显示合并按钮
      allData: [[], [], [], [], [], [], []], // 所有数据
      selectArr: [],
      selectedAll: false,
      more: [
        { title: "联系客服", func: () => { this.gotoCunstom() } },
      ],
      noticeList: new Map()
    };
  }

  componentDidMount() {
    // this.refresh();
    this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload => {
      BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
    }
    );
  }
  componentWillUnmount() {
    BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
    this._didFocusSubscription && this._didFocusSubscription.remove();
    this._willBlurSubscription && this._willBlurSubscription.remove();
    this.setState({
      modelVisible: false
    });
  }
  goSom = async () => {
    await this.props.navigation.navigate('SOM')
  }
  handleBackPress = () => {
    console.log('SOMORDER')
    let goBackRouteName = this.props.navigation.getParam('goBackRouteName', '')
    if (goBackRouteName) {
      this.props.navigation.navigate(goBackRouteName)
    } else {
      this.goSom();
    }
    return true
  };
  // 获取当前tabs对应的订单状态
  getInitTabsIndex = type => {
    switch (type) {
      case 0: return "";
      case 1: return "PRE_PAY";
      case 2: return "PRE_SHIP";
      case 3: return "PRE_RECEVICE";
      case 4: return "PRE_EVALUATE";
      case 5: return "COMPLETELY";
    }
  };
  // 刷新数据
  refresh = (page = 1) => {
    const { currentTab } = this.state;
    currentTab > 5
      ? this.refreshAfterSaleOrder(page)
      : this.refreshNormalOrder(page);
  };
  refreshNormalOrder = page => {
    const { limit, currentTab, total } = this.state;
    const { SOMOrderList } = this.props;
    let status = this.getInitTabsIndex(currentTab);
    let params = {
      orderStatus: status,
      limit: 10,
      page,
      currentTab
    }
    let orderList = SOMOrderList[currentTab].data;
    if (orderList.length === 0) {
      Loading.show();
    }
    this.props.actions.fetchMallOrderList(params)
  };
  // 获取售后订单列表
  refreshAfterSaleOrder = page => {
    const { currentTab } = this.state;
    const { SOMOrderList } = this.props;
    let params = {
      limit: 10,
      page,
      currentTab,
    }
    let orderList = SOMOrderList[currentTab].data;
    if (orderList.length === 0) {
      Loading.show();
    }
    this.props.actions.fetchMallRefundOrderList(params)
  };
  // 取消订单
  handleCancelOrder = () => {
    Loading.show();
    const { currentItem } = this.state;
    if (!currentItem.orderId) return;
    requestApi
      .queryCancelOrder({ orderId: currentItem.orderId })
      .then(res => {
        Toast.show("取消成功");
        this.setState({
          visiblePopover: false,
          modelVisible: false,
          refreshing: true
        }, () => {
          this.refresh()
        })
      }).catch((err)=>{
        console.log(err)
      });
  };
  showPopover = data => {
    this.setState({
      ...data,
      visiblePopover: !this.state.visiblePopover
    });
  };
  closePopover = () => {
    this.setState({
      visiblePopover: false
    });
  };
  showModel = type => {
    this.setState({ modelVisible: true, modelType: type });
  };
  handleChangeState = (key, value, callback = () => { }) => {
    this.setState(
      {
        [key]: value
      },
      () => {
        callback();
      }
    );
  };
  // 跳转到退款
  goToRefunds = (type = 0) => {
    // 跳转时，对当前订单商品做筛选，售后只显示可以退款和退货的商品
    const { navigation, actions } = this.props;
    const { currentItem } = this.state;
    let fliterRefund = [[], []]; // 二维数组，0已经退货商品，1，可以退货商品
    let data = JSON.parse(JSON.stringify(currentItem));
    currentItem.goods.map((item, index) => {
      // 商品售后拒绝后，次数未超过2次，可以继续申请
      if ((item.refundType === "REFUND" || item.refundType === "REFUND_GOODS") && item.refundStatus !== 'REFUSED' && item.refundCount !== 2) {
        fliterRefund[0].push(item);
      } else {
        fliterRefund[1].push(item);
      }
    });
    if (fliterRefund[0].length === currentItem.goods.length) {
      // 如果全部已经退款或者退货
      Toast.show("当前订单无可退货退款商品！", 2000);
      return;
    }
    data.goods = fliterRefund[1];
    this.setState(
      {
        visiblePopover: false
      },
      () => {
        if (type === 0) {
          navigation.navigate("SOMAfterSale", {
            orderDdata: data,
            callback: this.refresh
          });
        }
        if (type === 1) {
          navigation.navigate("SOMRefund", {
            orderInfo: data,
            afterSaleGoods: data.goods,
            callback: this.refresh
          });
        }

      }
    );
  };
  // 跳转到物流追踪
  goToLogistics = () => {
    const { navigation } = this.props;
    const { currentItem } = this.state;
    this.setState(
      {
        visiblePopover: false
      },
      () => {
        navigation.navigate("SOMLogistics", {
          orderDdata: currentItem
        });
      }
    );
  };
  // 确认收货
  mallOrderMUserConfirmReceive = (data = {}) => {
    const { navigation } = this.props;
    // 暂时不做验证，注释
    // let refundGoods = [];
    // // 判断当前订单中是否存在售后商品，且售后商品未完成流程
    // data && data.goods.map(item => {
    //     if (item.refundStatus !== null &&
    //     (item.refundStatus === 'APPLY'
    //     || item.refundStatus === 'PRE_USER_SHIP'
    //     || item.refundStatus === 'PRE_PLAT_RECEIVE'
    //     || item.refundStatus === 'PRE_REFUND'
    //     || item.refundStatus === 'REFUNDING')) {
    //         refundGoods.push(item)
    //     }
    // })
    // if (refundGoods.length > 0) {
    //     Toast.show('当前订单中存在售后商品，暂不能确认收货！')
    //     return
    // }
    Loading.show();
    let params = {
      orderId: data.orderId || ''
    };
    requestApi.mallOrderMUserConfirmReceive(params).then(res => {
      navigation.navigate("SOMReceivSuccess", {
        callback: this.refresh,
        orderData: data
      });
    }).catch(err => {
      Toast.show("收货失败，请刷新重试！", 2000);
    });
  };
  // 取消退款
  handleCancelRefund = () => {
    Loading.show();
    const { currentItem } = this.state;
    let params = {
      refundId: currentItem.refundId
    };
    // 仅退款时， 当用户发起仅退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
    if (currentItem.refundType === "REFUND") {
      if (currentItem.refundStatus === 'PRE_REFUND' || currentItem.refundStatus === "REFUNDING" || currentItem.refundStatus === "COMPLETE") {
        this.setState({
          modelVisible: false
        }, () => {
          Loading.hide();
          Toast.show("暂不能进行退款操作,请联系客服!", 3000);
        })
        return
      }
    }
    // 退货退款时， 当用户发起退货退款时，平台客服同意后，用户无法取消退款申请，若用户需要取消申请，只能联系客服
    if (currentItem.refundType === "REFUND_GOODS") {
      if (currentItem.refundStatus === "PRE_USER_SHIP" || currentItem.refundStatus === "PRE_PLAT_RECEIVE" || currentItem.refundStatus === "PRE_REFUND" || currentItem.refundStatus === "REFUNDING" || currentItem.refundStatus === "COMPLETE") {
        this.setState({
          modelVisible: false
        }, () => {
          Loading.hide();
          Toast.show("暂不能进行退款操作,请联系客服!", 3000);
        })
        return
      }
    }
    this.setState({ modelVisible: false })
    requestApi.mallOrderMUserRefundCancel(params).then(res => {
      Toast.show("取消退款成功！", 2000);
      this.setState({ modelVisible: false });
      Loading.show();
      setTimeout(() => {
        this.refresh(1);
      }, 4000)
    }).catch(err => {
      Toast.show("取消失败，请重试！", 2000);
      this.setState({
        modelVisible: false
      });
    });
  };
  // 跳转到评价
  goToEvaluation = item => {
    const { navigation } = this.props;
    // 暂时不做验证，注释
    // 如果商品是在售后流程
    // 如果售后状态为完成，则可以评价且过滤掉这个商品、
    // 如果有正在售后的商品，不允许评价
    // let normalGoods = [];
    // let refundGoods = [];
    // item.goods.map(goodsItem => {
    //     if (goodsItem.refundId === null || goodsItem.refundStatus === 'NONE' || goodsItem.refundType === null) {
    //         normalGoods.push(goodsItem)
    //     }
    //     // 如果未结束售后流程
    //     if (goodsItem.refundStatus === 'APPLY'
    //     || goodsItem.refundStatus === 'PRE_USER_SHIP'
    //     || goodsItem.refundStatus === 'PRE_PLAT_RECEIVE'
    //     || goodsItem.refundStatus === 'PRE_REFUND'
    //     || goodsItem.refundStatus === 'REFUNDING'
    //     ) {
    //         refundGoods.push(goodsItem)
    //     }
    // })
    // if (refundGoods.length > 0) {
    //     Toast.show('订单存在售后商品，暂无法评价！')
    //     return
    // } else {
    //     let _item = JSON.parse(JSON.stringify(item))
    //     item.goods = normalGoods
    //     navigation.navigate("SOMOrderEvaluation", {
    //         orderData: _item,
    //         callback: this.refresh
    //     });
    // }
    navigation.navigate("SOMOrderEvaluation", {
      orderData: item,
      callback: this.refresh
    });
  };
  // 跳转到客服
  gotoCunstom = () => {
    nativeApi.createXKCustomerSerChat();
  }
  // 获取更多
  getDetailMoreBtn = (item) => {
    let more = [{ title: "联系客服", func: () => { this.gotoCunstom() } }]
    if (item.status === 'active') {
      more = [
        { title: "联系客服", func: () => { this.gotoCunstom() } },
        {
          title: "查看物流",
          func: () => {
            this.goToLogistics();
          }
        }
      ]

    }
    if (item.dividedAble === 0 && item.status === 'active') {
      more.push({
        title: "申请售后",
        func: () => {
          this.goToRefunds();
        }
      })
    }
    return more
  }
  goDetails = (item) => {
    const { navigation } = this.props
    const { currentTab } = this.state
    this.handleChangeState("currentItem", item);
    if (currentTab === 6) {
      // 售后没有详情,判断是进入等待审核页面还是进度页面
      // 状态为 退款完成 退款中 待平台退款 待平台收货 跳转进度页面
      if (item.refundStatus === 'COMPLETE'
        || item.refundStatus === 'REFUNDING'
        || item.refundStatus === 'PRE_REFUND'
        || item.refundStatus === 'PRE_PLAT_RECEIVE') {
        navigation.navigate('SOMRefundProcess', {
          refundId: item.refundId,
          callback: () => { },
        })
        return
      }
      if (item.refundType === 'REFUND') {
        navigation.navigate('SOMRefundMoney', {
          refundId: item.refundId,
          routerIn: 'details'
        })
        return
      }
      if (item.refundType === 'REFUND_GOODS') {
        navigation.navigate('SOMReturnedAllWait', {
          refundId: item.refundId,
          callback: () => { },
          routerIn: 'details'
        })
      }
    } else {
      let popoverData = item.goodsDivide === 2 ? this.getCommoditButton(currentTab, item) : this.getBottomButtonByKey(currentTab, item)
      navigation.navigate("SOMOrderDetails", {
        nextData: popoverData,
        data: item,
        callback: () => { },
      });
    }
  }
  // 根据当前订单状态，获取订单可操作项
  getOrderItemStatus(item = { orderStatus: 'PRE_PAY' }) {
    if (item.status === 'del') return 5
    switch (item.orderStatus) {
      case 'PRE_PAY': return 1;
      case 'PRE_SHIP': return 2;
      case 'PRE_RECEVICE': return 3;
      case 'PRE_EVALUATE': return 4;
      case 'COMPLETELY': return 5;
      default: return 6;
    }
  }
  handleCanRefund = (currentItem) => {
    let temp = currentItem.goods.map(item => item.refundCount === 2 ? true : false)
    return temp.includes(true)
  }
  // 提醒发货
  handlePutNotice = (item, index) => {
    const { noticeList, currentTab } = this.state
    if (!noticeList.has(`${currentTab}${index}`)) {
      this.setState({
        noticeList: noticeList.set(`${currentTab}${index}`, `${currentTab}${index}`)
      })
      requestApi.mallOrderRemindShipping({ orderId: item.orderId }).then(() => {
        Toast.show("提醒发货成功！", 500);
        Loading.hide()
      }).catch((err)=>{
        console.log(err)
      });
    } else {
        Loading.hide()
        Toast.show("提醒发货成功！", 500);
    }
  }
  getBottomButtonByKey = (currentTab, item) => {
    let popoverData = this.getDetailMoreBtn(item);
    switch (currentTab){
      case 0: return this.getBottomButtonByKey(this.getOrderItemStatus(item), item);
      case 1: return {
        key: 1,
        nextOperTitle: "去付款",
        nextOperFunc: null,
        operateCallBack: () => {
          this.refresh();
        },
        more: [
          { title: "联系客服", func: () => { this.gotoCunstom() } },
          {
            title: "取消订单",
            func: () => {
              this.showModel("confirm");
            }
          }
        ],
        status: "等待付款"
      };
      case 2: return {
        key: 2,
        nextOperTitle: "提醒发货",
        nextOperFunc: (item, index) => {
          Loading.show()
          this.handlePutNotice(item, index)
        },
        more: [
          { title: "联系客服", func: () => { this.gotoCunstom() } },
          {
            title: "申请售后",
            func: () => {
              this.goToRefunds();
            }
          }
        ],
        status: "等待商家发货"
      }
      case 3: return {
        key: 3,
        nextOperTitle: "确认收货",
        nextOperFunc: this.mallOrderMUserConfirmReceive,
        more: popoverData,
        status: "等待买家收货"
      }
      case 4: return {
        key: 4,
        nextOperTitle: "去评价",
        nextOperFunc: item => {
          if (item !== null) {
            this.setState({ currentItem: item }, () => {
              this.goToEvaluation(item);
            });
          }
        },
        more: popoverData,
        status: "等待买家评价"
      }
      case 5: return {
        key: 5,
        nextOperTitle: null,
        nextOperFunc: null,
        more: popoverData,
        status: "交易完成"
      }
      case 6: return {
        key: 6,
        nextOperTitle: "去发货",
        nextOperFunc: (item = null) => {
          this.goDetails(item)
        },
        more: null,
        // more: [
        //   { title: "联系客服", func: () => { this.gotoCunstom() } },
        //   { title: "取消售后", func: (item = null) => {
        //     this.showModel("confirm");
        //     if (item !== null) {
        //       this.setState({ currentItem: item });
        //     }
        //    }},
        // ],
        status: "退款申请中"
      }
    }
  }
  // 获取大宗商品操作按钮
  getCommoditButton = (currentTab, item) => {
    let popoverData = [
      {
        title: "联系客服",
        func: () => { this.gotoCunstom() }
      }
    ];
    switch (currentTab){
      case 0: return this.getCommoditButton(this.getOrderItemStatus(item), item);
      case 1: return {
        key: 1,
        nextOperTitle: "去付款",
        nextOperFunc: null,
        operateCallBack: () => {
          this.refresh();
        },
        more: [
          { title: "联系客服", func: () => { this.gotoCunstom() } },
          {
            title: "取消订单",
            func: () => {
              this.showModel("confirm");
            }
          }
        ],
        status: "等待付款"
      };
      case 2: return {
        key: 2,
        nextOperTitle: "提醒发货",
        nextOperFunc: (item, index) => {
          Loading.show()
          this.handlePutNotice(item, index)
        },
        more: popoverData,
        status: "等待商家发货"
      }
      case 3: return {
        key: 3,
        nextOperTitle: "确认收货",
        nextOperFunc: this.mallOrderMUserConfirmReceive,
        more: popoverData,
        status: "等待买家收货"
      }
      case 4: return {
        key: 4,
        nextOperTitle: "去评价",
        nextOperFunc: item => {
          if (item !== null) {
            this.setState({ currentItem: item }, () => {
              this.goToEvaluation(item);
            });
          }
        },
        more: popoverData,
        status: "等待买家评价"
      }
      case 5: return {
        key: 5,
        nextOperTitle: null,
        nextOperFunc: null,
        more: popoverData,
        status: "交易完成"
      }
      case 6: return {
        key: 6,
        nextOperTitle: "取消售后",
        nextOperFunc: (item = null) => {
          this.showModel("confirm");
          if (item !== null) {
            this.setState({ currentItem: item });
          }
        },
        more: null,
        status: "退款申请中"
      }
    }
  }
  render() {
    const { navigation, SOMOrderList, actions } = this.props;
    const {
      currentTab,
      currentItem
    } = this.state;
    let allData = SOMOrderList
    let popoverData = currentItem.goodsDivide === 2 ? this.getCommoditButton(currentTab, currentItem) : this.getBottomButtonByKey(currentTab, currentItem)
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={true}
          leftView={
            <View>
              <TouchableOpacity
                style={[styles.headerItem, styles.left]}
                onPress={() => {
                  let goBackRouteName = this.props.navigation.getParam('goBackRouteName', '')
                  if (goBackRouteName) {
                    navigation.navigate(goBackRouteName)
                  } else {
                    navigation.navigate("SOM");
                  }
                }}
              >
                <Image source={require("../../images/mall/goback.png")}/>
              </TouchableOpacity>
            </View>
          }
          title="商城订单"
        />
        <ScrollableTabView
          initialPage={this.props.navigation.getParam("tabsIndex", 0)}
          onChangeTab={({ i }) => {
            if (i === this.state.currentTab) {
              Loading.show();
            }
            this.setState({ currentTab: i }, () => {
              this.refresh(1);
            });
          }}
          renderTabBar={() => (
            <ScrollableTabBar
              underlineStyle={{
                backgroundColor: "#fff",
                height: 8,
                borderRadius: 10,
                marginBottom: -5,
                width: "8%",
                marginLeft: this.state.currentTab == 6 ? "2%" : (this.state.currentTab === 0) ? "2%" : "2.8%"
              }}
              tabStyle={{
                backgroundColor: "#4A90FA",
                height: 44
              }}
              activeTextColor="#fff"
              inactiveTextColor="rgba(255,255,255,.5)"
              tabBarTextStyle={{ fontSize: 14 }}
              style={{
                backgroundColor: "#4A90FA",
                height: 44,
                borderBottomWidth: 0
              }}
            />
          )}
        >
          {["全部", "待付款", "待发货", "待收货", "待评价", "已完成", "售后"].map((itemTab, index) => {
            return (
              <FlatListView
                tabLabel={itemTab}
                extraData={this.state}
                style={{
                  backgroundColor: CommonStyles.globalBgColor
                }}
                store={allData[index]}
                tabLabel={itemTab}
                key={itemTab + index}
                data={allData[index].data}
                refreshData={() => {
                  this.handleChangeState("refreshing", true);
                  this.refresh(1);
                }}
                ListEmptyComponent={<ListEmptyCom type='orderListEmpty' />}
                loadMoreData={() => {
                  this.refresh(allData[currentTab].page + 1);
                }}
                renderItem={({ item, index }) => {
                  let _nextData = item.goodsDivide === 2 ? this.getCommoditButton(currentTab, item) : this.getBottomButtonByKey(currentTab, item)
                  return (<Ordercell
                    navigation={navigation}
                    actions={actions}
                    item={item}
                    index={index}
                    nextData={_nextData}
                    showPopover={data =>
                      this.showPopover(data)
                    }
                    goDetails={() => {
                      this.goDetails(item)
                    }}
                    refresh={this.refresh}
                  />)
                }
                }
              />
            );
          })}
        </ScrollableTabView>
        <Popover
          isVisible={this.state.visiblePopover}
          fromRect={this.state.buttonRect}
          onClose={() => this.closePopover()}
          placement={"top"}
        >
          {
            popoverData.more
              ? popoverData.more.map((item, index) => {
                if ((currentItem.dividedAble === 1 && item.title === '申请售后')) { // 判断是否允许退货
                  return null
                }
                if ((currentItem.dividedAble === 0 && item.title === '申请售后') && this.handleCanRefund(currentItem)) {
                  return null
                }
                return (
                  <Text
                    key={index}
                    style={[styles.popContent, styles.androidStyle, index > 0 && Platform.OS === 'ios' ? { paddingTop: 0 } : { paddingTop: 8 }]}
                    onPress={() => { this.setState({ visiblePopover: false }, () => { item.func(); }) }}
                  >
                    {item.title}
                  </Text>
                );
              })
              : null
          }
        </Popover>

        <Model
          type={this.state.modelType}
          title={currentTab == 1 || (currentTab === 0 && currentItem.orderStatus === 'PRE_PAY') ? "确定要取消订单吗" : "确定要取消退款吗"}
          visible={this.state.modelVisible}
          onShow={() => this.setState({ modelVisible: true })}
          onConfirm={() => {
            currentTab == 1 || (currentTab === 0 && currentItem.orderStatus === 'PRE_PAY')
              ? this.handleCancelOrder()
              : this.handleCancelRefund();
          }}
          onClose={() => this.setState({ modelVisible: false })}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding
  },
  itemTop: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    width: width,
    height: 50 + CommonStyles.footerPadding,
    paddingBottom: CommonStyles.footerPadding,
    backgroundColor: "#fff"
  },
  itemTopLeft: {
    flexDirection: "row",
    alignItems: "center",
    height: "100%",
    paddingHorizontal: 24
  },
  unSelected: {
    width: 15,
    height: 15,
    borderWidth: 1,
    borderColor: "#979797",
    borderRadius: 15
  },
  itemTopLeft_text: {
    fontSize: 14,
    color: "#222",
    marginLeft: 9
  },
  itemTopRight: {
    borderWidth: 1,
    borderColor: "#EE6161",
    marginHorizontal: 24,
    paddingHorizontal: 18,
    paddingVertical: 5,
    borderRadius: 12
  },
  itemTopRight_text: {
    fontSize: 12,
    color: "#EE6161"
  },
  popContent: {
    fontSize: 12,
    color: "#222",
    textAlign: "center",
    paddingTop: 10,
    paddingHorizontal: 14,
    backgroundColor: "#fff",

  },
  noBorder: {
    borderBottomWidth: 0
  },
  androidStyle: {
    borderBottomWidth: 1,
    borderColor: '#f1f1f1',
    paddingTop: 8,
    paddingBottom: 8,
  },
  headerItem: {
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    height: "100%"
    // position: 'absolute'
  },
  left: {
    width: 50
  }
});

export default connect(
  state => ({ SOMOrderList: state.mallReducer.SOMOrderList }),
  dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMOrderScreen);
