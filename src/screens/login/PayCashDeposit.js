/**
 * 支付保证金
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
  RefreshControl,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import ImageView from '../../components/ImageView';
import * as customPay from '../../config/customPay';
import { getProtocolUrl } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';
import math from "../../config/math.js";
const { width, height } = Dimensions.get('window');
const unchecked = require('../../images/index/unselect.png');
const checked = require('../../images/index/select.png');

function getWidth(val) { return (width * val) / 375; }

class PayCashDeposit extends NavigationComponent {
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
      merchantType: params.merchantType || 'shops',
      route: params.route,
      name: params.name,
      page: params.page,
      familyUp: params.familyUp,
      auditStatus: params.auditStatus,
      rule: {},
      rules: [],
      user: props.userInfo,
      callback: params.callback || (() => { }),
      paied: false,
      refreshing: false,
      showBigPicArr: [],
      bigPicVisible: false,
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
    if (global.updateShop) {
      func = requestApi.upgradeCashDepositTemplate;
      params.mMerchantId = global.updateShop.mMerchantId;
    } else if (user.auditStatus == 'success') {
      if (merchantType == 'familyL1' && (name == '公会' || familyUp)) { // 家族长升级
        func = requestApi.upFamilyCashDepositTemplate;
      } else {
        func = requestApi.merchantExtendCashDepositTemplate;
        params.merchantType = merchantType;
      }
    } else {
      func = requestApi.merchantCashDepositTemplate;
    }
    func(params).then((data = []) => {
      data.map((item, index) => {
        switch (item.payType) {
          case 'all': item.name = '全额支付'; break;
          case 'free': item.name = '0元加盟(提交后需后台审核通过)'; break;
          case 'ratio': item.name = `按比例从平台盈利中扣除（每笔收益扣除${math.divide((item.ratio || 0), 10)}%)`; break;
          case 'offline': item.name = '线下支付'; break;
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
    }).catch(() => {
      this.setState({ refreshing: false });
    });
  }
  componentDidMount() {
    Loading.show();
    this._onRefresh();
    setTimeout(() => {
      SplashScreen.hide();
    }, 100);
  }
  componentWillUnmount() {
    this.removeEventListener()
  }
  goNext = () => {
    const {
      merchantType, user, rule, route, name, familyUp, auditStatus, page,
    } = this.state;
    let func;
    const params = {
      payType: rule.payType, // free	免加盟费,full全额,ratio比例
      costTemplateId: rule.id,
    };
    if (global.updateShop) {
      func = global.updateShop.id ? requestApi.upgradeCashDepositNextStepShop : requestApi.upgradeCashDepositNextStep;
      params.mMerchantId = global.updateShop.mMerchantId;
      params.shopId = global.updateShop.id;
    } else if (user.auditStatus == 'success') {
      if (merchantType == 'familyL1' && (name == '公会' || familyUp)) { // 家族长升级
        func = requestApi.upFamilyCashDepositNextStep;
      } else {
        func = requestApi.merchantExtendCashDepositNextStep;
        params.merchantType = merchantType;
      }
    } else {
      func = requestApi.merchantCashDepositNextStep;
    }
    Loading.show();
    func(params).then((data) => {
      this.state.callback();
      if (global.updateShop && !global.updateShop.id) { // 创建独立
        this.props.navigation.replace('StoreEditor', { route: 'StoreManage', page: 'add' });
      } else {
        const navigationParams = {
          merchantType, route, familyUp, auditStatus, page,
        };
        if (auditStatus == 'fail' && merchantType == 'shops') {
          this.props.navigation.replace('StoreEditor', this.props.navigation.state.params);
        } else {
          this.props.navigation.replace('ApplyFormDone', navigationParams);
        }
      }
    }).catch(err => {
      console.log(err)
    });
  }
  checkPaid = (submit) => {
    const {
      rule, merchantType, user, name, familyUp,
    } = this.state;
    if (rule.payType == 'all') {
      let func;
      const params = {};
      if (global.updateShop) {
        func = requestApi.upgradeCashDepositPayStatus;
        params.mMerchantId = global.updateShop.mMerchantId;
      } else if (user.auditStatus == 'success') {
        if (merchantType == 'familyL1' && name == '公会') { // 家族长升级
          func = requestApi.upFamilyCashDepositPayStatus;
        } else if (familyUp) { // 家族长继续升级
          func = requestApi.merchantKeepEnterUpFamilyCashDepositPayStatus;
        } else {
          func = requestApi.merchantExtendCashDepositPayStatus;
          params.merchantType = merchantType;
        }
      } else {
        if (user.identityStatuses) {
          func = requestApi.merchantKeepEnterCashDepositPayStatus;
        } else {
          func = requestApi.merchantCashDepositPayStatus;
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
              newFunc = requestApi.upFamilyCashDepositPayStatus;
            } else {
              newFunc = requestApi.merchantReExtendCashDepositPayStatus;
            }
          } else {
            newFunc = requestApi.merchantCashDepositPayStatus;
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
  pay = (payChannel) => {
    const {
      rule, merchantType, user, name, familyUp,
    } = this.state;
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
        func = requestApi.upFamilyCashDepositPayment;
      } else {
        func = requestApi.merchantExtendCashDepositPayment;
      }
    } else if (global.updateShop) {
      func = requestApi.upgradeCashDepositPayment;
      params.mMerchantId = global.updateShop.mMerchantId;
    } else {
      func = requestApi.merchantCashDepositPayment;
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
        Toast.show('服务器返回数据错误');
      }
    }).catch(err => {
      console.log(err)
    });
  }
  renderPay = () => (
    <View style={styles.line}>
      {
        (this.state.rule.payChannel || []).map((item, index) => {
          const isAlipay = item.channelKey.indexOf('alipay') != -1
          return (
            <TouchableOpacity key={index} style={[styles.payType, { borderColor: isAlipay ? '#4A90FA' : '#40BA4A', marginRight: 20 }]} onPress={() => this.pay(item.channelKey)}>
              <Image source={isAlipay ? require('../../images/user/alipay.png') : require('../../images/user/wechat.png')} style={styles.icon} />
              <Text style={[styles.text, { color: isAlipay ? '#4A90FA' : '#40BA4A', marginLeft: 6 }]}>{isAlipay ? '支付宝' : '微信支付'}</Text>
            </TouchableOpacity>
          )
        })
      }
    </View>
  )
  renderOfflineContent = () => {
    const { rule } = this.state;
    const bankInfo = [
      { title: '户名', value: rule.bankName || '' },
      { title: '开户行', value: rule.openBank || '' },
      { title: '账号', value: rule.cardNumber || '' },
    ];
    return (
      <View>
        <Text style={{ color: '#999999', fontSize: 12, marginTop: 10 }}>方式一：银行转账</Text>
        <View style={styles.bankView}>
          {
            bankInfo.map((item, index) => (
              <View
                key={index}
                style={{ flexDirection: 'row', alignItems: 'center', marginBottom: index == 2 ? 0 : 8 }}
              >
                <Text style={{ color: '#9399A5', fontSize: 12 }}>
                  {item.title}
                  ：
                            </Text>
                <Text style={{ color: '#222', fontSize: 12 }}>{item.value}</Text>
              </View>
            ))
          }
        </View>
        {
          <View style={{ flexDirection: 'row', marginTop: 15 }}>
            {
              ['二', '三'].map((item, index) => (
                <TouchableOpacity
                  key={index}
                  style={{ marginRight: getWidth(25) }}
                  onPress={() => {
                    this.setState({
                      showBigPicArr: [{ type: 'images', url: index == 0 ? rule.alipayPic : rule.wexinPic }],
                      bigPicVisible: true,
                    });
                  }}
                >
                  <Text style={{ color: '#999999', fontSize: 12, marginTop: 10 }}>
                    方式
                                  {item}
                    ：
                                  {index == 0 ? '支付宝' : '微信'}
                    转账
                                </Text>
                  <ImageView style={{ marginTop: 8 }} source={{ uri: (index == 0 ? rule.alipayPic : rule.wexinPic) || null }} sourceWidth={getWidth(135)} sourceHeight={getWidth(152)} />
                </TouchableOpacity>
              ))
            }
          </View>
        }
        <Text style={{
          color: CommonStyles.globalRedColor, fontSize: 12, marginTop: 10, paddingRight: 15,
        }}
        >
          注：转账时请在“添加备注" 处准确填写注册时的真实姓名，以便平台核实信息并及时处理，如有疑问请致电客服：400-0801118

          </Text>
      </View>
    );
  }
  handleGetProtocolUrl = () => {
    const { navigation } = this.props;
    this.removeEventListener()
    getProtocolUrl('MAM_CAUTION_MONEY_RULES').then((res) => {
      navigation.navigate('AgreementDeal', { title: '保证金规则说明', uri: res.url });
    }).catch(() => {
      // Toast.show("协议请求失败")
    });
  }
  goBack = () => {
    CustomAlert.onShow(
      'confirm',
      '您尚未完成信息提交，退出后需要重新完成入驻，已支付保证金无需重新交纳，是否退出？',
      '提示',
      () => { },
      () => {
        this.removeEventListener()
        if (global.updateShop) { // 店铺升级
          global.updateShop.callback && global.updateShop.callback();
          global.updateShop = null;
          this.props.navigation.navigate('StoreManage');
          return;
        }
        this.props.getMerchantHome();
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
              onPress={() => {
                this.handleGetProtocolUrl();
              }}
            >
              <Text style={styles.headerRightView_text}> 规则说明 </Text>
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
          <View style={[styles.content]}>
            <View style={styles.topView}>
              <Text style={[styles.title, { fontWeight: 'bold' }]}>
                保证金
                        <Text style={{ color: '#FF7E00', fontSize: 20 }}>
                  {' '}
                  ¥
                            {' '}
                  <Text style={{ fontFamily: 'Akrobat-Bold' }}>{math.divide(rule.amount || 0, 100)}</Text>
                </Text>
                {
                  rule.payType == 'all' ? <Text style={{ color: '#ccc' }}>{paied ? '(已缴纳)' : ''}</Text> : null
                }
              </Text>
              <Text style={{ marginTop: 10, fontSize: 12, color: '#999' }}>*保证金支付后可随时提取，提取后账号无法使用 </Text>
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
                        {
                          item.payType == 'all' && item.payType == rule.payType ? this.renderPay()
                            : item.payType == 'offline' && item.payType == rule.payType ? this.renderOfflineContent()
                              : null
                        }
                      </View>

                    </View>
                  ))
              }
            </View>
          </View>
        </ScrollView>
        {
          rule.payType
            ? rule.payType == 'offline' && !rule.cardNumber ? null
              : (
                <TouchableOpacity
                  style={styles.btn}
                  onPress={() => this.submit()}
                >
                  <Text style={{ color: '#fff', fontSize: 17 }}>已完成支付</Text>
                </TouchableOpacity>
              ) : null

        }
        <ShowBigPicModal
          ImageList={this.state.showBigPicArr}
          visible={this.state.bigPicVisible}
          showImgIndex={0}
          callback={(index) => { }}
          // childrenStyles={{top:CommonStyles.headerPadding, right: 17 }}
          onClose={() => {
            this.setState({
              bigPicVisible: false,
            });
          }}
        >
        </ShowBigPicModal>
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
    // height: 82,
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
    minWidth: 108,
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
  bankView: {
    backgroundColor: '#F8F9FA',
    padding: 15,
    marginTop: 15,
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
  }),
  {
    getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
  },
)(PayCashDeposit);
