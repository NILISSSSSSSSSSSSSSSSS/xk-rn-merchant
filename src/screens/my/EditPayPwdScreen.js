/**
 * 修改支付密码
 */
import React, { Component, PureComponent } from "react";
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
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import TextInputView from "../../components/TextInputView";
import CheckButton from "../../components/CheckButton";
import * as regular from "../../config/regular";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");

class EditPayPwd extends PureComponent {
    static navigationOptions = {
        header: null
    };
    phoneInputRef = null;
    verifiyInputRef = null;
    pwdInputRef = null;
    constructor(props) {
        super(props);
        this.state = {
            phoneNumber: "",
            verifyNumber: "",
            pwdNumber: "",
            phoneFocus: false,
            verifyFocus: false,
            pwdFocus: false
        };
    }

    componentDidMount() { }

    componentWillUnmount() {
        Keyboard.dismiss();
    }
    handleChangePhone = value => { };
    handleChangeState = (key, value) => {
        this.setState({
            [key]: value
        });
    };
    handleSendCode = () => {
        Keyboard.dismiss();
        // console.log(this.props);
        const { phoneNumber } = this.state;
        if (this.refs.getCode.state.disabled) {
            return;
        }
        console.log(phoneNumber === "");
        if (phoneNumber === "") {
            Toast.show("请输入手机号码");
            return;
        }
        if (!regular.phone(phoneNumber)) {
            Toast.show("请输入正确的手机号码");
            return;
        }
        Loading.show();
        requestApi
            .sendAuthMessage({ phone: phoneNumber, bizType: "RESET_PASSWORD" })
            .then(() => {
                this.refs.getCode.sendVerCode();
            }).catch((err)=>{
                    
            });
        // do request...
    };
    handleSubmit = () => {
        Keyboard.dismiss();
        let { phoneNumber, pwdNumber, verifyNumber } = this.state;

        if (
            phoneNumber.trim() === "" ||
            pwdNumber.trim() === "" ||
            verifyNumber.trim() === ""
        ) {
            Toast.show("请输入手机号、密码或验证码");
            return;
        }
        if (!regular.phone(phoneNumber)) {
            Toast.show("请输入正确的手机号");
            return;
        }
        console.log(this.state);
        requestApi.setPayPwd(
            {
                phone: phoneNumber,
                code: verifyNumber,
                payPassword: pwdNumber
            },
            res => {
                console.log(res);
                let obj = JSON.parse(
                    JSON.stringify(this.props.setPayPwdStatus)
                );
                obj.result = 1;
                Toast.show("设置成功", 2000);
                this.props.userSave({setPayPwdStatus:obj})
                this.props.navigation.goBack();
            }
        );
    };
    render() {
        const { navigation } = this.props;
        const {
            phoneNumber,
            verifyNumber,
            pwdNumber,
            phoneFocus,
            verifyFocus,
            pwdFocus
        } = this.state;
        const { setPayPwdStatus } = this.props;
        // console.log(this.props);
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={`${setPayPwdStatus.result ? "修改" : "设置"}支付密码`}
                />
                <View style={styles.container_view}>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            phoneFocus && this.phoneInputRef.blur();
                            verifyFocus && this.verifiyInputRef.blur();
                            pwdFocus && this.pwdInputRef.blur();
                        }}
                    >
                        <TextInputView
                            inputRef={e => {
                                this.phoneInputRef = e;
                            }}
                            inputView={[
                                styles.inputView,
                                phoneFocus ? styles.inputActive : {}
                            ]}
                            value={phoneNumber}
                            maxLength={11}
                            onChangeText={value => {
                                this.handleChangeState("phoneNumber", value);
                            }}
                            placeholder="请输入手机号"
                            placeholderTextColor="#ccc"
                            keyboardType="numeric"
                            leftIcon={
                                <View style={styles.leftIcon}>
                                    <Image
                                        style={styles.leftIconImg}
                                        source={require("../../images/user/mobile_gray.png")}
                                    />
                                </View>
                            }
                            onFocus={() => {
                                this.handleChangeState("phoneFocus", true);
                            }}
                            onBlur={() => {
                                this.handleChangeState("phoneFocus", false);
                            }}
                        />
                        <TextInputView
                            inputRef={e => {
                                this.verifiyInputRef = e;
                            }}
                            inputView={[
                                styles.inputView,
                                verifyFocus ? styles.inputActive : {}
                            ]}
                            value={verifyNumber}
                            maxLength={6}
                            onChangeText={value => {
                                this.handleChangeState("verifyNumber", value);
                            }}
                            placeholder="请输入验证码"
                            placeholderTextColor="#ccc"
                            keyboardType="numeric"
                            leftIcon={
                                <View style={styles.leftIcon}>
                                    <Image
                                        style={styles.leftIconImg}
                                        source={require("../../images/user/mobile_code_gray.png")}
                                    />
                                </View>
                            }
                            rightIcon={
                                <CheckButton
                                    ref="getCode"
                                    delay={60}
                                    title={styles.codeDefaultStyle}
                                    onClick={this.handleSendCode}
                                    disabledStyles={{
                                        color: CommonStyles.globalHeaderColor
                                    }}
                                />
                            }
                            onFocus={() => {
                                this.handleChangeState("verifyFocus", true);
                            }}
                            onBlur={() => {
                                this.handleChangeState("verifyFocus", false);
                            }}
                        />
                        <TextInputView
                            inputRef={e => {
                                this.pwdInputRef = e;
                            }}
                            inputView={[
                                styles.inputView,
                                pwdFocus ? styles.inputActive : {}
                            ]}
                            value={pwdNumber}
                            onChangeText={value => {
                                this.handleChangeState("pwdNumber", value);
                            }}
                            placeholder="请输入新密码"
                            placeholderTextColor="#ccc"
                            keyboardType="decimal-pad"
                            secureTextEntry={true}
                            leftIcon={
                                <View style={styles.leftIcon}>
                                    <Image
                                        style={styles.leftIconImg}
                                        source={require("../../images/user/password_gray.png")}
                                    />
                                </View>
                            }
                            rightIcon={<View style={styles.paddingRight} />}
                            onFocus={() => {
                                this.handleChangeState("pwdFocus", true);
                            }}
                            onBlur={() => {
                                this.handleChangeState("pwdFocus", false);
                            }}
                        />
                        <TouchableOpacity
                            style={styles.resetBtn}
                            onPress={this.handleSubmit}
                        >
                            <Text style={styles.resetBtn_text}>
                                确定{`${setPayPwdStatus.result ? "" : "重置"}`}
                            </Text>
                        </TouchableOpacity>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    border: {
        borderWidth: 1
    },
    container: {
        ...CommonStyles.containerWithoutPadding,
        flex: 1,
        backgroundColor: '#fff'
    },
    container_view: {
        paddingTop: 11,
        paddingHorizontal: 36,
        // paddingLeft: 50,
        // paddingRight: 50
    },
    inputView: {
        // flex: 1,
        // height: '100%',
        // paddingLeft: 20,
        // paddingVertical: 0,
        // fontSize: 14,
        // color: '#555',
        // backgroundColor: '#fff',
        borderWidth: 2,
        marginTop: 27,
        width: "100%",
        height: 48,
        alignItems: "center",
        textAlign: "left",
        justifyContent: "flex-start",
        flexDirection: "row",
        borderWidth: 1,
        borderColor: "#ccc",
        borderRadius: 100,
        color: "#555",
        fontSize: 14
    },
    leftIcon: {
        width: 66,
        borderRightWidth: 2,
        borderRightColor: "#ccc",
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        marginRight: 14
    },
    leftIconImg: {
        height: 18
    },
    inputActive: {
        // ...CommonStyles.shadowStyle,
        // backgroundColor: '#fff',
        borderColor: "#4A90FA"
    },
    codeDefaultStyle: {
        // paddingRight: 14,
        color: "#4A90FA",
        fontSize: 14
    },
    resetBtn: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: "100%",
        height: 48,
        marginTop: 78,
        borderRadius: 100,
        backgroundColor: CommonStyles.globalHeaderColor
    },
    resetBtn_text: {
        color: "#fff",
        fontSize: 17
    },
    paddingRight: {
        paddingRight: 14
    }
});

export default connect(
    state => ({
        setPayPwdStatus:state.user.setPayPwdStatus
     }),
    {
        shopSave:(payload={})=>({type: 'user/save', payload }),
    }
)(EditPayPwd);
