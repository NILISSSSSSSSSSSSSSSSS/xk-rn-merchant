/**
 * 品牌详情
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
import * as requestApi from "../../config/requestApi";
import BlurredPrice from '../../components/BlurredPrice';
import  math from "../../config/math.js";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import Swiper from 'react-native-swiper';
import FlatListView from '../../components/FlatListView'
const shopImg = [1, 2, 3, 5, 6]
const { width, height } = Dimensions.get("window");
import { showSaleNumText, getPreviewImage, getSalePriceText, recodeGoGoodsDetailRoute } from '../../config/utils';
import CommoditiesText from '../../components/CommoditiesText'

class SOMShopDetailScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
            page: 1,
            limit: 10,
            refreshing: false,
            loading: false,
            hasMore: false,
            total: 0,
            shopDetail: {
                goods: [],
                name: '',
                introduction: '',
            },
            shopBanner: []
        }
    }

    componentDidMount() {
        this.getData()
    }
    getData = () => {
        Loading.show();
        const { navigation } = this.props;
        let code = navigation.getParam('brandCode','');
        Promise.all([this.getShopDetail(code),this.getShopBanner(code)]).then(res => {
            console.log('all',res)
            this.setState({
                shopDetail: res[0],
                shopBanner: res[1].banner,
                refreshing: false,
            })
        }).catch(err => {
            console.log(err)
        })
    }
    refresh = () => {
        this.getShopDetail().then(res => {
            this.setState({
                shopDetail: res,
            })
        }).catch(err => {
            console.log(err)
        })
    }
    componentWillUnmount() {

    }
    getShopDetail = (code) => {
        return new Promise((resolve,reject) => {
            if (code === '') {
                reject('code')
            }
            let params = {
                code,
            }
            requestApi.brandShopDetail(params).then(res => {
                console.log('xxx',res)
                resolve(res)
            }).catch(err => {
                reject(err)
                console.log(err)
            })
        })
    }
    getShopBanner = (code) => {
        return new Promise((resolve,reject) => {
            if (code === '') {
                reject('code')
            }
            let params = {
                code,
            }
            requestApi.brandShopBanner(params).then(res => {
                console.log('brandShopBanner',res)
                resolve(res)
            }).catch(err => {
                reject(err)
                console.log(err)
            })
        })
    }
    handleChangeState = (key, value) => {
        this.setState({
            [key]: value
        })
    }
    renderItem = ({ item, index }) => {
        const { navigation } = this.props
        let borderRadius = index === this.state.shopDetail.goods.length - 1 ? styles.bottomRadius:null;
        return (
            <TouchableOpacity
            onPress={() => {
                console.log('goodsId',item.goodsId)
                recodeGoGoodsDetailRoute('SOMShopDetail');
                navigation.push("SOMGoodsDetail", {
                    goodsId: item.goodsId
                });
            }}
            activeOpacity={0.6}
            key={index}
            style={[styles.flex_start_noCenter, styles.shopGoodsItemWrap,borderRadius]}
            >
                <View style={styles.imgWrap}>
                    <Image style={styles.goodsImg} source={{ uri: getPreviewImage(item.goodsPic, '50p') }} />
                </View>
                <View style={[styles.goodsInfoLeft, styles.flex_1]}>
                    <Text style={styles.goodsTitle} numberOfLines={2}>{item.goodsName}</Text>
                    {/* <Text style={[styles.labelText, { marginTop: 10,lineHeight:18 }]} numberOfLines={2}>产品规格：{item.goodsAttr}</Text> */}
                    {
                        item.goodsDivide === 2 // 如果是大宗商品
                        // true
                        ? <CommoditiesText price={item.price} buyPrice={item.buyPrice} subscription={item.subscription}/>
                        : <React.Fragment>
                            <View style={[CommonStyles.flex_start, { marginTop: 6 }]}>
                                <Text style={[{ fontSize: 12, color: '#222' }]}>惊喜价：
                                    <Text style={[{ fontSize: 12 }, styles.color_red]}>￥</Text>
                                    <BlurredPrice>
                                        <Text style={{ color: '#EE6161' }}>{getSalePriceText(math.divide(item.buyPrice , 100))}</Text>
                                    </BlurredPrice>
                                </Text>
                                
                            </View>
                            <View>
                                {
                                    item.price 
                                    ? <Text style={{fontSize: 12,color: '#222'}}>原价：
                                        <Text style={styles.originalPrice}>¥{ getSalePriceText(math.divide(item.price || 0, 100))}</Text>
                                    </Text>
                                    : null
                                }
                            </View>
                        </React.Fragment>
                    }
                    <Text style={[styles.labelText,{marginTop: 5}]}>总销量：{showSaleNumText(item.saleQ)} </Text>
                </View>
            </TouchableOpacity>
        )
    }
    render() {
        const { navigation, store } = this.props;
        const { shopDetail,shopBanner } = this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={"品牌详情"}
                />
                {
                    shopDetail.goods.length !== 0 &&
                    <FlatListView
                        store={this.state}
                        data={shopDetail.goods}
                        style={{backgroundColor: CommonStyles.globalBgColor}}
                        ListHeaderComponent={() => {
                            return (
                                <React.Fragment>
                                    <View style={styles.swiperWrap}>
                                        <Swiper
                                            // style={styles.wrapper}
                                            renderPagination={(index, total, context) => {
                                                return (
                                                    <View style={styles.paginationStyle}>
                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                            <Text style={styles.paginationText}>{index + 1}</Text>/{total}
                                                        </Text>
                                                    </View>
                                                )
                                            }}
                                            loop={true}
                                        >
                                            {
                                                shopBanner.length !== 0 && shopBanner.map((item, index) => {
                                                    return (
                                                        <View style={styles.slide} key={index}>
                                                            <Image style={styles.shopInfoImg} source={{ uri: item }} />
                                                        </View>
                                                    );
                                                })
                                            }
                                        </Swiper>
                                    </View>
                                    <View style={styles.shopInfoWrap}>
                                        <Text style={styles.shopTitle}>{shopDetail.name}</Text>
                                        <Text style={styles.shopNotice}>
                                        {
                                            shopDetail.introduction
                                        }
                                        </Text>
                                    </View>
                                    <View style={styles.shopGoodsWrap}>
                                        <Text style={styles.shopGoodsTitle}>全部商品</Text>
                                    </View>
                                </React.Fragment>
                            )
                        }}
                        ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                        renderItem={this.renderItem}
                        refreshData={() => {
                            this.handleChangeState('refreshing', true);
                            this.getData()
                        }}
                        ListFooterComponent={() => {
                            return (
                                <View style={[styles.footerView, this.props.footerStyle]}>
                                    <Text style={styles.footerText}>已经到底啦</Text>
                                </View>
                            )
                        }}
                        loadMoreData={() => {
                            // this.refresh(this.state.page + 1);
                        }}
                    />
                }

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
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

    swiperWrap: {
        height: 180,
        margin: 10,
        marginBottom: 0,
        overflow: 'hidden',
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    shopInfoWrap: {
        margin: 10,
        marginTop: 0,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.50)',
        borderTopWidth: 0,
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8,
        paddingHorizontal: 15,
        backgroundColor: '#fff'
    },
    shopInfoImg: {
        height: 180,
    },
    wrapper: {
        position: 'relative',
        margin: 10,
        height: 200,
    },
    slide: {
        justifyContent: 'center',
        backgroundColor: 'transparent',
    },
    text: {
        color: '#fff',
        fontSize: 30,
        fontWeight: 'bold'
    },
    image: {
        height: 180
    },
    paginationStyle: {
        position: 'absolute',
        bottom: 10,
        right: 10,
        backgroundColor: 'rgba(0,0,0,0.50)',
        paddingHorizontal: 8,
        paddingVertical: 1,
        borderRadius: 8
    },
    paginationText: {
        color: 'white',
        fontSize: 12
    },
    shopTitle: {
        fontSize: 17,
        color: '#222',
        paddingVertical: 10
    },
    shopNotice: {
        color: '#999',
        fontSize: 12,
        lineHeight: 16,
        paddingBottom: 20
    },
    shopGoodsWrap: {
        borderWidth: 1,
        borderColor: '#f1f1f1',
        margin: 10,
        marginBottom: 0,
        marginTop: 0,
        borderRadius: 8,
        borderBottomRightRadius: 0,
        borderBottomLeftRadius: 0,
        backgroundColor: '#fff'
    },
    shopGoodsTitle: {
        fontSize: 14,
        color: '#222',
        padding: 15,
    },
    flatListLine: {
        height: 0,
        backgroundColor: '#F1F1F1',
    },
    shopGoodsItemWrap: {
        padding: 15,
        backgroundColor: '#fff',
        marginHorizontal: 10,
        borderWidth: 1,
        borderColor: '#f1f1f1',
        borderTopWidth: 0,
        // marginBottom: 10
    },
    goodsImg: {
        height: 100,
        width: 100,
        borderRadius: 8
    },
    goodsInfoLeft: {
        paddingLeft: 12
    },
    goodsTitle: {
        lineHeight: 17,
        color: '#222',
        fontSize: 14
    },
    labelText: {
        fontSize: 12,
        color: '#777',
        marginTop: 1
    },
    bottomRadius: {
        borderBottomLeftRadius:8,
        borderBottomRightRadius:8
    },
    footerView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: 40,
        backgroundColor: CommonStyles.globalBgColor,
    },
    footerText: {
        fontSize: 14,
        color: '#666',
    },
    imgWrap: {
        borderWidth: 1,
        borderColor: '#f1f1f1',
        borderRadius: 8
    },
    originalPrice:{
        fontSize:12,
        color:'#999999',
        textDecorationLine:'line-through',
        marginLeft:5
    },
    color_red: {
        color: '#EE6161'
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMShopDetailScreen);
