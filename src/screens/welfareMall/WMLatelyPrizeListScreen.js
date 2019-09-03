/**
 * 最新揭晓，当前用户参与的抽奖商品
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
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi'
import CountDown from '../../components/CountDown'
import WMGoodsWrap from '../../components/WMGoodsWrap'
import ListEmptyCom from '../../components/ListEmptyCom';
import FlatListView from "../../components/FlatListView";
import math from '../../config/math';
import moment from 'moment'
import { getPreviewImage } from "../../config/utils";
const { width, height } = Dimensions.get("window");
class WMLatelyPrizeListScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            goodsList: [],
            limit: 10,
            page: 1,
            refreshing: false,
            total: 0,
            hasMore: false,
        }
    }

    componentDidMount() {
        Loading.show()
        this.refresh()
    }

    componentWillUnmount() {
        Loading.hide()
    }
    refresh = (page = 1) => {

        const { limit,total,goodsList } = this.state
        let params = {
            condition: {
                awardUsage: '',
            },
            limit,
            page
        }
        requestApi.newestJQPage(params).then(data => {
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...goodsList, ...data.data] : goodsList;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
                ? (data)
                    ? data.total
                    : 0
                : total;
            let hasMore = data ? _total !== _data.length : false;
            console.log('_data',_data)
            this.setState({
                refreshing: false,
                page,
                hasMore,
                total: _total,
                goodsList: _data,
            });
        }).catch(err => {
            Loading.hide()
        })
    }
    handleChangeState = (key, value, callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    renderItem = ({item, index}) => {
        const { goodsList } = this.state
        const { navigation } = this.props
        const time = moment(item.expectDrawTime * 1000).format('YYYY-MM-DD HH:mm')
        let value = math.multiply(math.divide(item.currentCustomerNum , item.eachSequenceNumber), 100)
        // let processValue = value > 98 ? parseInt(value) : value.toFixed(2)
        let processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
        const processPercent = `${processValue}%`
        return (
            <TouchableOpacity key={index} style={styles.itemWrap}
                onPress={() => {
                    let g_data = item
                    item['sequenceId'] = item.termNumber
                    // 如果是平台大奖（消费抽奖）则跳转消费抽奖详情
                    navigation.navigate('WMXFGoodsDetail', { goodsData: g_data })
                }}
            >
                <View style={[styles.flex_start_noCenter, styles.itemContent, (index === 0) ? styles.topRadius : null, (index === goodsList.length - 1) ? styles.bottomRadius : null]}>
                    <View style={styles.itemLeft}>
                        {
                            item.jsequenceState === 'running_status'
                                ? <Text style={styles.Label}>开奖中</Text>
                                : item.jsequenceState === 'finished_status'
                                    ? <Text style={styles.winLabel}>已开奖</Text>
                                    : null
                        }
                        <Image style={styles.itemLeftImage} source={{ uri: getPreviewImage(item.url, '50p') }} />
                    </View>
                    <View style={[styles.itemRight, styles.flex_1]}>
                        <Text style={styles.itemTitle} numberOfLines={2}>{item.name}</Text>
                        <View style={styles.timeWrap}>
                            {
                                moment().isAfter(moment(item.expectDrawTime * 1000))
                                    ? <Text style={styles.isOverText}>开奖已结束</Text>
                                    : <React.Fragment>
                                        <Text style={styles.timeLabel}>开奖倒计时：</Text>
                                        <CountDown
                                            date={moment((item.expectDrawTime || 0) * 1000)}
                                            days={{ plural: '天 ', singular: '天 ' }}
                                            hours='时'
                                            mins='分'
                                            segs='秒'
                                            daysStyle={styles.timeText}
                                            hoursStyle={styles.timeText}
                                            minsStyle={styles.timeText}
                                            secsStyle={styles.timeText}
                                            firstColonStyle={styles.timeText}
                                            secondColonStyle={styles.timeText}
                                        />
                                    </React.Fragment>
                            }

                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    renderSeparator = () => {
        return <View style={styles.separatorCom} />
    }
    render() {
        const { navigation, store } = this.props;
        const { goodsList } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"最新揭晓"}
                />
                <FlatListView
                    data={goodsList}
                    // style={styles.flatListSty}
                    renderItem={this.renderItem}
                    store={this.state}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={this.refresh}
                    loadMoreData={() => {
                        this.refresh(this.state.page + 1);
                    }}
                />
                {/* <ScrollView
                    style={styles.ScrollView}
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >
                {
                    goodsList.length === 0
                    ? <ListEmptyCom/>
                    : null
                }
                {
                    goodsList.length > 0 && goodsList.map((item, index) => {
                        let status = ''
                        if (item.jsequenceState === 'running_status') {
                            status = '开奖中'
                        } else if (item.jsequenceState === 'finished_status') {
                            status = '已开奖'
                        } else { }
                        console.log(index === goodsList.length - 1)
                        const time = moment(item.expectDrawTime * 1000).format('YYYY-MM-DD HH:mm')
                        let value = (item.currentCustomerNum / item.eachSequenceNumber) * 100
                        // let processValue = value > 98 ? parseInt(value) : value.toFixed(2)
                        let processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
                        const processPercent = `${processValue}%`
                        return (
                            <TouchableOpacity key={index} style={styles.itemWrap}
                                onPress={() => {
                                    let g_data = item
                                    item['sequenceId'] = item.termNumber
                                    // 如果是平台大奖（消费抽奖）则跳转消费抽奖详情
                                    navigation.navigate('WMXFGoodsDetail', { goodsData: g_data })
                                }}
                            >
                                <View style={[styles.flex_start_noCenter, styles.itemContent, (index === 0) ? styles.topRadius : null, (index === goodsList.length - 1) ? styles.bottomRadius : null]}>
                                    <View style={styles.itemLeft}>
                                        {
                                            item.jsequenceState === 'running_status'
                                                ? <Text style={styles.Label}>开奖中</Text>
                                                : item.jsequenceState === 'finished_status'
                                                    ? <Text style={styles.winLabel}>已开奖</Text>
                                                    : null
                                        }
                                        <Image style={styles.itemLeftImage} source={{ uri: getPreviewImage(item.url) }} />
                                    </View>
                                    <View style={[styles.itemRight, styles.flex_1]}>
                                        <Text style={styles.itemTitle} numberOfLines={2}>{item.name}</Text>
                                        <View style={styles.timeWrap}>

                                            {
                                                moment().isAfter(moment(item.expectDrawTime * 1000))
                                                    ? <Text style={styles.isOverText}>开奖已结束</Text>
                                                    : <React.Fragment>
                                                        <Text style={styles.timeLabel}>开奖倒计时：</Text>
                                                        <CountDown
                                                            date={moment((item.expectDrawTime || 0) * 1000)}
                                                            days={{ plural: '天 ', singular: '天 ' }}
                                                            hours='时'
                                                            mins='分'
                                                            segs='秒'
                                                            daysStyle={styles.timeText}
                                                            hoursStyle={styles.timeText}
                                                            minsStyle={styles.timeText}
                                                            secsStyle={styles.timeText}
                                                            firstColonStyle={styles.timeText}
                                                            secondColonStyle={styles.timeText}
                                                        />
                                                    </React.Fragment>
                                            }

                                        </View>
                                    </View>
                                </View>
                            </TouchableOpacity>
                        )
                    })
                }
                </ScrollView> */}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    ScrollView: {
        paddingTop: 10,
        paddingBottom: 20
    },
    flex_start_noCenter: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
    },
    flex_1: {
        flex: 1,
    },
    itemWrap: {
        width: '100%',
        // borderWidth: 1,
        backgroundColor: '#fff'
        // borderColor: "red",
    },
    itemContent: {
        // height: 109,
        borderBottomWidth: 1,
        borderBottomColor: '#F1F1F1',
        borderLeftColor: '#f1f1f1',
        borderLeftWidth: 1,
        borderRightWidth: 1,
        borderRightColor: '#f1f1f1',
        marginHorizontal: 10,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        backgroundColor: '#fff',
        padding: 15
    },
    topRadius: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    bottomRadius: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
        // paddingBottom: 20,
        marginBottom: 40,
    },
    itemLeft: {
        position: 'relative',
        padding: 2,
        borderRadius: 10,
        borderColor: '#E7E7E7',
        borderWidth: 1
    },
    itemLeftImage: {
        height: 78,
        width: 78,
        borderRadius: 10,
    },
    itemRight: {
        marginLeft: 15,
        fontSize: 14,
        color: '#222'
    },
    itemTitle: {
        color: '#222',
        fontSize: 14
    },
    timeWrap: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
    },
    timeLabel: {
        fontSize: 12,
        color: '#555',
        marginTop: 15
    },
    timeText: {
        color: '#EE6161',
        fontSize: 12,
        marginTop: 15
    },
    isOverText: {
        fontSize: 12,
        marginTop: 15,
        color: '#999'
    },
    winLabel: {
        position: 'absolute',
        left: 0,
        top: 0,
        backgroundColor: '#F5A623',
        borderTopLeftRadius: 8,
        borderBottomRightRadius: 8,
        padding: 2,
        color: '#fff',
        fontSize: 10,
        zIndex: 10

    },
    Label: {
        position: 'absolute',
        left: 0,
        top: 0,
        backgroundColor: '#0DCDCE',
        borderTopLeftRadius: 8,
        borderBottomRightRadius: 8,
        padding: 2,
        color: '#fff',
        fontSize: 10,
        zIndex: 10
    },
    separatorCom: {
        width: width,
        height: 0,
        borderWidth: 0.5,
        borderColor: '#F1F1F1'
    },
});

export default connect(
    state => ({ store: state })
)(WMLatelyPrizeListScreen);
