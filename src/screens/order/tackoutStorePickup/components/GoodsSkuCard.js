/**
 * 物流选择 - 商品规格卡片
 */
import React, { Component } from 'react';
import {
  Text, View, Dimensions, StyleSheet, Image,
} from 'react-native';
import CommonStyles from '../../../../common/Styles';
import List, { ListItem, Splitter } from '../../../../components/List';

const { width, height } = Dimensions.get('window');

const getWidth = dP => dP * width / 375;

export default class GoodsSkuCard extends Component {
  renderDetail(item) {
    return (
      <View style={{
        width: '100%', alignItems: 'flex-start', paddingTop: 15, paddingBottom: 10,
      }}
      >
        <Text style={{ marginBottom: 10 }}>
          {`类型：${item.type}`}
        </Text>
        <Text style={{ marginBottom: 10 }}>
          {`重量：${item.weight}kg`}
        </Text>
        <Text style={[{ marginBottom: 10 }, item.tabIndex === 0 ? { display: 'none' } : {}]}>
          {`体积：${item.lifangmi}立方米`}
        </Text>
      </View>
    );
  }

  render() {
    const { onNavigate = () => {}, currentGoodsSku: item = null, style } = this.props;
    return (
      <List style={[styles.card, style]}>
        <ListItem
            title="商品规格"
            style={styles.item}
            titleStyle={styles.titleStyle}
            arrow
            onPress={() => onNavigate()}
        />
        <Splitter />
        {
            item ? this.renderDetail(item) : (
              <View style={[CommonStyles.flex_center, { height: 80 }]}>
                <Text style={styles.gray}>请填写商品规格</Text>
              </View>
            )
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
