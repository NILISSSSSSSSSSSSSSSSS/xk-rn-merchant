/**
 * 申请售后 选择类型
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
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import TextInputView from '../../components/TextInputView';
import ImageView from '../../components/ImageView';
import * as nativeApi from '../../config/nativeApi';
import { getPreviewImage } from '../../config/utils';
import * as requestApi from '../../config/requestApi';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import  math from "../../config/math.js";

const { width, height } = Dimensions.get("window");

class SOMAfterSaleCategoryScreen extends Component {
    static navigationOptions = {
        header: null
    };
    _didFocusSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('willFocus', payload =>{
            const { navigation } = this.props
            const afterSaleGoods = navigation.getParam('afterSaleGoods', [])
            const orderInfo = navigation.getParam('orderInfo', '')
            this.props.actions.setRefundAmount(afterSaleGoods,orderInfo)
            // console.log('orderStatusorderStatusorderStatus', afterSaleGoods)
            // console.log('orderInfo', orderInfo)
            this.setState({
                orderInfo,
                afterSaleGoods,
            })
        });
        this.state = {
            afterSaleGoods: [],//选择的商品
            orderInfo: {
            },// 订单信息
        }
    }

    componentDidMount() {
    }
    componentWillUnmount() {
        this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    handleChangeState = (key = '', value = '') => {
        this.setState({
            [key]: value
        })
    }
    handleAddImage = () => {

    }
    handleNavigation = (type) => {
        const { navigation } = this.props
        const { afterSaleGoods } = this.state
        let callback = navigation.getParam('callback', () => { })
        let orderInfo = navigation.getParam('orderInfo', {})
        if (type === 1) {
            navigation.navigate('SOMRefund', { afterSaleGoods: afterSaleGoods, orderInfo, callback })

        } else {
            navigation.navigate('SOMReturnedAll', { afterSaleGoods: afterSaleGoods, orderInfo, callback })

        }
    }
    render() {
        const { navigation, store } = this.props;
        const { orderInfo, } = this.state
        const afterSaleGoods = navigation.getParam('afterSaleGoods', [])
        console.log('afterSaleGoods',afterSaleGoods)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"售后申请"}
                />
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >

                    <View style={styles.goodsWrpa}>

                        {
                            afterSaleGoods.length > 0 && afterSaleGoods.map((item, index) => {
                                let price = math.divide(item.price || item.goodsPrice,100).toFixed(2)
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
                        <TouchableOpacity style={[styles.categoryItem, styles.flex_1, styles.flex_between]} onPress={() => { this.handleNavigation(1) }}>
                            <View>
                                <Text style={[styles.labelText]}>仅退款</Text>
                                <Text style={styles.labelSmallText}>未收到货（包含未签收），与卖家协商同意前提下</Text>
                            </View>
                            <Image source={require('../../images/mall/goto_gray.png')} style={styles.rightIcon} />
                        </TouchableOpacity>
                        <TouchableOpacity style={[styles.categoryItem, styles.flex_1, styles.flex_between, styles.topBorder]} onPress={() => { this.handleNavigation(2) }}>
                            <View>
                                <Text style={[styles.labelText]}>退货退款</Text>
                                <Text style={styles.labelSmallText}>已收到货，需要退换已收到的货物</Text>
                            </View>
                            <Image source={require('../../images/mall/goto_gray.png')} style={styles.rightIcon} />
                        </TouchableOpacity>
                    </View>
                </ScrollView>
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
        color: '#222'
    },
    labelSmallText: {
        fontSize: 12,
        color: '#777',
        marginTop:2
    },
    topBorder: {
        borderTopColor: '#f1f1f1',
        borderTopWidth: 1
    },
    borderBottom: {
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
    disableRefund: {
        backgroundColor: '#eee',
        color: '#777'
    },
    disableReturnAll: {
        backgroundColor: '#eee',
        color: '#777'
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMAfterSaleCategoryScreen);
