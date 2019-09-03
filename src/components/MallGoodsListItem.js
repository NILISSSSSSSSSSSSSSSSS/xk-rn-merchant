/**
 * 商城商品Item
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  Platform,
  TouchableOpacity,
} from 'react-native';
import CommonStyles from '../common/Styles';
import BlurredPrice from './BlurredPrice'
import ImageView from './ImageView';
import CommoditiesText from './CommoditiesText'
import { showSaleNumText,keepTwoDecimalFull, getPreviewImage, getSalePriceText, recodeGoGoodsDetailRoute } from '../config/utils';
import  math from "../config/math.js";

export default class MallGoodsListItem extends PureComponent {
  constructor(props) {
    super(props)
    this.state = {}
  }
  goDetail = () => {
    const { navigation, item, pageName } = this.props;
    recodeGoGoodsDetailRoute(pageName);
    navigation.navigate('SOMGoodsDetail', { goodsId: item.id })
  }
  // 列布局 ，!!!!!!!!!!!!!!!important!!!!!!!!!!!!!!!!!!!!!修改样式的时候记得修改网格布局（如果列表支持切换网格/列布局）!!!!!!!!!!!!!!!!!!important!!!!!!!!!!!!!!!!!!
  getRowList = () => {
    const { navigation, index, item, data } = this.props;
    let topBorderRadius = index === 0 ? styles.topBorderRadius : null;
    let bottomBorderRadius = data.length - 1 === index ? styles.bottomBorderRadius : null;
    let firstPaddingTop = index === 0 ? { paddingTop: 20 } : null;
    let lastPaddingBottom = index === data.length - 1 ? { paddingBottom: 20 } : null;
    return (
      <TouchableOpacity
        activeOpacity={0.65}
        key={index}
        style={[styles.itemView, CommonStyles.flex_start, bottomBorderRadius, topBorderRadius,]}
        onPress={() => { this.goDetail() }}
      >
        <View style={[styles.itemRowImgView]}>
          <ImageView  style={styles.itemRowImgView_img} resizeMode='cover' sourceWidth={75} sourceHeight={75} source={{ uri: getPreviewImage(item.pic, '50p') }}/>
        </View>
        <View style={[styles.itemRowRightView]}>
          <Text style={styles.itemRowRight_title_text} numberOfLines={2}>{item.name}</Text>
          {
            item.goodsDivide === 2 // 如果是大宗商品
            ? <CommoditiesText price={item.price} buyPrice={item.buyPrice} subscription={item.subscription}/>
            : <React.Fragment>
                <View style={[CommonStyles.flex_start, { marginTop: 5 }]}>
                  <Text style={{ fontSize: 12, color: '#222' }}>惊喜价：</Text>
                  <Text style={[styles.itemRight_price_text1]}>¥</Text>
                  <BlurredPrice>
                    <Text style={styles.itemTitleText}>{getSalePriceText(keepTwoDecimalFull(math.divide(item.buyPrice || 0, 100)))} </Text>
                  </BlurredPrice>
                </View>
                <View style={[CommonStyles.flex_start]}>
                  {
                    // 原价为0不显示
                    item.price !== 0 
                    ? <Text style={{fontSize: 12,color: '#222'}}>原价：
                      <Text style={styles.originalPrice}>¥{getSalePriceText(keepTwoDecimalFull(math.divide(item.price || 0, 100)))}</Text>
                      </Text>
                    : null
                  }
                </View>
            </React.Fragment>
          }
          <Text style={{fontSize: 10, color: '#999', paddingTop: 5}}>总销量：{showSaleNumText(item.saleQ)}</Text>
        </View>
      </TouchableOpacity>
    )
  }
  // 网格布局 !!!!!!!!!!!!!!!important!!!!!!!!!!!!!!!!!!!!!修改样式的时候记得修改列布局（如果列表支持切换网格/列布局）!!!!!!!!!!!!!!!!!!important!!!!!!!!!!!!!!!!!!
  getColList = () => {
    const { navigation, index, item, data, colIndex } = this.props;
    // colIndex === 0 的时候，是第一列，1的时候为第二列，此字段用于判断是第几列，然后设置不同样式
    let wrapPaddingStyle = colIndex === 0 ? styles.firstItemWrapPadding : styles.secondItemWrapPadding;
    let imgWidthHeight = (width - 30) / 2;
    return (
      <TouchableOpacity
        activeOpacity={0.65}
        key={index}
        style={[CommonStyles.flex_1, wrapPaddingStyle, styles.wrapStyles]}
        onPress={() => { this.goDetail() }}
      >
        <View style={[styles.itemColImgView]}>
          <ImageView style={styles.itemImgView_img} resizeMode='cover' sourceWidth={imgWidthHeight} sourceHeight={imgWidthHeight} source={{ uri: getPreviewImage(item.pic, '50p') }}/>
        </View>
        <View style={[styles.itemColRightView]}>
          <Text style={styles.itemColRight_title_text1} numberOfLines={2}>{item.name}</Text>
          {
            item.goodsDivide === 2 // 如果是大宗商品
            // true
            ? <CommoditiesText price={item.price} buyPrice={item.buyPrice} subscription={item.subscription}/>
            : <View style={{paddingTop: 4}}>
                <Text style={[styles.itemRight_price_text2]}>
                  惊喜价：
                  <Text style={[styles.itemRight_price_text1]}>¥
                    <BlurredPrice>
                      <Text style={styles.itemTitleText}>
                        {(getSalePriceText(keepTwoDecimalFull(math.divide(item.buyPrice || 0, 100))))}
                      </Text>
                    </BlurredPrice>
                  </Text>
                </Text>
                {
                  // 原价为0不显示
                  item.price === 0
                  ? null
                  : <Text style={[styles.itemRight_price_text2, { paddingTop: 3 }]}>原价：
                    <Text style={{textDecorationLine:'line-through'}}>¥{getSalePriceText(keepTwoDecimalFull(math.divide(item.price || 0, 100)))}</Text>
                  </Text>
                }
              </View>
          }
          <Text style={[styles.itemRight_price_text2, { paddingTop: 5 }]}>总销量：{showSaleNumText(item.saleQ)}</Text>
        </View>
      </TouchableOpacity>
    )
  }

  render() {
    const { navigation, index, item, data, goodsListsType } = this.props;
    return  goodsListsType ? this.getColList() : this.getRowList()
  }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
  itemView: {
    backgroundColor: '#fff',
    marginHorizontal: 10,
    padding: 10,
    borderBottomWidth:1,
    borderColor:'#f1f1f1',
  },
  topBorderRadius: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  bottomBorderRadius: {
      borderBottomLeftRadius: 8,
      borderBottomRightRadius: 8,
  },
  itemRowImgView: {
    backgroundColor: '#F6F6F6',
    overflow: 'hidden',
    width: 75,
    height: 75,
    borderRadius: 6,
  },
  itemRowImgView_img: {
    width: '100%',
    height: '100%',
  },
  itemRowRightView: {
    flex: 1,
    paddingLeft: 15,
    paddingRight: 10,
  },
  itemRowRight_title_text: {
    fontSize: 14,
    color: '#222',
    fontWeight: '400',
    lineHeight: 20
  },
  itemRight_price_text1: {
    fontSize: 12,
    color: '#EE6161',
  },
  itemTitleText: {
    color: "#EE6161",
    fontSize:17,
    fontWeight: '500',
  },
  originalPrice:{
    fontSize:12,
    color:'#999999',
    textDecorationLine:'line-through',
    marginLeft:5
  },
  wrapStyles: {
    marginBottom: 10,
    borderRadius: 8,
    backgroundColor: '#fff'
  },
  firstItemWrapPadding: {
    marginLeft: 10,
    marginRight: 5
  },
  secondItemWrapPadding: {
    marginRight: 10,
    marginLeft: 5
  },
  itemColImgView: {
    height: 173,
    backgroundColor: '#F6F6F6',
    overflow: 'hidden',
    borderTopLeftRadius: 10,
    borderTopRightRadius: 10,
  },
  itemColRightView: {
    width: '100%',
    paddingHorizontal: 10,
    paddingTop: 7,
    paddingBottom: 10,
  },
  itemColRight_title_text1: {
    fontSize: 12,
    color: '#222',
    fontWeight: '400',
  },
  itemRight_price_text2: {
    fontSize: 12,
    color: '#999',
  },
});
