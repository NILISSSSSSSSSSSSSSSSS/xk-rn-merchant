// 分享弹窗 模板

import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
  Image,
  Clipboard,
} from 'react-native';
import QRCode from 'react-native-qrcode-svg';
import CommonStyles from '../common/Styles';
import ImageView from './ImageView';
import * as nativeApi from '../config/nativeApi';
import * as requestApi from '../config/requestApi';
import BlurredPrice from './BlurredPrice';
import config from '../config/config';
import math from '../config/math'
import { keepTwoDecimalFull } from '../config/utils'
const weixin = require('../images/share/weixin.png');
const weibo = require('../images/share/weibo.png');
const qqicon = require('../images/share/qqicon.png');
const friendsquan = require('../images/share/friendsquan.png');
const copylian = require('../images/share/copylian.png');
const friends = require('../images/share/friends.png');

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return (width * val) / 375;
}
const configShareUrl = config.baseUrl_share_h5;
export default class ShareTemplate extends Component {
  static defaultProps = {
    onClose: () => {},
    shareParams: {},
    type: '',
    shareUrl: '', // 福利商城，自营商城，商品详情分享需要的二维码url
  };

  handleNativeShare = type => {
    const { shareParams, type: shareTemType, shareUrl } = this.props;
    console.log('shareParams', shareParams);
    console.log('shareTemType', shareTemType);
    console.log('shareUrl', shareUrl);
    Loading.show();
    let url = '';
    let title = '';
    let info = '';
    let iconUrl = '';

    // 分享福利商品详情
    if (shareTemType === 'WM') {
      url = shareUrl
        ? shareUrl
        : `${configShareUrl}welfFareGoodsDetails?id=${shareParams.jSequence &&
            shareParams.jSequence.goods.id}`;
      title = shareParams.jSequence.goods.name;
      info = `规格：${(shareParams.jSequence &&
        shareParams.jSequence.goods.atrrName) ||
        '无'}`;
      iconUrl = shareParams.jSequence && shareParams.jSequence.goods.mainPic;
    }
    // 已中奖列表分享，已中奖订单详情分享，已完成订单详情分享，消费抽奖中奖列表未分享商品分享
    if (shareTemType === 'WMOrderList') {
      url = shareUrl
        ? shareUrl
        : `${configShareUrl}welfareGoodsShow?id=${shareParams.termNumber}`;
      title = shareParams.goodsName;
      info = `规格：${shareParams.showSkuName ||
        '无'}  消费券：${(shareParams.price || 0) / 100}`;
      iconUrl = shareParams.mainUrl || shareParams.goodsUrl;
    }
    // 消费抽奖已中奖的商品详情 待分享状态分享
    if (shareTemType === 'XFDetail') {
      url = shareUrl
        ? shareUrl
        : `${configShareUrl}welfConsumptionDetails?id=${
            shareParams.termNumber
          }&regionCode=${global.regionCode}`;
      title = '我中奖啦！';
      info = `规格：${shareParams.showSkuName || '无'}`;
      iconUrl = shareParams.mainUrl;
    }
    nativeApi
      .nativeShare(type, url, title, info, iconUrl)
      .then(res => {
        console.log('分享返回结果', res);
        Loading.hide();
        if (this.props.callback) {
          this.props.callback();
        }
      })
      .catch(e => {
        Toast.show('分享失败，请重试！');
        Loading.hide();
      });
  };

  // 自营商品详情分享
  handleSOMShare = (type, url, title, info, iconUrl) => {
    console.log('iconUrl',iconUrl)
    // console.log('format', `${iconUrl}${iconUrl.indexOf('?') !== -1 ? '&' : '?'}imageMogr2/format/jpg&imageMogr2/size-limit/32k!&imageMogr2/thumbnail/!30p`)
    // iconUrl = `${iconUrl}${iconUrl.indexOf('?') !== -1 ? '&' : '?'}imageMogr2/format/jpg&imageMogr2/size-limit/32k!&imageMogr2/thumbnail/!50p`
    nativeApi
      .nativeShare(type, url, title, info, iconUrl)
      .then(res => {
        console.log('SOM分享', res);
        this.handleConfimShare();
      })
      .catch(e => {
        Toast.show('分享失败，请重试！');
        Loading.hide();
      });
  };

