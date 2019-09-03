/**
 * 自营商城首页
 */
import React, { Component, PureComponent } from "react";
import {
  StyleSheet,
  Dimensions,
  DeviceInfo,
  View,
  Text,
  Button,
  TouchableOpacity,
  Image,
  BackHandler
} from "react-native";
import { connect } from 'rn-dva'

import CarouselSwiper from "../../components/CarouselSwiper";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as nativeApi from "../../config/nativeApi";
import * as requestApi from "../../config/requestApi";
import ImageView from "../../components/ImageView";
import BannerImage from "../../components/BannerImage";
import FlatListView from "../../components/FlatListView";
import MallHeaderTitle from '../../components/MallHeaderTitle';
import BlurredPrice from '../../components/BlurredPrice'
import { getPreviewImage, getSalePriceText,showSaleNumText, recodeGoGoodsDetailRoute } from '../../config/utils';
import  math from "../../config/math.js";
import CommoditiesText from '../../components/CommoditiesText'
const { width, height } = Dimensions.get("window");

class SOMScreen extends Component {
  _didFocusSubscription;
  _willBlurSubscription;
  constructor(props) {
    super(props);
    this._didFocusSubscription = props.navigation.addListener('didFocus', (payload) => {
      BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
    });
    this.state = {
      localCode: global.regionCode,
      recommendListName: 'longLists'
    };
  }
  scrollHeight = 0;

  // 获取banner，获取分类列表
  fetchSomPageData = () => {
    this.props.fetchSomPageData()
  }

  // 获取推荐商品列表
  getGoodsListData(isFirst = true, isLoadingMore = false, loading = true, refreshing = false,address = this.state.localCode) {
    const { recommendListName } = this.state
    let paramsPrivate = { condition: { districtCode: address } }
    this.props.fetchList({
      witchList: recommendListName,
      isFirst,
      isLoadingMore,
      paramsPrivate,
      api: requestApi.requestMallGoodsRecommendSGoodsQPage,
      callback: () => {},
      loading,
      refreshing,
      limit:10,
    })
  }

  initData = () => {
    this.fetchSomPageData()
    this.getGoodsListData(true, false);
  }

