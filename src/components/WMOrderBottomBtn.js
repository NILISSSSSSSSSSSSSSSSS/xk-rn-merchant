import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image, TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import math from '../config/math';
import * as nativeApi from '../config/nativeApi';

export default class WMOrderBottomBtn extends Component {
    static defaultProps = {
      orderData: {
      },
    };

    state = {
      lotteryNumbersLimit: 2,
    }

    // 获取底部操作按钮
    getBottomBtnItem = () => {
      const { navigation, orderData } = this.props;
      const param = { orderId: orderData.orderId };
      switch (orderData.state) {
        case 'RECEVING': return (
          <TouchableOpacity
            activeOpacity={0.65}
            style={[styles.bottomBtn, CommonStyles.flex_center]}
            onPress={() => {
              // 晒单
              navigation.navigate('WMShowOrder', param);
            }}
          >
            <Text style={[styles.bottomBtnText]}>晒单有奖</Text>
          </TouchableOpacity>
        );
        case 'WINNING_LOTTERY': return (
          <TouchableOpacity
            activeOpacity={0.65}
            style={[styles.bottomBtn, CommonStyles.flex_center]}
            onPress={() => {
              // 晒单
              navigation.navigate('WMShowOrder', param);
            }}
          >
            <Text style={[styles.bottomBtnText]}>晒单</Text>
          </TouchableOpacity>
        );
        case 'SHARE_AUDIT_ING': return null;
        case 'SHARE_AUDIT_FAIL': return (
          <TouchableOpacity
            activeOpacity={0.65}
            style={[styles.bottomBtn, CommonStyles.flex_center]}
            onPress={() => {
              // 重新晒单
              navigation.navigate('WMShowOrder', param);
            }}
          >
            <Text style={[styles.bottomBtnText]}>重新晒单</Text>
          </TouchableOpacity>
        );
        default: return null;
      }
    }

    // 跳转到客服
    gotoCunstom = () => {
      nativeApi.createXKCustomerSerChat();
    }

    render() {
      const { orderData } = this.props;
      return (
        <React.Fragment>
          <View style={styles.bottomBar}>
            {
              // 如果是待收货，显示货物报损
              (orderData.state === 'DELIVERY')
              && (
                <TouchableOpacity style={[styles.btnWrap, { borderColor: '#e5e5e5', marginRight: 10 }]} onPress={() => { this.hanldeApplyDramg(); }} activeOpacity={0.65}>
                  <Text style={[styles.btnText, { color: '#555' }]}>货物报损</Text>
                </TouchableOpacity>
              )
            }
            <TouchableOpacity style={[styles.btnWrap, { borderColor: '#e5e5e5' }]} onPress={() => { this.gotoCunstom(); }} activeOpacity={0.65}>
              <Text style={[styles.btnText, { color: '#555' }]}>联系客服</Text>
            </TouchableOpacity>
            {
              // 根据当前商品状态获取底部操作栏按钮
              this.getBottomBtnItem()
            }
          </View>
        </React.Fragment>
      );
    }
}

const styles = StyleSheet.create({
  bottomBar: {
    position: 'absolute',
    bottom: 0 + CommonStyles.footerPadding,
    left: 0,
    width: '100%',
    height: 50,
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
    backgroundColor: '#fff',
    paddingHorizontal: 15,
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
  bottomBtn: {
    backgroundColor: '#fff',
    height: 22,
    minWidth: 70,
    paddingHorizontal: 10,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: '#EE6161',
    marginRight: 10,
    marginLeft: 10,
  },

  bottomBtnText: {
    color: '#EE6161',
    fontSize: 12,
  },
});
