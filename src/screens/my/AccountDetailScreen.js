/**
 * 账号管理/账号详情
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
import { NavigationPureComponent } from "../../common/NavigationComponent";
const refunds = [
    { title: "消费前可退", key: "CONSUME_BEFORE" },
    { title: "限定时间前随时可退", key: "RESERVATION_BEFORE_BYTIME" },
    { title: "预定时间前随时退", key: "RESERVATION_BEFORE" }
];
const { width, height } = Dimensions.get("window");

class AccountDetailScreen extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            types: [],
            id: props.navigation.getParam('id',''), // 员工id
            currentAccount: {}, // 员工详情信息
            merchantType: '', // 账号归属
            accountBtlongVisible: false, // 账号归属Modal
            accountBtlong: [],
            roleData: {
                shop: [],
                notShop: {
                    other: [],
                    service: [],
                    merchant: []
                }
            }, // 权限配置页面保存的权限
            shopResources: [],
            notShopResources: []
        };
    }

    blurState = {
        accountBtlongVisible: false, // 账号归属Modal
    }

    screenDidFocus = (payload)=> {
        super.screenDidFocus(payload)
        this.initData()
    }

    componentDidMount() {
        Loading.show()

    }
    initData = () => {
        Promise.all([
            this.getData(),
            this.shopResourcePage(),
            this.notShopResourcePage()
        ]).then(res => {
            console.log('initData',res)
            let { roleData } = this.state
            roleData.shop = res[1];
            res[2].map((notShopResourceItem, index) => {
                notShopResourceItem.childrenResources.map(item => {
                    item['isSelect'] = false
                })
                notShopResourceItem['isShow'] = true
                roleData.notShop[notShopResourceItem.key] = [notShopResourceItem]
            })

            roleData.shop.map((shopItem, index) => {
                if (index === 0) {
                    shopItem['isShow'] = true
                }else {
                    shopItem['isShow'] = false
                }
                console.log('shopItem',shopItem)
                shopItem.resource && shopItem.resource.map(resourceItem => {
                    resourceItem.childrenResources.map(roleItem => {
                        roleItem['isSelect'] = false
                    })
                })
            })
            res[0].permissions.map(item => {
                if (item.shopId) {
                    roleData.shop.map(shopItem => {
                        shopItem.resource && shopItem.resource.map(resourceItem => {
                            resourceItem.childrenResources.map(roleItem => {
                                if (shopItem.shopId === item.shopId && item.key === roleItem.key) {
                                    roleItem['isSelect'] = true
                                }
                            })
                        })
                    })
                } else {
                    for (let key in roleData.notShop) {
                        roleData.notShop[key].map(notShopResource => {
                            console.log('123',notShopResource)
                            notShopResource.childrenResources && notShopResource.childrenResources.map(roleItem => {
                                if (item.key===roleItem.key) {
                                    roleItem['isSelect'] = true
                                }
                            })
                        })
                    }
                }
            })

            console.log('roleDataroleData',roleData)
            this.setState({
                currentAccount: res[0],
                roleData,
                merchantType: res[0].merchantType
            })
        }).catch(err => {
            console.log(err)
            Toast.show('网络错误')
        })
    }
    // 非店铺资源列表
    notShopResourcePage = () => {
        return new Promise((resolve,reject) => {
            requestApi.notShopResourcePage().then(res => {
                console.log('notShopResourcePage',res)
                resolve(res)
            }).catch(err => {
                reject(err)
                console.log(err)
            })
        })
    }
    // 店铺资源列表
    shopResourcePage = () => {
        const { navigation, userInfo } = this.props
        let merchantId = userInfo.merchantId;
        return new Promise((resolve,reject) => {
            requestApi.shopResourcePage({
                merchantId,
            }).then(res => {
                console.log('shopResourcePage',res)
                resolve(res)
            }).catch(err => {
                console.log(err)
                reject(err)
            })
        })

    }
    // 获取详情
    getData = (isRefresh) => {
        if (!isRefresh) {
            Loading.show();
        }
        return new Promise((resolve,reject) => {
            requestApi.employeeDetail({
                employeeId: this.state.id
            }).then(res=> {
                console.log('detail',res)
                resolve(res)
            }).catch(err => {
                reject(err)
                console.log(err)
            })
        })
    }
    componentWillUnmount() {

    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    // 获取商户账号归属
    merchantTypePage = () => {
        Loading.show()
        requestApi.merchantTypePage().then(res => {
            console.log('reerer',res)
            let temp = [];
            if (res) {
                res.map(item => {
                    if (item.auditStatus === 'success') {
                        temp.push(item)
                    }
                })
            }
            this.setState({
                accountBtlong: temp,
                accountBtlongVisible: true,
            })

        }).catch(er => {

        })
    }
    // 获取商户账号类型
    getAccountType = (employeeType) => {
        return (this.props.merchant.find(item=>item.merchantType==employeeType) || {name:'获取中...'}).name
        // switch (employeeType) {
        //     case 'personal': return '个人'
        //     case 'anchor': return '主播'
        //     case 'company': return '公司(合伙人)'
        //     case 'shops': return '商户'
        //     case 'familyL1': return '普通家族（家族长）'
        //     case 'familyL2': return '钻石家族（公会）'
        //     default: return '获取中...'
        // }
    }
    // 更新权限回调
    handleUpdateRole = (type,otherRoleType,data) => {
        console.log('wrewrwrw',type,otherRoleType,data)
        let _roleData = JSON.parse(JSON.stringify(this.state.roleData))
        if (type === 'shopRole') {
            _roleData.shop = data
        } else {
            _roleData.notShop[otherRoleType] = data
        }
        this.setState({
            roleData: _roleData
        })
        Loading.show()
        const currentAccount = this.state.currentAccount;
        let params = {
            employeeId: currentAccount.id,
            userPermissions: this.getRoleDataList(_roleData),
            merchantType:this.state.merchantType,
            name: currentAccount.realName
        };
        console.log('参数',params)
        this.handleUpdateRoleRequest(params)
    }
    // 修改权限请求
    handleUpdateRoleRequest = (params={}) => {
        requestApi.employeeUpdate(params).then(data => {
            console.log('更新权限回调',data)
            Toast.show("修改成功");
            this.getData(true)
            if (this.state.accountBtlongVisible) {
                this.setState({
                    accountBtlongVisible: false
                })
            }
        }).catch(error => {
            Loading.hide();
        });
    }
    getRoleDataList = (roleData) => {
        console.log('更新权限回调',roleData)
        let userPermissions = []
        roleData.shop.map(shopItem => {
            shopItem.resource && shopItem.resource.map((resourceItem) => {
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
        const currentAccount = this.state.currentAccount;
        Loading.show();
        const params = {
            employeeId: currentAccount.id,
            phone: currentAccount.phone,
            name: currentAccount.realName
        };
        requestApi.employeeUpdate(params).then(data => {
            console.log('res',data)
            Loading.hide();
            Toast.show("修改成功");
        }).catch(error => {
            Loading.hide();
        });
    };
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
    render() {
        const { navigation} = this.props;
        const { currentAccount,merchantType,accountBtlongVisible,accountBtlong } = this.state;
        let limit = [];
        for (item of currentAccount.resource || []) {
            limit.push(item.shopName);
        }
        let items = [
            // { title: '账号',  value: 'fdfdf', type: '' ,key:'account'},
            {
                title: "账号",
                value: currentAccount.nickName || '',
                type: "",
                key: "yaoqingma"
            },
            {
                title: "安全码",
                value: currentAccount.inviteCode || '',
                type: "",
                key: "yaoqingma"
            },
            {
                title: "手机号",
                value: currentAccount.phone || '',
                type: "horizontal",
                key: "phone",
                nextPageTitle: "修改手机号"
            },
            {
                title: "名称",
                value: currentAccount.realName || '',
                type: "horizontal",
                key: "name",
                nextPageTitle: "修改名称"
            },
            {
                title: "密码",
                value: "重置初始密码",
                type: "horizontal",
                key: "password",
                nextPageTitle: "重置初始密码"
            },
        ];
        return (
            <View style={styles.container}>
                <Header
                    title="账号详情"
                    navigation={navigation}
                    goBack={true}
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1,paddingBottom: 100 }}>
                    <View style={styles.content}>
                        <Content>
                            {items.map((item, index) => {
                                return (
                                    <View
                                        key={index}
                                        style={{ position: "relative" }}
                                    >
                                        <Line
                                            title={item.title}
                                            type={item.type}
                                            rightValueStyle={{
                                                textAlign: "right",
                                                color:item.title=='安全码'?CommonStyles.globalHeaderColor: '#222'
                                            }}
                                            point={null}
                                            value={item.value}
                                            onPress={() => {
                                                if (item.type == "horizontal") {
                                                    navigation.navigate("AccountUpdate",{
                                                            page: item,
                                                            currentAccount: this.state.currentAccount,
                                                            callback: () => {this.getData(false)}
                                                        }
                                                    );
                                                }

                                            }}
                                        />
                                    </View>
                                );
                            })}
                        </Content>
                    </View>
                    <View
                        style={[styles.selectBelong]}
                    >
                        <TouchableOpacity onPress={() => {
                            this.merchantTypePage()
                        }} style={[CommonStyles.flex_between,{padding: 15}]}>
                            <Text style={{fontSize: 14,color: '#222',textAlign: 'right'}}>账号归属</Text>
                            <View style={[CommonStyles.flex_start]}>
                                {
                                    merchantType === ''
                                    ? <Text style={{fontSize: 14,color: '#777'}}>请选择</Text>
                                    :<Text style={{fontSize: 14,color: '#222'}}>{this.getAccountType(merchantType)}</Text>
                                }
                                <Image source={require('../../images/index/expand.png')}/>
                            </View>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.roleWrap}>
                    {
                        merchantType === 'shops'
                        ?   <TouchableOpacity onPress={() => {
                                navigation.navigate("AccountRoleConfi", {
                                    type: 'shopRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                    callback: this.getRoleData,
                                    roleData: JSON.parse(JSON.stringify(this.state.roleData)), // 传入选择了的权限，配置页面自动打钩
                                    isUpdate: true,
                                    updateCallBack: this.handleUpdateRole
                                })
                            }}
                            style={[CommonStyles.flex_between,{padding:15,borderBottomColor: '#f1f1f1',borderBottomWidth: 1}]}>
                                    <Text style={{fontSize: 14,color: '#222'}}>店铺权限</Text>
                                    <View style={[CommonStyles.flex_start]}>
                                        {/* <Text style={{fontSize: 14,color: '#777'}}>dsf</Text> */}
                                        <Image source={require('../../images/index/expand.png')}/>
                                    </View>
                            </TouchableOpacity>
                        : null
                    }

                        <TouchableOpacity
                        onPress={() => {
                            navigation.navigate("AccountRoleConfi", {
                                type: 'otherRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                otherRoleType: 'merchant', // 其他权限类型
                                roleData: JSON.parse(JSON.stringify(this.state.roleData)), // 传入选择了的权限，配置页面自动打钩
                                callback: this.getRoleData,
                                isUpdate: true,
                                updateCallBack: this.handleUpdateRole
                            })
                        }}
                        style={[CommonStyles.flex_between,{padding:15,borderBottomColor: '#f1f1f1',borderBottomWidth: 1}]}>
                                <Text style={{fontSize: 14,color: '#222'}}>联盟商权限</Text>
                                <View style={[CommonStyles.flex_start]}>
                                    {/* <Text style={{fontSize: 14,color: '#777'}}>dsf</Text> */}
                                    <Image source={require('../../images/index/expand.png')}/>
                                </View>
                        </TouchableOpacity>
                        <TouchableOpacity
                        onPress={() => {
                            navigation.navigate("AccountRoleConfi", {
                                type: 'otherRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                otherRoleType: 'service', // 其他权限类型
                                roleData: JSON.parse(JSON.stringify(this.state.roleData)), // 传入选择了的权限，配置页面自动打钩
                                isUpdate: true,
                                updateCallBack: this.handleUpdateRole,
                                callback: this.getRoleData
                            })
                        }}
                        style={[CommonStyles.flex_between,{padding:15,borderBottomColor: '#f1f1f1',borderBottomWidth: 1}]}>
                                <Text style={{fontSize: 14,color: '#222'}}>客服权限</Text>
                                <View style={[CommonStyles.flex_start]}>
                                    {/* <Text style={{fontSize: 14,color: '#777'}}>dsf</Text> */}
                                    <Image source={require('../../images/index/expand.png')}/>
                                </View>
                        </TouchableOpacity>
                        {/* <TouchableOpacity
                        onPress={() => {
                            navigation.navigate("AccountRoleConfi", {
                                type: 'otherRole', // 分店铺权限(shopRole)和其他权限(otherRole)，店铺权限会根据店铺个数渲染，其他的只有一个
                                otherRoleType: 'other', // 其他权限类型
                                roleData: JSON.parse(JSON.stringify(this.state.roleData)), // 传入选择了的权限，配置页面自动打钩
                                isUpdate: true,
                                updateCallBack: this.handleUpdateRole,
                                callback: this.getRoleData
                            })
                        }}
                        style={[CommonStyles.flex_between,{padding:15,borderBottomColor: '#f1f1f1',borderBottomWidth: 1}]}>
                                <Text style={{fontSize: 14,color: '#222'}}>其他权限</Text>
                                <View style={[CommonStyles.flex_start]}>
                                    <Image source={require('../../images/index/expand.png')}/>
                                </View>
                        </TouchableOpacity> */}
                    </View>


                </ScrollView>
                {/* 选择员工账号归属modal */}
                <Modal
                    animationType="slide"
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
                                                if ((item.merchantType || '') === this.state.merchantType) {
                                                    this.setState({
                                                        accountBtlongVisible: false
                                                    })
                                                    return
                                                }
                                                this.setState({
                                                    merchantType: item.merchantType,
                                                    accountBtlongVisible: false,
                                                },() => {
                                                    let params = {
                                                        employeeId: currentAccount.id,
                                                        userPermissions: [],
                                                        merchantType:this.state.merchantType,
                                                        name: currentAccount.realName
                                                    };
                                                    this.handleUpdateRoleRequest(params)
                                                })
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
                                style={[styles.modalItem, styles.flex_center,{paddingBottom:CommonStyles.headerPadding}]}
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

    line: {
        paddingVertical: 14,
        paddingHorizontal: 10,
        borderColor: "#F1F1F1",
        borderBottomWidth: 1
    },
    code: {
        backgroundColor: "#fff",
        position: "absolute",
        right: 15,
        top: 14,
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
        backgroundColor: "#fff"
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
    marginTop: {
        marginTop: 5
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
    selectBelong: {
        // margin: 10,
        marginTop: 0,
        marginLeft:10,
        ...CommonStyles.shadowStyle,
        backgroundColor: '#fff',
        borderRadius: 6,
        width: width - 20,
        overflow: 'hidden'
    },
    roleWrap: {
        borderRadius: 6,
        backgroundColor: '#fff',
        margin: 10,

    },
});

export default connect(
    (state) => ({
        userInfo:state.user.user || {},
        merchant:state.user.merchant || [],
     })
)(AccountDetailScreen);
