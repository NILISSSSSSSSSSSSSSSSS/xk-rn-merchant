/**
 * 福利订单待开奖详情
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import * as nativeApi from '../../config/nativeApi';

import Header from '../../components/Header';
import WMOrderInfoWrap from '../../components/WMOrderInfoWrap';
import CommonStyles from '../../common/Styles';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import * as requestApi from '../../config/requestApi';
import CountDown from '../../components/CountDown';
import math from '../../config/math';
import Process from '../../components/Process'
const { width, height } = Dimensions.get('window');
import { showSaleNumText } from '../../config/utils'
class WMOpenPrizeDetailScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    };
    componentDidMount() {
      Loading.show();
      this.getData();
    }

    componentWillUnmount() { }

    getData = () => {
      const { navigation } = this.props;
      const orderId = navigation.getParam('orderId', '');
      console.log('orderId', orderId);
      const params = {
        orderId,
      };
      this.props.dispatch({ type: 'welfare/qureyWMOrderDetail', payload: { params } });
    };

    getOrderStatus = (data) => {
      const value = math.multiply(math.divide(data.joinCount , data.maxStake) ,100) ;
      // eslint-disable-next-line radix
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const surplusTime = moment(data.expectDrawTime * 1000).format('MM-DD HH:mm');
      let diffTime = 0;
      if (data.drawType !== 'bymember') {
        const expectTime = moment(data.expectDrawTime * 1000).format('YYYY-MM-DD HH:mm:ss');
        const nowdate = moment().format('YYYY-MM-DD HH:mm:ss');
        diffTime = moment(nowdate).diff(moment(expectTime)); // 时间差
      }
      const waitLabel = <Text style={{ fontSize: 14, color: '#222' }}>等待开奖中，请耐心等待</Text>;
      console.log('processValue', processValue);
      let fixedNumber = data.maxStake > 100000 ? 0 : 1;
      let joinNumber = showSaleNumText(data.joinCount, fixedNumber)
      let maxStakeNumber = showSaleNumText(data.maxStake,fixedNumber)
      switch (data.drawType) {
        case 'bytime':
          return (
            <View style={[styles.topStatus, styles.border, CommonStyles.flex_start, styles.borderRadius]}>
              <Image style={styles.topStatusImage} source={require('../../images/wm/clock_icon.png')} />
              { diffTime > 0 ? waitLabel : this.getTopOrderStatusLabel('开奖时间：', surplusTime) }
            </View>
          );
        case 'bytime_or_bymember':
          return (
            <React.Fragment>
              <View style={[styles.topStatus, styles.border, styles.flexStart_noItemCenter, styles.borderRadius]}>
                <Image
                  style={styles.topStatusImage}
                  source={require('../../images/wm/clock_icon.png')}
                />
                <View style={styles.flex_1}>
                  {
                    diffTime > 0 || processValue === 100
                      ? waitLabel
                      : (
                        <React.Fragment>
                          {this.getTopOrderStatusLabel('开奖进度：', processValue, {},`${joinNumber}/${maxStakeNumber}`)}
                          {this.getTopOrderStatusLabel('开奖时间：', surplusTime, { marginTop: 2 })}
                        </React.Fragment>
                      )
                  }
                  <View style={[CommonStyles.flex_start]}>
                    {
                      diffTime > 0 || processValue === 100
                        ? null
                        : (
                          <Text style={[styles.topStatusText, styles.yellowColor, { fontSize: 14, marginTop: 3, lineHeight: 18 }]}>
                          注意：满足以上任意一个条件就可以开奖哦！
                          </Text>
                        )
                    }
                  </View>
                </View>
              </View>
            </React.Fragment>
          );
        case 'bymember':
          return (
            <View style={[styles.topStatus, styles.border, CommonStyles.flex_start, styles.borderRadius]}>
              <Image style={styles.topStatusImage} source={require('../../images/wm/clock_icon.png')} />
              { processValue === 100 ? waitLabel : this.getTopOrderStatusLabel('开奖进度：', processValue, {}, `${joinNumber}/${maxStakeNumber}`) }
            </View>
          );
        case 'bytime_and_bymember':
          return (
            <React.Fragment>
              <View style={[styles.topStatus, styles.border, styles.flexStart_noItemCenter, styles.borderRadius]}>
                <Image style={styles.topStatusImage} source={require('../../images/wm/clock_icon.png')} />
                <View style={styles.flex_1}>
                  {
                    diffTime > 0 && processValue === 100
                      ? waitLabel
                      : (
                        <React.Fragment>
                          { this.getTopOrderStatusLabel('开奖进度：', processValue, {},`${joinNumber}/${maxStakeNumber}`) }
                          { this.getTopOrderStatusLabel('开奖时间：', surplusTime, { marginTop: 2 }) }
                        </React.Fragment>
                      )
                  }
                  <View style={[styles.flex_1, CommonStyles.flex_start]}>
                    {
                      diffTime > 0 && processValue === 100
                        ? null
                        : (
                          <Text style={[styles.topStatusText, styles.yellowColor, { fontSize: 14, marginTop: 3, lineHeight: 18 }]}>
                          注意：需满足以上两个条件才可以开奖哦！
                          </Text>
                        )
                    }
                  </View>
                </View>
              </View>
            </React.Fragment>
          );
        default: return null;
      }
    };

    getTopOrderStatusLabel = (label = '', value = moment(), wrapStyle = {}, showText = '') => {
      const showCountDown = ((typeof value) === 'string' || (typeof value) === 'number') ? false : true;
      const showProcess = (typeof value) === 'number';
      console.log('showText',showText)
      return (
        <View style={[styles.flexStart_noItemCenter,CommonStyles.flex_1, wrapStyle]}>
          <Text style={[styles.topStatusText]}>{label}</Text>
          {
            showCountDown
              ? (
                <CountDown
                  label=""
                  type="orderApply"
                  date={value || moment()}
                  days={{ plural: '天 ', singular: '天 ' }}
                  hours=":"
                  mins=":"
                  segs=""
                  daysStyle={styles.timeText}
                  hoursStyle={styles.timeText}
                  minsStyle={styles.timeText}
                  secsStyle={styles.timeText}
                  firstColonStyle={styles.timeText}
                  secondColonStyle={styles.timeText}
                />
              )
              : showProcess
                ? <Process showText={showText}  nowValue={value} height={6}/>
                : <Text style={styles.topStatusText}>{value}</Text>
          }
        </View>
      );
    }

    getCrashNumItem = (label = '', value = '', index) => (
      <View
        key={index}
        style={[CommonStyles.flex_start, styles.flex_1, styles.crashLabelWrap]}
      >
        <Text style={styles.crashLabel}>{label}</Text>
        <Text style={[styles.crashLabel, { fontSize: 12 }]}>
          {value}
        </Text>
      </View>
    );

    // 跳转到客服
    gotoCunstom = () => {
      nativeApi.createXKCustomerSerChat();
    }

    render() {
      const { navigation, orderData } = this.props;
      // const processValue = (math.multiply((math.divide(orderData.joinCount , orderData.maxStake))).toFixed(1) , 100) ;
      // console.log('orderData111', orderData);
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="订单详情"
          />
          <ScrollView
            style={{ marginBottom: CommonStyles.footerPadding }}
            showsHorizontalScrollIndicator={false}
            showsVerticalScrollIndicator={false}
          >
            {this.getOrderStatus(orderData)}
            <View style={[styles.addressView, styles.borderRadius, styles.border]}>
              <View style={[CommonStyles.flex_start]}>
                <Image source={require('../../images/wm/localtion_icon.png')} />
                <Text style={[styles.userInfoText, { marginLeft: 5, marginRight: 15 }]}>{orderData.userName}</Text>
                <Text style={styles.userInfoText}>{orderData.userPhone}</Text>
              </View>
              <Text style={styles.addressInfoText} numberOfLines={2}>{orderData.userAddress}</Text>
            </View>
            <View style={[styles.goodsWrap]}>
              <View style={[CommonStyles.flex_start, styles.goodsBorder]}>
                <WMGoodsWrap
                  imgHeight={80}
                  imgWidth={80}
                  imgUrl={orderData.mainUrl}
                  title={orderData.goodsName}
                  showProcess={false}
                  showPrice={false}
                  goodsTitleStyle={styles.goodsTitleStyle}
                >

                  {
                    orderData.showSkuName
                    ? <View style={[CommonStyles.flex_start_noCenter, { marginTop: 10 }]}>
                        <Text style={[styles.goodsInfoText, { color: '#555' }]}>
                          规格参数：
                        </Text>
                        <Text style={[styles.goodsInfoText, CommonStyles.flex_1]}>
                          {`${orderData.showSkuName || '无'} x ${orderData.myStake}`}
                        </Text>
                    </View>
                    : null
                  }
                  <View style={[CommonStyles.flex_start_noCenter, { marginTop: 7 }]}>
                    <Text style={[styles.goodsInfoText, { color: '#555' }]}>
                      消费券：
                    </Text>
                    <Text style={[styles.goodsInfoText, { color: '#EE6161' }, CommonStyles.flex_1]}>
                      {`${math.divide(orderData.eachPrice, 100)}每注`}
                    </Text>
                  </View>
                </WMGoodsWrap>
              </View>
            </View>
            <View style={styles.goodsOrderItemInfo}>
              <WMOrderInfoWrap orderData={orderData} />
            </View>
          </ScrollView>
          <View style={styles.bottomBar}>
            <TouchableOpacity
              style={[styles.bottomBtn, styles.flexStart]}
              onPress={() => {
                this.gotoCunstom();
              }}
            >
              <View style={[styles.cunstomTextWrap, CommonStyles.flexCenter]}>
                <Text style={{
                  color: '#555', fontSize: 12, height: 22, lineHeight: 22, textAlign: 'center',
                }}
                >
                  联系客服
                </Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  flexStart_noItemCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexCenter: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  flexWrap: {
    flexWrap: 'wrap',
  },
  borderRadius: {
    borderRadius: 8,
  },
  border: {
    borderWidth: 1,
    borderColor: 'rgba(215,215,215,0.5)',
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  flex_1: {
    flex: 1,
  },
  topStatus: {
    margin: 10,
    marginBottom: 0,
    padding: 15,
    backgroundColor: '#fff',
  },
  topStatusText: {
    color: '#222',
    fontSize: 17,
  },
  topStatusImage: {
    marginTop: 1,
    marginRight: 6,
  },
  addressView: {
    margin: 10,
    padding: 15,
    backgroundColor: '#fff',
  },
  userInfoText: {
    fontSize: 14,
    color: '#555',
  },
  goodsImg: {
    height: 80,
    width: 80,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(231,231,231,1)',
  },
  goodsWrap: {
    backgroundColor: '#fff',
    margin: 10,
    marginTop: 0,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(231,231,231,1)',
    overflow: 'hidden',
  },
  goodsOrderItemInfo: {
    marginBottom: 66,
    marginTop: -10,
  },
  goodsTitle: {
    fontSize: 12,
    color: '#222',
    lineHeight: 17,
    paddingLeft: 15,
  },
  Specifications: {
    color: '#555',
    fontSize: 12,
    paddingLeft: 15,
    marginTop: 10,
  },
  goodsImgWrap: {
    padding: 15,
  },
  redColor: {
    color: '#EE6161',
  },
  goodsInfoText: {
    marginTop: 5,
    fontSize: 12,
    color: '#777',
  },
  goodsBorder: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
    width: '100%',
  },
  btmLabelWrap: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
    padding: 14,
    backgroundColor: '#fff',
  },
  btmLabel: {
    fontSize: 14,
    color: '#777',
    minWidth: 70,
  },
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
    borderTopWidth: 1,
    borderTopColor: 'rgba(215,215,215,0.5)',
  },
  bottomBtn: {
    paddingHorizontal: 14,
    height: '100%',
  },
  goodsTitleStyle: {
    fontSize: 12,
    color: '#222',
  },
  prizeNumLable: {
    color: '#4A90FA',
    fontSize: 17,
  },
  crashLabelWrap: {
    paddingBottom: 7,
  },
  crashLabel: {
    fontSize: 14,
    color: '#555',
  },
  cunstomTextWrap: {
    width: 70,
    height: 22,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#f1f1f1',
  },
  addressInfoText: {
    fontSize: 14,
    color: '#777',
    paddingLeft: 19,
    marginTop: 10,
    lineHeight: 20,
  },
  timeText: {
    color: '#EE6161',
    fontSize: 17,
    backgroundColor: '#fff',
  },
  yellowColor: {
    color: '#FF8523',
  },
});

export default connect(
  state => ({ orderData: state.welfare.wmOrderDetail }),
)(WMOpenPrizeDetailScreen);
