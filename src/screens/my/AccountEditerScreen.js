/**
 * 账号管理/新增账号
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
    Switch,
    Keyboard,
    Modal
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from "../../components/ImageView";
import TextInputView from "../../components/TextInputView";
import * as nativeApi from "../../config/nativeApi";
import * as requestApi from "../../config/requestApi";
import Line from "../../components/Line";
import Content from "../../components/ContentItem";
import CheckButton from "../../components/CheckButton";
import * as regular from "../../config/regular";
import CommonButton from "../../components/CommonButton";
import { regExpPassWord } from "../../config/utils";
import { NavigationComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");

class AccountEditerScreen extends NavigationComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const page =
            (props.navigation.state.params &&
                props.navigation.state.params.page) ||
            "add";
        const params = props.navigation.state.params;
        const currentAccount = (params && params.currentAccount) || {};
        let commonItems = [{
                title: page == "remove" ? "商户手机号" : "手机号码",
                placeholder: "请输入手机号码",
                value: page == "remove" ? props.userInfo.phone : "", // 如果是注销，需要验证商户的手机号，而不是员工
                type: "input",
                key: "phone",
                canEdit: page == "remove" ? false : true
            },
            {
                title: "手机验证码",
                placeholder: "请输入验证码",
                value: "",
                type: "input",
                key: "code",
                maxLength: 6
            }
        ];
        let itemsAdd = [
            [
                ...commonItems,
                {
                    title: "名称",
                    placeholder: "请输入名称",
                    value: "",
                    type: "input",
                    key: "name"
                },
                {
                    title: "账号归属",
                    placeholder: "",
                    value: "",
                    type: "horizontal",
                    key: "limit",
                    onPress:() => {
                        this.merchantTypePage()
                    }
                },
            ]
        ];
        itemsAdd = [
                [
                    ...itemsAdd[0],
                    {
                        title: "联盟商权限",
                        placeholder: "",
                        value: "",
                        type: "horizontal",
                        key: "lianmengshang",
                        onPress: () => {
                            props.navigation.navigate("AccountRoleConfi", {
                                type: 'otherRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                otherRoleType: 'merchant', // 其他权限类型
                                roleData: this.state.roleData, // 传入选择了的权限，配置页面自动打钩
                                callback: this.getRoleData
                            })
                        }
                    },{
                        title: "客服权限",
                        placeholder: "",
                        value: "",
                        type: "horizontal",
                        key: "CUSTOMER",
                        onPress: () => {
                            props.navigation.navigate("AccountRoleConfi", {
                                type: 'otherRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                otherRoleType: 'service', // 其他权限类型
                                roleData: this.state.roleData, // 传入选择了的权限，配置页面自动打钩
                                callback: this.getRoleData
                            })
                        }
                    },
                ]
            ];

        this.state = {
            requesParams: {
                code: "",
                phone: page == "remove" ? this.props.userInfo.phone: "",
                name: "",
                userPermissions: [],
                merchantType: "shops"
            },
            roleData: {
                shop: [],
                notShop: {
                    other: [],
                    service: [],
                    merchant: []
                }
            }, // 权限配置页面保存的权限
            merchantType: '', // 账号归属
            types: [],
            page: page,
            itemsAdd,
            itemsDelete: [
                commonItems,
                [
                    {
                        title: page == "remove" ? "商户登录密码" : "密码",
                        placeholder: "验证当前密码",
                        value: "",
                        type: "password",
                        key: "password"
                    }
                ]
            ],
            currentAccount: currentAccount,
            callback:(params && params.callback && params.callback) || (() => { }),
            accountBtlong: [], // 账号归属
            accountBtlongVisible: false, // 账号归属Modal
        };
    }

    blurState = {
        accountBtlongVisible: false, // 账号归属Modal
    }

    componentWillUnmount() {
        Keyboard.dismiss();
    }
    // 保存的店铺权限配置
    getRoleData = (type,otherRoleType,data) => {
        console.log('getRole',data)
        let _roleData = JSON.parse(JSON.stringify(this.state.roleData))
        if (type === 'shopRole') {
            _roleData.shop = data
        } else {
            _roleData.notShop[otherRoleType] = data
        }
        this.setState({
            roleData: _roleData
        })
    }
    // 获取商户账号类型
    getAccountType = (employeeType) => {
        return (this.props.merchant.find(item=>item.merchantType==employeeType) || {}).name
    }
    // 获取商户账号归属
    merchantTypePage = () => {
        Loading.show()
        requestApi.merchantTypePage().then(res => {
            console.log('账号归属',res)
            if (res) {
                let arr = [];
                res.map(item => {
                    if (item.auditStatus === "active") {
                        arr.push(item)
                    }
                })
                this.setState({
                    accountBtlong: arr,
                    accountBtlongVisible: true,
                })
            }

        }).catch(er => {

        })
    }
    getRoleDataList = () => {
        let {roleData} = this.state;
        let userPermissions = []
        roleData.shop.map(shopItem => {
            shopItem.resource.map((resourceItem) => {
                resourceItem.childrenResources.map(roleItem => {
                    if (roleItem.isSelect) {
                        userPermissions.push({
                            shopId: shopItem.shopId,
                            type: resourceItem.key,
                            serviceList: roleItem.serviceList,
                            key: roleItem.key,
                            name: roleItem.name,
                            icon: roleItem.icon
                        })
                    }
                })
           })
        })
        for (let key in roleData.notShop) {
            roleData.notShop[key].map(resourceItem => {
                resourceItem.childrenResources.map(roleItem => {
                    if (roleItem.isSelect) {
                        userPermissions.push({
                            type: resourceItem.key,
                            serviceList: roleItem.serviceList,
                            key: roleItem.key,
                            name: roleItem.name,
                            icon: roleItem.icon
                        })
                    }
                })
            })
        }
        return userPermissions
        console.log('sdfasfdsfa',userPermissions)
    }
    saveEditor = () => {
        let {requesParams:params,merchantType} = this.state;
        params.userPermissions = this.getRoleDataList()
        params.merchantType = merchantType
        console.log(params);
        if (!(/^[\u4e00-\u9fa5]{1,5}/.test(params.name))) {
            Toast.show("名称最少一位，最多5位中文字符");
            return
        }
        if (!regular.phone(params.phone)) {
            Toast.show("请输入正确的手机号");
            return
        }  else if (!regular.checkcode(params.code)) {
            Toast.show("请输入正确的验证码");
            return
        } else if (params.merchantType === '') {
            Toast.show("请选择账号归属");
            return
        }else if (params.userPermissions.length === 0) {
            Toast.show("请分配权限");
            return
        }
        else {
            Loading.show();
            requestApi.employeeCreate(params).then(data => {
                console.log("callback", this.state.callback);
                this.state.callback();
                this.props.navigation.goBack();
            }).catch(err => {
                console.log(err)
            });
        }
    };
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    confirm = () => {
        Keyboard.dismiss();
        const { navigation } = this.props;
        const { currentAccount, requesParams } = this.state;
        if (!requesParams.password) {
            Toast.show("请输入密码");
        } else {
            // 密码验证
            // if (!regExpPassWord(requesParams.password)) {
            //     return;
            // }
        }
        if (!regular.checkcode(requesParams.code)) {
            Toast.show("请输入正确的验证码");
        } else {
            Loading.show();
            requestApi.employeeDelete({
                employeeId: currentAccount.userId,
                password: requesParams.password,
                phone: this.props.userInfo.phone,
                code: requesParams.code
            }).then(data => {
                Toast.show("注销成功");
                this.state.callback();
                navigation.goBack();
            }).catch(error => { });
        }
    };
    changeRequestParams = (key, data, index0, index) => {
        const { requesParams, page, itemsAdd, itemsDelete } = this.state;
        const items = page == "remove" ? itemsDelete : itemsAdd;
        let newItems = [...items];
        console.log(newItems)
        newItems[index0][index].value = data;
        this.setState({
            requesParams: {
                ...this.state.requesParams,
                [key]: data
            },
            items: newItems
        });
    };
    //获取验证码
    _checkBtn = () => {
        const {requesParams} = this.state
        Keyboard.dismiss();
        if (this.refs.getCode.state.disabled) {
            return;
        }
        let phone = this.state.page === 'remove' ? this.props.userInfo.phone : requesParams.phone;
        if (phone.trim() === "") {
            Toast.show("请输入手机号");
            return;
        }
        if (!regular.phone(phone)) {
            Toast.show("请输入正确的手机号");
        } else {
            Loading.show();
            requestApi.sendAuthMessage({
                phone,
                bizType: this.state.page == "remove" ? "DELETE_EMPLOYEE" : "CREATE_EMPLOYEE"
            }).then(() => {
                this.refs.getCode.sendVerCode();
            }).catch((err)=>{
                    
            });
        }
    };
    handleSelectUserType = (item) => {
        let itemsAddArr = this.state.itemsAdd;
        console.log('this.state.itemsAdd',this.state.itemsAdd)
        if (item.merchantType === 'shops') { // 如果选择了商户归属，则显示店铺权限
            let _index =null;
            itemsAddArr[0].map((itemArr, i) => {
                if (itemArr.title==='店铺权限配置' && itemArr.key === 'shopRole') {
                    _index = i
                }
            })
            if (_index === null) {
                itemsAddArr[0][itemsAddArr[0].length] = {
                    title: "店铺权限配置",
                    placeholder: "",
                    value: "",
                    type: "horizontal",
                    key: "shopRole",
                    onPress: () => {
                        this.props.navigation.navigate("AccountRoleConfi", {
                            type: 'shopRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                            callback: this.getRoleData,
                            roleData: this.state.roleData, // 传入选择了的权限，配置页面自动打钩
                        })
                    }
                }
            }
        } else {
            let _index =null;
            itemsAddArr[0].map((itemArr, i) => {
                if (itemArr.title==='店铺权限配置' && itemArr.key === 'shopRole') {
                    _index = i
                }
            })
            if (_index !== null) {
                itemsAddArr[0].splice(_index, 1)
            }
        }
        this.setState({
            merchantType: item.merchantType,
            accountBtlongVisible: false,
            itemsAdd:itemsAddArr,
        })
    }
    render() {
        const { navigation } = this.props;
        const { merchantType, page, itemsAdd, itemsDelete,accountBtlongVisible ,accountBtlong} = this.state;
        const items = page == "remove" ? itemsDelete : itemsAdd;
        let currentAccount = navigation.getParam('currentAccount','')
        let leftWidth=merchantType === ''?72:86
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={page == "remove" ? "注销账号" : "分号管理"}
                    rightView={
                        page == "remove" ? null : (
                            <TouchableOpacity
                                onPress={() => this.saveEditor()}
                                style={{ width: 50 }}
                            >
                                <Text style={{ fontSize: 17, color: "#fff" }}>
                                    保存
                                </Text>
                            </TouchableOpacity>
                        )
                    }
                />
                <ScrollView
                showsHorizontalScrollIndicator={false}
                showsVerticalScrollIndicator={false}
                alwaysBounceVertical={false}
                  style={{ flex: 1 }}>
                    <View style={styles.content}>
                        {items.map((item, index0) => {
                            return (
                                <View key={index0} key={index0}>
                                    <Content key={1.1}>
                                        {item.map((item, index) => {
                                            if (index > 2) return
                                            return (
                                                <View
                                                    style={{ position: "relative" }}
                                                    key={index}
                                                >
                                                    <Line
                                                        title={item.title}
                                                        type={
                                                            item.type == "password"
                                                                ? "input"
                                                                : item.type
                                                        }
                                                        leftStyle={{
                                                            width: 90,
                                                        }}
                                                        rightValueStyle={{
                                                            justifyContent:
                                                                item.key == "shop"
                                                                    ? "space-between"
                                                                    : "flex-end"
                                                        }}
                                                        point={null}
                                                        placeholder={
                                                            item.placeholder
                                                        }
                                                        secureTextEntry={
                                                            item.key == "password"
                                                                ? true
                                                                : false
                                                        }
                                                        maxLength={
                                                            item.key == "phone"
                                                                ? 11
                                                                : item.key === 'code'
                                                                    ? 6
                                                                    : item.key === 'password'
                                                                        ? 20
                                                                        // : item.key === 'name'
                                                                        //     ? 10
                                                                            : null
                                                        }
                                                        value={item.value}
                                                        onPress={
                                                            item.onPress
                                                                ? () =>
                                                                    item.onPress()
                                                                : null
                                                        }
                                                        // editable={!item.canEdit}
                                                        onChangeText={data => {
                                                            item.canEdit === false
                                                                ? null
                                                                : this.changeRequestParams(
                                                                    item.key,
                                                                    data,
                                                                    index0,
                                                                    index
                                                                );
                                                        }}
                                                    />
                                                    {item.key == "code" ? (
                                                        <CheckButton
                                                            onClick={this._checkBtn}
                                                            delay={60}
                                                            ref="getCode"
                                                            name={"发送验证码"}
                                                            styleBtn={styles.code}
                                                            title={{
                                                                color: "#4A90FA",
                                                                fontSize: 12
                                                            }}
                                                        />
                                                    ) : null}
                                                </View>
                                            );
                                        })}
                                    </Content>
                                    {
                                        item.length>4 && <Content key={1.2}>
                                        {item.map((item, index) => {
                                            if (index === 3) {
                                                return (
                                                    <Line
                                                        key={index}
                                                        title={'账号归属'}
                                                        type={'horizontal'}
                                                        leftStyle={{  width: leftWidth, }}
                                                        rightTextStyle={{color:merchantType === ''?'#ccc':'#222'}}
                                                        point={null}
                                                        value={ merchantType === ''?'请选择':this.getAccountType(merchantType)}
                                                        onPress={ ()=>this.merchantTypePage() }
                                                    />
                                                // <View
                                                //     style={{ position: "relative" }}
                                                //     key={index}
                                                // >
                                                //     <TouchableOpacity onPress={() => {
                                                //         this.merchantTypePage()
                                                //     }} style={[CommonStyles.flex_between,{padding: 15}]}>
                                                //         <Text style={{fontSize: 14,color: '#222',width:72,textAlign: 'right'}}>账号归属</Text>
                                                //         <View style={[CommonStyles.flex_start]}>
                                                //             {
                                                //                 merchantType === ''
                                                //                 ? <Text style={{fontSize: 14,color: '#777'}}>请选择</Text>
                                                //                 :<Text style={{fontSize: 14,color: '#777'}}>{this.getAccountType(merchantType)}</Text>
                                                //             }
                                                //             <Image source={require('../../images/index/expand.png')}/>
                                                //         </View>
                                                //     </TouchableOpacity>
                                                // </View>
                                            );
                                            }

                                        })}
                                        </Content>
                                    }
                                    {
                                        item.length>4 &&
                                        <Content key={1.3}>
                                    {item.map((item, index) => {
                                        if (index > 3) {
                                            return (
                                            <View
                                                style={{ position: "relative" }}
                                                key={index}
                                            >
                                                <Line
                                                    title={item.title}
                                                    type={
                                                        item.type == "password"
                                                            ? "input"
                                                            : item.type
                                                    }
                                                    leftStyle={{
                                                        width: leftWidth,
                                                    }}
                                                    rightValueStyle={{
                                                        justifyContent:
                                                            item.key == "shop"
                                                                ? "space-between"
                                                                : "flex-end"
                                                    }}
                                                    point={null}
                                                    placeholder={
                                                        item.placeholder
                                                    }
                                                    secureTextEntry={
                                                        item.key == "password"
                                                            ? true
                                                            : false
                                                    }
                                                    maxLength={
                                                        item.key == "phone"
                                                            ? 11
                                                            : null
                                                    }
                                                    value={item.value}
                                                    onPress={
                                                        item.onPress
                                                            ? () =>
                                                                item.onPress()
                                                            : null
                                                    }
                                                    onChangeText={data => {
                                                        item.canEdit === false
                                                            ? null
                                                            : this.changeRequestParams(
                                                                item.key,
                                                                data,
                                                                index0,
                                                                index
                                                            );
                                                    }}
                                                />
                                                {item.key == "code" ? (
                                                    <CheckButton
                                                        onClick={this._checkBtn}
                                                        delay={60}
                                                        ref="getCode"
                                                        name={"发送验证码"}
                                                        styleBtn={styles.code}
                                                        title={{
                                                            color: "#4A90FA",
                                                            fontSize: 12
                                                        }}
                                                    />
                                                ) : null}
                                            </View>
                                        );
                                        }

                                    })}
                                    </Content>
                                    }


                                </View>
                            );
                        })}

                        {page == "remove" ? (
                            <CommonButton
                                title="确认"
                                onPress={() => this.confirm()}
                            />
                        ) :
                        <Text style={styles.warning}>*分号的初始登录密码默认为：12345678。分号可登录晓可联盟，在个人中心里修改登录密码</Text>
                        }

                    </View>

                </ScrollView>
                {/* 选择员工账号归属modal */}
                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={accountBtlongVisible}
                    onRequestClose={() => {this.changeState('accountBtlongVisible',false)}}
                >
                    <View style={styles.modal}>
                        <View style={styles.modalContent}>
                            {
                                accountBtlong.length === 0
                                ? <TouchableOpacity style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                    onPress={() => {this.changeState('accountBtlongVisible',false)}}
                                >
                                    <Text style={styles.modalItemText}>暂无数据</Text>
                                </TouchableOpacity>
                                : accountBtlong.map((item, index) => {
                                    return (
                                        <TouchableOpacity key={index} style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                            onPress={() => {
                                                this.handleSelectUserType(item)
                                            }}
                                        >
                                            <Text style={styles.modalItemText}>{this.getAccountType(item.merchantType)}</Text>
                                        </TouchableOpacity>
                                    );
                                })
                            }
                            {

                            }
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {this.changeState('accountBtlongVisible',false)}}
                                style={[styles.modalItem, styles.flex_center]}
                            >
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    content: {
        alignItems: "center",
        paddingBottom: 10
    },
    warning:{
        color:CommonStyles.globalHeaderColor,
        fontSize:13,
        marginTop:15,
        paddingHorizontal:25
    },
    code: {
        backgroundColor: "#fff",
        position: "absolute",
        right: 15,
        top: 18,
        height: 22,
        alignItems: "center",
        justifyContent: "center",
        borderWidth: 1,
        borderColor: "#4A90FA",
        borderRadius: 10
    },
    bomView: {
        marginBottom: 20 + CommonStyles.footerPadding
    },
    modalOutView: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center"
    },
    modalInnerTopView: {
        flex: 1,
        width: width,
        backgroundColor: "rgba(0, 0, 0, .5)"
    },
    modalInnerBottomView: {
        width: width,
        height: 300 + CommonStyles.footerPadding,
        backgroundColor: "#fff"
    },
    userImgLists_item: {
        justifyContent: "center",
        alignItems: "center",
        width: width,
        height: 50
    },
    userImgLists_item1: {
        borderTopWidth: 1,
        borderTopColor: "#E5E5E5"
    },
    userImgLists_item2: {
        borderTopWidth: 5,
        borderTopColor: "#E5E5E5"
    },
    userImgLists_item_text: {
        fontSize: 16,
        color: "#000"
    },
    flex_center: {
        justifyContent: 'center',
        flexDirection: 'row',
    },
    flex_1: {
        flex: 1
    },
    modal: {
        // height: 342,
        flex: 1,

        backgroundColor: "rgba(10,10,10,.5)",
        position: "relative"
    },
    modalContent: {
        position: "absolute",
        bottom: 0,
        left: 0,
        width,
        backgroundColor: "#fff",
        paddingBottom:CommonStyles.footerPadding
    },
    color_red: {
        color: "#EE6161"
    },
    modalItemText: {
        fontSize: 17,
        color: "#222",
        textAlign: 'center'
    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: "relative"
    },
    borderBottom: {
        borderBottomColor: "#f1f1f1",
        borderBottomWidth: 1
    },
    block: {
        width,
        height: 5,
        backgroundColor: "#F1F1F1",
        position: "absolute",
        top: 0,
        left: 0
    },
    flex_end: {
        flexDirection: "row",
        justifyContent: "flex-end",
        alignItems: "center"
    },
    flex_start: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center"
    },
});

export default connect(
    (state) => ({
        userInfo:state.user.user || {},
        merchant:state.user.merchant || [],
     })
)(AccountEditerScreen);
