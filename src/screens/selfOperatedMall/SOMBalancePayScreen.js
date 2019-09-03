/**
 * 自营商城余额支付
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    Platform,
    StatusBar,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    ScrollView,
    BackHandler
} from 'react-native';
import moment from 'moment'
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actions from '../../action/actions';
import  math from "../../config/math.js";
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import TextInputView from '../../components/TextInputView';
import SecurityKeyboard from '../../components/SecurityKeyboard';
import ModalDemo from "../../components/Model";
import { debounce, getDiffTime } from '../../config/utils'

const { width, height } = Dimensions.get('window');

class SOMBalancePayScreen extends Component {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
      };
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
        super(props)
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
            this.setState({
                cashier: props.navigation.getParam('cashier', { amount: 0 }), // 收银台信息
            })
        });
        this.handleDebouncePswVerify = debounce(this.handlePswVerify)
        this.state = {
            payPrice: props.navigation.state.params && props.navigation.state.params.payPrice || 0,
            maxLength: 6,
            password: '',
            orderDetails: {
                amountInfo: {}
            },
            showKeyBoard: false, // 安全键盘
            cashier: props.navigation.getParam('cashier', { amount: 0 }), // 收银台信息
            confimVis1: false, // 退出时候弹窗
            confimVis2: false, // 订单过期弹窗
        }
    }

    componentDidMount() {
        this.textInput && this.textInput.focus();
        this.changeState('showKeyBoard', true)
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload => {
            console.log('balancePay')
            BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        });
    }
    handleBackPress = () => {
        console.log('SOMBALANCE')
        let cashier = this.props.navigation.getParam('cashier', {})
        let diffTime = (Date.parse(new Date(moment(cashier.expireTime * 1000))) - Date.parse(new Date())) / 1000;
        if (diffTime > 0) {
            this.setState({
                confimVis1: true,
            })
        } else {
            this.setState({
                confimVis2: true,
            })
        }
        return true
    }
    changeState(key, value, callback = () => { }) {
        this.setState({
            [key]: value
        }, () => {
            callback()
        });
    }

    _getTextInputItem() {
        let { password, maxLength } = this.state;

        let inputItem = [];
        for (let i = 0; i < parseInt(maxLength); i++) {
            inputItem.push(
                <View key={i} style={[styles.textInputItem1, i === 0 ? null : styles.textInputItem2]}>
                    {
                        i < password.length ?
                            <View style={styles.textInputIconStyle}></View> :
                            null
                    }
                </View>
            );
        }
        return inputItem;
    }

    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    // 取消支付
    handleCancePay = () => {
        let payId = this.state.cashier.outTradeNo
        const { navigation } = this.props
        requestApi.mallOrderMUserCancelPay({
            payId,
        }).then(res => {
            navigation.navigate('SOMPayResult', { payFailed: true })
        }).catch(err => {
        })
    }
    // 进行支付密码验证
    handlePswVerify = () => {
        this.changeState('showKeyBoard', false)
        const { password } = this.state
        let cashier = this.props.navigation.getParam('cashier', {})
        // 判断支付是否超时
        let diffTime = (Date.parse(new Date(moment(cashier.expireTime * 1000))) - Date.parse(new Date())) / 1000;
        console.log('diffTime',diffTime)
        if (diffTime < 0) { // 超过 待支付 时间
            Toast.show('已超过待支付时间，请重新下单！')
            navigation.push('SOMPayResult', { payFailed: true});
            return
        }
        requestApi.merchantPayPasswordValidate({
            payPassword: password
        }).then(res => {
            console.log('密码验证结果', res)
            let callback = this.props.navigation.getParam('callback', '')
            callback && callback(password,this.props.navigation)
        }).catch(err => {
            console.log('pswverfi err', err)
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { payPrice, password,confimVis2, maxLength, showKeyBoard, cashier, confimVis1 } = this.state;
        let routerIn = navigation.getParam('routerIn', 'OrderConfirm')
        let diffTime = getDiffTime(moment(cashier.expireTime * 1000));
        console.log('dsaf', diffTime)
        let diffText = `${diffTime.days > 0 ? `${diffTime.days}天`: ''}${diffTime.hours > 0 ? `${diffTime.hours}小时`: ''}${diffTime.min > 0 ? `${diffTime.min}分钟`: ''}${diffTime.sec > 0 ? `${diffTime.sec}秒`: ''}`
        let payTitle = `确认离开收银台吗？若在${diffText}内未完成支付，该订单会被关闭`;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title={'余额支付'}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftItem}
                            onPress={() => {
                                let diffTime = (Date.parse(new Date(moment(cashier.expireTime * 1000))) - Date.parse(new Date())) / 1000;
                                if (diffTime > 0) {
                                    this.setState({
                                        confimVis1: true,
                                    })
                                } else {
                                    this.setState({
                                        confimVis2: true,
                                    })
                                }
                            }}
                        >
                            <Image source={require('../../images/mall/goback.png')} />
                        </TouchableOpacity>
                    }
                />

                <View style={styles.contentView1}>
                    <Text style={styles.content_text1}>输入支付密码</Text>
                </View>
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.contentView2}
                    onPress={() => {
                        // this.textInput.focus();
                        this.changeState('showKeyBoard', true)
                    }}
                >
                    {this._getTextInputItem()}
                </TouchableOpacity>

                <TouchableOpacity
                    style={styles.contentView3}
                    onPress={() => {
                        if (password.trim().length !== maxLength) {
                            Toast.show('请输入正确的支付密码');
                            return
                        }
                        Keyboard.dismiss();
                        Loading.show();
                        this.handleDebouncePswVerify();
                    }}
                >
                    <Text style={styles.content_text2}>支付(¥{(math.divide(cashier.amount , 100)).toFixed(2)})</Text>
                </TouchableOpacity>
                {/* 安全键盘 */}
                <SecurityKeyboard
                    visible={showKeyBoard}
                    disableOkBtn={password.length === 6 ? false : true}
                    onClose={() => { this.changeState('showKeyBoard', false) }}
                    onKeyPress={(text) => {
                        this.changeState('password', text);
                        this.setState({
                            password: text
                        }, () => {
                            if (text.length === 6) {
                                Loading.show();
                                this.handleDebouncePswVerify()
                            }
                        })
                    }}

                />
                {/* 退出时候弹窗 */}
                <ModalDemo
                    noTitle={true}
                    leftBtnText="继续支付"
                    rightBtnText="确定离开"
                    visible={confimVis1}
                    titleStyle={{ lineHeight: 18 }}
                    title={payTitle}
                    type="confirm"
                    onClose={() => {
                        this.changeState("confimVis1", false);
                    }}
                    onConfirm={() => {
                        this.changeState("confimVis1", false);
                        let merchantId = this.props.store.user.userShop.id;
                        this.props.actions.fetchMallCartList({ merchantId });
                        navigation.push('SOMPayResult', { payFailed: true });
                        // this.handleCancePay()
                    }}
                />
                {/* 待支付过期弹窗 */}
                <ModalDemo
                    noTitle={true}
                    visible={confimVis2}
                    titleStyle={{ lineHeight: 18 }}
                    title='该订单已过期，请重新下单'
                    btnText='确认'
                    onConfirm={() => {
                        this.changeState("confimVis2", false);
                        navigation.push('SOMPayResult', { payFailed: true });
                    }}
                />
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerLeftItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 50,
        height: '100%',
    },
    contentView1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        width: width,
        height: 50,
        marginTop: 5,
        paddingHorizontal: 25,
    },
    content_text1: {
        fontSize: 14,
        color: '#777',
    },
    contentView2: {
        flexDirection: 'row',
        width: width - 50,
        height: 50,
        marginHorizontal: 25,
        borderWidth: 1,
        borderColor: '#E5E5E5',
        borderRadius: 6,
        backgroundColor: '#fff',
        // ...CommonStyles.shadowStyle,
    },
    textInputStyle: {
        position: 'absolute',
        width: '100%',
        height: '100%',
    },
    textInputItem1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: '100%',
    },
    textInputItem2: {
        borderLeftWidth: 1,
        borderLeftColor: '#E5E5E5',
    },
    textInputIconStyle: {
        width: 16,
        height: 16,
        borderRadius: 8,
        backgroundColor: '#333',
    },
    contentView3: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width - 20,
        height: 44,
        marginTop: 28,
        marginHorizontal: 10,
        borderRadius: 8,
        backgroundColor: '#4A90FA',
        // ...CommonStyles.shadowStyle,
    },
    content_text2: {
        fontSize: 17,
        color: '#fff',
    },
    pswinput: {
        width: (width - 30) / 6,
    },
});

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMBalancePayScreen);
