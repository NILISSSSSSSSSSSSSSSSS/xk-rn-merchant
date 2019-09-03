/**
 * 福利商城首页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  RefreshControl,
  TouchableOpacity,
  ImageBackground,
  ScrollView,
  NativeModules,
  NativeEventEmitter,
  AppState,
  StatusBar,
  Animated,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import { withNavigationFocus } from 'react-navigation';
import { formatPriceStr, bannerJumpFun, checkoutRole } from '../config/utils';

import CarouselSwiper from '../components/CarouselSwiper';
import CommonStyles from '../common/Styles';
import BannerImage from '../components/BannerImage';
import * as nativeApi from '../config/nativeApi';
import { ReLogin } from '../config/request';
import MarqueeLabel from '../components/MarqueeLabel';

import IconWithRedPoint from '../components/IconWithRedPoint';
import { JOIN_AUDIT_STATUS } from '../const/user';
import { NavigationComponent } from '../common/NavigationComponent';
import Icon from '../components/Icon';
import Button from '../components/Button';
import IconButton from '../components/IconButton';
import { ListItem } from '../components/List';
import XKText from '../components/XKText';

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return (width * val) / 375;
}

const listData = [
  {
    name: '夺奖派对',
    icon: require('../images/home/duojiang.png'),
    // route: "SOMOrder",
    route: 'WM',
    // route: "WMShowOrder",
    // route: "WMGoodsDamag",
    roleKey: 'welfareMall',
    isNeedRole: true,
  },
  {
    name: '批发商城',
    icon: require('../images/home/pifa1.png'),
    route: 'SOM',
    roleKey: 'wholesaleMall',
    isNeedRole: true,
  },
  // {
  //     name: "周边",
  //     icon: require("../images/home/around.png"),
  //     route: ""
  // },
  // {
  //     name: "游戏",
  //     icon: require("../images/home/game.png"),
  //     route: "",
  //     roleKey: '',
  //     isNeedRole: false,
  // },
  // {
  //     name: "更多",
  //     icon: require("../images/home/more.png"),
  //     route: "",
  //     roleKey: '',
  //     isNeedRole: false,
  // }
];
const usualFunc = [
  {
    name: '联盟商收益',
    intro: '收益随时看',
    icon: require('../images/home/shouyi1.png'),
    route: 'Profit',
    roleKey: 'merchantProfit',
    isNeedRole: true,
  },
  {
    name: '联盟商数据',
    intro: '推广数据',
    icon: require('../images/home/merchantData.png'),
    route: 'Profit',
    roleKey: 'merchantProfitData',
    isNeedRole: true,
    params: { route: 'unionDataHome?nativeBack=yes' },
  },
  {
    name: '财务账户',
    intro: '每月报表',
    icon: require('../images/home/finance1.png'),
    route: 'FinancialAccount',
    roleKey: 'accountFinance',
    isNeedRole: true,
  },
  {
    name: '联盟商群',
    intro: '商户共享',
    icon: require('../images/home/lianmengshang.png'),
    route: 'localGroup',
    roleKey: 'group',
    isNeedRole: true,
    test: /^home.unionGroup/gm,
  },
  {
    name: '晓可物流',
    intro: '专属快递',
    icon: require('../images/home/wuliu.png'),
    route: 'XKLogistics',
    roleKey: 'logistics',
    isNeedRole: true,
  },
  {
    name: '常见问题',
    intro: '答疑解问',
    icon: require('../images/home/question.png'),
    route: 'ComeProblemCatrgory',
    isNeedRole: false,
  },
];

class HomeScreen extends Component {
  constructor(props) {
    super(props);
  }
    state = {
      refreshing: false,
      showIntor: true, // e是否显示欢迎屏
      isCheckoutVer: false, // 是否进行版本检查
      showCashPrizeIndex: 0, // 中奖信息切换索引
      bannerIndex: 0,
    };
    screenWillFocus = () => {
      this.props.fetchJprizeUserPrizeData();
      this.setStatusBarStyleLight('dark-content');
    }
    // screenWillBlur = (payload) => {
    //   StatusBar.setBarStyle('light-content');
    // }
    componentDidMount() {
      setTimeout(() => {
        global.initAppRegistry();
        SplashScreen.hide();
      }, 100);
    }

    componentWillMount = () => {
      // 这里搞原生token失效的代码
      const xkMerchantEmitterModule = NativeModules.xkMerchantEmitterModule;
      const myNativeEvt = new NativeEventEmitter(xkMerchantEmitterModule); // 创建自定义事件接口
      this.listener = myNativeEvt.addListener('loginTokenFail', failReason => this.loginTokenFail(failReason));
      this.props.fetchHomeData();
      this.setStatusBarStyleLight('dark-content');
    }
    setStatusBarStyleLight = (style = 'light-content') => {
      StatusBar.setBarStyle(style);
    }
    componentDidUpdate(nextProps, nextState) {
      const { isFocused, navigation } = this.props;
      if (nextProps.isFocused !== this.props.isFocused) {
        if (isFocused) {
          const routeName = navigation.state.routeName;
          console.log(123, routeName);
          if (routeName === 'Home') {
            this.screenWillFocus();
          }
        }
      }
    }

    loginTokenFail(reason) {
      console.log(reason);
      this.listener && this.listener.remove(); // 记得remove哦
      this.listener = null;
      ReLogin(false, reason);
    }
    _onRefresh = () => {
      this.props.fetchHomeData();
    };

    handleUsualFunc = (item, isNotAuditSuccess, isAdmin, allRoleList) => {
      const { checkAuditStatus, navigation } = this.props;
      checkAuditStatus(() => {
        if (item.isNeedRole && isAdmin !== 1 && !checkoutRole(item.roleKey, allRoleList)) return;
        if (item.route == 'localGroup') {
          nativeApi.jumpLocalUnionGroup();
          return;
        }
        this.setStatusBarStyleLight('light-content');
        navigation.navigate(item.route, item.params);
      });
    }

    handleListData = (item, allRoleList) => {
      const { navigation } = this.props;
      // 判断权限
      if (item.isNeedRole && !checkoutRole(item.roleKey, allRoleList)) return;
      navigation.navigate(item.route);
      this.setStatusBarStyleLight('light-content');
    }

    handleToProfit = () => {
      const { checkAuditStatus, navigation } = this.props;
      checkAuditStatus(() => {
        this.setStatusBarStyleLight('light-content');
        navigation.navigate('Profit', { route: 'currentMonthIncome?nativeBack=yes' });
      });
    }

    render() {
      const {
        navigation, user, shop, effects, home, checkAuditStatus,
      } = this.props;
      const { auditStatus, createdMerchant, isAdmin } = user.user || {};
      const isNotAuditSuccess = auditStatus !== JOIN_AUDIT_STATUS.success || createdMerchant !== 1;
      const bannerLists = shop.bannerLists;
      const { userPrizeInfo = {}, monthIn = {} } = home;
      const refreshing = effects['home/fetchBannerList'] || effects['home/unionIndexPieEarningsStatistics'];
      const { bigPrizeInfo = [], reaPackageWiners = [], prizeCount = 0 } = userPrizeInfo || {};

      const prizeText1 = bigPrizeInfo.map(item => `恭喜${item.winerName}抽中${item.prizeName}`);
      const prizeText2 = reaPackageWiners;

      const allRoleList = user.userRoleList || [];
      const showIatestRevenue = isAdmin === 1 ? true : allRoleList.includes('latestRevenue');
      const shouyiData = [
        {
          name: '平台收益分成', bg: require('../images/home/platform_bg.png'), value: monthIn.PLATFORM_EARN || 0, route: 'incomeIndex?type=PLATFORM_EARN&label=平台收益&nativeBack=yes',
        },
        {
          name: '销售收益分成', bg: require('../images/home/sale_bg.png'), value: monthIn.SALES || 0, route: 'incomeIndex?type=SALES&label=销售收益&nativeBack=yes',
        },
        {
          name: '推荐商品收益', bg: require('../images/home/tuijian.png'), value: monthIn.SOURCE_AWARD || 0, route: 'incomeIndex?type=SOURCE_AWARD&label=推荐商品收益&nativeBack=yes',
        },
        {
          name: '直播业务收益', bg: require('../images/home/zhibo.png'), value: monthIn.LIVE_EARNINGS || 0, route: 'incomeIndex?type=LIVE_EARNINGS&label=直播收益&nativeBack=yes',
        },
      ];

      // console.log("this.props.isFocused", this.props.isFocused)

      return (
        <View style={styles.container}>
          <View style={styles.headerView}>
            <Text style={styles.headerText}>晓可联盟</Text>
          </View>
          <ScrollView
            showsHorizontalScrollIndicator={false}
            showsVerticalScrollIndicator={false}
            // style={{marginTop:CommonStyles.headerPadding}}
            scrollEventThrottle={1}
            refreshControl={(
              <RefreshControl
                refreshing={refreshing}
                onRefresh={this._onRefresh}
              />
            )}
          >
            <View style={{
              width, height: 163, overflow: 'hidden', position: 'relative',
            }}
            >
              {
                bannerLists && Array.isArray(bannerLists) && bannerLists.length !== 0
                && (
                <CarouselSwiper
                    key={bannerLists.length}
                    style={styles.bannerView}
                    loop
                    autoplay
                    onPageChanged={(index) => {
                      // console.log('HomeIndex',index)
                      this.setState({ bannerIndex: index });
                    }}
                    index={0}
                    autoplayTimeout={5000}
                    showsPageIndicator
                    renderPageIndicator={config => (
                      <View style={styles.bannerDotView}>
                        {
                          bannerLists && Array.isArray(bannerLists) && bannerLists.map((item, index) => (
                            <View key={index} style={[styles.banner_dot, index == this.state.bannerIndex ? styles.banner_activeDot : null]} />
                          ))
                        }
                      </View>
                    )}
                >
                  {
                bannerLists.map((item, index) => {
                  const data = item.templateContent || [];
                  return (
                    <BannerImage
                      key={index}
                      navigation={navigation}
                      style={{ height: 163, backgroundColor: '#f1f1f1', width }}
                      data={data}
                    />
                  );
                })}
                </CarouselSwiper>
                ) || <View style={styles.bannerView} />
              }
              <View style={styles.bannerDotView}>
                {
                  bannerLists && Array.isArray(bannerLists) && bannerLists.map((item, index) => (
                    <View key={index} style={[styles.banner_dot, index == this.state.bannerIndex ? styles.banner_activeDot : null]} />
                  ))
                }
              </View>
            </View>
            <View style={{ backgroundColor: '#fff' }}>
              <ImageBackground style={styles.categoryView} resizeMode="stretch" fadeDuration={0} source={require('../images/home/in_bg.png')}>
                <View style={styles.categoryViewTop}>
                  {listData.length !== 0
                    && listData.map((item, index) => (
                      <IconButton
                        key={item.route}
                        source={item.icon}
                        size={31}
                        style={[CommonStyles.flex_center, { flexDirection: 'row' }]}
                        title={item.name}
                        titleStyle={styles.category_text}
                        onPress={() => this.handleListData(item, allRoleList)}
                      />
                    ))
                  }
                </View>
              </ImageBackground>
              <View>
                <TouchableOpacity
                  activeOpacity={0.7}
                  onPress={() => {
                    if (!checkoutRole('winning', allRoleList)) return;
                    checkAuditStatus(() => {
                      navigation.navigate('PrizeMessage');
                    });
                  }}
                >
                  <ImageBackground
                    fadeDuration={0}
                    resizeMode="stretch"
                    source={require('../images/home/zhongjiang_bg.png')}
                    style={styles.zhongjiangView}
                  >
                    <View style={styles.newMessage}>
                      <XKText fontFamily="Akrobat-Bold" style={{ fontSize: getwidth(8), color: '#fff' }}>{ prizeCount > 98 ? '99+' : prizeCount}</XKText>
                    </View>
                    <View style={[styles.zhongjiangenter, {
                      flexDirection: 'column', justifyContent: 'center', alignItems: 'center', position: 'relative',
                    }]}
                    >
                      <View style={{
                        position: 'absolute', opacity: 0.5, top: 0, height: getwidth(40), left: -getwidth(70), width: getwidth(100),
                      }}
                      />
                      {
                        reaPackageWiners.length === 0
                        || bigPrizeInfo.length === 0
                          ? <Text style={{ color: '#fff', fontSize: 13 }}>夺奖派对精品大奖等你来拿</Text>
                          : (
                            <React.Fragment>
                              <MarqueeLabel
                                wrapStyle={{ flex: 1, overflow: 'hidden' }}
                                speed={35}
                                bgViewStyle={styles.label}
                                textStyle={{ color: '#fff', fontSize: getwidth(13) }}
                              >
                                {prizeText1.join(',')}
                              </MarqueeLabel>
                              <MarqueeLabel
                                wrapStyle={{ flex: 1, overflow: 'hidden' }}
                                speed={35}
                                bgViewStyle={styles.label}
                                textStyle={{ color: '#fff', fontSize: getwidth(10) }}
                              >
                                {prizeText2.join(',')}
                              </MarqueeLabel>
                            </React.Fragment>
                          )
                      }
                    </View>
                  </ImageBackground>
                </TouchableOpacity>
                {
                  // 有权限才显示
                  (!showIatestRevenue)
                    ? null
                    : (
                      <View style={[styles.itemHeader]}>
                        <ListItem
                            title="本月新收益"
                            titleStyle={[styles.adTitle_text]}
                            style={[styles.itemHeaderTitle, { marginBottom: 10, paddingVertical: 0 }]}
                            extra={<Button style={{ height: 'auto' }} type="link" title="查看全部" titleStyle={styles.c9f14} onPress={() => this.handleToProfit(isNotAuditSuccess)} />}
                        />
                        <ScrollView
                            style={{
                              flex: 1, paddingLeft: 25, marginBottom: 25, height: 68, width,
                            }}
                            horizontal
                            showsHorizontalScrollIndicator={false}
                        >
                          {
                              shouyiData.map((item, index) => (
                                <TouchableOpacity
                                      key={item.bg}
                                      onPress={() => {
                                        checkAuditStatus(() => {
                                          navigation.navigate('Profit', { route: item.route });
                                        });
                                      }}
                                      style={{ width: 123, height: 68, marginRight: index == shouyiData.length - 1 ? 55 : 10 }}
                                >
                                  <ImageBackground style={{ flex: 1, justifyContent: 'center', paddingLeft: 10 }} source={item.bg}>
                                    <Text style={{
                                      color: '#fff', fontSize: 15, marginTop: 14, fontFamily: 'Akrobat-Bold',
                                    }}
                                    >
    ¥
                                      {formatPriceStr(item.value || 0)}
                                    </Text>
                                  </ImageBackground>
                                </TouchableOpacity>
                              ))
                            }
                        </ScrollView>
                      </View>
                    )
                }
              </View>
            </View>
            <View style={[styles.itemHeader, { backgroundColor: '#fff', paddingBottom: 10, marginVertical: 10 }]}>
              <View style={[styles.itemHeaderTitle, { marginBottom: 10 }]}>
                <Text style={[styles.adTitle_text]}>常用功能 </Text>
              </View>
              <View style={[styles.usualFun]}>
                {usualFunc.map((item, index) => (
                  <TouchableOpacity style={styles.funcItemView1} key={index} onPress={() => this.handleUsualFunc(item, isNotAuditSuccess, isAdmin, allRoleList)}>
                    <IconWithRedPoint test={item.test} style={styles.funcItemRedPoint}>
                      <Icon source={item.icon} size={30} title={item.name} subtitle={item.intro} titleStyle={styles.funcItemTitle} subtitleStyle={styles.funcItemSubTitle} />
                    </IconWithRedPoint>
                  </TouchableOpacity>
                ))}
              </View>
            </View>
          </ScrollView>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    position: 'relative',
  },
  headerView: {
    backgroundColor: '#fff',
    width,
    height: CommonStyles.headerPadding + 44,
    paddingTop: CommonStyles.headerPadding,
    justifyContent: 'center',
    // paddingBottom:15,
    // position:'absolute',
    // zIndex:2,

    // top:0,
    // left:0,
    borderBottomColor: 'rgba(0,0,0,0.08)',
    borderBottomWidth: 1,
  },
  headerText: {
    fontSize: 17,
    color: '#27344C',
    marginLeft: 0,
    fontWeight: '500',
    width,
    textAlign: 'center',
    height: 44,
    textAlignVertical: 'center',
    lineHeight: 44,
  },
  headerStyle: {
    // backgroundColor: "#fff",
  },
  label: {
    //  flex: 1,
    width: getwidth(132),
    marginLeft: getwidth(12),
  },
  bannerDotView: {
    position: 'absolute',
    bottom: 25,
    left: 25,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  activeDot: {
    backgroundColor: '#fff',
    width: 16,
    height: 16,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 16,
  },
  activeDotBack: {
    width: 36 * 1.2,
    height: 16 * 1.2,
    alignItems: 'center',
    justifyContent: 'space-between',
    position: 'absolute',
    bottom: 30,
    left: 25,
    flexDirection: 'row',
  },
  activeDotText: {
    width: 16 * 1.2,
    height: 16 * 1.2,
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    fontSize: 10,
  },
  titleTextStyle: {
    color: '#fff',
    fontSize: 17,
    fontFamily: 'PingFangSC-Medium',
  },
  shoyYiText: {
    color: '#fff',
    fontSize: 12,
  },
  slider: {
    overflow: 'hidden', // for custom animations,
    borderRadius: 6,
    // backgroundColor: "blue"
  },
  sliderContentContainer: {
    // paddingVertical: 0 // for custom animation
  },
  adTitle_text: {
    color: '#27344B',
    fontSize: 17,
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
  bannerView: {
    height: 150,
    backgroundColor: '#f1f1f1',
    position: 'relative',
  },
  banner_dot: {
    width: 6,
    height: 6,
    borderRadius: 6,
    marginRight: 4,
    backgroundColor: '#fff',
    opacity: 0.6,
  },
  banner_activeDot: {
    width: 14,
    opacity: 1,
  },
  categoryView: {
    // ...CommonStyles.shadowStyle,
    width: width - 30,
    height: 82,
    // borderRadius: 6,
    marginTop: -20,
    marginLeft: 15,
    marginBottom: 3,
    // backgroundColor: '#fff',
  },
  categoryViewTop: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    width: width - 30,
    height: 66,
  },
  category_text: {
    fontSize: 13,
    color: '#000000',
    marginLeft: 5,
  },
  itemHeader: {
    // backgroundColor:'#fff',
    paddingTop: 25,
  },
  itemHeaderCol: {
    paddingBottom: 13,
  },
  itemHeader_text: {
    fontSize: 17,
    color: '#222',
  },
  headerRight_icon: {
    width: 50,
  },
  itemHeaderTitle: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 25,
  },
  itemHeaderTitle_line: {
    width: 15,
    height: 2,
    borderRadius: 6,
    backgroundColor: '#4A90FA',
  },

  content: {
    width,
    marginLeft: getwidth(10),
    marginVertical: 10,
  },
  zhongjiangView: {
    width: width - getwidth(30),
    marginLeft: getwidth(15),
    height: getwidth(80),
    position: 'relative',
  },
  zhongjiangContent: {
    width: getwidth(100),
    height: getwidth(42),
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: getwidth(10),
    marginTop: getwidth(3),
  },
  zhongjiangenter: {
    // marginLeft: getwidth(80),
    width: (width * 55) / 100,
    marginLeft: getwidth(83),
    // width: (width * 36) / 100,
    height: getwidth(32),
    marginTop: getwidth(30),
  },
  hurry: {
    backgroundColor: 'white',
    width: getwidth(30),
    height: getwidth(30),
    borderRadius: getwidth(30),
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  newMessage: {
    position: 'absolute',
    top: getwidth(23.5),
    right: getwidth(8),
    width: getwidth(21),
    height: getwidth(12),
    alignItems: 'center',
    justifyContent: 'center',
    // backgroundColor:'blue'
  },
  shouyiView: {
    width: '100%',
    height: 50,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 11,
    marginTop: 14,
  },
  usualFun: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    width,
    paddingHorizontal: 10,
  },
  funcItemView1: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 100,
    width: (width - 20) / 3,
  },
  funcItemRedPoint: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 100,
  },
  noBottomBorder: {
    borderBottomWidth: 0,
  },
  funcItem: {
    width: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    height: 60,
    borderColor: '#F1F1F1',
  },
  funcItemTitle: {
    marginTop: 10,
    fontSize: 15,
    color: '#27344C',
  },
  funcItemSubTitle: {
    marginTop: 6,
    fontSize: 12,
    color: '#999999',
  },
  c9f14: {
    color: '#999',
    fontSize: 14,
  },
});

export default connect(
  state => ({
    user: state.user,
    home: state.home,
    shop: state.shop,
    effects: state.loading.effects,
    isFocused: state.nav.routes.length === 1 && state.nav.routes[0].index === 0,
  }),
  {
    fetchHomeData: () => ({ type: 'home/fetchHomeData' }),
    fetchJprizeUserPrizeData: () => ({ type: 'home/jprizeUserPrize' }),
    checkAuditStatus: callback => ({ type: 'user/check', payload: { callback } }),
  },
)(HomeScreen);
