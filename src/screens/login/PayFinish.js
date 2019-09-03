/**
 * 支付完成
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Button,
  Image,
  ScrollView,
  TouchableOpacity,
} from 'react-native';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';

const { width, height } = Dimensions.get('window');

export default class TfPayScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        payType: 0,
      };
    }

    renderPay = () => (
      <View style={styles.line}>
        <TouchableOpacity style={[styles.payType, { borderColor: '#4A90FA' }]}>
          <Image source={require('../../images/user/alipay.png')} style={styles.icon} />
          <Text style={[styles.text, { color: '#4A90FA', marginLeft: 7 }]}>支付宝</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.payType, { borderColor: '#40BA4A', marginLeft: 20 }]}>
          <Image source={require('../../images/user/wechat.png')} style={styles.icon} />
          <Text style={[styles.text, { color: '#40BA4A', marginLeft: 7 }]}>支付宝</Text>
        </TouchableOpacity>
      </View>
    )

    render() {
      const { navigation } = this.props;
      const { payType, route } = this.state;
      const lists = [
        { title: '全额支付' },
        { title: '0元加盟(提交后需后台审核通过)' },
        { title: '从收入中扣除' },
      ];
      return (
        <View style={styles.container}>
          <Header
                    navigation={navigation}
                    goBack
                    title="支付费用"
          />

          <ScrollView alwaysBounceVertical={false}>
            <View style={styles.content}>
                <View style={styles.topView}>
                    <Text style={styles.title}>
加盟费
                        {' '}
                        <Text style={{ color: '#FF7E00', fontSize: 20 }}> ¥10,000</Text>
                      </Text>
                  </View>
                <Text style={[styles.title, { marginTop: 20 }]}>支付类型 </Text>
                {
                            lists.map((item, index) => (
                              <View style={styles.payItem} key={index}>
                                <TouchableOpacity style={styles.line} onPress={() => this.setState({ payType: index })}>
                                  <Image source={
                                                payType == index
                                                  ? require('../../images/index/select.png')
                                                  : require('../../images/index/unselect.png')}
                                        />
                                  <Text style={[styles.text, { marginLeft: 10 }]}>{item.title}</Text>
                                </TouchableOpacity>
                                {
                                            index == 0
                                              ? (
                                                <View style={{ marginLeft: 24 }}>
  {this.renderPay()}
</View>
                                              )
                                              : null
                                        }
                              </View>
                            ))
                        }
              </View>
            <View style={[styles.content, { marginTop: 0 }]}>
                <View style={styles.topView}>
                    <Text style={styles.title}>
保证金
                        {' '}
                        <Text style={{ color: '#FF7E00', fontSize: 20 }}> ¥10,000</Text>
                      </Text>
                    <Text style={{ marginTop: 10, fontSize: 12, color: '#999' }}>*保证金支付后可随时提取，提取后账号无法使用 </Text>
                  </View>
                <Text style={[styles.title, { marginTop: 20 }]}>支付方式</Text>
                {this.renderPay()}
              </View>


          </ScrollView>

          <TouchableOpacity
                    style={styles.btn}
                    onPress={() => {
                      navigation.navigate('PayLogin', { type, route });
                    }}
          >
            <Text style={{ color: '#fff', fontSize: 17 }}>已完成支付</Text>
          </TouchableOpacity>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  content: {
    width: width - 20,
    margin: 10,
    backgroundColor: '#fff',
    borderRadius: 8,
    // ...CommonStyles.shadowStyle,
    paddingLeft: 25,
    paddingBottom: 25,
  },
  title: {
    color: '#222',
    fontSize: 14,
  },
  text: {
    color: '#555',
    fontSize: 14,
  },
  topView: {
    flex: 1,
    height: 70,
    borderBottomWidth: 1,
    borderColor: 'rgba(0,0,0,0.08)',
    justifyContent: 'center',

  },
  payItem: {
    marginTop: 15,
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  payType: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: 108,
    height: 40,
    borderWidth: 1,
    borderRadius: 8,
    marginTop: 17,
  },
  icon: {
    width: 18,
    height: 18,
  },
  btn: {
    justifyContent: 'center',
    alignItems: 'center',
    height: 50,
    marginBottom: CommonStyles.footerPadding,
    backgroundColor: '#4A90FA',
  },
});
