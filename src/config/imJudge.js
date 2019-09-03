import { Platform } from 'react-native';
import AudioPlayer from '@scxkkj/react-native-audio-player';
import * as requestApi from './requestApi';
import * as nativeApi from './nativeApi';

import { ORDER_STATUS_ONLINE } from '../const/order';
import { showForzenToast } from './request';

const customMessageTypeMap = {
  has_timer_msg: 9910001, // 安卓自定义消息
  frozen_user: 992001, // 冻结商户
};

const mp3List = {
  20001: require('../../assets/audio/20001.mp3'), // ok
  20002: require('../../assets/audio/20002.mp3'),
  20004: require('../../assets/audio/20004.mp3'), // ok
  20005: require('../../assets/audio/20005.mp3'), // ok
  20007: require('../../assets/audio/20007.mp3'),
  20009: require('../../assets/audio/20009.mp3'),
  20013: require('../../assets/audio/20013.mp3'), // ok
  400031: require('../../assets/audio/400031.mp3'), // ok
  400032: require('../../assets/audio/400032.mp3'), // ok
  400033: require('../../assets/audio/400033.mp3'), // ok
};

const orderNextAction = (params) => {
  const routeParam = {
    orderId: params.orderId,
    shopId: params.shopId,
    isShouhou: params.orderType === 'REFUND' && params.refundType !== 1 ? true : false,
  };
  let route = '';
  switch (params.orderScene) {
    case 'SERVICE_OR_STAY': route = 'AccommodationOrder'; break;// 服务或者住宿类
    case 'ON_LINE_TAKE_OUT':
    case 'TAKE_OUT': route = 'GoodsTakeOut'; break;// 外卖   售后
    case 'LOCALE_BUY': route = 'GoodsSceneConsumption'; break;// 现场消费E
    case 'SERVICE_AND_LOCALE_BUY': route = 'StayStatementOrder'; break;// 服务+现场消费+加购
    case 'SHOP_HAND_ORDER': route = 'OfflneOrder'; break;// 线下订单
    default:
      break;
  }
  if (route) {
    app._store.dispatch({ type: 'system/navPage', payload: { routeName: route, params: routeParam } });
    app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules: ['shops.ordermanage'], flag: false } });
  } else {
    Toast.show(`参数传递出错:params.orderScene:${params.orderScene}`);
  }
};
/** 系统消息模块 */
const systemMessageModules = {
  '001': { code: '001', title: '系统消息', modules: ['user.system.systemMessage'] },
  '004': { code: '004', title: '自营商城消息', modules: ['user.system.selfMall'] },
  '005': { code: '005', title: '福利商城消息', modules: ['user.system.wfMall'] },
  '006': { code: '006', title: '抽奖', modules: ['user.system.choujiangMessage'] },
};

/** 系统消息 */
const systemMessage = ({ code = '001', title = '系统消息', modules = ['user.system.systemMessage'] }) => { // 系统消息处理
  app._store.dispatch({ type: 'system/navPage', payload: { routeName: 'Message', params: { code, title } } });
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules: ['user.system.systemMessage'], flag: false } });
};

/** 插入审核、任务、验收中心 */
const acceptanceCenter = (page) => { // 系统消息处理
  app._store.dispatch({ type: 'system/navPage', payload: { routeName: 'TaskHome', params: { page } } });
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules: [`user.${page}`], flag: false } });
};

/**
 * 插入系统消息
 */
const insertSystemMessage = (msg, { code = '001', modules = ['user.system.systemMessage'] }) => {
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules, flag: true } });
  app._store.dispatch({ type: 'application/changeMessageDesc', payload: { code, msg } });
  const msgCodes = [
    '40009', // 资料审核通过
    '400010', // 修改资料审核未通过
    '400016',//资料审核未通过
    '400026', // 入驻资料审核通过
    '400072',//成功激活
  ];
  if (msgCodes.find(item => item == msg.msgType)) { // 有关联盟商入驻审核的消息
    app._store.dispatch({ type: 'user/getMerchantHome', payload: {} });
  } if (msg.msgType == 400022 || msg.msgType == 400021) { // 店铺审核
    app._store.dispatch({ type: 'shop/getShopDetail' });
  }
};

