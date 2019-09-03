/**
* 账号管理/修改手机号
*/
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
    Keyboard,
} from 'react-native';
import { connect } from 'rn-dva';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import CommonButton from '../../components/CommonButton';
import CheckButton from '../../components/CheckButton';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import { regExpPassWord } from '../../config/utils';

const { width, height } = Dimensions.get('window');

export default class AccountUpdatePhoneScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const params = props.navigation.state.params && props.navigation.state.params || {}
        let items = []
        switch (params.page.key) {
            case 'phone': items = [
                { key: 'oldPhone', value: params.currentAccount.phone, type: 'text' ,maxLength: 11 },
                { key: 'oldCode', value: '', type: 'code', placeholder: '请输入验证码' },
                { key: 'newPhone', value: '', type: 'phone', placeholder: '请输入新的手机号', main: true, maxLength: 11 },
                { key: 'newCode', value: '', type: 'code', placeholder: '请输入验证码' },
            ]; break;
            case 'password': items = [
                { key: 'phone', value: params.currentAccount.phone, type: 'text', placeholder: '请输入手机号', maxLength: 11 },
                { key: 'code', value: '', type: 'code', placeholder: '请输入验证码', maxLength: 6 },
                // { key: 'password', value: '', type: 'password', placeholder: '请输入新密码', main: true, maxLength: 18 },
            ]; break;
            case 'name': items = [
                { key: 'name', value: '', type: 'input', placeholder: '请输入新的名称', main: true,maxLength: 6 },
            ]; break;
        }
        this.state = {
            items: items,
            page: params.page || {},
            currentAccount: params.currentAccount,
            phone: params.currentAccount.phone,
            name: params.currentAccount.realName,
            password: '',
            oldPhone: params.currentAccount.phone
        }
    }

    componentDidMount() {
    }

    componentWillUnmount() {
    }
    changeRequestParams = (data, index) => {
        let newItems = [...this.state.items]
        newItems[index].value = data
        this.setState({
            [newItems[index].key]: data,
            items: newItems,
        })
    }
    saveEditor = () => {
        Keyboard.dismiss();
        const { navigation} = this.props
        const { currentAccount, page, items } = this.state
        for (item of items) {
            if (!item.value) {
                Toast.show(item.placeholder)
                return
            }
            else if (item.key == 'newPhone' && !regular.phone(this.state.phone)) {
                Toast.show('请输入正确格式的手机号');
                return
            }
        }

        let func;
        let params;
        if (this.state.page.key == 'phone') {
            func = requestApi.employeePhoneUpdate
            const { oldPhone, oldCode, newPhone, newCode } = this.state
            params = {
                employeeId: currentAccount.id,
                oldPhone,
                oldCode,
                newPhone,
                newCode
            }
        } else if(this.state.page.key == "password") {
            func = requestApi.employeeResetPassword
            params = {
                employeeId: currentAccount.id,
                phone: this.state.phone,
                code: this.state.code,
            }
        }
        else {
            func = requestApi.employeeUpdate
            params = {
                employeeId: currentAccount.id,
                phone: this.state.phone,
                name: this.state.name,
                userPermissions: currentAccount.permissions,
                merchantType:currentAccount.merchantType,
            }
        }
        Loading.show()
        func(params).then(data => {
            navigation.state.params.callback()
            let alertText='修改成功!'
            this.state.page.key == "password"?alertText=(alertText+'密码为12345678'):null
            Toast.show(alertText)
            navigation.goBack()
        }).catch((error) => {
            Loading.hide()
        })

    }
    //获取验证码
    _checkBtn = (phone, key) => {
        Keyboard.dismiss();
        if (this.refs[key].state.disabled) {
            return;
        }
        if (phone.trim() === '') {
            Toast.show('请输入手机号');
            return
        }
        if (!regular.phone(phone)) {
            Toast.show('请输入正确的手机号')
        } else {
            Loading.show();
            requestApi.sendAuthMessage({
                phone,
                bizType: this.state.page.key == 'phone' ? key == 'oldCode' ? 'RESET_EMPLOYEE_PHONE' : 'RESET_PHONE' : 'RESET_PASSWORD'
            }).then(() => {
                this.refs[key].sendVerCode()
            }).catch((err)=>{
                    
            });
        }
    }

    render() {
        const { navigation } = this.props;
        const items = this.state.items
        const page = navigation.state.params.page
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={page.nextPageTitle}
                    rightView={
                        <TouchableOpacity
                            onPress={() => this.saveEditor()}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: '#fff' }}>确定</Text>
                        </TouchableOpacity>
                    }
                />
                <View style={styles.content}>
                    <Content>
                        {
                            items.map((item, index) => {
                                return (
                                    <View key={index} style={styles.inputView}>
                                        <TextInputView
                                            inputView={{ flex: 1 }}
                                            placeholder={item.placeholder}
                                            style={styles.input}
                                            placeholderTextColor={'#ccc'}
                                            value={item.value}
                                            type={item.type}
                                            maxLength={item.maxLength}
                                            // onChangeText={(data) => { item.type == 'text' ? null : this.changeRequestParams(data, index) }}
                                            // 修改，取消电话默认值
                                            onChangeText={(data) => { this.changeRequestParams(data, index) }}
                                        />
                                        {
                                            item.type == 'code' ?
                                                <CheckButton
                                                    onClick={() => this._checkBtn(items[index - 1].value, item.key)}
                                                    delay={60}
                                                    ref={item.key}
                                                    styleBtn={styles.checkButton}
                                                    title={{ color: '#4A90FA',fontSize:14 }}
                                                /> : null
                                        }


                                    </View>

                                )
                            })
                        }
                    </Content>


                </View>
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
    inputView: {
        borderColor: '#F1F1F1',
        borderBottomWidth: 1,
        height: 50,
        position: 'relative'
    },
    input: {
        flex: 1,
        padding: 0,
        fontSize: 14,
        color: '#222222',
        paddingLeft: 15
    },

    checkButton: {
        backgroundColor: '#fff',
        position: 'absolute',
        right: 5,
        top: 17
    }


});
