/**
 * 物流选择 -  收货人信息显示卡片
 */
import React, { Component } from 'react';
import {
  Text, View, StyleSheet, Image,
} from 'react-native';

const locationImg = require('../../../../images/logistics/location.png');

export default class ReceiverCard extends Component {
  render() {
    const { name = '上官楚楚', phone = '18692517988', address = '四川成都天府一街天府二街之间泰然·环球时代中心B座90' } = this.props;

    return (
      <View style={styles.card}>
        <View style={styles.cardContent}>
          <View style={styles.iconContainer}>
            <Image source={locationImg} style={styles.locationIcon} />
          </View>
          <View style={styles.receiverInfo}>
            <View style={styles.nameContainer}>
              <Text style={styles.name}>{name}</Text>
              <Text style={styles.mobile}>{phone}</Text>
            </View>
            <Text numberOfLines={2} ellipsizeMode="tail" style={styles.addresss}>{address}</Text>
          </View>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  card: {
    width: '100%',
    height: 90,
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  cardContent: {
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'row',
    margin: 15,
  },
  iconContainer: {
    width: 20,
    height: '100%',
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  locationIcon: {
    width: 10,
    height: 10,
    marginTop: 5,
  },
  receiverInfo: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'flex-start',
    flexDirection: 'column',
  },
  nameContainer: {
    flexDirection: 'row',
  },
  name: {
    fontWeight: 'bold',
    color: '#222222',
    fontSize: 14,
  },
  mobile: {
    color: '#777777',
    fontSize: 14,
    marginLeft: 15,
  },
  addresss: {
    color: '#222222',
    lineHeight: 17,
    marginTop: 13,
    fontSize: 12,
  },
});
