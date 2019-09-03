/**
 * 支付加盟费
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
  ToastAndroid,
  RefreshControl,
} from 'react-native';
import { connect } from 'rn-dva';
import math from "../../config/math.js";
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as customPay from '../../config/customPay';
import { getProtocolUrl } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');
const unchecked = require('../../images/index/unselect.png');
const checked = require('../../images/index/select.png');

class PayJoin extends NavigationComponent {
  _didFocusSubscription;
  _willBlurSubscription;
  static navigationOptions = {
    header: null,
    gesturesEnabled: false, // 禁用ios左滑返回
  };
  constructor(props) {
    super(props);
    const params = props.navigation.state.params || {};
    this.state = {
      payType: '',
      name: params.name,
      familyUp: params.familyUp,
      merchantType: params.merchantType || '',
      auditStatus: params.auditStatus,
      page: params.page,
      rule: {},
      rules: [],
      route: params.route,
      user: props.userInfo,
      callback: params.callback || (() => { }),
      paied: false,
      refreshing: false,
    };
  }
  screenDidFocus = (payload) => {
    BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid);
  }

  screenWillBlur = (payload) => {
    this.removeEventListener()
  }
  removeEventListener = () => {
    BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid)
  }
  // 触发返回键执行方法
  onBackAndroid = () => {
    this.goBack();
    return true;
  };
  _onRefresh = () => {
    let func;
    const params = {};
    const {
      merchantType, user, name, familyUp, rule
    } = this.state;
    if (global.updateShop) { // 店铺升级
      func = requestApi.upgradeInitialCostTemplate;
      params.mMerchantId = global.updateShop.mMerchantId;
    } else if (user.auditStatus == 'success') {
      if (merchantType == 'familyL1' && (name == '公会' || familyUp)) { // 家族长升级
        func = requestApi.upFamilyInitialCostTemplate;
      } else {
        func = requestApi.merchantExtendInitialCostTemplate;
        params.merchantType = merchantType;
      }
    } else {
      func = requestApi.merchantInitialCostTemplate;
    }
    Loading.show();
    func(params).then((data) => {
      data.map((item, index) => {
        switch (item.payType) {
          case 'all': item.name = '全额支付'; break;
          case 'free': item.name = '0元加盟(提交后需后台审核通过)'; break;
          case 'ratio': item.name = `按比例从平台盈利中扣除（每笔收益扣除${math.divide((item.ratio || 0), 10)}%)`; break;
        }
      });
      newRule = data.length == 1 ? data[0] : rule.payType ? rule : data[0] || {};
      this.setState({
        rules: data,
        rule: newRule,
        merchantType: merchantType == 'familyL1' && (name == '公会' || familyUp) ? merchantType : newRule.merchantType,
        refreshing: false,
      }, () => {
        this.checkPaid(0);
      });
    }).catch((error) => {
      console.log(error);
      this.setState({ refreshing: false });
    });
  }
  componentWillUnmount() {
    this.removeEventListener()
  }

  componentDidMount() {
    Loading.show();
    this._onRefresh();
  }
  checkPaid = (submit) => {
    const {
      rule, merchantType, user, name, familyUp,
    } = this.state;
    if (rule.payType == 'all') {
      let func;
      const params = {};
      if (global.updateShop) {
        func = requestApi.upgradeInitialCostPayStatus;
        params.mMerchantId = global.updateShop.mMerchantId;
      } else if (user.auditStatus == 'success') { // 扩展身份
        if (merchantType == 'familyL1' && name == '公会') { // 家族长升级
          func = requestApi.upFamilyInitialCostPayStatus;
        } else if (familyUp) { // 家族长继续升级
          func = requestApi.merchantKeepEnterUpFamilyInitialCostPayStatus;
        } else {
          func = requestApi.merchantExtendInitialCostPayStatus;
          params.merchantType = merchantType;
        }
      } else {
        if (user.identityStatuses) {
          func = requestApi.merchantKeepEnterInitialCostPayStatus;
        } else {
          func = requestApi.merchantInitialCostPayStatus;
        }
      }
      Loading.show();
      func(params).then((res) => {
        if (res.payStatus == 'success') {
          submit ? this.goNext() : this.setState({ paied: true });
        } else if (res.payStatus == 'notPay') { // 继续入驻
          let newFunc;
          if (user.auditStatus == 'success') {
            if (familyUp) {
              newFunc = requestApi.upFamilyInitialCostPayStatus;
            } else {
              newFunc = requestApi.merchantReExtendInitialCostPayStatus;
            }
          } else {
            newFunc = requestApi.merchantInitialCostPayStatus;
          }
          newFunc(params).then((res) => {
            if (res.payStatus == 'success') {
              submit ? this.goNext() : this.setState({ paied: true });
            } else if (res.payStatus == 'notPay') {
              submit ? Toast.show('还未支付') : this.setState({ paied: false });
            } else {
              submit ? Toast.show('支付失败') : this.setState({ paied: false });
            }
          }).catch(err => {
            console.log(err)
          });
        } else {
          submit ? Toast.show('支付失败') : this.setState({ paied: false });
        }
      }).catch(err => {
        console.log(err)
      });
    } else {
      submit ? this.goNext() : null;
    }
  }
  submit = () => {
    this.checkPaid(1);
  }

  goNext = () => {
    const {
      merchantType, user, rule, route, auditStatus, name, familyUp, page,
    } = this.state;
    let func;
    const params = {
      payType: rule.payType, // free	免加盟费,full全额,ratio比例
      costTemplateId: rule.id,
      ratio: rule.ratio,
    };
    if (global.updateShop) {
      func = requestApi.upgradeInitialCostNextStep;
      params.mMerchantId = global.updateShop.mMerchantId;
    } else if (user.auditStatus == 'success') {
      console.log(merchantType, name, familyUp);
      if (merchantType == 'familyL1' && (name == '公会' || familyUp)) { // 家族长升级
        func = requestApi.upFamilyInitialCostNextStep;
      } else {
        func = requestApi.merchantExtendInitialCostNextStep;
        params.merchantType = merchantType;
      }
    } else {
      func = requestApi.merchantInitialCostNextStep;
    }
    Loading.show();
    func(params).then((data) => {
      this.state.callback();
      this.props.navigation.replace('PayCashDeposit', {
        merchantType, route, auditStatus, name, familyUp, page,
      });
    }).catch(err => {
      console.log(err)
    });
  }
  pay = (payChannel) => {
    const {
      rule, merchantType, user, name, familyUp,
    } = this.state;
    console.log('merchantType', merchantType)
    let func;
    const params = {
      payChannel,
      merchantType,
      payType: rule.payType, // free	免加盟费,full全额,ratio比例
      payableAmount: rule.amount || 0,
      costTemplateId: rule.id,
    };
    if (user.auditStatus == 'success') {
      if ((merchantType == 'familyL1' && name == '公会') || familyUp) { // 家族长升级
        func = requestApi.upFamilyInitialCostPayment;
      } else {
        func = requestApi.merchantExtendInitialCostPayment;
      }
    } else if (global.updateShop) {
      func = requestApi.upgradeInitialCostPayment;
      params.mMerchantId = global.updateShop.mMerchantId;
    } else {
      func = requestApi.merchantInitialCostPayment;
    }
    Loading.show();
    func(params).then((data) => {
      if (data) {
        if (payChannel.indexOf('alipay') != -1) {
          customPay.alipay({ param: data.next.channelPrams.aliPayStr, successCallBack: () => this.checkPaid(0) });
        } else {
          customPay.wechatPay({ param: data.next.channelPrams, successCallBack: () => this.checkPaid(0) });
        }
      } else {
        Toast.show('您已支付过加盟费');
      }
    }).catch(err => {
      console.log(err)
    });
  }
  renderPay = () => (
    <View style={styles.line}>
      {
        (this.state.rule.payChannel || []).map((item, index) => (
          <TouchableOpacity key={index} style={[styles.payType, { borderColor: item.channelKey.indexOf('alipay') != -1 ? '#4A90FA' : '#40BA4A', marginRight: 20 }]} onPress={() => this.pay(item.channelKey)}>
            <Image source={item.channelKey.indexOf('alipay') != -1 ? require('../../images/user/alipay.png') : require('../../images/user/wechat.png')} style={styles.icon} />
            <Text style={[styles.text, { color: item.channelKey.indexOf('alipay') != -1 ? '#4A90FA' : '#40BA4A', marginLeft: 6 }]}>{item.channelName}</Text>
          </TouchableOpacity>
        ))
      }
    </View>
  )
  handleGetProtocolUrl = () => {
    const { navigation } = this.props;
    this.removeEventListener()
    getProtocolUrl('MAM_JOIN_MONEY_RULES').then((res) => {
      navigation.navigate('AgreementDeal', { title: '加盟费规则说明', uri: res.url });
    }).catch(() => {
      // Toast.show("协议请求失败")
    });
  }
  goBack = () => {
    CustomAlert.onShow(
      'confirm',
      '您尚未完成信息提交，退出后需要重新完成入驻，已支付加盟费无需重新交纳，是否退出？',
      '提示',
      () => { },
      () => {
        if (global.updateShop) { // 店铺升级
          global.updateShop.callback && global.updateShop.callback();
          global.updateShop = null;
          this.removeEventListener()
          this.props.navigation.navigate('StoreManage');
          return;
        }
        this.props.getMerchantHome();
        this.removeEventListener()
        this.props.navigation.navigate('RegisterList');
      },
      botton1Text = '确定',
      botton2Text = '取消',
    );
  }

  render() {
    const { navigation } = this.props;
    const {
      rule, route, page, paied, rules,
    } = this.state;
    console.log(rule);
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          leftView={(
            <TouchableOpacity
              style={styles.headerLeftView}
              onPress={this.goBack}
            >
              <Image
                source={require('../../images/mall/goback.png')}
              />
            </TouchableOpacity>
          )}
          rightView={(
            <TouchableOpacity
              style={styles.headerRightView}
              disabled
              onPress={() => {
                this.handleGetProtocolUrl();
              }}
            >
              {/* <Text style={styles.headerRightView_text}> 规则说明 </Text> */}
            </TouchableOpacity>
          )}
          title="支付费用"
        />

        <ScrollView
          style={{ flex: 1 }}
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
          refreshControl={(
            <RefreshControl
              refreshing={this.state.refreshing}
              onRefresh={() => {
                this.setState({ refreshing: true });
                this._onRefresh();
              }}
            />
          )}
        >
          <View style={styles.content}>
            <View style={styles.topView}>
              <Text style={[styles.title, { fontWeight: 'bold' }]}>
                加盟费
                  {' '}
                <Text style={{ color: '#FF7E00', fontSize: 20 }}>
                  {' '}
                  ¥
                    <Text style={{ fontFamily: 'Akrobat-Bold' }}>{math.divide(rule.amount || 0, 100)}</Text>
                </Text>
                {
                  rule.payType == 'all' ? <Text style={{ color: '#ccc' }}>{paied ? '(已缴纳)' : ''}</Text> : null
                }
              </Text>
            </View>
            <Text style={[styles.title, { marginTop: 20, fontWeight: 'bold' }]}>支付类型 </Text>
            <View>
              {
                paied
                  ? (
                    <View style={[styles.payItem]}>
                      <Text style={[styles.text]}>{rule.name}</Text>
                    </View>
                  )
                  : rules.map((item, index) => (
                    <View style={[styles.payItem]} key={index}>
                      <TouchableOpacity style={{ paddingRight: 10 }} onPress={() => this.setState({ rule: item })}>
                        <Image source={item.payType == rule.payType ? checked : unchecked} />
                      </TouchableOpacity>
                      <View>
                        <Text style={[styles.text]}>{item.name}</Text>
                        {item.payType == 'all' && item.payType == rule.payType ? this.renderPay() : null}
                      </View>

                    </View>
                  ))
              }
            </View>
          </View>
        </ScrollView>
        {
          rule.payType ? (
            <TouchableOpacity
              style={styles.btn}
              onPress={() => this.submit()}
            >
              <Text style={{ color: '#fff', fontSize: 17 }}>下一步</Text>
            </TouchableOpacity>
          ) : null
        }


      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  content: {
    width: width - 20,
    margin: 10,
    backgroundColor: '#fff',
    borderRadius: 8,
    // ...CommonStyles.shadowStyle,
    paddingHorizontal: 15,
    paddingVertical: 20,
  },
  headerLeftView: {
    width: width / 3,
    alignItems: 'flex-start',
    paddingLeft: 18,
  },
  headerRightView: {
    paddingRight: 18,
    width: width / 3,
    alignItems: 'flex-end',
  },
  headerRightView_text: {
    fontSize: 17,
    color: '#fff',
  },
  title: {
    color: '#222',
    fontSize: 14,
  },
  text: {
    color: '#555',
    fontSize: 14,
  },
  topView: {
    flex: 1,
    borderBottomWidth: 1,
    borderColor: 'rgba(0,0,0,0.08)',
    justifyContent: 'center',
    paddingBottom: 20,

  },
  payItem: {
    marginTop: 15,
    flexDirection: 'row',
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  payType: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: 108,
    height: 40,
    borderWidth: 1,
    borderRadius: 4,
    marginTop: 15,
  },
  icon: {
    width: 18,
    height: 18,
  },
  btn: {
    justifyContent: 'center',
    alignItems: 'center',
    height: 50,
    marginBottom: CommonStyles.footerPadding,
    backgroundColor: '#4A90FA',
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
  }),
  {
    getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
  },
)(PayJoin);
