/**
 * 设置支付密码
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
import FlatListView from '../../components/FlatListView';
import TextInputView from '../../components/TextInputView';
import SecurityKeyboard from '../../components/SecurityKeyboard';
import ModalDemo from "../../components/Model";
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');

export default class PayPswAddScreen extends NavigationComponent {
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
        }
    }

    blurState = {
        showKeyBoard: false, // 安全键盘
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
    // 判断密码长度 跳转
    goToEntryPsw = (text) => {
        if (text.length === 6) {
            const { navigation } = this.props
            let goBackRouter = navigation.getParam('goBackRouter', '')
            let callback = navigation.getParam('callback', '')
            this.changeState('showKeyBoard', false,
                () => {
                    this.props.navigation.navigate('PayPswEntry', { firstPsw: text, goBackRouter ,callback})
                });
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
        const { showKeyBoard, confimVis, password } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title={'设置支付密码'}
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
                />

                <View style={styles.contentView1}>
                    <Text style={styles.content_text1}>请设置您的支付密码</Text>
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
                    transparent={true}
                    visible={showKeyBoard}
                    disableOkBtn={password.length !== 6 ? true : false}
                    onClose={() => { this.changeState('showKeyBoard', false) }}
                    onKeyPress={(text) => { this.changeState('password', text, () => { this.goToEntryPsw(text) }); }}
                    onOk={() => { this.goToEntryPsw(password) }}
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
