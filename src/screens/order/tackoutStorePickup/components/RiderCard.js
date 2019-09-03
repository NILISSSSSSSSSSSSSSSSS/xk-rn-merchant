/**
 * 物流选择 -  骑手信息显示卡片
 */
import React, { Component } from 'react';
import {
  Text, View, Dimensions, StyleSheet, Image,
} from 'react-native';
import CommonStyles from '../../../../common/Styles';

import List, { ListItem, Splitter } from '../../../../components/List';

const { width, height } = Dimensions.get('window');

const getWidth = dP => dP * width / 375;

export default class RiderCard extends Component {
  renderExtra(currentPickRider) {
    return (
      <View style={CommonStyles.flex_center}>
        { currentPickRider.distance != undefined ? (
          <Text style={styles.extra}>
            距离你
            {' '}
            <Text style={styles.highlight}>
              {currentPickRider.distance}
              m
            </Text>
          </Text>
        ) : null }
        <Text style={styles.extra}>
          当前接单量
          {' '}
          <Text style={styles.highlight}>{currentPickRider.orderNum || 0}</Text>
        </Text>
      </View>
    );
  }

  renderTitle = item => (
    <View style={[CommonStyles.flex_start, { height: 16, marginBottom: 10 }]}>
      <Text numberOfLines={1} ellipsizeMode="tail" style={[styles.title, { maxWidth: getWidth(114) }]}>{item.realName}</Text>
      <Image
        source={require('../../../../images/logistics/auth.png')}
        style={{
          marginLeft: 8, marginRight: 6, width: 16, height: 16,
        }}
      />
      <Image source={require('../../../../images/logistics/health.png')} style={{ width: 16, height: 16 }} />
    </View>
  )

  render() {
    const { onNavigate = () => {}, currentPickRider: item = null, style } = this.props;
    return (
      <List style={[styles.card, style]}>
        <ListItem
            title="选择配送骑手"
            style={styles.item}
            titleStyle={styles.titleStyle}
            arrow
            onPress={() => onNavigate()}
        />
        <Splitter />
        {
            item ? (
              <ListItem
                  style={{
                    backgroundColor: '#fff',
                    borderRadius: 8,
                  }}
                  title={this.renderTitle(item)}
                  icon={item.avatar ? { uri: item.avatar } : require('../../../../images/order/head_portrait.png')}
                  iconStyle={{ width: 50, height: 50 }}
                  subtitle={item.phone}
                  subtitleStyle={{
                    color: '#999',
                    fontSize: 12,
                  }}
                  extra={this.renderExtra(item)}
              />
            ) : (
              <View style={[CommonStyles.flex_center, { height: 80 }]}>
                <Text style={styles.gray}>请选择配送骑手</Text>
              </View>
            )
        }
        {
          item && item.isLast ? <View style={CommonStyles.flex_end}><Text style={styles.highlight}>最近一次派单</Text></View> : null
        }
      </List>
    );
  }
}

const styles = StyleSheet.create({
  card: {
    width: '100%',
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  title: {
    color: '#222',
    fontSize: 14,
    fontWeight: 'bold',
  },
  subtitle: {
    color: '#999',
    fontSize: 12,
  },
  extra: {
    color: '#222',
    fontSize: 12,
  },
  highlight: {
    color: '#4A90FA',
    fontSize: 12,
  },
  titleStyle: {
    color: '#222',
    fontSize: 14,
  },
  item: {
    height: 44,
    paddingVertical: 0,
  },
  gray: {
    color: '#CCC',
    fontSize: 14,
  },
});