  componentDidMount() {
    this.initData();
    this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
      BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
    );
  }

  changeState(key, value) {
    this.setState({
      [key]: value
    });
  }

  componentWillUnmount() {
    this._didFocusSubscription && this._didFocusSubscription.remove();
    this._willBlurSubscription && this._willBlurSubscription.remove();
    BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
  }

  onBackButtonPressAndroid = () => {
    this.props.navigation.navigate('Home')
    return true
  };

  renderCarousel = () => {
    const { somBannerList, navigation } = this.props
    return (
      <React.Fragment>
        {
          somBannerList.length !== 0 &&
          <CarouselSwiper
            key={somBannerList.length}
            style={styles.bannerView}
            loop
            autoplay
            index={0}
            autoplayTimeout={5000}
            showsPageIndicator
            pageIndicatorStyle={styles.banner_dot}
            activePageIndicatorStyle={styles.banner_activeDot}
            
          >
            {
              somBannerList.length !== 0 && somBannerList.map((item, index) => {
                let data = item.templateContent || [];
                return (
                  <BannerImage
                    key={index}
                    navigation={navigation}
                    style={styles.bannerView}
                    data={data}
                  />
                );
              })
            }
          </CarouselSwiper> || <View style={styles.bannerView}></View>
        }
      </React.Fragment>
    )
  }

  renderCategoryList = () => {
    let categoryListsMaxLen = 9
    const { categoryLists, navigation } = this.props
    return (
      <View style={styles.categoryView}>
        {
          categoryLists.length !== 0
            ? categoryLists.map((item, index) => {
              if (index >= categoryListsMaxLen) return;
              return (
                <TouchableOpacity
                  key={index}
                  style={styles.categoryItem}
                  onPress={() => { navigation.navigate("SOMLists", { categoryLists, item: item, titleIndex: index }) }}
                >
                  <ImageView
                    style={styles.category_img}
                    resizeMode="cover"
                    source={{ uri: item.icon }}
                    sourceWidth={40}
                    sourceHeight={40}
                  />
                  <Text numberOfLines={1} style={styles.category_text}>{item.name}</Text>
                </TouchableOpacity>
              );
            })
            : Array.apply(null, Array(categoryListsMaxLen)).map((item, index) => index).map((item, index) => {
                return (
                  <TouchableOpacity
                    key={index}
                    style={styles.categoryItem}
                  >
                    <ImageView
                      style={styles.category_img}
                      resizeMode="cover"
                      source={{ uri: null }}
                      sourceWidth={40}
                      sourceHeight={40}
                    />
                    <Text numberOfLines={1} style={styles.category_text}></Text>
                  </TouchableOpacity>
                );
            })
        }
        {
          categoryLists.length !== 0 
          ? <TouchableOpacity
              style={styles.categoryItem}
              onPress={() => {
                navigation.navigate("SOMMore", { categoryLists, categoryListsMaxLen });
              }}
            >
              <ImageView
                style={styles.category_img}
                resizeMode="cover"
                source={require("../../images/mall/category_more_icon.png")}
                sourceWidth={40}
                sourceHeight={40}
              />
              <Text numberOfLines={1} style={styles.category_text}>更多</Text>
            </TouchableOpacity>
          : null
        }
          
      </View>
    )
  }

  renderItem = ({ item, index }) => {
    const { navigation, store, longLists } = this.props;
    const { recommendListName } = this.state
    let itemBoxRowEnd = index === (longLists[recommendListName] && longLists[recommendListName].lists.length - 1) ? styles.itemBoxRowEnd : null;
    return (
      <View style={[styles.itemBoxRow, itemBoxRowEnd]}>
        <TouchableOpacity
          key={index}
          style={styles.itemViewRow}
          onPress={() => {
            this.setState({ selectIndex: index })
            recodeGoGoodsDetailRoute();
            navigation.navigate("SOMGoodsDetail", {
              goodsId: item.id
            });
          }}
        >
          <View style={[styles.itemImgView, styles.itemImgView1]}>
            <Image
              style={styles.itemImgView_img}
              source={{ uri: getPreviewImage(item.pic, '50p') }}
            />
          </View>
          <View style={[styles.itemRightView1, CommonStyles.flex_1]}>
            <Text style={styles.itemRight_title_text} numberOfLines={2}>{item.name}</Text>
            <View style={styles.itemRight_price}>
              {
                // 如果是大宗商品
                item.goodsDivide === 2
                ? <CommoditiesText subscription={item.subscription} price={item.price} buyPrice={item.buyPrice} />
                : <React.Fragment>
                    <View style={ [{flexDirection:'row',alignItems:'center', marginTop: 5 }]}>
                      <Text style={[{ fontSize: 12, color: '#222' } ]} >惊喜价：</Text>
                      <BlurredPrice>
                        <Text style={[styles.itemTitleText, { fontSize: 12 }]}>¥</Text>
                        <Text style={styles.itemTitleText}>
                          { getSalePriceText(math.divide(item.buyPrice || 0, 100)) +' '}
                        </Text>
                      </BlurredPrice>
                    </View>
                    <View>
                      {
                        item.price ? <Text style={[{ fontSize: 12, color: '#222' } ]} >原价：<Text style={styles.originalPrice}>¥{ getSalePriceText(math.divide(item.price || 0, 100))}</Text></Text>:null
                      }
                    </View>
                </React.Fragment>

              }
              
              <Text style={[ { fontSize: 10, color: '#999', marginTop: 3 }]}>总销量：{showSaleNumText(item.saleQ)}</Text>
            </View>
          </View>
        </TouchableOpacity>
      </View>
    );
  };

  renderTopHeader = () => {
    const { navigation } = this.props
    return (
      <View style={[styles.headerItem, styles.headerCenterView]}>
        <TouchableOpacity
          activeOpacity={0.8}
          style={[styles.headerCenterItem1, CommonStyles.flex_1]}
          onPress={() => { navigation.navigate("SOMSearch") }}
        >
          <View style={styles.headerCenterItem1_search}>
            <Image source={require("../../images/mall/search.png")} />
          </View>
          <View style={styles.headerCenterItem1_textView}>
            <Text style={styles.headerCenterItem1_text} numberOfLines={1}>搜索你想要的商品</Text>
          </View>
        </TouchableOpacity>
        <View style={{ marginLeft: 15 }}>
          <MallHeaderTitle
            data={[
              {
                icon: require('../../images/mall/collection.png'),
                onPress: () => { navigation.navigate("SOMCollection"); }
              },
              {
                icon: require('../../images/mall/messages.png'),
                onPress: () => { nativeApi.createXKCustomerSerChat() }
              },
              {
                icon: require('../../images/mall/shoppingcart.png'),
                onPress: () => { navigation.navigate("SOMShoppingCart");}
              },
              {
                icon: require('../../images/mall/fg_ling.png'),
                onPress: () => {}
              },
              {
                icon: require('../../images/mall/orders.png'),
                onPress: () => { navigation.navigate("SOMOrder"); }
              }
            ]}
          />
        </View>
    </View>
    )
  }

  render() {
    const { navigation } = this.props;
    console.log('this.props', this.props)
    const { longLists } = this.props
    const { recommendListName } = this.state
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
                    navigation.navigate("Home", { isShowUpdate: false });
                  }}
                >
                  <Image source={require("../../images/mall/goback.png")} />
                </TouchableOpacity>
              </View>
            }
            centerView={ this.renderTopHeader() }
            rightView={<View style={{ width: 0 }} />}
          />

          <FlatListView
            flatRef={e => { e && (this.flatListRef = e) }}
            style={styles.flatList}
            store={{
              ...longLists[recommendListName],
              page: longLists[recommendListName] && longLists[recommendListName].listsPage || 1,
            }}
            data={longLists[recommendListName] && longLists[recommendListName].lists || []}
            onScroll={e => { let y = e.nativeEvent.contentOffset.y; this.scrollHeight = y; }}
            ListHeaderComponent={() => {
              return (
                <View>
                  {/* banner */}
                  {this.renderCarousel()}
                  {/* 分类列表 */}
                  {this.renderCategoryList()}
                  {/* 推荐商品列表标题 */}
                  <View style={[styles.itemHeader, longLists[recommendListName] && longLists[recommendListName].lists.length === 0 ? styles.noDataBorderRadius : null]}>
                    <View style={[styles.itemHeaderTitle, CommonStyles.flex_between, CommonStyles.flex_1]}>
                      <Text style={[styles.itemHeader_text]}>商品推荐</Text>
                      <TouchableOpacity style={CommonStyles.flex_start} onPress={() => { navigation.navigate('SOMLists', { titleIndex: -1 }) }} >
                        <Text>更多</Text>
                        <Image source={require('../../images/mall/goto_gray.png')} />
                      </TouchableOpacity>
                    </View>
                  </View>
                </View>
              );
            }}
            ItemSeparatorComponent={() => (<View style={styles.flatListLine} />)}
            renderItem={this.renderItem}
            numColumns={1}
            refreshData={() => { this.fetchSomPageData(); this.getGoodsListData(false,false,false, true) }}
            loadMoreData={() => { this.getGoodsListData(false, true,false,false) }}
          />
      </View>
    );
  }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    headerCenterView: {
        flex: 1
    },
    headerCenterItem1: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center",
        flex: 1,
        height: 30,
        borderRadius: 15,
        backgroundColor: "rgba(255,255,255,0.5)",
    },
    headerCenterItem1_search: {
        width: 32,
        paddingHorizontal: 8,
        marginTop: 1
    },
    headerCenterItem1_textView: {
        justifyContent: "center",
        alignItems: "flex-start",
        flex: 1,
        // height: 20,
        marginRight: 8
    },
    headerCenterItem1_text: {
        fontSize: 14,
        color: "rgba(255,255,255,0.8)"
    },
    flatList: {
        flex: 1,
        backgroundColor: CommonStyles.globalBgColor
    },
    flatListLine: {
        height: 0,
        backgroundColor: "#EEEEEE"
    },
    bannerView: {
        height: 136,
        backgroundColor: "#EEEEEE"
    },
    banner_dot: {
        width: 4,
        height: 4,
        borderRadius: 4,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: -20,
        backgroundColor: "#fff"
    },
    banner_activeDot: {
        width: 12,
        height: 4,
        borderRadius: 10,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: -20,
        backgroundColor: "#fff"
    },
    categoryView: {
        // ...CommonStyles.shadowStyle,
        flexDirection: "row",
        flexWrap: "wrap",
        width: width - 20,
        // height: 164,
        marginVertical: 10,
        marginHorizontal: 10,
        borderRadius: 8,
        backgroundColor: "#fff",
        overflow: "hidden"
    },
    categoryItem: {
        justifyContent: "center",
        alignItems: "center",
        width: "20%",
        height: 82,
        paddingHorizontal: 5
    },
    category_img: {
        width: 40,
        height: 40,
        borderRadius: 20
    },
    category_text: {
        width: "100%",
        fontSize: 12,
        color: "#222",
        textAlign: "center",
        marginTop: 5
    },
    itemHeader: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        width: width - 20,
        marginHorizontal: 10,
        padding: 15,
        // paddingBottom: 3,
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
        backgroundColor: "#fff"
    },
    noDataBorderRadius: {
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8
    },
    itemHeader_text: {
        fontSize: 17,
        marginHorizontal: 6,
        color: "#222",
    },
    itemBoxRow: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: width - 20,
        height: 130,
        marginHorizontal: 10,
        padding: 15,
        paddingRight: 10,
        borderBottomWidth: 0.7,
        borderBottomColor: "#F1F1F1",
        backgroundColor: "#fff"
    },
    itemBoxRowEnd: {
        borderBottomWidth: 0,
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
    itemViewRow: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: "100%",
        height: "100%"
    },
    itemImgView: {
        backgroundColor: "#F6F6F6",
        overflow: "hidden"
    },
    itemImgView1: {
        width: 100,
        height: "100%",
        borderWidth: 1,
        borderColor: "#F1F1F1",
        borderRadius: 8
    },
    itemImgView_img: {
        width: "100%",
        height: "100%"
    },
    itemRightView1: {
        height: "100%",
        paddingLeft: 12
    },
    itemRight_title_text: {
        fontSize: 14,
        color: "#222"
    },
    itemRight_price: {
        alignItems: "flex-start",
        width: "100%",
        marginTop: 5
    },
    itemRight_price_margin: {
        marginTop: 5
    },
    itemTitleText: {
        color: "#EE6161",
        fontSize:15
    },
    originalPrice:{
      fontSize:12,
      color:'#999999',
      textDecorationLine:'line-through',
    },
    itemHeaderTitle: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center"
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
    state => ({
        longLists: state.shop.longLists || {},
        somBannerList: state.mall.somBannerList, // 轮播banner数据
        categoryLists: state.mall.goodsCategoryLists_pre, // 分类列表数据
        recommendGoodsList: state.mall.recommendGoodsList, // 推荐列表商品数据
    }),
    dispatch => ({
        fetchList: (params = {}) => dispatch({ type: "shop/getList", payload: params}),
        fetchSomPageData: ()=> dispatch({ type: "mall/fetchSomPageData" }),
    })
)(SOMScreen);
