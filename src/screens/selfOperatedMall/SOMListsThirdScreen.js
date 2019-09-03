// 自营三级列表查询
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
import * as nativeApi from '../../config/nativeApi';
import {showSaleNumText } from '../../config/utils';
import FlatListView from '../../components/FlatListView';
import BlurredPrice from '../../components/BlurredPrice';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from '../../config/requestApi';
import { getPreviewImage, getSalePriceText, recodeGoGoodsDetailRoute } from '../../config/utils';
import  math from "../../config/math.js";
const { width, height } = Dimensions.get("window");
import CommoditiesText from '../../components/CommoditiesText'

class SOMListsThirdScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    flatListRef = null
    scrollHeight = 0
    constructor(props) {
        super(props);
        this.state = {
            item: props.navigation.getParam('item', {}),
            page: 1,
            limit: 10,
            refreshing: false,
            loading: false,
            hasMore: false,
            total: 0,
            goodLists: []
        }
    }

    componentDidMount() {
        Loading.show()
        this.refresh()
    }

    componentWillUnmount() {
        Loading.hide()
    }
    refresh = (page = 1, address = this.state.localCode) => {
        this.changeState("loading", true);
        let item = this.props.navigation.getParam('item', {});
        console.log('thirditem', item)
        const { limit, total, goodLists } = this.state;
        let param = {
            page,
            limit,
            condition: {
                category: item.code,
                keyword: ''

            },
        }
        console.log('11', param)
        requestApi.requestSearchGoodsList(param).then(data => {
            console.log('datadatadatadtadatadatadata', data)
            let _data;
            if (page === 1) {
                _data = data ? data.data : [];
            } else {
                _data = data ? [...goodLists, ...data.data] : goodLists;
            }
            let _total = page === 1 ? data.total : total;
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
    };

    changeState = (key = '', value = '', callback = () => { }) => {
        this.setState({
            [key]: value
        }, () => {
            callback()
        })
    }
    renderItem = ({ item, index }) => {
        let topBorderRadius = index === 0 ? styles.topBorderRadius : {};
        let topBorder = index === 0 ? styles.borderTop : {};
        let bottomBorderRadius = index === this.state.goodLists.length - 1 ? styles.bottomBorderRadius : {};
        let bottomBorder = index === this.state.goodLists.length - 1 ? styles.borderBottom : {};
        return (
            <TouchableOpacity
            onPress={() =>{
                recodeGoGoodsDetailRoute('SOMListsThird');
                this.props.navigation.navigate('SOMGoodsDetail', { goodsId: item.id });
            }}
            key={index}
            style={[styles.goodsItemWrap, CommonStyles.flex_start_noCenter, topBorderRadius, bottomBorderRadius, topBorder, bottomBorder, styles.borderHor,{backgroundColor: '#fff'}]}>
                <View style={[{ marginRight: 15, width: 72, height: 72}, CommonStyles.flex_center, styles.border, styles.borderRadius]}>
                    <Image style={{ width: 70, height: 70, borderRadius: 10 }} source={{ uri: getPreviewImage(item.pic, '50p') }} />
                </View>
                <View style={[CommonStyles.flex_1]}>
                    <Text style={styles.goodsTitle} numberOfLines={2}>{item.name}</Text>
                    {
                        item.goodsDivide === 2 // 如果是大宗商品
                        // true
                        ? <CommoditiesText price={item.price} buyPrice={item.buyPrice} subscription={item.subscription}/>
                        : <React.Fragment>
                            <View style={[CommonStyles.flex_start, { marginTop: 10 }]}>
                                <Text style={[{ fontSize: 12,color: '#222' }]}>惊喜价：</Text>
                                <Text style={[{ fontSize: 12 }, styles.color_red]}>￥</Text>
                                <BlurredPrice>
                                    <Text style={[styles.goodsPrice, styles.color_red]}>{getSalePriceText(math.divide(item.buyPrice || 0, 100))}</Text>
                                </BlurredPrice>
                            </View>
                            <View>
                                {
                                    item.price ? <Text style={{ fontSize: 12,color: '#222' }}>原价：<Text style={styles.originalPrice}>¥{ getSalePriceText(math.divide(item.price || 0, 100))}</Text></Text>:null
                                }
                            </View>
                        </React.Fragment>
                    }
                    <Text style={styles.goodsSold}>总销量：{ showSaleNumText(item.saleQ)}</Text>                
                </View>
            </TouchableOpacity>
        )
    }
    render() {
        const { navigation, store } = this.props;
        const { item, goodLists } = this.state
        console.log('itemitem', item)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    title={item.name}
                />
                <FlatListView
                    flatRef={e => {
                        e && (this.flatListRef = e);
                    }}
                    style={styles.flatList}
                    store={this.state}
                    data={goodLists}
                    ItemSeparatorComponent={() => (
                        <View style={styles.flatListLine} />
                    )}
                    renderItem={this.renderItem}
                    refreshData={() => {
                        this.changeState("refreshing", true);
                        this.refresh(1);
                    }}
                    loadMoreData={() => {
                        this.refresh(this.state.page + 1);
                    }}
                    // ListFooterComponent={() =>{
                    //     return null
                    // }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    flatList: {
        // flex: 1,
        // borderWidth: 0.5,
        // borderColor: 'rgba(215,215,215,0.5)',
        // backgroundColor: '#fff',
        // borderRadius: 8,
        margin: 10,
        marginTop: 0,
        backgroundColor: CommonStyles.globalBgColor,
    },
    flatListLine: {
        height: 1,
        backgroundColor: "#F1F1F1"
    },
    goodsItemWrap: {
        padding: 10,
        overflow: 'hidden',
    },
    topBorderRadius: {
        borderTopRightRadius: 8,
        borderTopLeftRadius: 8,
    },
    bottomBorderRadius: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
    borderTop: {
        borderTopWidth: 0.5,
        borderTopColor: 'rgba(215,215,215,0.5)',
    },
    borderBottom: {
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 0.5,
    },
    borderHor: {
        borderLeftColor: 'rgba(215,215,215,0.5)',
        borderLeftWidth: 0.5,
        borderRightWidth: 0.5,
        borderRightColor: 'rgba(215,215,215,0.5)',
    },
    border: {
        borderWidth: 0.6,
        borderColor: 'rgba(215,215,215,0.5)',
    },
    borderRadius: {
        borderRadius: 10
    },
    goodsPrice: {
        fontSize: 17,
    },
    goodsTitle: {
        color: '#222',
        fontSize: 14
    },
    goodsSold: {
        fontSize: 10,
        color: '#999',
        marginTop: 5
    },
    color_red: {
        color: '#EE6161'
    },
    originalPrice:{
      fontSize:12,
      color:'#999999',
      textDecorationLine:'line-through',
      marginLeft:5
    },

});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMListsThirdScreen);
