import React, { Component } from 'react';
import {
  Text, View, StyleSheet, TouchableOpacity, Dimensions, Image,
} from 'react-native';
import { filterOrderListItemCard } from '../../../../services/order';
import ImageView from '../../../../components/ImageView';
import { ListItem } from '../../../../components/List';

const { width, height } = Dimensions.get('window');
function getwidth(val) {
  return width * val / 375;
}

const sourceWidth = (width - 60) / 4;

export default class OrderCard extends Component {
  renderIcon(item) {
    return (
      <View style={styles.ordermain}>
        <View style={styles.orderItemImg}>
          <ImageView source={{ uri: item.icon }} sourceWidth={getwidth(80)} sourceHeight={80} resizeMode='cover'/>
        </View>
        <View style={styles.orderRight}>
          <Text style={styles.c2f14}>{item.goodName}</Text>
          <Text style={styles.c5f12}>
            规格：
            {item.skuName}
          </Text>
          {
                item.sceneStatus === 'SERVICE_AND_LOCALE_BUY' ? (
                  <Text style={styles.c5f12}>
                    {' '}
                    商品：
                    {item.goodCount}
                  </Text>
                ) : null
            }
          {
                item.showTimeRange ? <Text style={styles.c5f12}>{item.timeRange}</Text> : null
            }
        </View>
      </View>
    );
  }

  renderIcons(item) {
    return (
      <View style={[styles.ordermain]}>
        {
            item.icons.map((icon, index) => <Image source={{ uri: icon }} style={{ width: sourceWidth, height: sourceWidth, marginLeft: index === 0 ? 0 : 10 }} />)
        }
      </View>
    );
  }

  render() {
    const { data, onPress, isShouhou } = this.props;
    const item = filterOrderListItemCard(data, isShouhou);

    const bottomList = [
      item.showStartTime ? { title: '预约时间', content: item.startTime } : null,
      item.showAddress ? { title: '送货地址', content: item.address } : null,
      { title: '下单时间', content: item.createAt },
      { title: '备注', content: item.remark },
    ];

    // console.log(bottomList);

    return (
      <TouchableOpacity onPress={() => onPress && onPress(data, item)} style={styles.orderItem}>
        <View style={styles.ordertitle}>
          <Text style={styles.c2f14}>
            <Text>订单编号：</Text>
            <Text style={styles.c5f12}>{item.orderId}</Text>
          </Text>
          <Text style={styles.credf14}>{item.orderStatusName}</Text>
        </View>
        {
            item.showSkuAndName ? this.renderIcon(item) : this.renderIcons(item)
        }
        <View style={styles.bottomcenter}>
          <View style={styles.orderciadanTime}>
            {
                bottomList.filter(bItem => !!bItem).map(bItem => (
                  <ListItem
                    style={{ paddingVertical: 0, minHeight: 20 }}
                    title={`${bItem.title}：`}
                    titleStyle={styles.c9f12}
                    extra={(bItem.content || '').trim()}
                    extraContainerStyle={{ flex: 1, justifyContent: 'flex-start' }}
                    extraStyle={styles.c5f12}
                    extraProps={{ numberOfLines: 2, ellipsizeMode: 'tail' }}
                    contentStyle={{ alignItems: 'flex-start' }}
                  />
                ))
            }
          </View>
        </View>
        <View style={styles.btntotle}>
          <Text style={styles.c5f12}>
            <Text>共计：</Text>
            <Text style={styles.credf16}>{`￥${item.totalMoney}`}</Text>
          </Text>
        </View>
      </TouchableOpacity>
    );
  }
}

const styles = StyleSheet.create({
  orderItem: {
    width: getwidth(355),
    alignSelf: 'center',
    backgroundColor: '#fff',
    borderRadius: 10,
    shadowRadius: 8,
  },
  ordertitle: {
    width: getwidth(355),
    height: 40,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 15,
  },
  ordermain: {
    width: getwidth(355),
    height: 108,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
    paddingHorizontal: 15,
    paddingVertical: 14,
    flexDirection: 'row',
  },
  bottomcenter: {
    width: getwidth(355),
    // height: 86,
    paddingVertical: 5,
    borderBottomColor: '#F1F1F1',
    borderBottomWidth: 1,
  },
  headerLeftView: {
    width: 50,
    alignItems: 'center',
  },
  orderciadanTime: {
    width: getwidth(355),
    paddingHorizontal: 15,
    justifyContent: 'space-around',
    paddingTop: 3,
  },
  orderremaker: {
    width: getwidth(355),
    paddingHorizontal: 15,
    height: 20,
    justifyContent: 'center',
  },
  btntotle: {
    width: getwidth(355),
    height: 40,
    paddingHorizontal: 15,
    alignItems: 'flex-end',
    justifyContent: 'center',
  },
  orderItemImg: {
    width: getwidth(80),
    height: 80,
  },
  orderRight: {
    width: getwidth(355) - 30 - getwidth(80),
    height: 80,
    paddingHorizontal: 14,
    justifyContent: 'space-around',
  },
  credf16: {
    color: '#EE6161',
    fontSize: 16,
  },
  c5f12: {
    color: '#555555',
    fontSize: 12,
  },
  c2f14: {
    color: '#222222',
    fontSize: 14,
  },
  credf14: {
    color: '#EE6161',
    fontSize: 14,
  },
  c9f12: {
    color: '#999999',
    fontSize: 12,
  },
});
