/**
 * 我的中奖记录
 */
import React, { Component, PureComponent } from "react";
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  Modal,
  ScrollView,
  ImageBackground,
  TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import * as nativeApi from '../../config/nativeApi';
import ScrollableTabView from "react-native-scrollable-tab-view";
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import FlatListView from "../../components/FlatListView";
import * as requestApi from "../../config/requestApi";
import PickerOld from 'react-native-picker-xk';
import Picker from '../../components/Picker';
import moment from 'moment';
import { formatPriceStr } from '../../config/utils.js';
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar'
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import Content from '../../components/ContentItem';
import ImageView from "../../components/ImageView";
const { width, height } = Dimensions.get("window");
import { NavigationComponent } from '../../common/NavigationComponent';
import math from "../../config/math.js";
import ToastModal from '../../components/Toast';
import { getPreviewImage } from "../../config/utils";
const separatorLine = require('../../images/shop/separatorLine.png')
const tabTitle = [

  {
    title: '全部夺奖',
    typeKey: ''
  },
  {
    title: '随机红包',
    typeKey: 'packet'
  },
  {
    title: '机会夺奖',
    typeKey: 'j_mall'
  },
  {
    title: '抽到即得',
    typeKey: 'immediate'
  }
]
class WMMyPrizeRecordScreen extends NavigationComponent {
  static navigationOptions = {
    header: null
  };

  constructor(props) {
    super(props);
    this.state = {
      currentTab: 0, // 当前tabs
      typeKey: '', //否	记录类型，j_mall:二次抽奖机会，immediate:即抽即得，packet:红包
      description: '',//奖品简介
      visible: false,
      oprateItem: {}, //弹窗操作item
      parentItem: {},//父级item
      activityNumber: '' //奖品数量
    }
  }

  componentDidMount() {
    Loading.show()
    this.getList(true, false);
  }
  fetchAmount = () => {
    requestApi.myWinningCount().then((data) => {
      this.setState({ activityNumber: data.activity })
    }).catch(() => {
      this.setState({ activityNumber: 0 })
    })
  }

