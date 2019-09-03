import moment from 'moment';
import { ORDER_STATUS_ONLINE, RIDER_ORDER_STATUS, ORDER_STATUS_ONLINE_DESCRIBE, ORDER_SCENE_TYPES, ORDER_STATUS_OFFLINE } from '../const/order';
import { keepTwoDecimal } from '../config/utils';
import math from '../config/math';

export const filterOrderStatus = (res, isShouhou) => {
  let orderStatus = isShouhou ? ORDER_STATUS_ONLINE.SHOU_HOU : ORDER_STATUS_ONLINE[res.orderStatus];
  if (res.status === 'del' && res.orderStatus === ORDER_STATUS_ONLINE.CONSUMPTION_CENTRE) {
    orderStatus = ORDER_STATUS_ONLINE.SHOU_HOU;
  }
  if (res.orderStatus === ORDER_STATUS_ONLINE.COMPLETELY) {
    if (res.status === 'active') {
      orderStatus = ORDER_STATUS_ONLINE.COMPLETELY;
    }
    if (res.status === 'del' && res.isAgree === 1) {
      orderStatus = ORDER_STATUS_ONLINE.CLOSE;
    }
  }
  return orderStatus;
};

export const filterOfflineOrderStatus = (orderStatus, status, isAgree) => {
  switch (orderStatus) {
      case 'STAY_CLEARING':
          return ORDER_STATUS_OFFLINE.CONSUMPTION_CENTRE;
      case 'STAY_EVALUATE':
          return ORDER_STATUS_OFFLINE.STAY_EVALUATE;
      case 'COMPLETELY':
          if (status === 'active') {
              return ORDER_STATUS_OFFLINE.COMPLETELY;
          }
          if (status === 'del' && isAgree === 1) {
              return ORDER_STATUS_OFFLINE.CLOSE;
          }
  }
};

export const filterAppointRange = (res, dateTimeFormat = 'YYYY-MM-DD HH:mm') => {
  const dataKeys = {};
  if (!res.appointRange) {
    return dataKeys;
  }
  const indexTime = res.appointRange.indexOf('-');
  if (indexTime !== -1) {
    dataKeys.timedate = res.appointRange.substring(0, indexTime);
    dataKeys.endtime = res.appointRange.substring(indexTime + 1);
  } else {
    dataKeys.timedate = res.appointRange;
    dataKeys.endtime = '';
  }

  if (dataKeys.timedate) {dataKeys.timedate = moment(dataKeys.timedate * 1000).format(dateTimeFormat);}
  if (dataKeys.endtime) {dataKeys.endtime = moment(dataKeys.endtime * 1000).format(dateTimeFormat);}

  return dataKeys;
};

export const getVoucher = (data, order) => {
  if (order.voucher !== undefined && order.shopVoucher !== undefined) {
    return {
      voucher: order.voucher,
      shopVoucher: order.shopVoucher,
    };
  }
  let voucher = 0;
  let shopVoucher = 0;
  if (data) {
    data.forEach((item) => {
      voucher += Number(item.voucher);
      shopVoucher += Number(item.shopVoucher);
    });
  }
  return { voucher, shopVoucher };
};

export const filterLogistics = (res) => {
  const dataKeys = {};
  if (!res.logistics) {return dataKeys;}
  if (res.logistics.postType === 'THIRD') {
    dataKeys.postType = 'THIRD';
    dataKeys.hasWuliu = true;
  } else {
    dataKeys.postType = 'OWN';
    dataKeys.hasWuliu = true;
  }
  if (res.riderOrderStatus === 'rider_refuse' || res.riderOrderStatus === 'order_cancel') {
    dataKeys.postType = '';
    dataKeys.hasWuliu = false;
  }
  return dataKeys;
};

export const getDurationData = (startTime, endTime, format = 'YYYY-MM-DD HH:mm') => {
  const result = moment(endTime, format).diff(moment(startTime, format), 'days');
  return result;
};

