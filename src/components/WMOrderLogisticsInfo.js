import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image, TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import math from '../config/math';

export default class WMOrderLogisticsInfo extends Component {
    static defaultProps = {
      orderData: {

      },
    };

    // 匹配物流信息
    getLogisticsInfo = () => {
      const { orderData } = this.props;
      const { logisticsNo, logisticsName } = orderData;
      switch (logisticsName) {
        case 'XK': return '晓可自营物流';
        case 'SF': return '顺丰';
        case 'YD': return '韵达';
        case 'ZT': return '中通';
        case 'ST': return '申通';
        case 'YT': return '圆通';
        case 'BSHT': return '百世汇通';
        case 'HIMSELF': return '用户自行配送';
        default: return '';
      }
    }

    // 如果后台配置了需要配送
    getNeedLogistics = () => {
      const { orderData } = this.props;
      return (
        <React.Fragment>
          <View style={[styles.logisticsWrap, { marginTop: 10 }]}>
            <View style={[CommonStyles.flex_start, styles.logisticsTitleWrap]}>
              <Text style={styles.logisticsTitle}>
                {this.getLogisticsInfo(orderData.logisticsName)}
                快递:
              </Text>
              <Text style={[styles.logisticsTitle, { fontSize: 12, paddingLeft: 12,color: '#222' }]}>{orderData.logisticsNo}</Text>
            </View>
            {
              orderData.logisticsInfos
                && (
                  <View style={[{ padding: 15, position: 'relative' }]}>
                    {
                    orderData.logisticsInfos.map((item, index) => {
                      let hideLine = index === orderData.logisticsInfos.length - 1;
                      let deepColor = index === 0 ? { color: '#555' } : null;
                      let noMarginBottom = index === orderData.logisticsInfos.length - 1 ? { marginBottom: 0 } : null;
                      return (
                        // eslint-disable-next-line react/no-array-index-key
                        <View style={styles.logItemWrap} key={index}>
                          <View style={styles.logisticsCircle} />
                          {
                            hideLine
                              ? null
                              : (
                                <Image
                                  source={require('../images/wm/logisticsLine.png')}
                                  style={{ position: 'absolute', left: -0.5, top: 0, height: '100%' }}
                                />
                              )
                          }
                          <View style={[CommonStyles.flex_start_noCenter, {
                            flexWrap: 'wrap', position: 'relative', top: -5, marginBottom: 15, ...noMarginBottom
                          }]}
                          >
                            <Text style={[{ marginLeft: 17, fontSize: 12, color: '#999',lineHeight: 17, ...deepColor} ]}>{`${moment(item.time * 1000).format('MM-DD HH:mm')}  ${item.location}`}</Text>
                          </View>
                        </View>
                      )
                    })
                  }
                  </View>
                )
            }
            {
              !orderData.logisticsInfos
              && (
              <View style={[styles.flexStart_noItemCenter, { marginTop: 7 }]}>
                <View style={[styles.flex_1, { paddingLeft: 12, paddingRight: 5, paddingBottom: 7 }]}>
                  <Text style={styles.logisticsLabel}>暂无物流信息</Text>
                </View>
              </View>
              )
            }
          </View>
        </React.Fragment>
      );
    }
    // 如果后台配置不需要配送
    getnotNeedLogistics = () => {
      return (
        <React.Fragment>
          <View style={[styles.logisticsWrap, { marginTop: 10 }]}>
            <View style={[CommonStyles.flex_start, styles.logisticsTitleWrap]}>
              <Text style={styles.logisticsTitle}>不需要物流</Text>
            </View>
            <View style={[styles.flexStart_noItemCenter, { marginTop: 7 }]}>
              <View style={[styles.flex_1, { paddingLeft: 12, paddingRight: 5, paddingBottom: 7 }]}>
                <Text style={styles.logisticsLabel}>晓可客服将尽快与您联系处理！</Text>
              </View>
            </View>
          </View>
        </React.Fragment>
      );
    }
    render() {
      const { orderData } = this.props;
      if(orderData.needLogistics) return this.getNeedLogistics()
      return this.getnotNeedLogistics();
      
    }
}

const styles = StyleSheet.create({
  logisticsWrap: {
    margin: 10,
    marginTop: 0,
    backgroundColor: '#fff',
    borderRadius: 8,
    marginBottom: 66,
    overflow: 'hidden',
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  logisticsTitleWrap: {
    width: '100%',
    paddingHorizontal: 14,
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  logisticsTitle: {
    height: 42,
    lineHeight: 42,
    color: '#777',
    fontSize: 14,
  },
  logisticsLabel: {
    color: '#777',
    lineHeight: 17,
    fontSize: 12,
  },
  logItemWrap: {
    position: 'relative',
  },
  logisticsCircle: {
    height: 7,
    width: 7,
    borderRadius: 10,
    backgroundColor: CommonStyles.globalHeaderColor,
    position: 'absolute',
    top: 0,
    left: -3.5,
    zIndex: 2,
  },
});
