/**
 * 骑手选择(v1.1)
 */
import React, { Component } from 'react'
import { Text, View, StyleSheet, Dimensions, Image, ScrollView, TouchableOpacity } from 'react-native'
import { connect } from 'rn-dva';
import FlatListView from '../../../components/FlatListView';
import Header from '../../../components/Header';
import CommonStyles from '../../../common/Styles';
import { ListItem } from '../../../components/List';
import Button from '../../../components/Button';
import ModalDemo from '../../../components/Model';
import { fetchMerchantCalcPrice } from '../../../config/Apis/order';

const { width, height } = Dimensions.get("window");
const upIcon = require("../../../images/logistics/up.png");
const downIcon = require("../../../images/logistics/down.png");

const getWidth = (dP)=> {
  return dP * width / 375;
}

class ChooseRiderScreen extends Component {
  state = {
    selectedTabIndex: 0,
    pickConfirmVisible: false,
    pickedRider: {}
  }

  componentDidMount() {
      const { fetchRiderPickList } = this.props;
      fetchRiderPickList()
  }
  pickRider(currentPickRider) {
    if(!currentPickRider.isAccessOrder) {
      Toast.show("骑手未开启接单");
      return;
    }
    const { userShop, navigation } = this.props;
    let shopId = userShop.id;
		let { orderId, isGoodsTakeOut } = navigation.state.params || {};
    let param = {
        shopId: shopId,
        goodsOrderNo: orderId,
        xKModule:'shop'
    }
    if(isGoodsTakeOut) {
      Loading.show()
      fetchMerchantCalcPrice(param).then(res=> { 
        currentPickRider.price = res.price;
        this.setState({
            pickedRider: currentPickRider,
            pickConfirmVisible: true
        })
      }).catch(err => {
        console.log(err)
      });
    } else {
      this.setState({
          pickedRider: currentPickRider,
          pickConfirmVisible: true
      })
    }
  }
  renderExtra(currentPickRider) {
    return <View style={CommonStyles.flex_center}>
      { currentPickRider.distance!=undefined ? <Text style={styles.c2f12}>距离你  <Text style={styles.cbf12}>{currentPickRider.distance}m</Text></Text>: null }
      <Text style={styles.c2f12}>当前接单量 <Text style={styles.cbf12}>{currentPickRider.orderNum || 0}</Text></Text>
    </View>
  }
  renderTitle = (item)=> {
    return <View style={[CommonStyles.flex_start, { height: 16, marginBottom: 10 }]}>
      <Text numberOfLines={1} ellipsizeMode="tail" style={[{
          color: '#222222',
          fontSize: 14,
          fontWeight: 'bold'
        }, { maxWidth: getWidth(114) }]}>{item.realName}</Text>
      <Image source={require("../../../images/logistics/auth.png")} style={{ marginLeft: 8, marginRight: 6, width: 16, height: 16}} />
      <Image source={require("../../../images/logistics/health.png")} style={{ width: 16, height: 16 }} />
    </View>
  }
  renderItem = (item, index)=> {
    return <ListItem 
        style={{
          backgroundColor: '#fff',
          marginHorizontal: 10,
          paddingHorizontal: 15,
          borderRadius: 8
        }}
        title={this.renderTitle(item)}
        icon={ item.avatar ? { uri: item.avatar } : require("../../../images/order/head_portrait.png")}
        iconStyle={{ width: 50, height: 50 }}
        subtitle={item.phone}
        subtitleStyle={{
          color: '#999',
          fontSize: 12,
        }}
        extra={this.renderExtra(item)}
        onPress={()=> this.pickRider(item)}
    />
  }

  renderTabTitle(array, index) {
    const { fetchRiderPickList } = this.props;
      return array.map((item, i) => {
        let active = i === index;
        return (
            <View style={[styles.tabItemview]} key={item}>
                <TouchableOpacity
                    onPress={() => { this.setState({ selectedTabIndex: i }, ()=> fetchRiderPickList(["my", "nearby"][i], 1)) }}
                    style={styles.tabTouchItem}>
                    <Text style={[styles.cff14,{ opacity: active ?1 : 0.7}]}>{item}</Text>
                </TouchableOpacity>
                { active ? <View style={styles.chooseItem}></View> : null }
            </View>
        )
    })
  }

