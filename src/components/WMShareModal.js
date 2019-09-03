
import React, { Component } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Modal,
  Image,
  Dimensions,
  TouchableOpacity,
} from 'react-native';
import moment from 'moment';
import CommonStyles from '../common/Styles';
import WMPrizeType from './WMPrizeType';
import ShareTemplate from './ShareTemplate';
import * as requestApi from '../config/requestApi';

const { width, height } = Dimensions.get('window');

export default class WMShareModal extends Component {
    static defaultProps = {
      visible: false,
      animationType: 'none',
      shareModal: false, // 分享模板 状态
      onCloseShareTem: () => { }, // 关闭分享模板弹窗
      onShowShareTem: () => { }, // 显示分享模板
      shareParams: {}, // 分享参数
      orderData: {}, // 订单数据
      successCallBack: () => { }, // 确认分享后 回调
    }

    getDetailJLotteryShare = () => {
      const { onShowShareTem, onRequestClose } = this.props;
      onShowShareTem();
      onRequestClose();
    }

    // 确认分享 回调函数
    jOrderDoShare = () => {
      const { orderData, successCallBack } = this.props;
      const param = {
        orderId: orderData.orderId,
      };
      requestApi.jOrderDoShare(param).then((res) => {
        console.log(res);
        Toast.show('分享成功!');
        successCallBack();
      }).catch((err) => {
        console.log(err);
      });
    }

    render() {
      const {
        visible, onRequestClose, animationType, shareModal, onCloseShareTem, orderData,
      } = this.props;
      return (
        <React.Fragment>
          <Modal
            animationType={animationType}
            transparent
            visible={visible}
            onRequestClose={onRequestClose}
            onShow={() => { }}
          >

            <View style={[styles.flex_1, styles.modalView]}>
              <View style={[styles.content]}>
                <TouchableOpacity
                  onPress={() => { console.log(12); onRequestClose(); }}
                  style={styles.imgWrap}
                >
                  <Image source={require('../images/wm/wm_shareModal_icon.png')} style={styles.shareImg} />
                </TouchableOpacity>
                <Text style={styles.titleText}>提示</Text>
                <View style={[styles.flexStart_noCenter, styles.flex_center]}>
                  <Image
                    defaultSource={require('../images/skeleton/skeleton_img.png')}
                    source={{ uri: orderData.mainUrl }}
                    style={styles.goodsImg}
                  />
                </View>
                <Text style={styles.modalInfo}>小主分享后，系统才能帮您安排发货哦！</Text>
                <TouchableOpacity
                  style={[styles.flexStart, styles.flex_center, styles.modalBtn]}
                  onPress={() => { this.getDetailJLotteryShare(); }}
                >
                  <Image source={require('../images/wm/wmshare_icon.png')} />
                  <Text style={styles.modalBtnText}>立即分享</Text>
                </TouchableOpacity>
              </View>
            </View>
          </Modal>
          {/* 分享 */}
          {
            shareModal && (
            <ShareTemplate
              type="WMOrderList"
              onClose={() => { onCloseShareTem(); }}
              shareParams={orderData}
              callback={this.jOrderDoShare}
            />
            )
          }
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
  flex_center: {
    justifyContent: 'center',
    flexDirection: 'row',
  },
  flex_1: {
    flex: 1,
  },
  content: {
    position: 'absolute',
    top: 200,
    left: 43,
    right: 42,
    backgroundColor: '#fff',
    padding: 15,
    borderRadius: 8,
  },
  modalView: {
    backgroundColor: 'rgba(10,10,10,.5)',
  },
  shareImg: {
    height: 24,
    width: 24,
  },
  imgWrap: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    // position: 'relative',
    height: 24,
    width: 24,
    position: 'absolute',
    // right: -15,
    // top: -39,
    right: 15,
    top: 15,
    zIndex: 10,
  },
  titleText: {
    flex: 1,
    color: '#222',
    fontSize: 17,
    textAlign: 'center',
  },
  goodsImg: {
    height: width - 241,
    width: width - 241,
    borderRadius: 10,
    marginTop: 12,
  },
  modalInfo: {
    paddingVertical: 15,
    fontSize: 14,
    color: '#777',
    textAlign: 'center',
  },
  modalBtn: {
    flex: 1,
    backgroundColor: CommonStyles.globalHeaderColor,
    paddingVertical: 12,
    borderRadius: 8,
  },
  modalBtnText: {
    color: '#fff',
    fontSize: 14,
    paddingLeft: 6,
  },
});
