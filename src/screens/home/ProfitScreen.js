/**
 * webview页面
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  BackHandler,
  StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';
import { ReLogin } from '../../config/request';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import config from '../../config/config';
import * as nativeApi from '../../config/nativeApi';
import ActionSheet from '../../components/Actionsheet';
import { qiniuUrlAdd } from '../../config/utils';
import ShowBigPicModal from '../../components/ShowBigPicModal';

import FlatListView from '../../components/FlatListView';
import WebViewCpt from '../../components/WebViewCpt';
import { NavigationComponent } from '../../common/NavigationComponent';
import {
  TakeOrPickParams, TakeTypeEnum, PickTypeEnum, TakeOrPickCropEnum,
} from '../../const/application';


const { width, height } = Dimensions.get('window');

class ProfitScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    }

    ActionSheet = null;

    constructor(props) {
      super(props);
      this.state = {
        options: ['拍照', '从手机相册选择', '取消'], // 弹窗操作项
        maxImgLen: 1, // 上传的内容 长度
        imgsLists: [], // 上传的图片
        showBigPicVisible: false, // 查看大图
        canGoBack: false,
      };
    }

    blurState = {
      showBigPicVisible: false, // 查看大图
    }

    screenDidFocus = (payload) => {
      super.screenDidFocus(payload);
      BackHandler.addEventListener('hardwareBackPress', this.handleHardwareBackPress);
    }

    screenWillBlur = (payload) => {
      super.screenWillBlur(payload);
      BackHandler.removeEventListener('hardwareBackPress', this.handleHardwareBackPress);
      console.log('ProfitScreen:screenWillBlur');
    }

    componentDidMount() {
      Loading.show();
    }

    handleHardwareBackPress = () => {
      console.log('ProfitScreen:handleHardwareBackPress', this.props.navigation.isFocused());
      return this.goBack();
    }

    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    postMessage = (type = 'eventType', res = []) => {
      this.webViewRef.postMessage('uploadEvent', res);
    }

    goBack = () => {
      console.log('ProfitScreen:goBack');
      const { canGoBack } = this.state;

      if (canGoBack) {
        this.webViewRef.goBack();
        return true;
      }
      return false;
    }

    componentWillUnmount() {
      super.componentWillUnmount();
      Loading.hide();
    }

    // 显示上传图片弹窗
    uploadImage = () => {
      this.ActionSheet.show();
    }

    _deletePicture = () => {
      this.changeState('imgsLists', []);
    };

    render() {
      const { navigation } = this.props;
      const { options } = this.state;
      const route = navigation.getParam('route', '');
      console.log(navigation.state);
      const uri = navigation.getParam('uri', false);
      // let _baseUrl = routeIn ? `${config.baseUrl_profit_h5}newIncome`: (uri)?`${config.baseUrl_profit_h5}${uri}` : `${config.baseUrl_profit_h5}home`;
      const _baseUrl = !route ? `${config.baseUrl_profit_h5}latestHome?nativeBack=yes` : `${config.baseUrl_profit_h5}${route}`;
      // let _baseUrl = !route ? `http://192.168.2.115:8082/#/latestHome?nativeBack=yes` : `${config.baseUrl_profit_h5}${route}`;
      const source = {
        uri: _baseUrl,
        showLoading: false,
        headers: { 'Cache-Control': 'no-cache' },
      };
      // console.log('this.webViewRef',this.webViewRef)  //this.webViewRef是个引用对象，层级很深，控制台一直在打印，阻塞了,影响导航返回
      return (
        <View style={styles.container}>
          <StatusBar barStyle="light-content" />
          <View style={styles.content} />
          <WebViewCpt
            ref={(e) => { this.webViewRef = e; }}
            isNeedUrlParams={false}
            source={source}
            postMessage={() => {
              // this.postMessage();
            }}
            getMessage={(data) => {
              const params = data && data.split(',');
              if (params[0] === 'jsGoBackApp') {
                navigation.goBack();
              }
              if (params[0] === 'alterDefaultCard') {
                this.alterDefaultCard(data);
              }
              if (params[0] === 'uploadImage') {
                this.uploadImage();
              }
              if (params[0] === 'jsHiddenXKHUDView') {
                Loading.hide();
              }
              if (params[0] === 'imgPreview') {
                this.setState({
                  showBigPicVisible: true,
                });
              }
              if (params[0] === 'deletePic') {
                this.setState({
                  imgsLists: [],
                });
              }
              if (params[0] === 'jsOpenDescription') { // 联盟商数据说明
                navigation.navigate('AgreementDeal', { title: '联盟商数据说明', uri: JSON.parse(params[1]).url });
              }
              if (params[0] === 'selectBankCard') { // 选择银行卡
                navigation.navigate('Bankcard', {
                  routerIn: 'Profit',
                  callback: (card) => {
                    this.webViewRef.postMessage('selectCard', card.id);
                  },
                });
              }
              if (params[0] === 'relogin') { // 重新登录
                ReLogin(false);
              } if (params[0] === 'selectBankCard') { // 选择银行卡
                navigation.navigate('Bankcard', {
                  routerIn: 'Profit',
                  callback: (card) => {
                    this.webViewRef.postMessage('selectCard', card.id);
                  },
                });
              }
            }}
            navigationChange={(canGoBack) => {
              this.changeState('canGoBack', canGoBack);
            }}
          />
          <View style={styles.footer} />
          {/* 选择上传方式 modal */}
          <ActionSheet
            ref={o => this.ActionSheet = o}
            options={options}
            cancelButtonIndex={options.length - 1}
            onPress={(index) => {
              if ([0, 1].includes(index)) {
                const { takeOrPickImageAndVideo } = this.props;
                let { maxImgLen, imgsLists } = this.state;
                const params = new TakeOrPickParams({
                  func: index === 0 ? 'take' : 'pick',
                  type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
                  crop: TakeOrPickCropEnum.NoCrop,
                  totalNum: maxImgLen - imgsLists.length,
                });
                console.log(params.getOptions(), maxImgLen, imgsLists);
                takeOrPickImageAndVideo(params.getOptions(), (res) => {
                  if (index === 0) imgsLists = res;
                  else imgsLists = imgsLists.concat(res);
                  this.setState({ imgsLists }, () => {
                    this.postMessage('uploadEvent', imgsLists);
                  });
                });
              }
            }}
          />
          {/* 查看大图 */}
          <ShowBigPicModal
            ImageList={this.state.imgsLists}
            visible={this.state.showBigPicVisible}
            showImgIndex={0}
            onClose={() => {
              this.setState({
                showBigPicVisible: false,
              });
            }}
          />
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  content: {
    height: CommonStyles.headerPadding,
    backgroundColor: CommonStyles.globalHeaderColor,
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
  footer: {
    height: CommonStyles.footerPadding,
  },
});

export default connect(null, {
  takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
})(ProfitScreen);
