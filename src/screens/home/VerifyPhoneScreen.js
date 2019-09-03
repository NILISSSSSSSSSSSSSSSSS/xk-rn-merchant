/**
 * 验证商户手机号,解绑骑手
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
    Keyboard,
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import TextInputView from '../../components/TextInputView';
import CheckButton from '../../components/CheckButton';

const { width, height } = Dimensions.get('window');

export default class VerifyPhoneScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const params=props.navigation.state.params|| {}
        // console.log(params)
        this.state = {
            phone: params.phone || '',
            code: '',
            codeRequest:params.codeRequest || requestApi.sendAuthMessage,
            editable:params.editable===false ?false : true,
            onConfirm:params.onConfirm || (()=>{}),
            bizType:params.bizType,
            callback:params.callback || (()=>{})
        }
    }

    componentDidMount() {
    }
    componentWillUnmount=()=>{
        Keyboard.dismiss();
        this.state.callback()
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    confirm = () => {
        Keyboard.dismiss();
        const { code,phone } = this.state
        const { navigation } = this.props
        if (phone === '') {
            Toast.show('请输入手机号码！')
            return
        }
        if (code === '') {
            Toast.show('请输入验证码！')
            return
        }
        if (code.length !== 6) {
            Toast.show('验证码格式不对!')
            return
        }
        this.state.onConfirm(phone,code, navigation)
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
            this.state.codeRequest({ phone, bizType:this.state.bizType }).then(() => {
                this.refs.getCode.sendVerCode()
            }).catch((err)=>{
                    
            });
        }
    }
    // merchantUnBindRider
    render() {
        const { navigation} = this.props;
        const { phone, code, codeFocus,editable } = this.state;
        console.log(editable)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='验证手机'
                />

                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.contentView}
                >
                    <View style={{borderBottomColor: '#f1f1f1',borderBottomWidth: 0.8}}>
                        <TextInputView
                            inputView={[styles.inputView]}
                            inputRef={(e) => { this.phoneInput = e }}
                            style={styles.textInput}
                            value={phone}
                            maxLength={11}
                            editable={editable}
                            keyboardType='numeric'
                            placeholder={'请输入手机号'}
                            placeholderTextColor={'#ccc'}
                            onChangeText={(text) => {
                                this.changeState('phone', text);
                            }}
                            leftIcon={
                                <View style={[CommonStyles.flex_end, {width: 80}]}>
                                    <Text style={{fontSize: 14,color: '#222'}}>手机号码</Text>
                                </View>
                            }
                        />
                    </View>
                    <TextInputView
                        inputView={[styles.inputView, codeFocus && styles.inputView_focus]}
                        inputRef={(e) => { this.codeInput = e }}
                        style={styles.textInput}
                        value={code}
                        maxLength={6}
                        keyboardType='numeric'
                        placeholder={'验证码'}
                        placeholderTextColor={'#ccc'}
                        onChangeText={(text) => {
                            this.changeState('code', text);
                        }}
                        leftIcon={
                            <View style={[CommonStyles.flex_end, {width: 80}]}>
                                <Text style={{fontSize: 14,color: '#222'}}>验证码</Text>
                            </View>
                        }
                        rightIcon={
                            <CheckButton
                                ref="getCode"
                                delay={60}
                                styleBtn={styles.rightView}
                                title={styles.code_text}
                                onClick={this._checkBtn}
                            />
                        }
                    />
                </TouchableOpacity>
                <TouchableOpacity
                    style={styles.loginBtn}
                    onPress={() => {
                        this.confirm();
                    }}
                >
                    <Text style={styles.login_text}>确定</Text>
                </TouchableOpacity>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        // backgroundColor: '#fff',
    },
    contentView: {
        margin: 10,
        backgroundColor: '#fff',
        borderRadius: 8,
        paddingHorizontal: 15,
        overflow: 'hidden',
    },
    inputView: {
        flexDirection: 'row',
        width: '100%',
        height: 44,
        // marginTop: 20,
        // borderWidth: 1,
        // borderColor: '#ccc',
        // borderRadius: 100,
        overflow: 'hidden',
    },
    inputView_focus: {
        borderColor: CommonStyles.globalHeaderColor,
    },
    textInput: {
        flex: 1,
        height: '100%',
        paddingLeft: 20,
        paddingVertical: 0,
        fontSize: 14,
        color: '#555',
        backgroundColor: '#fff',
    },
    IconView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    leftView: {
        width: 68,
    },
    imageView: {
        justifyContent: 'center',
        alignItems: 'center',
        width: 66,
        height: '100%',
    },
    leftLine: {
        width: 2,
        height: 24,
        // borderRadius: 100,
        backgroundColor: '#ccc',
    },
    rightView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#fff',
    },
    code_text: {
        fontSize: 14,
        color: CommonStyles.globalHeaderColor,
    },
    loginBtn: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        // width: '100%',
        height: 48,
        marginTop: 30,
        // borderRadius: 100,
        backgroundColor: CommonStyles.globalHeaderColor,
        marginHorizontal: 10,
        borderRadius: 8
    },
    login_text: {
        fontSize: 17,
        color: '#fff',
    },
});
