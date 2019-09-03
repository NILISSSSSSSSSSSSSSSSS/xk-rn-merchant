/**
 * 设置、修改、重置支付密码验证页面
 */
// 进入验证页面入口： 1.联盟商信息-支付密码 2.收银台支付时未设置密码
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    StatusBar,
    TouchableOpacity,
    Keyboard,
    Platform
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi'
const { width, height } = Dimensions.get("window");
import TextInputView from '../../components/TextInputView';
import CheckButton from '../../components/CheckButton';
import * as regular from '../../config/regular';

class MerchantSetPswValidate extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            phone: this.props.merchantData.phone || '',
            validateValue: '',
        }
    }

    componentDidMount() {
        this.getMerchantData()
    }
    componentWillUnmount() {
    }
    // 如果从联盟商信息进入，store中的商户信息存在，如果其他入口进入，需要获取联盟商信息
    getMerchantData = () => {
        if (this.state.phone !== '') return
        requestApi.merchantHome().then(res => {
            console.log('res',res)
            this.setState({
                phone: res.baseInfo.phone || ''
            })
        }).catch(err => {
            console.log(err)
        });
    }
    //获取验证码
    _checkBtn = () => {
        Keyboard.dismiss();
        if (this.refs.getCode.state.disabled) {
            return;
        }
        const { phone } = this.state;
        if (phone.trim() === '') {
            Toast.show('请输入手机号');
            return
        }
        if (!regular.phone(phone)) {
            Toast.show('请输入正确格式的手机号')
        } else {
            Loading.show();
            requestApi.sendAuthMessage({
                phone,
                bizType: 'VALIDATE',
            }).then(() => this.refs.getCode.sendVerCode())
            .catch((err)=>{
                    
            });
        }
    }
    handleValidate = () => {
        const { navigation } = this.props;
        console.log('this.props',this.props)

        const { validateValue } = this.state
        const goBackRouter = navigation.getParam('goBackRouter', ''); // 需要返回的路由
        let type = this.getSettingType() // 获取当前是 设置 或者 修改 或者 重置 操作
        const { phone } = this.state;
        if (validateValue === '') {
            Toast.show('请输入验证码！')
            return
        }
        requestApi.smsCodeValidate({
            phone,
            code: validateValue,
        }).then(res => {
            console.log(res)
            navigation.navigate('SettingsPayPsw',{goBackRouter,type,callback:navigation.getParam('callback', '')})
        }).catch(err => {
            console.log(err)
        })
    }
    // 获取当前操作类型
    getSettingType = () => {
        const { navigation } = this.props;
        const goBackRouter = navigation.getParam('goBackRouter', ''); // 需要返回的路由
        const  setPayPwdStatus = this.props.setPayPwdStatus
        switch (goBackRouter) {
            case 'MerchantsMessage':
            return setPayPwdStatus.result === 0 ? '设置' : '修改';
            case 'SOMCashier':
            return '设置'
            case 'Bindstore':
            return '设置'
            default: return '设置'
        }
    }
    render() {
        const { navigation } = this.props;
        const { phone } = this.state;
        console.log('merchantData',this.props.merchantData)
        return (
            <View style={styles.containerWrap}>
                <Header
                    goBack={true}
                    navigation={navigation}
                    title={"验证手机"}
                />
                <View style={styles.container}>
                    <View style={[CommonStyles.flex_start,styles.itemWrap,{ borderBottomColor:'#f1f1f1',borderBottomWidth: 1 }]}>
                        <Text style={styles.label}>手机号码</Text>
                        <Text>{ phone }</Text>
                    </View>
                    <View style={[CommonStyles.flex_start,styles.itemWrap]}>
                        <Text style={styles.label}>验证码</Text>
                        <TextInputView
                            placeholder='请输入验证码'
                            inputView={{ flex: 1 }}
                            style={{ lineHeight: 20, height: 20, color: '#777' }}
                            placeholderTextColor={'#ccc'}
                            onChangeText={(data) => {
                                this.setState({validateValue:data})
                            }}
                            maxLength={6}
                            keyboardType='numeric'
                            value={this.state.validateValue}
                        />
                        <CheckButton
                            ref="getCode"
                            onClick={this._checkBtn}
                            delay={60}
                            name='发送验证码'
                            styleBtn={[styles.code, { borderWidth: 0, borderLeftWidth: 1, borderRadius: 0, borderColor: '#F1F1F1' }]}
                            title={{ color: '#4A90FA', fontSize: 12 }}
                        />
                    </View>
                </View>
                <TouchableOpacity style={styles.submitBtn} activeOpacity={0.65} onPress={() => {
                    this.handleValidate()
                }}>
                    <Text style={styles.submitBtnText}>提交</Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    containerWrap: {
        backgroundColor: CommonStyles.globalBgColor,
        flex: 1,
    },
    container: {
        paddingHorizontal: 15,
        margin: 10,
        borderRadius: 8,
        backgroundColor: '#fff'
    },
    itemWrap: {
        paddingVertical: 15,
    },
    label: {
        paddingRight: 15,
        color: '#222',
        fontSize: 14,
        maxWidth: 90,
        width: 80,
        textAlign: 'right',
    },
    code: {
        backgroundColor: '#fff',
        position: 'absolute',
        right: 15,
        top: 15,
        height: 22,
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 1,
        borderColor: '#4A90FA',
        borderRadius: 10
    },
    submitBtn: {
        padding: 11,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 8,
        margin: 10,
    },
    submitBtnText: {
        color: '#fff',
        fontSize: 17,
        textAlign: 'center'
    },
});

export default connect(
    state => ({
        merchantData: state.user.merchantData,
        setPayPwdStatus: state.user.setPayPwdStatus
    })
)(MerchantSetPswValidate);
