import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image, TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import WMGoodsWrap from './WMGoodsWrap';
import math from '../config/math';
import { showSaleNumText } from '../config/utils'
export default class WMOrderListItem extends Component {
    static defaultProps = {
      // 单个list item
      item: {
        expectDrawTime: new Date(),
        joinCount: 1,
        maxStake: 100,
        awardUsage: '',
        url: '',
        name: '',
        state: '',
        drawType: '',
      }, 
      status: 0, // 当前tabs索引
      listLength: 10, // 列表长度
      dispatch: () => {}, // dispatch
      listItemIndex: 0, // item 索引
    };
    // eslint-disable-next-line consistent-return
    goToDetails = (item) => {
      const { dispatch, status } = this.props;
      dispatch({ type: 'welfare/listNavigation', payload: { params: { ...item, routerIn: 'WMOrderList' } } })
      dispatch({ type: 'welfare/save', payload: { 
        wmOrderListItem: {
          orderId: item.orderId, 
          status: status
        }
        } })
    };
    // 根据订单类型，获取不同Label 1，待开奖，2，已中奖，3，已完成
    getGoodsLabelView = (itemData, status) => {
        switch (status) {
            case 0: return this.handleGetAllStatus(itemData);
            case 1: return this.getOpenPrizeLabelView(itemData);
            case 2: return this.getWinningPrizeView(itemData);
            case 3: return this.getWinningPrizeView(itemData);
            default: return null;
        }
    };
    // 获取待开奖label
    getOpenPrizeLabelView = itemData => (
        <View style={[CommonStyles.flex_start]}>
            { this.getTimeLabel('期数：', `第${itemData.currentNper}期`, false, { marginTop: 6 }) }
            { this.getTimeLabel('参与注数：', `${itemData.orderNumber}注`, false, { marginTop: 6, marginLeft: 30 }) }
        </View>
    )
    /** Label Item
     * label 显示的lebel
     * value 显示的时间
     * showColor 是否显示颜色
     * wrapStyle 包裹组件样式
     */
    getTimeLabel = (label = '中奖时间：', value = new Date(), showColor = false, wrapStyle = {} ) => {
        const text = typeof value === 'object'
          ? moment(value).format('YYYY-MM-DD HH:mm:ss')
          : value;
        return (
          <View style={[CommonStyles.flex_start, wrapStyle]}>
            <Text style={styles.prizeItemText}>{label}</Text>
            <Text style={[styles.prizeItemText, showColor ? styles.redColor : null]}>
              {text}
            </Text>
          </View>
        );
    };
    // 已中奖且根据商品状态获取label 1，代发货，2，待收货，3，待分享
    getWinningPrizeView = (itemData) => {
        let status = '';
        switch (itemData.state) {
            case 'NOT_DELIVERY':
            status = '等待平台发货';
            break;
            case 'DELIVERY':
            status = '等待用户收货';
            break;
            case 'NOT_SHARE':
            status = itemData.awardUsage === 'expense' ? '分享后领取' : '分享即发货';
            break;
            case 'WAIT_FOR_RECEVING': // 只有平台大奖才有多出这个状态，其余和上面三个状态一样
            status = '等待用户领取';
            break;
            case 'SHARE_LOTTERY': status = '已完成';
            break;
            case 'LOSING_LOTTERY': status = '未中奖';
            break;
            case 'SHARE_AUDIT_ING': status = '晒单审核中';
            break;
            case 'RECEVING': status = '晒单有奖';
            break;
            case 'WINNING_LOTTERY': status = '晒单有奖';
            break;
            case 'SHARE_AUDIT_FAIL': status = '晒单失败，重新晒单';
            break;
            case 'CHANGED': // 货物报损后，平台再次发货
            status = '已换货';
            break;
            default: status = '获取中...';
        }
        return this.getWinnerLotterLabelView(itemData, status);
    };
    // 获取已中奖后的label
    getWinnerLotterLabelView = (itemData, status) => (
        <React.Fragment>
            <View style={[CommonStyles.flex_start]}>
            { this.getTimeLabel('期数：', `第${itemData.currentNper}期`, false, { marginTop: 5 }) }
            { this.getTimeLabel('参与注数：', `${itemData.orderNumber}注`, false, { marginTop: 5, marginLeft: 30 }) }
            </View>
            {this.getTimeLabel('中奖时间：', moment(itemData.lotteryTime * 1000).format('YYYY-MM-DD HH:mm:ss'), false, { marginTop: 5 })}
            {this.getTimeLabel('奖品状态：', status, true, { marginTop: 5 })}
        </React.Fragment>
    )
    // 全部订单中，根据订单状态获取操作项和显示项
    handleGetAllStatus = (itemData) => {
        if (itemData.state === 'NO_LOTTERY') { // 未开奖相关状态：NO_LOTTERY 未开奖
            return this.getGoodsLabelView(itemData, 1);
        } if (itemData.state === 'NOT_SHARE' || itemData.state === 'NOT_DELIVERY' || itemData.state === 'DELIVERY') {
            // 已中奖相关状态：NOT_SHARE 未分享 NOT_DELIVERY 待发货 DELIVERY 待收货。。。。。平台大奖多一个WAIT_FOR_RECEVING等待用户领取状态
            return this.getGoodsLabelView(itemData, 2);
        }
        return this.getGoodsLabelView(itemData, 3);
    }
    render() {
       const { status, item, listItemIndex, listLength } = this.props
        const time = moment(item.expectDrawTime * 1000).format('MM-DD HH:mm');
        const value = (item.joinCount / item.maxStake) * 100;
        // eslint-disable-next-line radix
        const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
        const processPercent = `${processValue}%`;
        let fixedNumber = item.maxStake > 100000 ? 0 : 1;
        const showText = `${showSaleNumText(item.joinCount, fixedNumber)}/${showSaleNumText(item.maxStake, fixedNumber)}`
        let topRadius;
        let bottomRadius;
        let topBorder;
        let bottomBorder;
        if (listItemIndex === 0) {
          topRadius = styles.topRadius;
          topBorder = styles.topBorder;
        }
        if (listItemIndex === listLength - 1) {
          bottomRadius = styles.bottomRadius;
          bottomBorder = styles.bottomBorder;
        }
        return (
          <TouchableOpacity
            activeOpacity={0.75}
            onPress={() => { this.goToDetails(item) }}
            style={[ styles.itemWrap, topRadius, bottomRadius, topBorder, bottomBorder]}
          >
            <View styles={{ position: 'relative' }}>
              {
                item.awardUsage === 'expense'
                  ? (
                    <View style={styles.expenseLabel}>
                      <Image style={{ height: 20, width: 79 }} source={require('../images/wm/expenseOrderLabel.png')} />
                    </View>
                  )
                  : null
              }
              <WMGoodsWrap
                itemWrapStyle={styles.itemWrapStyle}
                imgUrl={item.url}
                imgHeight={80}
                imgWidth={80}
                title={item.name}
                goodsTitleStyle={ status === 3 ? styles.goodsTitle : {}}
                showProcess={ item.state === 'NO_LOTTERY' ? true : false }
                showPrice={false}
                type={item.drawType}
                processValue={processValue}
                label="开奖人次:"
                timeLabel="开奖时间:"
                timeValue={time}
                showText={showText}
                labelStyle={styles.labelStyle}
              >
                {this.getGoodsLabelView(item, status)}
              </WMGoodsWrap>
            </View>
          </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
    topRadius: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
      },
    bottomRadius: {
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8,
    },
    topBorder: {
        borderTopColor: 'rgba(215,215,215,0.5)',
        borderTopWidth: 1,
    },
    bottomBorder: {
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 1,
    },
    itemWrap: {
        backgroundColor: '#fff',
        marginLeft: 10,
        marginRight: 10,
        borderLeftColor: 'rgba(215,215,215,0.5)',
        borderLeftWidth: 1,
        borderRightColor: 'rgba(215,215,215,0.5)',
        borderRightWidth: 1,
        borderBottomColor: 'rgba(215,215,215,0.5)',
        borderBottomWidth: 1,
        position: 'relative',
    },
    expenseLabel: {
        position: 'absolute',
        bottom: 15.5,
        left: 15.5,
        zIndex: 2,
        height: 20,
        width: 79,
        overflow: 'hidden',
        borderBottomLeftRadius: 10,
        borderBottomRightRadius: 10,
    },
    itemWrapStyle: {
        marginTop: 10,
    },
    goodsTitle: {
        fontSize: 12,
        color: '#222',
    },
    labelStyle: {
        paddingRight: 7,
        color: 'red',
        fontSize: 12,
        color: '#555',
    },

  prizeItemText: {
    fontSize: 12,
    color: '#555',
  },
  redColor: {
    color: '#EE6161',
  },
});