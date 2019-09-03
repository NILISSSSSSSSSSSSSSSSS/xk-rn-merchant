// 店铺权限配置

import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from "../../config/requestApi";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";

const { width, height } = Dimensions.get("window");
let defaultImage = require('../../images/default/default_355_213.png');
class AccountShopRole extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            resourceList: [], // 店铺权限资源
            otherResourceList: [], // 非店铺权限资源，包括（联盟商权限，客服权限，其他权限）
        }
    }

    componentDidMount() {
        const { navigation } = this.props
        let type = navigation.getParam('type','')
        let roleData = navigation.getParam('roleData',[])
        Loading.show()
        if (type === 'shopRole') {
            if (roleData.shop.length !== 0) {
                Loading.hide();
                this.setState({
                    resourceList: roleData.shop
                })
                return
            }
            this.shopResourcePage()
        } else {
            let otherRoleType = navigation.getParam('otherRoleType','')
            if (roleData.notShop[otherRoleType].length !== 0) {
                Loading.hide();
                if (roleData.notShop[otherRoleType][0].key === otherRoleType) {
                    this.setState({
                        otherResourceList: roleData.notShop[otherRoleType]
                    })
                    return
                }
                this.notShopResourcePage();
            }
            this.notShopResourcePage();
        }
    }

    componentWillUnmount() {
        Loading.hide()
    }
    // 匹配已经选择的权限
    getIsSelectedRole = (roleData, nowAllData) => {
        const { navigation } = this.props
        let otherRoleType = navigation.getParam('otherRoleType')
        if (roleData.length === 0) return
        let data = []
        roleData.map(item => {
            data.push([item.permissionType, item])
        })
        // 过滤得到已经选择的权限
        let selectedData = new Map(data).get(otherRoleType);
        if (!selectedData) {
            this.setState({
                otherResourceList: nowAllData
            })
            return
        }
        // 设置当前权限自动勾选
        nowAllData.map(item => {
            item.childrenResources.map((secodeRole) => {
                selectedData.appServices.map(selectRole => {
                    if (selectRole.includes(secodeRole.appService)) {
                        secodeRole['isSelect'] = true
                    }
                })
            })
        })
        this.setState({
            otherResourceList: nowAllData
        })
    }
    // 非店铺资源列表
    notShopResourcePage = () => {
        const { navigation } = this.props
        let otherRoleType = navigation.getParam('otherRoleType','')
        let roleData = navigation.getParam('roleData',[])

        requestApi.notShopResourcePage().then(res => {
            let data =[];
            res.map(i => {
                data.push([i.key,i])
            })
            let data_filter = [new Map(data).get(otherRoleType)]
            data_filter.map((item,index) => {
                if (index === 0) {
                    item['isShow'] = true
                } else {
                    item['isShow'] = false
                }
                item.childrenResources.map(resourceItem => {
                    resourceItem['isSelect'] = false
                })
            })
            this.setState({
                otherResourceList: data_filter
            })
        }).catch(err => {
            console.log(err)
        })
    }
    // 自动匹配店铺资源并自动打钩
    setShopRoleSelect = (roleData, allShopRole) => {
        // 获取所有已选择的店铺权限
        let _isSelectShop = []
        roleData.map(item => {
            if (item.permissionType==='SHOP') {
                _isSelectShop.push(item)
            }
        })
        // 已经选择的店铺，和所有的店铺匹配，如果批到了，在匹配选择的权限，如果有设置isSelect true
        _isSelectShop.map(selectItem => {
            allShopRole.map(shopItem => {
                if (selectItem.shopId === shopItem.shopId) {
                    shopItem.resource.childrenResources.map(shopRoleItem => {
                        if (selectItem.appServices.includes(shopRoleItem.appService)) {
                            shopRoleItem['isSelect'] = true
                            shopItem['isShow'] = true
                        }
                    })
                }
            })
        })
        this.setState({
            resourceList: allShopRole
        })
    }
    // 店铺资源列表
    shopResourcePage = () => {
        const { navigation, user} = this.props
        let roleData = navigation.getParam('roleData',[])
        let merchantId = user.merchantId;

        requestApi.shopResourcePage({
            merchantId,
        }).then(res => {
            try {
                res.map((shopItem,index) => {
                    if (index === 0) {
                        shopItem['isShow'] = true
                    } else {
                        shopItem['isShow'] = false
                    }
                    shopItem.resource.map((resourceItem) => {
                        resourceItem.childrenResources.map(roleItem => {
                            roleItem['isSelect'] = false
                        })
                    })
                })
                this.setState({
                    resourceList: res
                })
            } catch (error) {
                console.log(error)
            }
        }).catch(err => {
            console.log(err)
        })
    }
    // 选择某个权限
    handleSelectItem = (shopIndex,roleItemIndex,resourceIndex) => {
        const { resourceList,otherResourceList } = this.state
        const { navigation } = this.props
        let type = navigation.getParam('type','')
        if (type === 'shopRole') {
            resourceList[shopIndex].resource[resourceIndex].childrenResources[roleItemIndex].isSelect = !resourceList[shopIndex].resource[resourceIndex].childrenResources[roleItemIndex].isSelect
            // resourceList[shopIndex].resource.childrenResources[roleItemIndex].isSelect = !resourceList[shopIndex].resource.childrenResources[roleItemIndex].isSelect
            this.setState({
                resourceList,
            })
            return
        }
        otherResourceList[shopIndex].childrenResources[roleItemIndex].isSelect = !otherResourceList[shopIndex].childrenResources[roleItemIndex].isSelect
        this.setState({
            otherResourceList,
        })
    }
    // 展开关闭
    handleShow = (index) => {
        const { resourceList,otherResourceList } = this.state
        const { navigation } = this.props
        let type = navigation.getParam('type','')
        let list = type === 'shopRole' ? resourceList: otherResourceList;
        list[index].isShow = !list[index].isShow
        if (type === 'shopRole') {
            this.setState({
                resourceList,
            })
            return
        }
        this.setState({
            otherResourceList,
        })
    }
    // 保存选择的权限
    handleSaveData = async () => {
        // 回调函数，返回配置信息
        const { navigation } = this.props
        const callback = navigation.getParam('callback', () => {}) // 非修改模式的回调
        const otherRoleType = navigation.getParam('otherRoleType', () => {}) // 非修改模式的回调
        const type = navigation.getParam('type', () => {}) // 是店铺权限配置还是其他，其他(otherRoleType)又分为三种，联盟商，客服，其他
        const isUpdate = navigation.getParam('isUpdate', false) // 如果是修改权限配置，只改变点击保存后执行的回调
        const updateCallBack = navigation.getParam('updateCallBack', () => {}) // 更新权限配置回调
        const { resourceList,otherResourceList } = this.state
        if (isUpdate) { // 是修改模式
            await updateCallBack(type,otherRoleType,(type === 'shopRole') ? resourceList: otherResourceList)
            navigation.goBack()
            return
        }
        callback(type,otherRoleType,(type === 'shopRole') ? resourceList: otherResourceList)
        navigation.goBack()
    }
    // 保存的店铺权限配置
    getRoleData = (data) => {
        let roleData = this.props.navigation.getParam('roleData',[])
        if (data.length === 0) return
        if (data[0].permissionType !== 'SHOP') {
            if (roleData.length === 0) {
                return data
            } else {
                let t =null;
                roleData.map((item,index) => {
                    if (item.permissionType === data[0].permissionType) {
                        t = index
                    }
                });
                if (t !== null) {
                    roleData[t] = data[0]
                    return roleData
                } else {
                    let temp = roleData.concat(data)
                    return temp
                }
            }
        }else {
            // 删除原来的shop权限，重新push
            // let _data = JSON.parse(JSON.stringify(roleData))
            let _data = []
            roleData.map((item,index) => {
                if (item.permissionType !== "SHOP") {
                    _data.push(item)
                }
            })
            return _data.concat(data)
        }
    }
    getRoleListContent = (type) => {
        const { resourceList,otherResourceList } = this.state
        switch (type) {
            case 'shopRole':
            return (
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >
                    {
                        resourceList.length > 0 && resourceList.map((item,index) => {
                            let marginBottom = index === 0 ? {marginBottom: 0}:{marginBottom: 10};
                            return(
                                <View key={index} style={[styles.containerView,marginBottom]}>
                                    <TouchableOpacity
                                        onPress={() => {this.handleShow(index)}}
                                        style={[CommonStyles.flex_between,{paddingVertical: 15,paddingHorizontal: 15,borderBottomColor: '#f1f1f1',borderBottomWidth:0.7}]}
                                    >
                                        <View style={[CommonStyles.flex_start]}>
                                            <Text style={{fontSize: 14,color: '#222'}}>店铺名：{item.shopName}</Text>
                                        </View>
                                        <View>
                                            {
                                                (item.isShow)
                                                ?<Image source={require('../../images/shop/row_show.png')} />
                                                :<Image source={require('../../images/shop/row_close.png')} />
                                            }

                                        </View>
                                    </TouchableOpacity>
                                    <View style={[CommonStyles.flex_start,{flexWrap: 'wrap'}]}>
                                    {
                                        item.isShow && item.resource.map((resourceItem, resourceIndex) => {
                                            return resourceItem.childrenResources.map((roleItem, roleItemIndex) => {
                                                return (
                                                    <TouchableOpacity
                                                    style={[styles.roleItemWrap,CommonStyles.flex_center]}
                                                    key={roleItemIndex}
                                                    onPress={() => {this.handleSelectItem(index,roleItemIndex,resourceIndex)}}>
                                                        {
                                                            (roleItem.isSelect)
                                                            ?<Image style={styles.selectImg} source={require("../../images/index/select.png")} />
                                                            : <Image style={styles.selectImg} source={require("../../images/index/unselect.png")} />
                                                        }
                                                        <Image style={{width: 22,height: 22}} source={roleItem.icon ? {uri: roleItem.icon} : defaultImage} />
                                                        <Text style={{fontSize: 12,color: '#222',marginTop: 5}}>{roleItem.name=='本地联盟商群'?'联盟商群':roleItem.name}</Text>
                                                    </TouchableOpacity>
                                                )
                                            })
                                        })
                                    }
                                    </View>
                                </View>
                            )
                        })
                    }
                </ScrollView>

            )
            case 'otherRole':
            return (
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >
                    {
                        otherResourceList.length > 0 && otherResourceList.map((item,index) => {
                            let marginBottom = index === 0 ? {marginBottom: 0}:{marginBottom: 10};
                            return(
                                <View key={index} style={[styles.containerView,marginBottom]}>
                                    <View
                                    // onPress={() => {this.handleShow(index)}}
                                    style={[CommonStyles.flex_between,{paddingVertical: 15,paddingHorizontal: 15,borderBottomColor: '#f1f1f1',borderBottomWidth:0.7}]}>
                                        <View style={[CommonStyles.flex_start]}>
                                            <Text style={{fontSize: 14,color: '#222'}}>{item.name=='本地联盟商群'?'联盟商群':item.name}</Text>
                                        </View>
                                        {/* <View>
                                            {
                                                (item.isShow)
                                                ?<Image source={require('../../images/shop/row_show.png')} />
                                                :<Image source={require('../../images/shop/row_close.png')} />
                                            }

                                        </View> */}
                                    </View>
                                    <View style={[CommonStyles.flex_start,{flexWrap: 'wrap'}]}>
                                    {
                                        item.isShow && item.childrenResources.map((roleItem, roleItemIndex) => {
                                            return (
                                                <TouchableOpacity
                                                style={[styles.roleItemWrap,CommonStyles.flex_center]}
                                                key={roleItemIndex}
                                                onPress={() => {this.handleSelectItem(index,roleItemIndex)}}>
                                                    {
                                                        (roleItem.isSelect)
                                                        ?<Image style={styles.selectImg} source={require("../../images/index/select.png")} />
                                                        : <Image style={styles.selectImg} source={require("../../images/index/unselect.png")} />
                                                    }
                                                    <Image style={{width: 22,height: 22}} source={roleItem.icon ? {uri: roleItem.icon}: defaultImage} />
                                                    <Text style={{fontSize: 12,color: '#222',marginTop: 5}}>{roleItem.name=='本地联盟商群'?'联盟商群':roleItem.name}</Text>
                                                </TouchableOpacity>
                                            )
                                        })
                                    }
                                    </View>
                                </View>
                            )
                        })
                    }
                </ScrollView>
            )
        }
    }
    render() {
        const { navigation} = this.props;
        const type = navigation.getParam('type', () => {})
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"权限配置"}
                    rightView={
                        <TouchableOpacity
                            onPress={() => {this.handleSaveData()}}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                保存
                            </Text>
                        </TouchableOpacity>
                    }
                />
                {
                    this.getRoleListContent(type)
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    containerView: {
        backgroundColor: '#fff',
        borderRadius: 6,
        borderWidth: 0.7,
        borderColor: 'rgba(215,215,215,0.2)',
        margin: 10,
        // marginBottom: 0,
    },
    roleItemWrap: {
        width: (width - 22) / 4,
        padding: 15,
        paddingHorizontal: 8,
        position: 'relative',
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 0.7,
    },
    selectImg: {
        position: 'absolute',
        top: 7,
        right: 5,
        width:18,
        height:18
    },
});

export default connect(
    state => ({
        user:state.user.user || {}
     }),
)(AccountShopRole);
