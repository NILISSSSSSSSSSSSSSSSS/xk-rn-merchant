/**
 * 夺宝购物车订单
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
  TextInput,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import * as requestApi from '../../config/requestApi';
import Process from '../../components/Process';
import TextInputView from '../../components/TextInputView';
import { getPreviewImage, debounce, showSaleNumText } from '../../config/utils';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import { JOIN_AUDIT_STATUS } from '../../const/user';
import math from '../../config/math.js';
import * as Address from '../../const/address';

const { width, height } = Dimensions.get('window');
const adresspic = require('../../images/indianashopcart/address.png');
const fuwulei = require('../../images/categroy/fuwulei.png');
const unchecked = require('../../images/mall/unchecked.png');
const checked = require('../../images/mall/checked.png');
const tiaozhuan = require('../../images/indianashopcart/tiaozhuan.png');

function getwidth(val) {
  return width * val / 375;
}

class IndianaShopOrder extends Component {
  constructor(props) {
    super(props);
    this.state = {
      adress: null,
      remark: '',
      height: 0,
      userCurrency: 0, // 用户余额
    };
    this.handlePay = debounce(this.payOrder);
  }
    getDefaultAdressData = (adress) => {
      const [provinceName, cityName, districtName] = Address.getNamesByDistrictCode(adress.districtCode);
      this.setState({
        adress: {
          ...adress, provinceName, cityName, districtName,
        },
      });
    }
    // 获取用户余额
    muserAccDetail = () => {
      const pararms = {
        currency: 'xfq',
      };
      requestApi.muserAccDetail(pararms).then((res) => {
        console.log('用户余额', res);
        if (res) {
          this.setState({
            userCurrency: parseFloat(res.userAccXfq.usable || 0),
          });
        }
      }).catch((err) => {
        console.log(err);
      });
    }
    componentDidMount() {
      Loading.show();
      requestApi.merchantDefault()
      .then(res => res && this.getDefaultAdressData(res))
      .catch((err)=>{
        console.log(err)
      });
      const { auditStatus, createdMerchant } = this.props.userInfo;
      // 商户未入驻，不获取商户余额
      if (auditStatus !== JOIN_AUDIT_STATUS.success || createdMerchant !== 1) {
        return;
      }
      this.muserAccDetail();
    }

    changeState = (key = '', value = '', callback = () => { }) => {
      this.setState({
        [key]: value,
      }, () => {
        callback();
      });
    }
    renderItem = () => {
      const data = this.props.navigation.state.params.data;
      return data.map((item, index) => {
        console.log(item);
        const time = moment(item.drawTime * 1000).format('MM-DD HH:mm');
        const value = math.multiply(math.divide(item.participateStake, item.maxStake), 100);
        const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
        const processPercent = `${processValue}%`;
        const fixedNumber = item.maxStake > 100000 ? 0 : 1;
        const showText = `${showSaleNumText(item.participateStake, fixedNumber)}/${showSaleNumText(item.maxStake, fixedNumber)}`;
        return (
          <WMGoodsWrap
            key={index}
            imgUrl={item.url}
            title={item.name}
            showProcess
            showPrice={false}
            type={item.drawType}
            processValue={processValue}
            label="开奖进度："
            timeLabel="开奖时间："
            timeValue={time}
            showText={showText}
            labelStyle={styles.labelStyle}
            imgStyle={styles.imgStyle}
            goodsTitleStyle={styles.goodsTitleStyle}
          >
            <View style={[CommonStyles.flex_between, { paddingTop: 8, paddingLeft: 10 }]}>
              <View style={[CommonStyles.flex_start]}>
                <Text style={{ fontSize: 12, color: '#777' }}>消费券：</Text>
                <Text style={[styles.color_red, { fontSize: 12 }]}>{item.price / 100}</Text>
              </View>
              <Text style={{ fontSize: 12, color: '#777' }}>
                {' '}
                  x
                {' '}
                {item.quantity}
              </Text>
            </View>
          </WMGoodsWrap>
        );
      });
    }
    getAdressData = (adress) => {
      this.setState({
        adress,
      });
    }
    // DeliveryAddress
    toDeliveryAddress = () => {
      const { navigation } = this.props;
      navigation.navigate('DeliveryAddress', { callBack: this.getAdressData });
    }
    renderAdress = () => {
      const { adress } = this.state;
      if (adress) {
        return (
          <View style={styles.titleAdress}>
            <TouchableOpacity onPress={this.toDeliveryAddress}>
              <View style={{ flexDirection: 'row', marginTop: 10, justifyContent: 'space-between' }}>
                <Text style={{ color: '#222222', fontSize: 14, maxWidth: 180 }} numberOfLines={1}>
                  收货人：
                  {adress.receiver}
                </Text>
                <Text style={{ color: '#222222', fontSize: 14 }}>{adress.phone}</Text>
              </View>
              <View style={{ flexDirection: 'row', marginTop: 15 }}>
                <Image source={adresspic} style={{ marginTop: 3 }} />
                <Text
                  numberOfLines={2}
                  style={{
                    marginLeft: 5, color: '#222222', fontSize: 12, paddingRight: 10, lineHeight: 17,
                  }}
                >
                  地址：
                  {adress.provinceName}
                  {adress.cityName}
                  {adress.districtName}
                  {adress.poiName}
                  {adress.street}
                </Text>
              </View>
            </TouchableOpacity>
          </View>
        );
      }
      return (
        <View style={[styles.titleAdress, { justifyContent: 'center' }]}>
          <TouchableOpacity
          onPress={this.toDeliveryAddress}
          style={{ flexDirection: 'row', justifyContent: 'space-around', alignItems: 'center' }}
          >
            <Image source={adresspic} />
            <Text style={{ width: getwidth(250) }}>您还没有添加收货地址，请点击右侧添加一个收获地址</Text>
            <Image source={tiaozhuan} />
          </TouchableOpacity>
        </View>
      );
    }
    getTotalPrice = () => {
      const { navigation } = this.props;
      const data = navigation.state.params.data;
      let totalPrices = 0;
      data.forEach((item) => {
        totalPrices += item.price * item.quantity;
      });
      return totalPrices;
    }
    payOrder = () => {
      const { navigation, checkAuditStatus } = this.props;
      const { adress, remark, userCurrency } = this.state;
      const data = navigation.state.params.data;

      checkAuditStatus(() => {
        if (!adress) {
          Toast.show('请选择地址', 2000);
          Loading.hide();
          return;
        }
        const param = {
          jOrderCreate: {
            remark,
            addressId: adress.id,
            totalPrices: '',
            sequences: [],
          },
        };
        let totalPrices = 0;
        data.forEach((item) => {
          param.jOrderCreate.sequences.push({
            num: item.quantity,
            sequenceId: item.sequenceId,
          });
          totalPrices += item.price * item.quantity;
        });
        if (parseFloat(userCurrency) === 0 || parseFloat(userCurrency) < math.divide(totalPrices, 100)) {
          Toast.show('您的消费券不足！');
          console.log('userCurrency', userCurrency)
          console.log('totalPrices', math.divide(totalPrices, 100))
          Loading.hide();
          return;
        }
        param.jOrderCreate.totalPrices = totalPrices;
        console.log('order', JSON.stringify(param));
        requestApi.jmallOrderCreate(param).then((res) => {
          console.log('下单，', res);
          const callback = navigation.getParam('callback', () => { });
          // 刷新购物车
          callback();
          navigation.navigate('IndianaShopPay');
        }).catch((err) => {
          console.log('err', err);
          // Toast.show(res.message, 2000)
        });
      });
    }
    render() {
      const { navigation } = this.props;
      const { adress, remark } = this.state;
      const totalPrices = this.props.navigation.state.params.totlePrice;
      const orderPice = adress && adress.id ? math.divide(totalPrices, 100) : math.divide(this.getTotalPrice(), 100);
      let textHeight = Math.max(38, this.state.height);
      if (textHeight >= 80) {
        textHeight = 80;
      }
      return (
        <View style={styles.container}>
          <Header
          navigation={navigation}
          goBack
          centerView={(
            <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
              <Text style={{ fontSize: 17, color: '#fff' }}>确认订单</Text>
            </View>
          )}
          />
          <ScrollView
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
          style={{ marginBottom: 50 + CommonStyles.footerPadding }}
          >
            {
              this.renderAdress()
            }
            <View style={styles.centerContent}>
              {
                this.renderItem()
              }
              <View style={[CommonStyles.flex_start_noCenter, {
                paddingHorizontal: 15, borderTopColor: '#f1f1f1', borderTopWidth: 1, marginBottom: 10,
              }]}
              >
                <Text style={{ paddingVertical: 10, color: '#222' }}>备注：</Text>
                <TextInput
                multiline
                onContentSizeChange={(e) => {
                  this.setState({
                    height: this.state.height + 28,
                  });
                }}
                onChangeText={(text) => {
                  if (text.length >= 50) {
                    Toast.show('最多输入50个字哦');
                    return;
                  }
                  this.setState({
                    remark: text,
                  });
                }}
                returnKeyLabel="确定"
                returnKeyType="done"
                maxLength={50}
                style={[{ height: textHeight }, { flex: 1, textAlignVertical: 'top' }]}
                value={this.state.remark}
                />
              </View>
            </View>
          </ScrollView>
          <View style={{
            width, height: 50, flexDirection: 'row', position: 'absolute', bottom: CommonStyles.footerPadding,
          }}
          >
            <View style={{
              flex: 1, backgroundColor: '#FFFFFF', flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end',
            }}
            >
              <Text style={{ color: '#222222', fontSize: 14 }}>消费券：</Text>
              <Text style={{ color: '#EE6161', fontSize: 16, marginRight: 20 }}>{orderPice}</Text>
            </View>
            <TouchableOpacity
            style={{
              width: getwidth(105), height: 50, backgroundColor: '#EE6161', marginRight: 0, alignItems: 'center', justifyContent: 'center',
            }}
            onPress={() => {
              Loading.show();
              this.handlePay();
            }}
            >
              <Text style={{ color: '#FFFFFF', fontSize: 17 }}>兑奖</Text>
            </TouchableOpacity>
          </View>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  titleAdress: {
    width: getwidth(355),
    height: 84,
    backgroundColor: '#FFFFFF',
    marginTop: 10,
    paddingHorizontal: 10,
    borderRadius: 8,
    borderWidth: 0.5,
    borderColor: 'rgba(215,215,215,0.2)',
  },
  centerContent: {
    // flex: 1,
    marginTop: 10,
    marginBottom: 60,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 0.5,
    borderColor: 'rgba(215,215,215,0.2)',
    overflow: 'hidden',
  },
  itemContaner: {
    flexDirection: 'row',
    paddingVertical: 15,
  },
  optItem: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  itemImg: {
    width: getwidth(80),
    height: getwidth(80),
    borderColor: '#E6E6E6',
    borderRadius: 8,
    borderWidth: 1,
  },
  rightView: {
    flex: 1,
    marginLeft: 10,
    paddingHorizontal: 10,
  },
  processSty: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
    flex: 1,
    paddingHorizontal: 8,
  },
  processSty2: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
    justifyContent: 'space-between',
    flex: 1,
    paddingHorizontal: 8,
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 7,
  },
  imgStyle: {
    borderRadius: 8,
  },
  goodsTitleStyle: {
    fontSize: 14,
    lineHeight: 18,
    color: '#222',
  },
  color_red: {
    color: '#EE6161',
  },
});

export default connect(
  state => ({
    userInfo: state.user.user,
  }),
  {
    checkAuditStatus: callback => ({ type: 'user/check', payload: { callback } }),
  },
)(IndianaShopOrder);