/** 插入其它消息 */
const otherMessage = ({ modules = ['user.system.systemMessage'] }) => {
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules, flag: true } });
};

/** 物流订单 */
const wuliuOrderDetails = (item) => {
  // 校验参数
  if (item.shopId && item.goodsOrderNo && item.orderNo) {
    app._store.dispatch({
      type: 'system/navPage',
      payload: {
        routeName: 'GoodsTakeOut',
        params: {
          page: 'imJudge',
          orderId: item.goodsOrderNo,
          shopId: item.shopId,
          orderNo: item.orderNo,
        },
      },
    });
  }
};
/** 入驻 */
const myApplyForm = (item) => {
  if (item.merchantType) {
    const nameMap = {
      anchor: '主播',
      familyL1: '家族长',
      familyL2: '公会',
      shops: '商户',
      company: '合伙人',
      personal: '个人',
    };
    app._store.dispatch({
      type: 'system/navPage',
      payload: {
        routeName: 'MyApplyForm',
        params: {
          merchantType: item.merchantType,
          page: 'register',
          editor: true,
          auditStatus: 'fail',
          name: nameMap[item.merchantType] || '申请资料',
        },
      },
    });
  }
};

/** 跳转夺奖派对、抽奖详情 */
const wmOrderDetails = (item) => {
  Loading.show();
  requestApi.qureyWMOrderDetail({ orderId: item.orderId }).then((res) => {
    app._store.dispatch({
      type: 'welfare/listNavigation',
      payload: {
        params: res,
      },
    });
  }).catch(err => {
    console.log(err)
  });
};

/** 夺奖派对售后 */
const refundDetail = (item) => {
  if (!item.refundId) return;
  app._store.dispatch({
    type: 'system/navPage',
    payload: {
      routeName: 'WMGoodsDamagResult',
      params: {
        orderData: {
          refundId: item.refundId,
        },
      },
    },
  });
};
/** 批发商城 */
const somOrderDetails = (item) => {
  if (!item.orderId) return;
  Loading.show();
  requestApi.queryMallOrderDetail({ orderId: item.orderId }).then((data) => {
    let tabsIndex = [[], ['PRE_PAY'], ['PRE_SHIP'], ['PRE_RECEVICE'], ['PRE_EVALUATE'], ['COMPLETELY']].findIndex(array => array.indexOf(data.orderStatus) !== -1);
    if (data.goodsInfo && data.goodsInfo.find(itemGood => itemGood.refundStatus != 'NONE')) {
      tabsIndex = 6;
    }
    console.log('SOMOrderDetails', data, tabsIndex);
    app._store.dispatch({
      type: 'system/navPage',
      payload: {
        routeName: 'SOMOrder',
        params: {
          tabsIndex,
        },
      },
    });
  }).catch(err => {
    console.log(err)
  });
};
/** 评价管理 */
const commentManage = (item) => {
  if (!item.shopId) return;
  app._store.dispatch({
    type: 'system/navPage',
    payload: {
      routeName: 'Comment',
      params: {
        shopId: item.shopId,
      },
    },
  });
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules: ['shops.commentmanage'], flag: false } });
};

/** 跳转首页 */
const toHomePage = () => {
  app._store.dispatch({
    type: 'system/resetToHome',
    payload: {
      params: {
        pageFrom: 'imJudge',
        action: 'toHomePage',
      },
    },
  });
  app._store.dispatch({ type: 'application/changeMessageModules', payload: { modules: ['user.system.systemMessage'], flag: false } });
};

/** 未知消息 */
const customMessage = () => {
  app._store.dispatch({
    type: 'system/resetToHome',
    payload: {
      params: {
        pageFrom: 'imJudge',
        action: 'customMessage',
      },
    },
  });
};
/** 抽奖中心 */
const prizeMessage = () => {
  app._store.dispatch({ type: 'system/navPage', payload: { routeName: 'PrizeMessage', params: {} } });
};
/** 订单页面 */
const orderTabMessage = ({
  orderId, orderStatus, orderType, redPoint,
}) => {
  if (orderId && orderStatus && orderType) {
    if (orderType.toUpperCase() === 'REFUND') {
      redPoint === 1 && otherMessage({ modules: ['orderlist.tabs.SHOUHOU'] });
      return;
    }
    if (orderType.toUpperCase() === 'NORMAL' && ['STAY_ORDER', 'STAY_CONSUMPTION', 'STOCK_CENTRE', 'CONSUMPTION_CENTRE', 'AGREE_PAY'].includes(orderStatus)) {
      const _orderStatus = ORDER_STATUS_ONLINE[orderStatus];
      _orderStatus && otherMessage({ modules: [`orderlist.tabs.${_orderStatus}`] });
    }
  }
};

