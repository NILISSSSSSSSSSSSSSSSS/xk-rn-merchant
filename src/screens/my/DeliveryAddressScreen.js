/**
 * 收货地址
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
const { width, height } = Dimensions.get("window");
import SwipeListView from "../../components/SwipeListView";

class DeliveryAddressScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            shopId: props.userShop.id,
            deleteIndex: 0, //要删除的项
            rowMap: {},
            rowKey: "",
            listName: 'deliver'
        };
    }

    componentWillUnmount() {

    }
    componentDidMount() {
        this.getList(true, false);
    }
    getList = (isFirst = false, isLoadingMore = false) => {
        this.closeRow();
        this.props.fetchList({
            witchList:this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate : {
                mShopId: this.state.shopId
            },
            api:requestApi.merchantShopAddrQPage,
        })
    };
    // 删除地址，比较删除的地址和确认订单页面的地址是否一样，一样则更新确认收货页面地址为空，否则不管
    compareAddress = (id) => {
        const {navigation} =this.props
        let nowAddress = navigation.getParam('nowAddress',{})
        if (nowAddress.id === id) {
            return null
        } else {
            return nowAddress
        }
    }
    deleteAdress = id => {
        const {navigation} =this.props
        let callback = navigation.getParam('callBack', () => {})
        requestApi.merchantShopAddrDelete({ id }).then(() => {
            callback(this.compareAddress(id))
            this.getList(true, false);
        }).catch(err => {
            console.log(err)
        });
    };
    openSetDefalt = () => {
        const { longLists } = this.props;
        const { listName } = this.state
        let newLists = [];
        let lists = longLists[listName] && longLists[listName].lists || []
        for (item of lists) {
            item.confirmDelete = false;
            newLists.push(item);
        }
        if (longLists[listName]) {
            this.props.shopSave({
                longLists: {
                    ...longLists,
                    [listName]: {
                        ...longLists[listName],
                        lists: newLists
                    }
                }
            })
        }
    };
    closeRow = () => {
        this.openSetDefalt();
        const { rowMap, rowKey} = this.state;
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }

    };
    chooseAdress = item => {
        const { navigation } = this.props;
        if (navigation.state.params && navigation.state.params.callBack) {
            let fun = navigation.state.params.callBack;
            fun(item);
            navigation.goBack();
        } else {
            this.closeRow();
            this.props.navigation.navigate("DeliveryAddressEdit", {
                currentAdress: item,
                deleteAdress: () => this.deleteAdress(item.id),
                refreshList: () => {
                    this.getList(true, false);
                }
            });
        }
    };

    renderItem = (item, viewStyle, index) => {
        return (
            <View style={[styles.item, viewStyle]}>
                <TouchableOpacity
                    underlayColor="#f1f1f1"
                    activeOpacity={0.5}
                    onPress={() => {
                        this.chooseAdress(item);
                    }}
                    style={{
                        flex: 1,
                        marginRight: 10,

                    }}
                >

                    <View style={[CommonStyles.flex_between]}>
                        <Text style={styles.name} numberOfLines={1} style={{maxWidth: 200}}>
                            {(item.receiver || "姓名")}
                        </Text>
                        <Text style={styles.name}>
                            {item.phone}
                        </Text>
                    </View>
                    <Text
                        style={[styles.smallText, { fontSize: 12,marginTop:6,lineHeight: 18 }]}
                        numberOfLines={2}
                    >
                        {item.isDefault === 1 ? (
                            <Text style={{ color: CommonStyles.globalHeaderColor }} >[默认地址]</Text>
                        ) : null}
                        {item.provinceName + " " +item.cityName +" " +item.districtName +" " +item.poiName+ item.street}
                    </Text>
                </TouchableOpacity>
                <TouchableOpacity
                    underlayColor="#f1f1f1"
                    activeOpacity={0.5}
                    style={{
                        width: 48,
                        height: 48,
                        justifyContent: "center",
                        alignItems: "center"
                    }}
                    onPress={() => {
                        this.closeRow();
                        this.props.navigation.navigate("DeliveryAddressEdit", {
                            currentAdress: item,
                            deleteAdress: () => this.deleteAdress(item.id),
                            refreshList: () => {
                                this.getList(true, false);
                            }
                        });
                    }}
                >
                    <Image
                        source={require("../../images/address/edit.png")}
                        style={{ width: 18, height: 18 }}
                    />
                </TouchableOpacity>
            </View>
        );
    };
    onRowDidOpen = (rowKey, rowMap) => {
        console.log("This row opened", rowKey);
        this.setState({ rowMap, rowKey });
    };

    render() {
        const { navigation, longLists,initList } = this.props;
        const { listName } = this.state
        let lists = longLists[listName] && longLists[listName].lists || []
        const viewStyle = index => {
            return {
                borderTopLeftRadius: index == 0 ? 8 : 0,
                borderTopRightRadius: index == 0 ? 8 : 0,
                borderBottomLeftRadius:index == lists.length - 1 ? 8 : 0,
                borderBottomRightRadius:index == lists.length - 1 ? 8 : 0,
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
                    title="我的收货地址"
                    rightView={
                        <TouchableOpacity
                            onPress={() => {
                                this.closeRow();
                                navigation.navigate("DeliveryAddressEdit", {
                                    refreshList: () =>
                                        this.getList(true, false)
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
                    useFlatList
                    style={{
                        width: width - 20,
                        marginLeft: 10,
                        marginRight: 10,
                        backgroundColor: CommonStyles.globalBgColor
                    }}
                    renderItem={(data, secId, rowId, rowMap) =>
                        this.renderItem(
                            data.item,
                            viewStyle(data.index),
                            data.index
                        )
                    }
                    store={{
                        ...longLists[listName] || initList,
                        page: longLists[listName] && longLists[listName].listsPage || 1
                    }}
                    data={lists}
                    numColumns={1}
                    ItemSeparatorComponent={() => (
                        <View style={styles.flatListLine} />
                    )}
                    refreshData={() => this.getList(false, false)}
                    loadMoreData={() => this.getList(false, true)}
                    ListEmptyComponent={() => {
                        return !longLists[listName] || (longLists[listName] && longLists[listName].isFirstLoad) ?
                            <View />
                            : (
                                <View style={styles.emptyView}>
                                    <Image
                                        source={require("../../images/address/address.png")}
                                        style={{ marginBottom: 30 }}
                                    />
                                    <Text style={styles.emptyText}>您还没有添加收货地址</Text>
                                </View>
                            );
                    }}
                    renderHiddenItem={(data, secId, rowId, rowMap) => {
                        return (
                            <View
                                style={[
                                    styles.rightContainer,
                                    viewStyle(data.index)
                                ]}
                            >
                                {!data.item.confirmDelete && !data.item.isDefault? (
                                    <TouchableOpacity
                                        style={[
                                            styles.delTextContainer,
                                            { backgroundColor: "#C3C3C3" }
                                        ]}
                                        onPress={() => {
                                            this.closeRow();
                                            requestApi
                                                .merchantShopAddrUpdateDefault({
                                                    id: data.item.id
                                                })
                                                .then(() =>
                                                    this.getList(true, false)
                                                ).catch(err => {
                                                    console.log(err)
                                                });
                                        }}
                                    >
                                        <Text style={styles.deleteTextStyle}>
                                            设为默认
                                        </Text>
                                    </TouchableOpacity>
                                ) : null}

                                <TouchableOpacity
                                    style={[
                                        styles.delTextContainer,
                                        {
                                            width: data.item.confirmDelete || data.item.isDefault? 152: 68
                                        }
                                    ]}
                                    onPress={() => {
                                        if (data.item.confirmDelete) {
                                            this.closeRow();
                                            this.deleteAdress(data.item.id);
                                        } else {
                                            lists[data.index ].confirmDelete = true;
                                            this.props.shopSave({longLists: longLists})
                                        }
                                    }}
                                >
                                    <Text style={styles.deleteTextStyle}>
                                        {data.item.confirmDelete
                                            ? "确认删除"
                                            : "删除"}
                                    </Text>
                                </TouchableOpacity>
                            </View>
                        );
                    }}
                    leftOpenValue={0}
                    rightOpenValue={-152}
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
        paddingVertical: 15,
        paddingLeft: 15,
        overflow: "hidden",
        backgroundColor: "white",
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between"
    },
    line: {
        flexDirection: "row",
        alignItems: "center",
        marginBottom: 6
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
    },
    emptyView: {
        alignItems: "center",
        marginTop: 68
    },
    emptyText: {
        marginBottom: 20,
        color: "#999",
        fontSize: 14
    }
});

export default connect(
    (state) => ({
        userShop:state.user.userShop || {},
        longLists:state.shop.longLists || {},
        initList:state.shop.initList || {}
     }),
    (dispatch) => ({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        shopSave: (params={})=> dispatch({ type: "shop/save", payload: params}),
     })
)(DeliveryAddressScreen);
