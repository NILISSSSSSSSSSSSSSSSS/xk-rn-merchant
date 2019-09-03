/**
 * 登录
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  
  View,
  Text,
  Linking,
  Image,
  ScrollView,
  TouchableOpacity,
  Keyboard,
  Platform,
  StatusBar,
  BackHandler,
  KeyboardAvoidingView,
  ImageBackground,
} from 'react-native';
import { connect } from 'rn-dva';
import JPushModule from 'jpush-react-native';
import SplashScreen from 'react-native-splash-screen';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as regular from '../../config/regular';
import TextInputView from '../../components/TextInputView';
import * as nativeApi from '../../config/nativeApi';
import Environment from '../../components/Environment';

const mainbg = require('../../images/user/mainbg.png');
const button = require('../../images/user/button.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

class LoginScreen extends PureComponent {
  static navigationOptions = {
    header: null,
    gesturesEnabled: false,
  };

  constructor(props) {
    super(props);
    this.state = {
      _goBack:
        (props.navigation.state.params
          && props.navigation.state.params._goBack)
        || false, // 登录后是否返回上一页
      phone: props.userInfo.phone || '',
      password: props.userInfo.password || '',
      phoneFocus: false, // 手机号输入框是否有焦点
      passwordFocus: false,
      passwordVisible: false, // 密码是否隐藏
    };
  }

  componentDidMount() {
    BackHandler.addEventListener('hardwareBackPress', this.handleBackPress);
    this.props.navigation.state.params && this.props.navigation.state.params.reLogin
      ? CustomAlert.onShow(
        'alert',
        this.props.navigation.state.params.reLogin.message,
        '登录已失效',
      ) : null;

    // if (global.loginInfo && global.loginInfo.userId) {
    //   requestApi.xkUserLogout().then(() => { });
    // }
    this.props.systemSave({ doLogin: false });
    nativeApi.loginOut(this.props.userInfo);
    console.log('取消监听推送');
    JPushModule.clearAllNotifications();

    setTimeout(() => {
      StatusBar.setTranslucent(true);
      Platform.OS === 'ios' ? StatusBar.setNetworkActivityIndicatorVisible(true) : null;
      StatusBar.setBackgroundColor('transparent');
      StatusBar.setBarStyle('dark-content');
      SplashScreen.hide();
    }, 100);
  }

  // 自定义物理返回
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

  changeState(key, value) {
    this.setState({
      [key]: value,
    });
  }

  _loginClick = () => {
    // throw "这个是测试错误"
    // return
    Keyboard.dismiss();
    const { _goBack, phone, password } = this.state;

    if (phone.trim() === '' || password.trim() === '') {
      Toast.show('请输入手机号或密码');
      phone.trim() === '' && this.changeState('phone', '');
      password.trim() === '' && this.changeState('password', '');
      return;
    }
    if (!regular.phone(phone)) {
      Toast.show('请输入正确的手机号');
      return;
    }
    Loading.show();
    this.props.login({ phone, password });
  };

  componentWillUnmount() {
    BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress);
    Keyboard.dismiss();
  }

  renderInput = item => (
    <TextInputView
      inputView={styles.inputView}
      inputRef={(e) => { this[`${item.key}Input`] = e; }}
      style={styles.textInput}
      value={this.state[item.key]}
      maxLength={item.maxLength}
      keyboardType={item.keyboardType}
      placeholder={item.placeholder}
      secureTextEntry={item.key == 'password' && !this.state.passwordVisible}
      placeholderTextColor="#ccc"
      onSubmitEditing={(e) => {
        item.getKey(e);
      }}
      onChangeText={(text) => {
        this.changeState(item.key, text);
      }}
      onBlur={() => {
        this.changeState(`${item.key}Focus`, false);
      }}
      onFocus={() => {
        this.changeState(`${item.key}Focus`, true);
      }}
      leftIcon={(
        <View style={styles.IconView}>
          <Image source={item.leftIcon} />
        </View>
      )}
      rightIcon={item.key == 'password'
        && (
          <TouchableOpacity
            activeOpacity={1}
            style={[styles.IconView, styles.rightView]}
            onPress={() => {
              this.changeState('passwordVisible', !this.state.passwordVisible);
            }}
          >
            {
              this.state.passwordVisible
                ? <Image source={require('../../images/user/password_visible.png')} />
                : <Image source={require('../../images/user/password_novisible.png')} />
            }
          </TouchableOpacity>
        )
      }
    />
  )

  render() {
    const { navigation } = this.props;
    const {
      phoneFocus,
      passwordFocus,
    } = this.state;
    const inputItem = [
      {
        key: 'phone',
        getKey: (e) => {
          if (e.nativeEvent.text && e.nativeEvent.text.length == 11) {
            this.phoneInput.blur();
            this.passwordInput.focus();
          }
        },
        leftIcon: require('../../images/user/phone_gray.png'),
        keyboardType: 'numeric',
        maxLength: 11,
        placeholder: '请输入手机号',
      },
      {
        key: 'password',
        leftIcon: require('../../images/user/password_gray.png'),
        placeholder: '请输入密码',
        getKey: (e) => {
          this.passwordInput.blur();
          this._loginClick();
        },
      },
    ];
    return (
      <ImageBackground
        source={mainbg}
        style={styles.mainbgsty}
        resizeMode="cover"
      >
        <TouchableOpacity
          activeOpacity={1}
          style={styles.mainbgsty}
          onPress={() => {
            phoneFocus && this.phoneInput.blur();
            passwordFocus && this.passwordInput.blur();
            this.setState({
              phoneFocus: false,
              passwordFocus: false,
            });
          }}
        >
          <StatusBar barStyle="dark-content" />
          <KeyboardAvoidingView behavior="position" enabled>
            <ScrollView testID="loginScreen" showsVerticalScrollIndicator={false}>
              <View style={{ marginTop: getwidth(136 + CommonStyles.headerPadding), width: getwidth(315), alignSelf: 'center' }}>
                <Image
                  source={require('../../images/user/loginLogo.png')}
                  style={{ marginLeft: getwidth(10), marginBottom: getwidth(60), width: getwidth(173), height: getwidth(56) }}
                />
                {
                  inputItem.map((item, index) => {
                    const isFocus = this.state[`${item.key}Focus`];
                    const focusStyle = {
                      width: getwidth(295),
                      height: getwidth(60),
                      marginTop: getwidth(10),
                      marginBottom: getwidth(10),
                    };
                    return (
                      <ImageBackground
                        style={[styles.inputBack, item.style, isFocus && focusStyle]}
                        resizeMode="stretch"
                        source={isFocus ? require('../../images/user/input_view_border.png') : require('../../images/user/input_view.png')}
                        key={index}
                      >
                        {this.renderInput(item)}
                      </ImageBackground>
                    );
                  })
                }
              </View>
            </ScrollView>
          </KeyboardAvoidingView >
          <View style={{ paddingRight: (width - getwidth(315)) / 2 + getwidth(10) }}>
            <View style={styles.pwdView}>
              <TouchableOpacity
                style={styles.pwdItem}
                onPress={() => navigation.navigate('ForgetPassWord')}
              >
                <Text style={styles.pwd_title}>忘记密码？</Text>
              </TouchableOpacity>
            </View>
            <TouchableOpacity
              style={styles.loginBut}
              onPress={() => this._loginClick()}
            >
              <Image source={button} style={styles.loginImage} />
            </TouchableOpacity>
          </View>
          <View style={styles.registerBtn}>
            <Text style={styles.register_text1}>还没有入驻联盟？</Text>
            <TouchableOpacity
              style={{ marginTop: 10 }}
              onPress={() => navigation.navigate('Register')}
            >
              <Text style={styles.register_text2}>立即入驻</Text>
            </TouchableOpacity>
          </View>
          <Environment />
        </TouchableOpacity>
      </ImageBackground>
    );
  }
}

const styles = StyleSheet.create({
  mainbgsty: {
    width,
    height,
  },
  scrollstyle: {
    flex: 1,
  },
  inputBack: {
    width: '100%',
    height: getwidth(80),
    alignSelf: 'center',
    justifyContent: 'center',
    alignItems: 'center',
  },
  inputView: {
    flexDirection: 'row',
    width: getwidth(293),
    backgroundColor: 'rgba(0,0,0,0)',
    height: getwidth(58),
    borderRadius: 4,
    overflow: 'hidden',
  },
  textInput: {
    flex: 1,
    height: '100%',
    paddingVertical: 0,
    fontSize: 14,
    color: '#27344C',
    backgroundColor: '#fff',

  },
  IconView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    width: 57,
    backgroundColor: '#fff',
  },
  imageView: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 66,
    height: '100%',
  },
  leftLine: {
    width: 2,
    height: 24,
    borderRadius: 100,
    backgroundColor: '#ccc',
  },
  rightView: {
    width: 60,
  },
  pwdView: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    width: '100%',
    height: 39,
  },
  pwdItem: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    height: '100%',
  },
  pwd_title: {
    fontSize: 13,
    color: '#008FFF',
  },
  register_text1: {
    fontSize: 14,
    color: '#999',
  },
  registerBtn: {
    width,
    position: 'absolute',
    bottom: getwidth(25 + CommonStyles.footerPadding),
    alignItems: 'center',
  },
  register_text2: {
    fontSize: 14,
    color: '#4A90FA',
  },
  loginBut: {
    marginTop: getwidth(27),
    alignSelf: 'flex-end',
    position: 'relative',
    width: getwidth(83),
    height: getwidth(83),
  },
  loginImage: {
    top: 0,
    position: 'absolute',
    left: getwidth(6),
    width: getwidth(83),
    height: getwidth(83),
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
  }),
  {
    systemSave: (payload = {}) => ({ type: 'system/save', payload }),
    login: (payload = {}) => ({ type: 'user/login', payload }),
  },
)(LoginScreen);
