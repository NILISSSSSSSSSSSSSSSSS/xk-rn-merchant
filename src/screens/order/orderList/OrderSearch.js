/**
 * 店铺订单搜索页面
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Platform,
    StatusBar,
    Image,
    TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'

import CommonStyles from '../../../common/Styles'
import Header from '../../../components/Header'
import ImageView from '../../../components/ImageView'
import Content from "../../../components/ContentItem"
import FlatListView from "../../../components/FlatListView"
import TextInputView from '../../../components/TextInputView'
import * as orderRequestApi from '../../../config/Apis/order'
import { ORDER_SCENE_TYPES, ORDER_STATUS_ONLINE, ORDER_STATUS_ONLINE_DESCRIBE } from "../../../const/order";
import { keepTwoDecimal } from "../../../config/utils";

const { width, height } = Dimensions.get("window")

const searchgray = require('../../../images/mall/search_gray.png')
const service = require('../../../images/shopOrder/service.png')

function getwidth(val) {
    return width * val / 375
}
class OrderSearch extends Component {
    state = {
        searchword: '',  //搜索词
    }

    rules = [
        { field: 'searchword' }
    ]

    componentWillUnmount() {
        this.props.clearShopOrderSearchResult()
    }

    changeSearchWord = (val) => {
        this.setState({
            searchword: val
        })
    }
    searchData = () => {
        const { searchword } = this.state
        if(!searchword){
            Toast.show('请输入订单号')
            return
        }
        if (/^[0-9]*$/.test(searchword)) {
            this.props.fetchBcleDetailByOrderIdAndMerchantId({searchword})
        };
    }
    gotoDetaills = (item) => {
        const { data = {}, navigation } = this.props
        const { sceneStatus, orderId, shopId: shopId } = data;
        switch (sceneStatus) {
            case ORDER_SCENE_TYPES.SERVICE_OR_STAY:
                navigation.navigate('AccommodationOrder', { orderId, shopId })
                break;
            case ORDER_SCENE_TYPES.TAKE_OUT:
                navigation.navigate('GoodsTakeOut', { orderId, shopId })
                break;
            case ORDER_SCENE_TYPES.LOCALE_BUY:
                navigation.navigate('GoodsSceneConsumption', { orderId, shopId })
                break;
            case ORDER_SCENE_TYPES.SERVICE_AND_LOCALE_BUY:
                navigation.navigate('StayStatementOrder', { orderId, shopId })
                break;
            case ORDER_SCENE_TYPES.SHOP_HAND_ORDER:
                navigation.navigate('OfflneOrder', { orderId, shopId })
                break;
        }
    }
    renderItem = () => {
        const { data = {} } = this.props
        let item = data
        let picUrl = null
        let smallTitle = ''
        let psmallTitle = ''
        let skuName = ''
        let pSkuName = ''
        let orderStatus = ORDER_STATUS_ONLINE_DESCRIBE[item.newStatus].name
        let picUrls = ['', '', '', '']
        let index = 3

        if (item.goods && item.goods[0]) {
            picUrl = item.goods[0].skuUrl || item.goods[0].pSkuUrl || ''
            smallTitle = item.goods[0].name
            psmallTitle = item.goods[0].pName
            skuName = item.goods[0].skuName
            pSkuName = item.goods[0].pSkuName
            while (index >= 0) {
                if (item.goods[index]) {
                    picUrls[index] = item.goods[index].skuUrl || item.goods[index].pSkuUrl

                }
                index--
            }
        }
        let sceneStatus = item.sceneStatus
        let appointRange = item.appointRange
        let startTime = ''
        let endTime = ''
        if (appointRange) {
            let indexTime = appointRange.indexOf('-')
            if (indexTime !== -1) {
                startTime = appointRange.substring(0, indexTime)
                endTime = appointRange.substring(indexTime + 1)
            } else {
                startTime = appointRange
            }
        }
        let yuyueTime = ''
        if (sceneStatus === 'SERVICE_OR_STAY') {
            //如果说是住宿
            if (item.bcleGoodsType === '1003') {
                yuyueTime = startTime && new Date(startTime * 1000) || ''
                let endYyue = ''
                endYyue = endTime && new Date(endTime * 1000) || ''
                if (endYyue) {
                    yuyueTime = `${yuyueTime.getFullYear()}年${yuyueTime.getMonth() + 1}月${yuyueTime.getDate()}日-${endYyue.getFullYear()}年${endYyue.getMonth() + 1}月${endYyue.getDate()}日`
                }
            }
        }
        let sourceWidth = (width - 60) / 4
        return (
            <TouchableOpacity
                onPress={() => { this.gotoDetaills(item) }}
                style={styles.orderItem} key={data.index}>
                <View style={styles.ordertitle}>
                    <Text style={styles.c2f14}>订单编号：<Text style={styles.c5f12}>{item.orderId}</Text></Text>
                    <Text style={styles.credf14}>{orderStatus}</Text>
                </View>
                {
                    (sceneStatus === 'SERVICE_OR_STAY' || sceneStatus === 'SERVICE_AND_LOCALE_BUY' || sceneStatus === 'SHOP_HAND_ORDER' || sceneStatus === 'LOCALE_BUY') ? (
                        <View style={styles.ordermain}>
                            <View style={styles.orderItemImg}>
                                <ImageView source={{ uri: picUrl }} sourceWidth={getwidth(80)} sourceHeight={80} resizeMode='cover'/>
                            </View>
                            <View style={styles.orderRight}>
                                <Text style={styles.c2f14}>{sceneStatus === 'LOCALE_BUY' ? psmallTitle : smallTitle}</Text>
                                <Text style={styles.c5f12}>规格：{sceneStatus === 'LOCALE_BUY' ? pSkuName : skuName}</Text>
                                {
                                    sceneStatus === 'SERVICE_AND_LOCALE_BUY' && (
                                        <Text style={styles.c5f12}> 商品：{item.goods && item.goods.length || 0}</Text>
                                    )
                                }
                                {
                                    sceneStatus === 'SERVICE_OR_STAY' && item.bcleGoodsType === '1003' && (
                                        <Text style={styles.c5f12}>{yuyueTime} | 共{this.getDurationData(startTime, endTime)}晚 | {item.goods && item.goods.length || 0}间</Text>
                                    )
                                }
                            </View>
                        </View>
                    ) : (
                            <View style={[styles.ordermain]}>
                                {
                                    picUrls[0] ? (
                                        <Image source={{ uri: picUrls[0] }} style={{ width: sourceWidth, height: sourceWidth }} />
                                    ) : null
                                }
                                {
                                    picUrls[1] ? (
                                        <Image source={{ uri: picUrls[1] }} style={{ width: sourceWidth, height: sourceWidth, marginLeft: 10 }} />
                                    ) : null
                                }
                                {
                                    picUrls[2] ? (
                                        <Image source={{ uri: picUrls[2] }} style={{ width: sourceWidth, height: sourceWidth, marginLeft: 10 }} />
                                    ) : null
                                }
                                {
                                    picUrls[3] ? (
                                        <Image source={{ uri: picUrls[3] }} style={{ width: sourceWidth, height: sourceWidth, marginLeft: 10 }} />
                                    ) : null
                                }
                            </View>
                        )
                }
                <View style={styles.bottomcenter}>
                    <View style={styles.orderciadanTime}>
                        {
                            item.bcleGoodsType != '1003' && sceneStatus !== 'TAKE_OUT' && sceneStatus !== 'LOCALE_BUY' && (
                                <Text style={[styles.c9f12, { height: 20, justifyContent: 'center' }]}>预约时间：<Text style={styles.c5f12}>{startTime && moment(startTime * 1000).format('YYYY-MM-DD HH:mm') || ''}</Text></Text>
                            )
                        }
                        {
                            sceneStatus === 'TAKE_OUT' &&  item.isSelfLifting == 0 && (
                                <Text style={[styles.c9f12, { height: 20, justifyContent: 'center' }]} numberOfLines={1} ellipsizeMode='tail'>送货地址：<Text style={styles.c5f12} numberOfLines={1} ellipsizeMode='tail'>{item.address}</Text></Text>
                            )
                        }
                        <Text style={[styles.c9f12, { height: 20, justifyContent: 'center' }]}>下单时间：<Text style={styles.c5f12}>{moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text></Text>
                    </View>
                    <View style={styles.orderremaker}>
                        <Text style={styles.c9f12}>备注：<Text style={styles.c5f12}>{item.remark}</Text></Text>
                    </View>
                </View>
                <View style={styles.btntotle}>
                    <Text style={styles.c5f12}>共计：<Text style={styles.credf16}>￥{keepTwoDecimal(item.money / 100)}</Text></Text>
                </View>
            </TouchableOpacity>
        )
    }
    clearTextInput = () => {
        this.setState({
            searchword: ''
        })
    }

    render() {
        const { searchword } = this.state
        const { navigation, data = {} } = this.props
        console.log('data',data,ORDER_SCENE_TYPES)
        return (
            <View style={styles.container}>
                <StatusBar barStyle={'dark-content'} />
                <Header
                    navigation={navigation}
                    headerStyle={styles.headerView}
                    leftView={
                        <View style={{ width: 0 }}></View>
                    }
                    centerView={
                        <TextInputView
                            inputView={[styles.headerItem, styles.headerCenterView]}
                            inputRef={(e) => { this.searchTextInput = e }}
                            style={styles.headerTextInput}
                            autoFocus={true}
                            placeholder='输入订单号'
                            placeholderTextColor={'#999'}
                            value={searchword}
                            onChangeText={this.changeSearchWord}
                            onSubmitEditing={this.searchData}
                            leftIcon={
                                <TouchableOpacity
                                    onPress={this.searchData}
                                    style={[styles.headerTextInput_icon, styles.headerTextInput_search]}>
                                    <Image source={searchgray} />
                                </TouchableOpacity>
                            }
                            rightIcon={
                                searchword === '' ?
                                    null :
                                    <TouchableOpacity
                                        style={[styles.headerTextInput_icon, styles.headerTextInput_close]}
                                        onPress={() => {
                                            this.clearTextInput();
                                        }}
                                    >
                                        <Image source={require('../../../images/mall/close_gray.png')} style={styles.headerTextInput_close_img} />
                                    </TouchableOpacity>
                            }
                        />
                    }
                    rightView={
                        <TouchableOpacity
                            style={[styles.headerItem, styles.headerRightView]}
                            onPress={() => {
                                navigation.goBack();
                            }}
                        >
                            <Text style={styles.header_search_text}>取消</Text>
                        </TouchableOpacity>
                    }
                />

                <View style={styles.hasorderList}>
                    {
                        data.orderId && this.renderItem()
                    }
                </View>


            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    serchView: {
        backgroundColor: CommonStyles.globalHeaderColor,
        width: width,
        height: 48 + CommonStyles.headerPadding,
        flexDirection: 'row',
        paddingTop: CommonStyles.headerPadding,
        alignItems: 'center'
    },
    headerTextInput_close: {
        right: 0,
    },
    headerTextInput_close_img: {
        width: 18,
        height: 18,
    },
    headerTextInput: {
        flex: 1,
        height: '100%',
        paddingHorizontal: 40,
        paddingVertical: 0,
        borderRadius: 15,
        fontSize: 14,
        backgroundColor: '#EEE',
    },
    headerCenterView: {
        position: 'relative',
        flex: 1,
        height: 30,
        marginLeft: 10,
        zIndex: 1,
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    headerTextInput_search: {
        left: 0,
    },
    headerRightView: {
        paddingLeft: 12,
        paddingRight: 23,
    },
    headerTextInput_icon: {
        position: 'absolute',
        top: 0,
        justifyContent: 'center',
        alignItems: 'center',
        width: 40,
        height: '100%',
        zIndex: 2,
    },
    headerView: {
        backgroundColor: '#fff',
    },
    c2f17: {
        color: '#fff',
        fontSize: 17
    },
    c5f12: {
        color: '#555555',
        fontSize: 12
    },
    credf14: {
        color: '#EE6161',
        fontSize: 14
    },
    c2f14: {
        color: '#222222',
        fontSize: 14
    },
    cbluef14: {
        color: '#4A90FA',
        fontSize: 14
    },
    searchItem: {
        width: getwidth(296),
        height: 38,
        backgroundColor: '#EEEEEE',
        borderRadius: 15,
        marginLeft: 10,
        flexDirection: 'row',
        alignItems: 'center'
    },
    searchText: {
        flex: 1,
        marginLeft: 10
    },
    searcIcon: {
        marginLeft: 20
    },
    cancelView: {
        width: 50,
        height: 38,
        marginLeft: 10,
        justifyContent: 'center',
        alignItems: 'center'
    },
    searchWord: {
        height: 30,
        paddingHorizontal: 10,
        backgroundColor: '#F1F1F1',
        borderRadius: 15,
        marginLeft: 10,
        marginTop: 10,
        justifyContent: 'center',
        alignItems: 'center'
    },
    wordList: {
        width: width,
        height: 70,
        flexDirection: 'row',
        flexWrap: 'wrap'
    },
    orderItem: {
        width: getwidth(355),
        height: 277,
        alignSelf: 'center',
        backgroundColor: '#fff',
        borderRadius: 10,
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        shadowRadius: 8,
        shadowColor: '#D7D7D7',
        elevation: 1,
        zIndex: Platform.OS === 'ios' ? 1 : 0,
    },
    hasorderList: {
        width: getwidth(355),
        marginTop: 10
    },
    ordertitle: {
        width: getwidth(355),
        height: 40,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 15
    },
    ordermain: {
        width: getwidth(355),
        height: 108,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        paddingHorizontal: 15,
        paddingVertical: 14,
        flexDirection: 'row',
    },
    orderItemImg: {
        width: getwidth(80),
        height: 80,
    },
    orderRight: {
        width: getwidth(355) - 30 - getwidth(80),
        height: 80,
        paddingHorizontal: 14,
        justifyContent: 'space-between'
    },
    bottomcenter: {
        width: getwidth(355),
        height: 86,
        paddingVertical: 5,
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
    },
    orderremaker: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 26,
        justifyContent: 'center'
    },
    orderciadanTime: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 49,
        justifyContent: 'space-around'
    },
    c9f12: {
        color: '#999999',
        fontSize: 12
    },
    btntotle: {
        width: getwidth(355),
        height: 40,
        paddingHorizontal: 15,
        alignItems: 'flex-end',
        justifyContent: 'center'
    },
})
export default connect(
    (state) => ({ data: state.order.shopOrderSearchResult || {} }),
    {
        clearShopOrderSearchResult:(payload={})=>({type:'order/clearShopOrderSearchResult',payload}),
        fetchBcleDetailByOrderIdAndMerchantId:(payload={})=>({type:'order/fetchBcleDetailByOrderIdAndMerchantId',payload}),
    }
)(OrderSearch)