  componentWillUnmount() {
    PickerOld.hide()
  }
  getList = (isFirst = false, isLoadingMore = false, loading = true, refreshing = true) => {
    const { parentItem, typeKey, currentTab } = this.state
    const who = parentItem.serialNum ? 'manyList' : 'record'
    who == 'record' && !isLoadingMore ? this.fetchAmount() : null //

    let params = {}
    typeKey ? params.typeKey = typeKey : null
    parentItem.serialNum ? params.serialNum = parentItem.serialNum : null
    this.props.fetchList({
      witchList: who == 'record' ? ('prize' + currentTab) : 'modalManyList',
      isFirst,
      isLoadingMore,
      paramsPrivate: params,
      api: who == 'record' ? requestApi.platSpendLotteryRecordUserQpage : requestApi.jPlatQpage,
      loading,
      refreshing
    })
  };
  screenWillBlur = (payload) => {
    super.screenWillBlur(payload);
    this.closeModal()
  }
  showMoadl = (item) => {
    const { longLists, shopSave } = this.props
    shopSave({
      longLists: {
        ...longLists,
        modalManyList: {}
      }
    })
    this.setState({
      visible: true,
      parentItem: item
    }, () => {
      this.getList(false, false)
    })
  }
  closeModal = () => {
    this.setState({
      visible: false,
      parentItem: {},
      oprateItem: {}
    })
  }
  itemOnpress = (item, who, isModalItem, isMoreList) => {
    const { navigation, dispatch } = this.props
    if (isModalItem && !item.isMatch) {
      this.Toast.show('该场夺奖正在匹配中，请耐心等待')
    } else if (isMoreList) {
      this.showMoadl(item)
    }else if(item.goodsType=='red_packet'){ //红包
      navigation.navigate('FinanceTradeRecord', { currency: 'xfq' })
    }
    else if(item.goodsType=='mall'){ //自营商品优惠券
      navigation.navigate('GoodsTickets')
    } else {
      dispatch({ type: 'welfare/listNavigation', payload: { params: { ...item, awardUsage: 'expense', routerIn: 'WMMyPrizeRecord' } } })
      this.closeModal()
    }
  }
  getOrderItemStatusImages = (item, isModalItem) => {
    if (!isModalItem) {
      return null
    }
    else {
      if (!item.isMatch) {
        return (
          <Image source={require('../../images/wm/notStart.png')} />
        );
      }
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
  }

  getOrderItemStatusLabel = (status = '已完成',bgColor = '#ecf3fe', textColor = CommonStyles.globalHeaderColor) => (
    <View style={[ CommonStyles.flex_center,styles.statusWrap, { backgroundColor: bgColor } ]}>
      <Text style={[{ fontSize: 12, color: textColor }]}>{status}</Text>
    </View>
  )

  renderItem = ({ item, index }, who) => {
    const isModalItem = who == 'manyList' //是否是弹窗状态
    const { parentItem } = this.state
    if (isModalItem) {
      item={...parentItem,...item}
      item.mainPic=item.goodsUrl || parentItem.mainPic
      // item.goodName=item.goodsName
      item.goodsId=item.goodsId
      item.skuName=parentItem.skuName
      item.amount=parentItem.amount
      item.price=parentItem.price
      item.isVirtual=parentItem.isVirtual
      item.goodName=parentItem.goodName
    }
    const isMoreList = !isModalItem && (item.goodsType == 'j_mall' && item.continuityNumber && item.continuityNumber > 1) //外部查看全部
    constModalItemStyle = {
      borderWidth: 1,
      borderColor: '#f1f1f1'
    }
    const leftStyle = [styles.smallText, { marginRight: 30 }]
    return (
      <Content activeOpacity={0.65} style={[styles.itemsStyle, isModalItem && constModalItemStyle]} onPress={() => this.itemOnpress(item, who, isModalItem, isMoreList)}>
        <View style={styles.itemTopView}>
          <Text style={{ color: '#999', fontSize: 12 }}>中奖编号：{item.id}</Text>
          {
            isModalItem ?
              this.getOrderItemStatusImages(item, isModalItem) :
              <Text style={{ color: '#FF8523', fontSize: 14 }}>×{item.goodsType === 'red_packet' ? item.multiple : item.amount}</Text>
          }
          <Image source={separatorLine} style={{ position: 'absolute',bottom: 0,left: 0,right: 0, width: width - 20, }}/>
        </View>
        <View style={{ flexDirection: 'row', padding: 15 }}>
          <View style={styles.goodsImageView}>
            <ImageView
              source={{
                uri: getPreviewImage(item.mainPic),
                cache: "force-cache"
              }}
              sourceWidth={80}
              sourceHeight={80}
            />
            {
              item.goodsType == 'j_mall' &&
              <View style={styles.duojiangTag}>
                <Text style={{ color: '#fff', fontSize: 10 }}>夺奖派对</Text>
              </View>
            }
          </View>
          <View style={{ flex: 1 }}>
            <Text style={{ color: '#222', fontSize: 14, lineHeight: 20, marginBottom: 8 }} numberOfLines={2}>{item.goodName}</Text>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'flex-start'}}>
              {
                item.goodsType == 'red_packet' 
                ? <Text style={leftStyle}>金额：{math.divide(item.price || 0,100) }元</Text>
                : item.goodsType == 'j_mall' 
                  ? <React.Fragment>
                    {
                      item.isVirtual && item.virtualType != 'money_car' // AA卡和免单卡显示金额上限
                        ? <Text style={[leftStyle]}>{ `金额上限：${math.divide(item.price ||0 ,100)}元`}</Text>
                        : null
                    }
                    {
                      item.skuName && !item.isVirtual // 如果不是虚拟物品，且有规格
                        ? <Text style={[leftStyle]}>{`规格：${item.skuName}`}</Text>
                        : null
                    }
                    </React.Fragment>
                  : item.goodsType == 'aa_lottery'
                    ? <Text style={leftStyle}>数量：{item.amount}注</Text>
                    : null
              }
              {
                item.goodsType == 'mall' ||  (item.goodsType == 'j_mall' && (item.virtualType=='money_car' || !item.virtualType))
                  ? <Text style={[styles.smallText]}>价值：{formatPriceStr(math.divide(item.price, 100))}元</Text>
                  : null
              }
            </View>
            {
              item.goodsType == 'j_mall' && !isModalItem && item.continuityNumber > 1 && <Text style={styles.smallText}>连场数：{item.continuityNumber}场</Text>
            }
            <Text style={styles.smallText}>获得时间：{moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
            {
              isModalItem && !item.isMatch ?
                <Image resizeMode='cover' source={require('../../images/wm/fingding.png')} style={{ width: '100%' }} /> : null
            }
            <TouchableOpacity
             activeOpacity={0.65}
              style={styles.allBut}
              onPress={() => {
                isMoreList ? this.showMoadl(item) : this.setState({ visible: true, oprateItem: item })
              }}
            >
              <Text style={{ color: CommonStyles.globalHeaderColor, fontSize: 12 }}>{isMoreList ? '查看全部' : '查看简介'}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Content>
    )
  }
  renderFlatlist = (who, item = {}, index) => {
    const { longLists } = this.props;
    const { currentTab } = this.state;
    const listName = who == 'record' ? ('prize' + currentTab) : 'modalManyList'
    const lists = longLists[listName] && longLists[listName].lists || []
    return (
      <FlatListView
        tabLabel={item.title}
        style={{
          backgroundColor: who == 'manyList' ? '#fff' : CommonStyles.globalBgColor
        }}
        contentContainerStyle={{ paddingBottom: CommonStyles.footerPadding }}
        footerStyle={who == 'manyList' ? { backgroundColor: '#fff' } : null}
        ListHeaderComponent={() => (<View />)}
        ItemSeparatorComponent={() => (<View />)}
        key={index}
        store={{
          ...(longLists[listName] || {}),
          page: longLists[listName] && longLists[listName].listsPage || 1
        }}
        data={lists}
        numColumns={1}
        refreshData={() =>
          this.getList(false, false)
        }
        loadMoreData={() =>
          this.getList(false, true)
        }
        renderItem={(data) => this.renderItem(data, who)}
      />
    )
  }
  render() {
    const { navigation } = this.props;
    const { visible, record, manyList, parentItem, oprateItem, activityNumber } = this.state
    console.log("tabtitle", tabTitle);
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={true}
          title={`我的奖品(${activityNumber || 0})`}
        />
        <ScrollableTabView
          initialPage={0}
          onChangeTab={({ i }) => {
            this.setState({
              currentTab: i,
              typeKey: tabTitle[i].typeKey,
            }, () => { this.getList(false, false) });
          }}
          renderTabBar={() => (
            <DefaultTabBar
              tabsContainerStyle={{
                borderBottomColor: 'rgba(215,215,215,0.3)',
                borderBottomWidth: 1,

              }}
              underlineStyle={{
                backgroundColor: "#4A90FA",
                height: 8,
                borderRadius: 10,
                marginBottom: -4,
              }}
              tabStyle={{
                backgroundColor: "#fff",
                height: 37,

              }}
              activeTextColor="#4A90FA"
              inactiveTextColor="#555"
              tabBarTextStyle={{ fontSize: 14 }}
              style={{
                backgroundColor: "#fff",
                height: 38,
                borderBottomWidth: 0,
                overflow: 'hidden'
              }}
            />
          )}
        >
          {
            tabTitle.map((item, index) => {
              return this.renderFlatlist('record', item, index)
            })
          }
        </ScrollableTabView>
        <Modal
          animationType={'slide'}
          transparent={true}
          visible={visible}
          onRequestClose={this.closeModal}
        >
          <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)' }}>
            {
              !oprateItem.id ? //查看全部（往期列表）
                <View style={[styles.innerContainer, styles.borderTopRadius]}>
                  <View style={[styles.modal_content_top, styles.borderTopRadius]}>
                    <View style={styles.close_modal} />
                    <Text style={{ fontSize: 17, color: '#4A4A4A' }}>夺奖列表</Text>
                    <TouchableOpacity onPress={this.closeModal} activeOpacity={0.65}>
                      <Image source={require('../../images/wm/close_modal.png')} style={styles.close_modal} />
                    </TouchableOpacity>
                  </View>
                  {this.renderFlatlist('manyList')}
                </View> : //查看简介（奖品简介）
                <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
                  <ImageBackground
                    style={{ width: 270, height: 341, position: 'relative', alignItems: 'center' }}
                    source={require('../../images/wm/modal.png')}
                  >
                    <TouchableOpacity  activeOpacity={0.65} style={{ position: 'absolute', top: -35, right: -30 }} onPress={parentItem.serialNum ? () => this.setState({ oprateItem: {} }) : this.closeModal}>
                      <Image
                        source={require('../../images/wm/close_packet_icon.png')}
                        style={{ width: 24, height: 24 }}
                      />
                    </TouchableOpacity>
                    <ImageView
                      source={{ uri: oprateItem.mainPic }}
                      sourceWidth={103}
                      sourceHeight={55}
                      style={{ marginTop: 36 }}
                    />
                    <View style={styles.descriptionView}>
                      <ScrollView >
                        <Text style={{ color: '#222', fontSize: 14, lineHeight: 20, textAlign: oprateItem.description ? 'left' : 'center' }}>{oprateItem.description || '无'}</Text>
                      </ScrollView>
                    </View>
                  </ImageBackground>
                </View>
            }

