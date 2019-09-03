
/**
 * 物流信息
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  Text,
  View,
  Image,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import CommonStyles from '../../../common/Styles';
import Header from '../../../components/Header';
import Content from '../../../components/ContentItem';
import { fetchlogisticsQuery } from '../../../config/Apis/order';
import NavigatorService from '../../../common/NavigatorService';
import { POST_COMPANY_MAP } from '../../../const/order';

const { width, height } = Dimensions.get('window');
const wuliucar = require('../../../images/shopOrder/wuliucar.png');

function getwidth(val) {
  return width * val / 375;
}
export default class LogisticsInform extends Component {
    state = {
      data: {},
    }

    componentDidMount() {
      const { orderId } = this.props.navigation.state.params;
      // console.log('params',this.props.navigation.state.params)
      const param = {
        orderId,
        orderType: 'NORMAL',
        xkModule: 'shop',
        logisticsType: 'MUSER',
      };
      fetchlogisticsQuery(param).then((res) => {
        this.setState({
          data: res,
        });
      }).catch(err => {
        console.log(err)
    });
    }

    renderLog = () => {
      const { data } = this.state;
      if (data.list) {
        return data.list.map((item, index) => {
          if (index === 0) {
            return (
              <View style={styles.logsItem}>
                <View style={styles.icoroundcontent}>
                  <View style={styles.iconround} />
                  <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                    <Image source={wuliucar} style={{ marginRight: 10 }} />
                    {
                      data.isSign == 1 ? (
                        <Text style={styles.c2f12}>已签收</Text>
                      ) : (
                        <Text style={styles.c2f12}>运输中</Text>
                      )
                    }
                  </View>
                  <Text style={styles.c9f12}>{item.location}</Text>
                  <Text style={styles.c9f12}>{moment(item.time * 1000).format('YYYY-MM-DD HH:mm')}</Text>
                </View>
              </View>
            );
          }
          return (
            <View style={styles.logsItem}>
              <View style={styles.icoroundcontent}>
                <View style={styles.iconround} />
                <Text style={styles.c9f12}>{item.location}</Text>
                <Text style={styles.c9f12}>{moment(item.time * 1000).format('YYYY-MM-DD HH:mm')}</Text>
              </View>
            </View>
          );
        });
      }
      return null;
    }

    render() {
      const { navigation } = this.props;
      const { data } = this.state;
      const { page } = navigation.state.params || {};
      return (
        <View style={styles.container}>
          <Header
                navigation={navigation}
                title="物流信息"
                leftView={(
                  <TouchableOpacity
                    style={[styles.headerItem, styles.left]}
                    onPress={() => {
                      if (page === 'entry') {
                        const route = NavigatorService.findRouteByRouteName('ChooseStream');
                        route && route.params.callback && route.params.callback(); // 更新数据
                        console.log(route);
                        NavigatorService.popToRouteName('GoodsTakeOut');
                      } else {
                        navigation.goBack();
                      }
                    }}
                  >
                    <Image style={styles.backStyle} source={require('../../../images/header/back.png')} />
                  </TouchableOpacity>
                )}
          />
          <ScrollView contentContainerStyle={{
            flex: 1, width, alignItems: 'center', justifyContent: 'flex-start',
          }}
          >
            <Content style={styles.topontent}>
              <Text style={styles.c2f14}>
                {`快递公司：${POST_COMPANY_MAP.get(data.companyName)}`}
              </Text>
              <Text style={styles.c2f14}>
                {`快递单号：${data.number}`}
              </Text>
            </Content>
            {
                data.list && (
                <Content style={styles.bottomcontent}>
                  {
                        this.renderLog()
                    }
                </Content>
                )
            }
          </ScrollView>
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
  },
  c2f14: {
    color: '#222222',
    fontSize: 14,
  },
  c2f12: {
    color: '#222222',
    fontSize: 12,
  },
  c9f12: {
    color: '#999999',
    fontSize: 12,
  },
  topontent: {
    width: getwidth(355),
    height: 73,
    justifyContent: 'space-around',
    paddingHorizontal: 15,
  },
  bottomcontent: {
    width: getwidth(355),
    maxHeight: height - 100,
    paddingVertical: 20,
  },
  logsItem: {
    width: getwidth(355),
    height: 65,
    paddingHorizontal: 12,
  },
  icoroundcontent: {
    borderLeftColor: '#D8D8D8',
    borderLeftWidth: 1,
    height: '100%',
    paddingHorizontal: 15,
  },
  iconround: {
    backgroundColor: '#4A90FA',
    width: 10,
    height: 10,
    borderRadius: 10,
    position: 'absolute',
    left: -5,
    top: -5,
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  left: {
    width: 50,
  },
  backStyle: {
    tintColor: 'white',
  },
});
