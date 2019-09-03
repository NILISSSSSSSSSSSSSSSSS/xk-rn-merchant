import React, { Component, PureComponent } from 'react';
import {
  StatusBar,
  Platform,
  Dimensions,
  StyleSheet,
  View,
  KeyboardAvoidingView,
  NativeModules,
  NativeEventEmitter, // 导入NativeEventEmitter模块
} from 'react-native';

import createRoute from './Routes';
import navigatorService from './common/NavigatorService';
import Toast from './components/Toast';
import CustomAlert from './components/CustomAlert';
import RightTopModal from './components/RightTopModal';
import Loading from './components/Loading';
import BackTwiceExitApp from './components/BackTwiceExitApp';
import CommonStyles from './common/Styles';
import config from '../android/app/src/main/assets/requestConfig.json';
import UpdateComModal from './components/UpdateComModal';

const { width, height } = Dimensions.get('window');

// // 在正式环境中替换掉console
if (!__DEV__ || config.enableLogger !== '1') {
  global.console = {
    info: () => { },
    log: () => { },
    warn: () => { },
    debug: () => { },
    error: () => { },
  };
}

class RootView extends Component {
  constructor(props) {
    super(props);
    StatusBar.setTranslucent(true);
    StatusBar.setBackgroundColor('transparent');
    StatusBar.setNetworkActivityIndicatorVisible(true);
    StatusBar.setBarStyle('light-content');
  }

  componentWillMount() {
    StatusBar.setTranslucent(true);
    StatusBar.setBackgroundColor('transparent');
    StatusBar.setNetworkActivityIndicatorVisible(true);
    StatusBar.setBarStyle('light-content');
  }

  render() {
    return (
      <View style={styles.container}>
        <StatusBar showHideTransition="fade" animated />
        <View style={styles.container}>
          {this.props.children}
        </View>
      </View>
    );
  }
}
const renderView = (initPage, props) => {
  const Routes = createRoute(initPage, props);
  if (initPage) {
    global.nativeProps = props || {};
  }
  return (
    <RootView>
      {Routes}
      <Toast
        ref={(e) => {
          e && (global.Toast = e);
          this.toast = e;
        }}
        position="center"
      />
      <Loading
        ref={(e) => {
          e && (global.Loading = e);
        }}
      />
      <CustomAlert
        ref={(e) => {
          e && (global.CustomAlert = e);
        }}
      />
      <RightTopModal
        ref={(e) => {
          e && (global.RightTopModal = e);
        }}
      />

      <BackTwiceExitApp />
      <UpdateComModal />
    </RootView>
  );
};

export class App extends Component {
  render() {
    return renderView();
  }
}

export class AppSOM extends Component {
  render() {
    console.log('render', this.props);
    return renderView('SOMGoodsDetail', { ...this.props, isOtherApp: true });
  }
}
export class AppWM extends Component {
  render() {
    console.log('renderWMGoodsDetail', this.props);
    return renderView('WMGoodsDetail', { ...this.props, isOtherApp: true });
  }
}

export class AppProfile extends Component {
  render() {
    console.log('renderProfile', this.props);
    return renderView('Profile', { ...this.props, isOtherApp: true });
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    width,
  },
});
