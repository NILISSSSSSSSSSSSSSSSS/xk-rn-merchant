/**
 * 申请售后 退款
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Modal,
    Image,
    ScrollView,
    TouchableOpacity
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import * as requestApi from '../../config/requestApi'
import math from "../../config/math";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import { getPreviewImage, keepTwoDecimalFull } from "../../config/utils";

const { width, height } = Dimensions.get("window");

class SOMRefundScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            afterSaleGoods: [],
            reason: '请选择',
            reasonId: '',
            allprice: '',
            modalVisible: false,
            reasonList: [],
        }
        this.debounceApplyRefund = this.handleApplyRefund
    }

    componentDidMount() {
        Loading.show()
        this.getNavigaionParam()
        this.getReasonList()
    }
    // 获取原因列表
    getReasonList = () => {
        requestApi.fetchMallRefundReasonList().then(res => {
            console.log('resresresresresresresres', res)
            this.handleChangeState('reasonList', res)
        }).catch(err => {
            // this.getReasonList()
        })
    }
    getNavigaionParam = () => {
        const { navigation } = this.props
        const afterSaleGoods = navigation.getParam('afterSaleGoods', [])
        const orderInfo = navigation.getParam('orderInfo', {})
        console.log('orderInfo',orderInfo)
        console.log('afterSaleGoods',afterSaleGoods)
        let allprice = 0
        afterSaleGoods.map((item, index) => {
            console.log(item)
            allprice += item.realPrice
        })
        // 退款时，如果订单是待发货且选择了所有的订单商品，则退运费，否则不退
        if (orderInfo.orderStatus === 'PRE_SHIP' && orderInfo.goods.length === afterSaleGoods.length) {
            console.log('orderInfo')
            allprice += orderInfo.postFee
        }
        this.setState({
            allprice: (math.divide(allprice , 100)).toFixed(2),
            afterSaleGoods,
        })
    }
    componentWillUnmount() {
        this.setState({
            modalVisible: false
        })
    }
    handleChangeState = (key = '', value = '') => {
        this.setState({
            [key]: value
        }, () => {
            console.log('%cChangeState', 'color:green', this.state)
        })
    }
    handleApplyRefund = () => {
        const { navigation } = this.props
        const { reason, reasonId, afterSaleGoods } = this.state
        const orderInfo = navigation.getParam('orderInfo', {})
        let callback = navigation.getParam('callback', () => { })
        if (reason === '请选择' || reasonId === '') return
        Loading.show()
        let temp = afterSaleGoods.map(item => {
            return {
                goodsId: item.goodsId,
                goodsSkuCode: item.goodsSkuCode
            }
        })
        let params = {
            mallRefundOrderParams: {
                refundType: 'REFUND', //退款REFUND，退货并退款REFUND_GOODS
                refundGoods: temp,
                orderId: orderInfo.orderId,
                refundReasonId: reasonId,
                refundMessage: '',
                refundEvidence: [],
            }
        }
        requestApi.mallOrderMUserRefund(params).then(res => {
            Toast.show('申请成功!', 2000)
            navigation.navigate('SOMRefundMoney', { refundId: res.refundId, callback, routerIn: 'refundMoney' })
            console.log('退款接口', res)
        }).catch(err => {
            Toast.show('申请失败，请重试!')
            Loading.hide();
        })
        console.log('退款参数', params)
    }
    render() {
        const { navigation, store } = this.props;
        const { afterSaleGoods, reason, reasonList, allprice, modalVisible } = this.state
        let refundAmount = (store.mallReducer.refundAmount || 0)
        console.log(afterSaleGoods)
        console.log(reason)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"退款申请"}
                />
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >

                    <View style={styles.goodsWrpa}>

                        {
                            afterSaleGoods.length > 0 && afterSaleGoods.map((item, index) => {
                                let price = (math.divide(item.price || item.goodsPrice,100)).toFixed(2)
                                let borderBottom = index === afterSaleGoods.length - 1 ? {} : styles.borderBottom
                                return (
                                    <View style={[styles.goodsItem, styles.flex_1, styles.flex_start_noCenter, borderBottom]} key={index}>
                                        <View style={[styles.flex_1, styles.flex_start]}>
                                            <View style={[styles.imgWrap, styles.flex_center]}>
                                                <Image source={{ uri: getPreviewImage(item.goodsPic, '50p') }} style={styles.imgStyle} />
                                            </View>
                                            <View style={[styles.flex_1, styles.goodsInfo]}>
                                                <Text numberOfLines={2} style={styles.goodsTitle}>{item.goodsName}</Text>
                                                <Text style={styles.goodsAttr}>{item.goodsShowAttr} x {item.num}</Text>
                                                <View style={[styles.flex_1, styles.flex_start, { marginTop: 5 }]}>
                                                    <Text style={styles.goodsPriceLabel}>价格:</Text>
                                                    <Text style={styles.goodsPriceValue}>{price}</Text>
                                                </View>
                                            </View>
                                        </View>
                                    </View>
                                )
                            })
                        }
                    </View>
                    <View style={styles.selectWrap}>
                        <TouchableOpacity style={[styles.categoryItem, styles.flex_1, styles.flex_between]} onPress={() => { this.handleChangeState('modalVisible', true) }}>
                            <View>
                                <Text style={styles.labelText}>退货原因:</Text>
                            </View>
                            <View style={styles.flex_start} >
                                <Text style={styles.selectReason}>{reason}</Text>
                                <Image source={require('../../images/mall/goto_gray.png')} style={styles.rightIcon} />
                            </View>
                        </TouchableOpacity>
                        <View style={[styles.categoryItem, styles.flex_1, styles.flex_between, styles.topBorder]}>
                            <View style={styles.flex_start}>
                                <Text style={styles.labelText}>退款金额:</Text>
                                <Text style={[styles.labelText, styles.labelValue]}>{keepTwoDecimalFull(math.divide(refundAmount , 100) )}</Text>
                            </View>
                        </View>
                    </View>
                    <TouchableOpacity activeOpacity={(reason === '请选择') ? 1 : 0.2} style={[styles.bottomBtn, (reason === '请选择') ? styles.disableBtn : {}]} onPress={() => {
                        Loading.show();
                        this.debounceApplyRefund();
                    }}>
                        <Text style={styles.bottomBtnText}>提交</Text>
                    </TouchableOpacity>
                </ScrollView>
                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => {
                        console.log(0)
                    }}
                >
                    <View style={styles.modal}>
                        <View style={styles.modalContent}>
                            <View style={[styles.modalItem, styles.flex_center, styles.borderBottom]}>
                                <Text style={[styles.modalItemText, styles.color_red]}>退款原因</Text>
                            </View>
                            <ScrollView
                                showsHorizontalScrollIndicator={false}
                            >
                                {
                                    reasonList.length > 0 && reasonList.map((item, index) => {
                                        return (
                                            <TouchableOpacity
                                                key={index}
                                                style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                                onPress={() => {
                                                    this.setState({
                                                        reason: item.refundReason,
                                                        reasonId: item.refundReasonId,
                                                        modalVisible: false
                                                    })
                                                }}>
                                                <Text style={styles.modalItemText}>{item.refundReason}</Text>
                                            </TouchableOpacity>
                                        )
                                    })
                                }
                            </ScrollView>
                            <TouchableOpacity activeOpacity={1} onPress={() => { this.handleChangeState('modalVisible', false) }} style={[styles.modalItem, styles.flex_center]}>
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
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
        width: 69,
        borderRadius: 6,
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
    modal: {
        // height: 342,
        flex: 1,
        backgroundColor: 'rgba(10,10,10,.5)',
        position: 'relative'
    },
    modalContent: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        width,
        backgroundColor: '#fff',
        maxHeight: 335 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
    },
    color_red: {
        color: '#EE6161'
    },
    modalItemText: {
        fontSize: 17,
        color: '#222',

    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: 'relative'
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
    disableBtn: {
        backgroundColor: '#999'
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMRefundScreen);
