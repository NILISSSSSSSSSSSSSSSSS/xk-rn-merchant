/**
 * 我的/系统消息
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    Text,
    Button,
    TouchableHighlight,
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
const { width, height } = Dimensions.get("window");
import SwipeListView from "../../components/SwipeListView";
import { imJudge } from "../../config/imJudge";

utils.initMomentFromString()

class SystemMessage extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {}
        this.state = {
            listName: 'message' + params.code,
            code: params.code,
            page: params.page,
            title: params.title
        };
    }
    getList = (isFirst = false, isLoadingMore = false) => {
        this.props.fetchList({
            witchList: this.state.listName,
            isFirst,
            isLoadingMore,
            paramsPrivate: { code: this.state.code },
            api: requestApi.systemMsgList,
        })
    };

    navPage = (routeName, params) => {
        this.props.navPage({ routeName, params })
    }

    componentDidMount() {
        this.getList(true, false);
    }

    renderSystemItem = (item) => {//系统消息
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={() => {
                    if(item.code=='007'){ //商圈订单消息
                        imJudge(item.extras, this.props.navigation)
                    }else{
                        this.navPage("MessageDetails", item)
                    }
                }}
                style={[styles.item, { flexDirection: 'row', justifyContent: 'space-between' }]}
            >
                <Text style={[styles.title, styles.itemLeft]}>{item.msgContent} </Text>
                <Text style={[styles.text, styles.itemRight]}>{moment(item.updatedAt * 1000).fromNow()}</Text>
            </TouchableOpacity>
        );
    };
    renderTicketsItem = (item) => {//抽奖消息
        return (
            <View style={styles.item}>
                <View style={styles.itemTop}>
                    <View style={[styles.itemLeft, { flexDirection: 'row', flexWrap: 'wrap' }]}>
                        <Text style={[styles.title]}>【抽奖】{item.msgContent}。</Text>
                        <TouchableOpacity onPress={() => Toast.show('待开发')}>
                            <Text style={[styles.title, { color: CommonStyles.globalHeaderColor }]}>点击查看详情 </Text>
                        </TouchableOpacity>
                    </View>
                    <Text style={[styles.text, styles.itemRight]}>{moment(item.updatedAt * 1000).format("YYYY-MM-DD")}</Text>
                </View>

            </View>
        );
    };
    renderSpecialItem = ({ item }) => {//专题活动消息
        return (
            <View style={[styles.item, { padding: 0 }]}>
                <View style={[styles.itemTop, { backgroundColor: '#FAFAFA', height: 38, alignItems: 'center', width: width - 20, paddingHorizontal: 15 }]}>
                    <Text style={[styles.title, styles.itemLeft]}>{item.msgContent}。</Text>
                    <Text style={[styles.text, styles.itemRight]}>{moment(item.updatedAt * 1000).format("YYYY-MM-DD")}</Text>
                </View>
                <View style={{ paddingHorizontal: 15 }}>
                    <ImageView
                        source={{ uri: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544866675468&di=6e4bfe947fe016a3290e0245d669caff&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01806f58e4a502a801219c7701b630.jpg' }}
                        sourceWidth={width - 50}
                        sourceHeight={110}
                        resizeMode='cover'
                    />
                    <View style={styles.itemBottom}>
                        <TouchableOpacity onPress={() => Toast.show('待开发')}>
                            <Text style={[styles.title, { color: CommonStyles.globalHeaderColor }]}>删除</Text>
                        </TouchableOpacity>

                        <TouchableOpacity onPress={() => Toast.show('待开发')}>
                            <Text style={[styles.text]}>点击查看</Text>
                        </TouchableOpacity>
                    </View>
                </View>


            </View>

        );
    };

    renderItem = (item) => {
        const { navigation } = this.props;
        let extras = item.extras || {};
        let defaultSource = 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=180635262,3469104988&fm=27&gp=0.jpg';
        // if(item.extras.goodsName && item.extras.orderId && item.extras.sequenceId) {
        if (item.extras.goodsName && item.extras.orderId) {
            return (
                <TouchableHighlight
                    underlayColor="#f1f1f1"
                    activeOpacity={0.5}
                    onPress={() => imJudge(extras, navigation)}
                >
                    <View style={styles.item} activeOpacity={1} >
                        <View style={styles.itemTop}>
                            <View style={[styles.itemLeft, { flexDirection: 'row', flexWrap: 'wrap' }]}>
                                <Text style={[styles.title]}>{item.msgContent}。</Text>
                                {
                                    item.extras.sequenceId &&
                                    <TouchableOpacity onPress={() => imJudge(extras, navigation)}>
                                        <Text style={[styles.title, { color: CommonStyles.globalHeaderColor }]}>点击查看开奖详情</Text>
                                    </TouchableOpacity>
                                }

                            </View>
                            <Text style={[styles.text, styles.itemRight]}>{moment(item.updatedAt * 1000).format("YYYY-MM-DD")}</Text>
                        </View>
                        <View style={styles.goods}>
                            <ImageView
                                source={{ uri: extras.goodsPic || defaultSource }}
                                sourceWidth={48}
                                sourceHeight={48}
                                style={{ borderRadius: 8, marginRight: 10 }}
                                resizeMode='cover'
                            />
                            <View style={{ flex: 1 }}>
                                <Text style={[styles.title, { flex: 1, marginBottom: 10 }]}>{extras.goodsName}</Text>
                                <Text style={[styles.text]}>订单编号：{extras.orderId}</Text>
                            </View>
                        </View>

                    </View>
                </TouchableHighlight>

            );
        } else {
            return this.renderSystemItem(item);
        }
    };
    onRowDidOpen = (rowKey, rowMap) => {
        console.log("This row opened", rowKey);
        this.setState({ rowMap, rowKey });
    };
    closeRow = () => {
        const { rowMap, rowKey } = this.state;
        if (rowMap && rowMap[rowKey]) {
            rowMap[rowKey].closeRow();
        }
    };
    delete = (item) => {
        requestApi.systemMsgDelete({ msgId: item.id }).then(() => {
            Toast.show('删除成功')
            this.getList(true, false)
        }).catch(err => {
            console.log(err)
        });
    }

    render() {
        const { navigation, longLists } = this.props;
        const { title, listName, code } = this.state;
        let renderItem = () => { }
        switch (code) {
            case '001': renderItem = this.renderSystemItem; break;
            case '006': renderItem = this.renderTicketsItem; break;
            case '003': renderItem = this.renderSpecialItem; break;
            default: renderItem = this.renderItem; break;
        }
        // const items = [
        //     { title: '活动', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '002' }, icon: require('../../images/message/activity.png') },
        //     { title: '专题', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '003' }, icon: require('../../images/message/special.png') },
        //     { title: '自营商城消息', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '004' }, icon: require('../../images/message/self.png') },
        //     { title: '福利商城消息', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '005' }, icon: require('../../images/message/welfare.png') },
        //     { title: '抽奖/AA彩', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '006' }, icon: require('../../images/message/choujiang.png') },
        //     { title: '系统提示', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '001' }, icon: require('../../images/message/system.png') },
        //     { title: '周边消息', value: '晓可迎新活动开始啦', time: '12:08', route: 'Message', params: { code: '007' }, icon: require('../../images/message/around.png') },
        // ]

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={title}
                />
                {
                    code == '003' ?
                        <FlatListView
                            renderItem={data => renderItem(data)}
                            style={styles.listview}
                            store={{
                                ...longLists[listName],
                                page: longLists[listName] && longLists[listName].listsPage || 1
                            }}
                            data={longLists[listName] && longLists[listName].lists || []}
                            keyExtractor={(item) => item.id}
                            numColumns={1}
                            refreshData={() =>
                                this.getList(false, false)
                            }
                            loadMoreData={() =>
                                this.getList(false, true)
                            }
                        />
                        :
                        <SwipeListView
                            useFlatList
                            style={styles.listview}
                            renderItem={(data, secId, rowId, rowMap) =>
                                renderItem(data.item)
                            }
                            store={{
                                ...longLists[listName],
                                page: longLists[listName] && longLists[listName].listsPage || 1
                            }}
                            data={longLists[listName] && longLists[listName].lists || []}
                            numColumns={1}
                            keyExtractor={(item) => item.id}
                            // ItemSeparatorComponent={() => (
                            //     <View style={styles.flatListLine} />
                            // )}
                            refreshData={() => this.getList(false, false)}
                            loadMoreData={() => this.getList(false, true)}
                            renderHiddenItem={(data, secId, rowId, rowMap) => {
                                return (
                                    <View
                                        style={[
                                            styles.rightContainer,
                                        ]}
                                    >
                                        <TouchableOpacity
                                            style={styles.delTextContainer}
                                            onPress={() => {
                                                this.closeRow();
                                                this.delete(data.item)
                                            }}
                                        >
                                            <Text style={styles.deleteTextStyle}>
                                                删除
                                        </Text>
                                        </TouchableOpacity>
                                    </View>
                                );
                            }}
                            leftOpenValue={0}
                            rightOpenValue={-70}
                            previewRowKey={"0"}
                            previewOpenValue={-40}
                            previewOpenDelay={3000}
                            onRowDidOpen={this.onRowDidOpen}
                        />
                }


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
        width: width,

    },
    listview: {
        width: width,
        backgroundColor: CommonStyles.globalBgColor
    },
    flatListLine: {
        backgroundColor: CommonStyles.globalBgColor,
        height: 10
    },

    item: {
        borderRadius: 6,
        backgroundColor: "#fff",
        width: width - 20,
        marginLeft: 10,
        // ...CommonStyles.shadowStyle,
        padding: 15,
        minHeight: 66,
        zIndex: 0
    },
    title: {
        fontSize: 14,
        color: '#222222',
        marginBottom: 2,
        lineHeight: 18
    },
    text: {
        fontSize: 14,
        color: '#BBBBBB'
    },
    delTextContainer: {
        width: 70,
        backgroundColor: "#EE6161",
        alignItems: "center",
        justifyContent: "center",
        height: "100%"
    },
    deleteTextStyle: {
        color: "#fff",
        fontSize: 16,
        letterSpacing: 2
    },
    rightContainer: {
        flexDirection: "row",
        backgroundColor: CommonStyles.globalBgColor,
        alignItems: "center",
        justifyContent: "flex-end",
        flex: 1,
        width: width - 20,
        borderRadius: 10,
        overflow: 'hidden',
        zIndex: 1
    },
    itemLeft: {
        flex: 1,
        marginRight: 20,
    },
    itemRight: {
        width: 80,
        flexDirection: "row",
        justifyContent: 'flex-end',
        alignItems: "flex-start",
        textAlign: "right"
    },
    itemTop: {
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    goods: {
        flexDirection: 'row',
        borderRadius: 6,
        backgroundColor: '#F8F8F8',
        padding: 10,
        flex: 1,
        marginTop: 15
    },
    itemBottom: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: 44,
        justifyContent: 'space-between',
        alignItems: 'center',
        borderTopWidth: 1,
        borderColor: '#F1F1F1'
    }

});

export default connect(
    (state) => ({
        userShop: state.user.userShop || {},
        longLists: state.shop.longLists || {},
        juniorShops: state.shop.juniorShops || [state.user.userShop || {}],
    }),
    {
        fetchList: (params = {}) => ({ type: "shop/getList", payload: params }),
        shopSave: (params = {}) => ({ type: "shop/save", payload: params }),
        navPage: (params = {}) => ({ type: "system/navPage", payload: params }),

    }
)(SystemMessage);
