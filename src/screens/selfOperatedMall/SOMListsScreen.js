/**
 * 自营商城二级列表页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  DeviceInfo,
  View,
  ScrollView,
  Text,
  TouchableOpacity,
  Image,
  Modal,
  Button,
  FlatList,
} from 'react-native';
import { connect } from 'rn-dva'
import * as nativeApi from "../../config/nativeApi";
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import MallGoodsFilter from '../../components/MallGoodsFilter';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import ImageView from '../../components/ImageView';
import MallGoodsListItem from '../../components/MallGoodsListItem';
import MallHeaderTitle from '../../components/MallHeaderTitle';
import ScrollableTabView from "react-native-scrollable-tab-view";
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar'

const { width, height } = Dimensions.get('window');

class SOMListsScreen extends Component {
  constructor(props) {
    super(props)
    this.state = {
      filterParams: {
        type: 'saleQ', // 排序字段，如：popularity 人气 saleQ 销量 price 价格
        isDesc: 1, //1 降序 0 升序
      },
      modalVisible: false,
      goodsListsType: false,
      titleIndex: props.navigation.getParam('titleIndex', 0) + 1, // 当前分类索引
      localCode: global.regionCode, // 推荐商品需要定位地址
      recommendFilterPar: null, // 推荐商品 过滤参数
      listName: ['recommendGoodsList', 'categoryList'],
      clearFilter: false, // 是否清空筛选条件
      filterActiveIndex: props.navigation.getParam('titleIndex', 0) === -1 ? -1 : 0, // 当前选中的筛选条件
    }
  }
  scrollHeight = 0;

  componentWillMount() {
    Loading.hide()
    this.props.handleUpDataSelectStatus({ index: 0})
  }

  componentDidMount() {
    this.getListData();
  }

  changeState(key, value) {
    this.setState({ [key]: value });
  }
  // 判断是否获取推荐商品分类列表
  getListData = () => {
    const { titleIndex } = this.state
    titleIndex === 0 ? this.getRecommendGoodsList(true, false): this.getCateListData();
  }
  // 获取推荐商品列表
  getRecommendGoodsList = (isFirst = true, isLoadingMore = false, loading = true, refreshing = false, recommendFilterPar = this.state.recommendFilterPar) => {
    let { localCode, listName } = this.state
    let { dispatch, fetchList } = this.props
    if (!localCode) {
      Toast.show('获取推荐商品数据失败，请重试！')
      return
    }
    let filter = recommendFilterPar ? recommendFilterPar : null;
    let paramsPrivate = {
      condition: {
        districtCode: localCode,
        ...filter
      }
    }
    fetchList({
      witchList: listName[0],
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

  // 获取非推荐商品分类列表
  getCateListData = (isFirst = true, isLoadingMore = false, loading = true, refreshing = false, filterParams = this.state.filterParams) => {
    let { titleIndex, listName } = this.state;
    let { categoryLists, fetchList } = this.props
    let titleList = [{name: '推荐'}].concat(categoryLists);
    let paramsPrivate = {
      condition: {
          category: titleList[titleIndex] && titleList[titleIndex].code || '',
      },
      sort: {
          ...filterParams
      },
    };
    fetchList({
      witchList: listName[1],
      isFirst,
      isLoadingMore,
      paramsPrivate,
      api: requestApi.requestSearchGoodsList,
      callback: () => {},
      loading,
      refreshing,
      limit:10,
    })
  }
  // 点击tabs
  onChangeTab = (i) => {
    const { titleIndex } = this.state
    // 如果重复点击同一个tabs，则进行 refresh 操作
    if (i === titleIndex) {
      this.setState({
        clearFilter: true,// 更换tabs，清空组件历史筛选条件
        filterActiveIndex: i === 0 ? -1 : 0,
        filterParams: { // 切换tabs，清空历史筛选条件，并默认销量降序
          type: 'saleQ', // 排序字段，如：popularity 人气 saleQ 销量 price 价格
          isDesc: 1, //1 降序 0 升序
        },
        recommendFilterPar: null, // 清空历史排序筛选条件
      }, () => {
        i === 0 ? this.getRecommendGoodsList(false, false, false, true): this.getCateListData(false, false, false, true);
      })
      return
    }
    this.setState({
      titleIndex: i,
      clearFilter: true,// 更换tabs，清空组件历史筛选条件
      filterActiveIndex: i === 0 ? -1 : 0,
      filterParams: { // 切换tabs，清空历史筛选条件，并默认销量降序
        type: 'saleQ', // 排序字段，如：popularity 人气 saleQ 销量 price 价格
        isDesc: 1, //1 降序 0 升序
      },
      recommendFilterPar: null, // 清空历史排序筛选条件
    }, () => { this.getListData() })
  }

  // 获取并设置筛选数据，然后根据当前选择的分类，获取当前分类数据
  getFilterData = (data, cancel = false) => {
    const { titleIndex } =this.state
    console.log('wer', data)
    this.setState({
      filterParams: cancel ? null : data, // 如果点击返回已取消，清空筛选条件 （是否返回已取消，在筛选组件中判断）
      recommendFilterPar: cancel ? null : this.fliterCommGoods(data),
      clearFilter: false,
      filterActiveIndex:  cancel ? -1 : data.index,
    }, () => {
      this.getListData();
    })
  }
  // 索引为推荐时候，获取筛选参数
  fliterCommGoods = (data) => {
    const { titleIndex } = this.state
    if (titleIndex !== 0) return null;
    let fliterParam = {
      orderType: ''
    }
    if (data.isDesc === 0 && data.type === "saleQ") {
      fliterParam.orderType = 'SALE_NUM_ASC'
    }
    if (data.isDesc === 1 && data.type === "saleQ") {
      fliterParam.orderType = 'SALE_NUM_DESC'
    }
    if (data.isDesc === 1 && data.type === "price") {
      fliterParam.orderType = 'PRICE_DESC'
    }
    if (data.isDesc === 0 && data.type === "price") {
      fliterParam.orderType = 'PRICE_ASC'
    }
    return fliterParam.orderType === '' ? null : fliterParam;
  }

  // 每项商品
  renderItem = ({ item, index, colIndex }) => {
    const { navigation, longLists } = this.props;
    const { goodsListsType,titleIndex, listName } = this.state;
    let data = titleIndex === 0 ? longLists[listName[0]] && longLists[listName[0]].lists : longLists[listName[1]] && longLists[listName[1]].lists;
    return (
      <MallGoodsListItem pageName='SOMLists' colIndex={ colIndex } index={index} item={item} navigation={navigation} data={data} goodsListsType={goodsListsType}/>
    );
  }

  // 弹窗左边TabBar
  renderLeftTabBar = () => {
    const { goodsCategoryLists } = this.props
    return (
      <View style={styles.cagListsView}>
        <ScrollView
          alwaysBounceVertical={false}
          showsVerticalScrollIndicator={false}
          ref={(ref) => { this.leftTabBarRef = ref }}
          onScroll={(event) => {
            console.log('event',event.nativeEvent.contentOffset)
            this.leftTabBarHeight = parseInt(event.nativeEvent.contentOffset.y)
          }}
        >
          {
            goodsCategoryLists.length !== 0 && goodsCategoryLists.map((item, index) => {
              return (
                <TouchableOpacity
                  key={index}
                  style={[styles.cagListsView_left_view, item.selected_status ? null : styles.cagListsView_left_view1]}
                  onPress={() => {
                    this.props.handleUpDataSelectStatus({ index: index})
                  }}
                >
                  <View style={styles.cagListsView_left_item}>
                    <Text
                      style={[styles.collectionText, item.selected_status ? styles.cag1_item_text2 : null]}
                      numberOfLines={2}
                    >
                      {item.name}
                    </Text>
                  </View>
                  <View style={styles.cagListsView_left_item_line}></View>
                </TouchableOpacity>
              );
            })
          }
        </ScrollView>
      </View>
    )
  }

  // 当前弹窗内容
  renderTabContent = () => {
    const { goodsCategoryLists, navigation } = this.props
    return (
      <View style={[styles.cagListsView, styles.cagListsView_right]}>
        <ScrollView alwaysBounceVertical={false} showsVerticalScrollIndicator={false}>
          {
            goodsCategoryLists.length !== 0 && goodsCategoryLists.map((item, index) => {
              if (item.selected_status) {
                return item.children && item.children.length !== 0 && item.children.map((item2, index2) => {
                  return (
                      <View key={index2}>
                        <View style={styles.cag_cld_view}>
                          <Text style={[styles.cag_cld_title, {fontWeight: '700'}]}>{item2.name}</Text>
                        </View>
                        <View style={styles.cag_cld_view2}>
                          {
                            item2.children && item2.children.length !== 0 && item2.children.map((item3, index3) => {
                              let boxStyle = index3 % 3 === 2 ? styles.cag_cld2_view1 : null;
                              return (
                                <TouchableOpacity
                                  key={index3}
                                  style={[styles.cag_cld2_view, boxStyle]}
                                  onPress={() => {
                                    this.changeState('modalVisible', false);
                                    navigation.navigate('SOMListsThird', { item: item3 });
                                  }}
                                >
                                  <ImageView
                                    style={styles.cag_cld2_img}
                                    resizeMode='cover'
                                    source={{ uri: item3.picUrl }}
                                    sourceWidth={(width - 174) / 3}
                                    sourceHeight={80}
                                  />
                                  <Text style={styles.cag_cld2_text} numberOfLines={1}>{item3.name}</Text>
                                </TouchableOpacity>
                              );
                            })
                          }
                        </View>
                      </View>
                    );
                })
              }
            })
          }
        </ScrollView>
      </View>
    )
  }

  // 头部内容
  renderHeaderTop = () => {
    const { navigation } = this.props
    const { goodsListsType } = this.state;
    return (
      <View style={[styles.headerItem, styles.headerCenterView]}>
        <TouchableOpacity
          activeOpacity={0.8}
          style={styles.headerCenterItem1}
          onPress={() => { navigation.navigate('SOMSearch') }}
        >
          <View style={styles.headerCenterItem1_search}>
            <Image source={require('../../images/mall/search.png')} />
          </View>
          <View style={styles.headerCenterItem1_textView}>
            <Text style={styles.headerCenterItem1_text} numberOfLines={1}>搜索你想要的商品</Text>
          </View>
        </TouchableOpacity>
        <View style={{marginLeft: 15}}>
        <MallHeaderTitle
          data={[
          {
            icon: require('../../images/mall/messages.png'),
            onPress: () => { nativeApi.createXKCustomerSerChat() }
          },
          {
            icon: require('../../images/mall/shoppingcart.png'),
            onPress: () => { navigation.navigate("SOMShoppingCart"); }
          },
          {
            icon: require('../../images/mall/orders.png'),
            onPress: () => { navigation.navigate("SOMOrder", { goBackRouteName: 'SOMLists' }); }
          },
          {
            icon: require('../../images/mall/fg_ling.png'),
            onPress: () => {}
          },{
            icon: goodsListsType ? require('../../images/mall/list2.png'):require('../../images/mall/list1.png'),
            onPress:() => {
              this.changeState('goodsListsType', !goodsListsType);
              setTimeout(() => {
                this.flatListRef && this.flatListRef.scrollToOffset({ offset: this.scrollHeight, animated: false });
              }, 100);
            }
          }]}
        />
        </View>
      </View>
    )
  }

  // 这个函数不用注释了吧。。
  render() {
    const { navigation,dispatch } = this.props;
    const { titleIndex, modalVisible, goodsListsType, listName, clearFilter, filterActiveIndex } = this.state;
    let { categoryLists, longLists } = this.props
    let store = titleIndex === 0 
    ? { ...longLists[listName[0]], page: longLists[listName[0]] && longLists[listName[0]].listsPage || 1, } 
    : { ...longLists[listName[1]], page: longLists[listName[1]] && longLists[listName[1]].listsPage || 1, };
    let listData = titleIndex === 0 
    ? longLists[listName[0]] && longLists[listName[0]].lists || [] 
    : longLists[listName[1]] && longLists[listName[1]].lists || [];
    console.log('this.props',this.props)
    console.log('titleIndex', titleIndex)
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={true}
          rightView={<View style={{ width: 0 }} />}
          centerView={this.renderHeaderTop()}
        />
        {/* 过滤筛选Bar */}
        <MallGoodsFilter 
          activeIndex= {filterActiveIndex} 
          clearFilter={clearFilter} 
          style={styles.fliterStyle}  
          canCancel={titleIndex === 0 ? true: false}
          onPress={(data, cancel) => { this.getFilterData(data, cancel) }}
        />
        {/* 滑动列表 */}
        <ScrollableTabView
          initialPage={navigation.getParam('titleIndex', 0) + 1}
          onChangeTab={({ i }) => { this.onChangeTab(i) }}
          renderTabBar={() => (
            <ScrollableTabBar
              underlineStyle={{ backgroundColor: "#fff", height: 8, borderRadius: 10, marginBottom: -5 }}
              tabStyle={{ backgroundColor: "#4A90FA", height: 44 }}
              activeTextColor="#fff"
              inactiveTextColor="rgba(255,255,255,.5)"
              tabBarTextStyle={{ fontSize: 14 }}
              style={{ backgroundColor: "#4A90FA", height: 44, borderBottomWidth: 0, marginRight: 56 }}
            />
          )}
        >
        {
          [{name: '推荐'}].concat(categoryLists).map((itemTab, index) => {
            return (
              <View
                key={itemTab.name + index}
                style={{paddingTop: 44,height: '100%',}}
                tabLabel={itemTab.name}
              >
                <FlatListView
                  openWaterFall
                  flatRef={(ref) => { this.flatListRef = ref }}
                  extraData={this.state}
                  style={{ backgroundColor: CommonStyles.globalBgColor }}
                  store={store}
                  key={itemTab.name + index}
                  data={listData}
                  ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                  refreshData={() => { titleIndex === 0 ? this.getRecommendGoodsList(false, false, false, true) : this.getCateListData(false, false, false, true);
                  }}
                  numColumns={!goodsListsType ? 1 : 2}
                  loadMoreData={() => { titleIndex === 0 ? this.getRecommendGoodsList(false, true, false, false) : this.getCateListData(false, true, false, false);
                  }}
                  renderItem={this.renderItem}
                />
              </View>
            );
          })
        }
        </ScrollableTabView>
        {/* 弹窗按钮 */}
        <TouchableOpacity
          activeOpacity={1}
          style={[styles.categoriesMoreModal, CommonStyles.flex_center]}
          onPress={() => { this.changeState('modalVisible', true) }}
        >
          <Image source={require('../../images/mall/mall_more.png')} />
        </TouchableOpacity>
        {/* 更多弹窗 */}
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
              onPress={() => { this.changeState('modalVisible', false); }}
            >
            </TouchableOpacity>
            <View style={styles.modalInnerBottomView}>
              <TouchableOpacity
                style={[styles.collectionView]}
                onPress={() => {
                  this.changeState('modalVisible', false);
                  navigation.navigate('SOMCollection');
                }}
              >
                <Text style={[styles.collectionText, {fontWeight: '700'}]}>我的收藏</Text>
                <Image source={require('../../images/mall/goto.png')} />
              </TouchableOpacity>
                <View style={styles.categorieListsView}>
                  {/* 弹窗左边标题列表 */}
                  { this.renderLeftTabBar() }
                  {/* 当前标题内容 */}
                  { this.renderTabContent() }
                </View>
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
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    headerCenterView: {
        flex: 1,
    },
    headerCenterItem1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        flex: 1,
        height: 30,
        borderRadius: 15,
        backgroundColor: 'rgba(255,255,255,0.3)',
    },
    headerCenterItem1_search: {
        width: 32,
        paddingHorizontal: 8,
        opacity: 1
    },
    headerCenterItem1_textView: {
        justifyContent: 'center',
        alignItems: 'flex-start',
        flex: 1,
        height: 20,
        marginRight: 8,
    },
    headerCenterItem1_text: {
        fontSize: 14,
        color: 'rgba(255,255,255,0.8)',
    },
    fliterStyle: {
        position: 'absolute',
        top: CommonStyles.headerPadding + 88,
        width,
        height: 44,
        zIndex: 2,
        // backgroundColor: 'red'
    },
    cag1_item_text2: {
        color: '#4A90FA',
    },
    modalOutView: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    modalInnerTopView: {
        width: width,
        height: 82 + CommonStyles.headerPadding,
        backgroundColor: 'rgba(0, 0, 0, .5)',
    },
    modalInnerBottomView: {
        flex: 1,
        width: width,
        // borderTopWidth: 5,
        // borderTopColor: '#F1F1F1',
        backgroundColor: '#fff',
    },
    collectionView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: width,
        // height: 30,
        paddingHorizontal: 25,
        paddingVertical:15,
        borderBottomWidth: 1,
        borderBottomColor: '#F1F1F1',
    },
    collectionText: {
        fontSize: 14,
        color: '#222',
    },
    categorieListsView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        flex: 1,
    },
    cagListsView: {
        width: 114,
        height: '100%',
        backgroundColor: '#F1F1F1',
        paddingBottom: CommonStyles.footerPadding,
    },
    cagListsView_right: {
        flex: 1,
        backgroundColor: '#fff',
    },
    cagListsView_left_view: {
        height: 50,
        backgroundColor: '#fff',
    },
    cagListsView_left_view1: {
        backgroundColor: '#F1F1F1',
    },
    cagListsView_left_item: {
        justifyContent: 'center',
        height: '99%',
        paddingHorizontal: 25,
    },
    cagListsView_left_item_line: {
        height: 1,
        marginHorizontal: 15,
        backgroundColor: '#E5E5E5',
    },
    cag_cld_view: {
        justifyContent: 'center',
        flex: 1,
        height: 50,
        paddingHorizontal: 15,
    },
    cag_cld_title: {
        fontSize: 14,
        color: '#777',
    },
    cag_cld_view2: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingTop: 15,
        paddingHorizontal: 15,
    },
    cag_cld2_view: {
        justifyContent: 'center',
        alignItems: 'center',
        width: (width - 174) / 3,
        // height: 100,
        marginRight: 15,
        marginBottom: 15,
    },
    cag_cld2_view1: {
        marginRight: 0,
    },
    cag_cld2_img: {
        width: '100%',
        height: 80,
    },
    cag_cld2_text: {
        width: '100%',
        marginVertical: 5,
        fontSize: 12,
        color: '#555',
        textAlign: 'center',
    },
    flatListLine: {
        height: 0,
        // backgroundColor: 'blue',
    },
    categoriesMoreModal: {
        position: 'absolute',
        width: 56,
        height: 44,
        right: 0,
        top: CommonStyles.headerPadding + 44,
        backgroundColor: CommonStyles.globalHeaderColor,
    },
});

export default connect(
    (state) => ({
        categoryLists: state.mall.goodsCategoryLists_pre, // 分类列表标题
        // categoryGoodsList: state.mall.categoryGoodsList, // 分类列表商品数据
        // recommendGoodsListOfCategory: state.mall.recommendGoodsListOfCategory, // 推荐商品列表商品数据
        goodsCategoryLists: state.mall.goodsCategoryLists, // 弹窗分类列表数据
        longLists:state.shop.longLists || {},
     }),
    dispatch=>({
        fetchList: (params={})=> dispatch({ type: "shop/getList", payload: params}),
        handleUpDataSelectStatus: (params = {}) => dispatch({ type: "mall/handleUpDataSelectStatus", payload: params}),
        fetchCategoryList: (params = {}) => dispatch({ type: "mall/fetchCategoryList", payload: params}),
    })
)(SOMListsScreen);
