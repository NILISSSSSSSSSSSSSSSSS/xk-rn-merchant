import React, { Component, PureComponent } from 'react';
import {
  View, Text, StyleSheet, ImageBackground, ScrollView, RefreshControl, Image, TouchableOpacity, Modal,
} from 'react-native';

import { connect } from 'rn-dva';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import Panel from '../../components/Panel';
import XKText from '../../components/XKText';
import Button from '../../components/Button';
import {
  SmallMargin, BaseMargin, WindowWidth, YellowColor, FlexCenter, RowCenter, RowStart, FlexStart, WarningColor, MaskColor, WhiteColor, TextColor, TextSecondColor,
} from '../../components/theme';
import { ListItem } from '../../components/List';
import { NavigationComponent } from '../../common/NavigationComponent';
import ImageView from '../../components/ImageView';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { keepTwoDecimal } from '../../config/utils';
import math from '../../config/math';
import ActionSheet from '../../components/Actionsheet';

const payingIcon = require('../../images/my/icon-paying.png');
const paying2Icon = require('../../images/my/icon-paying2.png');
const paiedIcon = require('../../images/my/icon-paied.png');
const paiedIconSY = require('../../images/my/icon-paied-sy.png');
const paiedIconJMF = require('../../images/my/icon-paied-jmf.png');
const paiedIconBZJ = require('../../images/my/icon-paied-bzj.png');
const activedIcon = require('../../images/my/icon-actived.png');
const failIcon = require('../../images/user/state_fail.png');


const numbers = {
  number1: require('../../images/my/number1.png'),
  number2: require('../../images/my/number2.png'),
  number3: require('../../images/my/number3.png'),
};

function getWidth(val) {
  return WindowWidth * val / 375;
}

const StatusLabel = ({ icon, style }) => (icon ? (
  <View style={[{
    position: 'absolute', right: -getWidth(19), top: getWidth(16), height: getWidth(30),
  }, style]}
  >
    <Image source={icon} style={{ height: getWidth(30) }} />
  </View>
) : null);

const PanelTitle = ({ title, price }) => (
  <Text>
    <Text style={styles.title}>{title}</Text>
    <Text>{' '.repeat(4)}</Text>
    <Text style={styles.price}>
      <Text>¥ </Text>
      <XKText fontFamily="Oswald" style={styles.priceNumber}>{price}</XKText>
    </Text>
  </Text>
);

const DescriptTitle = ({ title, subtitle }) => (
  <Text style={styles.btnTitle}>
    <Text>{`${title}\n`}</Text>
    <Text style={styles.btnSubTitle}>{subtitle}</Text>
  </Text>
);

const calCountDown = (timeExpire)=> {
  return timeExpire ? Math.floor(timeExpire - Date.now() / 1000) : -1;
};

const EndSecond = -5;

/** 具有倒计时功能的按钮 */
class PrimaryButton extends PureComponent {
  state = {
    timeExpire: 0,
    countdown: 0,
  }
  /** 过滤props并计算倒计时 */
  static getDerivedStateFromProps(nextProps, prevState) {
    if (nextProps.timeExpire !== prevState.timeExpire) {
      return {
        timeExpire: nextProps.timeExpire,
        countdown: calCountDown(nextProps.timeExpire),
      };
    }
    return null;
  }

  componentDidMount = ()=> {
    this.interval && cancelAnimationFrame(this.interval);
    this.handleCalculate();
  }

  componentWillUnmount() {
    this.interval && cancelAnimationFrame(this.interval);
    this.interval = null;
  }
  /** 倒计时定时器 */
  handleCalculate = ()=> {
    const { timeExpire, countdown: prevCountdown } = this.state;
    const { onEnd } = this.props;
    const countdown = calCountDown(timeExpire);
    this.interval = requestAnimationFrame(this.handleCalculate);

    if (prevCountdown !== countdown) {
      this.setState({
        countdown,
      });
      if (countdown === 0 || countdown === EndSecond) {
        onEnd && onEnd();
      }
    }
  }

  render() {
    const { title, onPress } = this.props;
    const { countdown } = this.state;
    return (
      <Button style={[{ width: getWidth(116), height: getWidth(58), marginLeft: -getWidth(7) }]} type="link" onPress={onPress}>
        <ImageBackground source={require('../../images/my/btn-primary.png')} style={[styles.btnSize2, RowCenter, { paddingTop: getWidth(5), paddingBottom: getWidth(9) }]}>
          <Text style={{ color: '#fff', fontSize: 13 }}>{title + (countdown > 0 ? '(' + countdown + 's)' : '')}</Text>
        </ImageBackground>
      </Button>
    );
  }
}

