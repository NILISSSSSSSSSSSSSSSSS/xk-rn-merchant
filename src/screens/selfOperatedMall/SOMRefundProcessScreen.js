/**
 * 售后进度
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
    TouchableOpacity,
    BackHandler
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import math from "../../config/math";
import * as requestApi from '../../config/requestApi';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import moment from 'moment'
import { StackActions, NavigationActions } from 'react-navigation';
import { getPreviewImage } from "../../config/utils";

const { width, height } = Dimensions.get("window");
const createResetAction = (routeName, params) => {
    return StackActions.reset({
        index: 0,
        actions: [NavigationActions.navigate({ routeName, params })]
    });
};
class SOMRefundProcessScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            refund: '',
            data: {
                goodsInfo: [],
                refundAmount: '',
                refundLogList: [],
                refundMessage: '',
                refundReason: '',
                refundTime: new Date()
            },
            isGetData: false, // 防止闪百
        }
    }

    componentDidMount() {
        Loading.show()
        this.getDetails()
        BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
    }
    // 处理物理返回。返回到订单列表
    handleBackPress = () => {
        const { navigation } = this.props
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn','')
        if (routerIn === 'SOMReturnedAllWait' || routerIn === 'SOMRefundMoney') {
            // this.props.navigation.dispatch(createResetAction("SOMOrder", { tabsIndex: 6 }));
            this.props.navigation.navigate("SOMOrder", { tabsIndex: 6 });
            return true
        } else {
            navigation.goBack();
            return true
        }
    }
    getDetails = () => {
        const { navigation } = this.props
        const refundId = navigation.getParam('refundId', '')
        let params = {
            refundId,
        }
        console.log('refundId', refundId)
        requestApi.mallOrderRefundDetail(params).then(res => {
            let temp = res.refundLogList;
            temp && temp.reverse();
            res.refundLogList = temp
            this.setState({
                data: res,
                isGetData: true,
            })
        }).catch((err)=>{
            console.log(err)
          });
    }
    componentWillUnmount() {
        Loading.hide()
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
    }
    getRefundStatus = (status = '') => {
        switch (status) {
            case 'APPLY': return '已申请'
            case 'REFUSED': return '未通过'
            case 'PRE_USER_SHIP': return '待用户发货'
            case 'PRE_PLAT_RECEIVE': return '待平台收货'
            case 'PRE_REFUND': return '待平台退款'
            case 'REFUNDING': return '退款中'
            case 'COMPLETE': return '退款完成'
            default: return '获取中'
        }
    }
    render() {
        console.log('this.props.navigation', this.props.navigation)
        const { navigation, store } = this.props;
        const { data,isGetData } = this.state
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn','')
        console.log('data', data)
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
                                    if (routerIn === 'SOMReturnedAllWait' || routerIn === 'SOMRefundMoney') {
                                        // this.props.navigation.dispatch(createResetAction("SOMOrder", { tabsIndex: 6 }));
                                        this.props.navigation.navigate("SOMOrder", { tabsIndex: 6 })
                                    } else {
                                        navigation.goBack();
                                    }
                                 }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                    title={"售后进度"}
                />
                {
                    isGetData
                    ? <ScrollView
                        showsHorizontalScrollIndicator={false}
                        showsVerticalScrollIndicator={false}
                    >

                        <View style={styles.goodsWrpa}>

                            {
                                data.goodsInfo.length > 0 && data.goodsInfo.map((item, index) => {
                                    let price = (math.divide(item.goodsPrice ,100)).toFixed(2)
                                    let borderBottom = index === data.goodsInfo.length - 1 ? {} : styles.borderBottom
                                    return (
                                        <View style={[styles.goodsItem, styles.flex_1, styles.flex_start_noCenter, borderBottom]} key={index}>
                                            <View style={[styles.flex_1, styles.flex_start]}>
                                                <View style={[styles.imgWrap, styles.flex_center]}>
                                                    <Image defaultSource={require('../../images/default/default_100.png')} source={{ uri: getPreviewImage(item.goodsPic, '50p') }} style={styles.imgStyle} />
                                                </View>
                                                <View style={[styles.flex_1, styles.goodsInfo]}>
                                                    <Text numberOfLines={2} style={styles.goodsTitle}>{item.goodsName}</Text>
                                                    <Text style={styles.goodsAttr}>{item.goodsAttr} x {item.buyCount}</Text>
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
                        <View style={styles.refundInfoWrap}>
                            <Text style={styles.refundInfoText}>订单编号：{data.refundId}</Text>
                            <Text style={[styles.refundInfoText, { marginTop: 5 }]}>退款进度：{this.getRefundStatus(data.refundStatus)}</Text>
                        </View>
                        <View style={styles.refundInfoProcess}>
                            <View style={styles.refundInfoProcessLine}>
                                {
                                    data.refundLogList.map((item, index) => {
                                        let refundInfoProcessActiveText = index === 0 ? styles.refundInfoProcessActiveText : {}
                                        let margigTop = index === 0 ? {} : { marginTop: 27 }
                                        return (
                                            <View style={[styles.flex_start_noCenter, margigTop]} key={index}>
                                                <View style={styles.refundInfoProcessCircle} />
                                                <View>
                                                    <Text style={[styles.refundInfoProcessText, refundInfoProcessActiveText]}>{item.refundInfo}</Text>
                                                    <Text style={styles.refundInfoProcessSmallText}>{moment(item.createTime * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                                                </View>
                                            </View>
                                        )
                                    })
                                }
                            </View>
                        </View>
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
    refundInfoWrap: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        margin: 10,
        marginTop: 0,
        padding: 15,
        backgroundColor: '#fff'
    },
    refundInfoText: {
        fontSize: 14,
        color: '#222'
    },
    refundInfoProcess: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        margin: 10,
        marginTop: 0,
        padding: 15,
        backgroundColor: '#fff'
    },
    refundInfoProcessLine: {
        flex: 1,
        borderLeftColor: '#D8D8D8',
        borderLeftWidth: 1,
        // minHeight: 230,
    },
    refundInfoProcessCircle: {
        width: 8,
        height: 8,
        backgroundColor: '#4A90FA',
        borderRadius: 8,
        position: 'relative',
        left: -4,
        top: 0,
        marginRight: 7
    },
    refundInfoProcessText: {
        fontSize: 14,
        color: '#999'
    },
    refundInfoProcessActiveText: {
        color: '#222'
    },
    refundInfoProcessSmallText: {
        fontSize: 12,
        color: '#999'
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
)(SOMRefundProcessScreen);
