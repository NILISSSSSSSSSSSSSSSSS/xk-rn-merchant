/**
 * 修改支付密码时候，验证支付密码
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TouchableOpacity,
    Image,
    Platform,
    TextInput,
} from 'react-native';
import { connect } from 'rn-dva';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import SecurityKeyboard from '../../components/SecurityKeyboard';
import CheckButton from '../../components/CheckButton'
import * as regular from '../../config/regular'
const { width, height } = Dimensions.get('window');

class VerifyUserScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        this.state = {
            phone: '',
            code: ''
        }
    }

    componentDidMount() {
    }

    changeState(key, value, callback = () => { }) {
        this.setState({
            [key]: value
        }, () => {
            callback(this.state.password)
        });
    }
    //获取验证码
    _checkBtn = () => {
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
            requestApi.sendAuthMessage({ phone, bizType: 'VALIDATE' }).then(() => {
                this.refs.getCode.sendVerCode()
            }).catch((err)=>{
                    
            });
        }
    }
    // 验证码是否通过
    handleVerifyCode = () => {
        const { navigation } = this.props;
        const { phone, code } = this.state
        requestApi.smsCodeValidate({
            phone,
            code
        }).then(res => {
            console.log(res)
            let goBackRouter = navigation.getParam('goBackRouter', '')
            this.props.navigation.navigate('ResetPayPsw', { goBackRouter })
        }).catch(err => {
            console.log(err)

        })
    }
    render() {
        const { navigation, store } = this.props;
        const { phone, code } = this.state
        let userInfo = store.user.user || {};
        const userImg = userInfo.avatar
            ? userInfo.avatar
            : require("../../images/user/phone_gray.png");
        return (
            <View style={styles.container}>
                <Header
                    headerStyle={styles.headerStyle}
                    navigation={navigation}
                    goBack={false}
                    title={''}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftItem}
                            onPress={() => {
                                navigation.goBack()
                            }}
                        >
                            <Image source={require('../../images/order/back.png')} />
                        </TouchableOpacity>
                    }
                />
                <View style={[styles.viewContainer, styles.shadowStyle]}>
                    <View style={[CommonStyles.flex_center, styles.userInfoWrap]}>
                        <Image source={{ uri: userImg }} style={styles.userImage} />
                        <Text style={styles.userName}>{userInfo.realName || userInfo.nickName}</Text>
                    </View>
                    <View style={styles.inputViewWrap}>
                        <View style={styles.phoneInputWrap}>
                            <TextInput
                                style={styles.phoneInput}
                                value={phone}
                                placeholder="请输入手机号码"
                                maxLength={11}
                                keyboardType="numeric"
                                returnKeyLabel="确定"
                                returnKeyType="done"
                                onChangeText={(text) => {
                                    this.changeState('phone', text)
                                }}
                            />
                        </View>
                        <View style={styles.verifyCodeWrap}>
                            <TextInput
                                style={styles.phoneInput}
                                placeholder="请输入验证码"
                                maxLength={6}
                                value={code}
                                keyboardType="numeric"
                                returnKeyLabel="确定"
                                returnKeyType="done"
                                onChangeText={(text) => {
                                    this.changeState('code', text)
                                }}
                            />
                            <View style={[styles.verifyCodeBtn, CommonStyles.flex_end]}>
                                <CheckButton
                                    ref="getCode"
                                    delay={60}
                                    styleBtn={styles.rightView}
                                    title={styles.code_text} ß
                                    onClick={this._checkBtn}
                                />
                            </View>
                        </View>
                        <TouchableOpacity
                            activeOpacity={0.7}
                            onPress={() => {
                                this.handleVerifyCode()
                            }} style={styles.entryBtnWrap}>
                            <Text style={styles.entryBtnText}>确定修改</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: '#fff'
    },
    headerLeftItem: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        width: 50,
        height: '100%',
        marginLeft: 27,
    },
    headerStyle: {
        backgroundColor: '#fff'
    },
    viewContainer: {
        marginTop: 80,
        marginHorizontal: 27,
        backgroundColor: '#fff',
        borderRadius: 10,
        // ...CommonStyles.shadowStyle
    },
    userInfoWrap: {
        position: 'relative',
        top: -40,
    },
    userImage: {
        height: 102,
        width: 102,
        borderRadius: 51,
    },
    userName: {
        marginTop: 13,
        fontSize: 14,
        color: '#222',
    },
    inputViewWrap: {
        marginHorizontal: 25,
    },
    phoneInputWrap: {
        borderBottomWidth: 1,
        borderBottomColor: '#BCBCBC',
    },
    verifyCodeWrap: {
        borderBottomWidth: 1,
        borderBottomColor: '#BCBCBC',
        position: 'relative',
        marginTop: Platform.OS === 'ios' ? 30 : 20,
    },
    verifyCodeBtn: {
        position: 'absolute',
        right: 0,
        bottom: 6,
        width: 120,
        height: 20,
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
    entryBtnWrap: {
        marginTop: 120,
        marginBottom: 40,
        borderRadius: 40,
        backgroundColor: CommonStyles.globalHeaderColor,
    },
    entryBtnText: {
        paddingVertical: 10,
        textAlign: 'center',
        color: '#fff',
        fontSize: 17,
    },
    phoneInput: {

    },
    shadowStyle: {
        // 以下是阴影属性：
        shadowOffset: { width: 0, height: 0.3 },
        shadowOpacity: 0.5,
        shadowRadius: 3,
        shadowColor: '#D7D7D7',
        // shadowColor: 'red',
        // 注意：这一句是可以让安卓拥有灰色阴影,现在不要阴影，修改为背景颜色为eee
        elevation: 2,
        // elevation: 2,
        zIndex: Platform.OS === 'ios' ? 1 : 0,
    },
});

export default connect(
    (state) => ({ store: state })
)(VerifyUserScreen);
