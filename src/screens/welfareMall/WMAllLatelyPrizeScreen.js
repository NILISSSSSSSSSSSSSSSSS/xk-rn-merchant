/**
 * 最新揭晓，所有人参与的抽奖商品
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    FlatList,
    TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import math from '../../config/math';

import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import CountDown from '../../components/CountDown';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import ListEmptyCom from '../../components/ListEmptyCom';
import FlatListView from '../../components/FlatListView';

import { getPreviewImage } from '../../config/utils';


const SpaceWidth = 10;
const MarginWidth = 7.5;
const Warpper = (props)=>
<View style={{width: width/2}}>
    <View
    style={{ width: (width - MarginWidth*2 - SpaceWidth) / 2, marginLeft: props.index%2===0 ? MarginWidth : SpaceWidth /2, marginRight: props.index%2===1 ? MarginWidth : SpaceWidth /2 }}>
    {props.children}
    </View>
</View>


const { width, height } = Dimensions.get('window');
function getwidth(val) {
    return width * val / 375
}
class WMAllLatelyPrizeScreen extends PureComponent {
    static scrollViewRef;
    static navigationOptions = {
        header: null,
    };

    constructor(props) {
        super(props);
        this.state = {
            limit: 10,
            page: 1,
            hasMore: false,
            usage: '',
            fixedWidth: '',
            titleIndex: '',
            initGoodsList: '',
            categoryListTitle: [
                {
                    tabName: '全部',
                    tabIndex: '0',
                }, {
                    tabName: '夺奖商品',
                    tabIndex: '1',
                }, {
                    tabName: '平台大奖',
                    tabIndex: '2',
                },
            ],
            numColumns: 2,
        };
    }

    componentDidMount() {
        this.getData();
        // Loading.show();
        this.setActiveTabsIndex();
    }

    componentWillUnmount() {
        // Loading.hide();
    }

    // 设置当前索引
    setActiveTabsIndex = () => {
        const { navigation } = this.props;
        const index = navigation.getParam('index', 0);
        const itemInit = '';
        this.handleClickItem(itemInit, index)
        // this.getData();
    }

    getData = (usage, page = 1) => {
        const { navigation, latelyPrizeList } = this.props;
        const goodsList = latelyPrizeList.goodLists;
        if (goodsList.length === 0) {
            Loading.show();
        }
        const { limit } = this.state;
        const params = {
            jCondition: {
                goodsName: '',
                usage: usage
            },
            limit,
            page,
        };
        this.setState({
            usage
        })
        this.props.dispatch({ type: 'welfare/getWMAllLateyPrizeList', payload: { params } });
    }
    handleChangeState = (key, value, callback = () => { }) => {
        this.setState({
            [key]: value,
        }, () => {
            callback();
        });
    }

    // 点击tab索引
    handleClickItem = (item, index) => {
        console.log('点击tab', item, index);
        Loading.show();
        const category = item.tabIndex || '';
        if (index === 0) { // 全部
            this.getData(usage = '');
        } else if (index === 1) { // 夺奖商品
            this.getData(usage = 'welfare');
        } else { // 平台大奖
            this.getData(usage = 'expense');
        }
        this.setState({
            titleIndex: index,
            category,
        });
        // this.scrollToIndex(index)
    }
    _onLayout = (e, index) => {
        let width = e.nativeEvent.layout.width
        if (index == 1) {
            this.setState({
                fixedWidth: width
            })
        }
    }
    scrollToIndex = (index) => {
        console.log(index)
        this.scrollViewRef.scrollToIndex({ animated: true, index: index, viewOffset: 0, viewPosition: 0.5 })
        this.handleChangeState('categoryListTitle', this.state.categoryListTitle)
    }
    renderSeparator = () => <View style={styles.separatorCom} />


    renderItem = ({ item, index }) => {
        const { navigation, latelyPrizeList } = this.props;
        const goodsList = latelyPrizeList.goodLists
        const time = moment(item.realityLotteryDate * 1000).format('YYYY-MM-DD HH:mm')
        let value =math.multiply(math.divide(item.currentCustomerNum , item.eachSequenceNumber) , 100)
        let processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
        // const navigationType=item.usage === 'expense' ?'WMLotteryDetail':'WMXFGoodsDetail'

        return (
            <Warpper index={index}>
            <TouchableOpacity key={index} style={[styles.itemWrap, CommonStyles.flex_center]}
                onPress={() => {
                    // console.log('item', item, usage)
                    // item['orderId'] = '';
                    // item['termNumber'] = item.sequenceId;
                    if (item.usage === 'welfare') {
                        const params = {
                            orderId: '',
                            sequenceId: item.sequenceId,
                        };
                        navigation.navigate('WMLotteryDetail', params); //夺奖商品详情
                    } else {
                        navigation.navigate('WMXFGoodsDetail', { goodsData: item, goodsId: item.goodsId });  //平台大奖详情
                    }

                }}
            >
                <View style={[styles.flex_start_noCenter, styles.itemContent]}>
                    <View style={styles.itemLeft}>
                        <Image style={styles.itemLeftImage} source={{ uri: getPreviewImage(item.mainUrl, '50p') }} />
                    </View>
                    <View style={[styles.itemRight, styles.flex_1]}>
                        <Text style={styles.textRighttt} numberOfLines={1}> {item.goodsName}</Text>
                        <View style={styles.timeWrap}>
                            <Text style={styles.isOverText}>期数：第{item.sequenceNo}期</Text>
                        </View>
                        <View style={styles.timeWrap2}>
                            <View><Text style={styles.isOverText2}>中奖时间：<Text style={styles.textColor}>{time}</Text></Text></View>
                            {item.lotteryUserName ?
                                <View>
                                    <Text style={styles.isOverText2}>中奖用户：<Text numberOfLines={1} style={styles.isOverText3}>{item.lotteryUserName}</Text></Text>
                                </View> :
                                <View>
                                    <Text style={styles.isOverText2}>无人参与，系统自动开奖！</Text>
                                </View>}
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
            </Warpper>
        )
    }
    render() {
        const { navigation, latelyPrizeList } = this.props;
        const { categoryListTitle, fixedWidth, titleIndex, numColumns } = this.state;
        const goodsList = latelyPrizeList.goodLists;
        // const goodsList = latelyPrizeList.goodLists.filter((item, index) => index < 3);
        const page = latelyPrizeList.page;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack
                    title="最新揭晓"
                />
                <View style={{ width }}>
                    <FlatList
                        horizontal
                        ref={(ref) => { this.scrollViewRef = ref; }}
                        style={styles.categoryTitle}
                        extraData={titleIndex}
                        data={categoryListTitle}
                        showsHorizontalScrollIndicator={false}
                        keyExtractor={(item, index) => index.toString()}
                        renderItem={({ item, index }) => (
                            <View>
                                <TouchableOpacity key={index} onPress={() => { this.handleClickItem(item, index); }}>
                                    <View style={[styles.categoryTitleItemWrap, { width: width / 3 }]}>
                                        <View style={styles.categoryTitleItem}>
                                            <Text style={[styles.categoryTitleITemTop, { width: '100%' }, (titleIndex === index) ? styles.titleActive : {}]} onLayout={e => this._onLayout(e, index)}>{item.tabName}</Text>
                                            <View style={[styles.categoryTitleITemBottom, { width: '100%' }, (titleIndex === index) ? styles.titleBottomActive : {}]} />
                                        </View>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        )}
                    />
                </View>
                <FlatListView
                    flatRef={(e) => { e && (this.flatListRef = e) }}
                    style={styles.ScrollView}
                    data={goodsList}
                    renderItem={this.renderItem}
                    store={latelyPrizeList}
                    ItemSeparatorComponent={this.renderSeparator}
                    refreshData={this.getData}
                    numColumns={numColumns}
                    loadMoreData={() => {
                        this.getData(this.state.usage, page + 1);
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    categoryTitle: {
        width,
        flexDirection: 'row',
        flexWrap: 'nowrap',
        backgroundColor: CommonStyles.globalBgColor,
    },
    ScrollView: {
        backgroundColor: '#EEEEEE',
        // paddingTop: 10,
        // padding: 6,
        // paddingLeft: 6,
        // paddingRight: 6,
        // paddingRight: 6
        // flexDirection: 'row',
        // flexWrap: 'wrap',
        // paddingBottom: 20
    },
    flatListSty: {
        // padding: 10,
    },
    textColor: {
        color: '#EE6161'
    },
    categoryTitleItemWrap: {
        // paddingHorizontal: 5,
        // width: width / 4.2,
        backgroundColor: '#fff',
        justifyContent: 'center',
        alignItems: 'center',
    },
    categoryTitleITemTop: {
        position: 'relative',
        paddingTop: 10,
        textAlign: 'center',
        color: '#555555',
        fontSize: 14,
    },
    titleBottomActive: {
        bottom: -2,
    },
    titleActive: {
        // color: CommonStyles.globalHeaderColor,
        color: '#4A90FA'
    },
    categoryTitleITemBottom: {
        height: 6,
        borderRadius: 2,
        backgroundColor: '#4A90FA',
        position: 'absolute',
        bottom: -6,
        left: 0,
    },
    textRighttt: {
        paddingLeft: 6,
        marginTop: 7,
        marginBottom: 12,
        color: '#222'
    },
    categoryTitleItem: {
        height: 38,
        overflow: 'hidden',
    },
    flex_start_noCenter: {
        flexDirection: 'column',
        // justifyContent: 'space-between',
    },
    flex_1: {
        // flex: 1,
    },
    isOverText3: {
        fontSize: 12,
        color: '#555'
    },
    itemWrap: {
        width: '100%',
        marginBottom: 10,
        borderRadius: 6,
        // borderTopRightRadius: 6,
        // borderTopLeftRadius: 6,
        // flexWrap: 'wrap',
        // justifyContent: 'space-between',
        backgroundColor: '#EEEEEE',
        overflow: 'hidden'

    },
    itemContent: {
        borderRadius: 6,
        backgroundColor: '#fff',
        width: width / 2 - 7.5,
    },
    itemRightw: {
        // marginRight: 7.5,
    },
    itemRightL: {
        borderTopRightRadius: 6,
        borderBottomLeftRadius: 6,
        // marginLeft: 7.5,
    },
    topBorder: {
        borderTopWidth: 1,
        borderTopColor: '#f1f1f1',
    },
    topRadius: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    bottomRadius: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
        // paddingBottom: 20,
        marginBottom: CommonStyles.footerPadding,
    },
    itemLeft: {
        // position: 'relative',
        // padding: 2,
        // borderRadius: 10,
        borderColor: '#E7E7E7',
        // borderWidth: 1,
    },
    itemLeftImage: {
        height: 168,
        width: '100%',
        borderTopRightRadius: 6,
        borderTopLeftRadius: 6
        // borderRadius: 10,
    },
    itemRight: {
        // marginLeft: 6,
        fontSize: 14,
        color: '#222',
    },

    itemTitle: {
        color: '#222',
        fontSize: 14,
    },
    timeWrap: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        marginLeft: 6
    },
    timeWrap2: {
        flexDirection: 'column',
        // justifyContent: 'flex-start',
        // alignItems: 'center',
        backgroundColor: '#F0F6FF',
        paddingLeft: 6,
        // paddingBottom: 10,
        borderBottomLeftRadius: 6,
        borderBottomRightRadius: 6,
        height: 48,
    },
    timeLabel: {
        fontSize: 12,
        color: '#555',
        marginTop: 15,
    },
    timeText: {
        color: '#EE6161',
        fontSize: 12,
        marginTop: 15,
    },
    isOverText: {
        fontSize: 12,
        // marginTop: 10,
        color: '#555',
        paddingBottom: 7
    },
    isOverText2: {
        fontSize: 12,
        marginTop: 7,
        color: '#777',
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
        zIndex: 10,

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
        zIndex: 10,
    },

});

export default connect(
    state => ({ latelyPrizeList: state.welfare.latelyPrizeList }),
)(WMAllLatelyPrizeScreen);