/** 店铺结算账户开通 */
const ActiveShopSection = ({
  visible = true, actived = true, activing = false, onPress, failed = false, hideButton = false,
}) => {
  if (visible) {
    return (
      <View style={styles.panel}>
        <View style={{ position: 'relative' }}>
          <ListItem title="店铺结算账户开通" titleStyle={styles.sectionTitle} style={{ paddingVertical: 0, marginVertical: 0 }} />
          <StatusLabel icon={actived ? activedIcon : activing ? payingIcon : failed ? failIcon : null} />
          {
            !activing && !hideButton && !actived ? (
              <View style={styles.body}>
                <View style={RowStart}>
                  <PrimaryButton title={failed ? '重新提交' : '立即开通'} onPress={onPress} />
                </View>
              </View>
            ) : null
          }
        </View>
      </View>
    );
  }
  return null;
};

/** 已支付状态 */
const PaiedTypeDescription = ({ paiedType = 'all', type = 'join', ratio }) => {
  switch (`${type}+${paiedType}`) {
    case 'join+all':
    case 'cash+all':
      return <Text style={styles.paiedText}>现金支付</Text>;
    case 'join+free': return <Text style={styles.paiedText}>申请免加盟费</Text>;
    case 'cash+free': return <Text style={styles.paiedText}>申请免保证金</Text>;
    case 'join+ratio': return (
      <Text style={styles.paiedText}>
        <Text>使用收益缴费</Text>
        <Text style={styles.paiedText2}>{`（每笔收益扣除${ratio}%）`}</Text>
      </Text>
    );
    case 'cash+offline': return <Text style={styles.paiedText}>线下缴纳保证金</Text>;
    default: return null;
  }
};

/** 加盟费 */
const ActiveJoinSection = ({
  actived = true, activing = false, paying = false, timeExpire , onPress, paiedType = 'all', tmpls = ['all', 'free', 'ratio'], tmplsList = [], account = 0, onRePay, onEnd,
}) => {
  const ratio = math.divide((tmplsList.find(item => item.payType === 'ratio') || {}).ratio || 0, 10);
  const canDo = (func)=> {
    const countdown = calCountDown(timeExpire);
    if (countdown > 0) {
      onRePay && onRePay(countdown, tmplsList.find(item => item.payType === 'all'));
      return;
    } else { func && func(); }
  };
  const paiedIconMap = {
    free: paiedIconJMF,
    all: paiedIcon,
    ratio: paiedIconSY,
  };
  return (
    <Panel
      style={[styles.panel, { paddingBottom: actived ? 0 : 10 }, !actived ? null : { position: 'relative' }]}
      bodyStyle={styles.body}
      title={<PanelTitle title="加盟费" price={account} />}
      headerStyle={[styles.header, { borderBottomWidth: actived ? 0 : 1 }]}
    >
      <View style={actived ? null : { position: 'relative' }}>
        {
          actived ? <StatusLabel icon={actived ? paiedIconMap[paiedType] : null} style={{ top: -getWidth(60) }} /> : <View><Text style={styles.sectionTitle}>缴费方式</Text></View>
        }
        {
          !actived && (!activing || paying)
            ? (
              <View style={RowStart}>
                <StatusLabel icon={paiedType === 'all' && paying ? paying2Icon : null} style={{ top: -getWidth(34) }} />
                {tmpls.includes('all') ? <PrimaryButton timeExpire={timeExpire} title="立即支付" onEnd={onEnd} onPress={() => {
                 canDo(()=> onPress('all', tmplsList.find(item => item.payType === 'all')));
                }} /> : null}
                {tmpls.includes('free') ? (
                  <Button
                    type="default"
                    style={styles.btnSize}
                    title="申请免加盟费"
                    titleStyle={styles.btnTitle}
                    onPress={() => {
                      canDo(()=> CustomAlert.onShow('confirm', '本申请需要平台审核，是否提交该申请？', '提示', () => onPress('free', tmplsList.find(item => item.payType === 'free'))));
                    }}
                  />
                ) : null}
                {tmpls.includes('ratio') ? (
                  <Button
                    type="default"
                    style={styles.btnSize}
                    onPress={() => {
                      canDo(()=>CustomAlert.onShow('confirm', `该方式会以每笔收益中扣除${ratio}%的形式扣除${account}元为止，确认选择该方式？`, '提示', () => onPress('ratio', tmplsList.find(item => item.payType === 'ratio'))));
                    }}
                  >
                    <DescriptTitle title="使用收益缴费" subtitle={`（每笔收益扣除${ratio}%）`} />
                  </Button>
                ) : null
                }
              </View>
            )
            : (!actived && activing)
              ? (
                <View style={RowStart}>
                  <StatusLabel icon={paiedType === 'all' ? paying2Icon : payingIcon} style={{ top: -getWidth(34) }} />
                  <PaiedTypeDescription paiedType={paiedType} type="join" ratio={ratio} />
                </View>
              )
              : null
        }
      </View>
    </Panel>
  );
};

