/**
 * 申请售后
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
    Platform
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import  math from "../../config/math.js";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import ImageView from '../../components/ImageView'
import { getPreviewImage } from "../../config/utils";
const { width, height } = Dimensions.get("window");

class SOMAfterSaleScreen extends Component {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            goodsData: {
                goods: []
            },
            selectAll: false,
            selectData: []
        }
    }

    componentDidMount() {
        let data = this.props.navigation.getParam('orderDdata', {})
        // console.log(data)
        let temp = data.goods.map((item) => {
            item['selected'] = false
            return item
        })
        // console.log('goodsData',data)
        data.goods = temp
        this.handleChangeState('goodsData', data)
    }

    componentWillUnmount() {
    }

    // 选择商品
    handleSelectGoods = (item, index) => {
        const { goodsData } = this.state
        let data = JSON.parse(JSON.stringify(this.state.goodsData))
        let temp = goodsData.goods.map((itemData, index) => {
            if (item.goodsId === itemData.goodsId) {
                itemData.selected = !itemData.selected
                return itemData
            }
            return itemData
        })
        data.goods = temp
        // 是否取消选择
        let temp1 = []
        temp.map(itemData => {
            if (itemData.selected) {
                temp1.push(itemData)
            }
        })
        // console.log('tetetete', temp1)
        this.setState({
            goodsData,
            selectData: temp1,
            selectAll: (temp1.length === goodsData.goods.length)
        })
    }
    // 全选
    handleSelectAll = () => {
        const { selectAll } = this.state
        let data = JSON.parse(JSON.stringify(this.state.goodsData))
        let temp = data.goods.map((item, index) => {
            if (selectAll) {
                item.selected = false
                return item
            }
            item.selected = true
            return item
        })
        data.goods = temp
        this.setState({
            selectAll: !selectAll,
            goodsData: data,
            selectData: (temp[0].selected) ? temp : []
        })
    }
    // 确认退货
    handleRefund = () => {
        const { selectData } = this.state
        const { navigation } = this.props
        // 刷新订单列表的回调函数
        let callback = navigation.getParam('callback', () => { })
        if (selectData.length === 0) return
        navigation.navigate('SOMAfterSaleCategory', { afterSaleGoods: selectData, orderInfo: this.state.goodsData, callback, })
        // console.log('selectData',selectData)
    }
    handleChangeState = (key, value) => {
        this.setState({
            [key]: value
        }, () => {
            // console.log('%cChangeState', 'color:green', this.state)
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { goodsData, selectAll, selectData } = this.state
        console.log('goodsData',selectData)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"申请售后"}
                />
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                >

                    <View style={styles.goodsWrpa}>

                        {
                            goodsData.goods.length > 0 && goodsData.goods.map((item, index) => {
                                let price =math.divide(item.price ,100)
                                let borderBottom = index === goodsData.goods.length - 1 ? {} : styles.borderBottom
                                return (
                                    <View style={[styles.goodsItem, styles.flex_1, styles.flex_start_noCenter, borderBottom]} key={index}>
                                        <View style={[styles.selectedBtn, styles.flex_start]}>
                                            <TouchableOpacity onPress={() => { this.handleSelectGoods(item, index) }} style={styles.selectedBtnWrap}>
                                                {
                                                    item.selected ?
                                                        <ImageView
                                                            source={require('../../images/order/selected.png')}
                                                            sourceWidth={15}
                                                            sourceHeight={15}
                                                        /> :
                                                        <View style={styles.unSelected}></View>
                                                }
                                            </TouchableOpacity>

                                        </View>
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
                </ScrollView>
                <View style={[styles.flex_between, styles.btmOperate]}>
                    <TouchableOpacity style={[styles.selectedBtnWrap_operate, styles.flex_start]} onPress={this.handleSelectAll}>
                        {
                            (selectAll) ?
                                <ImageView
                                    source={require('../../images/order/selected.png')}
                                    sourceWidth={15}
                                    sourceHeight={15}
                                /> :
                                <View style={styles.unSelected}></View>
                        }
                        <Text style={styles.selectAllText}>全选</Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={(selectData.length > 0) ? styles.btmOperate_entryBtn : styles.btmOperate_entryBtn_disable} onPress={this.handleRefund}>
                        <Text style={(selectData.length > 0) ? styles.btmOperate_entryText : styles.btmOperate_entryText_disable}>确认退货</Text>
                    </TouchableOpacity>
                </View>
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
        marginBottom: 40 + (Platform.OS === 'ios' ? CommonStyles.footerPadding: 0),
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
    btmOperate: {
        // minHeight: 50,
        height: Platform.OS === 'ios' ? 50 + CommonStyles.footerPadding: 50,
        backgroundColor: '#fff',
        width,
        borderTopWidth: 1,
        borderTopColor: '#f1f1f1',
        paddingBottom: Platform.OS === 'ios' ? CommonStyles.footerPadding: 0,
    },
    selectAllText: {
        fontSize: 14,
        color: '#222',
        paddingLeft: 8
    },
    selectedBtnWrap_operate: {
        paddingLeft: 20,
    },
    btmOperate_entryBtn: {
        paddingVertical: 2,
        paddingLeft: 12,
        paddingRight: 10,
        borderWidth: 1,
        borderColor: '#EE6161',
        borderRadius: 40,
        marginRight: 25
    },
    btmOperate_entryText: {
        fontSize: 12,
        color: '#EE6161'
    },
    btmOperate_entryText_disable: {
        fontSize: 12,
        color: '#999'
    },
    btmOperate_entryBtn_disable: {
        borderColor: '#999',
        paddingVertical: 2,
        paddingLeft: 12,
        paddingRight: 10,
        borderWidth: 1,
        borderRadius: 40,
        marginRight: 25
    },
    borderBottom: {
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMAfterSaleScreen);
