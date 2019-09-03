export const ORDER_STATUS_ONLINE = {
  /** 待接单 */
  STAY_ORDER: 'STAY_ORDER',
  /** 待付款 */
  STAY_PAY: 'STAY_PAY',
  /** 待消费 */
  STAY_CONSUMPTION: 'STAY_CONSUMPTION',
  /** 备货中 */
  STOCK_CENTRE: 'STOCK_CENTRE',
  /** 同意付款 */
  AGREE_PAY: 'CONSUMPTION_CENTRE',
  /** 待结束 */
  STAY_CLEARING: 'CONSUMPTION_CENTRE',
  /** 进行中 */
  CONSUMPTION_CENTRE: 'CONSUMPTION_CENTRE',
  /** 待评价 */
  STAY_EVALUATE: 'STAY_EVALUATE',
  /** 已完成  */
  COMPLETELY: 'COMPLETELY',
  /** 已关闭 */
  CLOSE: 'CLOSE',
  /** 已送达  */
  SHOP_DELIVERY: 'SHOP_DELIVERY',
  /** 进行中 */
  PROCESS_CENTRE: 'PROCESS_CENTRE',
  /** 退款中 */
  SHOU_HOU: 'SHOU_HOU',
};

export const ORDER_STATUS_OFFLINE = {
  /** 进行中 */
  CONSUMPTION_CENTRE: 0,
  /** 待评价 */
  STAY_EVALUATE: 1,
  /** 已完成  */
  COMPLETELY: 2,
  /** 已关闭 */
  CLOSE: 3,
};

export const ORDER_STATUS_ONLINE_DESCRIBE = {
  /** 待接单 */
  STAY_ORDER: {
    name: '待接单',
    tips: '后仍未接单，系统自动关闭',
  },
  /** 待付款 */
  STAY_PAY: {
    name: '待付款',
    tips: '后仍未付款，系统自动关闭',
  },
  /** 待消费 */
  STAY_CONSUMPTION: {
    name: '待消费',
    tips: '',
  },
  /** 备货中 */
  STOCK_CENTRE: {
    name: '备货中',
    tips: '',
  },
  /** 进行中 */
  CONSUMPTION_CENTRE: {
    name: '进行中',
    tips: '已生成结算订单，请提醒客户买单',
  },
  /** 待评价 */
  STAY_EVALUATE: {
    name: '待评价',
    tips: '后仍未评价，系统默认好评',
  },
  /** 已完成  */
  COMPLETELY: {
    name: '已完成',
    tips: '评价时间',
  },
  /** 已关闭 */
  CLOSE: {
    name: '已关闭',
    tips: '关闭时间',
  },
  /** 已送达  */
  SHOP_DELIVERY: {
    name: '已送达',
    tips: '',
  },
  /** 进行中 */
  PROCESS_CENTRE: {
    name: '进行中',
    tips: '已生成结算订单，请提醒客户买单',
  },
  /** 退款中 */
  SHOU_HOU: {
    name: '退款中',
    tips: '部分商品退款中，请及时处理',
  },
};

export const ORDER_STATUS_OFFLINE_DESCRIBE = [
  { name: '进行中', tips: '已生成结算订单，请提醒客户买单' },
  { name: '待评价', tips: '29分54秒后仍未评价，系统默认好评' },
  { name: '已完成', tips: '完成时间' },
  { name: '已关闭', tips: '关闭时间' },
];


/** 订单场景 */
export const ORDER_SCENE_TYPES = {
  /** 服务或者住宿类 */
  SERVICE_OR_STAY: 'SERVICE_OR_STAY',
  /** 外卖   售后 */
  TAKE_OUT: 'TAKE_OUT',
  /** 现场消费E */
  LOCALE_BUY: 'LOCALE_BUY',
  /** 服务+现场消费 */
  SERVICE_AND_LOCALE_BUY: 'SERVICE_AND_LOCALE_BUY',
  /** 线下订单 */
  SHOP_HAND_ORDER: 'SHOP_HAND_ORDER',
};

