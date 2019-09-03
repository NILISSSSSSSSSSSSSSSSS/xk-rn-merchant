/**
 * 自营商城购物车
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    Platform,
    View,
    Text,
    Keyboard,
    TouchableOpacity,
    Image,
    Button,
    Modal,
    ImageBackground,
    ScrollView,
} from 'react-native';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actions from '../../action/actions';
import moment from 'moment'
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import ListEmptyCom from '../../components/ListEmptyCom';
import { getPreviewImage, recodeGoGoodsDetailRoute } from '../../config/utils';
import  math from "../../config/math.js";
const { width, height } = Dimensions.get('window');
const leftYHQ = require('../../images/indianashopcart/leftYHQ.png')
const xiangUp = require('../../images/indianashopcart/xiangUp.png')
const xiangDown = require('../../images/indianashopcart/xiangDown.png')
const didlq = require('../../images/indianashopcart/didlq.png')
// const default_Image = require('../../images/skeleton/skeleton_img.png')
const shixiao = require('../../images/indianashopcart/shixiao.png')
function getwidth(val) {
    return width * val / 375
}
class SOMShoppingCartScreen extends Component {
    static navigationOptions = {
        header: null,
    }
    _didFocusSubscription;
    constructor (props) {
        super(props)
        // this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
        //     this.refresh();
        // });
        this.state = {
            data: [],
            textInputData: null,  // 当前点击的 textInput 数据
            isManager: false,  // 是否是管理模式
            selectedAll: false,  // 是否全选
            modalVisible: false,
            youHuiQuan: null,   //商品可选的优惠券列表
        }
        this.chooseGoodsId = null
    }

    static getDerivedStateFromProps(props, state) {
        // 付款成功更新购物车列表需要
        if (props.store.mallReducer.cartLists !== state.data) {
            return {
                data: props.store.mallReducer.cartLists
            }
        }
        return null
    }

    componentDidMount() {
        Loading.show();
        this.refresh();
        // console.log(this.props)
    }
    componentWillUnmount () {
        // this._didFocusSubscription && this._didFocusSubscription.remove();
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    refresh = () => {
        Keyboard.dismiss();
        let merchantId = this.props.store.user.userShop.id;
        this.props.actions.fetchMallCartList({ merchantId }, (data) => {
            Loading.hide();
            this.changeState('data', data);
        });
    }

    // 跳转商品详情
    _goToDetail = (item) => {
        Keyboard.dismiss();
        let _goodsData = {
            ...item,
            cartId: item.id,
            id: item.goodsId,
        };
        recodeGoGoodsDetailRoute()
        this.props.navigation.push('SOMGoodsDetail', { goodsId: _goodsData.id });
    }

    // 过滤未选择的数据
    filterLists = (item) => {
        Keyboard.dismiss();
        let _data = [];
        let data = item || this.state.data;
        for (let i = 0; i < data.length; i++) {
            if (data[i].selected_status) {
                _data.push(data[i]);
            }
        }
        return _data;
    }

    // 已选商品总价
    _totalPrice = () => {
        let price = 0;
        let data = this.state.data;
        for (let i = 0; i < data.length; i++) {
            if (data[i].selected_status && data[i].status !== 0) {
                price += data[i].price * data[i].quantity;
            }
        }
        return price;
    }

    // 切换商品选择状态
    _changeMallCartList = (item) => {
        Keyboard.dismiss();
        const { selectedAll, isManager } = this.state
        let data = isManager ? this.state.data : this.state.data.filter(dataItem => dataItem.status !== 0 );
        if (!selectedAll) {
            for (let i = 0; i < data.length; i++) {
                if (item) {
                    if (item.id === data[i].id) {
                        data[i].selected_status = !data[i].selected_status;
                    }
                } else {
                    data[i].selected_status = true;
                }
            }
        } else {
            for (let i = 0; i < data.length; i++) {
                if (item) {
                    if (item.id === data[i].id) {
                        data[i].selected_status = !data[i].selected_status;
                    }
                } else {
                    data[i].selected_status = false;
                }
            }
        }

        let selectLen = this.filterLists(data);
        if (selectLen.length === data.length && selectLen.length !== 0) {
            this.changeState('selectedAll', true);
        } else {
            this.changeState('selectedAll', false);
        }
        this.props.actions.changeMallCartList(data);
    }

    // 切换商品数量
    _changeGoodNum = (item, num, type) => {
        let data = this.state.data;
        for (let i = 0; i < data.length; i++) {
            if (item.id === data[i].id) {
                if (type) {
                    let re = /^[1-9]+[0-9]*]*$/;
                    if (!re.test(num)) {
                        this.textInput.clear();
                        Toast.show('商品数量必须为整数');
                        return
                    }
                    if (Number(num) > 9999) {
                        Toast.show('商品数量不能超过9999')
                    } else {
                        data[i].quantity = Number(num);
                    }
                } else {
                    let _num = data[i].quantity + num;
                    if (_num < 1) {
                        Toast.show('商品最小数量为1');
                        return
                    }
                    if (_num > 9999) {
                        Toast.show('商品数量不能超过9999')
                        return
                    }
                    data[i].quantity = _num;
                }
            }
        }
        this.props.actions.changeMallCartList(data);
        requestApi.requestMallCartBatchUpdate(data);
    }

    // 优惠劵列表
    getCouponLists = (item) => {
        requestApi.requestMallCardGoodsList({ goodsId: item.goodsId }, (data) => {
            if (!data || data.length === 0) {
                Toast.show('没有可选的优惠券');
                return
            } else {
                let youHuiQuan = data.data
                this.chooseGoodsId = item.goodsId
                youHuiQuan.forEach(element => {
                    element.detailVisible = false
                })
                this.setState({
                    youHuiQuan,
                    modalVisible: true
                })
            }

        });
    }

    // 批量删除
    _deleteGoods = (data) => {
        if (data.length === 0) {
            Toast.show('请选择商品');
            return
        }
        requestApi.requestMallCartBatchDestory(data, (res) => {
            this.changeState('isManager', !this.state.isManager);
            Toast.show('删除成功');
            this.refresh();
        });
    }

    // 批量移入收藏
    _moveToCollect = (data) => {
        if (data.length === 0) {
            Toast.show('请选择商品');
            return
        }
        // 是否有失效商品
        let expireArr =  data.filter(item => item.status === 0)
        if (expireArr.length !== 0) {
            Toast.show('不能将失效商品加入到收藏夹');
            return;
          }
        requestApi.requestMallCartMoveToCollect(data, (res) => {
            console.log('收藏',res)
            // this.changeState('isManager', !this.state.isManager);
            Toast.show('收藏成功');
            this.refresh();
        });
    }

    renderItem = ({ item, index }) => {
        const { data, textInputData } = this.state;
        let lineStyle = index === 0 ? styles.itemView1 : styles.itemLine;
        let radiusStyle = index === data.length - 1 ? styles.itemView2 : null;
        return (
            <View style={[styles.itemView, lineStyle, radiusStyle]}>

                <View style={styles.item_right}>
                    {
                        item.status === 0 ? (
                            <React.Fragment>
                                {
                                    (this.state.isManager)
                                        ? <TouchableOpacity
                                            style={styles.item_left}
                                            onPress={() => {
                                                this._changeMallCartList(item);
                                            }}
                                        >
                                            {
                                                item.selected_status
                                                ?<Image style={{height:18,width:18}} source={require('../../images/mall/checked.png')} />
                                                :<Image style={{height:18,width:18}}  source={require('../../images/mall/unchecked.png')} />
                                            }
                                        </TouchableOpacity>
                                        : null
                                }
                                <View style={{ width: 44, height: getwidth(80), justifyContent: 'center', alignItems: 'center' }}>
                                    <Image source={shixiao} />
                                </View>
                            </React.Fragment>
                        ) : (
                                <TouchableOpacity
                                    style={styles.item_left}
                                    onPress={() => {
                                        this._changeMallCartList(item);
                                    }}
                                >
                                    {
                                        item.selected_status ?
                                            <Image style={{height:18,width:18}}  source={require('../../images/mall/checked.png')} /> :
                                            <Image  style={{height:18,width:18}} source={require('../../images/mall/unchecked.png')} />
                                    }
                                </TouchableOpacity>
                            )
                    }
                    <TouchableOpacity
                        style={styles.item_shop_imgView}
                        onPress={() => {
                            this._goToDetail(item);
                        }}
                    >
                        <ImageView
                            style={styles.item_shop_img}
                            resizeMode='cover'
                            source={{ uri: getPreviewImage(item.url, '50p') }}
                            sourceWidth={80}
                            sourceHeight={80}
                        />
                    </TouchableOpacity>
                    <View style={[styles.item_shop_other]}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => { this._goToDetail(item); }}
                        >
                            <Text style={styles.item_shop_title} numberOfLines={2}>{item.goodsName}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => { this._goToDetail(item); }}
                        >
                            <Text style={styles.item_shop_guige} numberOfLines={1}>规格：{item.goodsAttr}</Text>
                        </TouchableOpacity>
                        <Text style={styles.item_shop_price1}>价格：<Text style={styles.item_shop_price2}>¥ {math.divide(item.price , 100)}</Text></Text>
                        {
                            item.status === 0 ? (
                                null
                                // <View style={{ alignItems: 'flex-end' }}><Text style={styles.item_shop_quan_title}>重新选择规格</Text></View>
                            ) : (
                                    <View style={styles.item_shop_otherItem}>
                                        <View style={styles.item_inputView}>
                                            <TouchableOpacity
                                                style={styles.item_inputItem}
                                                onPress={() => {
                                                    this._changeGoodNum(item, -1);
                                                }}
                                            >
                                                <Text style={styles.item_input_text1}>-</Text>
                                            </TouchableOpacity>

                                            <TouchableOpacity
                                                style={styles.item_inputItem2}
                                                onPress={() => {
                                                    this.changeState('textInputData', item);
                                                    this.textInput.focus();
                                                }}
                                            >
                                                <TextInputView
                                                    inputRef={(e) => { this.textInput = e }}
                                                    keyboardType='numeric'
                                                    onChangeText={(text) => {
                                                        this._changeGoodNum(textInputData, text, 'textInput');
                                                    }}
                                                />
                                                <Text style={styles.item_input}>{item.quantity}</Text>
                                            </TouchableOpacity>

                                            <TouchableOpacity
                                                style={styles.item_inputItem}
                                                onPress={() => {
                                                    this._changeGoodNum(item, 1);
                                                }}
                                            >
                                                <Text style={styles.item_input_text1}>+</Text>
                                            </TouchableOpacity>
                                        </View>
                                        {/* <TouchableOpacity
                                            style={styles.item_shop_quanView}
                                            onPress={() => {
                                                this.getCouponLists(item);
                                            }}
                                        >
                                            <Text style={styles.item_shop_quan_title}>领取优惠劵</Text>
                                        </TouchableOpacity> */}
                                    </View>
                                )
                        }
                    </View>
                </View>
            </View>
        );
    }
    changeDetailVisible = (one) => {
        const { youHuiQuan } = this.state
        youHuiQuan.find((item) => {
            if (item.couponId === one.couponId) {
                item.detailVisible = !one.detailVisible
                return
            }
        })
        this.setState({
            youHuiQuan
        })
    }
    changeYouHuiquanState = (one) => {
        const { youHuiQuan } = this.state
        youHuiQuan.forEach((item) => {
            if (item.couponId === one.couponId) {
                item.whetherDraw = 1
            }
        })
        this.setState({
            youHuiQuan
        })
    }
    handleBalance = () => {
        Keyboard.dismiss();
        let _data = [];
        let data = this.state.data;
        for (let i = 0; i < data.length; i++) {
            if (data[i].selected_status && data[i].status !== 0) {
                data[i].buyPrice=data[i].price
                _data.push(data[i]);
            }
        }
        console.log(_data)
        return _data;
    }
    handleClearIndex = () => {
        const { data } = this.state
        data.map(item => {
            item.selected_status = false;
        })
        this.setState({
            data,
            selectedAll: false,
        })
    }
    render() {
        const { navigation, store } = this.props;
        const { data, isManager, selectedAll, modalVisible, youHuiQuan } = this.state;
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={'商城购物车'}
                    leftView={
                        <View style={{position: 'absolute',top: CommonStyles.headerPadding,height:'100%',zIndex: 1}}>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    navigation.goBack()
                                }}
                            >
                                <Image
                                    source={require("../../images/mall/goback.png")}
                                />
                            </TouchableOpacity>
                        </View>
                    }
                    rightView={
                        data.length !== 0 ?
                        <TouchableOpacity
                            style={styles.headerRightView}
                            onPress={() => {
                                Keyboard.dismiss();
                                this.changeState('isManager', !isManager);
                                this.handleClearIndex();
                            }}
                        >
                            <Text style={styles.headerRight_text}>{isManager ? '完成' : '管理'}</Text>
                        </TouchableOpacity>
                        : <TouchableOpacity
                        style={styles.headerRightView}
                        onPress={() => {
                        }}
                    >
                    </TouchableOpacity>
                    }
                />

                <FlatListView
                    style={styles.flatListView}
                    store={
                        {
                            ...store.mallReducer,
                            page: 1,
                            hasMore: false
                        }
                    }
                    ListEmptyComponent={<ListEmptyCom type='shopCarEmpty' />}
                    data={data}
                    renderItem={this.renderItem}
                    ItemSeparatorComponent={() => <View style={{ height: 0 }}></View>}
                    refreshData={() => {
                        this.refresh();
                    }}
                />

                {
                    data.length === 0 ?
                        null :
                        isManager ?
                            <View style={styles.footerView}>
                                <TouchableOpacity
                                    activeOpacity={0.7}
                                    style={[styles.footerItem, styles.footerItem1_m]}
                                    onPress={() => {
                                        this._changeMallCartList();
                                    }}
                                >
                                    {
                                        selectedAll ?
                                            <Image style={styles.footerItem1_img} source={require('../../images/mall/checked.png')} /> :
                                            <Image style={styles.footerItem1_img} source={require('../../images/mall/unchecked.png')} />
                                    }
                                    <Text style={styles.footerItem1_text}>全选</Text>
                                </TouchableOpacity>
                                <TouchableOpacity
                                    activeOpacity={0.7}
                                    style={[styles.footerItem, styles.footerItem2_m]}
                                    onPress={() => {
                                        let _data = this.filterLists();
                                        this._moveToCollect(_data);
                                    }}
                                >
                                    <Text style={styles.headerRight_text}>移入收藏</Text>
                                </TouchableOpacity>
                                <TouchableOpacity
                                    activeOpacity={0.7}
                                    style={[styles.footerItem, styles.footerItem3_m]}
                                    onPress={() => {
                                        let _data = this.filterLists();
                                        this._deleteGoods(_data);
                                    }}
                                >
                                    <Text style={styles.headerRight_text}>删除</Text>
                                </TouchableOpacity>
                            </View> :
                            <View style={styles.footerView}>
                                <TouchableOpacity
                                    activeOpacity={0.7}
                                    style={[styles.footerItem, styles.footerItem1]}
                                    onPress={() => {
                                        this._changeMallCartList();
                                    }}
                                >
                                    {
                                        selectedAll ?
                                            <Image style={styles.footerItem1_img} source={require('../../images/mall/checked.png')} /> :
                                            <Image style={styles.footerItem1_img} source={require('../../images/mall/unchecked.png')} />
                                    }
                                    <Text style={styles.footerItem1_text}>全选</Text>
                                </TouchableOpacity>
                                <View style={[styles.footerItem, styles.footerItem2]}>
                                    <Text style={styles.footerItem2_text1}>合计：</Text>
                                    <Text style={styles.footerItem2_text2}>¥{math.divide(this._totalPrice() , 100)}</Text>
                                </View>
                                <TouchableOpacity
                                    activeOpacity={0.7}
                                    style={[styles.footerItem, styles.footerItem3]}
                                    onPress={() => {
                                        Keyboard.dismiss();
                                        let selectLen = this.filterLists();
                                        if (selectLen.length === 0) {
                                            Toast.show('请选择商品');
                                            return
                                        }
                                        navigation.navigate('SOMOrderConfirm', { goodsList: this.handleBalance() });
                                    }}
                                >
                                    <Text style={styles.headerRight_text}>结算</Text>
                                </TouchableOpacity>
                            </View>
                }

                <Modal
                    animationType={'fade'}
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => { this.changeState('modalVisible', false) }}
                    onShow={() => { }}
                >
                    <View style={styles.modalOutView}>
                        <TouchableOpacity
                            style={styles.modalInnerTopView}
                            activeOpacity={1}
                            onPress={() => {
                                this.changeState('modalVisible', false);
                            }}
                        >
                        </TouchableOpacity>
                        <View style={styles.modalInnerBottomView}>
                            <View style={styles.modal_titleView}>
                                <View style={styles.modal_titleItem}></View>
                                <Text style={styles.modal_title_text}>优惠券</Text>
                                <TouchableOpacity
                                    style={styles.modal_titleItem}
                                    onPress={() => {
                                        this.changeState('modalVisible', false);
                                    }}
                                >
                                    <Image source={require('../../images/mall/close1.png')} />
                                </TouchableOpacity>
                            </View>
                            <ScrollView alwaysBounceVertical={false} contentContainerStyle={{ alignItems: 'center' }} showsVerticalScrollIndicator={false}>
                                {
                                    youHuiQuan && youHuiQuan.map((item) => {
                                        return (
                                            <View style={styles.quanViews} key={item.couponId}>
                                                <View style={styles.quanView}>

                                                    {
                                                        item.couponType !== 'DISCOUNT' ? (
                                                            <ImageBackground source={leftYHQ} style={{ width: getwidth(105), height: 86 }} resizeMode='contain'>
                                                                <View style={styles.quanItem1}>
                                                                    <Text style={styles.quan_text1}>¥{math.divide(item.price , 100)}</Text>
                                                                    <Text style={[styles.quan_text2]}>满{math.divide(item.condition , 100) }元可用</Text>
                                                                </View>
                                                            </ImageBackground>
                                                        ) : (
                                                                <ImageBackground source={leftYHQ} style={{ width: getwidth(105), height: 86 }} resizeMode='contain'>
                                                                    <View style={styles.quanItem1}>
                                                                        <Text style={{ color: '#fff', fontSize: 12 }} numberOfLines={2}>{item.couponName}</Text>
                                                                    </View>
                                                                </ImageBackground>
                                                            )
                                                    }

                                                    {/* <View style={styles.quanItem_line1}></View> */}
                                                    <View style={styles.quanItem2}>
                                                        <Text style={styles.quan_text3} numberOfLines={2}>{item.couponName}</Text>
                                                        <Text style={{ color: '#555555', fontSize: 10, marginTop: 5 }}>{moment(item.validTime * 1000).format('YYYY-MM-DD')} - {moment(item.invalidTime * 1000).format('YYYY-MM-DD')}</Text>
                                                        <View style={[styles.quanItem2_bom]}>

                                                            <TouchableOpacity
                                                                style={styles.quan_detail}
                                                                onPress={() => {
                                                                    this.changeDetailVisible(item)
                                                                }}
                                                            >
                                                                {
                                                                    item.detailVisible ? (
                                                                        <View style={styles.quan_detail}>
                                                                            <Text style={{ color: '#4A90FA', fontSize: 12 }}>收起</Text>
                                                                            <Image source={xiangDown} style={{ marginLeft: 5 }} />
                                                                        </View>

                                                                    ) : (
                                                                            <View style={styles.quan_detail}>
                                                                                <Text style={{ color: '#4A90FA', fontSize: 12 }}>详情</Text>
                                                                                <Image source={xiangUp} style={{ marginLeft: 5 }} />
                                                                            </View>

                                                                        )
                                                                }

                                                            </TouchableOpacity>
                                                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                                {
                                                                    item.whetherDraw === 0 ? null : (
                                                                        <View style={{ marginRight: 6 }}>
                                                                            <Image source={didlq} style={{ marginRight: 0, width: getwidth(55), height: getwidth(55) }} />
                                                                        </View>
                                                                    )
                                                                }
                                                                {
                                                                    item.whetherDraw === 0 ? (
                                                                        <TouchableOpacity
                                                                            style={[styles.quan_detail, styles.quan_detail2]}
                                                                            onPress={() => {
                                                                                this.changeState('modalVisible', false);
                                                                                let param = {
                                                                                    couponId: item.couponId,
                                                                                    userId: this.props.store.user.user.id
                                                                                }
                                                                                requestApi.mallCouponUserDraw(param).then((res) => {
                                                                                    Toast.show('领取成功', 3000);
                                                                                    this.changeYouHuiquanState(item)
                                                                                }).catch((res) => {
                                                                                    Toast.show(res.message, 3000);
                                                                                })
                                                                            }}
                                                                        >
                                                                            <Text style={{ color: '#FFFFFF', fontSize: 10 }}>立即领取</Text>
                                                                        </TouchableOpacity>
                                                                    ) : (
                                                                            <View style={[styles.quan_detail, styles.quan_detailNo]}>
                                                                                <Text style={{ color: '#68A4FF', fontSize: 10 }}>已领取</Text>
                                                                            </View>
                                                                        )
                                                                }
                                                            </View>


                                                        </View>
                                                    </View>
                                                </View>
                                                {
                                                    item.detailVisible ?
                                                        <View style={{ backgroundColor: '#fff', paddingLeft: 15, paddingVertical: 8, width: width - 20 }}>
                                                            <Text style={{ color: '#777777', fontSize: 10 }}>{item.message}</Text>
                                                        </View> :
                                                        null
                                                }
                                            </View>
                                        )
                                    })
                                }
                            </ScrollView>
                        </View>
                    </View>
                </Modal>
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerRightView: {
        flexDirection: 'row',
        alignItems: 'center',
        // width: 50,
        position: 'absolute',
        // paddingRight: 25,
        height: '100%',
        top: CommonStyles.headerPadding,
        right: 25,
    },
    headerRight_text: {
        fontSize: 17,
        color: '#fff',
    },
    flatListView: {
        backgroundColor: '#EEEEEE',
    },
    itemView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width - 20,
        marginHorizontal: 10,
        backgroundColor: '#fff',
        // ...CommonStyles.shadowStyle,
    },
    itemLine: {
        borderTopWidth: 1,
        borderTopColor: '#F1F1F1',
    },
    itemView1: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    itemView2: {
        marginBottom: 10,
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
    item_left: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 44,
        height: 80,
    },
    item_right: {
        flexDirection: 'row',
        flex: 1,
        height: '100%',
        paddingTop: 15,
        paddingBottom: 8,
    },
    item_shop_imgView: {
        width: 80,
        height: 80,
        borderWidth: 1,
        borderColor: '#F1F1F1',
        borderRadius: 10,
        overflow: 'hidden',

    },
    item_shop_img: {
        width: '100%',
        height: '100%',
    },
    item_shop_other: {
        flex: 1,
        marginHorizontal: 10,
    },
    item_shop_title: {
        fontSize: 12,
        color: '#222',
    },
    item_shop_guige: {
        fontSize: 12,
        color: '#555',
        paddingTop: 10,
    },
    item_shop_price1: {
        fontSize: 12,
        color: '#555',
    },
    item_shop_price2: {
        fontSize: 12,
        color: '#EE6161',
    },
    item_shop_otherItem: {
        justifyContent: 'center',
        alignItems: 'flex-end',
    },
    item_inputView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 80,
        height: 20,
        marginTop: 5,
        borderWidth: 1,
        borderColor: '#E6E6E6',
        borderRadius: 3,
    },
    item_inputItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 22,
        height: 20,
    },
    item_input_text1: {
        fontSize: 20,
        marginTop: -4.5,
        color: '#ccc'
    },
    item_inputItem2: {
        flex: 1,
        height: '100%',
        borderLeftWidth: 1,
        borderRightWidth: 1,
        borderColor: '#E6E6E6',
    },
    item_input: {
        fontSize: 14,
        color: '#a9a9a9',
        textAlign: 'center',
    },
    item_shop_quanView: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'flex-end',
        width: 100,
        height: 24,
    },
    item_shop_quan_title: {
        fontSize: 12,
        color: '#4A90FA',
    },
    footerView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: 50 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
        backgroundColor: '#fff',
    },
    footerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: '100%',
        backgroundColor: '#fff',
    },
    footerItem1: {
        justifyContent: 'flex-start',
        flex: 1,
    },
    footerItem1_m: {
        justifyContent: 'flex-start',
        flex: 1.5,
    },
    footerItem1_img: {
        marginLeft: 20,
        height: 18,
        width: 18
    },
    footerItem1_text: {
        fontSize: 14,
        color: '#777',
        marginLeft: 14,
    },
    footerItem2: {
        justifyContent: 'flex-end',
        flex: 2,
    },
    footerItem2_m: {
        flex: 1,
        backgroundColor: '#4A90FA',
    },
    footerItem2_text1: {
        fontSize: 14,
        color: '#222',
    },
    footerItem2_text2: {
        fontSize: 14,
        color: '#EE6161',
        paddingRight: 10,
    },
    footerItem3: {
        backgroundColor: '#4A90FA',
    },
    footerItem3_m: {
        flex: 1,
        backgroundColor: '#EE6161',
    },
    modalOutView: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: CommonStyles.paddingBottom
    },
    modalInnerTopView: {
        width: width,
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, .5)',
    },
    modalInnerBottomView: {
        width: width,
        flex: 1,
        backgroundColor: '#fff',
    },
    modal_titleView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
    },
    modal_titleItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: 75,
        height: '100%',
    },
    modal_title_text: {
        flex: 1,
        fontSize: 17,
        color: '#000',
        textAlign: 'center',
    },
    quanViews: {
        width: width - 20,
        marginBottom: 15,
        borderWidth: 1,
        borderColor: '#FFEEF5FF',
        borderRadius: 4,
        backgroundColor: '#EEF5FF',
        paddingRight: 10,
        shadowColor: '#D7D7D7',
        shadowOpacity: 0.26,
        shadowRadius: 6,
        shadowOffset: { width: 4, height: 4 }
    },
    quanView: {
        flexDirection: 'row',
        width: '100%',
        height: 86,
    },
    quanView2: {
        width: '100%',
    },
    quanItem_line1: {
        width: 0,
        height: '100%',
        marginHorizontal: 10,
        borderWidth: 0.5,
        borderColor: '#ccc',
        borderStyle: 'dashed',
    },
    quanItem_line2: {
        width: '100%',
        height: 6,
        marginVertical: 10,
        borderTopWidth: 0.5,
        borderBottomWidth: 0,
        borderTopColor: '#ccc',
        borderStyle: 'dashed',
        borderRadius: 20
    },
    quanItem1: {
        justifyContent: 'center',
        alignItems: 'flex-start',
        flex: 3,
        height: '100%',
        marginLeft: 10,
    },
    quanItem2: {
        justifyContent: 'center',
        alignItems: 'flex-start',
        flex: 7,
        height: '100%',
        marginLeft: 8
    },
    quan_text1: {
        fontSize: 24,
        color: '#FFFFFF',
    },
    quan_text2: {
        fontSize: 10,
        color: '#FFFFFF',
    },
    quan_text2_mar: {
        marginTop: 5,
    },
    quan_text3: {
        fontSize: 12,
        color: '#222',
    },
    quanItem2_bom: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: '100%',
        height: 22,
    },
    quan_detail: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    quan_detail2: {
        height: '100%',
        paddingHorizontal: 6,
        borderRadius: 76,
        backgroundColor: '#4A90FA',
    },
    quan_detailNo: {
        height: '100%',
        paddingHorizontal: 6,
        borderRadius: 76,
        backgroundColor: '#DCEAFF'
    },
    quan_text4: {
        fontSize: 12,
        color: '#fff',
    },
    quan2_text1: {
        fontSize: 12,
        color: '#777',
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
        // position: 'absolute'
    },
    left: {
        width: 50
    }
});

export default connect(
    (state) => ({ store: state }),
    (dispatch) => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMShoppingCartScreen);
