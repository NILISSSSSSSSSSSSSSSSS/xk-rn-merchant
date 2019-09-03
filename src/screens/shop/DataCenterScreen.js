/**
 * 数据中心
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Modal,
    Button,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    TouchableHighlight,
    RefreshControl
} from "react-native";
import { connect } from "rn-dva";
import { formatPriceStr } from '../../config/utils'
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import Line from '../../components/Line';
import Content from '../../components/ContentItem'
import moment from 'moment'
import { fetchshopOrderData } from '../../config/requestApi'
const { width, height } = Dimensions.get("window");
import math from "../../config/math.js";
import ScrollableTabView from "react-native-scrollable-tab-view";
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar'
import { NavigationPureComponent } from "../../common/NavigationComponent";
const initData={
    closeNum: 0,
    closeTotalMoney: 0,
    completelyNum: 0,
    completelyTotalMoney: 0,
    closeAveragePrice:0,
    completelyAveragePrice:0,
    completelyUserNum:0,
    closeUserNum:0
}
class DataCenterScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        let data = JSON.parse(JSON.stringify(props.juniorShops))
        data.unshift({
            name: '全部'
        })
        const params = props.navigation.state.params || {}
        console.log(params.eTime)
        this.state = {
            modalVisible: false,
            tabsIndex: 0,  //今日数据，本月数据
            screenIndex: 1,   //选择的店铺数据
            modalData: data,
            resData: {...initData},
            startTime: params.sTime ? '' :moment().startOf('day').format('X'),
            endtTime: params.eTime ? '' : moment().endOf('day').format('X'),
            chooseShop: params.chooseShop || data[1],
            sTime: params.sTime || '',
            eTime: params.eTime || '',
            refreshing:false
        }
    }

    blurState = {
        modalVisible: false,
    }

    handelChangeState = (key, value) => {
        if (key == 'tabsIndex' && value == 1) {
            this.setState({
                startTime:  moment().startOf('month').format('X'),
                endtTime: moment().endOf('month').format('X'),
            }, this.requesetshopOrderData)

        }
        else if (key == 'tabsIndex' && value == 0) {
            this.setState({
                startTime:  moment().startOf('day').format('X'),
                endtTime: moment().endOf('day').format('X'),
            }, this.requesetshopOrderData)
        }
        this.setState({
          [key]: value,
          refreshing:true
         })
    }
    requesetshopOrderData = () => {
        const { startTime, endtTime, chooseShop,resData } = this.state
        let param = {
            startTime: startTime,
            endTime: endtTime,
        }
        if (chooseShop) {
            param.shopId = chooseShop.id
        }
        fetchshopOrderData(param).then((res) => {
            if (res) {
                this.setState({
                    resData: res,
                    refreshing:false
                })
            }else{ //数据为空
              this.setState({
                resData: initData,
                refreshing:false
              })
            }
        }).catch((res) => {
          console.log('error',res)
            this.setState({
                resData: initData,
                refreshing:false
            })
            // Toast.show(res.message)
        })
    }
    componentDidMount() {
      Loading.show()
      this.state.sTime ? this.handleReflashPage(this.props.navigation.state.params || {}) : this.requesetshopOrderData()
    }
    componentWillUnmount(){
        RightTopModal.hide()
    }

    handleReflashPage = (date) => {
        let { sTime, eTime } = date
        this.setState({
            startTime:moment(sTime).format('X'),
            endtTime:eTime?moment(eTime + ' 23:59:59').format('X'):moment().endOf('day').format('X') ,
            sTime,
            eTime
        }, this.requesetshopOrderData)
    }
    handleScreenData = (index, item) => {
        let chooseShop = { id: item.id, name: item.name }
        this.setState({
            screenIndex: index,
            chooseShop,
            modalVisible: false,
        }, this.requesetshopOrderData)
    }

    renderContent = (itemTab, index) => {
        const { resData } = this.state
        console.log(resData)
        const listTitle = [
            { icon: require('../../images/shop/order.png'), title: '订单总量', unit:'单',complete:resData.completelyNum,close: resData.closeNum},
            { icon: require('../../images/shop/turnover.png'), title: '营业额', unit:'元' ,complete:formatPriceStr(math.divide(resData.completelyTotalMoney || 0,100)),close: formatPriceStr(math.divide(resData.closeTotalMoney || 0,100))},
            { icon: require('../../images/shop/customerNumber.png'), title: '客户数量', unit:'人' ,complete:resData.completelyUserNum,close:resData.closeUserNum},
            { icon: require('../../images/shop/junjia.png'), title: '订单均价', unit:'元',complete:formatPriceStr(resData.completelyAveragePrice),close: formatPriceStr(resData.closeAveragePrice)},
        ]

        return (
            <ScrollView
                key={index}
                alwaysBounceVertical={true}
                showsVerticalScrollIndicator={false}
                tabLabel={itemTab}
                refreshControl={(
                  <RefreshControl
                    refreshing={this.state.refreshing}
                    onRefresh={() => this.requesetshopOrderData()}
                  />
                )}
            >
                {
                    listTitle.map((item0, index) => {
                        return (
                            <Content key={index} style={styles.content}>
                                <View style={styles.lineTitleContent}>
                                    <View style={styles.lineTitleWrap}>
                                        <Image style={styles.lineTitleIcon} source={item0.icon} />
                                        <Text style={styles.lineTitleText
                                        }>{item0.title}</Text>
                                    </View>
                                </View>
                                {
                                    [
                                        {title:'已完成',value:item0.complete},
                                        {title:'已关闭',value:item0.close}
                                    ].map((item1, index1) => {
                                        return (
                                            <View key={index1} style={{ alignItems: 'flex-end' }}>
                                                <View style={[styles.itemContentWrap, { borderTopWidth: index1 == 0 ? 0 : 1 }]}>
                                                    <Text style={styles.lineLeftText}>{item1.title}</Text>
                                                    <Text style={styles.lineRightText}>共{item1.value+item0.unit}</Text>
                                                </View>
                                            </View>

                                        )
                                    })
                                }
                            </Content>
                        )
                    })
                }
            </ScrollView>

        )
    }
    showPopover() {
        let options=[]
        options=[{name:'全部',id:''},...this.props.juniorShops]
        options.map((item,index)=>{
            item.title=item.name
            item.onPress=()=>this.handleScreenData(index, item)
        })
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:60}
        })
    }
    renderHeader=()=>{
        const { navigation} = this.props;
        const { chooseShop } = this.state
        return(
            <Header
                navigation={navigation}
                goBack={true}
                centerView={
                    <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#fff' }}>数据中心</Text>
                        {
                            (navigation.state.params || {}).sTime ? null :
                                <TouchableOpacity
                                    onPress={() => this.showPopover()}
                                    style={{ width: 50, position: 'absolute', right: 0, top: 0, }}
                                >
                                    <Text style={{ fontSize: 17, color: '#fff' }}>筛选</Text>
                                </TouchableOpacity>
                        }

                    </View>
                }
                rightView={
                    (navigation.state.params || {}).sTime ? null :
                        <TouchableOpacity
                            onPress={() => {
                                const { sTime, eTime } = this.state
                                navigation.navigate('DataCenterQuery', { sTime, eTime, chooseShop, callback: this.handleReflashPage })
                            }}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>查询</Text>
                        </TouchableOpacity>
                }
            />
        )
    }

    render() {
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
                {this.renderHeader()}
                {
                    (navigation.state.params || {}).sTime ? this.renderContent() :
                        <ScrollableTabView
                            initialPage={0}
                            page={this.state.page}
                            onChangeTab={({ i }) => {
                                this.handelChangeState('tabsIndex', i)
                            }}
                            renderTabBar={() => (
                                <DefaultTabBar
                                    underlineStyle={{
                                        backgroundColor: "#fff",
                                        height: 8,
                                        borderRadius: 10,
                                        marginBottom: -5,
                                        width: "0%",
                                        marginLeft: "17.5%"
                                    }}
                                    activeTextColor="#fff"
                                    inactiveTextColor="rgba(255,255,255,.5)"
                                    tabBarTextStyle={{
                                        fontSize: 14
                                    }}
                                    tabBarTextStyle={{ fontSize: 14 }}
                                    style={{
                                        backgroundColor: "#4A90FA",
                                        height: 44,
                                        borderBottomWidth: 0,
                                        overflow: "hidden",
                                    }}
                                    tabStyle={{
                                        backgroundColor: "#4A90FA",
                                        height: 44,
                                        paddingBottom: -4,
                                    }}
                                />
                            )}
                        >
                            {
                                ['今日数据', '本月数据'].map((itemTab, index) => {
                                    return this.renderContent(itemTab, index)

                                })
                            }
                        </ScrollableTabView>
                }
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    content: {
        marginHorizontal: 10,
        overflow: 'hidden'
    },
    container_view: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        width: 50,
    },
    topTabBtn: {
        height: 38,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        width: '100%',
        backgroundColor: CommonStyles.globalHeaderColor
    },
    topTabBtnItem: {
        width: '50%',
        justifyContent: 'center',
        flexDirection: 'column',
        alignItems: 'center',
        overflow: 'hidden',
    },
    topTabText: {
        width: 130,
        height: 36,
        lineHeight: 36,
        textAlign: 'center',
        color: '#fff'
        // backgroundColor: '#999',
    },
    topTabLine: {
        height: 4,
        width: 130,
        backgroundColor: '#fff',
        borderRadius: 8,
        position: 'relative',
        top: 4,
    },
    topTabLineActive: {
        top: 1,
    },
    headerBtnText: {
        fontSize: 17,
        color: '#fff',
        width: 50
        // paddingRight: 24
    },
    modalView: {
        // flex: 1,
        width: width,
        // height: '100%',
        flexDirection: 'row',
        justifyContent: 'center',
    },
    modalContentWrap: {
        position: 'absolute',
        backgroundColor: '#fff',
        top: 44 + CommonStyles.headerPadding,
        right: 50,
        borderRadius: 8,
        borderWidth: 1,
        borderColor: '#D8D8D8',
        // overflow: 'hidden',
        // height: 240,
        // width: 254,
        // marginLeft: 50,
        // backgroundColor: 'blue'
    },
    modalItemWrap: {
        height: 50,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: '#fff',
        borderTopWidth: 1,
        borderTopColor: 'rgba(0,0,0,0.05)',
    },
    selectBtnWrap: {
        height: 13,
        width: 13,
        padding: 2,
        borderWidth: 1,
        borderColor: '#CCCCCC',
        borderRadius: 13,
    },
    selectActive: {
        flex: 1,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 11,
    },
    lineWrap: {
        paddingLeft: 18,
        paddingRight: 18,
        // height: 47,
    },
    modalItemText: {
        textAlign: 'left',
        maxWidth: 140,
        fontSize: 14,
        color: '#222'
    },
    noTopBorder: {
        borderTopColor: '#fff',
        borderTopWidth: 1
    },
    noMarginTop: {
        marginTop: 0
    },
    lineWrapStyle: {
        paddingLeft: 20,
        paddingRight: 20,
        margin: 10,
        marginTop: 0,
        backgroundColor: '#fff',
        borderRadius: 8,
        overflow: 'hidden'
    },
    lineTitleContent: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 50,
        paddingHorizontal: 15,
        paddingRight: 20,
        borderColor: '#f1f1f1',
        borderBottomWidth: 1
    },
    itemContentWrap: {
        borderTopColor: '#F1F1F1',
        borderTopWidth: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 40,
        width: width - 75
    },
    lineLeftText: {
        fontSize: 14,
        color: '#222',
    },
    lineTitleWrap: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
    },
    lineTitleIcon: {
        height: 30,
        width: 30,
    },
    lineTitleText: {
        paddingLeft: 10,
        fontSize: 14,
        fontWeight: 'bold',
        color: '#222',
    },
    lineRightText: {
        paddingRight: 30,
        fontSize: 14,
        color: '#222',
    },
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
)(DataCenterScreen);
