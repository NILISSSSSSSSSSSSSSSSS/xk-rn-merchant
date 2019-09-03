// 财务账户/晓可物流余额充值
import React, { Component } from 'react';
import { View, Text, StyleSheet, Modal, TouchableOpacity, Dimensions, Keyboard , } from 'react-native';
import { connect } from 'rn-dva';

import TextInputView from '../../components/TextInputView';
import ImageView from '../../components/ImageView';
import * as requestApi from '../../config/requestApi';
import * as customPay from '../../config/customPay';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import { price, inputPrice } from '../../config/regular';
import  math from '../../config/math.js';
import PriceInputView from '../../components/PriceInputView';
import { NavigationComponent } from '../../common/NavigationComponent';
import { BorderLargeRadius } from '../../components/theme/sizes';
import { WhiteColor, TextSecondColor, BorderColor, PrimaryColor, TextThirdColor } from '../../components/theme/colors';
import XKText from '../../components/XKText';
import { RowCenter, RowStart } from '../../components/theme/flex';
import Button from '../../components/Button';

const { width, height } = Dimensions.get('window');

export default class FinanceWLChargeScreen extends NavigationComponent {
    constructor(props) {
        super(props);
        this.state = {
            visible: false,
            amount: '',
            payOrder: {},
        };
    }

    blurState = {
        visible: false,
    }    

    // 获取订单支付方式
    openPayType(payAmount) {
        Keyboard.dismiss();
        if (!payAmount) return;
        if (!price(payAmount)) {
            Toast.show('请输入正确的金额', 2000);
            return;
        }
        requestApi.wlPayChannel({ payAmount: math.multiply(payAmount, 100) }).then(res=>{
            this.setState({
                payOrder: res,
                visible: true,
            });
        }).catch(err => {
            console.log(err);
        });
    }
    // 获取订单签名
    payOrder(channel) {
        const { payOrder = {} } = this.state;
        let { amount = 0 } = payOrder;
        requestApi.uniPayment({
            'body': payOrder.body,
            'prePayChannel': channel.isPreChannel,
            'payChannel': channel.payChannel,
            'payAmount': amount,
            'prePayAmount':'',
            'authType':'',
            'authValue':'',
        }).then(res=>{
            switch (channel.payChannel){
                case 'alipay':
                    this.handleAliPay(res);
                    break;// 支付宝支付
                case 'wxpay':
                    this.handleWeChatPay(res);
                    break;// 微信支付
            }
        }).catch(err => {
            console.log(err);
        });
        this.setState({ visible: false });
    }

    // 微信支付
    handleWeChatPay = (res) => {
        const { navigation } = this.props;
        const params = navigation.state.params || {};
        let wx_param = {
            partnerId: res.next.channelPrams.partnerId,
            prepayId: res.next.channelPrams.prepayId,
            nonceStr: res.next.channelPrams.nonceStr,
            timeStamp: res.next.channelPrams.timestamp,
            package: res.next.channelPrams.pack,
            sign: res.next.channelPrams.sign,
        };
        customPay.wechatPay({
            param: wx_param,
            successCallBack: () => {
                if (params.callback) params.callback();
                navigation.replace('TransferSuccess', { payFailed: false, chargeType: 'xkwl', route: 'FinanceWLCharge', type: '充值', callback: params.callback });
            },
            faildCallBack: () => {
                if (params.callback) params.callback();
                navigation.replace('TransferSuccess', { payFailed: true, chargeType: 'xkwl', route: 'FinanceWLCharge', type: '充值', callback: params.callback  });
            },
        });
    }
    // 支付宝支付
    handleAliPay = (res) => {
        const { navigation } = this.props;
        const params = navigation.state.params || {};
        customPay.alipay({
            param: res.next.channelPrams.aliPayStr,
            successCallBack: () => {
                if (params.callback) params.callback();
                navigation.replace('TransferSuccess', { payFailed: false, chargeType: 'xkwl', route: 'FinanceWLCharge', type: '充值', callback: params.callback });
            },
            faildCallBack: () => {
                if (params.callback) params.callback();
                navigation.replace('TransferSuccess', { payFailed: true, chargeType: 'xkwl', route: 'FinanceWLCharge', type: '充值', callback: params.callback });
            },
        });
    }

