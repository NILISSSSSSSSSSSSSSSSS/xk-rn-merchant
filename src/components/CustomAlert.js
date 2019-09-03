/**
 * React Native App
 * dongtao 2017/04/22
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  Modal,
  PixelRatio,
  View,
  TouchableOpacity,
  Dimensions,
} from 'react-native';

const { width, height } = Dimensions.get('window');
export default class ModalDemo extends Component {
  constructor(props) {
    super(props); // 这一句不能省略，照抄即可
    this.state = {
      animationType: 'fade', // none slide fade
      transparent: true, // 是否透明显示
      visible: false,
      title: '提示',
      onConfirm: () => { },
      onClose: () => { },
      type: 'alert',
      confirmText: '',
      botton1Text: '',
      botton2Text: '',
      botton1TextStyle: {},
      botton2TextStyle: {},
    };
  }
    onShow = (
      type = 'alert',
      confirmText = '',
      title = '提示',
      onConfirm = () => { },
      onClose = () => { },
      botton1Text = '',
      botton2Text = '',
      botton1TextStyle = {},
      botton2TextStyle = {},
    ) => {
      this.setState({
        type,
        title,
        confirmText,
        botton1Text,
        botton2Text,
        onConfirm: () => {
          this.setState({ visible: false });
          onConfirm();
        },
        onClose: () => {
          this.setState({ visible: false });
          onClose();
        },
        visible: true,
        botton1TextStyle,
        botton2TextStyle,
      });
    };
    startShow = () => {
      // alert('开始显示了');
    };
    render() {
      console.log(this.state.visible);
      const modalBackgroundStyle = {
        backgroundColor: this.state.transparent
          ? 'rgba(0, 0, 0, 0.5)'
          : 'red',
      };
      const innerContainerTransparentStyle = this.state.transparent
        ? { backgroundColor: '#fff', paddingTop: 20 }
        : null;
      const {
        title,
        visible,
        onConfirm,
        onClose,
        type,
        confirmText,
        botton1Text,
        botton2Text,
        botton1TextStyle,
        botton2TextStyle,

      } = this.state; // type为类型，confirm表示选择操作，alert表示提醒
      return (
        <Modal
                animationType={this.state.animationType}
                transparent={this.state.transparent}
                visible={visible}
                style={{ width: width - 105 }}
                onRequestClose={() => { }}
                onShow={this.startShow}
        >
          <View style={[styles.container, modalBackgroundStyle]}>
            <View
                        style={[
                          styles.innerContainer,
                          innerContainerTransparentStyle,
                        ]}
            >
              <Text style={styles.title}>{title || '提示'}</Text>
              <Text style={styles.title2}>{confirmText}</Text>
              {type == 'confirm' ? (
                <View style={styles.row}>
                  <TouchableOpacity
                    style={styles.btn}
                    onPress={() => onClose()}
                  >
                    <Text style={[styles.btn_text, botton1TextStyle]}>
                      {botton1Text || '否'}
                    </Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    onPress={() => onConfirm()}
                    style={[
                      styles.btn,
                      {
                        borderColor: '#F1F1F1',
                        borderLeftWidth: 1,
                      },
                    ]}
                  >
                    <Text style={[styles.btn_text, botton2TextStyle]}>
                      {botton2Text || '是'}
                    </Text>
                  </TouchableOpacity>
                </View>
              ) : (
                <TouchableOpacity
                    onPress={() => onConfirm()}
                    style={[styles.but, styles.button]}
                >
                  <Text
                    style={{
                      color: '#fff',
                      fontSize: 17,
                      textAlign: 'center',
                      lineHeight: 35,
                    }}
                  >
                    确定
                  </Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
        </Modal>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 40,
  },
  innerContainer: {
    borderRadius: 10,
    alignItems: 'center',
    paddingHorizontal: 10,
  },
  title: {
    color: '#030303',
    fontSize: 17,
  },
  title2: {
    color: '#030303',
    fontSize: 14,
    marginTop: 10,
    marginBottom: 16,
    marginTop: 25,
    lineHeight: 18,
  },
  row: {
    alignItems: 'center',
    width: '100%',
    flexDirection: 'row',
    marginTop: 20,
    borderColor: '#F1F1F1',
    borderTopWidth: 1,
  },
  btn: {
    width: '50%',
    height: 40,
  },
  button: {
    backgroundColor: '#4A90FA',
    borderRadius: 8,
    width: '80%',
    marginBottom: 20,
  },
  btn_text: {
    textAlign: 'center',
    color: '#4A90FA',
    fontSize: 17,
    lineHeight: 40,
  },
});