  // 自营商品详情分享回调
  handleConfimShare = (isShowToast = true) => {
    const { shareParams } = this.props;
    console.log('shareParams', shareParams);
    const params = {
      generalizeShareRecord: {
        shareType: 'mall_goods_share',
        sGoodsId: shareParams.goodsAttrs.id,
        districtCode: global.regionCode,
      },
    };
    requestApi
      .generalizedRecordCreate(params)
      .then(res => {
        console.log('后台确认分享', res);
        isShowToast && Toast.show('分享成功');
        Loading.hide();
      })
      .catch(err => {
        Toast.show('分享失败，请重试！');
        Loading.hide();
      });
  };

  // 晓可朋友 分享
  /**
   * type: 0 商品 1 福利
   */
  handleXKFriendShare = (type = 0) => {
    const { shareParams } = this.props;
    console.log('shareParams', shareParams);
    const info = {
      type,
      goodsId: '', // 商品id
      sequenceId: '', // 期id
      iconUrl: '', // 图片地址
      name: '', // 商品名字
      price: '', // 价格
      description: '', // 描述
    };
    if (type === 0) {
      info.goodsId = shareParams.base.id;
      info.iconUrl = shareParams.base.defaultSku.skuUrl;
      info.name = shareParams.base.name;
      info.price = shareParams.base.defaultSku.b2bPrice;
      info.description = shareParams.base.defaultSku.name;
    }
    if (type === 1) {
      info.goodsId = shareParams.jSequence.goods.id;
      info.sequenceId = shareParams.jSequence.id;
      info.iconUrl = shareParams.jSequence.goods.mainPic;
      info.name = shareParams.jSequence.goods.name;
      info.price = shareParams.jSequence.lotteryWay.eachNotePrice;
      info.description = shareParams.jSequence.goods.atrrName || '无';
    }
    // eslint-disable-next-line camelcase
    const info_jsonString = JSON.stringify(info);
    console.log(info_jsonString);
    nativeApi
      .shareToKYFriend(info_jsonString)
      .then(res => {
        console.log(res);
        if (type === 0) {
          this.handleConfimShare();
          return;
        }
        Toast.show('分享成功');
      })
      .catch(err => {
        Loading.hide();
        Toast.show('分享失败，请重试！');
      });
  };

  getShareOpt = (type = '') => {
    if (type === 'SOM' || type === 'WM') {
      return [
        {
          type: 'WX_P',
          picUrl: friendsquan,
          name: '朋友圈',
        },
        {
          type: 'WX',
          picUrl: weixin,
          name: '微信好友',
        },
        {
          type: 'QQ',
          picUrl: qqicon,
          name: 'QQ',
        },
        {
          type: 'QQ_Z',
          picUrl: friends,
          name: '我的朋友',
        },
        // {
        //     type: "WB",
        //     picUrl: weibo,
        //     name: "微博"
        // },
        {
          picUrl: copylian,
          name: '复制链接',
        },
      ];
    }
    return [
      {
        type: 'WX_P',
        picUrl: friendsquan,
        name: '朋友圈',
      },
      {
        type: 'WX',
        picUrl: weixin,
        name: '微信好友',
      },
      {
        type: 'QQ',
        picUrl: qqicon,
        name: 'QQ',
      },
      {
        picUrl: copylian,
        name: '复制链接',
      },
    ];
  };

