import React, { Component } from 'react';
import {
  Text, View, StyleSheet, TouchableOpacity, Image, Modal, Linking,
} from 'react-native';

export default class NotAccessModal extends Component {
  /**
   * 是否允许显示的判断
   * @param userInfo 用户信息
   * @param firstMerchant 首次入驻的联盟商信息
   * @param merchantType 当前需要判断的联盟商身份
   */
  static canShow = (userInfo, firstMerchant, merchantType) => userInfo.auditStatus !== 'active' && userInfo.createdMerchant && firstMerchant.merchantType !== merchantType

  concatService = () => {
    this.props.onClose();
    Linking.openURL('tel:' + '400-0801118');
  }
  render() {
    const { visible, firstMerchant, onClose } = this.props;
    return (
      <Modal
          animationType="slide"
          visible={visible}
          transparent
          onRequestClose={() => { }}
          // onShow={this.startShow}
      >
        <View style={[styles.modal]}>
          <View style={[styles.innerContainer]}>
            <View style={{ padding: 15, paddingBottom: 0, alignItems: 'flex-end' }}>
              <TouchableOpacity onPress={() => onClose()}>
                <Image source={require('../../../images/user/close.png')} style={{ width: 18, height: 18 }} />
              </TouchableOpacity>
            </View>
            <Text style={styles.title2}>{`您的${firstMerchant.name}身份未成功入驻，入驻成功后才能入驻其他身份，如果您现在就需要入驻新的身份，请联系平台客服进行操作后即可入驻`}</Text>
            <View style={styles.rowModal}>
              <TouchableOpacity
                  style={styles.btn}
                  onPress={() => this.concatService()}
              >
                <Text style={[styles.btn_text, { color: '#222' }]}>联系客服</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    );
  }
}

const styles = StyleSheet.create({
  modal: {
    flex: 1,
    justifyContent: 'center',
    padding: 52,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  innerContainer: {
    borderRadius: 12,
    backgroundColor: '#fff',
  },
  btn: {
    width: '50%',
    height: 40,
  },
  btn_text: {
    textAlign: 'center',
    color: '#4A90FA',
    fontSize: 15,
    lineHeight: 40,
  },
  title2: {
    color: '#030303',
    fontSize: 14,
    lineHeight: 20,
    margin: 15,
    marginTop: 10,
    textAlign: 'center',
  },
  rowModal: {
    alignItems: 'center',
    width: '100%',
    // flexDirection: "row",
    marginTop: 20,
    borderColor: '#F1F1F1',
    borderTopWidth: 1,
  },
});
