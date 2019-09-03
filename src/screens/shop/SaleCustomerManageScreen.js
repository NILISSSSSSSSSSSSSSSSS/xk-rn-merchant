/**
 * 促销管理/会员卡管理
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    Image,
    TouchableOpacity,
    ScrollView,
    Platform
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import FlatListView from "../../components/FlatListView";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import * as utils from "../../config/utils";
import ImageView from "../../components/ImageView";
import Line from "../../components/Line";
import moment from "moment";
import Model from "../../components/Model";
import { NavigationPureComponent } from "../../common/NavigationComponent";
import math from '../../config/math.js';
const ticketsTypes = [
    //优惠券类型 折扣券DISCOUNT,抵扣券 DEDUCTION, 满减券 FULL_SUB
    { key: "DISCOUNT", type: "折扣券" },
    { key: "DEDUCTION", type: "抵扣券" },
    { key: "FULL_SUB", type: "满减券" }
];
const ticketsScopes = [
    //优惠范围 GOODS, 全场ALL,商品品类CATEGORY
    { key: "GOODS", type: "单品" },
    { key: "CATEGORY", type: "品类" },
    { key: "ALL", type: "全场" }
];
const { width, height } = Dimensions.get("window");

class SaleCustomerManage extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        let page = (props.navigation.state.params &&
            props.navigation.state.params.page) ||
            "card"
        this.state = {
            page,
            data: [],
            confirmVisible: false,
            deleteIndex: 0, //要删除的项
            currentShop: props.userShop, //选择的店铺
            listName: 'sale' + page,
        };
    }

    getList = (isFirst = false, isLoadingMore = false) => {
        let func =this.state.page == "card"
                ? requestApi.getShopCards
                : requestApi.mUserCardCouponQPage;
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {storeId: this.state.currentShop.id},
            api:func
        })
    };

    componentDidMount() {
        this.getList(true, false);
    }

    componentWillUnmount() {
        RightTopModal.hide()
     }
    quit = (data, index) => {
        //作废
        this.setState({
            confirmVisible: true,
            deleteIndex: index,
            deleteId: data.id
        });
    };
    delete = () => {
        const { user,longLists} = this.props;
        const {listName}=this.state
        const params = {
            id: this.state.deleteId,
            shopId: this.state.currentShop.id,
            updateId: user.id,
            userId: user.id
        };
        let func =
            this.state.page == "card"
                ? requestApi.mUserCardMemberDelete
                : requestApi.mUserCardCouponDelete;
        func(params).then(res => {
            this.setState({
                confirmVisible: false
            });
            Toast.show("操作成功");
            let newList = [...longLists[listName].lists];
            if (this.state.page == "card") {
                newList[this.state.deleteIndex].cardStatus = "OVERDUE";
            } else {
                newList[this.state.deleteIndex].couponStatus = "STOP";
            }
            this.props.shopSave({
                longLists: {
                    ...longLists,
                    [listName]: {
                        ...longLists[listName],
                        lists: newList
                    }
                }
            })
        }).catch(()=>{
          
        });
    };

    renderItem = ({ item, index }) => {
        const { page, currentShop,listName } = this.state;
        const {  navigation,longLists } = this.props;
        let length = longLists[listName] && longLists[listName].lists && longLists[listName].lists.length || 0
        item.startTime = item.validTime?moment(item.validTime*1000).format('YYYY-MM-DD HH:mm'):'';
        item.endTime = item.invalidTime?moment(item.invalidTime*1000).format('YYYY-MM-DD HH:mm'):'';
        let newStatus = page == "card" ? item.cardStatus : item.couponStatus;
        switch (newStatus) {
            case "All":
                item.status = "全部";
                break;
            case "VALIDING":
                item.status = "生效中";
                break;
            case "WAIT_VALID":
                item.status = "待生效";
                break;
            case "OVERDUE":
                item.status = "已过期";
                break;
            case "STOP":
                item.status = "已作废";
                break; //停发
        }
        let useLessStatus =
            item.status === "已作废" ||
            item.status === "已过期" ||
            item.status === "停发";
        // 状态，枚举：All 全部, VALIDING 生效中, WAIT_VALID 等待生效,OVERDUE 已过期,STOP 停发
        let name = "";
        if (page == "card") {
            name = (item.name || "普通会员卡 ") +math.divide(item.discount,100)  + "折";
        } else {
            for (itemType of ticketsTypes) {
                if (itemType.key == item.couponType) {
                    name = item.name + itemType.type;
                    item.ticketype = itemType.type;
                }
            }
            for (itemScope of ticketsScopes) {
                itemScope.key == item.couponScope
                    ? (item.fanwei = itemScope.type)
                    : null;
            }
        }
        return (
            <View  style={[styles.item,{marginBottom:index ==length - 1? 5: 0}]} >
                <View style={styles.top}>
                    <View style={styles.topLeft}>
                        <View
                            style={[
                                styles.topLeftBOrder,
                                {backgroundColor: useLessStatus? "#999999": CommonStyles.globalHeaderColor}
                            ]}
                        />
                        <Text
                            style={[
                                styles.title,
                                {color: useLessStatus ? "#999999" : CommonStyles.globalHeaderColor}
                            ]}
                        >
                            {name}
                        </Text>
                    </View>
                    <View style={[styles.topRight,{backgroundColor: useLessStatus? "#CCCCCC" : CommonStyles.globalHeaderColor}]}>
                        <Text style={{ fontSize: 12, color: "#fff" }}>
                            {item.status}
                        </Text>
                    </View>
                </View>
                <View style={styles.distribution}>
                    <Text style={styles.disText}>编号{item.id}</Text>
                </View>
                <View style={[styles.distribution, { marginTop: 2 }]}>
                    <Text style={[styles.disText, { marginRight: 10 }]}>
                        总量： {item.totalNum}
                    </Text>
                    <Text style={styles.disText}>已领： {item.num}</Text>
                </View>

                {page == "card" ? null : (
                    <Text style={[styles.fanwei,{color: useLessStatus ? "#555555": CommonStyles.globalHeaderColor}]}>
                        范围：{item.fanwei}
                    </Text>
                )}

                <Text style={[ styles.time, { marginTop: page == "card" ? 20 : 9 } ]}>
                    生效时间：{item.startTime} 至 {item.endTime}
                </Text>
                {useLessStatus ? (
                    <TouchableOpacity
                        style={styles.butView}
                        onPress={() =>
                            navigation.navigate("SaleCardDetail", {
                                page: page,
                                listName,
                                currentData: item,
                                opretaIndex: index,
                                currentShop: currentShop,
                                callback:()=>this.getList(true,false)
                            })
                        }
                    >
                        <Text style={[styles.butText,{ color: "#4A90FA", width: "100%" }]}  >
                            查看
                        </Text>
                    </TouchableOpacity>
                ) : (
                        <View style={styles.butView}>
                            <TouchableOpacity
                                style={styles.butView1}
                                onPress={() => this.quit(item, index)}
                            >
                                <Text style={styles.butText}>作废</Text>
                            </TouchableOpacity>
                            <TouchableOpacity
                                style={[styles.butView1,{borderLeftWidth: 1,borderLeftColor: "#F1F1F1"}]}
                                onPress={() =>
                                    navigation.navigate("SaleCardDetail", {
                                        listName,
                                        page: page,
                                        currentData: item,
                                        opretaIndex: index,
                                        currentShop: currentShop,
                                        callback:()=>this.getList(true,false)
                                    })
                                }
                            >
                                <Text style={styles.butText}>查看</Text>
                            </TouchableOpacity>
                        </View>
                    )}
            </View>
        );
    };
    showPopover() {
        let options=[]
        options=[...this.props.juniorShops]
        options.map(item=>{
            item.title=item.name
            item.onPress=()=>{
                this.setState(
                    {
                        currentShop: item
                    },
                    () => {
                        this.getList(false,false);
                    }
                );
            }
        })
        RightTopModal.show({
           options,
            children:<View style={{position:'absolute',top:Platform.OS=='ios'? 0:-CommonStyles.headerPadding}}>{this.renderHeader()}</View>,
            sanjiaoStyle:{right:60}
        })
    }
    renderHeader=()=>{
        const { navigation } = this.props;
        const { page,  currentShop } = this.state;
        return(
            <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ flex: 1, alignItems: "center" }} >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                {page == "card" ? "会员卡管理" : "优惠券管理"}
                            </Text>
                            <TouchableOpacity
                                onPress={() => this.showPopover()}
                                style={{ width: 50,position: "absolute",right: 0,top: 0}}
                            >
                                <Text style={{ fontSize: 17, color: "#fff" }}>
                                    筛选
                                </Text>
                            </TouchableOpacity>
                        </View>
                    }
                    rightView={
                        <TouchableOpacity
                            onPress={() => {
                                navigation.navigate("SaleAddCard", {
                                    page: page,
                                    callback: () => this.getList(),
                                    currentShop
                                });
                            }}
                            style={{ width: 50 }}
                        >
                            <Text style={{ fontSize: 17, color: "#fff" }}>
                                新增
                            </Text>
                        </TouchableOpacity>
                    }
                />
        )
    }

    render() {
        const { navigation,longLists } = this.props;
        const { page, data, currentShop, listName,confirmVisible } = this.state;
        const items = [
            { count: 8, isWork: 0, type: "打折券", fanwei: "单品" },
            { count: 9, isWork: 1, type: "抵扣券", fanwei: "品类" },
            { count: 7, isWork: 2, type: "优惠券", fanwei: "全场" }
        ];

        return (
            <View style={styles.container}>
                {this.renderHeader()}
                <FlatListView
                    type={page=='card'?'L2_memberCardManage':'L6_couponManage'}
                    style={[
                        styles.content,
                        { backgroundColor: CommonStyles.globalBgColor }
                    ]}
                    ListHeaderComponent={() => {
                        return (
                            <View style={{ flexDirection: "row" }}>
                                <View style={styles.shopNameView}>
                                    <Text
                                        style={{ color: "#fff", fontSize: 14 }}
                                    >
                                        {currentShop.name}
                                    </Text>
                                </View>
                            </View>
                        );
                    }}
                    renderItem={data => this.renderItem(data)}
                    store={{
                        ...longLists[listName],
                        page:longLists[listName] && longLists[listName].listsPage || 1
                    }}
                    data={longLists[listName] && longLists[listName].lists || []}
                    numColumns={1}
                    refreshData={() => this.getList(false, false)}
                    loadMoreData={() => this.getList(false, true)}
                />
                <Model
                    type={"confirm"}
                    title={"确定要作废？"}
                    confirmText="作废后该卡无法恢复"
                    visible={confirmVisible}
                    onShow={() => this.setState({ confirmVisible: true })}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ confirmVisible: false })}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        position: "relative"
    },
    content: {
        width: width
    },
    modal: {
        width: width,
        height: height - 44 - CommonStyles.headerPadding,
        marginTop: 44 + CommonStyles.headerPadding,
        alignItems: "flex-end",
        backgroundColor: "rgba(0,0,0,0.5)",
        position: "absolute",
        top: 0,
        left: 0
    },
    time: {
        color: "#777777",
        fontSize: 10,
        marginTop: 30,
        paddingLeft: 15
    },
    distText: {
        color: "#555555",
        fontSize: 12
    },
    butView: {
        // flex:1,
        height: 44,
        flexDirection: "row",
        alignItems: "center",
        borderTopWidth: 1,
        borderColor: "#F1F1F1",
        marginTop: 10
    },
    butView1: {
        justifyContent: "center",
        alignItems: "center",
        height: 44,
        width: (width - 20) / 2,
        lineHeight: 44
    },
    butText: {
        fontSize: 14,
        color: "#D1B402",
        textAlign: "center"
    },
    item: {
        borderRadius: 10,
        backgroundColor: "#fff",
        width: width - 20,
        marginLeft: 10,
        // ...CommonStyles.shadowStyle
    },
    top: {
        width: width - 20,
        flexDirection: "row",
        justifyContent: "space-between",
        marginTop: 15
    },
    topLeft: {
        flexDirection: "row",
        alignItems: "center"
    },
    title: {
        color: "#4A90FA",
        fontSize: 17
    },
    topLeftBOrder: {
        width: 5,
        backgroundColor: "#4A90FA",
        height: 20,
        borderTopRightRadius: 8,
        borderBottomRightRadius: 8,
        marginRight: 10
    },
    topRight: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#4A90FA",
        paddingRight: 10,
        paddingLeft: 15,
        borderTopLeftRadius: 15,
        borderBottomLeftRadius: 15,
        lineHeight: 20,
        height: 20
    },
    distribution: {
        flexDirection: "row",
        alignItems: "center",
        paddingLeft: 15,
        marginTop: 8,
        flexWrap: "wrap"
    },
    disText: {
        color: "#555555",
        fontSize: 12,
        paddingRight: 10,
        borderColor: "#999999"
    },
    fanwei: {
        color: CommonStyles.globalHeaderColor,
        fontSize: 12,
        marginTop: 8,
        paddingLeft: 15
    },
    modalView: {
        width: 168,
        // borderWidth: 1,
        borderColor: "#DDDDDD",
        borderBottomLeftRadius: 10,
        marginLeft: 25,
        position:'relative',
        backgroundColor: "white",
        maxHeight: 250,
        overflow:'hidden'
    },
    line: {
        padding: 15,
        borderBottomWidth: 1,
        borderColor: "#F1F1F1"
    },
    shopNameView: {
        backgroundColor: "#8FB8F8",
        borderRadius: 10,
        alignItems: "center",
        paddingVertical: 6,
        paddingHorizontal: 15,
        marginVertical: 10,
        marginLeft: 25
    }
});

export default connect(
    state => ({
        longLists:state.shop.longLists || {},
        userShop:state.user.userShop || {},
        user:state.user.user || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
    }),
    dispatch=>({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
    })
)(SaleCustomerManage);
