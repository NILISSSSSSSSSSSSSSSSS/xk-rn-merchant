/**
 * 我的奖券
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
    Platform,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import FlatListView from "../../components/FlatListView";
import * as nativeApi from "../../config/nativeApi";

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ScrollableTabView from 'react-native-scrollable-tab-view';
import DefaultTabBar from '../../components/CustomTabBar/DefaultTabBar';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar'
import { NavigationComponent } from '../../common/NavigationComponent'
import moment from 'moment'

const { width, height } = Dimensions.get("window");
import * as requestApi from '../../config/requestApi';
const mockData = [1, 2, 3, 4, 5, 6]
class WMMyLotteryScreen extends NavigationComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            allData: [[], [], []],
            status: 0,
            limit: 10,
            refreshing: false,
            loading: false,
            page: 1,
            hasMore: true,
            total: 0,
        }
    }
    screenWillFocus () {
        Loading.show()
        this.refresh()
    }
    componentDidMount() {
    }

    componentWillUnmount() {
    }
    handleChangeState = (key, val, callback = () => { }) => {
        this.setState({
            [key]: val
        });
        callback();
    };
    // 刷新
    refresh = (page = 1, refreshing = false) => {
        const { limit, status, total } = this.state;
        let allData = JSON.parse(JSON.stringify(this.state.allData));
        this.handleChangeState('refreshing', refreshing)
        requestApi.drawTicketPage({ page, limit, drawTicketType: status === 0 ? 'consumption_ticket' : 'generalize_ticket' }).then(data => {
            console.log("%cAllData", "color:blue", data);
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data
                    ? [...allData[status], ...data.data]
                    : allData[status];
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;
            allData[status] = _data;
            this.setState({
                refreshing: false,
                loading: false,
                page,
                hasMore,
                total: _total,
                allData
            });
        }).catch(() => {
            this.setState({
                refreshing: false,
                loading: false
            });
        });
    };
    // 跳转到客服
    gotoCunstom = () => {
        nativeApi.createXKCustomerSerChat();
    }
    // handleGoOrderDetail = (item) => {
    //     if (item.tradeProduct !== 'b2b') return
    //     const { navigation } = this.props
    //     let nextData = {
    //         key: 4,
    //         nextOperTitle: null,
    //         nextOperFunc: null,
    //         more: [
    //             { title: "联系客服", func: () => { this.gotoCunstom() } },
    //         ],
    //         status: "交易完成"
    //     }
    //     let data = {
    //         orderId: item.orderNo
    //     }
    //     navigation.navigate(
    //         "SOMOrderDetails",
    //         {
    //             nextData,
    //             data,
    //             callback: this.refresh,
    //         }
    //     );
    // }
    render() {
        const { navigation, store } = this.props;
        const { status, allData } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"我的奖券"}
                />
                <ScrollableTabView
                    initialPage={0}
                    onChangeTab={({ i }) => {
                        this.setState({ status: i }, () => {
                            this.refresh(1)
                        });
                    }}
                    renderTabBar={() => <ScrollableTabBar
                        style={{ backgroundColor: '#4A90FA', borderBottomWidth: 0, }}
                        underlineStyle={{ backgroundColor: "#fff", height: 8, borderRadius: 10, marginBottom: -5 }}
                        activeTextColor="#fff"
                        inactiveTextColor="rgba(255,255,255,.5)"
                    />}
                >
                    <FlatListView
                        tabLabel='平台券'

                        style={{
                            backgroundColor: CommonStyles.globalBgColor
                        }}
                        store={this.state}
                        data={allData[status]}
                        extraData={this.state}
                        ItemSeparatorComponent={() => (
                            <View style={{ height: 0 }} />
                        )}
                        renderItem={({ item, index }) => {
                            let marginBottom = index === mockData.length - 1 ? styles.marginBottom : null
                            return (
                                <View style={[styles.lotteryItemWrap, styles.flexStart_noCenter, marginBottom]} key={index}>
                                    <View style={[styles.flex_1, styles.lotteryLeftWrap]}>
                                        <Text style={styles.lotteryOrderId}>订单编号：{item.orderNo}</Text>
                                        <Text style={[styles.lotteryTitle, styles.color_blue]}>{item.name}</Text>
                                        <Text style={[{ fontSize: 10, color: '#738DF5',marginTop: 3  }]}>使用本券可在增运大转盘中抽奖一次</Text>
                                        <Text style={styles.lotteryTime}>有效期：{moment(item.effectiveTime * 1000).format('YYYY-MM-DD HH:mm')} 至 {moment(item.effectiveTime * 1000).add(item.validTime,'s').format('YYYY-MM-DD HH:mm')} </Text>
                                    </View>
                                    <TouchableOpacity
                                    style={[styles.flex_center, { position: 'relative' }]}
                                    onPress={() => { 
                                        // 跳转到抽奖转盘页面
                                        navigation.navigate('WMLotteryActivity');
                                    }}
                                    activeOpacity={item.tradeProduct !== 'b2b'? 1: 0.85}
                                    >
                                        <Image style={{ width: 100, height: 100 }} fadeDuration={0} source={require('../../images/lottery/lottery_left_bg_01.png')} />
                                        {
                                            item.tradeProduct === 'b2b'
                                            ?
                                            <View style={[styles.showMoreWrap, styles.flexEnd, { paddingRight: 15, }]}>
                                                <Text style={styles.showMoreText}>立即使用</Text>
                                                <Image style={styles.showMoreImg} source={require('../../images/lottery/lottery_left_more_01.png')} />
                                            </View>
                                            : null
                                        }
                                    </TouchableOpacity>
                                </View>
                            )
                        }}
                        refreshData={() => {
                            this.handleChangeState("refreshing", true);
                            this.refresh(1);
                        }}
                        loadMoreData={() => {
                            this.refresh(this.state.page + 1);
                        }}
                    />
                    <FlatListView
                        tabLabel='活动券'
                        style={{
                            backgroundColor: CommonStyles.globalBgColor
                        }}
                        store={this.state}
                        data={allData[status]}
                        extraData={this.state}
                        ItemSeparatorComponent={() => (
                            <View style={{ height: 0 }} />
                        )}
                        renderItem={({ item, index }) => {
                            let marginBottom = index === mockData.length - 1 ? styles.marginBottom : null
                            return (
                                <View style={[styles.lotteryItemWrap, styles.flexStart_noCenter, marginBottom]} key={index}>
                                    <TouchableOpacity style={[styles.flex_center, { position: 'relative'}]} onPress={() => { 
                                        // 跳转到抽奖转盘页面
                                        navigation.navigate('WMLotteryActivity');
                                     }}activeOpacity={0.85}>
                                        <Image style={styles.info_bg} fadeDuration={0} source={require('../../images/lottery/lottery_left_bg.png')} />
                                        <View style={[styles.showMoreWrap, styles.flex_center]}>
                                            <View style={[CommonStyles.flex_start]}>
                                                <Text style={styles.showMoreText}>立即使用</Text>
                                                <Image style={styles.showMoreImg} source={require('../../images/lottery/lottery_left_more.png')} />
                                            </View>
                                        </View>
                                    </TouchableOpacity>
                                    <View style={[styles.flex_1, styles.lotteryLeftWrap]}>
                                        <Text style={styles.lotteryOrderId}>活动编号：{item.generalizeId}</Text>
                                        <Text style={[styles.lotteryTitle, styles.color_red]}>{item.name}</Text>
                                        <Text style={[{ fontSize: 10, color: '#fca7a7',marginTop: 3 }]}>使用本券可在增运大转盘中抽奖一次</Text>
                                        <Text style={styles.lotteryTime}>有效期：{moment(item.effectiveTime * 1000).format('YYYY-MM-DD HH:mm')} 至 {moment(item.effectiveTime * 1000).add(item.validTime,'s').format('YYYY-MM-DD HH:mm')}</Text>
                                    </View>
                                </View>
                            )
                        }}
                        refreshData={() => {
                            this.handleChangeState("refreshing", true);
                            this.refresh(1);
                        }}
                        loadMoreData={() => {
                            this.refresh(this.state.page + 1);
                        }}
                    />
                </ScrollableTabView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flexStart: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center'
    },
    flexStart_noCenter: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
    },
    flex_center: {
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    flexEnd: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center'
    },
    flex_1: {
        flex: 1
    },
    lotteryItemWrap: {
        marginTop: 15,
        marginHorizontal: 10,
        borderTopLeftRadius: 10,
        borderBottomLeftRadius: 15
    },
    info_bg: {
        width: 77,
        height: 100
    },
    showMoreWrap: {
        position: 'absolute',
        width: '100%',
        height: '100%',
        left: 0,
        top: 0,
        // backgroundColor: 'red'
    },
    showMoreText: {
        fontSize: 12,
        color: '#fff',
        width: 26,
        marginLeft: 5
    },
    showMoreImg: {
        height: 14,
        width: 14,
        marginLeft: 5
    },
    lotteryLeftWrap: {
        backgroundColor: '#fff',
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
        paddingLeft: 15
    },
    lotteryOrderId: {
        fontSize: 10,
        color: '#999',
        paddingTop: 10,
        paddingBottom: 9
    },
    color_red: {
        color: '#EC725E'
    },
    color_blue: {
        color: '#5370E2'
    },
    color_yellow: {
        color: '#CEA462'
    },
    lotteryTitle: {
        fontSize: 14,
    },
    lotteryTime: {
        fontSize: 10,
        marginTop: 8
    },
    marginBottom: {
        marginBottom: 15
    },
});

export default connect(
    state => ({ store: state })
)(WMMyLotteryScreen);
