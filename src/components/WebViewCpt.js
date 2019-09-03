/**
 * 商城搜索结果页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet, Dimensions, Platform, StatusBar,
} from 'react-native';
import WebView from 'react-native-webview';
import { ReLogin } from '../config/request';

const { width, height } = Dimensions.get('window');

// 拼接链接
const _addSource = (source) => {
  let info = {
    os: Platform.OS, // 操作系统
    clientVersion: '1.0', // 版本号
    mobileType: 'mobile', // 手机型号
    guid: global.uniqueIdentifier || '000', // 设备编号
    channel: 'App Store', // 渠道
    token: (global.loginInfo && global.loginInfo.token) || '',
    userId: (global.loginInfo && global.loginInfo.userId) || '',
    merchantId: (global.loginInfo && global.loginInfo.merchantId) || '',
  };
  info = encodeURIComponent(JSON.stringify(info));
  // // 判断地址有没有参数，如果有,使用&拼接，没有使用,?
  if (source.uri.indexOf('?') !== -1) {
    source.uri = `${encodeURI(source.uri)}&client=sh&info=${info}`;
  } else {
    source.uri = `${source.uri}?client=sh&info=${info}`;
  }
  // 判断是否加入了安全码，如果没有加入则加入
  if (source.uri.indexOf('securityCode') === -1 && global.loginInfo && global.loginInfo.securityCode) {
    console.log('加入了安全码', source.uri);
    source.uri = `${source.uri}&securityCode=${global.loginInfo.securityCode}`;
  }
  return source;
};

export default class WebViewCpt extends Component {
    timer = null

    constructor(props) {
      super(props);
      this.state = {
        isNeedUrlParams: props.isNeedUrlParams || false,
        source: _addSource(JSON.parse(JSON.stringify(props.source))),
        propSource: props.source,
      };
    }

    componentDidMount() {
      // console.log('+++++loin++++++',global.loginInfo)
      const { source } = this.props;
      if (source.showLoading) {
        global.Loading && Loading.show();
      }
      this.timer = setTimeout(() => {
        global.Loading && Loading.hide();
      }, 10000);
    }

    static getDerivedStateFromProps(nextProps, prevState) {
      if (nextProps.source !== prevState.propSource) {
        return {
          source: _addSource(JSON.parse(JSON.stringify(nextProps.source))),
          propSource: nextProps.source,
        };
      }
      return null;
    }

    componentWillUnmount() {
      global.Loading && Loading.hide();
      this.timer && clearTimeout(this.timer);
      StatusBar.setHidden(false, true);
    }

    postMessage(func, ...args) {
      let strArgs = JSON.stringify(args);
      console.log(func, strArgs);
      const run = `
        window.${func} && window.${func}.apply(window, ${strArgs});
      `;
      if (this.webViewRef) {
        this.webViewRef.injectJavaScript && this.webViewRef.injectJavaScript(run);
      }
    }

    goBack = ()=> {
      if (this.webViewRef) {
        this.webViewRef.goBack();
      }
    }

    render() {
      const {
        webViewRef,
        postMessage,
        getMessage,
        navigationChange,
      } = this.props;

      if (this.state.source.uri === '') {return;}
      console.log('this.state.source', this.state.source);

      const INJECTED_JAVASCRIPT = `(function() {
          window.postMessage = function (__data) {
            window.ReactNativeWebView.postMessage(encodeURIComponent(__data));
          };
      })();`;

      return (
        <WebView
          ref={(dom)=> {
            webViewRef && webViewRef(dom);
            this.webViewRef = dom;
          }}
          bounces={false}
          allowsInlineMediaPlayback
          mediaPlaybackRequiresUserAction={false}
          injectedJavaScript={INJECTED_JAVASCRIPT}
          source={this.state.source}
          onLoadStart={() => {
            //
          }}
          geolocationEnabled
          mixedContentMode="always"
          onLoadEnd={() => {
            global.Loading && global.Loading.hide();
            // 给html发送事件（必须是数组或字符串）
            // let data = [];
            // data.push('from react-native to html');
            // data.push('999');
            // // console.log('这是RN发送到html的消息: ');
            // // console.log(data);
            // this.webViewRef.postMessage(data);

            // html 监听RN webview传递过来的数据
            // document.addEventListener('message', function (e) {
            //     let data = e.data;
            //     // console.log(data);
            // });
            postMessage && postMessage();
          }}
          onMessage={(event) => {
            // 监听html发送过来的数据
            // html给RN的webview发送数据或事件
            // window.postMessage('from html to react-native');
            // window.postMessage(alert('...'));
            const data = event.nativeEvent.data;
            let _data = decodeURIComponent(data);
            let params = _data && _data.split(',');
            console.log('html 发送的信息',_data);
            if (params[0] === 'relogin') { // 重新登录
              ReLogin(false);
              return;
            }
            getMessage && getMessage(decodeURIComponent(data));
          }}
          onNavigationStateChange={(event) => {
            // 监听html导航状态变化
            navigationChange && navigationChange(event.canGoBack);
          }}
        />
      );
    }
}

const styles = StyleSheet.create({});
