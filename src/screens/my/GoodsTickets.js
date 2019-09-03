/**
 * 我的/单品优惠券
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
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import ScrollableTabView from "react-native-scrollable-tab-view";
import { NavigationPureComponent } from "../../common/NavigationComponent";
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

class GoodsTickets extends NavigationPureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            listName: 'goodsTickets0',
            data: [],
            confirmVisible: false,
            deleteIndex: 0, //要删除的项
            currentShop: props.userShop, //选择的店铺
            visible: false,
            currentTab:0
        };
    }

    blurState = {
        visible: false,
        confirmVisible: false,
    }

    getList = (isFirst = false, isLoadingMore = false,loading=true,refreshing=true) => {
        const {currentTab,listName}=  this.state
        this.props.fetchList({
            witchList:listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {type: currentTab===0?'unused':currentTab===1?'used':'invalid' },
            api:requestApi.shopAppUserCouponQPage,
            loading,
            refreshing
        })
    };

    componentDidMount() {
        this.getList(true, false);
    }

    quit = (data, index) => {
        //作废
        this.setState({
            confirmVisible: true,
            deleteIndex: index,
            deleteId: data.id
        });
    };

    renderItem = ({ item, index }) => {
        const { currentShop, listName,currentTab } = this.state;
        const { navigation ,longLists} = this.props;
        item.startTime = item.validTime?moment(item.validTime*1000).format('YYYY-MM-DD HH:mm'):'';;
        item.endTime = item.invalidTime?moment(item.invalidTime*1000).format('YYYY-MM-DD HH:mm'):'';
        let length = longLists[listName] && longLists[listName].lists && longLists[listName].lists.length || 0

        return (
            <View
                style={[styles.item, { marginBottom: index == length - 1 ? 5 : 0 }]}
            >
                <View style={styles.top}>
                    <View style={styles.topLeft}>
                        <View
                            style={[
                                styles.topLeftBOrder,
                                {
                                    backgroundColor: currentTab!=0
                                        ? "#999999"
                                        : CommonStyles.globalHeaderColor
                                }
                            ]}
                        />
                        <Text style={[ styles.title, { color:currentTab!=0 ? "#999999" : CommonStyles.globalHeaderColor,flex:1  } ]}  >
                            {item.couponName}
                        </Text>
                    </View>
                    <View
                        style={[
                            styles.topRight,
                            {
                                backgroundColor: currentTab!=0
                                    ? "#CCCCCC"
                                    : CommonStyles.globalHeaderColor
                            }
                        ]}
                    >
                        <Text style={{ fontSize: 12, color: "#fff" }}>
                            {currentTab===0?'未使用':currentTab===1?'已使用':'已过期'}
                        </Text>
                    </View>
                </View>
                <View style={styles.distribution}>
                    <Text style={styles.disText}>编号{item.couponId}</Text>
                </View>
                <Text
                    style={[
                        styles.fanwei,
                        {
                            color: currentTab!=0
                                ? "#555555"
                                : CommonStyles.globalHeaderColor
                        }
                    ]}
                >
                    适用商品：{item.goodsName}
                </Text>
                <Text style={[styles.time, { marginTop: 9 }]}>
                    有效时间：{item.startTime} 至 {item.endTime}
                </Text>
            </View>
        );
    };
    changeTab=(index)=>{
        const {longLists}=this.props
        this.setState({
            currentTab: index,
            listName: 'goodsTickets' + index
        }, () => {
            const {listName}=this.state
            const isExist=longLists[listName] && longLists[listName].lists.length>0
            this.getList(false, false,true,!isExist);
        });
    }

    render() {
        const { navigation,longLists,juniorShops} = this.props;
        const { data, visible, currentShop, listName } = this.state;
        const items = [
            { count: 8, isWork: 0, type: "打折券", fanwei: "单品" },
            { count: 9, isWork: 1, type: "抵扣券", fanwei: "品类" },
            { count: 7, isWork: 2, type: "优惠券", fanwei: "全场" }
        ];
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title="单品优惠券"
                />
                 <ScrollableTabView
                    initialPage={0}
                    onChangeTab={({ i }) => {
                        this.changeTab(i);
                    }}
                    renderTabBar={() => (
                        <ScrollableTabBar
                            underlineStyle={{
                                backgroundColor: "#fff",
                                height: 8,
                                borderRadius: 10,
                                marginBottom: -5,
                                // width: "25%",
                                // marginLeft: "10%"
                            }}
                            tabsContainerStyle={{
                                width:width,
                            }}
                            tabStyle={{
                                backgroundColor: "#4A90FA",
                                height: 44,
                                paddingBottom: -4
                            }}
                            activeTextColor="#fff"
                            inactiveTextColor="rgba(255,255,255,.5)"
                            tabBarTextStyle={{ fontSize: 14 }}
                            style={{
                                backgroundColor: "#4A90FA",
                                height: 44,
                                borderBottomWidth: 0,
                                overflow: "hidden"
                            }}
                        />
                    )}
                >
                    {['未使用','使用记录','已过期'].map((itemTab, index) => {
                        return (
                            <FlatListView
                                type='N42_singleGoodsCoupon'
                                key={index}
                                tabLabel={itemTab}
                                style={[
                                    styles.content,
                                    { backgroundColor: CommonStyles.globalBgColor }
                                ]}
                                renderItem={data => this.renderItem(data)}
                                store={{
                                    ...longLists[listName],
                                    page: longLists[listName] && longLists[listName].listsPage || 1,
                                }}
                                data={longLists[listName] && longLists[listName].lists || []}
                                numColumns={1}
                                refreshData={() => this.getList(false, false)}
                                loadMoreData={() => this.getList(false, true)}
                            />
                        );
                    })}
                </ScrollableTabView>


                <Model
                    type={"confirm"}
                    title={"确定要作废？"}
                    confirmText="作废后该卡无法恢复"
                    visible={this.state.confirmVisible}
                    onShow={() => this.setState({ confirmVisible: true })}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ confirmVisible: false })}
                />
                {this.state.visible ? (
                    <TouchableOpacity
                        style={styles.modal}
                        onPress={() => {
                            this.setState({ visible: false });
                        }}
                    >
                        <View style={styles.modalView}>
                            <ScrollView>
                                {juniorShops.map(
                                    (item, index) => {
                                        return (
                                            <TouchableOpacity
                                                style={styles.line}
                                                key={index}
                                                onPress={() => {
                                                    this.setState(
                                                        {
                                                            visible: false,
                                                            currentShop: item
                                                        },
                                                        () => {
                                                            this.getList(
                                                                false,
                                                                false
                                                            );
                                                        }
                                                    );
                                                }}
                                            >
                                                <Text
                                                    style={{
                                                        fontSize: 14,
                                                        color: "#222222",
                                                        textAlign: "center"
                                                    }}
                                                >
                                                    {item.name}
                                                </Text>
                                            </TouchableOpacity>
                                        );
                                    }
                                )}
                            </ScrollView>
                        </View>
                    </TouchableOpacity>
                ) : null}
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
        paddingBottom: 15,
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
        // alignItems: "center",
        flex:1,
        marginRight:10
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
        overflow: "hidden",
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
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
        juniorShops:state.shop.juniorShops || [state.user.userShop || {}],
     }),
    {
        fetchList: (params={})=> ({ type: "shop/getList", payload: params}),
        shopSave: (params={})=>({ type: "shop/save", payload: params}),
     }
)(GoodsTickets);
