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
import BlurredPrice from '../components/BlurredPrice'
import ImageView from './ImageView';
import { showSaleNumText,keepTwoDecimalFull, getPreviewImage } from '../config/utils';
export default class MallGoodsItem extends PureComponent {
  constructor(props) {
    super(props)
    this.state = {}
  }

  render() {
    const { navigation, index, item, data, goodsListsType } = this.props;
    let itemStyle = index === 0 ? styles.itemViewRowTop : null;
    let borderBottom = index === data.length - 1 ? styles.itemViewRowBottom : null;
    // let borderTop = index !== 0 ? styles.borderTop: null;
    let firstPaddingTop = index === 0 ? { paddingTop: 20 } : null;
    let lastPaddingBottom = index === data.length - 1 ? { paddingBottom: 20 } : null;
    return (
      <TouchableOpacity
        key={index}
        style={[styles.itemView, goodsListsType ? styles.itemViewColumn : [styles.itemViewRow, itemStyle,firstPaddingTop,lastPaddingBottom],borderBottom]}
        onPress={() => {
            navigation.navigate('SOMGoodsDetail', { goodsId: item.id });
        }}
      >
        <View style={[styles.itemImgView, goodsListsType ? styles.itemImgView2 : styles.itemImgView1]}>
          <ImageView
            style={styles.itemImgView_img}
            resizeMode='cover'
            sourceWidth={goodsListsType ? (width - 30) / 2 : 75}
            sourceHeight={goodsListsType ? (width - 30) / 2 : 75}
            source={{ uri: getPreviewImage(item.pic, '50p') }}
          />
        </View>
        <View style={[styles.itemRightView, goodsListsType ? styles.itemRightView2 : styles.itemRightView1]}>
          <Text style={goodsListsType ? styles.itemRight_title_text1 : styles.itemRight_title_text} numberOfLines={2}>{item.name}</Text>
          {
            goodsListsType?
            <View style={{marginTop:3}}>
              <Text style={[styles.itemRight_price_text2]}>月销量：{showSaleNumText(item.saleQ)}</Text>
              <Text style={[styles.itemRight_price_text2]}>原价：
                <Text style={{textDecorationLine:'line-through'}}>¥{(keepTwoDecimalFull(item.price / 100))}</Text>
              </Text>
              <Text style={[styles.itemRight_price_text2]}>
                惊喜价：
                <Text style={[styles.itemRight_price_text1]}>¥
                  <BlurredPrice>
                    <Text style={styles.itemTitleText}>
                      {(keepTwoDecimalFull((item.buyPrice || 0) / 100))}
                    </Text>
                  </BlurredPrice>
                </Text>
              </Text>
            </View>
            :
            <View style={[CommonStyles.flex_between,{flexWrap:'wrap'}]}>
              <Text style={[styles.itemRight_price_text1]}>¥&nbsp;</Text>
              <BlurredPrice>
                <Text style={styles.itemTitleText}>
                  {(keepTwoDecimalFull((item.buyPrice || 0) / 100))+' '}
                </Text>
              </BlurredPrice>
              {
                item.price ? <Text style={styles.originalPrice}>¥{((item.price || 0) / 100)} </Text>:null
              }
              <Text style={{fontSize: 12, color: '#999', marginLeft: 15}}>销售量：{showSaleNumText(item.saleQ)}</Text>
            </View>
          }
        </View>
      </TouchableOpacity>
    );
  }
};

const { width, height } = Dimensions.get('window');
const styles = StyleSheet.create({
    itemView: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#fff',
    },
    itemViewRow: {
        flexDirection: 'row',
        width: width - 20,
        marginHorizontal: 10,
        padding: 10,
        borderBottomWidth:1,
        borderColor:'#f1f1f1',
    },
    itemViewRowTop: {
        borderTopLeftRadius: 8,
        borderTopRightRadius: 8,
    },
    itemViewRowBottom: {
        borderBottomLeftRadius: 8,
        borderBottomRightRadius: 8,
    },
    itemViewColumn: {
        flexDirection: 'column',
        width: (width - 30) / 2,
        marginLeft: 10,
        marginBottom: 10,
        borderRadius: 8,
        // ...CommonStyles.shadowStyle,
        // paddingBottom: 10,
        // 以下是阴影属性：
        // shadowOffset: { width: 0, height: 4 },
        // shadowOpacity: 0.5,
        // shadowRadius: 8,
        // shadowColor: '#D7D7D7',
        // // 注意：这一句是可以让安卓拥有灰色阴影
        // elevation: 0.7,
        // zIndex: Platform.OS === 'ios' ? 1 : 0,
    },
    itemImgView: {
        backgroundColor: '#F6F6F6',
        overflow: 'hidden',
    },
    itemImgView1: {
        width: 75,
        height: 75,
        borderRadius: 6,
    },
    itemImgView2: {
        width: (width - 30) / 2,
        // height: 173,
        // height: (width - 30) / 2,
        borderTopLeftRadius: 10,
        borderTopRightRadius: 10,
    },
    itemImgView_img: {
        width: '100%',
        height: '100%',
    },
    itemRightView: {
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        flex: 1,
    },
    itemRightView1: {
        height: 70,
        paddingLeft: 15,
        paddingRight: 10,
    },
    itemRightView2: {
        width: '100%',
        // height: 55,
        paddingHorizontal: 10,
        paddingTop: 7,
        paddingBottom: 10,
    },
    itemRight_title_text: {
        fontSize: 14,
        color: '#222',
        fontWeight: '400',
        lineHeight: 20
    },
    itemRight_title_text1: {
        fontSize: 12,
        color: '#222',
        fontWeight: '400',
    },
    itemRight_price1: {
        marginTop: 0,
    },
    itemRight_price2: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
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
    itemRight_price_text1: {
        fontSize: 12,
        color: '#EE6161',
    },
    itemRight_price_text2: {
        fontSize: 12,
        color: '#999',
        lineHeight:17,
        marginTop:1
    },
    borderTop: {
        // borderTopWidth:1,
        // borderTopColor: '#f1f1f1'
    },
});
