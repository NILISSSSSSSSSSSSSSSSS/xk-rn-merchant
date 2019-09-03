/**
 * 账号管理/店铺权限设置
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
    Switch
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
import Styles from "../../common/Styles";

const { width, height } = Dimensions.get("window");

class AccountLimitSettingScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            requesParams: {},
            types: [],
            serviceNames: [], //选中的权限
            page: "", //新增还是修改
            items: [],
            selectFirstLimitIndex: null //选中的权限下标
        };
    }
    componentDidMount() {
        requestApi.mShopResourceQPage({ limit: 0, page: 0 }).then(data => {
            data = data.data;
            const { navigation } = this.props;
            const params = navigation.state.params;
            console.log("params", params);
            let selectFirstLimitIndex = null;

            for (let i = 0; i < data.length; i++) {
                data[i].value = false;
                if (params && params.serviceNames) {
                    for (item of params.serviceNames) {
                        if (item == data[i].mobileService) {
                            data[i].value = true;
                            selectFirstLimitIndex = i;
                        }
                    }
                    if (
                        data[i].shopResources &&
                        data[i].shopResources.length > 0
                    ) {
                        for (let j = 0; j < data[i].shopResources.length; j++) {
                            let index = params.serviceNames.indexOf(
                                data[i].shopResources[j].mobileService
                            );
                            index > 0 || index == 0
                                ? (data[i].shopResources[j].value = true)
                                : (data[i].shopResources[j].value = false);
                        }
                    }
                }
            }
            this.setState({
                items: data,
                serviceNames: (params && params.serviceNames) || [],
                selectFirstLimitIndex: selectFirstLimitIndex
            });
        }).catch(err => {
            console.log(err)
        });
        // let shopItems = [
        //     { title: '收款二维码', icon: require('../../images/index/qrcode.png'), route: 'Receipt', value: false },
        //     { title: '扫码', icon: require('../../images/index/scan.png'), route: 'Scan', value: false },
        //     { title: '授权管理', icon: require('../../images/index/shouquan_manage.png'), route: 'Scan', value: false },
        //     { title: '促销管理', icon: require('../../images/index/cuxiaoguanli.png'), route: 'Sale', value: false },
        //     { title: '评价管理', icon: require('../../images/index/comment_manage.png'), route: 'Comment', value: false },
        //     { title: '订单管理', icon: require('../../images/index/order_manage.png'), route: 'SOMOrder', value: false },
        //     { title: '品类管理', icon: require('../../images/index/pinlei_manage.png'), route: 'Category', value: false },
        //     { title: '商品管理', icon: require('../../images/index/goods_manage.png'), route: 'Goods', value: false },
        //     { title: '席位管理', icon: require('../../images/index/seat_manage.png'), route: 'Seat', value: false },
        //     { title: '数据中心', icon: require('../../images/index/datas.png'), route: 'Datas', value: false },
        //     { title: '财务中心', icon: require('../../images/index/chaiwuzhongxin.png'), route: 'Finance', value: false },
        //     { title: '银行卡设置', icon: require('../../images/index/bank_set.png'), route: 'Bankcard', value: false },
        //     { title: '账号管理', icon: require('../../images/index/account_manage.png'), route: 'Account', value: false },
        //     { title: '修改支付密码', icon: require('../../images/index/pay_pass.png'), route: 'Scan', value: false },
        //     { title: '常见问题', icon: require('../../images/index/changjianwenti.png'), route: 'Scan', value: false },

        // ]
        // const { navigation } = this.props
        // const params = navigation.state.params
        // console.log(params)
        // if (params && params.serviceNames) {
        //     for (item of params.serviceNames) {
        //         for (itemShop of shopItems) {
        //             item == itemShop.title ? itemShop.value = true : null
        //         }
        //     }
        // }
        // this.setState({
        //     shopItems: shopItems,
        //     serviceNames: navigation.state.params && navigation.state.params.serviceNames
        // })
    }
    componentWillUnmount() {}
    saveEditor = () => {
        const { serviceNames } = this.state;
        if (serviceNames.length == 0) {
            return;
        }
        const navigation = this.props.navigation;
        const currentAccount = navigation.state.params.currentAccount;
        if (currentAccount) {
            Loading.show();
            const params = {
                employeeId: currentAccount.id,
                phone: currentAccount.phone,
                name: currentAccount.realName,
                userPermissions: [
                    {
                        shopId: this.props.userShop.id,
                        mobileServiceNames: serviceNames,
                        pcServiceNames: []
                    }
                ]
            };
            requestApi
                .employeeUpdate(params)
                .then(data => {
                    Loading.hide();
                    navigation.state.params.callback();
                    navigation.goBack();
                })
                .catch(error => {
                    Loading.hide();
                });
        } else {
            navigation.state.params &&
                navigation.state.params.callback(serviceNames);
            navigation.goBack();
        }
    };
    changeServiceNames = (item, index) => {
        let serviceNames = [...this.state.serviceNames];
        !item.value
            ? (serviceNames = serviceNames.filter(
                  name => name != item.mobileService
              ))
            : serviceNames.push(item.mobileService);
        return serviceNames;
    };
    selectItem = (witch, index) => {
        const { items, selectFirstLimitIndex, serviceNames } = this.state;
        let newServiceNames = [...serviceNames];
        let newItems = [...items];
        if (witch == "items") {
            newItems[index].value = !newItems[index].value;
            this.setState({
                items: newItems,
                serviceNames: this.changeServiceNames(newItems[index], index)
            });
        } else {
            let item = newItems[selectFirstLimitIndex];
            let shopResources = item && item.shopResources;
            shopResources[index].value = !shopResources[index].value;
            if (shopResources[index].value) {
                newServiceNames.push(shopResources[index].mobileService);
                if (!items[selectFirstLimitIndex].value) {
                    item.value = true;
                    newServiceNames.push(item.mobileService);
                }
            } else if (!shopResources[index].value) {
                newServiceNames = newServiceNames.filter(
                    name =>
                        name != newItems[selectFirstLimitIndex].mobileService
                );
                let exist = false;
                for (let source of shopResources) {
                    source.value ? (exist = true) : null;
                }
                if (newItems[selectFirstLimitIndex].value && !exist) {
                    newItems[selectFirstLimitIndex].value = false;
                    newServiceNames = newServiceNames.filter(
                        name =>
                            name !=
                            newItems[selectFirstLimitIndex].mobileService
                    );
                }
            }

            this.setState({
                items: newItems,
                serviceNames: newServiceNames
            });
        }
        // const newItems = []
        // for (item of items) {
        //     newItems.push(item)
        // }
        // newItems[index].value = !newItems[index].value
        // this.setState({
        //     [witch]: newItems,
        //     serviceNames: this.changeServiceNames()
        // })
    };

    render() {
        const { navigation} = this.props;
        const {
            requesParams,
            items,
            serviceNames,
            selectFirstLimitIndex
        } = this.state;
        const shopItems =
            (items[selectFirstLimitIndex] &&
                items[selectFirstLimitIndex] &&
                items[selectFirstLimitIndex].shopResources) ||
            [];

        return (
            <View style={styles.container}>
                <Header
                    title="权限配置"
                    navigation={navigation}
                    goBack={true}
                    rightView={
                        <TouchableOpacity
                            onPress={() => this.saveEditor()}
                            style={{ width: 50 }}
                        >
                            <Text
                                style={{
                                    fontSize: 17,
                                    color: serviceNames.length == 0 ? "gray" : "#fff"
                                }}
                            >
                                保存
                            </Text>
                        </TouchableOpacity>
                    }
                />
                <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }}>
                    <Content
                        style={{
                            marginLeft: 10,
                            marginTop: 10,
                            marginBottom: 5
                        }}
                    >
                        {items.map((item, index) => {
                            return (
                                <View
                                    key={index}
                                    style={{ position: "relative" }}
                                >
                                    <Line
                                        title={item.name}
                                        point={null}
                                        style={{
                                            justifyContent: "space-between",
                                            paddingVertical: 0
                                        }}
                                        type={"custom"}
                                        onPress={() => {
                                            this.setState({
                                                selectFirstLimitIndex: index
                                            });
                                        }}
                                        rightView={
                                            <TouchableOpacity
                                                style={{
                                                    width: 50,
                                                    height: 50,
                                                    alignItems: "center",
                                                    justifyContent: "center"
                                                }}
                                                onPress={() =>
                                                    this.selectItem(
                                                        "items",
                                                        index
                                                    )
                                                }
                                            >
                                                <ImageView
                                                    source={
                                                        item.value
                                                            ? require("../../images/index/select.png")
                                                            : require("../../images/index/unselect.png")
                                                    }
                                                    sourceWidth={14}
                                                    sourceHeight={14}
                                                />
                                            </TouchableOpacity>
                                        }
                                    />
                                </View>
                            );
                        })}
                    </Content>
                    {items[selectFirstLimitIndex] &&
                    items[selectFirstLimitIndex].name ? (
                        <Content
                            style={{
                                marginLeft: 10,
                                marginTop: 5,
                                marginBottom: 5
                            }}
                        >
                            <Text style={styles.title}>
                                {items[selectFirstLimitIndex].name}
                            </Text>
                            <View style={styles.shopRight}>
                                {shopItems.map((item, index) => {
                                    return (
                                        <TouchableOpacity
                                            key={index}
                                            onPress={() =>
                                                this.selectItem(
                                                    "shopItems",
                                                    index
                                                )
                                            }
                                            style={[
                                                styles.contentBottomItem,
                                                {
                                                    borderBottomWidth:
                                                        index >
                                                        shopItems.length - 4
                                                            ? 0
                                                            : 1
                                                }
                                            ]}
                                        >
                                            {/* <ImageView
                                                                    source={item.icon}
                                                                    sourceWidth={20}
                                                                    sourceHeight={20}
                                                                /> */}
                                            <Text
                                                style={{
                                                    color: "#222222",
                                                    fontSize: 12,
                                                    marginTop: 15
                                                }}
                                            >
                                                {item.name}
                                            </Text>
                                            <ImageView
                                                source={
                                                    item.value
                                                        ? require("../../images/index/select.png")
                                                        : require("../../images/index/unselect.png")
                                                }
                                                sourceWidth={14}
                                                sourceHeight={14}
                                                style={{
                                                    position: "absolute",
                                                    right: 10,
                                                    top: 6
                                                }}
                                            />
                                        </TouchableOpacity>
                                    );
                                })}
                            </View>
                        </Content>
                    ) : null}
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        backgroundColor: CommonStyles.globalBgColor
    },
    contentBottomItem: {
        width: (width - 20) / 4,
        height: (width - 20) / 4,
        alignItems: "center",
        justifyContent: "center",
        borderColor: "#F1F1F1",
        position: "relative"
    },
    title: {
        paddingVertical: 15,
        paddingHorizontal: 15,
        borderColor: "#F1F1F1",
        borderBottomWidth: 1,
        fontSize: 14,
        color: "#222222"
    },
    shopRight: {
        flexDirection: "row",
        alignItems: "center",
        flexWrap: "wrap",
        width: width - 20
    }
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
     })
)(AccountLimitSettingScreen);
