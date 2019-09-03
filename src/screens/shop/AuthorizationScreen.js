/**
 * 授权管理
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
    Keyboard,
    Modal,
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import TextInputView from '../../components/TextInputView';
import CheckButton from '../../components/CheckButton';
import * as requestApi from '../../config/requestApi'
import * as regular from '../../config/regular'
import * as utils from '../../config/utils';
import moment from 'moment'
import { NavigationPureComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");

class AuthorizationScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };
    timer = null;
    constructor(props) {
        super(props);
        this.state = {
            activeIndex: 0, // 选择的权限标题索引
            modalVisible: false, //shopList modal显示状态
            modalType: 'select',//..select为选择店铺，success为生成授权码成功
            selectShopName: '',
            phone: '', // 手机号
            code: '', // 二维码
            verCode: '', // 用户输入的验证码
            toShopId: '', //  目标店铺ID
            toMerchantCode: '', // 目标商户编号
            fromShopId: '', // 当前登录店铺ID
            authCode: '',//授权码
            timeoutTime: '',//过期时间
            selectResource: [],
            isTimeOut: false,
        }
    }

    blurState = {
        modalVisible: false, //shopList modal显示状态
    }

    componentDidMount() {
        // 获取当前登录店铺的绑定状态
        this.getShopBindStatus()
        // 获取所有权限列表
        this.getRoleList()
        // 获取当前登录店铺ID
        this.getLoginShopId()
        // this.handleCountDown(moment().add(2,'m'))
    }

    componentWillUnmount() {
        Keyboard.dismiss()
        this.timer && clearInterval(this.timer)
        this.setState({modalVisible:false})
    }
    getShopBindStatus = () => {
        const { userShop } = this.props
        requestApi.shopIsBind({
            id: userShop.id
        }).then(res => {
            console.log('shopIsBind',res)
            if (res.isBind === 1) {
                Toast.show(`本店已被${res.toShopName}店铺绑定，若需解绑请联系该店铺`,3000)
            }
        }).catch(err => {
            console.log(err)
        })
    }
    // 选择权限, 需要和移动端权限同步
    handleClickItem = (shopIndex,resourceIndex,roleIndex,rItem) => {
        const  _roleList = [...this.props.roleList]
        let selectResource = this.state.selectResource;
        _roleList[shopIndex].resource[resourceIndex].childrenResources[roleIndex].isSelect = ! _roleList[shopIndex].resource[resourceIndex].childrenResources[roleIndex].isSelect
        console.log(rItem.isSelect)
        if (rItem.isSelect) {
            selectResource.push(rItem.key)
        } else {
            let _index = null;
            selectResource.map((selectItem,_i) => {
                if (selectItem === rItem.key) {
                    _index = _i
                }
            })
            if (_index !== null) {
                selectResource.splice(_index, 1)
            }
        }
        this.setState({
            selectResource,
        })
        this.props.shopSave({roleList:_roleList})
    }
    getLoginShopId = () => {
        const { userShop } = this.props
        let id = userShop.id || ''
        if (id) {
            this.handleChangeState('fromShopId', id)
        }
    }
    // 获取权限列表
    getRoleList = () => {
        Loading.show();
        const { navigation, userShop ,user} = this.props
        let merchantId = user.merchantId;
        let shopId = userShop.id;
        requestApi.shopResourcePage({
            merchantId,
            shopId,
            type: 'create'
        }).then(res => {
            console.log('资源列表请求返回',res)
            try {
                res.map((shopItem,index) => {
                    shopItem.resource.map((resourceItem) => {
                        resourceItem.childrenResources.map(roleItem => {
                            roleItem['isSelect'] = false
                        })
                    })
                })
                this.props.shopSave({roleList:res})
            } catch (error) {
                console.log(error)
            }
        }).catch(err => {
            console.log(err)
        })
    }
    // 根据商户号获取店铺
    getShopList = () => {
        let len = this.state.toMerchantCode.length
        if (len !== 10) {
            this.props.shopSave({roleManagerShopList:[]})
            this.setState({
                selectShopName: '',
                toShopId: ''
            })
            return
        }
        Keyboard.dismiss();
        Loading.show()
        requestApi.getRoleManagerShopList({
            merchantCode: this.state.toMerchantCode
        }, (res) => {
            Loading.hide()
            this.props.shopSave({roleManagerShopList:res})
            this.setState({
                modalType: 'select',
                modalVisible: true
            })
        }).catch((err) => {
            Loading.hide()
            this.props.shopSave({roleManagerShopList:[]})
        })

    }
    // 选择店铺
    handleSelectShop = (item) => {
        let toShopId = JSON.parse(JSON.stringify(this.state.toShopId))
        if (toShopId === item.id) {
            this.setState({
                selectShopName: '',
                toShopId: ''
            })
            return
        }
        this.setState({
            selectShopName: item.name,
            toShopId: item.id
        })
    }
    // 发送验证码
    handleSendCode = () => {
        Keyboard.dismiss()
        const { phone, fromShopId } = this.state
        if (this.refs.getCode.state.disabled) {
            return
        }
        if (phone === '') {
            Toast.show('请输入手机号码')
            return
        }
        if (!regular.phone(phone)) {
            Toast.show('请输入正确的手机号码')
            return
        }
        Loading.show();
        requestApi.sendAuthMessage({ phone, bizType: 'CREATE_BIND_CODE', shopId: this.props.userShop.id })
        .then(() =>this.refs.getCode.sendVerCode()) 
        .catch((err)=>{
                    
        });
        // do request...
    }
    // 切换权限标题
    handleToggle = (index) => {
        const { activeIndex } = this.state
        this.setState({
            activeIndex: index === activeIndex ? '' : index
        })
    }
    // 改变state
    handleChangeState = (key, value, callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    // 显示提供选择的店铺列表
    handleOpenShopList = () => {
        const { toMerchantCode } = this.state
        if (toMerchantCode.trim() === '') {
            Toast.show('请先填写商户号')
            return
        }
        this.setState({
            modalType: 'select',
            modalVisible: true
        })
    }

    // 提交
    handleSubmit = () => {
        const { phone, toMerchantCode, verCode, toShopId, fromShopId } = this.state
        const { roleList ,user,userShop,merchantShopRelations} = this.props;
        let _roleList  = JSON.parse(JSON.stringify(roleList))
        let resource = {};
        _roleList.map(shopItem => {
            resource = {
                childrenResources: [],
                name: shopItem.shopName,
                key: 'shop'
            }
            shopItem.resource.map(resourceItem => {
                resourceItem.childrenResources.map(roleItem => {
                    if (roleItem.isSelect) {
                        resource.childrenResources.push(roleItem)
                    }
                })
            })
        })
        let isSelf = 0;
        merchantShopRelations&&merchantShopRelations.map(item => {
            if (item.name === userShop.name && item.shopId === userShop.id) {
                isSelf = item.isSelf
            }
        })
        if (isSelf !== 1) {
            Toast.show('当前登录为非直属店铺，不能进行授权操作！')
            return
        }
        if (resource.childrenResources.length === 0) {
            Toast.show('请选择权限')
            return
        }
        if (phone.trim() === '') {
            Toast.show('请输入手机号')
            return
        }
        if (!regular.phone(phone)) {
            Toast.show('请输入正确的手机号码')
            return
        }
        // if (code === '') {
        //     Toast.show('请先获取验证码')
        //     return
        // }
        if (verCode.trim() === '') {
            Toast.show('请输入验证码')
            return
        }
        if (verCode.length !== 6) {
            Toast.show('验证码长度不正确')
            return
        }
        if (toMerchantCode.trim() === '') {
            Toast.show('请输入商户号')
            return
        }
        if (toMerchantCode.trim().length !== 10) {
            Toast.show('输入的商户号不正确')
            return
        }
        if (toShopId.length === 0) {
            Toast.show('请选择店铺')
            return
        }
        let params = {
            phone, // 手机号
            code: verCode, // 二维码
            toShopId, //  目标店铺ID
            toMerchantCode, // 目标商户编号
            fromShopId, // 当前登录店铺ID
            resource, // 选择的资源列表
        }
        console.log('提交数据', params)
        Loading.show()
        requestApi.submitRoleList(params, (res) => {
            console.log(res)
            if (res) {
                const timeoutTime=moment().add(res.expire,'second').format('YYYY-MM-DD HH:mm:ss')
                this.setState({
                    modalVisible: true,
                    modalType: 'success',
                    authCode: res.code,
                    timeoutTime
                })
                this.handleCountDown(res.expire)
            }
            else {
                Toast.show('创建失败')
            }
        })
    }
    handleCountDown = (expire) => {
        this.timer = setInterval(() => {
            expire--
            if(expire===0){
                this.setState({
                    isTimeOut: true,
                }, () => {
                    clearInterval(this.timer)
                })
            }
        }, 1000)
    }
    // 有效期倒计时
    // handleCountDown = (dealline) => {
    //     let time = moment(dealline).diff(moment());
    //     console.log('time',dealline)
    //     console.log('moment',moment())
    //     console.log(' moment(dealline).diff(moment())',time)
    //     this.timer = setInterval(() => {
    //         let t = null;
    //         let d = null;
    //         let h = null;
    //         let m = null;
    //         let s = null;
    //         //js默认时间戳为毫秒,需要转化成秒
    //         t = time / 1000;
    //         d = Math.floor(t / (24 * 3600));
    //         h = Math.floor((t - 24 * 3600 * d) / 3600);
    //         m = Math.floor((t - 24 * 3600 * d - h * 3600) / 60);
    //         s = Math.floor((t - 24 * 3600 * d - h * 3600 - m * 60));
    //         time -= 1000;
    //         if (time < 0) {
    //             this.setState({
    //                 isTimeOut: true,
    //             }, () => {
    //                 clearInterval(this.timer)
    //             })
    //             return
    //         }
    //     }, 1000)
    // }
    render() {
        const { navigation, roleList, roleManagerShopList } = this.props;
        const { activeIndex, toShopId, modalVisible, modalType, toMerchantCode, phone, verCode, selectShopName, authCode, timeoutTime,selectResource,isTimeOut } = this.state
        console.log('selectResource',selectResource)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"授权管理"}
                />
                <ScrollView
                    keyboardDismissMode="on-drag"
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}>
                    <View style={styles.containerView}>
                        {
                            roleList.map((item, index) => {
                                console.log(item)
                                let topBorderRadius = index === 0 ? styles.topRadius : null
                                let btmBorderRadius = roleList.length > 1 ? index === roleList.length - 2 ? styles.bottomRadius : null : null
                                let bottomRadius_parant = index !== activeIndex && index === roleList.length - 1 ? styles.bottomRadius_parant : null
                                return (
                                    <TouchableOpacity activeOpacity={1} onPress={() => { this.handleToggle(index) }} key={index}>
                                        <View style={[styles.titleItem, topBorderRadius, btmBorderRadius, bottomRadius_parant]} >
                                            <Text style={styles.titleItemText}>{item.shopName}</Text>
                                            <Image style={styles.titleItemImage} source={(index === activeIndex) ? require('../../images/shop/row_show.png') : require('../../images/shop/row_close.png')} />
                                        </View>
                                        {
                                            (index === activeIndex)
                                            && <View style={[styles.contentItemWrap]}>
                                                {
                                                    item.resource && item.resource.map((resourceItem, j) => {
                                                        return resourceItem.childrenResources.map((roleItem, k) => {
                                                            return (
                                                                <TouchableOpacity
                                                                    activeOpacity={0.6}
                                                                    key={k}
                                                                    onPress={() => { this.handleClickItem(index,j,k,roleItem) }}
                                                                    style={styles.listItemWrap}
                                                                >
                                                                    <View style={styles.listItem}>
                                                                        {/* 图片地址暂无，等后台添加 */}
                                                                        <Image style={styles.listItemImg} source={{uri: roleItem.icon}} />
                                                                        <Text style={styles.listItemText}>{roleItem.name}</Text>
                                                                    </View>

                                                                        {/* // 判断是否选择，选择则显示图标 */}

                                                                    <View style={styles.listItemSelectedIcon}>
                                                                        <Image  source={roleItem.isSelect ?require("../../images/index/select.png"):require("../../images/index/unselect.png")} />
                                                                    </View>

                                                                </TouchableOpacity>
                                                            )
                                                        })
                                                    })
                                                }
                                            </View>
                                        }
                                    </TouchableOpacity>
                                )
                            })
                        }
                        <View style={styles.formWrap}>
                            <View style={styles.formItemWrap}>
                                <View style={styles.formItem}>
                                    <TextInputView
                                        leftIcon={
                                            <Text style={styles.formItemLabel}>商户手机号</Text>
                                        }
                                        inputView={styles.textInputView}
                                        placeholder="请输入手机号"
                                        placeholderTextColor="#ccc"
                                        maxLength={11}
                                        keyboardType="numeric"
                                        onChangeText={(value) => {
                                            this.handleChangeState('phone', value)
                                        }}
                                        value={phone}
                                    />
                                </View>
                            </View>
                            <View style={styles.formItemWrap}>
                                <View style={styles.formItem}>
                                    <TextInputView
                                        leftIcon={
                                            <Text style={styles.formItemLabel}>验证码</Text>
                                        }
                                        inputView={styles.textInputView}
                                        placeholder="请输入验证码"
                                        placeholderTextColor="#ccc"
                                        maxLength={6}
                                        keyboardType="numeric"
                                        rightIcon={
                                            <CheckButton
                                                ref="getCode"
                                                delay={60}
                                                title={styles.codeDefaultStyle}
                                                onClick={() => this.handleSendCode()}
                                            />
                                        }
                                        onChangeText={(value) => {
                                            this.handleChangeState('verCode', value)
                                        }}
                                        value={verCode}
                                    />
                                </View>
                            </View>
                            <View style={styles.formItemWrap}>
                                <View style={styles.formItem}>
                                    <TextInputView
                                        leftIcon={
                                            <Text style={styles.formItemLabel}>绑定商户号</Text>
                                        }
                                        inputView={styles.textInputView}
                                        placeholder="请输入商户号"
                                        maxLength={10}
                                        placeholderTextColor="#ccc"
                                        keyboardType="numeric"
                                        value={toMerchantCode}
                                        onChangeText={(value) => {
                                            this.handleChangeState('toMerchantCode', value, this.getShopList)
                                        }}
                                    />
                                </View>
                            </View>
                            <View style={styles.formItemWrap}>
                                <View style={styles.formItem}>
                                    <TouchableOpacity style={{ width: '100%' }} activeOpacity={1} onPress={this.handleOpenShopList}>
                                        <TextInputView
                                            leftIcon={
                                                <Text style={styles.formItemLabel}>店铺选择</Text>
                                            }
                                            rightIcon={
                                                <Image style={styles.shopSelectImg}
                                                    source={(modalVisible && modalType == 'select') ? require('../../images/shop/row_show.png') : require('../../images/shop/row_close.png')}
                                                />
                                            }
                                            inputView={styles.textInputView}
                                            placeholder="请选择店铺"
                                            placeholderTextColor="#ccc"
                                            value={selectShopName}
                                            editable={false}
                                        />
                                    </TouchableOpacity>

                                </View>
                            </View>
                            <TouchableOpacity style={styles.formSubmitBtnWrap} onPress={() => this.handleSubmit()} activeOpacity={(selectResource.length === 0) ? 1 : 0.2}>
                                <Text style={[styles.formSubmitBtn, (selectResource.length === 0) ? styles.formSubmitBtnDisable : null]}>生成授权码</Text>
                            </TouchableOpacity>
                        </View>
                        <View style={styles.bottomNoticeWrap}>
                            <Text style={styles.bottomNotice}><Text style={styles.color_red}>* </Text>提示：被绑定后，上级店铺将对本店拥有以上权限，绑定后权限无法修改，如要修改权限，请上级店铺解绑后设定权限重新绑定。</Text>
                        </View>
                    </View>
                </ScrollView>
                <Modal
                    animationType="fade"
                    transparent={true}
                    style={{ width: width }}
                    visible={modalVisible}
                    onRequestClose={() => {
                        this.handleChangeState('modalVisible', false)
                    }}>
                    {
                        modalType == 'select' ?
                            <TouchableOpacity style={{ height: '100%', width: '100%' }} onPress={() => { this.handleChangeState('modalVisible', false) }}>
                                <View style={{flex:1,backgroundColor:'rgba(0,0,0,0.5)'}}></View>
                                <View style={styles.modalView}>
                                    <View style={styles.modalOperat}>
                                        <TouchableOpacity onPress={() => { this.handleChangeState('modalVisible', false) }}>
                                            <Text style={styles.modalOperatText}>确定</Text>
                                        </TouchableOpacity>
                                    </View>
                                    <ScrollView style={styles.modalScroll} showsVerticalScrollIndicator={false}>
                                        {
                                            roleManagerShopList.length > 0 && roleManagerShopList.map((item, index) => {
                                                return (
                                                    <View style={styles.lineWrap} key={index}>
                                                        <TouchableOpacity onPress={() => { this.handleSelectShop(item) }}>
                                                            <View style={[styles.modalItemWrap, (index === 0) ? styles.noTopBorder : null]}>
                                                                <Text numberOfLines={12} style={styles.modalItemText}>{item.name}</Text>
                                                                <View style={styles.selectBtnWrap}>
                                                                    <View style={[(toShopId === item.id) ? styles.selectActive : null]} />
                                                                </View>
                                                            </View>
                                                        </TouchableOpacity>
                                                    </View>
                                                )
                                            }) || <Text style={{ color: '#999', textAlign: 'center', fontSize: 14, marginTop: 20 }}>暂无数据</Text>
                                        }
                                    </ScrollView>
                                </View>
                            </TouchableOpacity> :
                            <View style={styles.alertView}>
                                <ImageBackground
                                    source={require('../../images/shop/shouquan_alert.png')}
                                    style={styles.alertBackground}
                                >
                                    <Text style={{ color: '#000000', fontSize: 28, marginTop: 152 }}>{authCode}</Text>
                                    <View style={styles.timeView}>
                                        <Text style={{ color: '#555555', fontSize: 12 }}>有效期：{timeoutTime}</Text>
                                    </View>
                                    {
                                        isTimeOut
                                        ? <Text style={{ color: '#555555', fontSize: 12 }}>授权码已过期，请重新生成授权码</Text>
                                        : <Text style={{ color: '#555555', fontSize: 12 }}>请在有效期内使用</Text>
                                    }
                                </ImageBackground>
                                <TouchableOpacity onPress={() => this.handleChangeState('modalVisible', false)}>
                                    <Image source={require('../../images/shop/close.png')} style={styles.close} />
                                </TouchableOpacity>
                            </View>
                    }
                </Modal>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    containerView: {
        borderRadius: 6,
        margin: 10,
    },
    titleItem: {
        borderBottomWidth: 1,
        borderBottomColor: '#F1F1F1',
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 49
    },
    titleItemText: {
        fontSize: 14,
        color: '#222'
    },
    titleItemImage: {

    },
    listItemWrap: {
        width: '25%',
        position: 'relative',
        height: 85,
        alignItems: 'center',
        justifyContent: 'center',
        // paddingLeft: 5,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        backgroundColor: '#fff'
    },
    listItem: {
        alignItems: 'center',
        justifyContent: 'center'
    },
    listItemImg: {
        height: 18,
        width: 18,
    },
    itemMargin: {
        marginTop: 10,
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8
    },
    listItemText: {
        fontSize: 12,
        color: '#222',
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 15,
    },
    listItemSelectedIcon: {
        height: 18,
        width: 18,
        borderRadius: 14,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'absolute',
        right: 10,
        top: 5,
        opacity: 1,
    },
    listItemSelectedText: {
        color: '#fff',
    },
    noBottomBorder: {
        borderBottomWidth: 0,
        borderBottomColor: '#F1F1F1',
    },
    topRadius: {
        borderTopLeftRadius: 6,
        borderTopRightRadius: 6
    },
    bottomRadius: {
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6
    },
    bottomRadius_parant: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8
    },
    contentItemWrap: {
        width: '100%',
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'flex-start',
        flexWrap: 'wrap',
        overflow: 'hidden',
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8
    },
    formWrap: {
        marginTop: 10,
        borderRadius: 6,
        overflow: 'hidden',
        backgroundColor: '#fff'
    },
    formItemWrap: {
        paddingRight: 0,
        height: 50,
    },
    formItem: {
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        height: 49,
    },
    formItemLabel: {
        width: 100,
        paddingRight: 14,
        color: '#222',
        textAlign: 'right',
    },
    formSubmitBtnWrap: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginVertical: 20,
    },
    formSubmitBtn: {
        width: 295,
        height: 44,
        lineHeight: 44,
        fontSize: 17,
        color: '#fff',
        backgroundColor: CommonStyles.globalHeaderColor,
        textAlign: 'center',
        borderRadius: 8
    },
    formSubmitBtnDisable: {
        backgroundColor: '#ccc'
    },
    bottomNoticeWrap: {
        marginTop: 15,
        paddingHorizontal: 20,
        marginBottom: 5,
    },
    bottomNotice: {
        fontSize: 12,
        color: '#999',
        lineHeight: 17
    },
    textInputView: {
        width: '100%',
        height: '100%',
        justifyContent: 'flex-start',
        alignItems: 'center',
        flexDirection: 'row',
    },
    codeDefaultStyle: {
        color: '#4A90FA',
        fontSize: 14,
        backgroundColor: '#fff',
        // height: 30,
        // lineHeight: 20,
        paddingHorizontal: 10,
        paddingVertical:4,
        borderColor: '#4A90FA',
        borderWidth: 1,
        borderRadius: 14,
    },
    shopSelectImg: {
        marginRight: 10
    },

    modalView: {
        width: width,
        height: 271 + CommonStyles.footerPadding,
        flexDirection: 'row',
        justifyContent: 'center',
        backgroundColor: '#fff',
        paddingBottom: CommonStyles.footerPadding
    },
    modalOperat: {
        height: 44,
        lineHeight: 44,
        borderColor: '#f1f1f1',
        borderBottomWidth: 1,
        borderTopWidth: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        width: '100%',
        paddingRight: 28,
        backgroundColor: '#fff'
    },
    modalOperatText: {
        color: CommonStyles.globalHeaderColor
    },
    modalScroll: {
        position: 'absolute',
        bottom: CommonStyles.footerPadding,
        left: 0,
        maxHeight: 240,
        width: '100%',
        height: 227,
        zIndex: 1,
        backgroundColor: '#fff',
    },
    lineWrap: {
        paddingLeft: 18,
        paddingRight: 28,
        height: 47,
    },
    modalItemWrap: {
        height: 50,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: '#fff',
        borderTopWidth: 1,
        borderTopColor: 'rgba(0,0,0,0.05)',
    },
    noTopBorder: {
        borderTopColor: '#fff',
        borderTopWidth: 1
    },
    modalItemText: {
        textAlign: 'left',
        maxWidth: 140,
        fontSize: 14,
        color: '#555555'
    },
    selectBtnWrap: {
        height: 13,
        width: 13,
        padding: 2,
        borderWidth: 1,
        borderColor: '#CCCCCC',
        borderRadius: 13,
    },
    selectActive: {
        flex: 1,
        backgroundColor: CommonStyles.globalHeaderColor,
        borderRadius: 11,
    },
    alertView: {
        height: '100%',
        width: '100%',
        backgroundColor: 'rgba(0,0,0,0.5)',
        alignItems: 'center',
    },
    alertBackground: {
        marginTop: CommonStyles.headerPadding + 120,
        width: 300,
        height: 287,
        alignItems: 'center',

    },
    timeView: {
        backgroundColor: "#E5E5E5",
        borderRadius: 100,
        paddingHorizontal: 12,
        paddingVertical: 3,
        marginTop: 20,
        marginBottom: 8

    },
    close: {
        width: 24,
        height: 24,
        marginTop: 20
    },
    color_red: {
        color: "#EE6161"
    },
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        user:state.user.user || {},
        merchantShopRelations: (state.user.merchantData || {}).merchantShopRelations || [],
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
        roleList:state.shop.roleList || [],
        roleManagerShopList:state.shop.roleManagerShopList || []
     }),
    (dispatch) => ({
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(AuthorizationScreen);