  getTemplate = shareParams => {
    console.log('shareParams', shareParams);
    const { type, onClose, shareUrl, store } = this.props;

    const shareOption = this.getShareOpt(type);
    if (type === 'SOM') {
      return (
        <TouchableOpacity
          style={[styles.modalOutView, styles.modalOutView2]}
          onPress={() => {
            onClose();
          }}
        >
          <TouchableOpacity activeOpacity={1} style={styles.shareModalView}>
            <Image
              resizeMode="contain"
              style={styles.shareModalView_img}
              source={{ uri: shareParams.base.showPicUrl[0] }}
            />
            <View style={styles.shareModalView_center}>
              <View
                style={[
                  CommonStyles.flex_end_noCenter,
                  {
                    padding: 10,
                    borderTopColor: '#E5E5E5',
                    borderTopWidth: 1,
                    marginTop: 10,
                  },
                ]}
              >
                <View style={CommonStyles.flex_1}>
                  <Text
                    style={{
                      fontSize: 14,
                      color: '#222',
                      fontWeight: '600',
                      lineHeight: 20,
                    }}
                    numberOfLines={2}
                  >
                    {shareParams.base.name}
                  </Text>
                  <Text
                    style={{
                      fontSize: 12,
                      color: '#777',
                      marginTop: 5,
                      marginBottom: 8,
                    }}
                  >
                    规格：{shareParams.base.defaultSku.name}
                  </Text>
                  <View style={[CommonStyles.flex_start]}>
                    <BlurredPrice>
                      <Text
                        style={{
                          color: CommonStyles.globalRedColor,
                          fontSize: 17,
                        }}
                      >
                        ¥{(shareParams.base.defaultSku.buyPrice || 0) / 100}
                      </Text>
                    </BlurredPrice>
                    {shareParams.base.defaultSku.price ? (
                      <Text style={styles.originalPrice}>
                        ¥{keepTwoDecimalFull(math.divide(shareParams.base.defaultSku.price, 100))}
                      </Text>
                    ) : null}
                  </View>
                </View>
                <View>
                  <QRCode
                    value={shareUrl}
                    size={getwidth(66)}
                    bgColor="black"
                    fgColor="white"
                  />
                </View>
              </View>
              <View style={styles.shareModalView_center_bom}>
                {shareOption.map((item, index) => (
                  <TouchableOpacity
                    key={index}
                    style={styles.shareModalView_center_bom_view}
                    onPress={() => {
                      onClose();
                      if (item.type && item.type !== 'QQ_Z') {
                        let type;
                        let url;
                        let title;
                        let info;
                        let iconUrl;
                        type = item.type;
                        url = shareUrl;
                        title = shareParams.base.name;
                        // info = `规格：${shareParams.base.defaultSku.name ||
                        //   '无'}  价格：¥${shareParams.base.defaultSku.b2cPrice /
                        //   100}`;
                        info = '精选好物，快来围观！'
                        // iconUrl = shareParams.base.defaultSku.url;
                        iconUrl = shareParams.base.showPicUrl[0];
                        this.handleSOMShare(type, url, title, info, iconUrl);
                        return;
                      }
                      if (item.type && item.type === 'QQ_Z') {
                        this.handleXKFriendShare(0);
                      } else {
                        this.handleConfimShare(false);
                        const title = shareParams.base.name;
                        Clipboard.setString(
                          `【${title}】${shareUrl} 点击链接，跳转至晓可广场即可参与抢购哦。`
                        );
                        console.log(
                          `链接复制成功====【${title}】${shareUrl} 点击链接，跳转至晓可广场即可参与抢购哦。`
                        );
                        Toast.show('链接复制成功');
                      }
                    }}
                  >
                    <Image
                      style={styles.shareModalView_center_bom_img}
                      source={item.picUrl}
                    />
                    <Text style={styles.shareModalView_center_bom_text}>
                      {' '}
                      {item.name}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>

            <TouchableOpacity
              style={styles.shareModalView_bom}
              onPress={() => {
                onClose();
              }}
            >
              <Text style={styles.shareModalView_bom_text}>关闭</Text>
            </TouchableOpacity>
          </TouchableOpacity>
        </TouchableOpacity>
      );
    }
    if (type === 'WM') {
      return (
        <TouchableOpacity
          style={[styles.modalOutView, styles.modalOutView2]}
          onPress={() => {
            onClose();
          }}
        >
          <TouchableOpacity activeOpacity={1} style={styles.shareModalView}>
            <View style={CommonStyles.flex_center}>
              <ImageView
                sourceHeight={200}
                resizeMode="contain"
                style={styles.shareModalView_img}
                source={{ uri: shareParams.mainPics[0] }}
              />
            </View>
            <View
              style={[
                CommonStyles.flex_end_noCenter,
                {
                  padding: 10,
                  borderTopColor: '#E5E5E5',
                  borderTopWidth: 1,
                  marginTop: 10,
                },
              ]}
            >
              <View style={CommonStyles.flex_1}>
                <Text
                  style={{
                    fontSize: 14,
                    color: '#222',
                    fontWeight: '600',
                    lineHeight: 20,
                  }}
                  numberOfLines={2}
                >
                  {shareParams.jSequence && shareParams.jSequence.goods.name}
                </Text>
                <Text
                  style={{
                    fontSize: 12,
                    color: '#777',
                    marginTop: 5,
                    marginBottom: 8,
                  }}
                >
                  {
                    shareParams.jSequence 
                    ? `规格：${shareParams.jSequence.goods.atrrName}`
                    : null
                  }
                </Text>
                <View style={[CommonStyles.flex_start]}>
                  <View style={styles.goodsInfoPrice}>
                    <Text style={{ color: '#fff', fontSize: 14 }}>
                      {/* <BlurredPrice> */}
                      <Text>
                        {shareParams.jSequence.lotteryWay.eachNotePrice / 100}
                      </Text>
                      {/* </BlurredPrice> */}
                      <Text style={{ fontSize: 13 }}> 代金券 </Text>
                    </Text>
                  </View>
                </View>
              </View>
              {/* <Image style={{ width: 66, height: 66, marginLeft: 10 }} source={{ uri: shareParams.mainPics[0] }} /> */}
              <View>
                <QRCode
                  value={shareUrl}
                  size={getwidth(66)}
                  bgColor="black"
                  fgColor="white"
                />
              </View>
            </View>
            <View style={styles.shareModalView_center}>
              <View style={styles.shareModalView_center_bom}>
                {shareOption.map((item, index) => (
                  <TouchableOpacity
                    key={index}
                    style={styles.shareModalView_center_bom_view}
                    onPress={() => {
                      onClose();
                      if (item.type && item.type !== 'QQ_Z') {
                        this.handleNativeShare(item.type);
                      } else if (item.type && item.type === 'QQ_Z') {
                        this.handleXKFriendShare(1);
                      } else {
                        const title = shareParams.jSequence.goods.name;
                        Clipboard.setString(
                          `【${title}】${shareUrl} 点击链接，跳转至晓可广场即可参与抢购哦。`
                        );
                        console.log(
                          `链接复制成功====【${title}】${shareUrl} 点击链接，跳转至晓可广场即可参与抢购哦。`
                        );
                        Toast.show('链接复制成功');
                      }
                    }}
                  >
                    <Image
                      style={styles.shareModalView_center_bom_img}
                      source={item.picUrl}
                    />
                    <Text style={styles.shareModalView_center_bom_text}>
                      {item.name}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>

            <TouchableOpacity
              style={styles.shareModalView_bom}
              onPress={() => {
                onClose();
              }}
            >
              <Text style={styles.shareModalView_bom_text}>关闭</Text>
            </TouchableOpacity>
          </TouchableOpacity>
        </TouchableOpacity>
      );
    }
    if (type === 'WMOrderList') {
      return (
        <React.Fragment>
          <TouchableOpacity
            style={[styles.modalOutView, styles.modalOutView2]}
            onPress={() => {
              onClose();
            }}
          >
            <TouchableOpacity activeOpacity={1} style={styles.shareModalView}>
              <View style={[styles.shareModalView_center]}>
                <View style={styles.shareModalView_center_bom}>
                  {shareOption.map((item, index) => (
                    <TouchableOpacity
                      key={index}
                      style={styles.shareModalView_center_bom_view}
                      onPress={() => {
                        onClose();
                        if (item.type) {
                          this.handleNativeShare(item.type);
                        } else {
                          if (this.props.callback) {
                            this.props.callback();
                          }
                          Clipboard.setString(
                            shareUrl ||
                              `${configShareUrl}welfareGoodsShow?id=${
                                shareParams.termNumber
                              }`
                          );
                          Toast.show('链接复制成功');
                        }
                      }}
                    >
                      <Image
                        style={styles.shareModalView_center_bom_img}
                        source={item.picUrl}
                      />
                      <Text style={styles.shareModalView_center_bom_text}>
                        {item.name}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>

              <TouchableOpacity
                style={styles.shareModalView_bom}
                onPress={() => {
                  onClose();
                }}
              >
                <Text style={styles.shareModalView_bom_text}>关闭</Text>
              </TouchableOpacity>
            </TouchableOpacity>
          </TouchableOpacity>
        </React.Fragment>
      );
    }
    if (type === 'XFDetail') {
      return (
        <React.Fragment>
          <TouchableOpacity
            style={[styles.modalOutView, styles.modalOutView2]}
            onPress={() => {
              onClose();
            }}
          >
            <TouchableOpacity activeOpacity={1} style={styles.shareModalView}>
              <View style={[styles.shareModalView_center]}>
                <View style={styles.shareModalView_center_bom}>
                  {shareOption.map((item, index) => (
                    <TouchableOpacity
                      key={index}
                      style={styles.shareModalView_center_bom_view}
                      onPress={() => {
                        onClose();
                        if (item.type) {
                          this.handleNativeShare(item.type);
                        } else {
                          Clipboard.setString(
                            shareUrl
                              ? shareUrl
                              : `${configShareUrl}welfConsumptionDetails?id=${
                                  shareParams.termNumber
                                }`
                          );
                          Toast.show('链接复制成功');
                        }
                      }}
                    >
                      <Image
                        style={styles.shareModalView_center_bom_img}
                        source={item.picUrl}
                      />
                      <Text style={styles.shareModalView_center_bom_text}>
                        {item.name}
                      </Text>
                    </TouchableOpacity>
                  ))}
                </View>
              </View>
              <TouchableOpacity
                style={styles.shareModalView_bom}
                onPress={() => {
                  onClose();
                }}
              >
                <Text style={styles.shareModalView_bom_text}>关闭</Text>
              </TouchableOpacity>
            </TouchableOpacity>
          </TouchableOpacity>
        </React.Fragment>
      );
    }
  };

  render() {
    const { onClose, shareParams } = this.props;
    return this.getTemplate(shareParams);
  }
}

const styles = StyleSheet.create({
  modalOutView: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'transparent',
  },
  modalInnerView: {
    position: 'absolute',
    top: 44 + CommonStyles.headerPadding,
    right: 12,
    justifyContent: 'flex-end',
    width: 126,
    height: 93,
  },
  modalInnerItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    width: '100%',
    height: 41,
    paddingLeft: 15,
  },
  modalInnerItem_text: {
    fontSize: 17,
    color: '#fff',
    marginLeft: 8,
  },
  modalOutView2: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  shareModalView: {
    width: width - 55,
    marginHorizontal: 27.5,
    borderRadius: 8,
    backgroundColor: '#fff',
    overflow: 'hidden',
  },
  shareModalView_img: {
    width: '100%',
    height: ((width - 55) * 217.5) / 319,
    marginTop: 15,
  },
  shareModalView_center: {
    width: '100%',
    // borderTopWidth: 1,
    // borderTopColor: "#E5E5E5",
    borderBottomWidth: 1,
    borderBottomColor: '#E5E5E5',
  },
  shareModalView_center_top: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    height: 80,
    paddingHorizontal: 10,
    paddingVertical: 7,
  },
  shareModalView_center_top_left: {
    justifyContent: 'space-between',
    flex: 1,
    height: '100%',
  },
  shareModalView_center_top_right: {
    width: 66,
    height: '100%',
  },
  shareModalView_center_top_right_img: {
    width: '100%',
    height: '100%',
  },
  shareModalView_center_top_left_text1: {
    fontSize: 12,
    color: '#777',
  },
  shareModalView_center_top_left_item1: {
    // paddingHorizontal: 20,
    // paddingVertical: 2,
    // borderRadius: 10,
    // backgroundColor: '#FF545B',
  },
  shareModalView_center_top_left_text2: {
    fontSize: 12,
    color: '#FF545B',
    paddingVertical: 2,
    borderRadius: 10,
  },
  shareModalView_center_bom: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingTop: 10,
  },
  shareModalView_center_bom_view: {
    justifyContent: 'center',
    alignItems: 'center',
    width: '25%',
    marginBottom: 10,
  },
  shareModalView_center_bom_img: {
    width: 40,
    height: 40,
  },
  shareModalView_center_bom_text: {
    fontSize: 10,
    color: '#777',
    marginTop: 5,
  },
  shareModalView_bom: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    height: 36,
    // backgroundColor: '#fff'
  },
  shareModalView_bom_text: {
    fontSize: 14,
    color: '#222',
  },
  goodsInfoWrap: {
    padding: 10,
  },
  goodsTitle: {
    fontSize: 14,
    color: '#222',
  },
  goodsInfoPrice: {
    paddingHorizontal: 15,
    paddingVertical: 1,
    backgroundColor: '#FF545B',
    color: '#fff',
    fontSize: 12,
    borderRadius: 20,
  },
  originalPrice: {
    fontSize: 17,
    color: '#999999',
    textDecorationLine: 'line-through',
    marginLeft: 5,
  },
});
