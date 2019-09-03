/**
 * 财务账户/晓可币充值
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    ScrollView,
    Platform,
    TouchableOpacity
} from 'react-native';
import { connect } from 'rn-dva';
import * as nativeApi from "../../config/nativeApi";
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import Content from "../../components/ContentItem";
import * as requestApi from '../../config/requestApi';
import * as customPay from '../../config/customPay';
import CommonButton from '../../components/CommonButton';
import { getProtocolUrl } from '../../config/utils'
import Line from '../../components/Line';
const payChannels={
    xkq:'账户余额',
    xkb:'晓可币',
    swq:'实物券',
    xfq:'消费券',
    xfqs :'店铺消费券',
    alipay:'支付宝',
    wxpay:'微信',
    tfAlipay:'天府银行-支付宝',
    tfWxpay :'天府银行-微信'
}




const { width, height } = Dimensions.get('window');
export default class FinanceChargeScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        let currency = this.props.navigation.getParam('currency', '');
        let title = this.props.navigation.getParam('title', '晓可币充值');
        this.state = {
            number: '',
            payModalVis: false,
            payTypeList: [],
            selectMoneyIndex:0,
            moneyList: [],
            payChannelIndex:0,
            currency,
            title,
            getMoneys:false,
            agreementUri: ''
        }

    }
    componentDidMount () {
        // this.getPayTypeList()
        this.getList()
        this.handleGetProtocolUrl()
        let payTypeList=[
            {name:'微信支付',key:'wxpay',icon:require('../../images/mall/wechat_pay.png')},
            {name:'支付宝支付',key:'alipay',icon:require('../../images/user/alipay.png')},
        ]
        Platform.OS=='ios'?
        payTypeList=[{name:'Apple Pay',key:'applePay',icon:require('../../images/account/apple_payicon.png')}]:null
        this.setState({payTypeList})
    }
    componentWillUnmount() {
        this.chagneState('payModalVis',false)
    }
    // 获取协议
    handleGetProtocolUrl = () => {
        getProtocolUrl('MAM_XKB_RECHARGE_RULE').then(res => {
            this.setState({
                agreementUri: res.url
            })
        }).catch(err => {
            console.log(err)
            // Toast.show("协议请求失败")
        })
    }
    // 获取支付方式列表，获取后需要过滤出支付宝，和微信，如果是内部支付，需要做密码验证
    getPayTypeList = () => {
        let temp = []
        requestApi.xkbPayChannel().then(res => {
            if (res) {
                res.map((item,index) => {
                    if(item.payChannel!='applePay' || (item.payChannel=='applePay' && Platform.OS=='ios')){
                        temp.push({
                            // icon:require('../../images/mall/wechat_pay.png'),
                            title:payChannels[item.payChannel] || 'apple支付',
                            ...item
                        })
                    }
                })
            }
            console.log('支付方式列表',res)
            this.chagneState('payTypeList',temp)
        }).catch(err => {
            console.log(err)
        })
    }
    getList=()=>{ //获取充值列表
        Loading.show()
        requestApi.xkbDenominationQList().then(res => {
            this.setState({
                moneyList:res.denominations,
                getMoneys:true
            })
        }).catch(err => {
            console.log(err)
        })
    }
    // 选择支付
    handleSelectPay = (payType) => {
        if(this.state.moneyList.length>0){
            Loading.show()
            const { number,moneyList,selectMoneyIndex, currency } = this.state
            let param = {
                // amount: moneyList[selectMoneyIndex].amount,
                // amount: 1, // 测试
                payChannel: payType,
                currency,
                xkbId:moneyList[selectMoneyIndex].id
            }
            requestApi.uniPaymentXkbCharge(param).then(res => {
                this.setState({payModalVis:false})
                switch(payType){
                    case 'alipay':this.handleAliPay(res);break;// 支付宝支付
                    case 'wxpay':this.handleWeChatPay(res);break;// 微信支付
                    case 'applePay':this.handleApplePay(res);break;// ios内购
                }
            }).catch(err => {
                console.log(err)
            });
        }else{
            Toast.show(this.state.getMoneys?'面额充值列表为空':'获取面额充值列表失败')
        }


    }
    // ios内购
    handleApplePay=(res)=>{
        console.log('apple支付',res)
        const {moneyList,selectMoneyIndex}=this.state
        nativeApi.applePay({
            ...res.otherParams,
            productId: moneyList[selectMoneyIndex].iosId
        }).then((res)=>{
            console.log('成功',res)
            if(res.status==0){//是真正的成功
                this.props.navigation.replace('TransferSuccess', { payFailed: false,type:'充值' });
            }else if(res.status==1 || res.status==3){ //内购扣了钱，由于网络问题服务器还未进行验证，一般是成功的
                Toast.show('支付成功，请稍后查看验证结果')
                this.props.navigation.replace('TransferSuccess', { payFailed: false ,type:'充值'});
            }else{
                Toast.show(res.msg)
            }
        }).catch((res)=>{
            console.log('失败',res)
            // this.props.navigation.replace('TransferSuccess', { payFailed: true,type:'充值' });
        })
    }
    // 微信支付
    handleWeChatPay = (res) => {
        Loading.show()
        const { navigation } = this.props
        let wx_param = {
            partnerId: res.next.channelPrams.partnerId,
            prepayId: res.next.channelPrams.prepayId,
            nonceStr: res.next.channelPrams.nonceStr,
            timeStamp: res.next.channelPrams.timestamp,
            package: res.next.channelPrams.pack,
            sign: res.next.channelPrams.sign,
        }
        customPay.wechatPay({
            param: wx_param,
            successCallBack: () => {
                navigation.replace('TransferSuccess', { payFailed: false ,type:'充值'});
            },
            faildCallBack: () => {
                navigation.replace('TransferSuccess', { payFailed: true,type:'充值' });
            }
        })
    }
    // 支付宝支付
    handleAliPay = (res) => {
        const { navigation } = this.props
        customPay.alipay({
            param: res.next.channelPrams.aliPayStr,
            successCallBack: () => {
                navigation.replace('TransferSuccess', { payFailed: false,type:'充值' });
            },
            faildCallBack: () => {
                navigation.replace('TransferSuccess', { payFailed: true ,type:'充值'});
            }
        })
    }
    chagneState = (key = '', value='') => {
        this.setState({
            [key]: value
        })
    }
    render() {
        const { navigation } = this.props;
        const { payModalVis, number,selectMoneyIndex,moneyList,payTypeList,payChannelIndex, title, currency  } = this.state
        let unit = currency === "xkr" ?  "元" : "晓可币";
        console.log(payTypeList)
        return (
            <View style={styles.container}>
                <Header
                    title={title}
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView>
                <Content>
                        <Line title='支付方式' point={null}/>
                        <View style={styles.lineView}>
                            {
                                moneyList.map((item,index)=>{
                                    return(
                                        <TouchableOpacity
                                            onPress={()=>this.setState({selectMoneyIndex:index})}
                                            key={index}
                                            style={[styles.item,{
                                                backgroundColor:selectMoneyIndex==index?CommonStyles.globalHeaderColor:'#fff',
                                                borderWidth:selectMoneyIndex==index?0:1,
                                                marginTop:index>2?10:0
                                            }]}
                                        >
                                            <Text style={[styles.commonText,{color:selectMoneyIndex==index?'#fff':'#222'}]}>{item.denomination/100}{unit}</Text>
                                            <Text style={[{color:selectMoneyIndex==index?'#fff':'#999999',marginTop:3,fontSize:12}]}>¥{item.amount/100}</Text>
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                    </Content>
                    <Content>
                        {
                            payTypeList.map((item,index)=>{
                                return(
                                    <TouchableOpacity
                                        onPress={() => {this.setState({payChannelIndex:index})}}
                                        key={index}
                                        style={[styles.actionLine, { justifyContent: 'space-between', width: width - 20, paddingHorizontal: 15 }]}
                                    >
                                        <View style={styles.line}>
                                            <ImageView
                                                source={Platform.OS=='ios'?require('../../images/logo.jpg'):item.icon}
                                                sourceWidth={20}
                                                sourceHeight={20}
                                                style={{ marginRight: 8 }}
                                            />
                                            {
                                                Platform.OS=='ios'?
                                                <View>
                                                    <Text>晓可联盟</Text>
                                                    <Text style={{fontSize:10,color:'#999',marginTop:3}}>app内购项目</Text>
                                                </View>:
                                                <Text>{item.name}</Text>
                                            }
                                        </View>
                                        <ImageView
                                            source={payChannelIndex===index? require("../../images/mall/checked.png"):require("../../images/mall/unchecked.png")}
                                            sourceWidth={14}
                                            sourceHeight={14}
                                        />
                                    </TouchableOpacity>
                                )
                            })
                        }
                    </Content>
                    <TouchableOpacity onPress={()=>navigation.navigate('AgreementDeal',{title:'充值服务协议',uri:this.state.agreementUri})}>
                        <Text style={styles.read}>阅读并同意<Text style={{color:CommonStyles.globalHeaderColor}}>《充值服务协议》</Text></Text>
                    </TouchableOpacity>
                    <CommonButton
                        title='立即充值'
                        onPress={() => {
                            payTypeList[payChannelIndex]?this.handleSelectPay(payTypeList[payChannelIndex].key):Toast.show('获取支付方式失败')
                        }}
                    />
                </ScrollView>

            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
        alignItems: 'center',
        position: 'relative'
    },
    content: {
        alignItems: 'center',
        paddingBottom: 10
    },
    line: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    title: {
        fontSize: 17,
        color: '#222222',
        marginTop: 37,
        marginBottom: 13,
        textAlign: 'center'
    },
    inputView: {
        width: width - 50,
        height: 53,
        borderRadius: 10,
        overflow: 'hidden',
        paddingHorizontal: 15,
        backgroundColor: 'white'
    },
    bottomContent: {
        backgroundColor: '#fff',
        width: width
    },
    actionLine: {
        height: 50,
        textAlign: 'center',
        justifyContent: 'center',
        borderTopWidth: 1,
        borderColor: '#F1F1F1',
        flexDirection: 'row',
        alignItems: 'center'

    },
    actionTitle: {
        fontSize: 17,
        color: '#000000',
        textAlign: 'center'
    },
    container_modal: {
        flex: 1,
        justifyContent: 'center',
        backgroundColor:'rgba(0, 0, 0, 0.5)'
    },
    innerContainer: {
        backgroundColor: '#fff',
        position: 'absolute',
        bottom: 0,
        left: 0,
        width,
    },
    rechargeBtn: {
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 8,
        justifyContent: 'center',
        alignItems: 'center',
        paddingVertical: 10,
        marginTop: 45,
    },
    commonText:{
        fontSize:14,
    },
    lineView:{
        flexDirection:'row',
        alignItems:'center',
        paddingVertical:15,
        justifyContent:'space-between',
        flexWrap:'wrap',
        width:width-50,
        marginLeft:15,
    },
    item:{
        width:(width-50-30)/3,
        height:50,
        alignItems:'center',
        justifyContent:'center',
        borderRadius:6,
        borderColor:'#DCDCDC'
    },
    read:{
        fontSize:14,
        color:'#999',
        marginTop:10,
        width:width-20
    }
});
