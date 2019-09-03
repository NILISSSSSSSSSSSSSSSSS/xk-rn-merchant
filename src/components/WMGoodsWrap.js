import React, { Component } from 'react';
import {
  StyleSheet, View, Text, Image,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import WMPrizeType from './WMPrizeType';
// import BlurredPrice from '../components/BlurredPrice'
import { getPreviewImage } from '../config/utils';
import math from '../config/math';

export default class WMGoodsWrap extends Component {
    static defaultProps = {
      imgUrl: '',
      imgHeight: 100,
      imgWidth: 100,
      imgStyle: {}, // 图片样式
      title: '商品加载中...',
      numberOfLines: 2,
      xfnumber: 1000,
      showProcess: true, // 显示进度
      showPrice: true, // 显示价格
      goodsWrap: {},
      alignType: 'row', // 行布局 列布局 未完成
      // process 组件参数
      type: 'bymember',
      height: 4,
      showText: '',
      processValue: 0,
      label: '开奖进度：',
      timeLabel: '开奖时间：',
      timeValue: moment().format('MM-DD HH:mm'),
      goodsTitleStyle: {},
      goodsPrice: 0,
      showXFPrice: true, // 显示消费券价格
      renderInsertContent: () => null, // 插入在 商品名字下的内容
    };

    render() {
      const {
        imgUrl,
        imgHeight,
        imgWidth,
        title,
        numberOfLines,
        xfnumber,
        processValue,
        showProcess,
        alignType,
        showPrice,
        imgStyle,
        goodsTitleStyle,
        goodsWrap,
        goodsPrice,
        showXFPrice,
        renderInsertContent,
      } = this.props;
      return (
        <React.Fragment>
          {alignType === 'row' ? (
            <View
              style={[
                styles.flex_1,
                styles.flexStart_noCenter,
                styles.goodsItem,
                goodsWrap,
              ]}
            >
              <View
                style={{
                  // padding: 2,
                  borderWidth: 1,
                  borderColor: '#E7E7E7',
                  borderRadius: 10,
                  overflow: 'hidden',
                  height: imgHeight,
                  width: imgWidth,
                }}
              >
                <Image
                  defaultSource={require('../images/skeleton/skeleton_img.png')}
                  style={[{ height: imgHeight || '100%', width: imgWidth || '100%' }, imgStyle]}
                  source={(imgUrl) ? { uri: getPreviewImage(imgUrl, '50p') } : require('../images/skeleton/skeleton_img.png')}
                />
              </View>
              <View style={[styles.flex_1, styles.goodsInfo]}>
                <Text style={[styles.goodsTitle, goodsTitleStyle]} numberOfLines={numberOfLines}>{(typeof title === 'function') ? title() : title}</Text>
                {renderInsertContent()}
                {showProcess
                  ? (
                    <WMPrizeType
                      type="bytime"
                      {...this.props}
                      nowValue={processValue}
                    />
                  )
                  : null}
                {this.props.children}
              </View>
            </View>
          ) : null}
        </React.Fragment>
      );
    }
}

const styles = StyleSheet.create({
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexStart_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flex_1: {
    flex: 1,
  },
  goodsItem: {
    paddingVertical: 15,
    paddingLeft: 15,
    paddingRight: 12,
  },
  goodsInfo: {
    paddingLeft: 12,
  },
  labelText: {
    fontSize: 12,
    color: '#777',
  },
  goodsTitle: {
    fontSize: 14,
    color: '#222',
  },
  red_color: {
    color: '#EE6161',
  },
});
