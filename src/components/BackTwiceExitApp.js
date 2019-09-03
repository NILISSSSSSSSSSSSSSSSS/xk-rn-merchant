/**
 * Android 返回
 */
import React, { Component, PureComponent } from 'react';
import {
  BackHandler,
} from 'react-native';

import { connect } from 'rn-dva';

class BackTwiceExitApp extends Component {
  componentDidMount() {
    BackHandler.addEventListener('hardwareBackPress', this.handleBackPress);
  }

  componentWillUnmount() {
    BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress);
  }

    handleBackPress = () => {
      Loading.hide();
      const { nav, back } = this.props;
      const index = nav.index;
      if (index === 0 && this.lastBackPressed && (this.lastBackPressed + 2000) >= Date.now()) {
        // 最近2秒内按过back键，可以退出应用。
        BackHandler.exitApp();
        return false;
      } if (index !== 0) {
        back();
        return true;
      }

      this.lastBackPressed = Date.now();
      Toast.show('再按一次退出应用', 2000);
      return true;
    }

    render() {
      return null;
    }
}


export default connect(state => ({
  nav: state.nav,
}), {
  back: () => ({ type: 'system/back' }),
})(BackTwiceExitApp);
