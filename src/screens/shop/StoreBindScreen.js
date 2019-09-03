/**
 * 确认提取保证金
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
import ActionSheet from '../../components/Actionsheet'
import * as requestApi from '../../config/requestApi';
const { width, height } = Dimensions.get('window');
import CheckButton from '../../components/CheckButton';
import CommonButton from '../../components/CommonButton';
import * as regular from '../../config/regular';
const options = ['分店', '店中店', '取消']
const optionsKey = ['BRANCH', 'SHOP_IN_SHOP']

class StoreBindScreen extends PureComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props)
        const params = props.navigation.state.params || {}
        this.state = {
            type: '店中店',
            shopType: 'SHOP_IN_SHOP',//分店	BRANCH,店中店	SHOP_IN_SHOP
            merchantCode: '',
            shopId: params && params.shopId,
            code: '',
            phone:'',
            payPassword: "",
            bindCode: '',
            masterId: params && params.masterId,
            shopName: '',
            currentShop: params && params.currentShop,
            callback: params && params.callback || (() => { })

        }
    }

    componentDidMount() {
    }

    componentWillUnmount() {
    }
    goSetPassword=(callback)=>{
        CustomAlert.onShow(
            "confirm",
            "您未设置过支付密码，是否立即设置？",
            "提示",
            () => { },
            () => {
                this.props.navigation.navigate('MerchantSetPswValidate',{goBackRouter:'Bindstore',callback})
            },
            botton1Text = "去设置",
            botton2Text = "取消",

        );
    }
    // 是否设置过支付密码
    getPayPwdStatus = (callback=()=>{}) => {
        let { navigation ,setPayPwdStatus,userSave} = this.props
        let textPwdIsSet = setPayPwdStatus.result
        if(!textPwdIsSet){ //undefind || 0
            if(textPwdIsSet=== 0){
                this.goSetPassword(callback)
            }else{
                Loading.show()
                requestApi.merchantPayPasswordIsSet().then(res => {
                    console.log('获取设置支付密码状态', res)
                    userSave({ setPayPwdStatus:res})
                    if (res.result === 0) {
                        // 没有设置支付密码
                        this.goSetPassword(callback)
                    } else {
                        callback()
                    }
                }).catch((err)=>{
                    console.log(err)
                  });
            }
        }else{
            callback()
        }

    };
    confirm = () => {
        const { code, phone, password, shopId, bindCode, shopName,shopType } = this.state
        const { navigation ,getMerchantHome} = this.props
        const params = {
            code,
            phone,
            payPassword: password
        }
        if(shopId){
            params.shopId = shopId
        }else{
            params.bindCode = bindCode
            params.shopType=shopType
        }
        if (!shopId && !shopName) {
            Toast.show('请输入正确的授权码')
            return
        }
        if (!regular.phone(params.phone)) {
            Toast.show('请输入正确格式的手机号');
        }
        if(shopId && !password){
            Toast.show('请输入支付密码')
            return
        }
        else if (!regular.checkcode(params.code)) {
            Toast.show('请输入正确格式的验证码');
        }
        else {
            Loading.show()
            let func = shopId ? requestApi.shopUnBind : requestApi.shopBind
            if (shopId) {

            }
            else {
                params.merchantPhone = params.phone
            }
            func(params).then(data => {
                Loading.hide()
                getMerchantHome()
                if (shopId) {
                    Toast.show('解绑成功')
                    navigation.navigate('StoreManage')
                }else {
                    Toast.show('绑定成功')
                    navigation.goBack()
                }
            }).catch(error => {
                Loading.hide()
            })
        }
    }
    bindCodeDetail = (shopBindCode) => {
        requestApi.bindCodeDetail({ shopBindCode }).then(data => {
            console.log('店铺名', data)
            this.setState({ shopName: data && data.shopName || '' })
        }).catch(error => {
            Loading.hide()
        })
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
                bizType: this.state.shopId ? 'UNBIND_SHOP' : 'BIND_SHOP',
                shopId: this.state.shopId || this.props.userShop.id
            }).then(() => this.refs.getCode.sendVerCode())
            .catch((err)=>{
                    
            });
        }
    }
    render() {
        const { navigation } = this.props;
        const { shopId, shopName ,type} = this.state
        let items = [
            { title: '商户手机号', placeholder: shopId ?'请输入验证手机号':'商户手机号', type: 'input', key: 'phone', },
            { title: '验证码', placeholder: shopId ?'请输入验证码':'验证码', type: 'input', key: 'code' }
        ]
        if (!shopId) {
            items = [
                { title: '授权码', placeholder: '请输入授权码', type: 'input', key: 'bindCode' },
                { title: '绑定店铺', placeholder: '', type: 'text', key: 'shopName' },
                ...items,
                { title: '店铺类型', placeholder: '请选择店铺类型', type: 'select', key: 'shopType' },
            ]
        }else{
            items.push({title: '验证支付密码', placeholder: '请输入支付密码', type: 'input', key: 'password' })
        }
        return (
            <View style={styles.container}>
                <Header
                    title={shopId ? '取消绑定' : '绑定下级店铺'}
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <View style={styles.content}>
                        {
                            shopId ? <Content style={{ width: width - 20 }}>
                                {
                                    items.map((item, index) => {
                                        return (
                                            <View style={{ position: 'relative' }} key={index}>
                                                <Line
                                                    title={item.title}
                                                    type={item.type}
                                                    leftStyle={{ width: 90 }}
                                                    point={null}
                                                    value={this.state[item.key]}
                                                    placeholder={item.placeholder}
                                                    secureTextEntry={item.key == 'password' ? true : false}
                                                    maxLength={item.key == 'phone' ? 11 : null}
                                                    onPress={item.onPress ? () => item.onPress() : null}
                                                    onChangeText={(data) => {
                                                        this.setState({ [item.key]: data })
                                                    }}
                                                    editable={true}
                                                />
                                                {
                                                    item.key == 'code' ?
                                                        <CheckButton
                                                            ref="getCode"
                                                            onClick={this._checkBtn}
                                                            delay={60}
                                                            styleBtn={styles.code}
                                                            title={{ color: '#4A90FA', fontSize: 12 }}
                                                        /> : null
                                                }

                                            </View>
                                        )
                                    })
                                }


                            </Content> :
                                <View style={{ alignItems: 'center' }}>
                                    {
                                        items.map((item, index) => {
                                            return (
                                                item.key == 'shopName' ?
                                                shopName? <Text style={styles.shopName} key={index}>绑定店铺：{shopName}</Text>:null :
                                                    <Content key={index} style={{ height: 50, justifyContent: 'center'  }} onPress={item.key=='shopType'?()=>this.ActionSheet.show():null}>
                                                        {
                                                            item.key!='shopType'?
                                                            <View style={{flex: 1,}}>
                                                                <TextInputView
                                                                    placeholder={item.placeholder}
                                                                    inputView={{ flex: 1, paddingHorizontal: 15 }}
                                                                    style={{ color: '#222' }}
                                                                    placeholderTextColor={'#ccc'}
                                                                    onChangeText={(data) => {
                                                                        this.setState({ [item.key]: data })
                                                                        item.key == 'bindCode' && data.length == 6 ?
                                                                            this.bindCodeDetail(data) : null
                                                                    }}
                                                                    maxLength={item.key == 'phone' ? 11 : null}
                                                                    secureTextEntry={item.key == 'password' ? true : false}
                                                                    editable={true}
                                                                    value={this.state[item.key]}
                                                                />
                                                                {
                                                                    item.key == 'code' ?
                                                                        <CheckButton
                                                                            ref="getCode"
                                                                            onClick={this._checkBtn}
                                                                            delay={60}
                                                                            name='发送验证码'
                                                                            styleBtn={[styles.code]}
                                                                            title={{ color: '#4A90FA' }}
                                                                        /> : null
                                                                }
                                                            </View>:
                                                            <View style={{flexDirection:'row',paddingHorizontal:15,alignItems:'center',justifyContent:'space-between'}}>
                                                                <Text style={{fontSize:14,color:'#222'}}>{type}</Text>
                                                                <Image source={require('../../images/index/expand.png')} style={{width:14,height:14}} />
                                                            </View>

                                                        }

                                                    </Content>
                                            )
                                        })
                                    }

                                </View>
                        }


                        <CommonButton title={shopId ? '确定' : '确认绑定'} onPress={() => shopId?this.getPayPwdStatus(this.confirm):this.confirm()} />


                    </View>
                    <ActionSheet
                        ref={o => this.ActionSheet = o}
                        // title={'Which one do you like ?'}
                        options={options}
                        cancelButtonIndex={2}
                        // destructiveButtonIndex={2}
                        onPress={(index) => {
                            index == options.length - 1 ? null : this.setState({
                                shopType: optionsKey[index],
                                type: options[index]
                            })
                        }}
                    />

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
        right: 0,
        top: 15,
        height: 22,
        alignItems: 'center',
        justifyContent: 'center',
        borderLeftWidth: 1,
        borderColor: '#F1F1F1',
        paddingLeft:15,
        paddingRight:15

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
        user:state.user.user || {},
        merchantData:state.user.merchantData || {},
        shops: (state.user.merchantData || {}).shops || [],
        userShop:state.user.userShop || {},
        setPayPwdStatus:state.user.setPayPwdStatus || {}
     }),
     {
        userSave: (params={})=>({ type: "user/save", payload: params}),
        getShopDetail: (payload = {}) => ({ type: 'shop/getShopDetail', payload }),
        getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
     }
)(StoreBindScreen);