    render() {
        const { navigation } = this.props;
        const { payOrder = {} } = this.state;
        let { amount = 0, channelConfigs = [] } = payOrder;
        let payTypes = [
            {name:'微信支付',key:'wxpay',icon:require('../../images/mall/wechat_pay.png')},
            {name:'支付宝支付',key:'alipay',icon:require('../../images/user/alipay.png')},
        ];

        return (
            <TouchableOpacity activeOpacity={0.9} style={styles.container} onPress={()=> this._input && this._input.blur()}>
                <Header
                    title="晓可物流余额充值"
                    navigation={navigation}
                    goBack={true}
                />
                <View style={styles.card}>
                    <View style={styles.titleRow}>
                        <Text style={styles.title}>充值金额</Text>
                    </View>
                    <PriceInputView
                        inputRef={(view)=> this._input = view}
                        value={this.state.amount}
                        leftIcon={<XKText fontFamily="Oswald-Bold" style={{ fontSize: 30 }}>¥</XKText>}
                        onChangeText={(text)=> this.setState({ amount: text })}
                        style={styles.inputViewText}
                        inputView={styles.inputView}
                        placeholder="请输入充值金额"
                    />
                    {/* <Button type="link" style={RowStart}>
                        <Text style={{color: TextThirdColor }}>阅读并同意<Text style={{ color: PrimaryColor }}>《充值服务协议》</Text></Text>
                    </Button> */}
                    <Button type="primary" title="确认充值" style={{ borderRadius: BorderLargeRadius, marginTop: 15 }} onPress={()=> this.openPayType(this.state.amount)} />
                </View>
                <View style={[styles.modalContainer, {
                    top: this.state.visible ? 44 + CommonStyles.headerPadding : height,
                    overflow: 'hidden',
                }]}>
                    <View style={styles.modalContent}>
                        <View style={styles.modalTitleRow}>
                            <Text style={styles.modalTitle}>选择支付方式</Text>
                        </View>
                        <View style={styles.moneyRow}>
                            <Text style={styles.money}>支付金额：¥{math.divide(amount, 100)}</Text>
                        </View>
                        {
                            channelConfigs.filter(conf=> ['wxpay', 'alipay'].indexOf(conf.payChannel) !== -1).map((item,index)=>{
                                let payType = {...item, ...payTypes.find(type=> type.key === item.payChannel)};
                                return (
                                    <TouchableOpacity
                                        onPress={()=> this.payOrder(payType)}
                                        key={index}
                                        style={styles.item}
                                    >
                                        <ImageView
                                            source={payType.icon}
                                            sourceWidth={20}
                                            sourceHeight={20}
                                            style={{ marginRight: 8 }}
                                        />
                                        <Text style={[styles.commonText]}>{payType.name}</Text>
                                        <ImageView
                                            source={require('../../images/account/goto_gray.png')}
                                            sourceWidth={12}
                                            sourceHeight={12}
                                            style={{ marginRight: 8 }}
                                        />
                                    </TouchableOpacity>
                                );
                            })
                        }
                    </View>
                </View>
            </TouchableOpacity>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor,
    },
    hidden: {
        top: height,
    },
    title: {
        color: TextSecondColor,
        fontSize: 14,
    },
    titleRow: {
        marginVertical: 15,
    },
    modalContainer: {
        backgroundColor: 'transparent',
        flexDirection: 'column',
        justifyContent: 'flex-end',
        alignItems: 'center',
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0,
    },
    modalContent: {
        height: 275,
        width,
        backgroundColor: 'white',
    },
    textInputView: {
        marginHorizontal: 15,
    },
    errorText: {
        color: CommonStyles.globalRedColor,
    },
    inputView: {
        height: 60,
        backgroundColor: 'white',
        borderRadius: 6,
        flexDirection: 'row',
        paddingVertical: 15,
        alignItems: 'center',
        borderBottomWidth: 1,
        borderBottomColor: BorderColor,
    },
    inputViewText: {
        color: '#222',
        fontSize: 14,
        textAlignVertical: 'center',
        height: 30,
        lineHeight: 20,
        paddingLeft: 8,
    },
    modalTitle: {
        fontSize: 17,
        color: '#000',
    },
    modalTitleRow: {
        height: 50,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
    },
    money: {
        color: '#EE6161',
        fontSize: 17,
    },
    moneyRow: {
        height: 70,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    item: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
        marginHorizontal: 10,
        paddingHorizontal: 17,
        borderTopColor: '#F1F1F1',
        borderTopWidth: 1,
    },
    commonText: {
        flex: 1,
        color: '#222',
        letterSpacing: 0.13,
        fontSize: 14,
    },
    card: {
        borderRadius: BorderLargeRadius,
        backgroundColor: WhiteColor,
        marginHorizontal: 10,
        paddingHorizontal: 15,
        marginTop: 10,
        paddingBottom: 20,
    },
});