/** 保证金 */
const ActiveCashSection = ({
  actived = false, activing = false, paying = false, timeExpire, onPress, paiedType = 'all', tmpls = ['all', 'free', 'offline'], tmplsList = [], account = 0, onRePay, onEnd,
}) => {
  const canDo = (func)=> {
    const countdown = calCountDown(timeExpire);
    if (countdown > 0) {
      onRePay && onRePay(countdown, tmplsList.find(item => item.payType === 'all'));
      return;
    } else { func && func(); }
  };
  const paiedIconMap = {
    free: paiedIconBZJ,
    all: paiedIcon,
    offline: paiedIcon,
  };
  return (
    <Panel
      style={[styles.panel, { paddingBottom: actived ? 0 : 10 }, !actived ? null : { position: 'relative' }]}
      bodyStyle={styles.body}
      title={<PanelTitle title="保证金" price={account} />}
      headerStyle={[styles.header, { borderBottomWidth: actived ? 0 : 1 }]}
    >
      <View style={actived ? null : { position: 'relative' }}>
        {
          actived ? <StatusLabel icon={actived ? paiedIconMap[paiedType] : null} style={{ top: -getWidth(60) }} /> : <View><Text style={styles.sectionTitle}>缴费方式</Text></View>
        }
        {
        !actived && (!activing || paying)
          ? (
            <View style={RowStart}>
              <StatusLabel icon={paiedType === 'all' && paying ? paying2Icon : null} style={{ top: -getWidth(34) }} />
              {tmpls.includes('all') ? <PrimaryButton timeExpire={timeExpire} title="立即支付" onEnd={onEnd}  onPress={() => {
                canDo(()=> onPress('all', tmplsList.find(item => item.payType === 'all')));
              }} /> : null }
              {tmpls.includes('free') ? (
                <Button
                  type="default"
                  style={styles.btnSize}
                  title="申请免保证金"
                  titleStyle={styles.btnTitle}
                  onPress={() => {
                    canDo(()=> CustomAlert.onShow('confirm', '本申请需要平台审核，是否提交该申请？', '提示', () => onPress('free', tmplsList.find(item => item.payType === 'free'))));
                  }}
                />
              ) : null }
              {tmpls.includes('offline')
                ? (
                  <Button
                    type="default"
                    style={styles.btnSize}
                    title="线下缴纳保证金"
                    titleStyle={styles.btnTitle}
                    onPress={() => {
                      canDo(()=> onPress('offline', tmplsList.find(item => item.payType === 'offline')));
                    }}
                  />
                ) : null }
            </View>
          )
          : (!actived && activing)
            ? (
              <View style={RowStart}>
                <StatusLabel icon={paiedType === 'all' ? paying2Icon : payingIcon} style={{ top: -getWidth(34) }} />
                <PaiedTypeDescription paiedType={paiedType} type="cash" />
              </View>
            )
            : null
        }
      </View>
    </Panel>
  );
};