export const RIDER_ORDER_STATUS = {
  /** 等待骑手接单 */
  WAIT_RIDER: 'wait_rider',
  /** 骑手拒绝接单 */
  RIDER_REFUSE: 'rider_refuse',
  /** 等待骑手取货 */
  WAIT_PICKUP: 'wait_pickup',
  /** 配送中 */
  RIDER_DRIVERING: 'rider_drivering',
  /** 配送完成 */
  RIDER_ARRAIVE: 'rider_arraive',
  /** 派单已取消 */
  ORDER_CANCEL: 'order_cancel',
  /** 骑手已接单 */
  RIDER_TRANS: 'rider_trans',
  /** 骑手已接单 */
  RIDER_TRANSING: 'rider_transing',
};

export const RIDER_ORDER_STATUS_DESCRIBE = {
  default: {
    name: '',
  },
  /** 等待骑手接单 */
  wait_rider: {
    name: '等待骑手接单',
  },
  /** 骑手拒绝接单 */
  rider_refuse: {
    name: '骑手拒绝接单',
  },
  /** 等待骑手取货 */
  wait_pickup: {
    name: '待骑手取货',
  },
  /** 配送中 */
  rider_drivering: {
    name: '骑手配送中',
  },
  /** 配送完成 */
  rider_arraive: {
    name: '已完成',
  },
  /** 派单已取消 */
  order_cancel: {
    name: '骑手已取消订单',
  },
  rider_trans: {
    name: '骑手已接单',
  },
  rider_transing: {
    name: '骑手已接单',
  },
};


export const BCLE_ORDER_PAY_STATUS = {
  /** 未支付 */
  NOT_PAY: 'NOT_PAY',
  /** 未支付 */
  DURING_PAY: 'DURING_PAY',
  /** 支付成功 */
  SUCCESS_PAY: 'SUCCESS_PAY',
  /** 已支付需退款 */
  APPLY_REFUND: 'APPLY_REFUND',
  /** 同意退款 */
  AGREE_REFUND: 'AGREE_REFUND',
  /** 拒绝退款 */
  REFUSE_REFUND: 'REFUSE_REFUND',
  /** 退款成功 */
  SUCCESS_REFUND: 'SUCCESS_REFUND',
};

/** 线下订单 tab名称以及对应的状态 */
export const TABS_TITLE_OFFLINE = [
  { name: '全部', index: 0, status: '' },
  { name: '进行中', index: 1, status: 'CONSUMPTION_CENTRE' },
  { name: '待评价', index: 2, status: 'STAY_EVALUATE' },
  { name: '已完成', index: 3, status: 'COMPLETELY' },
  { name: '已关闭', index: 4, status: 'CLOSE' },
];

/** 线上订单 tab名称以及对应的状态 */
export const TABS_TITLE_ONLINE = [
  { name: '全部', index: 0, status: '' },
  { name: '待接单', index: 1, status: 'STAY_ORDER' },
  { name: '待付款', index: 2, status: 'STAY_PAY' },
  { name: '待消费', index: 3, status: 'STAY_CONSUMPTION' },
  { name: '备货中', index: 4, status: 'STOCK_CENTRE' },
  { name: '进行中', index: 5, status: 'CONSUMPTION_CENTRE' },
  { name: '待评价', index: 6, status: 'STAY_EVALUATE' },
  { name: '已完成', index: 7, status: 'COMPLETELY' },
  { name: '已关闭', index: 8, status: 'CLOSE' },
  { name: '售后', index: 9, status: 'SHOUHOU' },
];
export const POST_COMPANY_LIST = [
  { key: 'SF', value: '顺丰', icon: require('../images/logistics/SF.png') },
  { key: 'YD', value: '韵达', icon: require('../images/logistics/YD.png') },
  { key: 'ZT', value: '中通', icon: require('../images/logistics/ZT.png') },
  { key: 'ST', value: '申通', icon: require('../images/logistics/ST.png') },
  { key: 'YT', value: '圆通', icon: require('../images/logistics/YT.png') },
  { key: 'BSHT', value: '百世汇通', icon: require('../images/logistics/BSHT.png') },
];

export const POST_COMPANY_MAP = new Map(POST_COMPANY_LIST.map(({ key, value }) => ([key, value])));

export const BCLE_ORDER_PAY_STATUS_DESCRIBE = {
  NOT_PAY: { name: '未支付', noPay: true },
  DURING_PAY: { name: '未支付', noPay: true },
  SUCCESS_PAY: { name: '支付成功' },
  APPLY_REFUND: { name: '已支付需退款' },
  AGREE_REFUND: { name: '同意退款' },
  REFUSE_REFUND: { name: '拒绝退款' },
  SUCCESS_REFUND: { name: '退款成功' },
};
