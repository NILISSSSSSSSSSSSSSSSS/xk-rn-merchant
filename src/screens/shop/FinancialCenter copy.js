
/**
 * 财务中心
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    DeviceInfo,
    View,
    Text,
    Button,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
} from 'react-native'
import { connect } from 'rn-dva'
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'
import Content from '../../components/ContentItem';
import FlatListView from '../../components/FlatListView'
import Picker from '../../components/Picker'
import PickerOld from 'react-native-picker-xk'
import { fetchshopOrderDataQPage } from '../../config/requestApi'
const success = require('../../images/caiwu/success.png')
const { width, height } = Dimensions.get('window')
import {  formatPriceStr } from '../../config/utils'
import  math from "../../config/math.js";
import { NavigationComponent } from '../../common/NavigationComponent';
function getwidth(val) {
    return width * val / 375
}
const date = new Date()
const fullYear = date.getFullYear()+10
const fullMonth = date.getMonth() + 1
const fullDay = date.getDate()
const endYear = moment().year(); // 截止年份
const endMonth = moment().month() + 1; // 截止月份

const startYear = moment().subtract(3, 'y').year(); // 开始年份
const startMonth = moment().subtract(3, 'y').month() + 1; // 开始月份
class FinancialCenter extends NavigationComponent {
    constructor(props){
        super(props)
        this.queryParam = {
            shopId:'',
            startTime:'',
            endTime:'',
            page:1,
            limit:10
        }
        this.state = {
            data: [],
            store: {
                refreshing: false,
                loading: false,
                hasMore: true,
                isFirstLoad:true,
            },
            startDate: moment().startOf('day').format('X'),
            endData:moment().endOf('day').format('X'),
            chooseShop:{id:props.userShop.id},
            totalSettlementPrice:0,
            totalOrderMoney:0,
            totalSettlementPrice:0,
            startDatename:moment().format('YYYY-MM-DD'),
            endDataname:moment().format('YYYY-MM-DD')
        }
    }
    requestshopOrderDataQPage = (isFirst) => {
        let {store,startDate,endData,chooseShop} = this.state
        store.refreshing = true
        this.setState({
            store
        })
        if(isFirst){
            this.queryParam.page = 1
            this.queryParam.shopId = chooseShop.id
            this.queryParam.startTime = startDate
            this.queryParam.endTime =endData
            fetchshopOrderDataQPage(this.queryParam).then((res)=>{
                if(res){
                    let data = res.pageable.data
                    store.hasMore = true
                    if(data.length < 10){
                        store.hasMore = false
                    }
                    store.refreshing = false
                    store.loading = false
                    store.isFirstLoad=false
                    this.setState({
                        store,
                        data,
                        totalDivideMoney:res.totalDivideMoney,
                        totalOrderMoney:res.totalOrderMoney,
                        totalSettlementPrice:res.totalSettlementPrice
                    })
                }else{
                    store.refreshing = false
                    store.loading = false
                    store.hasMore = false
                    store.isFirstLoad=false
                    this.setState({
                        store,
                        data:[],
                        totalDivideMoney:0,
                        totalOrderMoney:0,
                        totalSettlementPrice:0
                    })
                }
            }).catch(()=>{
                store.refreshing = false
                store.loading = false
                store.hasMore = false
                store.isFirstLoad=false
                this.setState({
                    store
                })
            })
        }else{
            if(store.hasMore){
                this.queryParam.page += 1
                this.queryParam.shopId = chooseShop.id
                this.queryParam.startTime = startDate
                this.queryParam.endTime =endData
                fetchshopOrderDataQPage(this.queryParam).then((res)=>{
                    if(res){
                        let data = res.pageable.data
                        if(data.length <10){
                            store.hasMore = false
                        }
                        store.refreshing = false
                        store.loading = false
                        let newdata = this.state.data.concat(data)
                        this.setState({
                            data:newdata,
                            store,
                            totalDivideMoney:res.totalDivideMoney,
                            totalOrderMoney:res.totalOrderMoney,
                            totalSettlementPrice:res.totalSettlementPrice
                        })
                    }else{
                        store.refreshing = false
                        store.loading = false
                        store.hasMore = false
                        this.setState({
                            store
                        })
                    }
                }).catch(()=>{
                    store.refreshing = false
                    store.loading = false
                    store.hasMore = false
                    this.setState({
                        store
                    })
                })
            }
        }
    }
    componentDidMount(){
        Loading.show()
        this.requestshopOrderDataQPage(true)
    }
    componentWillUnmount() {
        super.componentWillUnmount()
        PickerOld.hide()
        RightTopModal.hide()
    }
    renderSeparator = () => {
        return <View />
    }
    renderItem = (data) => {
        let item = data.item
        let items=[
            {name:'订单时间',value:moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss')},
            {name:'订单号',value:item.orderId},
            {name:'所属店铺',value:item.shopName},
            {name:'金额',value:formatPriceStr(math.divide(item.orderMoney || 0,100) ),price:true},
            {name:'平台分成',value:formatPriceStr(math.divide(item.divideMoney || 0,100) ),price:true},
            {name:'最终结算',value:formatPriceStr(math.divide(item.settlementPrice || 0,100) ),price:true},
            {name:'状态',value:item.orderStatus == 'COMPLETELY' ? '已完成' : '已关闭'},

        ]
        return (
            <Content style={[styles.listItem,{marginTop:0,marginBottom:10,borderRadius:0}]} key={data.index}>
            {
                items.map((data2,index)=>{
                    return(
                        <View style={index==items.length-1?styles.listItemOneColumn2: styles.listItemOneColumn} key={index}>
                            <Text style={styles.listitemTitle}>{data2.name}：</Text>
                            <Text style={[styles.listitemTitle,{color:data2.name=='金额'?CommonStyles.globalRedColor:data2.name=='状态'?CommonStyles.globalHeaderColor:'#222'}]}>{data2.value}{data2.price?'元':''}</Text>
                        </View>
                    )
                })
            }
            </Content>
        )
    }
    selectTime = (name) => {
        const {startDatename,endDataname}=this.state
        Picker._showDatePicker((data) => {
            this.setState({
                [name]:name=='startDate'? moment(data).format('X'): moment(data + ' 23:59:59').format('X'),
                [name+'name']:data
            })
        // })
        },this._createDateData,moment(name=='startDate'?startDatename:endDataname)._d)
    }
    _createDateData = () => {
        let date = [];
        for (let i = fullYear - 20; i <= fullYear; i++) {
            let month = [];
            for (let j = 1; j < (i === fullYear ? fullMonth + 1 : 13); j++) {
                let day = [];
                let nowDays = 1 // 默认开始的天数为 1 号
                let endDay = (i === fullYear) && (j === fullMonth) ? fullDay : 31 // 如果时间为当前 年 ，当前 月 ，则结束时间为当前 日 ， 否则结束日为 31 天
                if (j === 2) {
                    for (let k = nowDays; k < 29; k++) {
                        day.push(k + '日');
                    }
                    if (i % 4 === 0) {
                        day.push(29 + '日');
                    }
                }
                else if (j in { 1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1 }) {
                    for (let k = nowDays; k <= endDay; k++) {
                        day.push(k + '日');
                    }
                }
                else {
                    for (let k = nowDays; k < endDay; k++) {
                        day.push(k + '日');
                    }
                }
                let _month = {};
                _month[j + '月'] = day;
                month.push(_month);
            }
            let _date = {};
            _date[i + '年'] = month;
            date.push(_date);
        }
        return date;
    }
    // _createDateData = () => {
    //     let date = [];
    //     for (let i = startYear; i <= endYear; i++) {
    //         let month = [];
    //         for(let j = 1; j<=12; j++) {
    //             if (i === startYear && j >= startMonth) {
    //                 month.push(`${j}月`)
    //                 console.log('enenenenenenenen',j)
    //             }
    //             if (i === endYear && j <= endMonth) {
    //                 month.push(`${j}月`)
    //             }
    //             if (i !== startYear && i !== endYear) {
    //                 month.push(`${j}月`)
    //             }

    //         }
    //         let _date = {};
    //         _date[i + '年'] = month;
    //         date.push(_date);
    //     }
    //     console.log('date',date)
    //     return date;
    // }
    showPopover() {
        let options=[]
        options=[{name:'全部',id:''},...this.props.juniorShops]
        options.map(item=>{
            item.title=item.name
            item.onPress=()=>{
                this.setState({
                    chooseShop:{id:item.id}
                },()=>this.requestshopOrderDataQPage(true))
            }
        })
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:10}
        })
    }
    renderHeader=()=>{
        const { navigation } = this.props;
        return(
            <Header
                    navigation={navigation}
                    goBack={true}
                    title={'财务中心'}
                    rightView={
                        <TouchableOpacity
                            style={{ width: 50, height: 44 + CommonStyles.headerPadding, justifyContent: 'center'}}
                            onPress={() => this.showPopover()}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>筛选</Text>
                        </TouchableOpacity>
                    }
                />
        )
    }
    render() {
        const { data, store, totalDivideMoney,totalOrderMoney,totalSettlementPrice,startDatename,endDataname } = this.state
        return (
            <View style={styles.container} >
                {this.renderHeader()}
                <View style={styles.topView}>
                    <View style={styles.topViewItem}>
                        <TouchableOpacity
                            style={styles.beginTime}
                            onPress={() => this.selectTime('startDate')}
                        >
                            <Text style={{ color: '#777777', fontSize: 14 }}>{startDatename ? startDatename : '开始时间'}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={styles.beginTime}
                            onPress={() => this.selectTime('endData')}
                        >
                            <Text style={{ color: '#777777', fontSize: 14 }}>{endDataname ? endDataname : '截止时间'}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={styles.searchBtn}
                            onPress={()=>{
                              this.requestshopOrderDataQPage(true)
                            }}
                        >
                            <Text style={{ color: '#fff', fontSize: 14 }}>查询</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.bottomItem}>
                        <Text style={{ color: '#222222', fontSize: 14, paddingHorizontal: 15 }}>总金额：{
                            formatPriceStr(math.divide(totalOrderMoney || 0,100 ))
                            }（{formatPriceStr(math.divide(totalSettlementPrice || 0,100 ))}元已经结清）</Text>
                    </View>
                </View>

                <FlatListView
                    type='R1_financial_Base'
                    data={data}
                    style={{ flex: 1, backgroundColor: CommonStyles.globalBgColor,marginTop:10 }}
                    renderItem={this.renderItem}
                    store={store}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={()=>{this.requestshopOrderDataQPage(true)}}
                    loadMoreData={()=>{this.requestshopOrderDataQPage(false)}}
                    footerStyle={{  backgroundColor: CommonStyles.globalBgColor,marginBottom:CommonStyles.footerPadding}}
                    ListHeaderComponent={<View />}
                />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    modal: {
        width: width,
        height: height - 44 - CommonStyles.headerPadding,
        marginTop: 44 + CommonStyles.headerPadding,
        alignItems: 'flex-end',
        backgroundColor: 'rgba(0,0,0,0.5)',
        position: 'absolute',
        top: 0,
        left: 0
    },
    modalView: {
        width: 168,
        borderColor: '#DDDDDD',
        borderBottomLeftRadius: 10,
        marginLeft: 25,
        position:'relative',
        backgroundColor: 'white',
        maxHeight: 250,
        overflow:'hidden'
    },
    separator: {
        // borderColor: '#F1F1F1',
        // width: width,
        // height: 0,
        // borderWidth: 0.5
    },
    topView: {
        width: width,
        height: 95,
        backgroundColor: '#fff',
    },
    topViewItem: {
        width: width,
        height: 48,
        flexDirection: 'row',
        justifyContent: 'space-around',
        alignItems: 'center'
    },
    bottomItem: {
        width: width,
        height: 47,
        marginTop: 15
    },
    beginTime: {
        width: getwidth(119),
        height: 30,
        borderRadius: 30,
        backgroundColor: '#FBFBFB',
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: '#F1F1F1',
        borderWidth: 1
    },
    searchBtn: {
        width: getwidth(62),
        height: 30,
        backgroundColor: '#1F75DF',
        borderRadius: 30,
        borderColor: '#4A90FA',
        borderWidth: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    listItem: {
        width: width,
        // height: 249,
        paddingHorizontal: 15,
        alignItems: 'center'
    },
    listItemOneColumn: {
        width: width - 30,
        height: 49,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottomColor: '#D7D7D7',
        borderBottomWidth: 0.5
    },
    listItemOneColumn2: {
        width: width - 30,
        height: 49,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    listitemTitle: {
        color: '#222222',
        fontSize: 14
    },
    jinetxt: {
        color: '#EE6161',
        fontSize: 14
    },
    listStatustxt: {
        color: '#4A90FA',
        fontSize: 14
    }
})


export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
)(FinancialCenter);