/** 线下缴纳弹框 */
const OfflineContent = ({ rule = {}, onPress = () => {}, onShow = () => {} }) => {
  const offlineTransferAccounts = rule.offlineTransferAccounts || [];
  let ruleIndex = 1;
  const bankRule = offlineTransferAccounts.find(item => item.transferType === 'bank');
  const aliRule = offlineTransferAccounts.find(item => item.transferType === 'ali');
  const wxRule = offlineTransferAccounts.find(item => item.transferType === 'wx');

  const bankInfo = {
    visible: !!bankRule,
    index: bankRule ? ruleIndex++ : ruleIndex,
    rules: bankRule ? [
      { title: '户名', value: bankRule.accountName || '' },
      { title: '开户行', value: bankRule.bankName || '' },
      { title: '账号', value: bankRule.bankCardNo || '' },
    ] : [],
  };

  const aliInfo = {
    visible: !!aliRule,
    url: aliRule ? aliRule.qrCode : '',
    index: aliRule ? ruleIndex++ : ruleIndex,
    name: '支付宝',
  };

  const wxInfo = {
    visible: !!wxRule,
    url: wxRule ? wxRule.qrCode : '',
    index: wxRule ? ruleIndex++ : ruleIndex,
    name: '微信',
  };

  return (
    <TouchableOpacity activeOpacity={1} style={{ backgroundColor: WhiteColor, paddingBottom: CommonStyles.footerPadding }}>
      <View style={{ marginHorizontal: getWidth(35), marginVertical: getWidth(25) }}>
        <Text style={{ fontWeight: '500', fontSize: 17, color: TextColor }}>支付方式</Text>
      </View>
      <View style={{ marginHorizontal: getWidth(35), marginBottom: getWidth(20), display: bankInfo.visible ? 'flex' : 'none' }}>
        <View style={[RowStart, { marginBottom: getWidth(10) }]}>
          <ImageView source={numbers[`number${bankInfo.index}`]} sourceWidth={12} sourceHeight={12} />
          <Text style={{ color: '#999999', fontSize: 12, marginLeft: 8 }}>银行转账</Text>
        </View>
        <View style={styles.bankView}>
          {
            bankInfo.rules.map((item, index) => (
              <View
                key={item.title}
                style={{ flexDirection: 'row', alignItems: 'center', marginBottom: index === 2 ? 0 : 8 }}
              >
                <Text style={{ color: '#9399A5', fontSize: 12 }}>
                  {`${item.title}：`}
                </Text>
                <Text style={{ color: '#222', fontSize: 12 }}>{item.value}</Text>
              </View>
            ))
          }
        </View>
      </View>
      <View style={{ flexDirection: 'row', marginHorizontal: getWidth(35), marginBottom: getWidth(15) }}>
        {
          [aliInfo, wxInfo].map(item => (
            <TouchableOpacity
              key={item.name}
              style={{ marginRight: getWidth(25) }}
              onPress={() => {
                onShow({
                  showBigPicArr: [{ type: 'images', url: item.url }],
                  showBigModal: true,
                });
              }}
            >
              <View style={[RowStart, { marginBottom: 10 }]}>
                <ImageView source={numbers[`number${item.index}`]} sourceWidth={12} sourceHeight={12} />
                <Text style={{ color: '#999999', fontSize: 12, marginLeft: 8 }}>{item.name}</Text>
              </View>
              <ImageView style={{ marginTop: 8 }} source={{ uri: item.url }} sourceWidth={getWidth(135)} sourceHeight={getWidth(152)} />
            </TouchableOpacity>
          ))
        }
      </View>
      <View style={{ marginBottom: getWidth(20), marginHorizontal: getWidth(35) }}>
        <Text style={{
          color: CommonStyles.globalRedColor, fontSize: 12, marginTop: getWidth(10), paddingRight: getWidth(15),
        }}
        >
          {'*说明：转账请备注联盟商名称，以便平台快速处理'}
        </Text>
      </View>
      <Button type="primary" title="我已支付" onPress={() => onPress()} style={{ borderRadius: 0 }} />
    </TouchableOpacity>
  );
};

/** 订单正在支付中的弹框，提示用户已经在支付中 */
class OrderStatusModal extends Component {
  state = {
    countdown: 0,
  }

  componentWillUnmount() {
    this.interval && clearInterval(this.interval);
  }

  startCountDown(countdown) {
    const endTime = Date.now() + countdown * 1000;
    this.interval && clearInterval(this.interval);
    this.interval = setInterval(()=> {
      let _countdown = Math.floor((endTime - Date.now()) / 1000);
      this.setState({
        countdown: _countdown,
      });
      if (_countdown <= 0) {
        this.interval && clearInterval(this.interval);
        const { onClose } = this.props;
        onClose && onClose();
      }
    }, 450);

    this.setState({
      countdown,
    });
  }

