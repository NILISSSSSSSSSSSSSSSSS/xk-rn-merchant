// 消费抽奖详情页，商品详情

import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';

import config from '../../config/config';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import WebViewCpt from '../../components/WebViewCpt';
import * as nativeApi from '../../config/nativeApi';

const { width, height } = Dimensions.get('window');

class WMNewGoodsDetailScreen extends Component {
    static navigationOptions = {
      header: null,
    }
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
      super(props);
      this._didFocusSubscription = props.navigation.addListener('didFocus', (payload) => {
        StatusBar.setBarStyle('dark-content');
      });
      this.state = {
        goodsData: {},
        canGoBack: false,
        modalVisible: false,
        modalLists: [
          {
            id: 1,
            title: '分享',
            icon: require('../../images/mall/share.png'),
            routeName: '',
          },
          {
            id: 2,
            title: '意见反馈',
            icon: require('../../images/mall/fankui.png'),
            routeName: 'Feedback',
          },
        ],
        shareModal: false,
        shareUrl: '', // 分享链接
        shareParams: null,
        showBingPicVisible: false,
        bigIndex: 0, // 大图索引
        bigList: [], // 查看大图所有图片
        goodsId: (global.nativeProps && global.nativeProps.goodsId) || this.props.navigation.getParam('goodsId', ''),
        sequenceId: (global.nativeProps && global.nativeProps.sequenceId) || this.props.navigation.getParam('sequenceId', ''),
      };
    }

    componentDidMount() {
      // Loading.show();
      this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload => StatusBar.setBarStyle('light-content'));
    }
    getGoodsDetail = (router = '') => {
      Loading.show();
      requestApi.lotteryDetail({
        sequenceId: this.state.sequenceId,
      }).then((res) => {
        console.log('商品详情', this.props, res);
        if (router === 'Feedback') {
          this.props.navigation.navigate('Feedback', { goodsData: res.jSequence.goods });
        }
      }).catch((err) => {
        console.log(err);
      });
    }
    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    postMessage = () => {

    }

    goBack = () => {
      const { navigation } = this.props;
      const { canGoBack } = this.state;
      if (canGoBack) {
        this.webViewRef.goBack();
      } else {
        global.nativeProps ? nativeApi.popToNative()
          : navigation.goBack();
      }
    }
    // 进入结算界面：
    jsOpenIndianaShopOrder(e) {
      const str = e.replace('jsOpenIndianaShopOrder,', '');
      const data = JSON.parse(str);
      console.log('data', data);
      const datalist = [];
      let totlePrice = 0;
      if (data) {
        datalist[0] = {};
        datalist[0].goodsId = data.jSequence.goods.id;
        datalist[0].quantity = data.quantity;
        datalist[0].price = data.jSequence.lotteryWay.eachNotePrice;
        datalist[0].name = data.jSequence.goods.name;
        datalist[0].url = data.jSequence.goods.mainPic;
        datalist[0].lotteryNumber = null;
        datalist[0].participateStake = data.jSequence.currentCustomerNum;
        datalist[0].drawTime = data.jSequence.expectLotteryDate;
        datalist[0].drawType = data.jSequence.lotteryWay.jDrawType;
        datalist[0].maxStake = data.jSequence.lotteryWay.eachSequenceNumber;
        datalist[0].sequenceId = data.jSequence.id;
        totlePrice = data.quantity * data.jSequence.lotteryWay.eachNotePrice;
      }
      this.props.navigation.navigate('IndianaShopOrder', { data: datalist, totlePrice });
    }
    // 打开购物车
    jsOpenAppShoppingCart = (e) => {
      this.props.navigation.navigate('IndianaShopCart');
    }
    // 打开客服
    jsOpenAppCustomerService = (e) => {
      // Toast.show('开发中');
      nativeApi.createXKCustomerSerChat();
    }
    // 打开图片浏览
    jsOpenAppImageBrowser = (param) => {
      const _params = param.replace('jsOpenAppImageBrowser,', '');
      const _data = JSON.parse(_params);
      const { index, list } = _data;
      const temp = [];
      list.map((item) => {
        if (item.type === 'img') {
          temp.push({
            url: item.url,
            type: 'images',
          });
        }
      });
      console.log(temp);
      StatusBar.setHidden(true);

      this.setState({
        bigIndex: index,
        bigList: temp,
        showBingPicVisible: true,
      });
      console.log('打开图片浏览', JSON.parse(_params));
    }
    // 打开全部评价
    jsOpenAppComments = (e) => {
      this.props.navigation.navigate('WMAllShowOrder', { goodsId: this.state.goodsId });
    }
    //  获取分享路径
    pushSharePath = (e) => {
      e = e.replace('pushSharePath,', '');
      const param = JSON.parse(e);
      this.changeState('shareUrl', param.shareUrl);
      this.changeState('shareParams', param.param);
    }

    // 加入购物车
    addToCart = () => {
      const merchantId = this.props.store.user.userShop.id;
      requestApi.requestGoodsSku({ goodsId: this.state.goodsId }, (res) => {
        const goodsSkuCode = res.skuAttrValue[0].code;
        const quantity = 1;
        requestApi.requestMallCartCreate({
          merchantId, goodsId: this.state.goodsId, goodsSkuCode, quantity,
        }, () => {
          Toast.show('加入购物车成功');
        });
      });
    }
    componentWillUnmount() {
      this._didFocusSubscription && this._didFocusSubscription.remove();
      this._willBlurSubscription && this._willBlurSubscription.remove();
      Loading.hide();
    }

    render() {
      const { navigation, store } = this.props;
      const sequenceId = this.props.navigation.getParam('sequenceId', '');
      const orderId = this.props.navigation.getParam('orderId', '');

      const _baseUrl = `${config.baseUrl_h5}lotteryDetail`;
      const referralCode = store.user.user.securityCode;
      const _url = `${_baseUrl}?id=${sequenceId}&orderId=${orderId || ''}`;
      const source = {
        uri: _url,
        showLoading: true,
        headers: { "Cache-Control": "no-cache" }
      };
      return (
        <View style={styles.container}>
          <StatusBar barStyle="light-content" />
          <Header
                    navigation={navigation}
                    goBack
                    title="商品详情"
          />
          <WebViewCpt
                    webViewRef={(e) => { this.webViewRef = e; }}
                    isNeedUrlParams
                    source={source}
                    postMessage={() => {
                      this.postMessage();
                    }}
                    getMessage={(data) => {
                      const params = data && data.split(',');
                      // if (params[0] === 'jsOpenAppShoppingCart') {
                      //     this.jsOpenAppShoppingCart(params);
                      // } else if (params[0] === 'jsOpenAppCustomerService') {
                      //     this.jsOpenAppCustomerService(params);
                      // } else if (params[0] === 'jsOpenAppImageBrowser') {
                      //     this.jsOpenAppImageBrowser(data);
                      // } else if (params[0] === 'jsOpenAppComments') {
                      //     this.jsOpenAppComments(params);
                      // } else if (params[0] === 'pushSharePath') {
                      //     this.pushSharePath(data);
                      // } else if (params[0] === 'jsOpenIndianaShopOrder') {
                      //     this.jsOpenIndianaShopOrder(data);
                      // } else if (params[0] === 'jsHiddenXKHUDView') {
                      //     Loading.hide()
                      // } else {
                      console.log(params);
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
  footerView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 50 + CommonStyles.footerPadding,
    paddingBottom: CommonStyles.footerPadding,
  },
  footerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: 50,
  },
  footerItem1: {
    flex: 1.6,
    backgroundColor: '#fff',
  },
  footerItem1_imgView: {
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    paddingHorizontal: 10,
  },
  footerItem2: {
    flex: 1,
    backgroundColor: '#4A90FA',
  },
  footerItem3: {
    flex: 1,
    backgroundColor: '#EE6161',
  },
  footerItem_text: {
    fontSize: 14,
    color: '#fff',
  },
  modalOutView: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'transparent',
    // backgroundColor: 'blue'
  },
  modalInnerView: {
    position: 'absolute',
    top: 44 + CommonStyles.headerPadding,
    right: 12,
    width: 126,
    height: 130,
  },
  modalinnerItem_border: {
    borderTopWidth: 1,
    borderTopColor: 'rgba(255,255,255,0.2)',
  },
  modalInnerItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    width: '100%',
    height: '100%',
    paddingLeft: 5,
    // height: 41,
    // paddingHorizontal: 15,
    // flexDirection: 'row',
    // justifyContent: 'flex-start',
    // alignItems: 'center',
    // width: '100%',
    // height: 41,
    // paddingLeft: 15,
    // paddingTop: 10
    // backgroundColor:'rgba(10,10,10,.5)'
  },
  modalInnerItem_text: {
    fontSize: 17,
    color: '#fff',
    marginLeft: 8,
  },
  modalOutView2: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  shareModalView: {
    width: width - 55,
    marginHorizontal: 27.5,
    borderRadius: 8,
    backgroundColor: '#fff',
    overflow: 'hidden',
  },
  shareModalView_img: {
    width: '100%',
    height: 110,
  },
  shareModalView_center: {
    width: '100%',
    // borderTopWidth: 1,
    // borderTopColor: '#E5E5E5',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5E5',
  },
  shareModalView_center_top: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    height: 80,
    paddingHorizontal: 10,
    paddingVertical: 7,
  },
  shareModalView_center_top_left: {
    justifyContent: 'space-between',
    height: '100%',
  },
  shareModalView_center_top_right: {
    width: 66,
    height: '100%',
  },
  shareModalView_center_top_right_img: {
    width: '100%',
    height: '100%',
  },
  shareModalView_center_top_left_text1: {
    fontSize: 12,
    color: '#777',
  },
  shareModalView_center_top_left_item1: {
    paddingHorizontal: 20,
    paddingVertical: 2,
    borderRadius: 10,
    backgroundColor: '#FF545B',
  },
  shareModalView_center_top_left_text2: {
    fontSize: 12,
    color: '#fff',
  },
  shareModalView_center_bom: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingTop: 10,
  },
  shareModalView_center_bom_view: {
    justifyContent: 'center',
    alignItems: 'center',
    width: '25%',
    marginBottom: 10,
  },
  shareModalView_center_bom_img: {
    width: 40,
    height: 40,
  },
  shareModalView_center_bom_text: {
    fontSize: 10,
    color: '#777',
    marginTop: 5,
  },
  shareModalView_bom: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    height: 36,
  },
  shareModalView_bom_text: {
    fontSize: 14,
    color: '#222',
  },
  goodsInfoWrap: {
    padding: 10,
  },
  goodsTitle: {
    fontSize: 14,
    color: '#222',
  },
  goodsInfoPrice: {
    paddingHorizontal: 7,
    paddingVertical: 4,
    backgroundColor: '#FF545B',
    color: '#fff',
    fontSize: 12,
    borderRadius: 20,
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(255,255,255,.2)',
  },
});

export default connect(
  state => ({ store: state }),
)(WMNewGoodsDetailScreen);
