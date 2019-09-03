/**
 * 注册
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,

    View,
    ScrollView,
    Text,
    Button,
    StatusBar,
    Image,
    TouchableOpacity,
    Keyboard,
    ImageBackground
} from "react-native";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import { getProtocolUrl } from '../../config/utils'
import TextInputView from "../../components/TextInputView";
import CheckButton from "../../components/CheckButton";
import { regExpPassWord } from '../../config/utils';
import { connect } from 'rn-dva'

const ruzhulogo = require('../../images/user/ruzhulogo.png')
const logotxt = require('../../images/user/logotxt.png')
const confirbtn = require('../../images/user/confirbtn.png')
const nochooseIcon = require('../../images/user/nochooseIcon.png')
const chooseIcon = require('../../images/user/chooseIcon.png')
const { width, height } = Dimensions.get("window");

class RegisterScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        let params=this.props.navigation.state.params || {}
        this.state = {
            phone: "",
            password: "",
            code: "",
            phoneFocus: false, // 手机号输入框是否有焦点
            passwordFocus: false,
            codeFocus: false,
            agress:true
        };
    }

    componentDidMount() {
     }
    handleGetProtocolUrl = () => {
        const { navigation } = this.props
        getProtocolUrl('MAM_APP_USER_PROTOCOL').then((res)=> {
            navigation.navigate('AgreementDeal',{title:'用户协议',uri: res.url})
        }).catch(()=> {
            // Toast.show("协议请求失败")
        })

    }
    handleGetConcealPro = () => {
        const { navigation } = this.props
        getProtocolUrl('MAM_PRIVACY_PROTOCOL').then((res)=> {
            navigation.navigate('AgreementDeal',{title:'隐私协议',uri: res.url})
        }).catch(()=> {
            // Toast.show("协议请求失败")
        })
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    _registerClick = () => {
        Keyboard.dismiss();
        let { phone, password, code} = this.state;
        if (
            phone.trim() === "" ||
            password.trim() === "" ||
            code.trim() === ""
        ) {
            Toast.show("请输入手机号、密码或验证码");
            phone.trim() === "" && this.changeState("phone", "");
            password.trim() === "" && this.changeState("password", "");
            code.trim() === "" && this.changeState("code", "");
            return;
        }
        if (!regular.phone(phone)) {
            Toast.show("请输入正确的手机号");
            return;
        }
        // 密码验证
        if (!regExpPassWord(password)) {
            return
        }
        Loading.show()
        let params={ phone, password,code };
        this.props.fetchRegister(params)

    };

    //获取验证码
    _checkBtn = () => {
        Keyboard.dismiss();
        if (this.refs.getCode.state.disabled) {
            return;
        }
        const { phone } = this.state;
        if (phone.trim() === "") {
            Toast.show("请输入手机号");
            return;
        }
        if (!regular.phone(phone)) {
            Toast.show("请输入正确的手机号");
        } else {
            Loading.show();
            requestApi
                .sendAuthMessage({ phone, bizType: "REGISTER" })
                .then(() => {
                    this.refs.getCode.sendVerCode();
                })
                .catch((err)=>{
                    
                });
        }
    };

    componentWillUnmount() {
        Keyboard.dismiss();
    }

    render() {
        const { navigation} = this.props;
        const {
            phone,
            password,
            code,
            phoneFocus,
            passwordFocus,
            codeFocus,
            agress
        } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"手机号注册"}
                />
                <StatusBar
                    translucent={true}
                    backgroundColor={"transparent"}
                    barStyle="light-content"
                    networkActivityIndicatorVisible={true}
                    showHideTransition={'fade'}
                />
                <ScrollView
                    bounces={false}
                    showsVerticalScrollIndicator={false}
                >
                    <View style={styles.logoView}>
                        <Image
                            source={ruzhulogo}
                        />
                        <Image source={logotxt}/>
                    </View>

                    <View style={styles.loginView1}>
                        <TextInputView
                            inputView={[
                                styles.inputView,
                                phoneFocus && styles.inputView_focus
                            ]}
                            inputRef={e => {
                                this.phoneInput = e;
                            }}
                            style={styles.textInput}
                            value={phone}
                            maxLength={11}
                            keyboardType="numeric"
                            placeholder={"请输入手机号"}
                            placeholderTextColor={"#ccc"}
                            onChangeText={text => {
                                this.changeState("phone", text);
                            }}
                            onBlur={() => {
                                this.changeState("phoneFocus", false);
                            }}
                            onFocus={() => {
                                this.changeState("phoneFocus", true);
                            }}
                            leftIcon={
                                <View
                                    style={[styles.IconView, styles.leftView]}
                                >
                                    <View style={styles.imageView}>
                                        <Image
                                            source={require("../../images/user/mobile_gray.png")}
                                        />
                                    </View>
                                    <View style={styles.leftLine} />
                                </View>
                            }
                        />
                        <TextInputView
                            inputView={[
                                styles.inputView,
                                passwordFocus && styles.inputView_focus
                            ]}
                            inputRef={e => {
                                this.passwordInput = e;
                            }}
                            style={styles.textInput}
                            value={password}
                            placeholder={"请输入密码"}
                            secureTextEntry={true}
                            maxLength={20}
                            placeholderTextColor={"#ccc"}
                            onChangeText={text => {
                                console.log(text)
                                let str = text.replace(/\s+/g, "")
                                this.changeState("password", str);
                            }}
                            onBlur={() => {
                                this.changeState("passwordFocus", false);
                            }}
                            onFocus={() => {
                                this.changeState("passwordFocus", true);
                            }}
                            leftIcon={
                                <View
                                    style={[styles.IconView, styles.leftView]}
                                >
                                    <View style={styles.imageView}>
                                        <Image
                                            source={require("../../images/user/password_gray.png")}
                                        />
                                    </View>
                                    <View style={styles.leftLine} />
                                </View>
                            }
                        />
                        {
                            <TextInputView
                            inputView={[
                                styles.inputView,
                                codeFocus && styles.inputView_focus
                            ]}
                            inputRef={e => {
                                this.codeInput = e;
                            }}
                            style={styles.textInput}
                            value={code}
                            maxLength={6}
                            keyboardType="numeric"
                            placeholder={"请输入验证码"}
                            placeholderTextColor={"#ccc"}
                            onChangeText={text => {
                                this.changeState("code", text);
                            }}
                            onBlur={() => {
                                this.changeState("codeFocus", false);
                            }}
                            onFocus={() => {
                                this.changeState("codeFocus", true);
                            }}
                            leftIcon={
                                <View
                                    style={[styles.IconView, styles.leftView]}
                                >
                                    <View style={styles.imageView}>
                                        <Image
                                            source={require("../../images/user/mobile_code_gray.png")}
                                        />
                                    </View>
                                    <View style={styles.leftLine} />
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
                        }

                    </View>
                    <TouchableOpacity
                        style={{width:275,alignSelf:'center',paddingVertical:15,flexDirection:'row',alignItems:'center'}}
                      onPress={()=>{
                          this.setState({
                            agress:!this.state.agress
                          })
                      }}
                    >
                        <Image source={ agress ?  chooseIcon : nochooseIcon} style={{marginRight:8}}/>
                        <Text style={styles.c9f12}>我已阅读并同意</Text>
                        <TouchableOpacity onPress={()=>{this.handleGetProtocolUrl()}}>
                            <Text style={styles.cbf14}>《用户协议》</Text>
                        </TouchableOpacity>
                        <Text style={styles.c9f12}>及</Text>
                        <TouchableOpacity onPress={()=>{this.handleGetConcealPro()}}>
                            <Text style={styles.cbf14}>《隐私协议》</Text>
                        </TouchableOpacity>
                    </TouchableOpacity>
                    <View style={styles.loginBtnView}>
                        <TouchableOpacity
                            style={styles.loginBtn}
                            onPress={() => {
                                if(agress){
                                    this._registerClick();
                                }else{
                                    Toast.show('请先阅读并同意协议')
                                }
                            }}
                        >
                        <ImageBackground source={confirbtn} style={{width:315,height:89,justifyContent:'center',alignItems:'center'}}>
                        <Text style={styles.login_text}>{global.updateShop?'下一步':'确定并登录'}</Text>
                        </ImageBackground>
                        </TouchableOpacity>
                    </View>
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: "#fff",
        overflow: "hidden"
    },
    c9f12:{
        color:'#999999',
        fontSize:12
    },
    cbf14:{
        color:'#4A90FA',
        fontSize:12
    },
    logoView: {
        justifyContent: "center",
        alignItems: "center",
        width: "100%",
        // height: 180,
        marginTop: 30,
    },
    logo_text: {
        fontSize: 14,
        color: "#4A90FA",
        marginTop: 15
    },
    loginView1: {
        alignItems: "center",
        paddingHorizontal: 36,
        backgroundColor: "#fff"
    },
    inputView: {
        flexDirection: "row",
        width:275,
        height: 48,
        marginTop: 27,
        borderWidth: 1,
        borderColor: "#ccc",
        borderRadius: 100,
        overflow: "hidden"
    },
    inputView_focus: {
        borderColor: CommonStyles.globalHeaderColor
    },
    textInput: {
        flex: 1,
        height: "100%",
        paddingLeft: 20,
        paddingVertical: 0,
        color: "#555",
        backgroundColor: "#fff"
    },
    IconView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
    },
    leftView: {
        width: 68
    },
    imageView: {
        justifyContent: "center",
        alignItems: "center",
        width: 66,
        height: "100%"
    },
    leftLine: {
        width: 2,
        height: 24,
        borderRadius: 100,
        backgroundColor: "#ccc"
    },
    rightView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#fff"
    },
    code_text: {
        fontSize: 14,
        color: CommonStyles.globalHeaderColor
    },
    loginBtnView: {
        width: width,
        flex: 1,
        alignItems:'center',
        marginTop:35
    },
    loginBtn: {
        width:315,
        height: 89,
        // backgroundColor: CommonStyles.globalHeaderColor
    },
    login_text: {
        fontSize: 17,
        color: "#fff"
    }
});

export default connect(
    state => ({

     }),
    {
        fetchRegister:(payload={})=>({type:'user/fetchRegister',payload})
    }
)(RegisterScreen);