  render() {
    const { visible, onClose, onRePay, onNext } = this.props;
    const { countdown } = this.state;
    return (
      <TouchableOpacity style={[styles.modalContent, !visible ? { width: 0} : {}]} onPress={()=> onClose && onClose()}>
          <TouchableOpacity style={styles.modalBody} activeOpacity={1}>
            <View>
              <Text style={styles.modalText}>您已经发起过一次支付，该支付正在确认中</Text>
              <Text style={styles.modalText}>如果您已完成支付，请耐心等待系统确认</Text>
              <Text style={styles.modalText}>如果您未完成支付，请尽快完成支付</Text>
              <Text style={styles.modalText}>{'如果您需要以其他方式缴费，请在' + countdown + 's后操作'}</Text>
            </View>
            <View style={styles.modalBtns}>
              <Button style={styles.modalBtn} type="primary" title="立即支付" onPress={()=> onRePay && onRePay()} />
              <Button style={styles.modalBtn} type="default" title="我已支付，等待系统确认" onPress={()=> onClose && onClose()} />
              <Button style={styles.modalBtn} type="default" title={countdown > 0 ? (countdown + 's后选择其他缴费方式') : '选择其他缴费方式'} onPress={()=> onNext && onNext()} />
            </View>
          </TouchableOpacity>
      </TouchableOpacity>
    );
  }
}

class AccountActiveScreen extends NavigationComponent {
  state = {
    visible: false,
    showBigPicArr: [],
    showBigModal: false,
    rule: {},
    options: [],
    actionType: 'join', // 当前操作的动作

    orderStatusVisible: false,
    orderRepayInfo: {},
    orderNextInfo: {},
  }

  blurState = {
    visible: false,
    showBigModal: false,
  }

  screenWillFocus = (payload) => {
    super.screenWillFocus(payload);
    this.onRefresh();
  }

  componentDidMount() {
    this.onRefresh();
    this.__mount = true;
  }

  componentWillUnmount = () => {
    if (this.timer) {clearInterval(this.timer);}
    this.__unmount = true;
  };

  onRefresh = () => {
    const { fetchPayTmpl } = this.props;
    fetchPayTmpl();
  }
  /** 点击按钮的处理函数 */
  pay = (type, payType, rule) => {
    const { orderRepayInfo } = this.state;
    if (orderRepayInfo[type] && this.orderStatusModal.state.countdown > 0) {
      this.setState({
        orderStatusVisible: true,
      });
      return;
    }
    switch (`${type}+${payType}`) {
      case 'cash+offline':
        this.setState({ visible: true, rule });
        break;
      case 'cash+all':
      case 'join+all':
        {
          const payChannel = rule.payChannel || [];
          if (payChannel.length === 0) {
            Toast.show('未找到支付模版');
            return;
          }
          this.ActionSheet.show((index) => {
            if (index < payChannel.length) {
              const channel = payChannel[index];
              this.props.pay(type, payType, { ...rule, channel });
            }
          });
          this.setState({
            options: payChannel.map(item => item.channelName),
          });
        }
        break;
      default:
        this.props.pay(type, payType, rule);
        break;
    }

    this.setState({
      actionType: type,
    });
    this.startAction();
  }
  /** 跳转到激活店铺账户 */
  navActiveShop = () => {
    const { navPage } = this.props;
    navPage('AccountActiveShop');
  }
  /** 显示支付中的提示弹框 */
  handlePaied = () => {
    const { rule } = this.state;
    this.props.pay('cash', 'offline', rule);
    this.setState({
      visible: false,
    });
  }
  /** 更新数据 */
  fetchAction = () => {
    const { payTmpl, fetchPayTmpl } = this.props;
    const { costStatus, costPayType, depositStatus, depositPayType } = payTmpl || {};
    if (['un_auth', 'auth'].includes(costStatus) && costPayType === 'all') {
      this.props.fetchPaiedInfo('cost');
    }

    if (['un_auth', 'auth'].includes(depositStatus) && depositPayType === 'all') {
      this.props.fetchPaiedInfo('join');
    }

    if (['fail'].includes(costStatus) || ['fail'].includes(depositStatus)) {
      fetchPayTmpl(false);
    }
  }
  /** 启动定时器，刷新数据 */
  startAction = () => {
    if (this.timer) {clearInterval(this.timer);}
    this.timer = setInterval(() => {
      if (this.__unmount) {return;}
      this.fetchAction();
    }, 2500);
  }
  /** 支付中弹框，重新支付 */
  handleRepay = ()=> {
    const { orderRepayInfo } = this.state;
    const { type, payType, rule } = orderRepayInfo || {};
    this.pay(type, payType, rule);
  }
  /** 倒计时结束，获取支付状态 */
  handleEndCoundDown = (type)=> {
    this.props.fetchPaiedInfo(type);
  }
  /** 显示支付中弹框 */
  handleShowRepay = (type, countdown, _rule = {}, payChannel)=> {
    this.orderStatusModal.startCountDown(countdown);
    const rule = {
      ..._rule,
      payChannel: (_rule.payChannel || []).filter((channel)=> !payChannel || channel.channelKey ===  payChannel),
    };
    this.setState({
      orderStatusVisible: true,
      orderRepayInfo: {
        type,
        payType: 'all',
        rule,
      },
    });
  }