// im推送判断推送类型进行逻辑处理
export const imJudge = (extras) => {
  console.log('----------推送的消息----------', extras);
  /** 自定义消息 */
  if (customMessageTypeMap[extras.msgType]) {
    extras.msgType = customMessageTypeMap[extras.msgType];
  }

  switch (parseInt(extras.msgType, 10)) {
    // 自营商城
    case 10005: somOrderDetails(extras); break;// 9,用户确认收货。提示进行评价
    case 10006: break;// 9,用户取消支付
    case 10007: somOrderDetails(extras); break;// 2，平台已发货，提示用户已发货，并附带物流单号
    case 10008: somOrderDetails(extras); break;// 4，平台同意退货申请，提示用户进行回寄操作
    case 10009: somOrderDetails(extras); break;// 5，平台拒绝用户的售后申请，提示用户，附带拒绝原因
    case 10010: somOrderDetails(extras); break;// 7，平台同意退款后，提示用户
    case 10011: somOrderDetails(extras); break;// 8，退款转账完毕后，提示用户
    case 10012: somOrderDetails(extras); break;// 11,平台确认收货。您退货的商品平台已签收
    case 10013: prizeMessage(); break; // 13, 您的订单：xxxxxx已完成，晓可赠送您一次xx抽奖机会，去抽奖！
    case 10016: somOrderDetails(extras); break; // 用户申请售后，提醒用户：您的退款申请已提交，请等待系统审核！
    case 10017: somOrderDetails(extras); break; //  用户支付成功后，提醒用户：您已支付成功，系统将尽快为你发货！
    // 商圈订单
    case 20001: orderNextAction(extras); break;// 1，用户下单后，提示商家接单
    case 20002: orderNextAction(extras); break;// 2，用户付款后，外卖类需要提示商家备货    ---没有推送
    case 20003: break;// 3，纯服务类，到达预定时间，因用户未到店关闭订单的，提示用户
    case 20004: orderNextAction(extras); break;// 4，用户发起加购订单，提示商户进行接单
    case 20005: orderNextAction(extras); break;// 5，用户发起取消/退款订单申请，提示商户进行确认   --后端跑错
    case 20006: orderNextAction(extras); break;// 6，加购场景，用户发起加购付款，提示商户确认
    case 20007: orderNextAction(extras); break;// 7，用户付款成功，提示商户已付款              --没有推送消息
    case 20008: orderNextAction(extras); break;// 8，用户删除加购订单，需提示商户,附带原因
    case 20009: orderNextAction(extras); break;// 9，用户取消加购订单，需提示商户,附带原因
    case 20010: orderNextAction(extras); break;// 10，用户发起退款加购订单，需提示商户,附带原因
    case 20011: orderNextAction(extras); break;// 11，用户发起结算
    case 20012: orderNextAction(extras); break;// 12，用户发起最终结算
    case 20013: orderNextAction(extras); break;// 13，用户发起最终付款
    case 20014: orderNextAction(extras); break;// 14，用户发起了差额补退(定金付了500，实际消费了300)

    case 20031: break;// 30，商家接单时，若修改了订单信息，需提示用户
    case 20032: break;// 31，商户拒绝接单，提示用户，并附带原因
    case 20033: break;// 32，商家接单后，需要付款的订单，提示用户付款
    case 20034: break;// 33，若商家拒绝接加购单，提示用户，并附带拒绝原因
    case 20035: break;// 34，商户同意退款/取消申请，发送消息提示用户
    case 20036: break;// 35，商户拒绝退款/取消申请，提示用户并附带拒绝原因

    case 20037: break;// 36，外卖类，商家已发货，提示用户
    case 20038: break;// 37，加购场景，商户确认用户发起的付款，提示用户进行付款
    case 20039: break;// 38，商户同意用户加购的售后申请，提示用户
    case 20040: break;// 39，商户拒绝用户加购的售后申请，提示用户，附带原因
    case 20041: break;// 40，可加购场景，若商户加购用户的订单（排除线下下单），需提示用户
    case 20042: break;// 41，用户发起付款，商家进行确认，并修改了金额，需提示用户
    case 20043: break;// 42，商户删除加购订单，需提示用户,附带原因
    case 20044: break;// 43，商户取消订单，需提示用户,附带原因
    case 20045: break;// 43，商户确认用户到店消费
    case 20046: break; // 44，外卖类，商户确认已送达
    case 20050: break; // 50. 系统自动评价
    case 20051: orderNextAction(extras); break; // 51. 客户预约时间即将到期，请及时联系客户

    case 20052: commentManage(extras); break; // 00752 您有新的店铺评价，请查看. 跳转评价列表页
    case 20056: break; //  提醒用户进行评价
    case 20057: orderNextAction(extras); break; // 外卖类，用户确认收货，提醒商户

      // 福利商城
    case 30003: break; // 00503 3，平台已发货，提示用户已发货，并附带物流单号
    case 30004: refundDetail(extras); break; // 00504 4，平台同意报损申请，提示用户进行回寄操作
    case 30005: refundDetail(extras); break; // 00505 5，平台拒绝用户的报损申请，提示用户，附带拒绝原因
    case 30009: wmOrderDetails({ ...extras, type: 2 }); break; // 00509 9，中奖提醒用户
    case 30010: wmOrderDetails({ ...extras, type: 2 }); break; // 00507 10，未中奖提醒用户
    case 30011: systemMessage(systemMessageModules['005']); break; // 00511 11，晒单通过
    case 30012: systemMessage(systemMessageModules['005']); break; // 00512 12，晒单未通过
    case 30018: wmOrderDetails({ ...extras, type: 2 }); break; // 00509 9，中奖提醒用户

    case 40004: systemMessage(systemMessageModules['001']); break; // 00103, 您注销了账号:(账号名)，该账号将无法继续使用
    case 40005: systemMessage(systemMessageModules['001']); break; // 00104, 您修改了账号：（账号名）的资料，立即生效
    case 40006: systemMessage(systemMessageModules['001']); break; // 00105, 您修改了账号：（账号名）的权限，立即生效
    case 40007: systemMessage(systemMessageModules['001']); break; // 00106, 您重置了账号：（账号名）的密码，立即生效
    case 40008: systemMessage(systemMessageModules['001']); break; // 00107, 您的XX联盟商资料已提交修改，请等待系统审核

    case 40009: systemMessage(systemMessageModules['001']); break; // 00108, 您的XX联盟商资料已通过审核，立即生效
      // toHomePage(); break; // 00108, 您的XX联盟商资料已通过审核，立即生效

    case 400010: systemMessage(systemMessageModules['001']); break; // 00109, 您的XX联盟商资料:XXXX等内容，未通过审核,请重新提交

    case 400011: systemMessage(systemMessageModules['001']); break; // 00110, 您的账号资料被修改，请查看
    case 400015: systemMessage(systemMessageModules['001']); break; // 00114, 您的晓可广场联盟商分号已创建成功，可登录使用
    case 400016: myApplyForm(extras); break; // 00115, 入驻资料审核未通过，请重新提交

    case 400017: acceptanceCenter('taskcore'); break; // 00116, 您有新的验收任务，请及时查看
    case 400018: acceptanceCenter('taskcore'); break; // 00117, 您有新的审核任务，请及时查看
    case 400019: acceptanceCenter('taskcore'); break; // 00118, 您有新的任务，请及时查看
    case 400020: acceptanceCenter('taskcore'); break; // 00119, 您的任务未验收通过，请及时修改

    case 400021: systemMessage(systemMessageModules['001']); break; // 00121, 店铺审核成功
    case 400022: systemMessage(systemMessageModules['001']); break; // 00122, 店铺审核失败

    case 400023: systemMessage(systemMessageModules['001']); break; // 00123, 店铺被绑定，您的店铺XXXXXX已被XXXXX店铺绑定
    case 400024: systemMessage(systemMessageModules['001']); break; // 00124, 店铺解绑成功，
    case 400025: systemMessage(systemMessageModules['001']); break; // 00125, 店铺绑定其他店铺，您已成功绑定XXXXX店铺

    case 400026: toHomePage(); break; // 00126, 您的入驻资料已审核通过，可正常使用 跳转首页
    case 400027: acceptanceCenter('taskcore'); break; // 00127, 您的任务未审核通过，请及时修改
    case 400028: systemMessage(systemMessageModules['001']); break; // 00128, 充值晓可币后发消息

    case 400030: wuliuOrderDetails(extras); break; // 00130, 订单xxx骑手已接单，跳转派送订单详情页
    case 400031: wuliuOrderDetails(extras); break; // 00131, 订单xxx骑手已到店，跳转派送订单详情页
    case 400032: wuliuOrderDetails(extras); break; // 00132, 订单xxx已被骑手拒绝接单,请及时查看，跳转商品订单详情页
    case 400033: wuliuOrderDetails(extras); break; // 00133, 订单xxx已被骑手取消,请重新派单，跳转派送订单详情页
    case 400034: wuliuOrderDetails(extras); break; // 00134, 订单xxx骑手已到达目的地，跳转派送订单详情页

    case 400050: systemMessage(systemMessageModules['001']); break; // 00150, 您上传的福利商品XXXXXX已通过审核，请及时登录后台查看
    case 400051: systemMessage(systemMessageModules['001']); break; // 00151, 您上传的福利商品XXXXXXX被系统下架，请及时登录后台查看

    case 400064: systemMessage(systemMessageModules['001']); break; // 00164 入驻资料审核通过
    case 400065: systemMessage(systemMessageModules['001']); break; // 00165 入驻资料审核未通过审核
    case 400066: systemMessage(systemMessageModules['001']); break; // 00166 免保证金审核通过
    case 400067: systemMessage(systemMessageModules['001']); break; // 00167 免保证金审核未通过
    case 400068: systemMessage(systemMessageModules['001']); break; // 00168 免加盟费审核通过
    case 400069: systemMessage(systemMessageModules['001']); break; // 00169 免加盟费审核未通过
    case 400070: systemMessage(systemMessageModules['001']); break; // 00170 结算账户通过审核
    case 400071: systemMessage(systemMessageModules['001']); break; // 00171 结算账户未通过审核
    case 400072: systemMessage(systemMessageModules['001']); break; // 00172 身份成功激活
    case 400073: systemMessage(systemMessageModules['001']); break; // 00173 家族升级提交成功
    case 400074: systemMessage(systemMessageModules['001']); break; // 00174 家族升级通过审核
    case 400075: systemMessage(systemMessageModules['001']); break; // 00175 家族升级未通过审核
    case 400076: systemMessage(systemMessageModules['001']); break; // 00176 联盟商信息修改提交成功
    case 400077: systemMessage(systemMessageModules['001']); break; // 00177 联盟商信息修改通过审核
    case 400078: systemMessage(systemMessageModules['001']); break; // 00178 联盟商信息修改未通过审核

    case 60001: wmOrderDetails(extras); break; // 平台推送奖品码给用户
    case 60002: wmOrderDetails(extras); break; // 平台抽奖推送消息
    case 60003: wmOrderDetails(extras); break; // 店铺抽奖平台发货
    case 60006: wmOrderDetails(extras); break; // 商铺发送抽奖券消息
    default:
      customMessage();
      break;
  }
};

