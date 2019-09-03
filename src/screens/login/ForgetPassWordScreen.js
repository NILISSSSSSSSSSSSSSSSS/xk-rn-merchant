/**
 * 重置密码
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
    StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import TextInputView from '../../components/TextInputView';
import CheckButton from '../../components/CheckButton';
import { regExpPassWord } from '../../config/utils';

const { width, height } = Dimensions.get('window');

export default class ForgetPassWordScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        this.state = {
            phone: '',
            password: '',
            code: '',
            phoneFocus: false,  // 手机号输入框是否有焦点
            passwordFocus: false,
            codeFocus: false,
        }
    }

    componentDidMount() {
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    confirm = () => {
        Keyboard.dismiss();
        let { phone, password, code } = this.state;

        if (phone.trim() === '' || password.trim() === '' || code.trim() === '') {
            Toast.show('请输入手机号、密码或验证码');
            phone.trim() === '' && this.changeState('phone', '');
            password.trim() === '' && this.changeState('password', '');
            code.trim() === '' && this.changeState('code', '');
            return;
        }
        if (!regular.phone(phone)) {
            Toast.show('请输入正确格式的手机号');
            return;
        }
        if (code.length < 6) {
            Toast.show("验证码长度不正确");
            return;
        }
        // 密码验证
        if (!regExpPassWord(password)) {
            return
        }
        Loading.show()
        requestApi.requestRetrievePwd({ phone, password, code, }).then(()=>{
            Toast.show('修改成功')
            requestApi.storagePhone("save", {phone,password});
            this.props.navigation.goBack()
        }).catch(()=>{
            
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
            requestApi.sendAuthMessage({ phone, bizType: 'MERCHANT_RESET_PASSWORD' }).then(() => {
                this.refs.getCode.sendVerCode()
            }).catch((err)=>{
                 console.log(err)   
            });
        }
    }

    componentWillUnmount() {
        Keyboard.dismiss();
    }

    render() {
        const { navigation, store } = this.props;
        const { phone, password, code, phoneFocus, passwordFocus, codeFocus } = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='忘记密码'
                />
                <StatusBar
                    translucent={true}
                    backgroundColor={"transparent"}
                    barStyle="light-content"
                    networkActivityIndicatorVisible={true}
                    showHideTransition={'fade'}
                />
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.contentView}
                    onPress={() => {
                        phoneFocus && this.phoneInput.blur();
                        passwordFocus && this.passwordInput.blur();
                        codeFocus && this.codeInput.blur();
                    }}
                >
                    <TextInputView
                        inputView={[styles.inputView, phoneFocus && styles.inputView_focus]}
                        inputRef={(e) => { this.phoneInput = e }}
                        style={styles.textInput}
                        value={phone}
                        maxLength={11}
                        keyboardType='numeric'
                        placeholder={'请输入手机号'}
                        placeholderTextColor={'#ccc'}
                        onChangeText={(text) => {
                            this.changeState('phone', text);
                        }}
                        onBlur={() => {
                            this.changeState('phoneFocus', false);
                        }}
                        onFocus={() => {
                            this.changeState('phoneFocus', true);
                        }}
                        leftIcon={
                            <View style={[styles.IconView, styles.leftView]}>
                                <View style={styles.imageView}>
                                    <Image source={require('../../images/user/mobile_gray.png')} />
                                </View>
                                <View style={styles.leftLine}></View>
                            </View>
                        }
                    />
                    <TextInputView
                        inputView={[styles.inputView, codeFocus && styles.inputView_focus]}
                        inputRef={(e) => { this.codeInput = e }}
                        style={styles.textInput}
                        value={code}
                        maxLength={6}
                        keyboardType='numeric'
                        placeholder={'请输入验证码'}
                        placeholderTextColor={'#ccc'}
                        onChangeText={(text) => {
                            this.changeState('code', text);
                        }}
                        onBlur={() => {
                            this.changeState('codeFocus', false);
                        }}
                        onFocus={() => {
                            this.changeState('codeFocus', true);
                        }}
                        leftIcon={
                            <View style={[styles.IconView, styles.leftView]}>
                                <View style={styles.imageView}>
                                    <Image source={require('../../images/user/mobile_code_gray.png')} />
                                </View>
                                <View style={styles.leftLine}></View>
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
                    <TextInputView
                        inputView={[styles.inputView, passwordFocus && styles.inputView_focus]}
                        inputRef={(e) => { this.passwordInput = e }}
                        style={styles.textInput}
                        value={password}
                        placeholder={'请输入新密码'}
                        placeholderTextColor={'#ccc'}
                        secureTextEntry={true}
                        maxLength={20}
                        onChangeText={(text) => {
                            this.changeState('password', text);
                        }}
                        onBlur={() => {
                            this.changeState('passwordFocus', false);
                        }}
                        onFocus={() => {
                            this.changeState('passwordFocus', true);
                        }}
                        leftIcon={
                            <View style={[styles.IconView, styles.leftView]}>
                                <View style={styles.imageView}>
                                    <Image source={require('../../images/user/password_gray.png')} />
                                </View>
                                <View style={styles.leftLine}></View>
                            </View>
                        }
                    />

                    <TouchableOpacity
                        style={styles.loginBtn}
                        onPress={() => {
                            this.confirm();
                        }}
                    >
                        <Text style={styles.login_text}>确定重置</Text>
                    </TouchableOpacity>
                </TouchableOpacity>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: '#fff',
    },
    contentView: {
        flex: 1,
        paddingHorizontal: 36,
    },
    inputView: {
        flexDirection: 'row',
        width: '100%',
        height: 44,
        marginTop: 20,
        borderWidth: 1,
        borderColor: '#ccc',
        borderRadius: 100,
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
        borderRadius: 100,
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
        width: '100%',
        height: 48,
        marginTop: 50,
        borderRadius: 100,
        backgroundColor: CommonStyles.globalHeaderColor,
    },
    login_text: {
        fontSize: 17,
        color: '#fff',
    },
});
