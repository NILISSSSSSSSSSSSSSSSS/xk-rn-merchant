/**
 * 选择注册申请的类型
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,

  View,
  Text,
  Button,
  Image,
  TouchableOpacity,
  Keyboard,
  Modal,
  ImageBackground,
  Platform,
  RefreshControl,
  ScrollView,
  Linking,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import Content from '../../components/ContentItem';
import { NavigationComponent } from '../../common/NavigationComponent';
import NotAccessModal from './components/NotAccessModal';

const { width, height } = Dimensions.get('window');
class RegisterListScreen extends NavigationComponent {
  static navigationOptions = {
    header: null,
  }

  constructor(props) {
    super(props);
    const params = props.navigation.state.params || {};
    this.state = {
      topRoute: params.route,
      refreshing: false,
      visible: false,
    };
  }

  blurState = {
    visible: false,
  }

  getDetail = () => { // 获取入驻详情
    this.props.userInfo.createdMerchant == 1
      ? this.props.getMerchantHome()
      : null;
  }

  componentDidMount() {
    this.getDetail();
    setTimeout(() => {
      SplashScreen.hide();
    }, 100);
  }
  goNextPage = (data) => {
    const { userInfo, firstMerchant } = this.props;
    if (NotAccessModal.canShow(userInfo, firstMerchant, data.merchantType)) {
      this.setState({
        visible: true,
      });
      return;
    }
    const param = {
      ...data, page: 'register', callback: this.getDetail, route: this.state.topRoute ? 'RegisterList' : null,
    };
    this.props.navigation.navigate('MyApplyForm', param);
  }

  judgeState = (state) => {
    switch (state) {
      case 'unSubmit': return require('../../images/user/state_unsubmit.png');
      case 'un_active': return require('../../images/user/state_daijihuo.png');
      case 'active': return require('../../images/user/state_success.png');
      case 'audit_fail': return require('../../images/user/state_fail.png');
      default: return require('../../images/user/state_submited.png');
    }
  }
  renderItem = (item, index) => {
    const { navigation, navPage } = this.props;
    return (
      <Content key={index}>
        <View style={styles.topLine}>
          <View style={CommonStyles.flex_between}>
            <View style={styles.leftBorder} />
            <Text style={{ color: '#666666' }}>入驻状态</Text>
          </View>
          <Image source={this.judgeState(item.auditStatus)} style={{ width: 62, height: 30, marginTop: 4 }} />
        </View>
        <View style={styles.dashLine} />
        <View style={[CommonStyles.flex_between, { height: 77, paddingLeft: 15 }]}>
          <View style={CommonStyles.flex_between}>
            <Image source={icons[item.merchantType]} style={styles.icon} />
            <Text style={{ color: '#222' }}>{item.name}</Text>
          </View>
          <View style={[CommonStyles.flex_between, { marginRight: 8 }]}>
            {
              item.auditStatus == 'active' || item.auditStatus == 'un_active' || item.auditStatus == 'audit_fail'
                ? (
                  <TouchableOpacity style={styles.checkDetail} onPress={() => { this.goNextPage(item); }}>
                    <Text style={styles.operateText}>身份详情</Text>
                  </TouchableOpacity>
                )
                : null
            }
            {
              item.auditStatus == 'active'
                ? (
                  <TouchableOpacity style={styles.checkDetail} onPress={() => navPage('AccountActive', { route: 'RegisterList', merchantType: item.merchantType })}>
                    <Text style={styles.operateText}>激活详情</Text>
                  </TouchableOpacity>
                )
                : null
            }
            {
              item.auditStatus == 'unSubmit' || item.auditStatus == 'un_active'
                ? (
                  <TouchableOpacity onPress={() => {
                    item.auditStatus == 'un_active'
                      ? navPage('AccountActive', { route: 'RegisterList', merchantType: item.merchantType })
                      : this.goNextPage(item);
                  }}
                  >
                    <ImageBackground
                    source={item.auditStatus == 'unSubmit' ? require('../../images/user/button_unsubmit.png') : require('../../images/user/button_jihuo.png')}
                    style={styles.button_nextOperate}
                    >
                      <Text style={{ color: '#fff', fontSize: 12, marginBottom: 3 }}>{item.auditStatus == 'unSubmit' ? '马上入驻' : '马上激活'}</Text>
                    </ImageBackground>
                  </TouchableOpacity>
                ) : null
            }

          </View>
        </View>
      </Content>
    );
  }
  render() {
    const {
      navigation, resetPage, userInfo, firstMerchant, merchant,
    } = this.props;
    const { topRoute, visible } = this.state;

    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack={false}
          title="入驻身份列表"
          leftView={(
            <TouchableOpacity
              style={styles.headerLeftView}
              onPress={() => {
                if (!topRoute) {
                  resetPage('Login');
                  return;
                }
                navigation.goBack();
              }}
            >
              <Image source={require('../../images/mall/goback.png')} />
            </TouchableOpacity>
          )}
        />
        <ScrollView
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingBottom: CommonStyles.footerPadding + 20 }}
          refreshControl={(
            <RefreshControl
              refreshing={this.state.refreshing}
              onRefresh={() => this.getDetail()}
            />
          )}
        >
          <View style={{ alignItems: 'center' }}>
            {
              merchant.map((item, index) => this.renderItem(item, index))
            }
          </View>
        </ScrollView>
        <NotAccessModal visible={visible} firstMerchant={firstMerchant} onClose={() => this.setState({ visible: false })} />
      </View>
    );
  }
}
const icons = {
  shops: require('../../images/user/icon_shops.png'),
  personal: require('../../images/user/icon_person.png'),
  company: require('../../images/user/icon_company.png'),
  anchor: require('../../images/user/icon_anchor.png'),
  familyL1: require('../../images/user/icon_family.png'),
  familyL2: require('../../images/user/icon_family2.png'),
};

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  headerLeftView: {
    width: 50,
    alignItems: 'flex-start',
    paddingLeft: 18,
  },
  title: {
    color: '#222',
    fontSize: 14,
  },
  topLine: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    height: 40,
    paddingLeft: 15,
  },
  dashLine: {
    borderColor: '#f1f1f1',
    borderWidth: 1,
    borderStyle: 'dashed',
    borderRadius: 0,
    height: 0,
  },
  leftBorder: {
    width: 3,
    height: 12,
    backgroundColor: CommonStyles.globalHeaderColor,
    borderRadius: 3,
    marginRight: 8,
  },
  icon: {
    width: 36,
    height: 36,
    marginRight: 10,
  },
  button_nextOperate: {
    width: 86,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 4,
  },
  checkDetail: {
    width: 72,
    height: 26,
    alignItems: 'center',
    justifyContent: 'center',
    borderColor: '#f1f1f1',
    borderWidth: 1,
    borderRadius: 26,
    marginRight: 8,
  },
  operateText: {
    fontSize: 12,
    color: '#666',
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    merchant: state.user.merchant || [],
    shop: state.shop || {},
    merchantData: state.user.merchantData || {},
    firstMerchant: state.user.firstMerchant || {},
  }), {
    resetPage: routeName => ({ type: 'system/resetPage', payload: { routeName } }),
    replacePage: (routeName, params = {}) => ({ type: 'system/replacePage', payload: { routeName, params } }),
    getMerchantHome: (payload = {}) => ({ type: 'user/getMerchantHome', payload }),
    navPage: (routeName, params) => ({ type: 'userActive/navPage', payload: { routeName, params } }),
  },
)(RegisterListScreen);