  renderUpAndDown(title, isActive = false, asc = false) {
    return <View style={[CommonStyles.flex_center, { flexDirection: 'row'}]}>
        <Text style={[styles.btnTitle, isActive ? { color: '#4A90FA' } : {}]}>{title}</Text>
        <View style={{ width: 9, height: 6, marginLeft: 5 }}>
        {isActive ?  <Image source={asc?upIcon : downIcon} style={{ width: 9, height: 6}} /> : null}
      </View>
    </View>
  }
  renderTabList() {
    const { riderPickList, fetchRiderPickList, navigation } = this.props;
    const { selectedTabIndex, pickConfirmVisible, pickedRider } = this.state;
    const { my, nearby } = riderPickList || {};
    const tabList = [ my, nearby ];
    const type = ["my", "nearby"][selectedTabIndex];
    const { pagination = {}, list = [] } = tabList[selectedTabIndex] || {};
    const { sortParams = "", sortValue = true, } = pagination || {}

    return (<View style={[CommonStyles.flex_start_column, { width, flex: 1 }]}>
            <View style={{ height: 38, width }}>
                <ScrollView
                      ref={(ref) => this.tabScroll = ref}
                      showsHorizontalScrollIndicator={false}
                      style={{ paddingLeft:15, flex:1, width, height: 38, backgroundColor: '#4A90FA', }}
                      contentContainerStyle={{ width, height: 38 }}
                      horizontal
                  >
                      {
                          this.renderTabTitle(["我的骑手", "附近的骑手"], selectedTabIndex)
                      }
                  </ScrollView>
            </View>
            <View style={[ CommonStyles.flex_around, {height: 44, backgroundColor: '#fff', width }]}>
                <Button titleStyle={sortParams === "" ?{ color: '#4A90FA' } : {}} title="综合" type="link" onPress={()=> fetchRiderPickList(type, 1, 10, "") }  />
                { selectedTabIndex===0? null: <Button type="link" onPress={()=> fetchRiderPickList(type, 1, 10, "distanceAsc", !sortValue)}>
                  { this.renderUpAndDown("距离", sortParams ==="distanceAsc", !sortValue)}
                </Button>}
                <Button type="link" onPress={()=> fetchRiderPickList(type, 1, 10, "orderNumAsc", !sortValue)} >
                { this.renderUpAndDown("任务数", sortParams ==="orderNumAsc", !sortValue)}
                </Button>
            </View>
            <View style={{ flex: 1 }}>
              <FlatListView
                    type={ type==="my" ? "Riders_Not_Find" : "Riders_Not_Nearby"}
                    style={{
                        backgroundColor: "#EEEEEE",
                        marginBottom: 10,
                        flex: 1,
                        width: width
                    }}
                    renderItem={({ item }) => this.renderItem(item)}
                    store={pagination}
                    data={pagination.isFirstLoad ? [] : list}
                    numColumns={1}
                    refreshData={()=> fetchRiderPickList(type, 1)}
                    loadMoreData={()=> fetchRiderPickList(type, pagination.page + 1)}
                />
            </View>
            {/* 确认指派骑手 */}
            <ModalDemo
                noTitle={true}
                leftBtnText="取消"
                rightBtnText="确定"
                visible={pickConfirmVisible}
                title={`确定指派给骑手${pickedRider.realName}？`}
                type="confirm"
                onClose={() => {
                    this.setState({ pickConfirmVisible: false });
                }}
                onConfirm={() => {
                    navigation.goBack()
                    this.props.chooseRider(pickedRider);
                    this.setState({ pickConfirmVisible: false });
                }}
            />
    </View>)
  }

  render() {
    return (
      <View style={styles.container}>
        <Header 
            title="选择骑手"
            goBack
            rightView={<Button type="link" onPress={()=> this.props.toSearchRiderPage()} style={{ paddingRight: 16 }}>
              <Image source={require('../../../images/logistics/search.png')} style={{ width: 18, height: 18, tintColor: '#fff' }} />
            </Button>}
        />
        {this.renderTabList()}
      </View>
    )
  }
}

export default connect(state=> ({
    riderPickList: state.order.riderPickList || {},
    userShop: state.user.userShop || {},
}), {
    fetchRiderPickList: (type = "my", page = 1, limit = 10, sortParams= '', sortValue= true)=> ({ type: "order/fetchRiderPickList", payload: { type, page, limit, sortParams, sortValue } }),
    toSearchRiderPage: ()=> ({ type: 'system/navPage', payload: { routeName: "RiderSearch", params: { pageFrom: "ChooseRider" }}}),
    chooseRider: (pickedRider)=> ({ type: "order/changeLogistics", payload: { pickedRider }})
})(ChooseRiderScreen);

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    c2f12: {
      color: '#222',
      fontSize: 12
    },
    cbf12: {
      color: '#4A90FA',
      fontSize: 12
    },
    cff14: {
      color: '#FFFFFF',
      fontSize: 14
  },
  tabItemview: {
      height: 38,
      marginRight:25,
      alignItems: 'center',
      justifyContent: 'center',
      alignItems: 'center',
      flex: 1
  },
  tabTouchItem: {
      height: 36,
      justifyContent: 'center',
      alignItems: 'center'
  },
  chooseItem: {
      width: 45,
      height: 8,
      marginBottom: 0,
      backgroundColor: '#fff',
      borderRadius: 10,
      position:'absolute',
      bottom:-5
  },
  btnTitle: {
    fontSize: 17,
    letterSpacing: -0.41,
    color: "#222"
  }
})