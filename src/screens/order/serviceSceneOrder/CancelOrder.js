/**
 * -取消订单
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TextInput,
  TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import Content from '../../../components/ContentItem';
import Button from '../../../components/Button';

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

class CancelOrder extends Component {
  saveData = () => {
    const val = this.textInput._lastNativeText;
    if (!val) {
      Toast.show('请输入原因');
      return;
    }
    const { cancelOrder } = this.props;
    Loading.show()
    cancelOrder(val);
  }

  textInputFocus = () => {
    if (this.textInput) {
      this.textInput.blur();
      setTimeout(() => this.textInput.focus(), 100);
    }
  }

  render() {
    const { loading } = this.props;
    return (
      <View style={styles.container}>
        <Header goBack title="取消订单" />
        <Content style={styles.content} onPress={() => this.textInputFocus()} activeOpacity={0.7}>
          <TextInput
            style={styles.textInput}
            ref={dom => this.textInput = dom}
            returnKeyLabel="确定"
            returnKeyType="done"
            autoFocus
            multiline
            placeholder="取消原因" />
        </Content>
        <Button title="确认提交" titleStyle={styles.cff17} disabled={loading} onPress={this.saveData} style={[styles.savebtn, loading ? { opacity: 0.5 } : {}]} />
      </View>
    );
  }
}

export default connect(state => ({
  loading: state.loading.effects['order/cancelOrder'],
}), {
    cancelOrder: cause => ({ type: 'order/cancelOrder', payload: { cause } }),
  })(CancelOrder);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  content: {
    width: getwidth(355),
    height: 196,
    paddingHorizontal: 15,
  },
  textInput: {
    height: '100%',
    textAlignVertical: 'top',
  },
  savebtn: {
    width: getwidth(355),
    height: 44,
    backgroundColor: '#4A90FA',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 20,
  },
  cff17: {
    fontSize: 17,
    color: '#fff',
  },
});
