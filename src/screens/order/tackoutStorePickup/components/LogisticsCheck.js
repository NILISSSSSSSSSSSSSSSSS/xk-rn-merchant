/**
 * 物流选择 -  物流方式选择
 */
import React, { Component } from 'react';
import {
  Text, View, StyleSheet, ImageBackground, TouchableOpacity, Dimensions, Image,
} from 'react-native';

const { width, height } = Dimensions.get('window');

const checkList = [
  { title: '晓可配送', value: 'OWN', background: require('../../../../images/logistics/LogRide.png') },
  { title: '第三方配送', value: 'THIRD', background: require('../../../../images/logistics/LogThird.png') },
  { title: '自行配送', value: 'M_HIMSELF', background: require('../../../../images/logistics/LogOwn.png') },
];

const checkedImg = require('../../../../images/logistics/checked.png');
const uncheckedImg = require('../../../../images/logistics/uncheck.png');
const govImg = require('../../../../images/logistics/gov.png');

const getWidth = dP => dP * width / 375;

export default class LogisticsCheck extends Component {
  render() {
    const { value = 'OWN', style, onChange = () => {} } = this.props;
    const objTitle = {
      OWN: '*官方推荐使用晓可配送，快速可靠',
      M_HIMSELF: '*商家自行安排配送',
      THIRD: '*请填写快递单号，并仔细确认，提交后不可修改',
    };
    return (
      <View style={[styles.logisticsCheck, style]}>
        <View style={styles.checkListContainer}>
          {
          checkList.map((item) => {
            const checked = item.value === value;
            return (
              <ImageBackground
              source={item.background}
              style={styles.background}
              >
                <View style={[styles.govImg, { overflow: item.value === 'OWN' ? 'visible' : 'hidden' }]}>
                  <Image source={govImg} style={{ width: getWidth(45), height: getWidth(17) }} />
                </View>
                <TouchableOpacity style={styles.backgroundTouch} onPress={() => onChange(item.value)}>
                  <View style={styles.checkedImg}>
                    <Image source={checked ? checkedImg : uncheckedImg} style={style.image} />
                  </View>
                </TouchableOpacity>
              </ImageBackground>
            );
          })
        }
        </View>
        <View style={styles.postTypeDesc}>
          <Text style={styles.postTypeDescText}>{objTitle[value]}</Text>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  logisticsCheck: {
    width: '100%',
    height: getWidth(175),
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  background: {
    width: getWidth(120),
    height: getWidth(120),
  },
  govImg: {
    width: '100%',
    height: 0,
    overflow: 'visible',
    alignItems: 'flex-end',
  },
  backgroundTouch: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  checkedImg: {
    height: 0,
    overflow: 'visible',
    width: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
    top: getWidth(-12),
  },
  checkListContainer: {
    justifyContent: 'space-around',
    alignItems: 'center',
    flexDirection: 'row',
    marginTop: getWidth(7),
  },
  image: {
    height: getWidth(41),
    width: getWidth(41),
  },
  postTypeDesc: {
    marginTop: getWidth(16),
    marginHorizontal: getWidth(15),
  },
  postTypeDescText: {
    color: '#999',
    fontSize: 12,
  },
});