// 小红点逻辑判断，有新消息到来的时候，更新小红点
export const moduleJudge = async (extras, isRealTime = false) => {
  const state = app._store.getState();
  try {
    const myModel = state.my || {};
    const mySettings = myModel.settings || {};
    if (mySettings.switchShopMsg && mp3List[extras.msgType] && isRealTime) {
      const audioPlaying = await AudioPlayer.isPlaying();
      if (!audioPlaying) {
        await AudioPlayer.setDataSource(mp3List[extras.msgType]);
        AudioPlayer.seekTo(0);
        AudioPlayer.start();
      }
    }
  } catch (error) {
    Toast.show(`播放声音错误:${error.message}`);
  }
  /** 自定义消息 */
  if (customMessageTypeMap[extras.msgType]) {
    extras.msgType = customMessageTypeMap[extras.msgType];
  }
  switch (parseInt(extras.msgType, 10)) {
    // 自营商城
    case 10005: insertSystemMessage(extras, systemMessageModules['004']); break;// 9,用户确认收货。提示进行评价
    case 10006: break;// 9,用户取消支付
    case 10007: insertSystemMessage(extras, systemMessageModules['004']); break;// 2，平台已发货，提示用户已发货，并附带物流单号
    case 10008: insertSystemMessage(extras, systemMessageModules['004']); break;// 4，平台同意退货申请，提示用户进行回寄操作
    case 10009: insertSystemMessage(extras, systemMessageModules['004']); break;// 5，平台拒绝用户的售后申请，提示用户，附带拒绝原因
    case 10010: insertSystemMessage(extras, systemMessageModules['004']); break;// 7，平台同意退款后，提示用户
    case 10011: insertSystemMessage(extras, systemMessageModules['004']); break;// 8，退款转账完毕后，提示用户
    case 10012: insertSystemMessage(extras, systemMessageModules['004']); break;// 11,平台确认收货。您退货的商品平台已签收
    case 10013: break; // 13, 您的订单：xxxxxx已完成，晓可赠送您一次xx抽奖机会，去抽奖！
    case 10016: insertSystemMessage(extras, systemMessageModules['004']); break; // 用户申请售后，提醒用户：您的退款申请已提交，请等待系统审核！
    case 10017: insertSystemMessage(extras, systemMessageModules['004']); break; //  用户支付成功后，提醒用户：您已支付成功，系统将尽快为你发货！

    case 20001: orderTabMessage(extras); extras.orderId && extras.orderStatus === ORDER_STATUS_ONLINE.STAY_ORDER && otherMessage({ modules: [`shops.ordermanage.orderId.${extras.orderId}`] }); break;// 1，用户下单后，提示商家接单
    case 20002: orderTabMessage(extras); break; // 此处外卖类是到备货中 otherMessage({ modules: [`orderlist.tabs.${ORDER_STATUS_ONLINE.STAY_CONSUMPTION}`] }); break;// 2，用户付款后，外卖类需要提示商家备货    ---没有推送
    case 20003: break;// 3，纯服务类，到达预定时间，因用户未到店关闭订单的，提示用户
    case 20004: orderTabMessage(extras); break;// 4，用户发起加购订单，提示商户进行接单
    case 20005: orderTabMessage(extras); break;// 5，用户发起取消/退款订单申请，提示商户进行确认   --后端跑错
    case 20006: orderTabMessage(extras); break;// 6，加购场景，用户发起加购付款，提示商户确认
    case 20007: orderTabMessage(extras); break;// 7，用户付款成功，提示商户已付款              --没有推送消息
    case 20008: orderTabMessage(extras); break;// 8，用户删除加购订单，需提示商户,附带原因
    case 20009: orderTabMessage(extras); break;// 9，用户取消加购订单，需提示商户,附带原因
    case 20010: orderTabMessage(extras); break;// 10，用户发起退款加购订单，需提示商户,附带原因
    case 20011: orderTabMessage(extras); break;// 11，用户发起结算
    case 20012: orderTabMessage(extras); break;// 12，用户发起最终结算
    case 20013: orderTabMessage(extras); break;// 13，用户发起最终付款
    case 20014: orderTabMessage(extras); break;// 14，用户发起了差额补退(定金付了500，实际消费了300)

    case 20031: break;// 30，商家接单时，若修改了订单信息，需提示用户
    case 20032: break;// 31，商户拒绝接单，提示用户，并附带原因
    case 20033: break;// 32，商家接单后，需要付款的订单，提示用户付款
    case 20034: break;// 33，若商家拒绝接加购单，提示用户，并附带拒绝原因
    case 20035: break;// 34，商户同意退款/取消申请，发送消息提示用户
    case 20036: break;// 35，商户拒绝退款/取消申请，提示用户并附带拒绝原因

    case 20037: break;// 36，外卖类，商家已发货，提示用户
    case 20038: break;// 37，加购场景，商户确认用户发起的付款，提示用户进行付款
    case 20039: break;// 38，商户同意用户加购的售后申请，提示用户
    case 20040: break;// 39，商户拒绝用户加购的售后申请，提示用户，附带原因
    case 20041: break;// 40，可加购场景，若商户加购用户的订单（排除线下下单），需提示用户
    case 20042: break;// 41，用户发起付款，商家进行确认，并修改了金额，需提示用户
    case 20043: break;// 42，商户删除加购订单，需提示用户,附带原因
    case 20044: break;// 43，商户取消订单，需提示用户,附带原因
    case 20045: break;// 43，商户确认用户到店消费

    case 20052: otherMessage({ modules: ['shops.commentmanage'] }); break; // 00752 您有新的店铺评价，请查看

    case 30003: insertSystemMessage(extras, systemMessageModules['005']); break; // 00503 3，平台已发货，提示用户已发货，并附带物流单号
    case 30004: insertSystemMessage(extras, systemMessageModules['005']); break; // 00504 4，平台同意报损申请，提示用户进行回寄操作
    case 30005: insertSystemMessage(extras, systemMessageModules['005']); break; // 00505 5，平台拒绝用户的报损申请，提示用户，附带拒绝原因
    case 30009: insertSystemMessage(extras, systemMessageModules['005']); break; // 00509 9，中奖提醒用户
    case 30010: insertSystemMessage(extras, systemMessageModules['005']); break; // 00507 10，未中奖提醒用户
    case 30011: insertSystemMessage(extras, systemMessageModules['005']); break; // 00511 11，晒单通过
    case 30012: insertSystemMessage(extras, systemMessageModules['005']); break; // 00512 12，晒单未通过

    case 40004: insertSystemMessage(extras, systemMessageModules['001']); break; // 00103, 您注销了账号:(账号名)，该账号将无法继续使用
    case 40005: insertSystemMessage(extras, systemMessageModules['001']); break; // 00104, 您修改了账号：（账号名）的资料，立即生效
    case 40006: insertSystemMessage(extras, systemMessageModules['001']); break; // 00105, 您修改了账号：（账号名）的权限，立即生效
    case 40007: insertSystemMessage(extras, systemMessageModules['001']); break; // 00106, 您重置了账号：（账号名）的密码，立即生效
    case 40008: insertSystemMessage(extras, systemMessageModules['001']); break; // 00107, 您的XX联盟商资料已提交修改，请等待系统审核
    case 40009: insertSystemMessage(extras, systemMessageModules['001']); break; // 00108, 您的XX联盟商资料已通过审核，立即生效
    case 400010: insertSystemMessage(extras, systemMessageModules['001']); break; // 00109, 您的XX联盟商资料:XXXX等内容，未通过审核,请重新提交
    case 400011: insertSystemMessage(extras, systemMessageModules['001']); break; // 00110, 您的账号资料被修改，请查看

    case 400015: insertSystemMessage(extras, systemMessageModules['001']); break; // 00114, 您的晓可广场联盟商分号已创建成功，可登录使用
    case 400016: insertSystemMessage(extras, systemMessageModules['001']); break; // 00115, 入驻资料审核未通过，请重新提交

    case 400017: otherMessage({ modules: ['user.taskcore'] }); break; // 00116, 您有新的验收任务，请及时查看
    case 400018: otherMessage({ modules: ['user.taskcore'] }); break; // 00117, 您有新的审核任务，请及时查看
    case 400019: otherMessage({ modules: ['user.taskcore'] }); break; // 00118, 您有新的任务，请及时查看
    case 400020: otherMessage({ modules: ['user.taskcore'] }); break; // 00119, 您的任务未验收通过，请及时修改

    case 400021: insertSystemMessage(extras, systemMessageModules['001']); break; // 00121, 店铺审核成功
    case 400022: insertSystemMessage(extras, systemMessageModules['001']); break; // 00122, 店铺审核失败
    case 400023: insertSystemMessage(extras, systemMessageModules['001']); break; // 00119, 店铺被绑定
    case 400024: insertSystemMessage(extras, systemMessageModules['001']); break; // 00119, 店铺解绑成功
    case 400025: insertSystemMessage(extras, systemMessageModules['001']); break; // 00119, 店铺绑定其他店铺
    case 400026: insertSystemMessage(extras, systemMessageModules['001']); break; // 00126, 店铺解绑成功
    case 400027: insertSystemMessage(extras, systemMessageModules['001']); break; // 00127, 店铺绑定其他店铺
    case 400028: insertSystemMessage(extras, systemMessageModules['001']); break; // 00120, 充值晓可币后发消息

    case 400030: break; // 00130, 订单xxx骑手已接单，跳转派送订单详情页
    case 400031: break; // 00131, 订单xxx骑手已到店，跳转派送订单详情页
    case 400032: break; // 00132, 订单xxx已被骑手拒绝接单,请及时查看，跳转商品订单详情页
    case 400033: break; // 00133, 订单xxx已被骑手取消,请重新派单，跳转派送订单详情页
    case 400034: break; // 00134, 订单xxx骑手已到达目的地，跳转派送订单详情页

    case 400050: insertSystemMessage(extras, systemMessageModules['001']); break; // 00150, 您上传的福利商品XXXXXX已通过审核，请及时登录后台查看
    case 400051: insertSystemMessage(extras, systemMessageModules['001']); break; // 00151, 您上传的福利商品XXXXXXX被系统下架，请及时登录后台查看

    case 400064: insertSystemMessage(extras, systemMessageModules['001']); break; // 00164 入驻资料审核通过
    case 400065: insertSystemMessage(extras, systemMessageModules['001']); break; // 00165 入驻资料审核未通过审核
    case 400066: insertSystemMessage(extras, systemMessageModules['001']); break; // 00166 免保证金审核通过
    case 400067: insertSystemMessage(extras, systemMessageModules['001']); break; // 00167 免保证金审核未通过
    case 400068: insertSystemMessage(extras, systemMessageModules['001']); break; // 00168 免加盟费审核通过
    case 400069: insertSystemMessage(extras, systemMessageModules['001']); break; // 00169 免加盟费审核未通过
    case 400070: insertSystemMessage(extras, systemMessageModules['001']); break; // 00170 结算账户通过审核
    case 400071: insertSystemMessage(extras, systemMessageModules['001']); break; // 00171 结算账户未通过审核
    case 400072: insertSystemMessage(extras, systemMessageModules['001']); break; // 00172 身份成功激活
    case 400073: insertSystemMessage(extras, systemMessageModules['001']); break; // 00173 家族升级提交成功
    case 400074: insertSystemMessage(extras, systemMessageModules['001']); break; // 00174 家族升级通过审核
    case 400075: insertSystemMessage(extras, systemMessageModules['001']); break; // 00175 家族升级未通过审核
    case 400076: insertSystemMessage(extras, systemMessageModules['001']); break; // 00176 联盟商信息修改提交成功
    case 400077: insertSystemMessage(extras, systemMessageModules['001']); break; // 00177 联盟商信息修改通过审核
    case 400078: insertSystemMessage(extras, systemMessageModules['001']); break; // 00178 联盟商信息修改未通过审核

    case 60001: insertSystemMessage(extras, systemMessageModules['006']); break; // 平台推送奖品码给用户
    case 60002: insertSystemMessage(extras, systemMessageModules['006']); break; // 平台抽奖推送消息
    case 60003: insertSystemMessage(extras, systemMessageModules['006']); break; // 店铺抽奖平台发货
    case 60006: insertSystemMessage(extras, systemMessageModules['006']); break; // 商铺发送抽奖券消息
    /** 安卓自定义消息 */
    case customMessageTypeMap.has_timer_msg: Platform.OS === 'android' && nativeApi.secreteMessageTimer(); break;
    /** 账户已冻结信息 */
    case customMessageTypeMap.frozen_user: showForzenToast({ code: '', message: '您的账号已冻结，如有疑问请联系平台' }); break;
    default:
      break;
  }
};

// {"goodsId":"5be52f450334553f3f44eeb2","goodsName":"test2222","goodsSkuCode":"00","goodsSkuValue":"12","msgCode":"00701","msgType":20001,"orderId":11118121300000014,"orderScene":"LOCALE_BUY","orderStatus":"STAY_ORDER","orderType":"NORMAL"}
