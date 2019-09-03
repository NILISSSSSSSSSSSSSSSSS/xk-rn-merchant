import React, { Component, PureComponent } from 'react'
import { Modal, StyleSheet, Dimensions, View, TouchableOpacity, Text, Image } from 'react-native'
import { withNavigation } from 'react-navigation';
const { width, height } = Dimensions.get('window');
import CommonStyles from '../common/Styles';
import * as requestApi from '../config/requestApi';
import * as customPay from '../config/customPay';
import ModalDemo from "./Model";

class PayModal extends Component {
    static defaultProps = {
        animationType: 'fade',
        transparent: true,
        modalVisible: false,
        payMoney: 0, // 支付金额
        balance: 999999, // 用户余额
        cashier: {}, // 收银台信息
        // onRequestClose: () => { }, // 按物理按键，关闭后回调，注意本属性在 Android 平台上为必填，且会在 modal 处于开启状态时阻止BackHandler事件
        onShowCallBack: () => { }, // 显示时候回调
        onClose: () => { },
        onDismiss: () => { }, // 回调会在 modal 被关闭时调用。
        cancelPay: () => { }, // 取消支付
    }
    state = {
        confimVis: false, // 显示余额不足弹窗

    }
    // shouldComponentUpdate(prevProps, nextProps) {
    // console.log(prevProps)
    // console.log(nextProps)
    // if (prevProps.payMoney === nextProps.payMoney && prevProps.balance === nextProps.balance) {
    //     return false
    // }
    // return true
    // }
    componentDidMount() {

    }
    componentDidMount() {

    }
    // 支付宝支付
    handleSelectAliPay = () => {
        const { cashier } = this.props
        customPay.alipay({
            orderNo: cashier.outTradeNo,
            totalAmount: cashier.amount,
            successCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: false, routerIn: 'OrderConfirm' });
            },
            faildCallBack: () => {
                navigation.replace('SOMPayResult', { payFailed: true, routerIn: 'OrderConfirm' });
            }
        })
    }
    // 微信支付
    handleSelectWeChat = () => {

    }
    // 银行卡支付
    handleSelectBankCard = () => {

    }
    // 余额支付
    handleSelectBalance = () => {

    }
    // 是否设置过支付密码
    getPayPwdStatus = () => {
        Loading.show()
        requestApi.merchantPayPasswordIsSet(res => {
            console.log('获取设置支付密码状态', res)
            this.props.actions.getSetPayPwdStatus(res);
            if (res.result === 0) {
                // 没有设置支付密码显示弹窗
                this.changeState('confimVis', true)
            } else {
                // 设置了则进行下一步
                // navigation.navigate('SOMBalancePay', { payPrice: this.props.payMoney, orderId: res.orderId, routerIn: 'OrderConfirm' });
            }
        });
    };
    changeState(key = '', value = '', callback = () => { }) {
        this.setState({
            [key]: value
        }, () => {
            callback()
        });
    }
    render() {
        const { modalVisible, payMoney, navigation, balance, onShowCallBack, onDismiss, onClose, cancelPay } = this.props
        const { confimVis } = this.state
        const payType = [
            {
                title: '支付宝',
                icon: require('../images/mall/alipay.png'),
                callBack: this.handleSelectAliPay,
            },
            {
                title: '微信',
                icon: require('../images/mall/wechat.png'),
                callBack: this.handleSelectWeChat,
            },
            {
                title: '银行卡',
                icon: require('../images/mall/bank_card.png'),
                callBack: this.handleSelectBankCard,
            },
            {
                title: `晓可币支付(可用晓可币${balance})`,
                icon: require('../images/mall/balance.png'),
                callBack: this.handleSelectBalance,
            }
        ]
        return (
            <React.Fragment>
                <Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={onClose}
                    onShow={onShowCallBack}
                    onDismiss={onDismiss}
                >
                    <View style={styles.modalOutView}>
                        <TouchableOpacity
                            style={styles.modalInnerTopView}
                            activeOpacity={1}
                        >
                        </TouchableOpacity>
                        <View style={styles.modalInnerBottomView}>
                            <View style={styles.modal_titleView}>
                                <View style={styles.modal_titleItem}></View>
                                <Text style={styles.modal_title_text}>选择支付方式</Text>
                                <TouchableOpacity
                                    style={styles.modal_titleItem}
                                    onPress={() => {
                                        cancelPay()
                                    }}
                                >
                                    <Image source={require('../images/mall/close1.png')} />
                                </TouchableOpacity>
                            </View>
                            <View style={[styles.modal_titleView, styles.modalItem1]}>
                                <Text style={styles.modal_text1}>支付金额：¥{payMoney} </Text>
                            </View>
                            {
                                payType.map((item, index) => {
                                    if (index === payType.length - 1) {
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                style={[styles.modal_titleView, styles.modalItem3]}
                                                disabled={balance < payMoney}
                                                onPress={() => {
                                                    if (index === payType.length - 1) {
                                                        if (balance < payMoney) {
                                                            Toast.show('您的余额不足，请充值!')
                                                            return
                                                        } else { }
                                                        item.callBack()
                                                    } else {
                                                        item.callBack()
                                                    }

                                                }}
                                            >
                                                <View style={styles.modalItem2_item}>
                                                    <Image source={item.icon} />
                                                    <Text style={[styles.modal_text2, balance < payMoney ? styles.modal_text3 : null]}>{item.title}</Text>
                                                </View>
                                            </TouchableOpacity>
                                        )
                                    }
                                    return (
                                        <TouchableOpacity
                                            key={index}
                                            style={[styles.modal_titleView, styles.modalItem2]}
                                            onPress={() => {
                                                item.callBack()
                                            }}
                                        >
                                            <View style={styles.modalItem2_item}>
                                                <Image source={item.icon} />
                                                <Text style={styles.modal_text2}>{item.title}</Text>
                                            </View>
                                            <Image source={require('../images/mall/goto_gray.png')} />
                                            {/* {
                                            (tabsIndex === index)
                                                ? <Image source={require('../images/mall/checked.png')} />
                                                : <Image source={require('../images/mall/unchecked.png')} />
                                        } */}
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                    </View>
                </Modal>
                {/* 未设置支付密码弹窗 */}
                <ModalDemo
                    noTitle={true}
                    leftBtnText="取消"
                    rightBtnText="去设置"
                    visible={confimVis}
                    title="您未设置过支付密码，是否立即设置？"
                    type="confirm"
                    onClose={() => {
                        this.changeState("confimVis", false);
                    }}
                    onConfirm={() => {
                        navigation.navigate('PayPswAdd', { goBackRouter: 'SOMOrderConfirm' })
                        this.changeState("confimVis", false);
                    }}
                />
            </React.Fragment>
        )
    }
}


const styles = StyleSheet.create({
    modalOutView: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    modalInnerTopView: {
        width: width,
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, .5)',
    },
    modalInnerBottomView: {
        width: width,
        paddingBottom: CommonStyles.footerPadding,
        backgroundColor: '#fff',
    },
    modal_titleView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
        borderBottomWidth: 1,
        borderBottomColor: '#F1F1F1',
    },
    modal_titleItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 75,
        height: '100%',
    },
    modal_title_text: {
        flex: 1,
        fontSize: 17,
        color: '#000',
        textAlign: 'center',
    },
    modalItem1: {
        height: 70,
    },
    modal_text1: {
        fontSize: 17,
        color: '#EE6161',
    },
    modalItem2: {
        justifyContent: 'space-between',
        paddingHorizontal: 25,
    },
    modalItem2_item: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    modal_text2: {
        fontSize: 14,
        color: '#222',
        marginLeft: 8,
    },
    modalItem3: {
        justifyContent: 'space-between',
        paddingHorizontal: 25,
    },
    modal_text3: {
        color: '#ccc',
    },
})
export default withNavigation(PayModal);