export const filterOrderListItemCard = (res, isShouhou) => {
  const {
    sceneStatus, orderId, bcleGoodsType, remark, isSelfLifting, address,
  } = res;
  const showSkuAndName = sceneStatus === 'SERVICE_OR_STAY' || sceneStatus === 'SERVICE_AND_LOCALE_BUY' || sceneStatus === 'SHOP_HAND_ORDER' || sceneStatus === 'LOCALE_BUY';
  const orderStatus = filterOrderStatus(res, isShouhou);
  const orderStatusName = (ORDER_STATUS_ONLINE_DESCRIBE[orderStatus] || { name: '未知状态' }).name;
  const goods = res.goods || [];
  const firstGood = goods[0] || {};
  const goodCount = goods.length;
  const isLocalBuy = sceneStatus === 'LOCALE_BUY';
  const goodName = isLocalBuy ? firstGood.pName : firstGood.name;
  const skuName = isLocalBuy ? firstGood.pSkuName : firstGood.skuName;
  const totalMoney = keepTwoDecimal(res.money / 100);
  const createAt = moment(res.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss');
  const appointRange = filterAppointRange(res, 'YYYY-MM-DD HH:mm');
  const startTime = appointRange.timedate;
  const showStartTime = bcleGoodsType != '1003' && sceneStatus !== 'TAKE_OUT' && sceneStatus !== 'LOCALE_BUY';
  const showAddress = sceneStatus === 'TAKE_OUT' && isSelfLifting == 0;
  const showTimeRange = sceneStatus === 'SERVICE_OR_STAY' && bcleGoodsType === '1003';
  const yuyueTime = filterAppointRange(res, 'YYYY年MM月DD日');
  const timeRange = `${yuyueTime.timedate}-${yuyueTime.endtime} | 共${getDurationData(appointRange.timedate, appointRange.endtime)}晚 | ${goodCount}间`;
  const icon = firstGood.skuUrl || firstGood.pSkuUrl;
  const icons = goods.map(item => item.skuUrl || item.pSkuUrl);

  return {
    orderId, // 订单编号
    bcleGoodsType,
    sceneStatus,
    orderStatus, // 页面上显示的订单状态
    orderStatusName, // 页面上显示的订单状态名称
    showSkuAndName,
    goodName,
    skuName,
    appointRange,
    startTime, // 预约时间
    showStartTime,
    address,
    showAddress,
    timeRange,
    showTimeRange,
    createAt, // 下单时间
    remark, // 备注
    icon,
    icons,
    totalMoney,
    goodCount,
  };
};

export const filterOrderDetails = (res, isShouhou = false) => {
  const goods = res.goods || [];
  const firstGood = goods[0] || {};
  const dataKeys = {
    freight: res.postFee / 100,
    data: goods,
    goodsCount: goods.length,
    orderStatus: filterOrderStatus(res, isShouhou), // 订单状态
    getSomeData: getVoucher(goods, res), // 消费信息
    resmoney: res.money,
    price: res.pirce, // 总金额
    isGoodsTakeOut: res.bcleGoodsType !== '1005', // 是否是外卖类
    isStay: res.sceneStatus === 'SERVICE_OR_STAY' && res.bcleGoodsType === '1003', // 是否是住宿类
    ...filterAppointRange(res),
    ...filterLogistics(res),
  };

  if (isShouhou) {
    const findReasonFromGoods = goods.find((good) => {
      const subGoods = good.goods || [];
      const findSubGood = subGoods.find(subGood => !!subGood.pRefundReason);
      good.pRefundReason = !findSubGood ? '' : findSubGood.pRefundReason;
      if (findSubGood) {
        return true;
      }
      return !!good.reason;
    });
    dataKeys.orderReason = res.reason || findReasonFromGoods ? findReasonFromGoods.pRefundReason || findReasonFromGoods.reason : '';
    dataKeys.pPrice = res.pPirce || 0;
  }

  if (res.sceneStatus === ORDER_SCENE_TYPES.SERVICE_OR_STAY) {
    const appointRange = filterAppointRange(res, dataKeys.isStay ? 'YYYY-MM-DD' : 'YYYY-MM-DD HH:mm');
    dataKeys.startTime = appointRange.timedate;
    dataKeys.endTime = appointRange.endtime;
    if (dataKeys.isStay) {
      dataKeys.stayDays = moment(dataKeys.endTime, 'YYYY-MM-DD').diff(moment(dataKeys.startTime, 'YYYY-MM-DD'), 'days');
      dataKeys.goodsData = goods.map(item => ({
        ...item,
        platformPrice: item.platformPrice / dataKeys.stayDays,
        platformShopPrice: item.platformShopPrice / dataKeys.stayDays,
      }));
    }
  }

  if (res.sceneStatus === ORDER_SCENE_TYPES.SERVICE_AND_LOCALE_BUY) {
    const seatData = [];
    dataKeys.serviceData = goods.map((item) => {
      if (!seatData.find(seat => seat.seatId === item.seatId)) {
        seatData.push({
          seatId: item.seatId,
          seatName: item.seatName,
          seatCode: item.seatCode,
        });
      }
      return {
        ...item,
        payStatus: item.pBcleOrderPayStatus || item.payStatus,
        confirmStatus: item.pConfirmStatus || item.confirmStatus,
        createdAt: item.pCreatedAt || item.createAt,
        itemId: item.pItemId || item.itemId,
        name: item.pName || item.name,
        platformPrice: item.pPlatformPrice || item.platformPrice,
        platformShopPrice: item.pPlatformShopPrice || item.platformShopPrice,
        skuName: item.pSkuName || item.skuName,
        isCustomerAdd: true,
      };
    });
    dataKeys.seatData = seatData || [];
    const appointRange = filterAppointRange(res, 'YYYY-MM-DD HH:mm');
    dataKeys.startTime = appointRange.timedate;
    dataKeys.endTime = appointRange.endtime;
    dataKeys.agree_pay = res.orderStatus === 'AGREE_PAY';
    dataKeys.canAddGoods = !(res.orderStatus === 'AGREE_PAY' || res.orderStatus === 'STAY_CLEARING');
    dataKeys.updataSettlement = res.orderStatus === 'STAY_CLEARING';
    dataKeys.canCancelOrder = res.orderStatus !== 'STAY_CLEARING';
    dataKeys.totalMoney = dataKeys.serviceData.reduce((preV, curV, curIndex, array) => preV += (curV.platformShopPrice || 0), 0);
    dataKeys.getSomeData = getVoucher(dataKeys.serviceData, res); // 消费信息
  }

  if (res.sceneStatus === ORDER_SCENE_TYPES.LOCALE_BUY) {
    const seatData = [];
    dataKeys.serviceData = goods.map((item) => {
      if (!seatData.find(seat => seat.seatId === item.seatId)) {
        seatData.push({
          seatId: item.seatId,
          seatName: item.seatName,
          seatCode: item.seatCode,
        });
      }
      return {
        ...item,
        payStatus: item.pBcleOrderPayStatus || item.payStatus,
        confirmStatus: item.pConfirmStatus || item.confirmStatus,
        createdAt: item.pCreatedAt || item.createAt,
        itemId: item.pItemId || item.itemId,
        name: item.pName || item.name,
        platformPrice: item.pPlatformPrice || item.platformPrice,
        platformShopPrice: item.pPlatformShopPrice || item.platformShopPrice,
        skuName: item.pSkuName || item.skuName,
        isCustomerAdd: true,
      };
    });
    const appointRange = filterAppointRange(res, 'YYYY-MM-DD HH:mm');
    dataKeys.startTime = appointRange.timedate;
    dataKeys.endTime = appointRange.endtime;
    dataKeys.agree_pay = res.orderStatus === 'AGREE_PAY';
    dataKeys.canAddGoods = !(res.orderStatus === 'AGREE_PAY' || res.orderStatus === 'STAY_CLEARING');
    dataKeys.updataSettlement = res.orderStatus === 'STAY_CLEARING';
    dataKeys.canCancelOrder = res.orderStatus !== 'STAY_CLEARING';
    dataKeys.respayPirce = firstGood.payPirce;
    dataKeys.totalMoney = dataKeys.serviceData.reduce((preV, curV, curIndex, array) => {
      if (curV.platformShopPrice) {
        if (res.orderStatus === ORDER_STATUS_ONLINE.STAY_EVALUATE || res.orderStatus === ORDER_STATUS_ONLINE.CLOSE) {
          preV += curV.platformShopPrice;
        } else {
          preV += curV.platformPrice;
        }
      }
      return preV;
    }, 0);
    dataKeys.seatData = seatData || [];
  }

  if (res.sceneStatus === ORDER_SCENE_TYPES.SHOP_HAND_ORDER) {
    let serviceData = res.goods;
    dataKeys.goodsNum = 0;
    serviceData.forEach((item) => {
        if (item.goods) {
          dataKeys.goodsNum += item.goods.length;
        }
    });
    let appointRange = res.appointRange;
    dataKeys.startTime = moment(appointRange * 1000).format('YYYY-MM-DD HH:mm');
    dataKeys.agree_pay = res.orderStatus === 'AGREE_PAY';
    dataKeys.canAddGoods = !(res.orderStatus === 'AGREE_PAY' || res.orderStatus === 'STAY_CLEARING');
    dataKeys.updataSettlement = res.orderStatus === 'STAY_CLEARING';
    dataKeys.orderStatus = filterOfflineOrderStatus(res.orderStatus, res.status, res.isAgree);

    let totalMoney = 0;
    serviceData.forEach((item) => {
        if (item.platformShopPrice) {
            totalMoney += item.platformShopPrice;
        }
    });
    dataKeys.totalMoney = math.divide(totalMoney , 100);
    dataKeys.serviceData = serviceData;
  }

  return {
    ...res,
    ...dataKeys,
  };
};
