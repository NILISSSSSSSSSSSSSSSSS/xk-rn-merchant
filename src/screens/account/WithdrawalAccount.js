/**
 * 提现
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
    TouchableOpacity,
} from 'react-native'
import ImageView from '../../components/ImageView';
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import moment from 'moment'
import Content from '../../components/ContentItem'
import * as requestApi from '../../config/requestApi';
import TextInputView from '../../components/TextInputView';
import PriceInputView from "../../components/PriceInputView";
const tiaozhuan = require('../../images/indianashopcart/tiaozhuan.png')
import math from '../../config/math';
import * as regular from "../../config/regular";
const { width, height } = Dimensions.get('window')
function getwidth(val) {
    return width * val / 375
}

export default class WithdrawalAccount extends Component {
    constructor(props) {
        super(props)
        const params = this.props.navigation.state.params || {}
        console.log(params)
        this.state = {
            amount: params.amount,
            callback: params.callback,
            cards: null,
            isFirstLoad: false,
            money: '',//提现金额
            poundage: 0,//手续费
            leastAmount: 0,//提现金额区间
            mostAmount: 0,//提现金额区间
            realAmount: 0,// 实际金额
            poundageRate: 0, //手续费比例
        }
    }
    getMerchantWithdrawInfoApp = () => {
        Loading.show()
        requestApi.merchantWithdrawInfoApp().then((data) => {
            this.setState({
                ...(data || {}),
                cards: data && data.cards || null,
                isFirstLoad: true
            })
        }).catch(() => {
            this.setState({
                isFirstLoad: true
            })
        })
    }
    componentDidMount() {
        this.getMerchantWithdrawInfoApp()
    }
    renderBankCard = () => {
        const { cards } = this.state
        return (
            <View style={styles.leftItem}>
                <View style={[styles.topItem, { marginTop: 10 }]}>
                    <ImageView source={{ uri: cards.logo }} style={styles.banklogo} sourceWidth={32} />
                    <View style={{ marginLeft: 9 }}><Text style={{ color: '#222222', fontSize: 14 }}>{cards.bank}</Text></View>
                    <View style={{ marginLeft: 10 }}><Text style={{ color: '#999999', fontSize: 14 }}>{cards.cardType || '借记卡'}</Text></View>
                </View>
                <View style={styles.topItem}>
                    {
                        [1, 2, 3].map((item, index) => {
                            return (
                                <View
                                    style={styles.pointView}
                                    key={index}
                                >
                                    {[1, 2, 3, 4].map((item, index) => {
                                        return (
                                            <View style={styles.point} key={index} />
                                        );
                                    })}
                                </View>
                            );
                        })
                    }

                    <Text style={{ color: '#222222', fontSize: 17, marginLeft: 25 }}>{(cards.cardNo || '').substring(cards.cardNo.length - 4, cards.cardNo.length)}</Text>
                </View>
            </View>
        )
    }
    selectCard = () => {
        this.props.navigation.navigate('Bankcard', {
            callback: (data) => {
                this.setState({
                    cards: {
                        ...data,
                        bankDetail: data.openBank
                    }
                })
                // this.getMerchantWithdrawInfoApp()
            },
            page: 'withdraw'
        })
    }
    inputMoney = (data) => {
        this.setState({ money: data }, () => {
            const { money, mostAmount, leastAmount } = this.state
            if (regular.price(data) &&  parseFloat(data)>=leastAmount  && this.judgeCanWitdrawal('confirm')) {
                requestApi.merchantWithdrawPoundageApp({ amount: parseFloat(math.multiply(data, 100)) }).then((data) => {
                    this.setState({
                        // realAmount:data.poundage,// (2.0.1)
                        ...data  //realAmount 实际金额   poundageRate 手续费比例    poundage 手续费  (2.0.2)

                    })
                }).catch((error)=>{
                    console.log(error)
                })
            } else {
                this.setState({
                    poundage: 0,
                    realAmount: 0
                })
            }
        })


    }
    judgeCanWitdrawal = (confirm) => {
        const { amount, money, poundage, cards = {}, realAmount, mostAmount, leastAmount } = this.state
        console.log('lllll',cards,mostAmount, leastAmount)
        if (!cards) {
            confirm && Toast.show('请添加银行卡信息')
            return false

        } else if (!regular.price(money) || parseFloat(money) == 0) {
            confirm && Toast.show('请输入正确的金额格式且提现金额不能为0')
            return false
        }
        else if (parseFloat(money) > mostAmount || parseFloat(money) < leastAmount) {
            confirm && Toast.show(`提现金额只能在${leastAmount}和${mostAmount}之间`)
            return false
        }
        else {
            return true
        }
    }
    confirm = () => {
        const { amount, money, poundage, cards = {}, realAmount, mostAmount, leastAmount } = this.state
        if (this.judgeCanWitdrawal('confirm')) {
            Loading.show()
            const params = {
                "realName": cards.realName,
                "amount": math.multiply(money, 100),
                "bank": cards.bank,
                "bankDetail": cards.bankDetail,
                "cardNo": cards.cardNo,
                "rightPublic": cards.rightPublic,
                "bankNo": cards.bankNo
            }
            requestApi.merchantWithdrawApply(params).then(() => {
                this.state.callback && this.state.callback()
                this.props.navigation.replace('TransferSuccess', { page: 'withdraw', title: '提现申请提交成功', payFailed: false })
            }).catch(err => {
                console.log(err)
            });
        }

    }
    render() {
        const { navigation } = this.props
        const { cards, amount, money, poundage, isFirstLoad, realAmount, leastAmount,poundageRate } = this.state
        console.log(leastAmount)
        return (
            <View style={styles.container} >
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'提现'}
                />
                <ScrollView showsVerticalScrollIndicator={false}>
                    <TouchableOpacity style={styles.bankItem} onPress={this.selectCard}>
                        {
                            cards ? this.renderBankCard() : <Text style={{ fontSize: 14, color: '#999' }}>{isFirstLoad ? '请先添加银行卡信息' : ''}</Text>
                        }
                        <Image source={tiaozhuan} />
                    </TouchableOpacity>
                    {/* v2.0.2 */}
                    <View style={styles.bottomItem}>
                    <View style={{ paddingHorizontal: 15 }}>
                        <View style={{ marginTop: 15 }}><Text style={styles.btntitle}>可提现金额：{amount}元</Text></View>
                        <View style={styles.inputView}>
                            <Text style={styles.jinesty}>￥</Text>
                            <PriceInputView
                                style={[styles.input,money.toString() ? {fontSize:40 }:{fontSize:14,paddingTop:14}]}
                                inputView={{flex:1,height:40}}
                                placeholder={'请输入提现金额，最低提现金额'+leastAmount+'元'}
                                onChangeText={(data)=>{this.inputMoney(data)}}
                                value={money.toString()}
                            />
                            {
                                parseFloat(money) >parseFloat(amount) &&
                                <Text style={styles.wrongInput}>余额不足</Text>
                            }

                        </View>
                    </View>
                    <View style={styles.tixianbtn}>
                        <Text style={{ color: '#777777', fontSize: 14 }}>手续费({math.multiply(parseFloat(poundageRate),100)}%){poundage}元，将实际转账{realAmount}元</Text>
                    </View>
                </View>
                    {/* v2.0.1 */}
                    {/* <View style={styles.bottomItem}>
                        <View style={{ paddingHorizontal: 15 }}>
                            <View style={{ marginTop: 15 }}><Text style={styles.btntitle}>提现金额</Text></View>
                            <View style={styles.inputView}>
                                <Text style={styles.jinesty}>￥</Text>
                                <PriceInputView style={[styles.input]} inputView={{ flex: 1, height: 40 }} onChangeText={(data) => { this.inputMoney(data) }} value={money.toString()} />
                            </View>


                        </View>
                        <TouchableOpacity style={styles.tixianbtn}>
                            <Text style={{ color: '#777777', fontSize: 14,flex:1 }}>可用余额{parseFloat(amount)}元，实际到账{realAmount}元</Text>
                            <TouchableOpacity onPress={() => this.inputMoney(parseFloat(amount))}>
                                <Text style={{ color: '#4A90FA', fontSize: 14 }}>全部提现</Text>
                            </TouchableOpacity>

                        </TouchableOpacity>
                    </View> */}


                    <TouchableOpacity style={[styles.savebtn, (!this.judgeCanWitdrawal() && { backgroundColor: '#CCCCCC' })]} onPress={() => this.confirm()}>
                        <Text style={{ color: '#FFFFFF', fontSize: 17 }}>确定提现</Text>
                    </TouchableOpacity>
                </ScrollView>





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
    bankItem: {
        width: getwidth(355),
        height: 94,
        flexDirection: 'row',
        justifyContent: 'space-between',
        backgroundColor: '#fff',
        paddingHorizontal: 15,
        paddingVertical: 10,
        alignItems: 'center',
        marginTop: 12,
        borderRadius: 6
    },
    bottomItem: {
        width: getwidth(355),
        backgroundColor: '#fff',
        marginTop: 10,
        borderRadius: 6
    },
    leftItem: {
        flex: 1,
        height: 94
    },
    banklogo: {
        width: 32,
        height: 32,
    },
    line: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    topItem: {
        flex: 1,
        height: 37,
        flexDirection: 'row',
        alignItems: 'center',
    },
    rightImg: {
        width: getwidth(44),
        height: getwidth(44),
        justifyContent: 'center',
        alignItems: 'flex-end',
    },
    point: {
        width: 6,
        height: 6,
        borderRadius: 6,
        backgroundColor: '#CCCCCC',
        marginLeft: 5
    },
    pointView: {
        flexDirection: 'row',
        marginLeft: 25
    },
    btntitle: {
        color: '#777777',
        fontSize: 14
    },
    jinesty: {
        color: '#222',
        fontSize: 30,
        fontWeight: 'bold'
    },
    wrongInput: {
        color: CommonStyles.globalRedColor,
        fontSize: 13
    },
    inputView: {
        flexDirection: 'row',
        marginTop: 10,
        alignItems: 'flex-end'
    },
    input: {
        flex: 1,
        color: '#222'
    },
    tixianbtn: {
        width: getwidth(355),
        height: 44,
        flexDirection: 'row',
        alignItems: 'center',
        borderTopColor: '#eee',
        borderTopWidth: 1,
        justifyContent: 'space-between',
        paddingHorizontal: 15,
        marginTop: 6
    },
    savebtn: {
        width: getwidth(355),
        height: 44,
        borderRadius: 8,
        backgroundColor: '#4A90FA',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 19
    }
})
