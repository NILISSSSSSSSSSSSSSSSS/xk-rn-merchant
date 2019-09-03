import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import math from '../config/math';

export default class WMOrderInfoWrap extends Component {
    static defaultProps = {
      orderData: {

      },
    };

    state = {
      lotteryNumbersLimit: 2,
    }

   // 兑奖编号
   getCrashNumItem = (label = '', value = '', index) => (
     <View key={index} style={[CommonStyles.flex_start, CommonStyles.flex_1, styles.crashLabelWrap]}>
       <Text style={styles.crashLabel}>{label}</Text>
       <Text style={[styles.crashLabel, styles.itemValueStyle]}>{value}</Text>
     </View>
   )

   render() {
     const { orderData } = this.props;
     const { lotteryNumbersLimit } = this.state;
     return (
       <React.Fragment>
         {/* 购买注数 */}
         <View style={[styles.prizeNumberWrap]}>
           <View style={[CommonStyles.flex_start, styles.flex_1, styles.prizeTitleWrap]}>
             <Text style={styles.prizeNumLable}>兑奖注数：</Text>
             <Text style={[styles.prizeNumLable]}>{orderData.lotteryNumbers && orderData.lotteryNumbers.length}</Text>
             {/* <Text style={[styles.prizeNumLable]}>{orderData.myStake}</Text> */}
           </View>
           <View style={{ padding: 15 }}>
             {orderData.lotteryNumbers && orderData.lotteryNumbers.length > 0 && orderData.lotteryNumbers.map((item, index) => {
               if (index < lotteryNumbersLimit) {
                 return this.getCrashNumItem('兑奖编号：', item.lotteryNumber, index);
               }
               return null;
             })}
             {// 如果总数大于限制条数则显示
              (orderData.lotteryNumbers && orderData.lotteryNumbers.length > 0 && orderData.lotteryNumbers.length > 2)
                ? (
                  <Text
                    style={{ color: '#4A90FA' }}
                    onPress={() => {
                      this.setState({
                        lotteryNumbersLimit: (lotteryNumbersLimit === orderData.lotteryNumbers.length)
                          ? 2
                          : orderData.lotteryNumbers.length,
                      });
                    }}
                  >
                    {
                      (lotteryNumbersLimit === 2) ? '展开' : '关闭'
                    }
                  </Text>
                )
                : null
              }
           </View>
         </View>
         {/* 订单信息 */}
         <View style={[styles.goodsOrderItemInfo]}>
           {
            orderData.awardUsage === 'expense'
              ? null
              : (
                <View style={[CommonStyles.flex_start, styles.flex_1, styles.btmLabelWrap, { paddingTop: 15 }]}>
                  <Text style={styles.btmLabel}>总计：</Text>
                  <Text style={[styles.btmLabel, styles.bottomValueStyle]}>{`${math.divide(orderData.price, 100) || 0}消费券`}</Text>
                </View>
              )
          }
           <View style={[CommonStyles.flex_start, styles.flex_1, styles.btmLabelWrap, orderData.awardUsage === 'expense' ? { paddingTop: 15 } : null]}>
             <Text style={styles.btmLabel}>期数：</Text>
             <Text style={[styles.btmLabel, styles.bottomValueStyle]}>{(orderData.currentNper < 10) ? `第0${orderData.currentNper || 1}期` : `第${orderData.currentNper || 1}期`}</Text>
           </View>
           <View style={[CommonStyles.flex_start, styles.flex_1, styles.btmLabelWrap]}>
             <Text style={styles.btmLabel}>订单编号：</Text>
             <Text style={[styles.btmLabel, styles.bottomValueStyle]}>{orderData.orderId}</Text>
           </View>
           <View style={[CommonStyles.flex_start, styles.flex_1, styles.btmLabelWrap]}>
             <Text style={styles.btmLabel}>下单时间：</Text>
             <Text style={[styles.btmLabel, styles.bottomValueStyle]}>
               {
                orderData.createdAt
                  ? moment(orderData.createdAt * 1000).format('YYYY-MM-DD HH:mm')
                  : moment().format('YYYY-MM-DD HH:mm')
              }
             </Text>
           </View>
           <View style={[CommonStyles.flex_start, styles.flex_1, styles.btmLabelWrap, { paddingBottom: 15 }]}>
             <Text style={styles.btmLabel}>兑奖方式：</Text>
             <Text style={[styles.btmLabel, styles.bottomValueStyle]}>{orderData.awardUsage !== 'expense' ? '消费券兑奖' : '抽奖券抽奖'}</Text>
           </View>
         </View>
       </React.Fragment>
     );
   }
}

const styles = StyleSheet.create({
  prizeTitleWrap: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
    padding: 14,
    backgroundColor: '#fff',
  },
  prizeNumberWrap: {
    backgroundColor: '#fff',
    borderRadius: 10,
    borderWidth: 1,
    marginHorizontal: 10,
    marginTop: 10,
    borderColor: 'rgba(231,231,231,1)',
    overflow: 'hidden',
  },
  prizeNumLable: {
    color: '#4A90FA',
    fontSize: 17,
  },
  goodsOrderItemInfo: {
    marginTop: 10,
    marginHorizontal: 10,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(231,231,231,1)',
    overflow: 'hidden',
  },
  btmLabelWrap: {
    paddingHorizontal: 15,
    paddingVertical: 7.5,
    backgroundColor: '#fff',
    borderColor: '#fff',
  },
  btmLabel: {
    fontSize: 14,
    color: '#777',
    minWidth: 70,
  },
  bottomValueStyle: {
    fontSize: 14,
    color: '#222',
    flex: 1,
  },
  crashLabelWrap: {
    paddingBottom: 7,
  },
  crashLabel: {
    fontSize: 14,
    color: '#555',
  },

  itemValueStyle: {
    fontSize: 14,
    color: '#222',
    flex: 1,
    paddingLeft: 10,
  },
});
