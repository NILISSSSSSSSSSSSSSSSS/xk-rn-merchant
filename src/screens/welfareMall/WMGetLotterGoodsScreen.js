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
  ImageBackground,
  TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import * as requestApi from '../../config/requestApi';
import Process from '../../components/Process';
import TextInputView from '../../components/TextInputView';
import { getPreviewImage } from '../../config/utils';
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

export default class WMGetLotterGoodsScreen extends Component {
    state = {
      adress: null,
    }


    componentDidMount() {
      Loading.show();
      requestApi.merchantDefault()
      .then(res => res && this.getDefaultAdressData(res))
      .catch((err)=>{
        console.log(err)
      });
    }

    getDefaultAdressData = (adress) => {
      const [provinceName, cityName, districtName] = Address.getNamesByDistrictCode(adress.districtCode);
      this.setState({
        adress: {
          ...adress, provinceName, cityName, districtName,
        },
      });
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
      console.log(data);
      return data.map((item, index) => (
        <View style={styles.itemContaner} key={item.goodsId}>
          <View style={{
            flexDirection: 'row', marginLeft: 10, marginRight: 10, flex: 1,
          }}
          >
            <Image source={{ uri: getPreviewImage(item.url, '50p') }} style={styles.itemImg} />
            <View style={styles.rightView}>
              <View>
                <Text style={{ color: '#222222', fontSize: 12 }}>{item.name}</Text>
              </View>
            </View>
          </View>
        </View>
      ));
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
      if (adress && adress.street) {
        return (
          <View style={styles.addressWrap}>
            <Image
            source={require('../../images/wm/winLotterBg.png')}
            style={{
              width, height: 94, position: 'absolute', top: 0,
            }}
            />
            <TouchableOpacity onPress={this.toDeliveryAddress} activeOpacity={0.95}>
              <View style={[styles.addressWrapStyle]}>
                <View style={[CommonStyles.flex_between]}>
                  <View style={[CommonStyles.flex_start]}>
                    <Image source={require('../../images/wm/pastWinnerIcon.png')} />
                    <Text style={{ fontSize: 14, color: '#222', paddingLeft: 7 }}>收货地址</Text>
                  </View>
                  <Image source={require('../../images/wm/gotomore.png')} />
                </View>

                <View style={[CommonStyles.flex_start, { marginTop: 20 }]}>
                  <Text style={{ fontSize: 14, color: '#555' }}>{adress.receiver}</Text>
                  <Text style={{ fontSize: 14, color: '#555', paddingLeft: 15 }}>{adress.phone}</Text>
                </View>
                <Text numberOfLines={2} style={styles.addressText}>
                  {`${adress.provinceName}${adress.cityName}${adress.districtName}${adress.poiName}${adress.street.replace(/[\r\n]/g, '')}`}
                </Text>
              </View>
            </TouchableOpacity>
          </View>
        );
      }
      return (
        <View style={[styles.titleAdress, { justifyContent: 'center' }]}>
          <TouchableOpacity
            activeOpacity={0.95}
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

    payOrder = () => {
      const address = this.state.adress;
      const { navigation } = this.props;
      const data = navigation.getParam('jOrderLotteryVO', {});
      console.log('address', address);
      if (!address) {
        Toast.show('请选择收货地址！');
        return;
      }
      const params = {
        orderId: data.orderId,
        addressId: address.id,
      };
      requestApi.platOrderDoDelivery(params).then((res) => {
        console.log(res);
        navigation.navigate('WMGoodsDamagSuccessful', {
          title: '领取成功', resultType: 5,
        });
      }).catch((err) => {
        console.log(err);
      });
    }

    render() {
      const { navigation } = this.props;
      // console.log(this.props)
      const data = navigation.getParam('data', []);
      console.log(data);
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
          {
            this.renderAdress()
          }
          {
            data.map((item, index) => (
              <View style={styles.itemContaner} key={index}>
                <View style={{
                  flexDirection: 'row', marginLeft: 15, marginRight: 15, flex: 1,
                }}
                >
                  <View style={{
                    borderRadius: 8, borderWidth: 1, borderColor: '#e5e5e5', borderRadius: 10,
                  }}
                  >
                    <Image source={{ uri: item.mainPic }} style={styles.itemImg} />
                  </View>
                  {
                    item.attr 
                      ? <View style={styles.rightView}>
                          <View>
                            <Text style={{ color: '#222222', fontSize: 12 }}>{item.name}</Text>
                            <Text style={{ color: '#555', fontSize: 12, marginTop: 10 }}>{`规格：${item.attr || '无'} x 1`}</Text>
                          </View>
                        </View>
                      : null
                  }
                </View>
              </View>
            ))
            }
          <View style={{
            width, height: 50, flexDirection: 'row', position: 'absolute', bottom: CommonStyles.footerPadding, ...CommonStyles.flex_end, backgroundColor: '#fff',
          }}
          >
            <TouchableOpacity
              style={{
                width: 70, height: 22, backgroundColor: '#fff', ...CommonStyles.flex_center, borderColor: '#EE6161', borderWidth: 1, borderRadius: 20, marginRight: 25,
              }}
              onPress={this.payOrder}
            >
              <Text style={{ fontSize: 12, color: '#EE6161', textAlign: 'center' }}>
                确认
              </Text>
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
  addressWrap: {
    height: 169,
    width,
    position: 'relative',
  },
  centerContent: {
    // flex: 1,
    width: getwidth(355),
    marginTop: 10,
    // marginBottom: 60,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 0.5,
    borderColor: 'rgba(215,215,215,0.2)',
    overflow: 'hidden',
  },
  itemContaner: {
    flexDirection: 'row',
    paddingVertical: 15,
    backgroundColor: '#fff',
    margin: 10,
    borderRadius: 8,
    borderWidth: 0.7,
    borderColor: '#f1f1f1',
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
    borderRadius: 8,
  },
  rightView: {
    flex: 1,
    // marginLeft: 10,
    paddingHorizontal: 15,
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
  addressWrapStyle: {
    marginHorizontal: 10,
    marginTop: 30,
    padding: 15,
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  addressText: {
    fontSize: 14,
    color: '#777',
    lineHeight: 20,
    marginTop: 10,
  },
});
