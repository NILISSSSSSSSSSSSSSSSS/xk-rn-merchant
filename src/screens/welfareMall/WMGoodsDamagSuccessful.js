/**
 * 货物报损成功
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
} from 'react-native';
import { connect } from 'rn-dva';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import Content from '../../components/ContentItem';
import math from '../../config/math';

const { width, height } = Dimensions.get('window');
const sucessImg = require('../../images/indianashopcart/submitSucess.png');
const recevingSucessImg = require('../../images/wm/wm_success_icon.png');

function getwidth(val) {
  return width * val / 375;
}
/**
 * resultType: 1,收货成功，2，报损成功，3，晒单成功，4，晒单失败， 5，领取消费抽奖奖品
 */
class WMGoodsDamagSuccessful extends PureComponent {
  static navigationOptions = {
    header: null,
    gesturesEnabled: false, // 禁用ios左滑返回
  };
    _didFocusSubscription;
    _willBlurSubscription;

    componentDidMount() {
      this._didFocusSubscription = this.props.navigation.addListener('didFocus', (payload) => {
        BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
      });
      this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload => BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid));
      // requestApi.storageWMOrderShare("remove");
    }

    componentWillUnmount() {
      this._didFocusSubscription && this._didFocusSubscription.remove();
      this._willBlurSubscription && this._willBlurSubscription.remove();
      Loading.hide();
    }

    onBackButtonPressAndroid = () => {
      const { navigation, opeartGoBackRouteName } = this.props;
      const resultType = navigation.getParam('resultType', '');
      const isFocused = navigation.isFocused();
      let goBackRouteName = 'WMOrderList'
      if (isFocused) {
        if (resultType === 2) { 
          // 货物报损， 只有福利订单详情才会有， 需要返回订单详情，而不是列表，其余的返回，记录好的列表路由
          navigation.navigate('WMWinPrizeDetail');
          return true;
        }
        // opeartGoBackRouteName 如果福利订单列表进入 为 WMOrderList， 如果我的奖品列表进入 为 WMMyPrizeRecord， 如果我的夺奖进入 为 WMMyprize
        if (opeartGoBackRouteName !== '') {
          goBackRouteName = opeartGoBackRouteName
        }
        console.log('osdlfjal',opeartGoBackRouteName)
        navigation.navigate(goBackRouteName);
        return true;
      }
      return false;
    };

    // 晒单文案
    getShowOrderText = () => {
      const { navigation } = this.props;
      const showOrderResponse = navigation.getParam('showOrderResponse', {});
      if (!showOrderResponse.returnPrice) {
        return '';
      }
      switch (showOrderResponse.returnType) {
        case 'voucher':
          return `后，将赠送给您${math.divide(showOrderResponse.returnPrice, 100)}消费券`;
        default:
          return `后，将赠送给您${showOrderResponse.returnPrice}张AA彩票`;
      }
    }

    getBottomView = (resultType) => {
      const { navigation, dispatch } = this.props;
      const routerIn = navigation.getParam('routerIn', '');
      const orderId = navigation.getParam('orderId', '');
      switch (resultType) {
        case 1: // 确认收货
          return (
            <React.Fragment>
              <Image source={sucessImg} />
              <Text style={styles.bottom_label}>确认收货成功</Text>
              <View style={styles.flexCenter}>
                <TouchableOpacity style={[styles.bottom_btn, { marginRight: 10 }]} onPress={() => { navigation.navigate('WMShowOrder', { orderId }); }}>
                  <Text style={styles.bottom_btn_text}>去晒单</Text>
                </TouchableOpacity>
                <TouchableOpacity style={[styles.bottom_btn, { marginLeft: 10 }]} onPress={() => { 
                  // navigation.navigate('WMOrderList'); 
                  dispatch({ type: 'welfare/handleOpeartGoBack', payload: { resultType } })
                }}>
                  <Text style={styles.bottom_btn_text}>返回订单列表</Text>
                </TouchableOpacity>
              </View>
            </React.Fragment>
          );
        case 2: // 货物报损
          return (
            <React.Fragment>
              <Image source={sucessImg} />
              <View style={{ width: getwidth(252) }}>
                <Text style={{ textAlign: 'center',lineHeight: 19 }}>您的信息已经提交成功，客服人员会尽快为您处理，请注意查看订单状态</Text>
              </View>
            </React.Fragment>
          );
        case 3: // 晒单
          return (
            <React.Fragment>
              <Image source={sucessImg} />
              <Text style={[styles.bottom_label, { paddingHorizontal: 44, lineHeight: 19 }]}>
                { `你的晒单已提交，系统会尽快为你审核${this.getShowOrderText()}` }
                </Text>
              <View style={styles.flexCenter}>
                <TouchableOpacity
                  style={[styles.bottom_btn, { marginLeft: 10 }]}
                    onPress={() => {
                      // navigation.navigate('WMOrderList');
                      dispatch({ type: 'welfare/handleOpeartGoBack', payload: { resultType } })
                  }}
                >
                  <Text style={styles.bottom_btn_text}>返回订单列表</Text>
                </TouchableOpacity>
              </View>
            </React.Fragment>
          );
        case 4: // 晒单失败。作废
          return (
            <React.Fragment>
              <Image source={sucessImg} />
              <Text style={[styles.bottom_label, styles.color_red, { paddingBottom: 10 }]}>你的晒单审核未通过！</Text>
              <Text style={[styles.bottom_label_reason, { paddingBottom: 10 }]}>未通过原因:你的晒单图片与商品不符！</Text>
              <View style={styles.flexCenter}>
                <TouchableOpacity style={[styles.bottom_btn, { marginTop: 5 }]} onPress={() => { navigation.navigate('WM'); }}>
                  <Text style={styles.bottom_btn_text}>重新晒单</Text>
                </TouchableOpacity>
              </View>
            </React.Fragment>
          );
        case 5: // 领取成功
          return (
            <React.Fragment>
              <Image source={recevingSucessImg} />
              <Text style={[styles.bottom_label, { fontWeight: '700', paddingTop: 30 }]}>恭喜您，领取成功</Text>
              <TouchableOpacity
                style={[{
                  margin: 10, paddingVertical: 15, width: width - 50, backgroundColor: CommonStyles.globalHeaderColor, borderRadius: 8,
                }]}
                onPress={() => {
                  // navigation.navigate('WMOrderList');
                  dispatch({ type: 'welfare/handleOpeartGoBack', payload: { resultType } })
                }}
              >
                <Text style={[{ color: '#fff', fontSize: 15, textAlign: 'center' }]}>确定</Text>
              </TouchableOpacity>
            </React.Fragment>
          );
        default: return null;
      }
    }

    render() {
      const { navigation, dispatch } = this.props;
      const title = navigation.getParam('title', '提交结果');
      const resultType = navigation.getParam('resultType', '');
      const routerIn = navigation.getParam('routerIn', '');
      const awardUsage = navigation.getParam('awardUsage', '');
      console.log(title);
      console.log(navigation);
      return (
        <View style={styles.container}>
          <Header
          navigation={navigation}
          goBack
          title={title}
          leftView={(
            <View>
              <TouchableOpacity
              style={[styles.headerItem, styles.left]}
              onPress={() => {
                dispatch({ type: 'welfare/handleOpeartGoBack', payload: { resultType } })
              }}
              >
                <Image
                source={require('../../images/mall/goback.png')}
                />
              </TouchableOpacity>
            </View>
          )}
          />
          <Content style={{ justifyContent: 'center', alignItems: 'center', paddingVertical: 10 }}>
            {
              this.getBottomView(resultType)
            }
          </Content>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  bottom_label: {
    fontSize: 14,
    color: '#555',
    textAlign: 'center',
    paddingTop: 13,
    paddingBottom: 22,
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexCenter: {
    justifyContent: 'center',
    flexDirection: 'row',
  },
  bottom_btn: {
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    width: 86,
    height: 22,
    lineHeight: 22,
    borderRadius: 22,
    textAlign: 'center',
    justifyContent: 'center',
    alignItems: 'center',
  },
  bottom_btn_text: {
    fontSize: 12,
    color: CommonStyles.globalHeaderColor,
    textAlign: 'center',
  },
  color_red: {
    color: '#EE6161',
  },
  bottom_label_reason: {
    fontSize: 12,
    color: '#555',
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
    opeartGoBackRouteName: state.welfare.opeartGoBackRouteName, // 记录进入的列表
  }),
  dispatch => ({ dispatch }),
)(WMGoodsDamagSuccessful);
