import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  View, Text, StyleSheet, TouchableOpacity, StatusBar,
} from 'react-native';
import BaseModal from './BaseModal';

export default class ConfirmModal extends Component {
    static propTypes = {
      visible: PropTypes.bool,
      title: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
      content: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
      buttons: PropTypes.arrayOf(PropTypes.shape({
        text: PropTypes.string,
        onPress: PropTypes.func,
        type: PropTypes.oneOf(['submit', 'cancel']),
      })),
      onRequestClose: PropTypes.func,
    }
    static defaultProps = {
      visible: false,
      title: '',
      content: '',
      buttons: [
        { text: '取消', type: 'cancel' },
        { text: '确定', type: 'submit', onPress: () => {} },
      ],
      onRequestClose: () => {},
    }
    render() {
      const {
        visible, title, content, buttons, onRequestClose,
      } = this.props;
      return (
        <BaseModal
                visible={visible}
                onRequestClose={() => onRequestClose()}
        >
          {
            typeof title === 'string' ? <Text style={styles.title}>{title}</Text> : title
          }
          {
            typeof content === 'string' ? <Text style={styles.content}>{content}</Text> : content
          }
          <View style={styles.modalFooter}>
            {
                buttons.map((btn, index) => (
                  <TouchableOpacity
                    key={btn.text}
                    style={[styles.btn, index === buttons.length - 1 ? {} : styles.btnRightBorder]}
                    onPress={() => {
                      if (btn.type !== 'cancel') {
                        btn.onPress();
                      } else {
                        btn.onPress ? btn.onPress() : this.props.onRequestClose();
                      }
                    }}
                  >
                    <Text style={[styles.btnText, btn.type !== 'cancel' ? styles.btnOk : {}]}>{btn.text}</Text>
                  </TouchableOpacity>
                ))
            }
          </View>
        </BaseModal>
      );
    }
}
const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 40,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    // marginTop: -StatusBar.currentHeight
  },
  modalContent: {
    borderRadius: 10,
    backgroundColor: '#fff',
  },
  title: {
    color: '#030303',
    fontSize: 17,
    paddingBottom: 10,
    paddingTop: 25,
    textAlign: 'center',
  },
  content: {
    fontSize: 14,
    color: '#030303',
    letterSpacing: 0,
    textAlign: 'center',
    lineHeight: 20,
    paddingBottom: 25,
    paddingHorizontal: 25,
  },
  modalFooter: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    borderTopColor: '#f1f1f1',
    borderTopWidth: 1,
  },
  btn: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: 43,
  },
  btnText: {
    fontSize: 17,
    color: '#222222',
    letterSpacing: 0,
    textAlign: 'center',
  },
  btnOk: {
    color: '#4A90FA',
  },
  btnRightBorder: {
    borderRightWidth: 1,
    borderRightColor: '#F1F1F1',
  },
});