  render() {
    const {
      activeInfo = {}, refreshing, payTmpl = {}, merchant = [],
    } = this.props;
    const {
      costStatus, costAmount, cost = [], depositStatus, depositAmount, deposit = [],
    } = payTmpl || {};
    const { merchantType } = activeInfo;
    const auditStatus = (merchant.find(item => item.merchantType === merchantType) || {}).auditStatus;
    const actived = auditStatus === 'active';
    const {
      visible, showBigPicArr, showBigModal, rule, options, orderStatusVisible,
    } = this.state;

    const joinSectionProps = {
      paiedType: payTmpl.costPayType,
      actived: costStatus === 'success', // 已激活
      activing: costStatus === 'un_auth', // 激活中
      paying: costStatus === 'un_auth' && payTmpl.costPayType === 'all', // 支付中
      timeExpire: payTmpl.costTimeExpire, // 支付中倒计时间
      payChannel: payTmpl.costPayChannel, // 支付方式
      account: keepTwoDecimal(math.divide(costAmount, 100)),
      tmpls: (cost || []).map(item => item.payType), // 支付方式列表
      tmplsList: cost, // 支付模版
    };

    const cashSectionProps = {
      paiedType: payTmpl.depositPayType,
      actived: depositStatus === 'success',
      activing: depositStatus === 'un_auth',
      paying: depositStatus === 'un_auth' && payTmpl.depositPayType === 'all',
      timeExpire: payTmpl.depositTimeExpire,
      payChannel: payTmpl.depositPayChannel,
      account: keepTwoDecimal(math.divide(depositAmount, 100)),
      tmpls: (deposit || []).map(item => item.payType),
      tmplsList: deposit,
    };

    const shopProps = {
      visible: merchantType === 'shops',
      activing: payTmpl.authStatus === 'SUBMIT',
      actived: payTmpl.authStatus === 'SUCCESS',
      failed: payTmpl.authStatus === 'FAILED',
      hideButton: actived,
      partnerId: payTmpl.partnerId,
    };

    const tips = merchantType !== 'shops' ? '*成功缴纳加盟费及保证金即可激活该身份' : '*成功缴费和开通支付账户即可激活该身份';

    return (
      <View style={styles.container}>
        <Header title={actived ? '已激活' : '未激活'} goBack />
        <ScrollView
          contentContainerStyle={[FlexStart, { alignItems: 'flex-start' }]}
          refreshControl={(
            <RefreshControl
              onRefresh={() => this.onRefresh()}
              refreshing={refreshing}
            />
          )}
        >
          <View style={{ marginHorizontal: getWidth(25), marginTop: getWidth(11) }}>
            <Text style={{ color: WarningColor }}>{tips}</Text>
          </View>
          <ActiveJoinSection
            {...joinSectionProps}
            onEnd={()=> this.handleEndCoundDown('join')}
            onPress={(payType, _rule) => this.pay('join', payType, _rule)}
            onRePay={(countdown, _rule)=> this.handleShowRepay('join', countdown, _rule, joinSectionProps.payChannel)}
          />
          <ActiveCashSection
            {...cashSectionProps}
            onEnd={()=> this.handleEndCoundDown('cash')}
            onPress={(payType, _rule) => this.pay('cash', payType, _rule)}
            onRePay={(countdown, _rule)=> this.handleShowRepay('cash', countdown, _rule, cashSectionProps.payChannel)}
          />
          <ActiveShopSection {...shopProps} onPress={() => this.navActiveShop()} />
          <ActionSheet
            ref={dom => this.ActionSheet = dom}
            options={options.concat('取消')}
            cancelButtonIndex={options.length}
          />
          <ShowBigPicModal
            ImageList={showBigPicArr}
            visible={showBigModal}
            showImgIndex={0}
            onClose={() => {
              this.setState({
                showBigModal: false,
              });
            }}
          />
        </ScrollView>
        <OrderStatusModal
            visible={orderStatusVisible}
            ref={dom=> this.orderStatusModal = dom }
            onClose={()=> this.setState({ orderStatusVisible: false })}
            onRePay={()=> this.handleRepay()}
            onNext={()=> this.setState({ orderStatusVisible: false })}
        />
        <View style={ visible ? { position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, display: 'flex'} : { width: WindowWidth, height: 0, overflow: 'hidden' }}>
          <TouchableOpacity style={{ flex: 1, backgroundColor: MaskColor, justifyContent: 'flex-end' }} activeOpacity={1} onPress={() => this.setState({ visible: false })}>
            <OfflineContent rule={rule} onShow={payload => this.setState(payload)} onPress={() => this.handlePaied()} />
          </TouchableOpacity>
        </View>
      </View>
    );
  }
}

