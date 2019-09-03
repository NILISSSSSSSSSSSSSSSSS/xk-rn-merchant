/**
 * 选择登录店铺
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
  ScrollView,
  StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';
import SplashScreen from 'react-native-splash-screen';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';

const { width, height } = Dimensions.get('window');

class UserShopListsScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      const params = props.navigation.state.params || {};
      this.state = {
        canGoBack: (params.canGoBack && params.canGoBack) || false,
        page: params.page || '', // 有传page时是账号设置选择店铺,AccountEditer新增，AccountUpdate修改
        currentAccount: params.currentAccount || {}, // 账号设置传过来的已配置的权限
        resource: params.resource || [], // 账号设置传过来的权限
        callback: params.callback || (() => { }),
      };
    }

    componentDidMount() {
      const { page, currentAccount, resource } = this.state;
      console.log('page:', page);
      if (page) {
        const user = this.props.userInfo;
        for (item of this.props.shops) {
          item.selected = false;
          item.serviceNames = [];
          console.log(resource, page);
          // if (this.state.page == 'AccountEditer') {
          for (resorceItem of resource) {
            console.log(resorceItem.shopId, item.id);
            if (resorceItem.shopId == item.id) {
              item.selected = true;
              item.serviceNames = resorceItem.mobileServiceNames;
            }
          }
          // }
        }
        this.props.updateUser({ user });
      }

      setTimeout(() => {
        SplashScreen.hide();
      }, 100);
    }

    selectShop = (currentShop) => {
      if (this.state.page) {
        const shops = this.props.merchantData.shops || [];
        for (item of shops) {
          currentShop.id == item.id
            ? (item.selected = !item.selected)
            : null;
        }
        this.props.userSave({ merchantData });
      }
    };

    goNextPage = (item, index) => {
      const { navigation } = this.props;
      if (this.state.page) {
        // navigation.navigate("AccountLimitSetting", {
        //     serviceNames: item.serviceNames,
        //     callback: serviceNames => {
        //         const user = this.props.store.user.user;
        //         for (shop of user.shops) {
        //             shop.id === item.id
        //                 ? (item.serviceNames = serviceNames)
        //                 : item.serviceNames || [];
        //         }
        //         this.props.actions.changeState({ user: user });
        //     }
        // });
      } else {
        const _data = item;
        Loading.show();
        this.props.chooseShop({
          userShop: item,
          successCallback: () => {
            if (navigation.state.params.chooseShop) {
              console.log(navigation.state.params);
              this.state.callback();
              navigation.goBack();
            } else {
              this.props.resetToHome();
            }
          },
        });
      }
    };

    saveEditor = () => {
      const user = this.props.userInfo;
      const userPermissions = [];
      console.log(user.shops);
      for (item of user.shops) {
        if (item.selected) {
          if (item.serviceNames.length == 0) {
            Toast.show(`店铺‘${item.name}’还未分配权限`);
            return;
          }
          userPermissions.push({
            shopId: item.id,
            mobileServiceNames: item.serviceNames,
            pcServiceNames: [],
          });
        }
      }
      if (userPermissions.length == 0) {
        Toast.show('您未选择任何店铺');
        return;
      }
      console.log(userPermissions);
      const { navigation } = this.props;
      if (this.state.page == 'accountUpdate') {
        const { currentAccount } = this.state;
        const params = {
          employeeId: currentAccount.id,
          phone: currentAccount.phone,
          name: currentAccount.realName,
          userPermissions,
        };
        Loading.show();
        requestApi
          .employeeUpdate(params)
          .then((data) => {
            Loading.hide();
            navigation.state.params.callback();
            navigation.goBack();
          })
          .catch((error) => {
            Loading.hide();
          });
      } else if (this.state.page == 'AccountEditer') {
        this.state.callback(userPermissions);
        navigation.goBack();
      } else {
        navigation.state.params
                && navigation.state.params.callback
                && navigation.state.params.callback(userPermissions);
        navigation.goBack();
      }
    };

    componentWillUnmount() { }

    render() {
      const { navigation, merchantData } = this.props;
      const { canGoBack, page } = this.state;
      const titleStatus = '选择登录店铺';
      const shopLists = merchantData.shops || [];
      return (
        <View style={styles.container}>
          <Header
                    navigation={navigation}
                    goBack={canGoBack}
                    title={page ? '店铺列表' : titleStatus}
                    rightView={
                        page ? (
                          <TouchableOpacity
                                onPress={() => this.saveEditor()}
                                style={{ width: 50 }}
                          >
                            <Text style={{ fontSize: 17, color: '#fff' }}>
                                    保存
                            </Text>
                          </TouchableOpacity>
                        ) : null
                    }
                    leftView={(
                      <View>
                        <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                  if (canGoBack === false) {
                                    // requestApi.storageLogin("remove"); // 移除用户登录信息
                                    requestApi.storagePhone('remove');
                                    this.props.resetPage({ routeName: 'Login' });
                                    return;
                                  }
                                  this.props.navigation.goBack();
                                }}
                        >
                          <Image source={require('../../images/mall/goback.png')} />
                        </TouchableOpacity>
                      </View>
)}
          />
          <StatusBar
                    translucent
                    backgroundColor="transparent"
                    barStyle="light-content"
                    networkActivityIndicatorVisible
                    showHideTransition="fade"
          />

          <ScrollView alwaysBounceVertical={false}>
            {shopLists
            && shopLists.map((item, index) => {
              const bottomStyle = index === shopLists.length - 1 ? styles.bottomView : null;
              return (
                <View key={index} style={[styles.itemView, bottomStyle]}>
                  <View style={styles.itemItem}>
                    <View style={[styles.item_box, styles.item_left]}>
                      <Text style={styles.item_text1}>店铺编号</Text>
                    </View>
                    <View style={[styles.item_box, styles.item_center]}>
                      <Text style={styles.item_text2}>
                        {' '}
                        {item.code}
                        {' '}
                      </Text>
                    </View>
                    <TouchableOpacity
                                style={[styles.item_box, styles.item_right]}
                                onPress={() => this.selectShop(item)}
                    >
                      {page ? (
                        <Image
                            source={item.selected
                              ? require('../../images/index/select.png')
                              : require('../../images/index/unselect.png')
                            }
                            style={{ width: 14, height: 14 }}
                        />
                      ) : null}
                    </TouchableOpacity>
                  </View>
                  <View style={styles.itemLine} />
                  <TouchableOpacity
                            style={styles.itemItem}
                            onPress={() => this.goNextPage(item, index)
                            }
                  >
                    <View style={[styles.item_box, styles.item_left]}>
                      <Text style={styles.item_text1}> 店铺名称 </Text>
                    </View>
                    <View style={[styles.item_box, styles.item_center]}>
                      <Text style={styles.item_text2}>
                        {' '}
                        {item.name}
                        {' '}
                      </Text>
                    </View>
                    <View style={[styles.item_box, styles.item_right]}>
                      <Image source={require('../../images/mall/goto_gray.png')} />
                    </View>
                  </TouchableOpacity>
                </View>
              );
            })}
          </ScrollView>

        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  tipView: {
    width: width - 20,
    marginHorizontal: 10,
    marginTop: 10,
  },
  tipView_item: {
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    height: 192,
    borderRadius: 8,
    backgroundColor: '#fff',
  },
  tipView_item_text: {
    fontSize: 17,
    color: '#222',
    marginTop: 20,
  },
  tipView_btn: {
    height: 44,
    borderRadius: 8,
    backgroundColor: '#4A90FA',
    marginTop: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  tipView_btn_text: {
    fontSize: 17,
    color: '#fff',
  },
  bottomView: {
    marginBottom: CommonStyles.footerPadding + 10,
  },
  itemView: {
    // ...CommonStyles.shadowStyle,
    width: width - 20,
    height: 101,
    margin: 10,
    marginBottom: 0,
    borderRadius: 6,
    backgroundColor: '#fff',
  },
  itemItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    height: 50,
  },
  itemLine: {
    width: '100%',
    height: 1,
    backgroundColor: '#F1F1F1',
  },
  item_box: {
    flexDirection: 'row',
    alignItems: 'center',
    height: '100%',
  },
  item_left: {
    width: 100,
    paddingLeft: 14,
  },
  item_center: {
    flex: 1,
    justifyContent: 'flex-start',
  },
  item_right: {
    width: 40,
    paddingRight: 14,
    justifyContent: 'flex-end',
  },
  item_text1: {
    fontSize: 14,
    color: '#222',
  },
  item_text2: {
    fontSize: 14,
    color: '#555',
  },

  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    // position: 'absolute'
  },
  left: {
    width: 50,
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    shops: (state.user.merchantData || {}).shops || [],
    merchantData:state.user.merchantData || {}
  }),
  {
    updateUser: (payload = {}) => ({ type: 'user/updateUser', payload }),
    chooseShop: (payload = {}) => ({ type: 'user/chooseShop', payload }),
    resetPage: (payload = {}) => ({ type: 'system/resetPage', payload }),
    resetToHome: (payload = {}) => ({ type: 'system/resetToHome', payload }),
    userSave:(payload = {}) => ({ type: 'user/save', payload }),
  },
)(UserShopListsScreen);
