/**
 * 账号管理
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
    TouchableHighlight
} from "react-native";
import { connect } from "rn-dva";
import FlatListView from "../../components/FlatListView";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import * as utils from "../../config/utils";
const { width, height } = Dimensions.get("window");
import SwipeListView from "../../components/SwipeListView";

class AccountScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    _didFocusSubscription;
    constructor(props) {
        super(props);
        const listName='account'
        this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) =>{
            props.longLists[listName]&& props.longLists[listName].lists?this.getList(true, false):null
        });
        this.state = {
            listName,
            shopId: props.userShop.id,
            deleteIndex: 0, //要删除的项
            rowMap: {},
            rowKey: "",
        };
    }

    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    componentDidMount() {
        this.props.longLists[this.state.listName]?null:this.getList(true, false);
    }
    // 获取员工类型
    getAccountType = (employeeType) => {
        return (this.props.merchant.find(item=>item.merchantType==employeeType) || {}).name
        // switch (employeeType) {
        //     case 'personal': return '个人'
        //     case 'anchor': return '主播'
        //     case 'company': return '公司(合伙人)'
        //     case 'shops': return '商户'
        //     case 'familyL1': return '普通家族（家族长）'
        //     case 'familyL2': return '钻石家族（公会）'
        // }
    }
    getList = (isFirst = false, isLoadingMore = false) => {
        this.closeRow();
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            api:requestApi.employeeQPage
        })
    };
    closeRow = () => {
        const { rowMap, rowKey } = this.state;
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    };

    renderItem = (item,index, viewStyle) => {
        return (
            <TouchableHighlight
                style={viewStyle}
                underlayColor="#f1f1f1"
                activeOpacity={0.5}
                onPress={() => {
                    this.closeRow();
                    this.setState({
                        isGoDetail: true
                    })
                    this.props.navigation.navigate("AccountDetail", {
                        id: item.userId
                    });
                }}
            >
                <View style={[styles.item]}>
                    <View style={[styles.line, { marginBottom: 15 }]}>
                        <Text style={styles.name}>
                            {item.realName}
                            {/* <Text style={{ color: "#777777" }}>({item.employeeCode})</Text> */}
                        </Text>
                        <Text style={styles.smallText}>
                            {this.getAccountType(item.merchantType)}
                        </Text>
                    </View>
                    <View style={styles.line}>
                        <Text style={[styles.smallText, { fontSize: 14 }]}>
                            {item.phone}
                        </Text>
                        <Text style={styles.smallText}>
                            {item.shopNames && item.shopNames.join("，")}
                        </Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    };
    onRowDidOpen = (rowKey, rowMap) => {
        console.log("This row opened", rowKey);
        this.setState({ rowMap, rowKey });
    };

    render() {
        const { navigation, longLists } = this.props;
        const { listName } = this.state
        let length = longLists[listName] && longLists[listName].lists && longLists[listName].lists.length || 0
        const viewStyle = index => {
            return {
                borderTopLeftRadius: index == 0 ? 8 : 0,
                borderTopRightRadius: index == 0 ? 8 : 0,
                borderBottomLeftRadius:index == length - 1 ? 8 : 0,
                borderBottomRightRadius:index == length - 1 ? 8 : 0,
                overflow: "hidden",
                width: width - 20
                // marginLeft: 10,
            };
        };
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title="分号管理"
                    rightView={
                        <TouchableOpacity
                            onPress={() => {
                                this.closeRow();
                                navigation.navigate("AccountEditer", {
                                    page: "add",
                                    callback: () => this.getList(true, false)
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
                <SwipeListView
                    type='l1_accountManage'
                    useFlatList
                    style={{
                        width: width - 20,
                        backgroundColor: CommonStyles.globalBgColor
                    }}
                    renderItem={(data, secId, rowId, rowMap) =>
                        this.renderItem(data.item,data.index, viewStyle(data.index))
                    }
                    store={{
                        ...longLists[listName],
                        page: longLists[listName] && longLists[listName].listsPage || 1
                    }}
                    data={longLists[listName] && longLists[listName].lists || []}
                    numColumns={1}
                    ItemSeparatorComponent={() => (
                        <View style={styles.flatListLine} />
                    )}
                    refreshData={() => this.getList(false, false)}
                    loadMoreData={() => this.getList(false, true)}
                    renderHiddenItem={(data, secId, rowId, rowMap) => {
                        return (
                            <View
                                style={[
                                    styles.rightContainer,
                                    viewStyle(data.index)
                                ]}
                            >
                                <TouchableOpacity
                                    style={styles.delTextContainer}
                                    onPress={() => {
                                        this.closeRow();
                                        navigation.navigate("AccountEditer", {
                                            currentAccount: data.item,
                                            page: "remove",
                                            callback: () =>
                                                this.getList(true, false)
                                        });
                                    }}
                                >
                                    <Text style={styles.deleteTextStyle}>
                                        注销
                                    </Text>
                                </TouchableOpacity>
                            </View>
                        );
                    }}
                    leftOpenValue={0}
                    rightOpenValue={-84}
                    previewRowKey={"0"}
                    previewOpenValue={-40}
                    previewOpenDelay={3000}
                    onRowDidOpen={this.onRowDidOpen}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: CommonStyles.globalBgColor
    },
    flatList: {
        flex: 1,
        backgroundColor: "#F6F6F6"
    },
    flatListLine: {
        height: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    swipe: {
        width: width - 20,
        marginLeft: 10,
        backgroundColor: "white",
        overflow: "hidden"
    },
    item: {
        padding: 15,
        overflow: "hidden",
        backgroundColor: "white"
    },
    line: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between"
    },
    name: {
        color: "#222222",
        fontSize: 14
    },
    smallText: {
        color: "#777777",
        fontSize: 12
    },
    rightContainer: {
        flexDirection: "row",
        backgroundColor: CommonStyles.globalBgColor,
        alignItems: "center",
        justifyContent: "flex-end",
        flex: 1
    },

    delTextContainer: {
        width: 84,
        backgroundColor: "#EE6161",
        alignItems: "center",
        justifyContent: "center",
        height: "100%"
    },
    deleteTextStyle: {
        color: "#fff",
        fontSize: 14
    }
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
        merchant:state.user.merchant || [],
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(AccountScreen);
