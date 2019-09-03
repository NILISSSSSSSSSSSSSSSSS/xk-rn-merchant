/**
 * 福利商城首页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  
  View,
  Text,
  Button,
  TouchableOpacity,
  Image,
  BackHandler,

} from 'react-native';
import { connect } from 'rn-dva';

// import Swiper from "react-native-swiper";
import moment from 'moment';
import CarouselSwiper from '../../components/CarouselSwiper';
import math from '../../config/math';

import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as utils from '../../config/utils';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import ImageView from '../../components/ImageView';
import BannerImage from '../../components/BannerImage';
import FlatListView from '../../components/FlatListView';
import Process from '../../components/Process';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import MallHeaderTitle from '../../components/MallHeaderTitle';
import { showSaleNumText } from '../../config/utils'
import { NavigationComponent } from '../../common/NavigationComponent';
// import BlurredPrice from '../../components/BlurredPrice'
const localCode = global.regionCode;
const { width, height } = Dimensions.get('window');
const listData = [
  {
    name: '夺奖商品',
    icon: require('../../images/home/fuli.png'),
    route: '',
  },
  {
    name: '平台大奖',
    icon: require('../../images/wm/list_palf_icon.png'),
    route: '',
  },
  {
    name: '查看更多',
    icon: require('../../images/home/more.png'),
    route: '',
  },
];
const activityData1 = [
  {
    // 最新揭晓,所有人参与的
    icon: require('../../images/wm/recentlyPrize.png'),
    route: 'WMAllLatelyPrize',
  }, {
    // 大奖晒单
    icon: require('../../images/wm/show_order.png'),
    route: 'BigPrizeOrder',
  },
  { // 活动规则
    icon: require('../../images/wm/drawules.png'),
    route: 'WMActiveRole',
    params: { param: 'type=welfare' },
  },
];
class WMScreen extends NavigationComponent {
    _didFocusSubscription;

    scrollHeight = 0;

    constructor(props) {
      super(props);
      this.state = {
        goodsListsType: false,
        limit: 10,
        goodLists: [],
        selectIndex: 0, // 选择查看商品详情的index
      };
    }

    screenWillFocus () {
      BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
    }
    screenWillBlur () {
      BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
    }
    onBackButtonPressAndroid = () => {
      const { navigation } = this.props
      const isFocused = this.props.navigation.isFocused();
      if (isFocused) {
          navigation.goBack();
          return true;
      }
      return false
    };
    componentDidMount() {
      this.getData();
    }

    componentWillUnmount() {
    }

    // 获取基础数据
    getData = (page = 1) => {
      this.refresh(page);
    };

    // 刷新
    refresh = (page = 1, address = localCode) => {
      const { limit, total, goodLists } = this.state;
      const params = {
        page,
        limit,
        jCondition: { districtCode: address },
      };
      this.props.dispatch({ type: 'welfare/initPageData', payload: { params } });
    };

    // 抽奖状态
    getProcessView = (item) => {
      const time = moment(item.expectDrawTime * 1000).format(
        'YYYY-MM-DD HH:mm',
      );
      const processValue = parseInt(item.currentCustomerNum / item.eachSequenceNumber, 10);
      const processPercent = `${processValue}%`;
      const borderRadius = this.state.goodsListsType ? styles.borderNone : {};
      let fixedNumber = item.eachSequenceNumber > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.currentCustomerNum,fixedNumber)}/${showSaleNumText(item.eachSequenceNumber,fixedNumber)}`
      switch (item.drawType) {
        case 'bymember':
          return (
            <View style={[styles.processItem, borderRadius]}>
              <Process
                labelStyle={styles.labelStyle}
                showText={showText}
                label="进度:"
                height={4}
                nowValue={processValue}
              />
            </View>
          );
        case 'bytime_or_bymember':
          return (
            <React.Fragment>
              <View style={[styles.processItem, borderRadius]}>
                <Process
                  labelStyle={styles.labelStyle}
                  showText={showText}
                  label="进度:"
                  height={4}
                  nowValue={processValue}
                />
              </View>
              <View
                style={[
                  styles.openPrizeItem,
                  borderRadius,
                  { borderTopColor: '#fff', borderTopWidth: 0, marginTop: 0 },
                ]}
              >
                <Text style={styles.openPrizeItemTitle}>时间:</Text>
                <Text style={styles.openPrizeItemTime}>{time}</Text>
              </View>
            </React.Fragment>
          );
        case 'bytime':
          return (
            <React.Fragment>
              <View
                style={[
                  styles.openPrizeItem,
                  { backgroundColor: '#F0F6FF' },
                  borderRadius,
                ]}
              >
                <Text style={styles.openPrizeItemTitle}>时间:</Text>
                <Text
                  style={[
                    styles.openPrizeItemTime,
                    { color: '#4A90FA' },
                  ]}
                >
                  {time}
                </Text>
              </View>
            </React.Fragment>
          );
        case 'bytime_and_bymember':
          return (
            <React.Fragment>
              <View style={[styles.processItem, borderRadius]}>
                <Process
                  labelStyle={styles.labelStyle}
                  showText="100%"
                  label="进度:"
                  height={4}
                  nowValue={processValue}
                />
              </View>
              <View
                style={[
                  borderRadius,
                  styles.flexStart,
                  {
                    paddingLeft: 6,
                    paddingBottom: 7,
                    backgroundColor: '#f0f6ff',
                  },
                ]}
              >
                <Text style={styles.openPrizeItemTitle}>时间:</Text>
                <Text
                  style={[
                    styles.openPrizeItemTime,
                    { color: '#4A90FA' },
                  ]}
                >
                  {time}
                </Text>
              </View>
            </React.Fragment>
          );
        default:
          return null;
      }
    };

    getPrizeLable = (drawType) => {
      switch (drawType) {
        case 'bymember': return (
          <Image source={require('../../images/wm/processPrizeicon.png')} />
        );
        case 'bytime': return (
          <Image source={require('../../images/wm/timePrizeicon.png')} />
        );
        case 'bytime_or_bymember': return (
          <Image source={require('../../images/wm/byTimeOrProcess.png')} />
        );
        case 'bytime_and_bymember': return (
          <Image source={require('../../images/wm/byTimeAndProcess.png')} />
        );

        default: return null;
      }
    }

    handleChangeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    // 每项商品
    renderItem = ({ item, index }) => {
      const { navigation } = this.props;
      const { goodsListsType, goodLists } = this.state;
      const time = moment(item.expectDrawTime * 1000).format('MM-DD HH:mm');
      const value = math.multiply( math.divide(item.currentCustomerNum , item.eachSequenceNumber), 100);
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = item.eachSequenceNumber > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.currentCustomerNum,fixedNumber)}/${showSaleNumText(item.eachSequenceNumber,fixedNumber)}`
      const itemBoxRowEnd = index === goodLists && goodLists.length - 1 ? styles.itemBoxRowEnd : null;
      const itemBoxColRight = index % 2 !== 0 ? styles.itemBoxColRight : null;
      if (!goodsListsType) {
        return (
          <TouchableOpacity
            style={[
              styles.goodsListItemWrap,
              styles.flexStart_noCenter,
            ]}
            activeOpacity={0.65}
            onPress={() => {
              this.setState({ selectIndex: index });
              navigation.navigate('WMGoodsDetail', {
                goodsId: item.goodsId,
                sequenceId: item.sequenceId,
              });
            }}
          >
            <View style={{
              position: 'absolute', top: 15, left: 15, zIndex: 1,
            }}
            >
              { // 获取开奖类型标签
                this.getPrizeLable(item.drawType)
              }
            </View>
            <WMGoodsWrap
              imgUrl={item.mainUrl}
              imgStyle={styles.imgStyle}
              title={() => (
                  <Text style={styles.goodsViewText} numberOfLines={2}>
                    <Text style={[styles.red_color]}>{`[${math.divide(item.perPrice, 100)}消费券夺${math.divide(item.price, 100)}元]`}</Text>
                    {item.goodsName}
                  </Text>
              )}
              showProcess
              type={item.drawType}
              label="参与人次："
              timeLabel="开奖时间："
              labelStyle={styles.labelStyle}
              processValue={processValue}
              timeValue={time}
              showText={showText}
              // renderInsertContent={() => (
              //   <View style={{ height: 14,width: 100,marginTop: 5,marginBottom: 2,paddingHorizontal: 5,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
              //     <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>中奖后凭券0元兑换</Text>
              //   </View>
              // )}
            />
          </TouchableOpacity>
        );
      }
      return (
        <TouchableOpacity
        activeOpacity={0.65}
          style={[
            styles.goodsListItemWrap_Col,
            itemBoxColRight,
            itemBoxRowEnd,
          ]}
          onPress={() => {
            this.setState({ selectIndex: index });
            navigation.navigate('WMGoodsDetail', {
              goodsId: item.goodsId,
              sequenceId: item.sequenceId,
            });
          }}
        >
          <View style={styles.goodsView}>
            <Image
              style={styles.goodsViewImage}
              source={{ uri: item.mainUrl || '' }}
            />
            <Text style={styles.goodsViewText} numberOfLines={1}>
              {item.goodsName}
            </Text>

            <View style={{ height: 14,width: 100,paddingHorizontal: 5,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
              <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>订单半额消费券返还</Text>
            </View>
            <View style={[styles.flexStart, { marginTop: 3 }]}>
              <Text style={styles.goodsTicketsText_col}>
                消费券：
              </Text>
              {/* <BlurredPrice> */}
              <Text
                style={[
                  styles.goodsTicketsText_col,
                  { color: '#222' },
                ]}
              >
                {item.perPrice}
              </Text>
              {/* </BlurredPrice> */}

            </View>
            {this.getProcessView(item)}
          </View>
        </TouchableOpacity>
      );
    };

    render() {
      const { navigation, wmRecommendList, bannerLists } = this.props;
      const { goodsListsType } = this.state;
      const goodLists = wmRecommendList.data || [];
      return (
        <View style={styles.container}>
          <Header
          navigation={navigation}
          goBack
          centerView={(
            <View style={[styles.headerItem, styles.headerCenterView]}>
              <TouchableOpacity
                activeOpacity={0.8}
                style={styles.headerCenterItem1}
                onPress={() => { navigation.navigate('WMSearch'); }}
              >
                <View style={styles.headerCenterItem1_search}>
                  <Image source={require('../../images/mall/search.png')} />
                </View>
                <View style={styles.headerCenterItem1_textView}>
                  <Text style={styles.headerCenterItem1_text} numberOfLines={1}>搜索你想要的商品</Text>
                </View>
              </TouchableOpacity>

              <View style={{ marginLeft: 15 }}>
                <MallHeaderTitle
                  data={[{
                    icon: require('../../images/mall/collection.png'),
                    onPress: () => {
                      navigation.navigate('WelfareFavorites');
                    },
                  },

                  {
                    icon: require('../../images/mall/messages.png'),
                    onPress: () => { nativeApi.createXKCustomerSerChat(); },
                  },
                  {
                    icon: require('../../images/mall/shoppingcart.png'),
                    onPress: () => {
                      navigation.navigate('IndianaShopCart');
                    },
                  },
                  {
                    icon: require('../../images/mall/fg_ling.png'),
                    onPress: () => {
                    },
                  },
                  {
                    icon: require('../../images/mall/orders.png'),
                    onPress: () => {
                      navigation.navigate('WMOrderList');
                    },
                  }]}
                />
              </View>
            </View>
          )}
          rightView={<View style={{ width: 0 }} />}
          leftView={(
            <View>
              <TouchableOpacity
                style={[styles.headerItem, styles.left]}
                onPress={() => {
                  navigation.goBack();
                }}
              >
                <Image source={require('../../images/mall/goback.png')} />
              </TouchableOpacity>
            </View>
          )}
          />

          <FlatListView
            flatRef={(e) => { e && (this.flatListRef = e); }}
            style={styles.flatList}
            store={wmRecommendList.params}
            data={goodLists}
            onScroll={(e) => {
              const y = e.nativeEvent.contentOffset.y;
              this.scrollHeight = y;
            }}
            ListHeaderComponent={(
              <View>
                {
                  bannerLists.length !== 0
                  // eslint-disable-next-line no-mixed-operators
                  && (
                  <CarouselSwiper
                    key={bannerLists.length}
                    style={styles.bannerView}
                    loop
                    autoplay
                    onPageChanged={(index) => {
                      // this.setState({ bannerIndex: index })
                    }}
                    index={0}
                    autoplayTimeout={5000}
                    showsPageIndicator
                    pageIndicatorStyle={styles.banner_dot}
                    activePageIndicatorStyle={styles.banner_activeDot}
                  >
                    {
                      bannerLists.length !== 0 && bannerLists.map((item, index) => {
                        const data = item.templateContent || [];
                        return (
                          <BannerImage
                            // eslint-disable-next-line react/no-array-index-key
                            key={index}
                            navigation={navigation}
                            style={styles.bannerView}
                            data={data}
                          />
                        );
                      })
                  }
                  </CarouselSwiper>
                  ) || <View style={styles.bannerView} />
              }
                <View style={styles.categoryView}>
                  {listData && listData.length !== 0
                    && listData.map((item, index) => (
                      <TouchableOpacity
                        // eslint-disable-next-line react/no-array-index-key
                        key={index}
                        style={styles.categoryItem}
                        onPress={() => {
                          navigation.navigate('WMLists', { index });
                        }}
                      >
                        <ImageView
                          style={styles.category_img}
                          resizeMode="cover"
                          source={item.icon}
                          sourceWidth={40}
                          sourceHeight={40}
                          fadeDuration={0}
                        />
                        <Text
                          numberOfLines={1}
                          style={styles.category_text}
                        >
                          {item.name}
                        </Text>
                      </TouchableOpacity>
                    ))}
                </View>
                <View style={styles.adTitle}>
                  <Image source={require('../../images/wm/left-side.png')} />
                  <Text style={styles.adTitle_text}>下单抽大奖赢好礼</Text>
                  <Image source={require('../../images/wm/right-side.png')} />
                </View>
                <View style={[styles.adLists, { minHeight: 120 }]}>
                  {activityData1.map((item, index) => (
                    <TouchableOpacity
                      // eslint-disable-next-line react/no-array-index-key
                      key={index}
                      style={[styles.adLists_item]}
                      onPress={() => { navigation.navigate(item.route, item.params); }}
                    >
                      <Image
                      // resizeMode='center'
                      source={item.icon}
                      fadeDuration={0}
                      />
                    </TouchableOpacity>
                  ))}
                </View>
                <View style={styles.Blockbote} />
                <View style={[CommonStyles.flex_center, {
                  position: 'relative', padding: 15, backgroundColor: '#fff', borderBottomColor: '#f1f1f1', borderBottomWidth: 0.7,
                }]}
                >
                  <View style={[CommonStyles.flex_start]}>
                    <View style={[styles.line]} />
                    <Text style={{ fontSize: 17, color: '#222', marginHorizontal: 6 }}>商品推荐</Text>
                    <View style={[styles.line]} />
                  </View>
                  <View style={[CommonStyles.flex_start, { position: 'absolute', right: 15, top: 15 }]}>
                    <Text onPress={() => { this.props.navigation.navigate('WMLists', { index: 10 }); }}>
                    更多
                    </Text>
                    <Image source={require('../../images/index/expand.png')} />
                  </View>
                </View>
              </View>
              )}
            emptyStyle={{
              paddingBottom: 40,
            }}
            ItemSeparatorComponent={() => (
              <View style={styles.flatListLine} />
            )}
            renderItem={this.renderItem}
            numColumns={!goodsListsType ? 1 : 2}
            refreshData={() => {
              console.log('refreshData');
              this.handleChangeState('refreshing', true);
              this.getData(1);
            }}
            loadMoreData={() => {
              console.log('loadMoreData');
              this.refresh(wmRecommendList.page + 1);
            }}
          />
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    // backgroundColor:'#EEEEEE'
  },
  red_color: {
    color: '#EE6161',
  },
  borderNone: {
    borderRadius: 0,
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexStart_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flex_1: {
    flex: 1,
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
    backgroundColor: 'rgba(255,255,255,0.5)',
  },
  headerCenterItem1_search: {
    width: 32,
    paddingHorizontal: 8,
    marginTop: 1,
  },
  headerCenterItem1_textView: {
    justifyContent: 'center',
    alignItems: 'flex-start',
    flex: 1,
    // height: 20,
    marginRight: 8,
  },
  headerCenterItem1_text: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.8)',
  },
  headerCenterItem2: {
    width: 114,
  },
  headerCenterItem2_icon: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    height: '100%',
  },
  flatList: {
    flex: 1,
    backgroundColor: CommonStyles.globalBgColor,
  },
  flatListLine: {
    height: 0,
    backgroundColor: '#F1F1F1',
  },
  bannerView: {
    height: 136,
    backgroundColor: '#f1f1f1',
  },
  banner_dot: {
    width: 4,
    height: 4,
    borderRadius: 4,
    marginLeft: 1.5,
    marginRight: 1.5,
    marginBottom: -20,
    backgroundColor: '#fff',
  },
  banner_activeDot: {
    width: 12,
    height: 4,
    borderRadius: 10,
    marginLeft: 1.5,
    marginRight: 1.5,
    marginBottom: -20,
    backgroundColor: '#fff',
  },
  categoryView: {
    // ...CommonStyles.shadowStyle,
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    width,
    height: 87,
    marginBottom: 10,
    backgroundColor: '#fff',
    paddingHorizontal: 15,
    overflow: 'hidden',
    paddingHorizontal: 34,
  },
  categoryItem: {
    justifyContent: 'center',
    alignItems: 'center',
    // width: '25%',
    height: '100%',
    // paddingHorizontal: 5,
  },
  category_img: {
    width: 40,
    height: 40,
    borderRadius: 20,
  },
  category_text: {
    fontSize: 12,
    color: '#222',
    marginTop: 5,
  },
  adTitle: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 47,
    backgroundColor: '#FBEEDE',
  },
  adTitle_text: {
    fontSize: 17,
    color: '#222',
    marginHorizontal: 15,
    fontWeight: 'bold',
  },
  adLists: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width,
    backgroundColor: '#FBEEDE',
    paddingBottom: 25,
    paddingHorizontal: 10,
  },
  Blockbote: {
    backgroundColor: '#f6f6f6',
    height: 10,
  },
  adLists_item: {
    // ...CommonStyles.shadowStyle,
    position: 'relative',
    width: (width - 20) / 3,
    // height: 105,
    marginTop: 10,
    borderRadius: 8,
    ...CommonStyles.flex_center,
    // backgroundColor: '#fff',
  },
  adLists_item_end: {
    marginRight: 10,
  },
  adLists_item_img: {
    // width: 110,
    // height: 80,
    width: (width - 30) / 3,
    height: 110,
    // width: '100%',
    // height: '100%'
  },
  adLists_item_textView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
  },
  adLists_item_text: {
    fontSize: 14,
    color: '#222',
  },
  adLists_item_icon: {
    position: 'absolute',
    top: 0,
    left: 0,
  },
  adBtn: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 70,
    backgroundColor: '#F6F6F6',
  },
  adBtnImg: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: 279,
    height: 50,
  },
  adBtn_text: {
    fontSize: 14,
    color: '#fff',
  },
  itemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width,
    padding: 15,
    paddingBottom: 3,
    backgroundColor: '#fff',
  },
  itemHeaderCol: {
    paddingBottom: 13,
  },
  itemHeader_text: {
    fontSize: 17,
    marginHorizontal: 6,
    color: '#222',
  },
  headerRight_icon: {
    width: 50,
  },
  itemHeaderTitle: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
  },
  itemHeaderTitle_line: {
    width: 15,
    height: 2,
    borderRadius: 8,
    backgroundColor: '#4A90FA',
  },
  itemBoxRowEnd: {
    marginBottom: 10,
  },
  learnMore: {
    backgroundColor: '#f6f6f6',
    height: 44,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  learnMoreText: {
    fontSize: 14,
    color: '#777',
    textAlign: 'center',
  },
  processItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#f0f6ff',
    paddingVertical: 8,
    paddingHorizontal: 7,
    borderRadius: 4,
    marginTop: 5,
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 7,
  },
  goodsTicket: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: '#fff',
    paddingLeft: 10,
    marginTop: 10,
  },
  goodsTicketLeft: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  goodsTicketLeftTitle: {
    fontSize: 12,
    color: '#555',
  },
  goodsTicketLeftNum: {
    paddingLeft: 6,
    color: '#EE6161',
    fontSize: 12,
  },
  goodsTicketRight: {
    fontSize: 12,
    color: '#999',
  },
  openPrizeItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    backgroundColor: '#FFF4E1',
    paddingVertical: 8,
    paddingHorizontal: 7,
    borderRadius: 4,
    marginTop: 2,
  },
  openPrizeItemTitle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 5,
  },
  openPrizeItemTime: {
    fontSize: 12,
    color: '#F5A623',
  },
  nomargin: {
    marginTop: 0,
    borderTopLeftRadius: 0,
    borderTopRightRadius: 0,
    backgroundColor: '#F0F6FF',
    paddingTop: 0,
    backgroundColor: 'red',
  },
  noBottomRadius: {
    borderBottomLeftRadius: 0,
    borderBottomRightRadius: 0,
  },

  goodsListItemWrap: {
    backgroundColor: '#fff',
    borderBottomWidth: 0.7,
    borderBottomColor: '#F1F1F1',
    // padding: 15
  },
  goodsImg: {
    height: 100,
    width: 100,
  },
  goodsInfoWrap: {
    paddingLeft: 12,
  },
  goodsTicketsText: {
    fontSize: 12,
    color: '#777',
  },
  goodsListItemWrap_Col: {
    width: width / 2 - 2,
    borderRadius: 6,
    paddingRight: 3.5,
    paddingLeft: 10,
    marginTop: 10,
  },
  itemBoxColRight: {
    paddingLeft: 3.5,
    paddingRight: 10,
  },
  goodsView: {
    borderColor: '#f1f1f1',
    borderWidth: 1,
    borderRadius: 6,
  },
  goodsViewImage: {
    width: '100%',
    height: 168,
    borderTopLeftRadius: 6,
    borderTopRightRadius: 6,
  },
  goodsViewText: {
    fontSize: 14,
    lineHeight: 16,
    color: '#101010',
    paddingLeft: 6,
    paddingTop: 8,
  },
  goodsTicketsText_col: {
    paddingLeft: 6,
    fontSize: 12,
    color: '#777',
  },
  goodsTitleStyle: {
    fontSize: 14,
    lineHeight: 18,
    color: '#222',
  },
  marginHor: {
    marginLeft: 0,
  },
  itemHeaderTitle: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  itemHeaderTitle_line: {
    width: 15,
    height: 2,
    borderRadius: 8,
    backgroundColor: '#4A90FA',
  },
  imgStyle: {
    borderRadius: 8,
  },
  line: {
    width: 15,
    height: 2,
    borderRadius: 8,
    backgroundColor: '#4A90FA',
  },
  expenseLabel: {
    position: 'absolute',
    bottom: 15.5,
    left: 15.5,
    zIndex: 2,
    height: 20,
    width: 79,
    overflow: 'hidden',
    borderBottomLeftRadius: 10,
    borderBottomRightRadius: 10,
  },
  left: {
    width: 50,
  },
});

export default connect(
  state => ({
    wmRecommendList: state.welfare.wmRecommendList || {},
    bannerLists: state.welfare.bannerList_wm || [],
  }),
)(WMScreen);
