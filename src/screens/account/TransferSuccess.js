/**
 * 转账成功
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  TouchableOpacity,
} from 'react-native';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';

const success = require('../../images/caiwu/success.png');
const pay_failed = require('../../images/caiwu/pay_failed.png');

const { width, height } = Dimensions.get('window');
function getwidth(val) {
  return width * val / 375;
}

export default class TransferSuccess extends Component {
    componentDidMount = () => {
      const payFailed = this.props.navigation.getParam('payFailed', true);
      !payFailed && global.refreshFinanceData && global.refreshFinanceData(); // 刷新财务数据
    }

    render() {
      const { navigation } = this.props;
      const payFailed = navigation.getParam('payFailed', true);
      const route = navigation.getParam('route', null);
      const type = navigation.getParam('type', null); // charge
      const chargeType = navigation.getParam('chargeType', 'xkb');
      const callback = navigation.getParam('callback', null);
      const page = navigation.getParam('page', null);
      const type1 = type || '转账';
      let title = `晓可币${type1}`;
      if (navigation.state.params && navigation.state.params.title) {
        title = navigation.state.params.title;
      } else {
        if (chargeType === 'xkwl') {
          title = '晓可物流余额充值';
        }
      }

      return (
        <View style={styles.container}>
            <Header
                    navigation={navigation}
                    goBack={false}
                    leftView={(
                      <TouchableOpacity
                            style={styles.headerLeftView}
                            onPress={() => {
                              navigation.navigate('FinancialAccount');
                            }}
>
  <Image
                                source={require('../../images/mall/goback.png')}
                            />
</TouchableOpacity>
)}
                    title={title}
              />
            <View style={styles.mainContaner}>
                <View style={styles.imgView}>

                    {
                            (!payFailed)
                              ? <Image source={success} style={styles.img} />
                              : <Image source={pay_failed} style={styles.img} />
                        }
                  </View>
                <View style={styles.textview}>
                    {
                            page == 'withdraw'
                              ? <View>
                                <Text style={[styles.centerText, { fontSize: 14 }]}>提现申请提交成功</Text>
                                <Text style={[styles.centerText, { fontSize: 14, marginTop: 6 }]}>请等待平台审核</Text>
                              </View>
                              : (
<Text style={styles.centerText}>
{type1}
{(!payFailed) ? '成功' : '失败'}
</Text>
)
                        }

                  </View>
                <TouchableOpacity
                        onPress={() => {
                          page == 'withdraw' ? navigation.goBack()
                            : navigation.replace(route || 'FinanceCharge', { callback, ...navigation.state.params });
                        }}
                        style={[CommonStyles.flex_center, { marginTop: 10, marginBottom: 15 }]}
                  >
                    <Text style={styles.btnText}>{page == 'withdraw' ? '返回' : (`继续${type1}`)}</Text>
                  </TouchableOpacity>
              </View>
          </View>
      );
    }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  mainContaner: {
    width: getwidth(355),
    // height: 166,
    backgroundColor: '#fff',
    borderRadius: 6,
    marginTop: 10,
  },
  imgView: {
    width: getwidth(355),
    height: getwidth(66),
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 30,
  },
  img: {
    width: getwidth(66),
    height: getwidth(66),
  },
  textview: {
    width: getwidth(355),
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 19,
  },
  btnText: {
    borderRadius: 6,
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    paddingVertical: 5,
    paddingHorizontal: 15,
    fontSize: 12,
    color: CommonStyles.globalHeaderColor,
  },
  headerLeftView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    width: 50,
  },
  centerText: {
    color: '#222222',
    fontSize: 17,
  },
});
