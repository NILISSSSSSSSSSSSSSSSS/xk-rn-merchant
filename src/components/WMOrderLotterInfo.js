import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image, TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import math from '../config/math';

export default class WMOrderLotterInfo extends Component {
    static defaultProps = {
      orderData: {

      },
      wrapStyle: {},
    };

    // 开奖算法
    gotoLotteryAlgorithm = () => {
      const { orderData, navigation } = this.props;
      const param = {
        thirdWinningTime: orderData.thirdWinningTime,
        thirdWinningNo: orderData.thirdWinningNo,
        thirdWinningNumber: orderData.thirdWinningNumber,
        termNumber: orderData.termNumber,
        userBuyRecord: orderData.maxStake || 0, // 本期参与人次
        lotteryNumber: orderData.lotteryNumber, // 中奖编号
      };
      navigation.navigate('WMLotteryAlgorithm', { lotteryData: param });
    }

    render() {
      const { orderData, wrapStyle } = this.props;
      const gzDataList = [
        {
          label: '中奖号码:',
          value: orderData.lotteryNumber || '暂无',
        },
        {
          label: '中奖时间:',
          value: orderData.lotteryTime
            ? moment(orderData.lotteryTime * 1000).format('YYYY-MM-DD HH:mm')
            : moment().format('YYYY-MM-DD HH:mm'),
        },
        {
          label: '时时彩开奖时间:',
          value: orderData.thirdWinningTime
            ? moment((orderData.thirdWinningTime) * 1000).format('YYYY-MM-DD HH:mm')
            : moment().format('YYYY-MM-DD HH:mm'),
        },
        {
          label: '时时彩开奖期数:',
          value: orderData.thirdWinningNo || 0,
        },
        {
          label: '时时彩开奖号码:',
          value: orderData.thirdWinningNumber || 0,
        },
      ];
      return (
        <React.Fragment>
          <View style={[styles.gzWrpa, wrapStyle]}>
            {
              gzDataList.map((item, index) => {
                const bottomBorder = index === gzDataList.length ? null : styles.borderBottom;
                if (index === 0) {
                  return (
                    // eslint-disable-next-line react/no-array-index-key
                    <View style={[CommonStyles.flex_start, { paddingTop: 15, paddingBottom: 7.5 }]} key={index}>
                      <Text style={[styles.btmLabel, { width: 112 }]}>{item.label}</Text>
                      <View style={[CommonStyles.flex_between, CommonStyles.flex_1]}>
                        <Text style={[styles.btmLabel, styles.itemValueStyle]}>{item.value}</Text>
                        <TouchableOpacity style={styles.btnWrap} activeOpacity={0.65} onPress={() => { this.gotoLotteryAlgorithm(); }}>
                          <Text style={styles.btnText}>开奖算法</Text>
                        </TouchableOpacity>
                      </View>
                    </View>
                  );
                }
                return (
                  // eslint-disable-next-line react/no-array-index-key
                  <View style={[CommonStyles.flex_start, { paddingVertical: 7.5 }, (index === gzDataList.length - 1) ? { paddingBottom: 15 } : null]} key={index}>
                    <Text style={[styles.btmLabel, { width: 112 }]}>{item.label}</Text>
                    <Text style={[styles.btmLabel, styles.itemValueStyle]}>{item.value}</Text>
                  </View>
                );
              })
            }
          </View>
        </React.Fragment>
      );
    }
}

const styles = StyleSheet.create({
  gzWrpa: {
    backgroundColor: '#fff',
    margin: 10,
    marginBottom: 0,
    borderRadius: 8,
    paddingHorizontal: 15,
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  btmLabel: {
    fontSize: 14,
    color: '#777',
    width: 70,
  },
  itemValueStyle: {
    fontSize: 14,
    color: '#222',
    flex: 1,
    paddingLeft: 10,
  },
  btnWrap: {
    width: 70,
    height: 20,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    backgroundColor: '#fff',
  },
  btnText: {
    fontSize: 12,
    textAlign: 'center',
    color: CommonStyles.globalHeaderColor,
    lineHeight: 18,
  },
});
