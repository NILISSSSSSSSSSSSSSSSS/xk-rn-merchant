/**
 * 首页/中奖信息
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  TouchableOpacity,
  Image,
  StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';

import config from '../../config/config';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import WebViewCpt from '../../components/WebViewCpt';
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');

class PrizeMessageScreen extends Component {
    static navigationOptions = {
      header: null,
    };
    webViewRef = null;
    _didFocusSubscription;
  ;
  constructor(props) {
    super(props);
    this._didFocusSubscription = props.navigation.addListener('willFocus', (payload) => {
      this.screenDidFocus();
    });
      this.state = {
        canGoBack: false,
      };
    }
    screenDidFocus = (payload) => {
      StatusBar.setBarStyle('dark-content');
      const { refreshPrizeMessage, dispatch } = this.props;
      console.log('refreshPrizeMessage', refreshPrizeMessage)
      if (refreshPrizeMessage) {
        this.postMessage();
        // this.webViewRef.reload();
        dispatch({ type: 'welfare/save', payload: { refreshPrizeMessage: false } });
      }
    }

    screenWillBlur = (payload) => {
      // StatusBar.popStackEntry(this.entry);
      StatusBar.setBarStyle('light-content');
    }

    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    postMessage = () => {
      console.log('send');
      let run = `
      setTimeout(() => {
          window.reloadLotteryCount()
        }, 1000);
      `
      this.webViewRef.injectJavaScript(run);
    };

    goBack = () => {
      const { navigation } = this.props;
      const { canGoBack } = this.state;

      if (canGoBack) {
        this.webViewRef.goBack();
      } else {
        navigation.goBack();
      }
    };

    componentDidMount() {
      // 第一次监听失效
      this.props.navigation.navigate('PrizeMessage')
    }
    componentWillUnmount() {
      Loading.hide();
      this._didFocusSubscription && this._didFocusSubscription.remove();
    }

    render() {
      const { navigation } = this.props;
      const _baseUrl = `${config.baseUrl_h5}lotteryIndex`;
      const _url = `${_baseUrl}?id=111`;
      // let _url = `http://192.168.2.115:8083/#/lotteryIndex?id=111`; // 本地测试地址
      console.log(_url);
      const source = {
        uri: _url,
        showLoading: true,
        headers: { 'Cache-Control': 'no-cache' },
      };
      return (
        <View style={styles.container}>
          <Header
          navigation={navigation}
          goBack
          title="中奖公告"
          headerStyle={{ backgroundColor: '#fff' }}
          titleTextStyle={{ color: '#222' }}
          leftView={(
            <View>
              <TouchableOpacity
                      style={[styles.headerItem, styles.left]}
                      onPress={() => {
                        navigation.goBack();
                      }}
              >
                <Image source={require('../../images/mall/gobackblack.png')} />
              </TouchableOpacity>
            </View>
          )}
          />
          <WebViewCpt
          webViewRef={(e) => {
            this.webViewRef = e;
          }}
          isNeedUrlParams
          source={source}
          // postMessage={() => {
          //   this.postMessage();
          // }}
          getMessage={(data) => {
            console.log(data);
            const params = data && data.split(',');
            if (params[0] === 'jsOpenAppShoppingCart') {
              this.jsOpenAppShoppingCart(params);
            } else if (params[0] === 'jsHiddenXKHUDView') {
              Loading.hide();
            } else if (params[0] === 'jsOpenMyPrize') {
              console.log(data);
              // 跳转到我的大奖
              navigation.navigate('WMMyprize');
            } else if (params[0] === 'jsOpenRecentLottery') {
              console.log(data);
              // 跳转到最新揭晓
              navigation.navigate('WMAllLatelyPrize');
            } else if (params[0] === 'jsOpenStorePrize') {
              console.log(data);
              // 跳转到店铺大奖
              // navigation.navigate('WMShopPrize');
            } else if (params[0] === 'jsOpenMyPrizeCoupon') {
              console.log(data);
              // 跳转到我的奖券
              navigation.navigate('WMMyLottery');
            } else if (params[0] === 'goToLotteryActivity') {
              // 跳转到抽奖转盘页面
              navigation.navigate('WMLotteryActivity');

              // this.setState({
              //     needReload: true
              // }, () => {
              //     navigation.navigate('WMLotteryActivity')
              // })
            } else if (params[0] === 'jsOpenMyPrizeRecord') {
              // 跳转到我的中奖记录
              navigation.navigate('WMMyPrizeRecord');
            } else if (params[0] === 'jsOpenShowPrizeOrder') {
              // 跳转到大奖晒单
              navigation.navigate('BigPrizeOrder');
            } else {
              console.log(params);
            }
          }}
          navigationChange={(canGoBack) => {
            // this.changeState('canGoBack', canGoBack);
          }}
          />
          {/* <Header 5c99cd480334554d7736c8d9  5c99cd750334554d7736c8db
                    navigation={navigation}
                    headerStyle={styles.headerStyle}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.goBack();
                            }}
                        >
                            <Image
                                source={require("../../images/mall/goback_gray.png")}
                            />
                        </TouchableOpacity>
                    }
                /> */}
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  headerStyle: {
    position: 'absolute',
    top: CommonStyles.headerPadding,
    height: 44,
    paddingTop: 0,
    backgroundColor: 'transparent',
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    width: 50,
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    // position: 'absolute'
  },
  left: {
    width: 50,
  },
});
export default connect(
  state => ({
    refreshPrizeMessage: state.welfare.refreshPrizeMessage, // true 刷新
  }),
  dispatch => ({ dispatch }),
)(PrizeMessageScreen);
