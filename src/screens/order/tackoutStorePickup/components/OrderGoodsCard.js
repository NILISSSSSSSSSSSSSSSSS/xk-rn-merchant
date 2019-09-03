import React, { Component } from 'react';
import {
  Text, View, StyleSheet, Image, Dimensions,
} from 'react-native';
import Card from '../../../../components/Card';
import { BCLE_ORDER_PAY_STATUS_DESCRIBE, ORDER_STATUS_ONLINE } from '../../../../const/order';
import { keepTwoDecimal } from '../../../../config/utils';
import math from '../../../../config/math';
import ImageView from '../../../../components/ImageView';

const exchangeFToY = fen => keepTwoDecimal(math.divide(fen, 100));

const green = require('../../../../images/account/xiaokebi.png');
const shiwuquan = require('../../../../images/account/shiwuquan.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

export default class OrderGoodsCard extends Component {
  renderRefund(refund) {
    console.log('renderRefund', refund);
    return (
      <View style={styles.refund}>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Image source={refund.payStatusInfo.noPay ? shiwuquan : green} />
          {
            !refund.itemRefundId ? null : <Text style={[styles.c7f14, { marginLeft: 8 }]}>{`售后编号：${refund.itemRefundId}`}</Text>
          }
        </View>
        <Text style={!refund.pPurchaseRefundId ? styles.cgreenF14 : styles.cyellowF14}>
          {refund.payStatusInfo.name}
        </Text>
      </View>
    );
  }

  render() {
    const {
      isShouhou, // 售后
      orderDetail, // 订单详情
      style,
    } = this.props;

    const {
      data = [], orderStatus, getSomeData = {}, price, resmoney,
    } = orderDetail || {};
    const isPlatformPrice = [ORDER_STATUS_ONLINE.STAY_EVALUATE, ORDER_STATUS_ONLINE.COMPLETELY].includes(orderStatus);
    /** 商品信息 */
    const goods = data.map(item => ({
      refund: !isShouhou ? null : {
        itemRefundId: item.itemRefundId, // 售后编号
        pPurchaseRefundId: item.pPurchaseRefundId, // 售后Id
        bcleOrderPayStatus: item.pBcleOrderPayStatus, // 售后商品支付状态
        payStatusInfo: BCLE_ORDER_PAY_STATUS_DESCRIBE[item.pBcleOrderPayStatus] || {},
      },
      skuUrl: item.skuUrl, // 商品图片
      goodsName: item.goodsName, // 商品名称
      skuName: item.skuName, // 商品规格
      platformPrice: exchangeFToY(isPlatformPrice ? item.platformShopPrice : item.platformPrice), // 商品实际价格
      originalPrice: exchangeFToY(item.originalPrice),
    }));

    /** 订单商品价格统计信息 */
    const priceInfo = [
      { title: '总数：', value: `x${data.length}`, style: styles.c2f14 },
      { title: '共计：', value: `￥${exchangeFToY(price)}` },
      { title: '消费券支付：', value: exchangeFToY(getSomeData.voucher) },
      { title: '商家券支付：', value: exchangeFToY(getSomeData.shopVoucher) },
      { title: '现金支付：', value: `￥${exchangeFToY(resmoney)}` },
    ];
    return (
      <Card style={style}>
        {
          goods.map((item, index) => (
            <View key={item.id}>
              {item.refund ? this.renderRefund(item.refund) : null}
              <View style={[styles.serviceItem, index === data.length - 1 ? {} : styles.borderBt]}>
                <View style={styles.serviceItemimg}>
                  <ImageView source={{ uri: item.skuUrl }} sourceWidth={getwidth(80)} sourceHeight={getwidth(80)} resizeMode='cover' />
                </View>
                <View style={styles.goods}>
                  <View style={styles.textItem}>
                    <View style={{ flex: 1 }}>
                      <Text style={styles.c2f14}>{item.goodsName}</Text>
                    </View>
                  </View>
                  <View style={{ marginTop: 13 }}>
                    <Text style={styles.c7f12}>{item.skuName}</Text>
                  </View>
                  <View style={styles.price}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                      <Text style={styles.credf14}>{`￥${item.platformPrice}`}</Text>
                      <Text style={[styles.ccf10, { textDecorationLine: 'line-through' }]}>{` 市场价(￥${item.originalPrice})`}</Text>
                    </View>
                  </View>
                </View>
              </View>
            </View>
          ))
        }
        <View style={styles.serviceBottom}>
          {
            priceInfo.map(item => (
              <View style={styles.serviceBottomItem}>
                <View><Text style={styles.c7f14}>{item.title}</Text></View>
                <View><Text style={[styles.credf14, item.style]}>{item.value}</Text></View>
              </View>
            ))
          }
        </View>
      </Card>
    );
  }
}

const styles = StyleSheet.create({
  refund: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 6,
    alignItems: 'center',
  },
  serviceBottom: {
    width: getwidth(355),
    height: 170,
    borderTopColor: '#D7D7D7',
    borderTopWidth: 0.5,
    borderRadius: 6,
    overflow: 'hidden',
  },
  serviceBottomItem: {
    width: getwidth(325),
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  c2f14: {
    color: '#222',
    fontSize: 14,
  },
  c7f14: {
    color: '#777',
    fontSize: 14,
  },
  credf14: {
    color: '#EE6161',
    fontSize: 14,
  },
  cgreenF14: {
    color: '#46D684',
    fontSize: 14,
  },
  cyellowF14: {
    color: '#FA994A',
    fontSize: 14,
  },
  price: {
    flexDirection: 'row',
    height: 44,
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  borderBt: {
    borderBottomColor: '#D7D7D7',
    borderBottomWidth: 0.5,
  },
  goods: {
    flex: 1,
    height: 80,
    marginLeft: 15,
    alignSelf: 'center',
  },
  serviceItem: {
    width: getwidth(325),
    height: 110,
    flexDirection: 'row',
    backgroundColor: '#fff',
  },
  serviceItemimg: {
    width: getwidth(80),
    height: 110,
    justifyContent: 'center',
    alignItems: 'center',
  },
  textItem: {
    width: '100%',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  ccf10: {
    color: '#CCCCCC',
    fontSize: 10,
  },
});
