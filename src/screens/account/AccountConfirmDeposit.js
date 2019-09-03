//财务账户-确认提取保证金
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
    Keyboard
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import * as requestApi from '../../config/requestApi';
const { width, height } = Dimensions.get('window');
import CheckButton from '../../components/CheckButton';
import CommonButton from '../../components/CommonButton';
import * as regular from '../../config/regular';

class AccountConfirmDeposit extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const params = props.navigation.state.params || {}
        this.state = {
            topParams:params,
            code: '',
            phone: global.loginInfo && global.loginInfo.phone || '',
            payPassword: "",
            callback: params && params.callback || (() => { })

        }
    }

    componentDidMount() {

    }

    componentWillUnmount() {
    }
    goSetPassword=()=>{
        CustomAlert.onShow(
            "confirm",
            "您未设置过支付密码，是否立即设置？",
            "提示",
            () => { },
            () => {
                this.props.navigation.navigate('MerchantSetPswValidate',{goBackRouter:'AccountConfirmDeposit',})
            },
            botton1Text = "去设置",
            botton2Text = "取消",

        );
    }
   // 是否设置过支付密码
   getPayPwdStatus = (callback) => {
    let textPwdIsSet = this.props.setPayPwdStatus.result
    if(!textPwdIsSet){ //undefind || 0
        if(textPwdIsSet=== 0){
            this.goSetPassword(callback)
        }else{
            Loading.show()
            console.log('获取设置支付密码状态1')
            requestApi.merchantPayPasswordIsSet().then(res => {
                console.log('获取设置支付密码状态', res)
                this.props.userSave({setPayPwdStatus:res})
                if (res.result === 0) {
                    // 没有设置支付密码
                    this.goSetPassword(callback)
                } else {
                    callback()
                }
            }).catch(err => {
                console.log(err)
            });
        }
    }else{
        callback()
    }
    };
    confirm = () => {
        // console.log(this.state.callback)
        // this.state.callback()
        // this.props.navigation.navigate('AccountDepositSuccess',topParams)
        // return
        const { code, phone, password,topParams } = this.state
        const { navigation } = this.props
        const params = {
            code,
            phone,
            password,
            merchantType:topParams.merchantType
        }
        if (!regular.phone(params.phone)) {
            Toast.show('请输入正确格式的手机号');
        }
        else if (!regular.checkcode(params.code)) {
            Toast.show('请输入正确格式的验证码');
        }
        else if (!password) {
            Toast.show('请输入支付密码')
        }
        else {
            this.getPayPwdStatus(()=>{
                Loading.show()
                let func = requestApi.merchantCashDepositRefund
                func(params).then(data => {
                    this.state.callback()
                    navigation.navigate('AccountDepositSuccess',topParams)

                }).catch(err => {
                    console.log(err)
                });
            })
        }
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
                bizType: 'WITHDRAWAL_CASH_DEPOSIT',
            }).then(() => this.refs.getCode.sendVerCode()) 
            .catch((err)=>{
                    
            });
        }
    }
    render() {
        const { navigation } = this.props;
        let items = [
            { title: '联盟商手机号',  type: 'input', key: 'phone', editable:false},
            { title: '验证码', type: 'input', key: 'code',editable:true },
            { title: '支付密码',type: 'input', key: 'password',editable:true },
        ]
        return (
            <View style={styles.container}>
                <Header
                    title='确认提取'
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        <View style={{ alignItems: 'center' }}>
                                    {
                                        items.map((item, index) => {
                                            return (
                                                    <Content key={index} style={{ height: 50, justifyContent: 'center'  }}>
                                                        <TextInputView
                                                            editable={item.editable}
                                                            placeholder={item.title}
                                                            inputView={{ flex: 1, paddingHorizontal: 15 }}
                                                            style={{ lineHeight: 20, height: 20, color: '#777' }}
                                                            placeholderTextColor={'#ccc'}
                                                            onChangeText={(data) => {this.setState({ [item.key]: data })}}
                                                            maxLength={item.key == 'phone' ? 11 : null}
                                                            secureTextEntry={item.key == 'password' ? true : false}
                                                            value={this.state[item.key]}
                                                        />
                                                        {
                                                            item.key == 'code' ?
                                                                <CheckButton
                                                                    ref="getCode"
                                                                    onClick={this._checkBtn}
                                                                    delay={60}
                                                                    name='发送验证码'
                                                                    styleBtn={[styles.code, { borderWidth: 0, borderLeftWidth: 1, borderRadius: 0, borderColor: '#F1F1F1' }]}
                                                                    title={{ color: '#4A90FA', fontSize: 12 }}
                                                                /> : null
                                                        }
                                                    </Content>
                                            )
                                        })
                                    }

                             </View>
                        <CommonButton title='确认提取' onPress={() => this.confirm()} style={{marginBottom:0}}/>
                        <CommonButton
                            title='暂不提取'
                            style={{backgroundColor:'#fff'}}
                            textStyle={{color:CommonStyles.globalHeaderColor}}
                            onPress={()=>navigation.navigate('FinancialAccount')}
                        />
                    </View>

                </ScrollView>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: 'center',
        paddingBottom: 10
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
    shopName: {
        fontSize: 14,
        color: '#999999',
        width: width - 20,
        textAlign: 'left',
        marginTop: 8,
        marginBottom: 20,
        marginLeft: 10,
        paddingHorizontal:10
    }


});

export default connect(
    (state) => ({
        setPayPwdStatus:state.user.setPayPwdStatus || {}
     }),
    {
        userSave:(payload={})=>({type:'user/save',payload})
    }
)(AccountConfirmDeposit);
