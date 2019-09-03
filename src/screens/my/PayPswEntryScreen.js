/**
 * 确认支付密码
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
} from 'react-native';
import { connect } from 'rn-dva';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import SecurityKeyboard from '../../components/SecurityKeyboard';
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');

class PayPswEntryScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }
    constructor(props) {
        super(props)
        this.state = {
            maxLength: 6,
            password: '',
            showKeyBoard: false, // 安全键盘
            confimVis: false, // 没有设置密码弹窗
            goBackRouter: '', // 设置成功后 需要返回的路由
            callback:()=>{},//设置成功后 需要回调的函数
        }
    }

    blurState = {
        showKeyBoard: false, // 安全键盘
        confimVis: false, // 没有设置密码弹窗
    }

    componentDidMount() {
        this.changeState('showKeyBoard', true)
    }

    changeState(key, value, callback = () => { }) {
        this.setState({
            [key]: value
        }, () => {
            callback(this.state.password)
        });
    }
    // 确认密码
    handleEntryPsw = (text) => {
        if (text.length === 6) {
            this.changeState('showKeyBoard', false);
        }
    }
    handleSavePsw = () => {
        Loading.show()
        const { navigation } = this.props
        const { password } = this.state
        let firstPsw = navigation.getParam('firstPsw', '')
        let goBackRouter = navigation.getParam('goBackRouter', '')
        let callback = navigation.getParam('callback', '')
        if (firstPsw === password) {
            requestApi.xkUserPaySecuritySetPassword({
                textPassword: password
            }).then(res => {
                Toast.show('设置成功!')
                // 从哪儿来，回哪儿去
                // 获取设置支付密码状态
                requestApi.getPayPwdStatus(res => {
                    this.props.userSave({setPayPwdStatus:res})
                    console.log("获取设置支付密码状态", res);
                });
                callback && callback()
                this.props.navigation.navigate(goBackRouter)
            }).catch(err => {
                Toast.show('网络错误，请重试！')
            })
        } else {
            Toast.show('两次输入的密码不一样！')
            Loading.hide()
        }
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
    render() {
        const { navigation } = this.props;
        const { showKeyBoard, confimVis } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title={'确认支付密码'}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftItem}
                            onPress={() => {
                                navigation.goBack()
                            }}
                        >
                            <Image source={require('../../images/mall/goback.png')} />
                        </TouchableOpacity>
                    }
                    rightView={
                        <TouchableOpacity
                            onPress={this.handleSavePsw}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                保存
                            </Text>
                        </TouchableOpacity>
                    }

                />

                <View style={styles.contentView1}>
                    <Text style={styles.content_text1}>请再次输入您的支付密码</Text>
                </View>
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.contentView2}
                    onPress={() => {
                        this.changeState('showKeyBoard', true)
                    }}
                >
                    {this._getTextInputItem()}
                </TouchableOpacity>
                {/* 安全键盘 */}
                <SecurityKeyboard
                    visible={showKeyBoard}
                    onClose={() => { this.changeState('showKeyBoard', false) }}
                    onKeyPress={(text) => { this.changeState('password', text, () => { this.handleEntryPsw(text) }); }}

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
    saveBtn: {
        backgroundColor: CommonStyles.globalHeaderColor,
        marginHorizontal: 10,
        marginTop: 20,
        borderRadius: 8,
        paddingVertical: 10,
    },
    saveBtnText: {
        fontSize: 16,
        color: '#fff',
        textAlign: 'center'
    },
});

export default connect(
    (state) => ({

     }),
    {
        userSave: (payload={})=>({type: 'user/save', payload }),
    }
)(PayPswEntryScreen);
