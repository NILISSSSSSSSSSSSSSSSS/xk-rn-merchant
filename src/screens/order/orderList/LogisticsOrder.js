/**
 * 晓可物流订单
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    Modal
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import ImageView from '../../../components/ImageView'
import Content from "../../../components/ContentItem";
import FlatListView from "../../../components/FlatListView";
import ScrollableTabView from "react-native-scrollable-tab-view";
import ScrollableTabBar from '../../../components/CustomTabBar/ScrollableTabBar'
import * as requestApi from "../../../config/requestApi";
import {
    RIDER_ORDER_STATUS,
} from "../../../const/order";
import { NavigationComponent } from "../../../common/NavigationComponent";

const { width, height } = Dimensions.get("window")
const tabsTitle = [{ name: '全部', index: 0 }, { name: '待接单', index: 1 },{ name: '未接单', index: 2},{ name: '待取货', index: 3 },{ name: '配送中', index: 4 },{ name: '已完成', index: 5 },{ name: '已取消', index: 6 }]
const statusList = ['', 'wait_rider','rider_refuse','wait_pickup','rider_drivering','rider_arraive','order_cancel']
function getwidth(val) {
    return width * val / 375
}
class LogisticsOrder extends NavigationComponent {
    constructor(props){
        super(props)
        let shopId = this.props.shopId;
        this.state = {
            chooseIndexTitle:0,
            shopId
        }
        this.queryParam = {
            shopId: "",
            orderStatus:statusList[0],
            page:1,
            limit:10,
        }
    }
    requestData = (isFirst) => {
        const { chooseIndexTitle,shopId } = this.state
        if(!shopId){
            Toast.show('请先创建店铺')
            return
        }
        if(isFirst){
            Loading.show()
            this.queryParam.page=1
        }else{
            this.queryParam.page+=1
        }
        this.queryParam.orderStatus = statusList[chooseIndexTitle]
        this.queryParam.shopId = shopId;
        this.props.dispatch({type:'order/fetchmerchantOrderQPage',payload:{params:this.queryParam}})
        
    }
    componentWillUnmount() {
        RightTopModal.hide()
    }
    componentDidMount(){
        this.requestData(true)
    }
    toDetail = (item) => {
        const { shopId } = this.state
        const { navigation } = this.props
        navigation.navigate('GoodsTakeOut',{
            page: 'LogisticsOrder',
            orderId:item.goodsOrderNo,
            shopId: shopId,
            orderNo: item.orderNo,
            initData: ()=> this.requestData(true)
        })
    }
    getNameByStatus = (item) => {
        switch(item.orderStatus){
            case 'wait_rider':
            return '等待骑手接单';
            case 'rider_refuse':
            return '骑手拒绝接单'
            case 'wait_pickup':
            return '等待骑手取货'
            case 'rider_drivering':
            return '配送中'
            case 'rider_arraive':
            return '配送完成'
            case 'order_cancel':
            return '派单已取消'
        }
    }
    renderItem = (data) => {
       let item = data.item
       const {chooseIndexTitle} = this.state
       let orderStatus  = statusList[chooseIndexTitle];
        return (
            <TouchableOpacity
            onPress={()=>{
                this.toDetail(item)
            }}
            style={styles.iteview} key={data.index}>
             <Content style={styles.listItem}>
              <View style={styles.topItem}>
              <Text style={styles.c2f14}>订单号：{item.orderNo}</Text>
              <Text style={styles.cbf14}>{this.getNameByStatus(item)}</Text>
              </View>
              <View style={styles.linesty}></View>
              <View style={styles.itemcenter}>
                  <Image source={{uri:item.skuUrl[0] || ''}} style={styles.itemimg}/>
                  <Image source={{uri:item.skuUrl[1] || ''}} style={styles.itemimg}/>
                  <Image source={{uri:item.skuUrl[2] || ''}} style={styles.itemimg}/>
                  <Image source={{uri:item.skuUrl[3] || ''}} style={styles.itemimg}/>
              </View>
              <View style={styles.linesty}></View>
              <View style={styles.bottomItem}>
              <Text style={styles.c9f12}>下单时间：{moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm')}</Text>
              <Text style={styles.c2f12}>指派骑手：{orderStatus === RIDER_ORDER_STATUS.RIDER_REFUSE ? "请重新分配": item.riderName}</Text>
              </View>
            </Content>
            </TouchableOpacity>
        )
    }
    chooseItemTitle = (index) => {
        this.setState({
            chooseIndexTitle:index
        },()=>{
           this.requestData(true)
        })
    }
    renderTabTitle = () => {
        const { chooseIndexTitle } = this.state
        return tabsTitle.map((item, index) => {
            return (
                <View style={styles.tabItemview} key={item.index}>
                    <TouchableOpacity
                        onPress={() => { this.chooseItemTitle(index) }}
                        style={styles.tabTouchItem}>
                        <Text style={styles.cff14}>{item.name}</Text>
                    </TouchableOpacity>
                    {
                        item.index === chooseIndexTitle && (
                            <View style={styles.chooseItem}></View>
                        )
                    }
                </View>
            )
        })
    }
    chooseItem = (item) => {
        this.setState({
            shopId:item.id
        },()=>{
            this.requestData(true)
        })
    }
    showPopover=()=> {
        let options=[...this.props.juniorShops]
        options.map(item=>{
            item.title=item.name
            item.onPress=()=>this.chooseItem(item)
        })
        RightTopModal.show({
           options,
            contentStyle:{top:Platform.OS=='ios'? 40+CommonStyles.headerPadding:40},
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:12}
        })
    }
    renderHeader=()=>{
        const { navigation} = this.props;
        return(
            <Header
            navigation={navigation}
            goBack={true}
            title={'晓可物流订单'}
            rightView={
                <TouchableOpacity
                    onPress={this.showPopover}
                    style={{ width: 50 }}
                >
                    <Text style={{color:'#fff',fontSize:17}}>筛选</Text>
                </TouchableOpacity>

            }
        />

        )
    }
    render(){
        const { navigation, data, wuliuOrderStore } = this.props
        console.log(this.props)
        return (
            <View style={styles.container}>
                {this.renderHeader()}
                <ScrollableTabView
                        initialPage={0}
                        onChangeTab={({ i }) => {
                            this.chooseItemTitle(i)
                        }}
                        renderTabBar={() => (
                            <ScrollableTabBar
                                underlineStyle={styles.underlineStyle}
                                activeTextColor="#fff"
                                inactiveTextColor={"rgba(255,255,255,.5)"}
                                tabBarTextStyle={{fontSize: 14}}
                                tabStyle={styles.topTabView}
                                style={{height:38}}
                            />
                        )}
                    >
                        {
                            tabsTitle.map((item,index)=>{
                                return(
                                        <View key={index} style={{flex:1}} tabLabel={item.name}>
                                            {
                                                data.length>0?
                                                <FlatListView
                                                    data={data}
                                                    renderItem={this.renderItem}
                                                    store={wuliuOrderStore}
                                                    refreshData={()=>{this.requestData(true)}}
                                                    loadMoreData={()=>{this.requestData(false)}}
                                                    style={{ backgroundColor: CommonStyles.globalBgColor,}}
                                                />:
                                                <View style={CommonStyles.flex_center}>
                                                    <Image style={styles.noDataImage} source={require("../../../images/default/no_content.png")}></Image>
                                                    <View>
                                                        <Text style={styles.noDataText}>暂无数据</Text>
                                                    </View>
                                                </View>
                                            }
                                        </View>
                                    )
                            })
                        }
                    </ScrollableTabView>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        // alignItems: 'center',
        // flexDirection: 'column'
    },
    topRight:{
        width:50,
        height:44 + CommonStyles.headerPadding,
        justifyContent:'center',
        alignItems:'flex-start'
    },
    listContent: {
        width: width,
        // alignItems: 'center',
        flex: 1,
    },
    cff14: {
        color: '#FFFFFF',
        fontSize: 14
    },
    cbf14:{
        color:'#4A90FA',
        fontSize:14
    },
    c2f14:{
        color:'#222222',
        fontSize:14
    },
    c9f12:{
        color:'#999999',
        fontSize:12
    },
    c2f12:{
        color:'#222222',
        fontSize:12
    },
    toptabView: {
        width: width,
        height: 38,
        backgroundColor: '#4A90FA',
        flexDirection: 'row',
    },
    tabItemview: {
        width: getwidth(68),
        height: 38,
        // paddingHorizontal: 6,
        alignItems: 'center',
        justifyContent: 'center',
        alignItems: 'center'
    },
    tabTouchItem: {
        height: 36,
        justifyContent: 'center',
        alignItems: 'center'
    },
    chooseItem: {
        width: getwidth(42),
        height: 4,
        marginBottom: 0,
        backgroundColor: '#fff',
        borderTopLeftRadius: 4,
        borderTopRightRadius: 4,
    },
    listItem:{
        width:getwidth(355),
        height:196,
        // backgroundColor:'#fff'
    },
    itemcenter:{
        width:getwidth(355),
        height:98,
        paddingHorizontal:15,
        flexDirection:'row',
        alignItems:'center'
    },
    iteview:{
        width:width,
        height:196,
        // backgroundColor:'#F6F6F6',
        alignItems:'center'
    },
    topItem:{
        width:getwidth(355),
        height:44,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-between',
        paddingHorizontal:15
    },
    bottomItem:{
        width:getwidth(355),
        height:44,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'space-between',
        paddingHorizontal:15
    },
    linesty:{
        width:getwidth(340),
        marginLeft:15,
        borderWidth:0.2,
        borderColor:'#CCC',
        height:0,
    },
    itemimg:{
        width:68,
        height:68,
        marginRight:10
    },
    modalView: {
        width: width,
        height: height,
        backgroundColor: 'rgba(0,0,0,0.5)',
    },
    modalShaixuan: {
        position: 'absolute',
        paddingHorizontal: 15,
        top: 82,
        right: 10,
        backgroundColor: '#fff',
        borderRadius: 8,
        maxHeight: 250
    },
    shaixuanItem: {
        height: 54,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    noDataImage: {
        marginTop: 70,
        marginBottom: 26
    },
    noDataText: {
        fontSize: 14,
        color: "#777"
    },
    topTabView:{
        backgroundColor: "#4A90FA",
        height: 38,
    },
    underlineStyle:{
        backgroundColor: "#fff",
        height: 8,
        borderRadius: 10,
        marginBottom: -6,
    },
})
export default connect(
    (state) => ({
        wuliuOrderStore: state.order.wuliuOrderStore || {},
        data: state.order.wuliuOrderList || [],
        shopId: state.user.userShop.id,
        juniorShops: state.shop.juniorShops || []
    }),
)(LogisticsOrder)
