/**
 * 财务账户
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    Platform,
    ScrollView,
    RefreshControl,
    TouchableOpacity,
} from 'react-native'

import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import Content from '../../components/ContentItem';
import { connect } from "rn-dva";

import * as requestApi from '../../config/requestApi';
import {  formatPriceStr } from '../../config/utils'
import * as scanConfig from "../../config/scanConfig";
import ActionSheet from "../../components/Actionsheet";
const { width, height } = Dimensions.get('window')
import  math from "../../config/math.js";
function getwidth(val) {
    return width * val / 375
}

const BG = require('../../images/account/BG.png')
const xianjin = require('../../images/account/xianjin.png')
const xiaokebi = require('../../images/account/xiaokebi.png')
const singleGoodsXFQ = require('../../images/account/singleGoodsXFQ.png')
const xiaofeiquan = require('../../images/account/xiaofeiquan.png')
const shiwuquan = require('../../images/account/shiwuquan.png')
const bond = require('../../images/account/bond.png')
const moreArrow = require('../../images/account/goto_gray.png')

class FinancialAccount extends Component {
    constructor(props) {
        super(props)
        this.state = {
            userFinanceInfo: {},
            bondList:props.merchant,
            positDetail:[]
             // userAccXkq 晓可券(现金)， userAccXkb 晓可币， userAccXfq 消费券， userAccSwq 实物券
        }
    }
    componentDidMount() {
        Loading.show();
        this._onRefresh()
    }
    _onRefresh=()=>{
        global.refreshFinanceData=this.getUserFinanceInfo
        this.getDetail()
        this.getUserFinanceInfo()
        this.props.getMerchantHome({
            successCallback:(res)=>this.setState({ refreshing: false }),
            failCallback:()=>this.setState({ refreshing: false })
        })
    }
    componentWillUnmount(){
        global.refreshFinanceData=null
    }
    // 获取保证金列表数据
    getDetail=()=>{
        requestApi.merchantCashDepositList().then((res)=>{
            console.log(res)
            this.setState({positDetail:res})
        }).catch(err => {
            console.log(err)
        });
    }
    // 商户App账户账务详情
    getUserFinanceInfo = () => {
        requestApi.shopAppUserAccDetail().then(res => {
            this.changeState('userFinanceInfo', res)
            this.props.userSave({userFinanceInfo:res})
        }).catch(err => {
            console.log(err)
        })
    }
    changeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    toTransactionRecord = (name) => {
        const { navigation } = this.props
        navigation.navigate('TransactionRecord', { title: name })
    }
    toFinance = () => {
        this.ActionSheet.show()
    }
    toFinanceCharge = (params={}) => {
        const { navigation } = this.props
        if(params.currency === "xkr") {
            params.callback = this.getUserFinanceInfo; // 添加回调更新
            navigation.navigate('FinanceWLCharge', params)
        } else {
            navigation.navigate('FinanceCharge', params)
        }
    }
    toBYJFinanceCharge = () => {
        const { navigation } = this.props
        navigation.navigate('FinanceCharge')
    }
    merchanrNextOprate=(data,index)=>{//保证金处理
        if(data.payStatus=='paySuccess'){
            const identityStatuses =  this.props.merchantData.identityStatuses || []
            if(identityStatuses.find(item=>item.auditStatus != 'success' && item.merchantType==data.merchantType)){
                Toast.show('该身份还未审核通过')
                return
            }
            data.callback=this._onRefresh
            CustomAlert.onShow(
                "confirm",
                "提取后该联盟商身份无法正常使用，是否确认提取？提取后，保证金将原路返回",
                "提示",
                () => {this.props.navigation.navigate('FinancialPositDeposit',data) },
                () => {},
                "不提取",
                "确认提取",
            );
        }else{//去缴纳
            // let param = { ...data, page:'register',callback:this.getDetail}
            // param.route='FinancialAccount'
            // this.props.navigation.navigate('PayCashDeposit', param);
        }
    }
    render() {
        const { navigation } = this.props
        const { userFinanceInfo,positDetail } = this.state
        let bondList=JSON.parse(JSON.stringify(this.state.bondList))
        for (let i=0;i<bondList.length;i++) {
            for (let item2 of positDetail) {
                if(item2.merchantType==bondList[i].merchantType){
                    bondList[i].payStatus=item2.payStatus
                }
            }
        }
        console.log(userFinanceInfo)
        return (
            <View style={styles.container} >
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'财务账户'}
                />
                <View style={styles.imgContaner}>
                    <Image source={BG} style={styles.imgsty} />
                </View>
                <ScrollView
                    style={styles.mainContaner}
                    contentContainerStyle={{ alignItems: 'center', paddingBottom: 10 }}
                    showsVerticalScrollIndicator={false}
                    refreshControl={
                        <RefreshControl
                            refreshing={this.state.refreshing}
                            onRefresh={this._onRefresh}
                        />
                    }
                >
                    {/* 现金 */}
                    {
                         userFinanceInfo.userAccXkq && <Content style={[styles.xianjin]}>
                            <View style={styles.itemtop}>
                                <View style={styles.horizontalbox}>
                                    <Image source={xianjin} style={styles.jinetype} />
                                    <Text style={styles.ML6}>现金金额：</Text>
                                </View>
                                <View style={{flexDirection:'row'}}>
                                    {/* <TouchableOpacity style={{marginRight:20}} onPress={() => {
                                        navigation.navigate('Profit',{uri:'settle?nativeBack=yes'})
                                    }}>
                                        <Text style={{ color: '#999999', fontSize: 14 }}>结算记录</Text>
                                    </TouchableOpacity> */}
                                    <TouchableOpacity onPress={() => {
                                        navigation.navigate('FinanceTradeRecord', { currency: 'xkq' })
                                    }}>
                                        <Text style={{ color: '#999999', fontSize: 14 }}>交易记录</Text>
                                    </TouchableOpacity>

                                </View>
                            </View>
                            <View style={styles.itemcenter}>
                                <Text style={{ color: '#EE6161', fontSize: 28,marginTop:Platform.OS=='ios'? 6:0,fontFamily:'Akrobat-Bold' }}>￥
                                {userFinanceInfo.userAccXkq.usable}
                                </Text>
                                <Text style={{ color: '#EE6161', fontSize: 14, opacity: 0.5,fontFamily:'Akrobat-Bold' }}>
                                    { `￥${userFinanceInfo.userAccXkq.foFrozen}(提现中)` }
                                </Text>
                            </View>
                            <View style={styles.itemBottom}>
                                <TouchableOpacity
                                    onPress={() => {
                                        navigation.navigate('WalletAccount', { recordType: 'xkq' })
                                    }}
                                    style={[styles.itemBtn, styles.rightBorder]}><Text style={{ color: '#222222', fontSize: 14 }}>提现记录</Text></TouchableOpacity>
                                <TouchableOpacity style={styles.itemBtn}
                                    onPress={
                                        () => {
                                            navigation.navigate('WithdrawalAccount',{
                                                callback : this.getUserFinanceInfo,
                                                amount: Number(userFinanceInfo.userAccXkq.usable)
                                            })
                                        }
                                    }
                                ><Text style={{ color: '#4A90FA', fontSize: 14 }}>提现</Text></TouchableOpacity>
                            </View>
                        </Content>

                    }

                    {/* 晓可币金额 */}
                    {
                        //  userFinanceInfo.userAccXkb && <Content style={[styles.xianjin2]}>
                        //     <View style={styles.itemtop}>
                        //         <View style={styles.horizontalbox}>
                        //             <Image source={xiaokebi} style={styles.jinetype} />
                        //             <Text style={styles.ML6}>晓可币余额：</Text>
                        //         </View>
                        //         <TouchableOpacity onPress={() => {
                        //             navigation.navigate('FinanceTradeRecord', { currency: 'xkb' })
                        //         }}>
                        //             <Text style={{ color: '#999999', fontSize: 14 }}>交易记录</Text>
                        //         </TouchableOpacity>
                        //     </View>
                        //     <View style={styles.itemcenter}>
                        //         <Text style={{ color: '#EE6161', fontSize: 28,marginTop:Platform.OS=='ios'? 15:0,fontFamily:'Akrobat-Bold' }}>
                        //             { userFinanceInfo.userAccXkb.usable }
                        //         </Text>
                        //     </View>
                        //     <View style={styles.itemBottom}>
                        //         <TouchableOpacity style={[styles.itemBtn, styles.rightBorder]} onPress={this.toFinance}><Text style={{ color: '#222222', fontSize: 14 }}>转账</Text></TouchableOpacity>
                        //         <TouchableOpacity style={styles.itemBtn} onPress={this.toFinanceCharge}><Text style={{ color: '#4A90FA', fontSize: 14 }}>充值</Text></TouchableOpacity>
                        //     </View>
                        // </Content>
                    }

                    {/* 晓可物流余额 */}
                    {
                         userFinanceInfo.merchantAccWls && <Content style={[styles.xianjin]}>
                            <View style={styles.itemtop}>
                                <View style={styles.horizontalbox}>
                                    <Image source={xianjin} style={styles.jinetype} />
                                    <Text style={styles.ML6}>晓可物流余额：</Text>
                                </View>
                                <TouchableOpacity onPress={() => {
                                    navigation.navigate('FinanceTradeRecord', { currency: 'xkwl' })
                                }}
                                >
                                    <Text style={{ color: '#999999', fontSize: 14 }}>交易记录</Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.itemcenter}>
                                <Text style={{ color: '#EE6161', fontSize: 28,marginTop:Platform.OS=='ios'? 6:0,fontFamily:'Akrobat-Bold' }}>￥
                                {userFinanceInfo.merchantAccWls.usable }
                                </Text>
                                <TouchableOpacity onPress={()=>navigation.navigate('FinanceTradeRecord', { currency: 'xkwl' ,billStatus:'frozen',billType:'fo'})}>
                                    <Text style={{ color: '#EE6161', fontSize: 14, opacity: 0.5,fontFamily:'Akrobat-Bold' }}>
                                        { `￥${userFinanceInfo.merchantAccWls.foFrozen}(冻结中)>` }
                                    </Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.itemBottom}>
                                <TouchableOpacity style={styles.itemBtn} onPress={()=>this.toFinanceCharge({ currency: 'xkr', title: "物流余额充值" })}><Text style={{ color: '#4A90FA', fontSize: 14 }}>充值</Text></TouchableOpacity>
                            </View>
                        </Content>
                    }
                    {/* 消费券 */}
                    {
                         userFinanceInfo.userAccXfq && <Content style={[styles.xianjin3]}>
                            <View style={styles.itemtop}>
                                <View style={styles.horizontalbox}>
                                    <Image source={xiaofeiquan} style={styles.jinetype} />
                                    <Text style={styles.ML6}>消费券余额：</Text>
                                </View>
                                <TouchableOpacity onPress={() => {
                                    navigation.navigate('FinanceTradeRecord', { currency: 'xfq' })
                                }}>
                                    <Text style={{ color: '#999999', fontSize: 14 }}>使用记录</Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.itemcenter}>
                                <Text style={{ color: '#4A90FA', fontSize: 12 ,marginTop:Platform.OS=='ios'? 15:0}}>
                                    <Text style={{ color: '#4A90FA', fontSize: 28,fontFamily:'Akrobat-Bold' }}>
                                        {
                                            userFinanceInfo.userAccXfq.usable
                                        }

                                    </Text>
                                </Text>
                            </View>
                        </Content>
                    }

                    {/* 实物券 */}
                    {
                         userFinanceInfo.userAccSwq && <Content style={[styles.xianjin3]}>
                            <View style={styles.itemtop}>
                                <View style={styles.horizontalbox}>
                                    <Image source={shiwuquan} style={styles.jinetype} />
                                    <Text style={styles.ML6}>实物券余额：</Text>
                                </View>
                                <TouchableOpacity onPress={() => {
                                    navigation.navigate('FinanceTradeRecord', { currency: 'swq' })
                                }}>
                                    <Text style={{ color: '#999999', fontSize: 14 }}>使用记录</Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.itemcenter}>
                                <Text style={{ color: '#4A90FA', fontSize: 12,marginTop:Platform.OS=='ios'? 15:0 }}>
                                    <Text style={{ color: '#4A90FA', fontSize: 28 ,fontFamily:'Akrobat-Bold'}}>
                                    {/* {userFinanceInfo.userAccSwq && userFinanceInfo.userAccSwq.usable || 0} */}
                                    {userFinanceInfo.userAccSwq.usable}
                                    </Text>
                                </Text>
                            </View>
                        </Content>
                    }

                    {/* 单品消费券 */}
                    {
                         userFinanceInfo.userAccSwq && <Content style={[styles.xianjin3]}>
                            <View style={styles.itemtop}>
                                <View style={styles.horizontalbox}>
                                    <Image source={singleGoodsXFQ} style={styles.jinetype} />
                                    <Text style={styles.ML6}>单品优惠券：</Text>
                                </View>
                                <TouchableOpacity onPress={() => navigation.navigate('GoodsTickets')}>
                                    <Text style={{ color: '#999999', fontSize: 14 }}>查看优惠券</Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.itemcenter}>
                                <Text style={{ color: '#4A90FA', fontSize: 12,marginTop:Platform.OS=='ios'? 15:0 }}>数量
                                <Text style={{ color: '#4A90FA', fontSize: 28,fontFamily:'Akrobat-Bold' }}>
                                    {userFinanceInfo.coupon || 0}
                                 </Text>
                                </Text>
                            </View>
                        </Content>
                    }

                    {/* bond 保证金 */}
                    <Content style={[styles.xianjin4]}>
                        <View style={styles.itemtop}>
                            <View style={styles.horizontalbox}>
                                <Image source={bond} style={styles.jinetype} />
                                <Text style={styles.ML6}>保证金：</Text>
                            </View>
                        </View>
                        {
                            bondList.map((item, index) => {
                                let noBorderBottom = index === bondList.length - 1 ? { borderBottomWidth: 0 } : {}
                                return(
                                    <TouchableOpacity disabled={item.payStatus=='paySuccess'?false:true} style={[CommonStyles.flex_between, styles.bondListItem, noBorderBottom]} key={index} onPress={()=>this.merchanrNextOprate(item,index)}>
                                        <Text style={{ fontSize: 14, color: '#222' }}>{item.name}</Text>
                                        {
                                            item.payStatus === 'paySuccess'
                                                ? <View style={[CommonStyles.flex_start]}>
                                                    <Text style={{ fontSize: 12, color: '#EE6161', opacity: 0.7 }}>(已缴纳)</Text>
                                                    <Text style={{ fontSize: 12, color: '#EE6161' }}>提取保证金</Text>
                                                    <Image source={moreArrow} />
                                                </View>:
                                                item.payStatus=='freeze'?
                                                 <View style={[CommonStyles.flex_start]}>
                                                    <Text style={{ fontSize: 12, color: '#4A90FA', opacity: 0.7 }}>(已提取，账号冻结中)</Text>
                                                    <Text style={{ fontSize: 12, color: '#4A90FA' }}>去缴纳</Text>
                                                    <Image source={moreArrow} />
                                                </View>:
                                                <View style={[CommonStyles.flex_start]}>
                                                    <Text style={{ fontSize: 12,color:'#999', opacity: 0.7 }}>{ !item.payStatus?'未入驻':item.payStatus=='notPay' ? '未支付':'免保证金'}</Text>
                                                </View>
                                        }
                                        <View style={{width:getwidth(355)-30,height:0,borderColor: '#f1f1f1',borderWidth: 0.5,alignItems:'center',position:'absolute',bottom:0,left:15}}></View>
                                    </TouchableOpacity>
                                )

                            })
                        }
                    </Content>
                </ScrollView>
                <ActionSheet
                        ref={o => (this.ActionSheet = o)}
                        // title={'Which one do you like ?'}
                        options={['扫一扫','出示二维码','账号转账','取消']}
                        cancelButtonIndex={3}
                        // destructiveButtonIndex={2}
                        onPress={index => {
                            switch (index) {
                                case 0:
                                    scanConfig.scan(navigation);
                                    break;
                                case 1:
                                    navigation.navigate("FinanceMakeQrcode",{allMoney: math.multiply(userFinanceInfo.userAccXkb && userFinanceInfo.userAccXkb.usable || 0,100)});
                                    break;
                                case 2:
                                    navigation.navigate("AccountTransfer",{allMoney: math.multiply(userFinanceInfo.userAccXkb &&userFinanceInfo.userAccXkb.usable || 0,100)});
                                    break;
                            }
                        }}
                    />
            </View >
        )
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
    },
    imgsty: {
        width: width,
        height: 136
    },
    imgContaner: {
        width: width,
        height: 136
    },
    mainContaner: {
        position: 'absolute',
        top: 44 + CommonStyles.headerPadding,
        width: width,
        height: height - CommonStyles.headerPadding - 64,
        paddingBottom:CommonStyles.footerPadding
    },
    xianjin: {
        width: getwidth(355),
        height: 164,
        overflow: 'hidden',
    },
    xianjin2: {
        width: getwidth(355),
        height: 144,
        overflow: 'hidden',
    },
    xianjin3: {
        width: getwidth(355),
        height: 95,
    },
    xianjin4: {
        width: getwidth(355),
        // height: 331,
    },
    jinetype: {
        width: getwidth(3),
        height: 12
    },
    itemtop: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: 20,
        paddingHorizontal: 15,
    },
    horizontalbox: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    itemcenter: {
        paddingHorizontal: 10,
    },
    ML6: {
        marginLeft: 6,
        color: '#222222',
        fontSize: 14
    },
    itemBottom: {
        width: getwidth(355),
        marginTop: 20,
        flex: 1,
        borderColor: '#fff',
        borderWidth: 1,
        borderTopColor:'#eee',
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor:'#fff'
    },
    itemBtn: {
        flex: 1,
        alignItems: 'center'
    },
    rightBorder: {
        borderRightColor: '#ddd',
        borderRightWidth: 1
    },
    bondWrap: {
        margin: 10,
        backgroundColor: '#fff'
    },
    bondListItem: {
        paddingLeft: 15,
        paddingBottom: 14,
        paddingTop: 15,
        paddingRight: 19,
    },
})
export default connect(
    state => ({
        merchantData:state.user.merchantData || {},
        merchant:state.user.merchant || []
    }),
    {
        getMerchantHome:(payload={})=>({type:'user/getMerchantHome',payload}),
        userSave:(payload={})=>({type:'user/save',payload})
    }
)(FinancialAccount);
