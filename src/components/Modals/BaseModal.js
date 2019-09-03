import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  View, Text, StyleSheet, TouchableOpacity, Modal, StatusBar,
} from 'react-native';

export default class BaseModal extends Component {
    static propTypes = {
      visible: PropTypes.bool,
      containerStyle: PropTypes.oneOfType([PropTypes.object, PropTypes.number]),
      contentStyle: PropTypes.oneOfType([PropTypes.object, PropTypes.number]),
      onRequestClose: PropTypes.func,
    }
    static defaultProps = {
      visible: false,
      containerStyle: {},
      contentStyle: {},
      onRequestClose: () => {},
    }
    render() {
      const {
        visible, containerStyle, contentStyle, onRequestClose,
      } = this.props;
      return (
        <Modal
                animationType="fade"
                transparent
                visible={visible}
                onRequestClose={() => onRequestClose()}
                onShow={() => {}}
        >
          <View style={[styles.modalContainer, containerStyle]}>
            <View style={[styles.modalContent, contentStyle]}>
              {this.props.children}
            </View>
          </View>
        </Modal>
      );
    }
}
const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 40,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalContent: {
    borderRadius: 10,
    backgroundColor: '#fff',
  },
});