          </View>
          <ToastModal
            ref={(e) => {
              e && (this.Toast = e);
              this.toast = e;
            }}
            position="center"
          />

        </Modal>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding
  },

  borderTopRadius: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  smallText: {
    color: '#555',
    fontSize: 12,
    marginBottom: 5
  },
  allBut: {
    borderRadius: 12,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    width: 70,
    height: 20,
    alignItems: 'center',
    justifyContent: 'center',
    alignSelf: 'flex-end',
    marginTop: 10
  },
  itemTopView: {
    height: 40,
    justifyContent: 'center',
    paddingHorizontal: 15,
    // borderBottomWidth: 1,
    // borderColor: '#f1f1f1',
    flexDirection: 'row',
    alignItems: 'center',
    position: 'relative',
    justifyContent: 'space-between',
  },
  itemsStyle: {
    width: width - 20,
    overflow: 'hidden',
    paddingVertical: 0,
    marginLeft: 10,
    // marginTop:0,
    // marginBottom:10
  },
  goodsImageView: {
    position: 'relative',
    width: 80,
    height: 80,
    borderWidth: 1,
    borderColor: '#f1f1f1',
    borderRadius: 4,
    overflow: 'hidden',
    marginRight: 15,
    ...CommonStyles.flex_center
  },
  duojiangTag: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    height: 20,
    width: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: CommonStyles.globalHeaderColor
  },
  modal_top: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  innerContainer: {
    height: 486,
    position: 'absolute',
    bottom: 0,
    overflow: 'hidden',
    // backgroundColor: CommonStyles.globalBgColor
  },
  close_modal: {
    width: 16,
    height: 16,
  },
  modal_content_top: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: 50,
    backgroundColor: '#fff',
    width: width,
    paddingHorizontal: 15
  },
  descriptionView: {
    marginTop: 87,
    width: 194,
    height: 110,
    overflow: 'hidden',
  },
  statusWrap: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderTopLeftRadius: 6,
    borderBottomRightRadius: 6,
  },
});

export default connect(
  (state) => ({
    longLists: state.shop.longLists || {},
  }),
  (dispatch) => ({
    dispatch,
    fetchList: (params = {}) => dispatch({ type: "shop/getList", payload: params }),
    shopSave: (params = {}) => dispatch({ type: "shop/save", payload: params }),
  })
)(WMMyPrizeRecordScreen);
