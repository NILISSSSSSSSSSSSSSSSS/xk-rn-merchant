/**
 * app引导页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  ScrollView,
  TouchableOpacity,
  BackHandler,
  TouchableHighlight,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import DeviceInfo from 'react-native-device-info';
import { StackActions, NavigationActions } from 'react-navigation';
import Swiper from 'react-native-swiper';
import * as requestApi from '../config/requestApi';
import CommonStyles from '../common/Styles';

const { width, height } = Dimensions.get('window');
const introImg = [
  {
    src: require('../images/intro/appIntro_01.png'),
  },
  {
    src: require('../images/intro/appIntro_02.png'),
  },
  {
    src: require('../images/intro/appIntro_03.png'),
  },
];
const createResetAction = (routeName, params) => StackActions.reset({
  index: 0,
  actions: [NavigationActions.navigate({ routeName, params })],
});
class AppIntroScreen extends Component {
    static navigationOptions = {
      header: null,
      gesturesEnabled: false, // 禁用ios左滑返回
    };

    constructor(props) {
      super(props);
      this.state = {
        showBtn: false,
      };
    }

    componentDidMount = () => {
      setTimeout(() => {
        SplashScreen.hide();
      }, 100);
      BackHandler.addEventListener('hardwareBackPress', this.handleBackPress);
    };

    componentWillUnmount() {
      BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress);
    }

    // 自定义物理返回键
    handleBackPress = () => {
      if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
        // 最近2秒内按过back键，可以退出应用。
        BackHandler.exitApp();
        return false;
      }
      this.lastBackPressed = Date.now();
      Toast.show('再按一次退出应用', 2000);
      return true;
    }

    handleGoToHome = () => {
      const version = DeviceInfo.getVersion();
      requestApi.storageAppIntroStatus('save', { openStatus: true, version });
      // this.props.navigation.navigate("Login");
      this.props.navigation.dispatch(createResetAction('Login', { pageFrom: 'AppIntroScreen' }));
    }

    _renderJumpBtn = () => (
      <TouchableOpacity testID="introGoTo" activeOpacity={0.35} onPress={() => { this.handleGoToHome(); }} style={[styles.jumpBtnWrap, CommonStyles.flex_center]}>
        <Text style={styles.jumpText}>跳过</Text>
      </TouchableOpacity>
    )

    render() {
      const { navigation, store } = this.props;
      const { showBtn } = this.state;
      return (
        <View style={styles.container} testID="appIntroScreen">
          {
                    (showBtn)
                      ? (
                        <View style={styles.btnWrap} onPress={this.handleGoToHome}>
                          <TouchableOpacity activeOpacity={0.8} onPress={this.handleGoToHome}>
                            <Image fadeDuration={0} source={require('../images/intro/introGoTo.png')} />
                          </TouchableOpacity>
                        </View>
                      )
                      : null
                }
          {
            this._renderJumpBtn()
          }
          <Swiper
            style={styles.bannerView}
            autoplay={false}
            dotStyle={styles.banner_dot}
            loop={false}
            index={0}
            activeDotStyle={styles.banner_activeDot}
            onMomentumScrollEnd={(a, b, c) => {
              if (b.index === introImg.length - 1) {
                this.setState({
                  showBtn: true,
                });
              } else {
                this.setState({
                  showBtn: false,
                });
              }
            }}
          >
            {
              introImg.map((item, index) => (
                <TouchableOpacity
                  key={item.src}
                  style={[styles.bigImage, { position: 'relative' }]}
                  activeOpacity={1}
                >
                  <Image fadeDuration={0} source={item.src} style={{ width: '100%', height: '100%' }} />
                </TouchableOpacity>
              ))
            }
          </Swiper>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    position: 'relative',
    flex: 1,
    backgroundColor: '#fff',
    ...CommonStyles.containerWithoutPadding,
  },
  bannerView: {
    backgroundColor: '#fff',
    position: 'relative',
  },
  btnWrap: {
    // backgroundColor: 'rgba(10,10,10,.5)',
    position: 'absolute',
    bottom: 50,
    left: 0,
    width,
    // paddingVertical: 10,
    ...CommonStyles.flex_center,
    zIndex: 1,
  },
  btn: {
    // backgroundColor: '#fff',
    paddingVertical: 8,
    paddingHorizontal: 31,
    borderRadius: 40,
    // color: 'rgba(10,10,10,0)'
  },
  bigImage: {
    // backgroundColor: "rgba(0, 0, 0, 1)",
    width: '100%',
    height: '100%',
    backgroundColor: '#fff',
    // justifyContent: "center",
    // alignItems: "center",
    position: 'relative',
  },
  banner_activeDot: {
    width: 8,
    height: 8,
    borderRadius: 8,
    marginHorizontal: 28,
    // marginBottom: -20,
    backgroundColor: '#3077e2',
  },
  banner_dot: {
    width: 8,
    height: 8,
    borderRadius: 8,
    marginHorizontal: 28,
    // marginBottom: -20,
    backgroundColor: '#d5dfef',
  },
  introGo: {
    fontSize: 12,
    position: 'absolute',
    right: 20,
    bottom: 40,
    paddingHorizontal: 10,
    paddingVertical: 5,
    color: CommonStyles.globalHeaderColor,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    borderRadius: 40,
  },
  jumpBtnWrap: {
    width: 50,
    height: 28,
    position: 'absolute',
    top: 25 + CommonStyles.headerPadding,
    right: 25,
    // backgroundColor:'rgba(0,0,0,0.10)',
    borderRadius: 14,
    zIndex: 10,
    opacity: 0.45,
  },
  jumpText: {
    color: '#6C6E85',
    fontSize: 14,
    textAlign: 'center',
  },
});

export default connect(
  state => ({ store: state }),
)(AppIntroScreen);
