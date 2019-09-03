/**
 * 自营商城支付结果（失败或成功）
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    
    Platform,
    StatusBar,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    ScrollView,
    BackHandler,
    FlatList
} from 'react-native';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actions from '../../action/actions';
import math from "../../config/math";
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import ListEmptyCom from '../../components/ListEmptyCom';
import TextInputView from '../../components/TextInputView';
import { StackActions, NavigationActions } from 'react-navigation';
import { showSaleNumText, getPreviewImage, recodeGoGoodsDetailRoute } from '../../config/utils'

const { width, height } = Dimensions.get('window');

class SOMPayResultScreen extends Component {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
      };
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
        super(props)
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
        });
        this.state = {
            payFailed: props.navigation.state.params && props.navigation.state.params.payFailed || false,
            localCode: global.regionCode,
            limit: 3,
            page: 1,
            total: '',
            goodLists: []
        }
    }

    componentDidMount() {
        // 付款成功更新购物车列表
        // if (!this.state.payFailed) {
            let merchantId = this.props.store.user.userShop.id;
            this.props.actions.fetchMallCartList({ merchantId });
        // }
        this.getGoodsRecommend()
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        );
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    handleBackPress = () => {
        const { navigation,  } = this.props;
        const { payFailed } = this.state;
        console.log('SOMPAYRESULT')
        if (payFailed) {
            navigation.push('SOMOrder', { tabsIndex: 0 })
        } else {
            navigation.push('SOMOrder', { tabsIndex: 2})
        }
        return true
    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        this._willBlurSubscription && this._willBlurSubscription.remove()
        this._didFocusSubscription && this._didFocusSubscription.remove()
    }
    // 获取推荐商品
    getGoodsRecommend = (page = 1) => {
        Loading.show()
        const { limit,goodLists } = this.state;
        requestApi.requestMallGoodsRecommendSGoodsQPage({
            page,
            limit,
            condition: { districtCode: this.state.localCode, },

        }).then(data => {
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...goodLists, ...data.data] : goodLists;
            }
            // let _total = page === 1 ? data.total : total;
            let _total = page === 1
            ? (data)
                ? data.total
                : 0
            : total;
            let hasMore = data ? _total !== _data.length : false;

            this.setState({
                refreshing: false,
                loading: false,
                page,
                hasMore,
                total: _total,
                goodLists: _data
            });
        }).catch(() => {
            this.setState({
                refreshing: false,
                loading: false
            });
        });
    }
    // 重新支付,
    // handleRePay = () => {
    //     Loading.show()
    //     const { navigation, store } = this.props
    //     if (store.mallReducer.payOrderInfo.mallCreateOrderParams) {
    //         requestApi.createOrder(store.mallReducer.payOrderInfo).then((res) => {
    //             console.log('resresres111', res)
    //             // 拿到保存在store中的下单参数，然后重新支付，成功后清除store的参数
    //             this.props.actions.payOrderInfo(store.mallReducer.payOrderInfo)
    //             // 记录进入收银台的路由，如果是重确认订单页面进入，则如果支付失败，便于在重新支付页面做页面返回判断
    //             this.props.actions.recordPayRouter('OrderConfirm');
    //             if (res) {
    //                 navigation.navigate('SOMCashier', { cashier: res });
    //             }
    //         }).catch(err => {
    //             console.log(err)
    //         })
    //     }
    // }

    render() {
        const { navigation, store } = this.props;
        const { payFailed, goodLists } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    if (payFailed) {
                                        navigation.push('SOMOrder')

                                    } else {
                                        navigation.push('SOMOrder', { tabsIndex: 2})

                                    }
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                    title={payFailed ? '付款失败' : '付款成功'}
                />

                <View style={styles.view1}>
                    <View style={styles.view1_item1}>
                        {
                            payFailed ?
                                <Image style={styles.view1_item1_img} source={require('../../images/mall/pay_failed.png')} /> :
                                <Image style={styles.view1_item1_img} source={require('../../images/mall/pay_success.png')} />
                        }
                    </View>
                    <Text style={styles.view1_text1}>
                        {
                            payFailed ? '支付失败' : '支付成功'
                        }
                    </Text>
                    <View style={styles.view1_item2}>
                        <TouchableOpacity
                            style={[styles.v1_i2_item1,{borderWidth: 0}]}
                            onPress={() => {
                                // navigation.navigate('SOM');
                            }}
                        >
                            {/* <Text style={styles.v1_i2_text1}>返回商城</Text> */}
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={styles.v1_i2_item1}
                            onPress={() => {
                                if (payFailed) {
                                    navigation.push('SOMOrder', { tabsIndex: 0 })
                                } else {
                                    navigation.push('SOMOrder', { tabsIndex: 2})
                                }
                            }}
                        >
                            <Text style={styles.v1_i2_text1}>查看订单</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={[styles.v1_i2_item1, styles.v1_i2_item2,{borderWidth: 0}]}
                            onPress={() => {
                                // if (payFailed) { // 如果支付失败，如果是从确认订单进入，则继续下支付单并进入收银台，如果是订单列表，则返回订单列表重从开始
                                //     if (routerIn === 'OrderList') {
                                //         navigation.navigate('SOMOrder')
                                //     } else if (routerIn === 'OrderDetail') { // 如果是订单详情页面进入，失败返回订单详情页
                                //         navigation.navigate('SOMOrderDetails')
                                //     } else {
                                //         // 重新从确认订单进入
                                //         this.handleRePay()
                                //     }
                                // } else { // 如果支付成功，返回首页
                                //     navigation.navigate('Home')
                                // }
                            }}
                        >
                            {/* <Text style={[styles.v1_i2_text1, styles.v1_i2_text2]}>
                                {
                                    payFailed ? '重新支付' : '返回首页'
                                }
                            </Text> */}
                        </TouchableOpacity>
                    </View>
                </View>
                <View style={styles.v2_item1}>
                    <Text style={styles.v2_text1}>热门推荐</Text>
                </View>
                <FlatList
                    ListEmptyComponent={<ListEmptyCom />}
                    store={this.state}
                    data={goodLists}
                    ItemSeparatorComponent={() => (
                        <View style={styles.flatListLine} />
                    )}
                    style={{marginHorizontal:10,backgroundColor: '#fff',}}
                    renderItem={({item,index}) => {
                        return (
                            <TouchableOpacity
                                key={index}
                                style={styles.content_ord}
                                onPress={() => {
                                    recodeGoGoodsDetailRoute();
                                    navigation.push("SOMGoodsDetail", {
                                        goodsId: item.id
                                    });
                                }}
                            >
                                <View style={styles.item_shop_imgView}>
                                    <Image style={styles.item_shop_img} source={{ uri: getPreviewImage(item.pic, '50p') }} />
                                </View>
                                <View style={styles.item_shop_other}>
                                    <View style={styles.item_shop_titleView}>
                                        <Text style={styles.item_shop_title} numberOfLines={2}> {item.name}</Text>
                                    </View>
                                    <Text style={styles.item_shop_guige} numberOfLines={1}>销售量：{showSaleNumText(item.saleQ)}</Text>
                                    <Text style={[styles.item_shop_guige, styles.item_shop_price1]}>价格：<Text style={styles.item_shop_price2}>{(math.divide (item.buyPrice || 0, 100)).toFixed(2)}</Text></Text>
                                </View>
                            </TouchableOpacity>
                        )
                    }}
                    numColumns={1}
                    loadMoreData={() => {
                        this.getGoodsRecommend(this.state.page + 1);
                    }}
                />
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    view1: {
        width: width - 20,
        height: 223,
        margin: 10,
        borderRadius: 6,
        backgroundColor: '#fff',
        // ...CommonStyles.shadowStyle,
    },
    view1_item1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 30,
    },
    view1_item1_img: {
        width: 66,
        height: 66,
    },
    view1_text1: {
        fontSize: 17,
        color: '#222',
        textAlign: 'center',
        marginTop: 16,
    },
    view1_item2: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: 30,
        marginTop: 38,
        paddingLeft: 15,
    },
    v1_i2_item1: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: '100%',
        marginRight: 15,
        borderWidth: 1,
        borderColor: '#999',
        borderRadius: 4,
    },
    v1_i2_text1: {
        fontSize: 14,
        color: '#999',
    },
    v1_i2_item2: {
        borderColor: '#4A90FA',
    },
    v1_i2_text2: {
        color: '#4A90FA',
    },
    v2_item1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        height: 32,
        paddingHorizontal: 10,
        backgroundColor: '#fff',
        marginHorizontal: 10,
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
    v2_text1: {
        fontSize: 14,
        color: '#222',
    },
    content_ord: {
        flexDirection: 'row',
        width: '100%',
        height: 99,
        paddingVertical: 15,
        paddingHorizontal: 10,
        borderTopWidth: 1,
        borderTopColor: '#F1F1F1',
    },
    item_shop_imgView: {
        width: 70,
        height: 70,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 10,
    },
    item_shop_img: {
        width: '100%',
        height: '100%',
        borderRadius: 6,
    },
    item_shop_other: {
        flex: 1,
        marginLeft: 10,
    },
    item_shop_titleView: {
        height: 36,
    },
    item_shop_title: {
        fontSize: 14,
        color: '#222',
    },
    item_shop_guige: {
        fontSize: 12,
        color: '#999',
        marginTop: 10,
    },
    item_shop_price1: {
        marginTop: 0,
    },
    item_shop_price2: {
        fontSize: 12,
        color: '#101010',
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50
    },

    flatListLine: {
        height: 0,
        backgroundColor: "#EEEEEE"
    },
});

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMPayResultScreen);
