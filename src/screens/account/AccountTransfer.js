/**
 * 账号转账
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
  ScrollView,
} from 'react-native';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as regular from '../../config/regular';
import TextInputView from '../../components/TextInputView';

const { width, height } = Dimensions.get('window');
function getwidth(val) {
  return (width * val) / 375;
}

export default class AccountTransfer extends Component {
  constructor(props) {
    super(props);
    const params = this.props.navigation.state.params || {};
    this.state = {
      inputValue: '',
      allMoney: params.allMoney,
    };
  }

    handleSubmit = () => {
      const { navigation } = this.props;
      const { inputValue, allMoney } = this.state;
      if (!regular.number(inputValue)) {
        Toast.show('请输入正确格式的账号');
        return;
      }
      navigation.navigate('FinanceMakeQrcode', { phone: inputValue, allMoney });
    }

    render() {
      const { navigation } = this.props;
      return (
        <ScrollView contentContainerStyle={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="账号转账"
          />
          <TextInputView
            inputView={styles.inputContaner}
            style={styles.textinput}
            value={this.state.inputValue}
            onChangeText={(data) => {
              this.setState({ inputValue: data });
            }}
            placeholder="请输入手机号码或晓可ID"
          />
          <TouchableOpacity
            onPress={() => {
              this.handleSubmit();
              // navigation.navigate("TransferSuccess");
            }}
            style={styles.btnstyle}
          >
            <Text style={{ color: '#fff' }}>确定</Text>
          </TouchableOpacity>
        </ScrollView>
      );
    }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  inputContaner: {
    width: getwidth(355),
    height: 50,
    backgroundColor: '#fff',
    borderRadius: 6,
    marginTop: 10,
    paddingLeft: 10,
  },
  textinput: {
    width: getwidth(355),
    height: 50,
  },
  btnstyle: {
    width: getwidth(355),
    height: 44,
    backgroundColor: '#4A90FA',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 20,
  },
});
