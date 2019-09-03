/**
 * 申请售后 退款等待审核
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
    BackHandler,
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import * as requestApi from '../../config/requestApi'
import CountDown from '../../components/CountDown';
import moment from 'moment'
import math from "../../config/math";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import { getPreviewImage, keepTwoDecimalFull } from "../../config/utils";

const { width, height } = Dimensions.get("window");

class SOMRefundMoneyScreen extends Component {
    static navigationOptions = {
        header: null
    };

    timer = null;
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('willFocus', payload =>{
            this.getNavigaionParam();
            BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
        });
        this.state = {
            detail: {
                goodsInfo: [{
                    refundCount:0,
                }],
                refundAmount: 0,
                refundReason: ''
            },
            isGetData: false, // 防止闪百
            isRefused: false,
            countDown: '提交',
        }
    }
    handleCountDown = (dealline) => {
        let time = moment(dealline).diff(moment());
        this.timer = setInterval(() => {
            let t = null;
            let d = null;
            let h = null;
            let m = null;
            let s = null;
            //js默认时间戳为毫秒,需要转化成秒
            t = time / 1000;
            d = Math.floor(t / (24 * 3600));
            h = Math.floor((t - 24 * 3600 * d) / 3600);
            m = Math.floor((t - 24 * 3600 * d - h * 3600) / 60);
            s = Math.floor((t - 24 * 3600 * d - h * 3600 - m * 60));
            time -= 1000;
            if (time < 0) {
                this.setState({
                    showSubmit: true,
                    countDown: '提交'
                }, () => {
                    clearInterval(this.timer)
                })
                return
            }
            this.setState({
                countDown: d + ((d === 0) ? '' : '天') + h + ((h === 0) ? '' : '小时') + m + '分钟' + s + '秒'
            })
            Loading.hide();
        }, 1000)
    }
    componentDidMount() {
        Loading.hide();
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        );
    }
    getNavigaionParam = () => {
        Loading.show();
        let refundId = this.props.navigation.getParam('refundId', '')
        requestApi.mallOrderRefundDetail({
            refundId,
        }).then(res => {
            // res.goodsInfo[0].refundCount = 2
            let isRefused = false
            // 如果进入平台退款流程
            if (res.refundStatus === 'PRE_REFUND' || res.refundStatus === 'REFUNDING' || res.refundStatus === 'COMPLETE') {
                this.props.navigation.navigate('SOMRefundProcess', { refundId: refundId, routerIn: 'SOMRefundMoney' })
            } else if (res.refundStatus === 'APPLY') { // 如果是审核状态
                this.handleCountDown(moment(res.refundTime * 1000).add(res.refundAutoAcceptTime, 's'))
            } else { // 如果平台拒绝
                isRefused = true
            }
            this.setState({
                detail: res,
                isRefused,
                isGetData: true, // 防止闪百
            }, () => {
                this.props.actions.setRefundAmount(res.goodsInfo, res)
            })
        }).catch(err => {
            console.log(err)
        })
    }
    componentWillUnmount() {
        this.timer && clearInterval(this.timer);
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    // 处理物理返回。返回到订单列表
    handleBackPress = () => {
        const { navigation } = this.props
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn', () => { })
        callback()
        let isFocused = this.props.navigation.isFocused()
        console.log('isFocused', isFocused)
        if (isFocused) {
            if (routerIn === 'details') {
                navigation.goBack()
                return true;
            }
            this.props.navigation.navigate("SOMOrder");
            return true
        }
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        return false
    }
    handleChangeState = (key = '', value = '') => {
        this.setState({
            [key]: value
        })
    }
    handleRefundAgain = () => {
        const { detail } = this.state
        const { navigation } = this.props
        let _detail = JSON.parse(JSON.stringify(detail))
        if (_detail.goodsInfo[0].refundCount >= 2) {
            Toast.show('超出申请次数限制，暂不能申请！')
            return
        }
        _detail.goodsInfo.map(item => {
            item['num'] = item.buyCount
            item['price'] = item.realPrice
            item['goodsShowAttr'] = item.goodsAttr
            item['goodsPic'] = item.goodsPic
        })
        // navigation.navigate("SOMRefund", {
        //     orderInfo: _detail,
        //     afterSaleGoods: _detail.goodsInfo,
        //     callback: this.getNavigaionParam
        // });
        navigation.navigate('SOMAfterSaleCategory', {
            afterSaleGoods: _detail.goodsInfo,
            orderInfo:_detail,
            callback: this.getNavigaionParam
        })
    }
    getRefundPrice = (data) => {
        let allPice = 0;
        data.goodsInfo.map(item => {
            allPice += math.divide (item.realPrice , 100)
        })
        allPice +=math.divide (data.postFee , 100)
        return allPice
    }
    render() {
        const { navigation, store } = this.props;
        const { detail,countDown,isRefused,isGetData } = this.state
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn', '')
        let refundId = this.props.navigation.getParam('refundId', '')
        let refundAmount = (store.mallReducer.refundAmount || 0)
        console.log('detail',detail)
        console.log("sd",moment(detail.refundTime * 1000).add(detail.refundAutoAcceptTime,'s'))
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"退款申请"}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    if (routerIn === 'details') {
                                        navigation.goBack()
                                    }
                                    if (routerIn === 'refundMoney') {
                                        navigation.navigate('SOMOrder');
                                        if (callback) { callback() }
                                    }
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                />
                {
                    isGetData
                    ? <ScrollView
                        showsHorizontalScrollIndicator={false}
                        showsVerticalScrollIndicator={false}
                    >
                        <View style={styles.goodsWrpa}>
                            {
                                detail.goodsInfo.length > 0 && detail.goodsInfo.map((item, index) => {
                                    let price =math.divide (item.goodsPrice || 0, 100);
                                    let borderBottom = index === detail.goodsInfo.length - 1 ? {} : styles.borderBottom
                                    return (
                                        <View style={[styles.goodsItem, styles.flex_1, styles.flex_start_noCenter, borderBottom]} key={index}>
                                            <View style={[styles.flex_1, styles.flex_start]}>
                                                <View style={[styles.imgWrap, styles.flex_center]}>
                                                    <Image defaultSource={require('../../images/default/default_100.png')} source={{ uri: getPreviewImage(item.goodsPic, '50p') }} style={styles.imgStyle} />
                                                </View>
                                                <View style={[styles.flex_1, styles.goodsInfo]}>
                                                    <Text numberOfLines={2} style={styles.goodsTitle}>{item.goodsName}</Text>
                                                    <Text style={styles.goodsAttr}>{(item.goodsAttr && item.goodsAttr) ? `${item.goodsAttr} x ${item.buyCount}`: ''}</Text>
                                                    <View style={[styles.flex_1, styles.flex_start_noCenter,{ marginTop: 5 }]}>
                                                        <Text style={styles.goodsPriceLabel}>价格:</Text>
                                                        <Text style={styles.goodsPriceValue}>￥{price}</Text>
                                                    </View>
                                                </View>
                                            </View>
                                        </View>
                                    )
                                })
                            }
                        </View>
                        <View style={styles.selectWrap}>
                            <View style={[styles.categoryItem, styles.flex_1, styles.flex_between]}>
                                <View>
                                    <Text style={styles.labelText}>退货原因: {detail.refundReason}</Text>
                                </View>
                            </View>
                            <View style={[styles.categoryItem, styles.flex_1, styles.flex_between, styles.topBorder]}>
                                <View style={styles.flex_start}>
                                    <Text style={styles.labelText}>退款金额:</Text>
                                    <Text style={[styles.labelText, styles.labelValue]}>￥{keepTwoDecimalFull(math.divide(refundAmount , 100))}</Text>
                                </View>
                            </View>
                        </View>
                        {
                            !isRefused
                            ? <View style={{paddingLeft: 10,paddingBottom: 10}}>
                                    <Text style={styles.noticeInfoText}>* 若卖家在规定时间内未处理，系统将自动为您退款</Text>
                            </View>
                            : <View style={{paddingLeft: 10,paddingBottom: 10}}>
                                <Text style={styles.noticeInfoText}>* 审核未通过 { (detail.goodsInfo[0].refundCount >= 2) ? '，如有疑问，请联系客服！': ''}</Text>
                            </View>
                        }
                        {
                            isRefused
                            ? !(detail.goodsInfo[0].refundCount >= 2) ? // 拒绝了判断是否申请了两次
                                <TouchableOpacity
                                    style={[styles.countDownWrap]}
                                    onPress={() => {
                                        Loading.show();
                                        this.handleRefundAgain()
                                    }}
                                >
                                    <Text style={[styles.countDownText]}>再次申请</Text>
                                </TouchableOpacity>
                                : null
                            : (countDown !== '提交' && detail.refundAutoAcceptTime !== 0)
                            ? // 没有被拒绝并且时间未到
                                <View style={styles.countDownWrap}>
                                    <CountDown
                                        date={moment(detail.refundTime * 1000).add(detail.refundAutoAcceptTime,'s')}
                                        days={{ plural: ' ', singular: ' ' }}
                                        hours=':'
                                        mins=':'
                                        segs=' '
                                        type='orderApply'
                                        label='等待卖家同意'
                                        daysStyle={styles.countDownText}
                                        hoursStyle={styles.countDownText}
                                        minsStyle={styles.countDownText}
                                        secsStyle={styles.countDownText}
                                        firstColonStyle={styles.countDownText}
                                        secondColonStyle={styles.countDownText}
                                        onEnd={() => {
                                            console.log('时间到')
                                            // navigation.navigate('SOMRefundProcess', { refundId: refundId })
                                        }}
                                    />
                                </View>
                            : <View style={styles.countDownWrap}>
                                <Text style={styles.countDownText}>等待卖家同意</Text>
                            </View>

                        }
                    </ScrollView>
                    : null
                }

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flex_center: {
        justifyContent: 'center',
        alignItems: 'center'
    },
    flex_start: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
        alignItems: 'center'
    },
    flex_start_noCenter: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
    },
    flex_between: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    flex_1: {
        flex: 1
    },
    goodsWrpa: {
        borderRadius: 8,
        backgroundColor: '#fff',
        margin: 10,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        overflow: 'hidden',
        // marginBottom: 60
    },
    goodsItem: {
        padding: 15,
        backgroundColor: '#fff',
    },
    selectedBtnWrap: {
        marginRight: 10
    },
    unSelected: {
        width: 15,
        height: 15,
        borderWidth: 1,
        borderColor: '#979797',
        borderRadius: 15,
    },
    goodsTitle: {
        lineHeight: 17,
        fontSize: 12,
        color: '#222'
    },
    imgStyle: {
        height: 69,
        borderRadius: 6,
        width: 69,
    },
    imgWrap: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: '#E5E5E5',
        backgroundColor: '#fff',
        height: 69,
        width: 69,
    },
    goodsInfo: {
        paddingLeft: 10,
        flex: 1
    },
    goodsAttr: {
        fontSize: 10,
        color: '#999',
        marginTop: 5
    },
    goodsPriceLabel: {
        fontSize: 10,
        color: '#999',
    },
    goodsPriceValue: {
        fontSize: 10,
        color: '#101010',
        paddingLeft: 7
    },

    selectWrap: {
        margin: 10,
        marginTop: 0,
        borderRadius: 8,
        backgroundColor: '#fff',
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
    },
    categoryItem: {
        padding: 15
    },
    labelText: {
        fontSize: 14,
        color: '#222',

    },
    labelSmallText: {
        fontSize: 12,
        color: '#777',
    },
    topBorder: {
        borderTopColor: '#f1f1f1',
        borderTopWidth: 1
    },
    selectReason: {
        fontSize: 14,
        color: '#999',
        paddingRight: 4
    },
    labelValue: {
        fontSize: 12,
        color: '#222',
        paddingLeft: 4
    },
    marginTop: {
        marginTop: 5
    },
    borderBottom: {
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
    block: {
        width,
        height: 5,
        backgroundColor: '#F1F1F1',
        position: 'absolute',
        top: 0,
        left: 0
    },
    bottomBtn: {
        margin: 10,
        paddingVertical: 11,
        backgroundColor: '#4A90FA',
        borderRadius: 8
    },
    bottomBtnText: {
        textAlign: 'center',
        color: '#fff',
        fontSize: 17
    },
    countDownText: {
        fontSize: 17,
        color: '#fff',
        textAlign: 'center'
    },
    countDownWrap: {
        marginHorizontal: 10,
        marginBottom: 30,
        borderRadius: 8,
        backgroundColor: '#4A90FA',
        height: 44,
        justifyContent: 'center',
        alignItems: 'center'
    },
    noticeInfoText: {
        color: '#EE6161',
        fontSize: 12,
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
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMRefundMoneyScreen);
