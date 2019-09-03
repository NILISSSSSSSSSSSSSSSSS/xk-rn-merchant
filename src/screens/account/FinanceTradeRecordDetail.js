/**
 * 账户财务 交易记录详情
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import moment from 'moment'

import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi'
import  math from "../../config/math.js";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import {  formatPriceStr } from '../../config/utils'
import ImageView from "../../components/ImageView";
import Content from '../../components/ContentItem'
import Line from "../../components/Line";

const { width, height } = Dimensions.get("window");

const xfqSource={ //消费券来源
    'b2c':'自营商城',
    'b2b':'批发商城',
    'jb2c':'福利商城',
    'jb2b':'福利商城',
    'o2o':'商圈',
    'gift':'礼物',
    'redPackets':'红包',
    'xkbCharge':'充值晓可币',
    'RDCard':'推广卡',
    'mj':'加盟费',
    'mqc':'二维码收款',
    'game':'游戏充值',
    'p2b':'商家购买平台商品',
    'activity':'活动',
    'postFee':'物流',
    'lottery':'彩票',
    'jgoodComment':'晒单'
}
export default class FinanceTradeRecordDetail extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        let params=props.navigation.state.params || {}
        console.log(params)
        this.state = {
            id:params.id,
            currency:params.currency || '',
            detailData: params.data || {}
        }
    }

    componentDidMount() {
        this.getDetail()
    }

    componentWillUnmount() {
    }
    getDetail = () => {
        const { id, currency, detailData }=this.state
        console.log(currency)
        let func;
        switch(currency){
            case 'xkb':func=requestApi.userAccXkbBillDetail;break;
            case 'xfq':func=requestApi.userAccXfqBillDetail;break;
            case 'swq':func=requestApi.userAccSwqBillDetail;break;
            case 'xkq':func=requestApi.userAccXkqBillDetail;break;
        }
        if(func){
            func({id}).then((res)=>{
                console.log("晓可币详情",res)
                this.setState({detailData:res})
            }).catch(err => {
                console.log(err)
            });
        }

    }
    goToWmOrderDetail = item => {
        const { navigation } = this.props;
        switch (item.state) {
            case 'NOT_DELIVERY':case 'DELIVERY':case 'NOT_SHARE': //已中奖
                navigation.navigate("WMWinPrizeDetail", {
                    params: item
                });
                break;
            case 'SHARE_LOTTERY':case 'LOSING_LOTTERY':case 'SHARE_AUDIT_ING':case 'WINNING_LOTTERY':case 'SHARE_AUDIT_FAIL': case 'NO_LOTTERY'://已完成
                navigation.navigate("WMOrderCompleteDetail", {
                    params: item
                });
                break;
            default:navigation.navigate("WMOpenPrizeDetail", {
                    params: item
                });break;
        }
    };

    goToOrderDetail=(id)=>{ //跳转订单详情
        const {detailData}=this.state
        let func;
        const isPifa=detailData.tradeProduct=='b2b' || detailData.tradeProduct=='b2b' //批发商城
        const isDuojiang=detailData.tradeProduct=='jb2c' || detailData.tradeProduct=='jb2b' //夺奖派对
        if (isPifa){//批发商城
            func=requestApi.queryMallOrderDetail
        }else if(isDuojiang){ //福利商城
            func=requestApi.qureyWMOrderDetail
        }else{ //商圈订单
            func=requestApi.shopOrderDetail
        }
        console.log(detailData)
        Loading.show()
        func({orderId:id,id}).then((res)=>{
            console.log('//////',res)
            console.log('//////',isDuojiang)
            if(isDuojiang){
                this.goToWmOrderDetail(res)
            }else if(isPifa){
                this.goSomDetails(res)
            }else{
                Toast.show('待完善')
            }
        }).catch(err => {
            console.log(err)
        });
    }
    goSomDetails = (item) => { //跳转批发商城详情
        const { navigation } = this.props
        const { currentTab } = this.state
        let nextData = {}
        switch(item.orderStatus){
            case 'PRE_PAY':nextData={key: 0,status: "等待付款"};break; //	待支付
            case 'PRE_SHIP':nextData={key: 1,status: "等待商家发货"};break;//	待配送
            case 'PRE_RECEVICE':nextData={key: 2,status: "等待买家收货"};break;//	待收货
            case 'PRE_EVALUATE':nextData={key: 3,status: "等待买家评价"};break; //待评价
            case 'COMPLETELY':nextData={key: 4,status: "交易完成"};break;//	已完成
        }
        if(item.goodsInfo && item.goodsInfo.find((itemGood)=>itemGood.refundStatus!='NONE' )){
            nextData = {
                key: 5,status: "退款申请中"
            }
        }
        console.log('nextData',nextData)
        console.log('item',nextData)
        if (nextData.key === 5) {
            // 售后没有详情,判断是进入等待审核页面还是进度页面
            if (item.goodsInfo[0].refundStatus === 'COMPLETE'
            || item.goodsInfo[0].refundStatus === 'REFUNDING'
            || item.goodsInfo[0].refundStatus === 'PRE_REFUND'
            || item.goodsInfo[0].refundStatus === 'PRE_PLAT_RECEIVE')
            {
                navigation.navigate('SOMRefundProcess', {
                    refundId: item.goodsInfo[0].refundId,
                    callback: () => {},
                })
                return
            }
            if (item.goodsInfo[0].refundType === 'REFUND') {
                navigation.navigate('SOMRefundMoney', {
                    refundId: item.goodsInfo[0].refundId,
                    routerIn: 'details'
                })
                return
            }
            if (item.goodsInfo[0].refundType === 'REFUND_GOODS') {
                navigation.navigate('SOMReturnedAllWait', {
                    refundId: item.goodsInfo[0].refundId,
                    callback: () => {},
                    routerIn: 'details'
                })
            }
        } else {
            if (item.orderStatus=='COMPLETELY') {
                navigation.navigate("SOMOrderDetails",{
                    nextData,
                    data: item,
                    callback: () => {},
                });
                return
            }
            navigation.navigate("SOMOrderDetails",{
                nextData,
                data: item,
                callback: () => {},
            });
        }
    }

    // 根据金额类型获取列表
    getDetailList = (currency) => {
        const {detailData}=this.state
        // let numberPrice=formatPriceStr(math.divide(detailData.amount || 0,100))
        let numberPrice=detailData.amount
        let price='¥'+numberPrice
        const isPifa=detailData.tradeProduct=='b2b' || detailData.tradeProduct=='b2b' //批发商城
        const isDuojiang=detailData.tradeProduct=='jb2c' || detailData.tradeProduct=='jb2b' //夺奖派对
        const tixianStatus={
            UNAUDITED:'未审核',
            UNAPPROVED:'未审核通过',
            VERIFIED:'提现中',
            FINISH:'提现成功',
            UN_FINISH:'银行转账失败'
        }
        const commomItems=[
            {name:'时间',value:moment(detailData.updatedAt*1000).format('YYYY-MM-DD HH:mm:ss')},
            {name:'流水号',value:detailData.id},
        ]
        const items=[
            {name:'使用平台',value:xfqSource[detailData.tradeProduct] || ''},
        ]
        const swqItemsIn=[//实物券收入
            ...commomItems,
            {name:'来源',value:isPifa? detailData.tradeName : detailData.tradeName},
            {name:'返还实物券',value:numberPrice},
            // {name:'订单号',value:detailData.orderNo},
        ]
        for (let item of (detailData.orderIds || [])){
            items.push({name:'订单号',value:item})
            swqItemsIn.push({name:'订单号',value:item})
        }
        const xfqIn=[ //消费券收入
            ...commomItems,
            {name:'来源',value:isPifa? detailData.tradeName : detailData.tradeName},
            {name:isPifa?'返还消费券':'赠送消费券',value:numberPrice},
        ]
        if(isPifa){
            for (let item of (detailData.orderIds || [])){
                xfqIn.splice(-1,1,{name:'订单号',value:item})
            }
        }
        let xkbIn=[ //晓可币收入
            ...commomItems,
            {name:'充值晓可币',value: numberPrice},
            {name:'消费金额',value:price,price:true},
        ]
        const xkbOut=[ //晓可币支出
            ...commomItems,
            {name:'转账晓可币',value:numberPrice},
            {name:'收款人账号',value:detailData.receiveUid},
        ]
        const cashOutTixian=[
            ...commomItems,
            {name:'提现金额',value:price,price:true},
            // {name:'收款人',value:detailData.orderNo},
            // {name:'收款银行',value:detailData.t},
            // {name:'银行卡号',value:detailData.orderNo},
            {name:'状态',value:tixianStatus[detailData.advanceAudit]},

        ]//现金提现
        // const cashOutXiaofei=[ //现金商城消费
        //     ...commomItems,
        //     {name:'消费金额',value:price,price:true},
        //     {name:'订单号',value:detailData.orderNo },
        // ]
        // const cashOutCharge=[ //现金晓可币充值
        //     ...commomItems,
        //     {name:'消费金额',value:price,price:true},
        //     {name:'充值数量',value:numberPrice},
        // ]
        const cashInBack=[ //现金收入退返
            ...commomItems,
            {name:'退返金额',value:price,price:true},
            {name:'退返原因',value:detailData.t},
        ]
        const cashInZhubo=[ //现金收入主播代管收入
            ...commomItems,
            {name:'收入金额',value:price},
            {name:'收入类型',value:detailData.t},
            {name:'来源主播',value:detailData.t},
        ]
        // const xkwlInBack=[//小可物流收入/退反
        //     ...commomItems,
        //     {name:'晓可物流退款',value:price,price:true},
        // ]
        const xkwlInCharge=[//小可物流收入/充值
            ...commomItems,
            {name:'充值金额',value:price,price:true},
        ]
        const xkwlOut=[//小可物流支出
            ...commomItems,
            {name:'物流费用',value:price,price:true},
            {name:'配送订单号',value:detailData.orderNo},
        ]
        const xkwlFrozen=[//小可物流冻结记录
            ...commomItems,
            {name:'冻结金额',value:price,price:true},
            {name:'物流单号',value:detailData.orderNo},
        ]
        let newItems=[]
        switch(currency){
            case 'xkq':newItems=detailData.billType== "fi"?cashOutTixian:cashOutTixian;break;//现金
            case 'xkwl':detailData.billStatus=='frozen'?newItems=xkwlFrozen: detailData.billType== "fi"?newItems=xkwlInCharge:newItems=xkwlOut; break;//晓可物流
            case 'xkb': detailData.billType== "fi"?newItems=xkbIn:newItems=xkbOut;break; //晓可币
            case 'xfq': detailData.billType== "fi"?newItems=xfqIn :newItems=[...commomItems,...items,{name:'使用消费券',value:numberPrice}];break;//消费券
            case 'swq':detailData.billType== "fi"? newItems=swqItemsIn:newItems=[...commomItems,...items,{name:'使用实物券',value:numberPrice}];break; //实物券
        }

        return (
            <Content>
                {
                    newItems.map((item,index)=>{
                        return(
                            <Line
                                key={index}
                                title={item.name}
                                value={item.value}
                                // type={(currency=='swq' || currency=='xfq') && item.name=='订单号'?'horizontal':''}
                                // onPress={
                                    // 暂时不做跳转只显示关联的订单号
                                    // (currency=='swq' || currency=='xfq') && item.name=='订单号'?  ()=>this.goToOrderDetail(item.value):null//跳转详情
                                // }
                                point={null}
                                rightValueStyle={{textAlign:'right'}}
                                rightTextStyle={{ color: item.price ?'#EE6161':'#222'}}
                            />
                        )
                    })
                }

            </Content>
        )
    }
    // 进入晓可物流订单
    toWLOrderDetails(item) {
        const { navigation } = this.props;
        // 目前没有传递商品订单号，故无法跳转物流订单详情
        // navigation.navigate('GoodsTakeOut',{
        //     orderNo:item.trackingNumber, // 物流订单号
        //     orderId:item.tradeNo // 商品订单号
        // })
    }

    render() {
        const { navigation} = this.props;
        const {currency,detailData}=this.state
        console.log(currency,detailData)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={currency=='xkwl' && detailData.billStatus=='frozen'?'物流余额冻结详情': (detailData.billType== "fi"?'收入明细':'支出明细')}
                />
                {
                    this.getDetailList(currency)
                }
                {
                    currency=='xkq' && detailData.advanceAudit=='UNAPPROVED'?
                    <View>
                        <Text style={{color:CommonStyles.globalRedColor,marginTop:16,marginLeft:15}}>审核不通过原因</Text>
                        <Content style={{padding:15,marginTop:6}}>
                            <Text>{detailData.advanceAuditError}</Text>
                        </Content>
                    </View>
                    :null
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems:'center'
    },
    ContentView: {
        borderRadius: 8,
        backgroundColor: "#FFFFFF",
        marginHorizontal: 10,
        marginTop: 10
    },
    borderBottom: {
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 1,
    },
    row: {
        paddingHorizontal: 15,
        height: 45,
        justifyContent: 'space-between',
        alignItems: 'center',
        flexDirection: 'row',
    },
    rowLeftText: {
        fontSize: 14,
        color: "#222",
    },
    rowRightText: {
        fontSize: 14,
        color: "#222",
    },
    redText: {
        color: "#EE6161"
    },
    rowRight: {
        justifyContent: 'space-between',
        alignItems: 'center',
        flexDirection: 'row',
    }
});