export default connect(state => ({
  activeInfo: state.userActive.activeInfo,
  paiedInfo: state.userActive.paiedInfo,

  payTmpl: state.userActive.payTmpl,
  merchant: state.user.merchant || [],
  refreshing: state.loading.effects['userActive/fetchPayTmpl'],
}), {
  fetchPayTmpl: (loading) => ({ type: 'userActive/fetchPayTmpl', payload: { loading } }),
  fetchPaiedInfo: type => ({ type: 'userActive/fetchPaiedInfo', payload: { type } }),
  navPage: (routeName, params = {}) => ({ type: 'userActive/navPage', payload: { routeName, params } }),
  checkedUserActive: (callback, merchantType, familyUp = false) => ({ type: 'userActive/checkedUserActive', payload: { merchantType, familyUp, callback } }),
  pay: (type, payType, context, callback) => ({ type: 'userActive/pay', payload: { type, payType, context, callback } }),
})(AccountActiveScreen);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    paddingBottom: CommonStyles.footerPadding,
    backgroundColor: CommonStyles.globalBgColor,
  },
  panel: {
    marginHorizontal: getWidth(10),
    paddingHorizontal: getWidth(15),
    width: getWidth(355),
    backgroundColor: '#fff',
    borderRadius: 8,
    marginTop: SmallMargin,
    paddingBottom: SmallMargin,
    overflow: 'visible',
  },
  header: {
    paddingTop: 20,
    paddingBottom: 24,
  },
  body: {
    paddingHorizontal: 0,
  },
  title: {
    color: '#666',
    fontSize: 14,
    marginRight: 15,
  },
  price: {
    color: YellowColor,
  },
  priceNumber: {
    fontSize: 20,
  },
  sectionTitle: {
    marginTop: 20,
    marginBottom: 10,
    fontSize: 14,
    color: '#666',
  },
  btnSize2: {
    width: getWidth(116),
    height: getWidth(58),
  },
  btnSize: {
    width: getWidth(102),
    height: getWidth(44),
    borderRadius: 6,
    backgroundColor: '#F8F8F8',
    marginLeft: getWidth(2),
    marginRight: getWidth(8),
    marginTop: getWidth(-2),
  },
  btnTitle: {
    color: '#666',
    fontSize: 13,
    textAlign: 'center',
  },
  btnSubTitle: {
    fontSize: 9,
  },
  paiedText: {
    fontSize: 17,
    color: '#222',
    fontWeight: '500',
    marginBottom: 10,
  },
  paiedText2: {
    fontSize: 12,
    color: '#666',
    fontWeight: '400',
  },
  bankView: {
    backgroundColor: '#F8F9FA',
    paddingHorizontal: getWidth(15),
    paddingVertical: getWidth(15),
  },
  modalContent: {
    flex: 1,
    width: WindowWidth,
    backgroundColor: MaskColor,
    justifyContent: 'center',
    alignItems: 'center',
    overflow: 'hidden',
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    top: 0,
  },
  modalBody: {
    width: WindowWidth - getWidth(15),
    backgroundColor: WhiteColor,
    borderRadius: getWidth(4),
    padding: getWidth(15),
  },
  modalText: {
    color: TextSecondColor,
    fontSize: 17,
    marginBottom: 8,
  },
  modalBtns: {
    marginTop: getWidth(15),
  },
  modalBtn: {
    marginBottom: getWidth(15),
  },
});
