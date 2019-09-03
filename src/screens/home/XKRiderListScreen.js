/**
 * 晓可物流
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  Modal,
  TouchableOpacity,
  Platform,
  KeyboardAvoidingView,
  ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';
import * as requestApi from '../../config/requestApi';
import VerifyCodeInput from '../../components/VerifyCodeInput';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import FlatListView from '../../components/FlatListView';
import { NavigationComponent } from '../../common/NavigationComponent';
import TextInputView from '../../components/TextInputView';

const { width, height } = Dimensions.get('window');

class XKRiderListScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        alertVisible: false, // 新增弹窗
        managerVisible: false, // 选择管理，新增弹窗
        riderName: '', // 骑手姓名
        riderPhone: '', // 骑手电话
        ListData: [], // 所有数据
        isManager: false, // 是否是管理模式
        isSelectAll: false, // 是否全选
        entryDeleteVisible: false, // 确认删除弹窗
        verifyVisible: false, // 输入骑手验证码弹窗
        searchResult: {}, // 搜索到的骑手信息
        code: '', // 骑手验证码
        isBind: false, // 是否被绑定
        isAuth: true, // 是否实名认证
        listStore: {
          refreshing: false,
          loading: false,
          hasMore: true,
          isFirstLoad: true,
        },
      };
      this.queryParam = {
        limit: 10,
        page: 1,
      };
    }

    blurState = {
      entryDeleteVisible: false, // 确认删除弹窗
      verifyVisible: false, // 输入骑手验证码弹窗
      alertVisible: false, // 新增弹窗
      managerVisible: false, // 选择管理，新增弹窗
    }

    componentDidMount() {
      this.requestRiderList(true);
    }

    componentWillUnmount() {
      super.componentWillUnmount();
      this.setState({
        verifyVisible: false,
        entryDeleteVisible: false,
        alertVisible: false,
        managerVisible: false,
      });
    }
    /** 获取骑士列表 */
    requestRiderList = (isfirst) => {
      if (isfirst) {
        this.queryParam.page = 1;
      } else {
        this.queryParam.page += 1;
      }
      this.getRiderList(this.queryParam.page, this.queryParam.limit);
    }
    
    getRiderList = (page = 1, limit = 10) => {
      const { listStore } = this.state;
      listStore.refreshing = true;
      this.setState({
        listStore,
      });
      requestApi.merchantBindRiderQPage({
        page,
        limit,
      }).then((res) => {
        const { ListData } = this.state;
        const data = this.handleListData(res);
        if (data.length < 10) {
          listStore.hasMore = false;
        } else {
          listStore.hasMore = true;
        }
        listStore.refreshing = false;
        listStore.loading = false;
        this.setState({
          ListData: page === 1 ? data : ListData.concat(data),
          listStore,
        });
      }).catch((err) => {
        console.log('error');
        listStore.refreshing = false;
        listStore.loading = false;
        this.setState({
          listStore,
        });
      });
    }

    // 给list列表数据添加选择状态
    handleListData = (res = {}) => {
      const data = res.data || [];
      const ListData = data.map((item, index) => {
        item.select = false;
        return item;
      });
      return ListData;
    }

    //  绑定骑手
    merchantBindRider = (value) => {
      console.log('222', value);
      const {
        riderPhone, searchResult, isAuth, isBind,
      } = this.state;
      if (!isAuth) {
        this.chagneState('verifyVisible', false);
        Toast.show('该骑手未实名认证！');
        return;
      }
      if (isBind) {
        this.chagneState('verifyVisible', false);
        Toast.show('该骑手与其他商户绑定！');
        return;
      }
      const params = {
        code: value,
        phone: riderPhone,
        riderId: searchResult.id,
      };
      requestApi.merchantBindRider(params).then((res) => {
        console.log(res);
        Toast.show('骑手绑定成功！');
        this.chagneState('verifyVisible', false);
        this.getRiderList();
      }).catch((err) => {
        this.chagneState('verifyVisible', false);
      });
    }

    // 点击新郑弹窗确定,显示验证码modal
    handleConfirm = () => {
      const { riderPhone } = this.state;
      requestApi.sendAuthMessage({ phone: riderPhone, bizType: 'BIND_RIDER' }).then(() => {
        this.chagneState('alertVisible', false);
        this.chagneState('verifyVisible', true);
      }).catch((error) => {
        this.chagneState('alertVisible', false);
      });
    }

    // 电话匹配姓名
    getRiderName = () => {
      Loading.show();
      const { riderPhone } = this.state;
      requestApi.merchantFindRiderByPhone({
        phone: riderPhone,
      }).then((res) => {
        if (res.megCode === 1119) {
          this.setState({
            isAuth: true,
            isBind: true,
          });
        } else if (res.megCode === 1070) {
          this.setState({
            isAuth: false,
            isBind: false,
          });
        } else {
          this.setState({
            searchResult: res,
            isAuth: true,
            isBind: false,
          });
        }
      }).catch((err) => {
        console.log(err);
      });
    }

    // 全选
    handleSelectAll = () => {
      const data = JSON.parse(JSON.stringify(this.state.ListData));
      data.map((item) => {
        item.select = !this.state.isSelectAll;
      });
      this.setState({
        ListData: data,
        isSelectAll: !this.state.isSelectAll,
      });
    }

    // 确认删除
    handleDelete = () => {
      const { navigation } = this.props;
      // navigation.navigate()
    }

    // 单选
    handleSelectItem = (item, index) => {
      const data = JSON.parse(JSON.stringify(this.state.ListData));
      data[index].select = !data[index].select;
      let selectCount = 0;
      data.map((item, index) => {
        if (item.select) {
          selectCount++;
        }
      });
      if (selectCount === data.length) {
        this.setState({
          ListData: data,
          isSelectAll: true,
        });
      } else {
        this.setState({
          ListData: data,
          isSelectAll: false,
        });
      }
    }

    chagneState = (key = '', value = '') => {
      this.setState({
        [key]: value,
      });
    }

    // 过滤删除数据
    handleGetDeleteData = () => {
      const { ListData } = this.state;
      const { navigation, user = {} } = this.props;
      const { phone } = user;
      const callback = navigation.getParam('callback', null);
      const arr = [];
      ListData.map((item, index) => {
        if (item.select) {
          arr.push(item);
        }
      });
      this.setState({
        entryDeleteVisible: false,
      });
      console.log('删除的骑手', arr, user);
      if (arr.length !== 0) {
        navigation.navigate('VerifyPhone', {
          bizType: 'UNBIND_RIDER',
          phone,
          editable: !phone,
          onConfirm: (phone, code, _navigation) => {
            const riderIds = [];
            arr.map((item) => {
              riderIds.push(item.id);
            });
            requestApi.merchantUnBindRider({
              code,
              phone,
              riderIds,
            }).then((res) => {
              console.log('解绑操作结果', res);
              Toast.show('解绑成功');
              _navigation.goBack();
              callback && callback();
              this.getRiderList();
              this.setState({
                isManager: false,
              });
            }).catch((err) => {
              console.log(err);
            });
          },
        });
      } else {
        Toast.show('请选择删除的骑手！');
      }
    }

    openAlertVisible() {
      this.setState({
        managerVisible: false,
        alertVisible: true,
        isBind: false,
        isAuth: true,
        searchResult: {},
        riderPhone: '',
      });
    }

    render() {
      const { navigation } = this.props;
      const callback = navigation.getParam('callback', null);
      const {
        alertVisible, riderPhone, listStore, ListData: data, managerVisible, isManager, isSelectAll, entryDeleteVisible, searchResult, verifyVisible, isBind, isAuth,
      } = this.state;
      return (
        <View style={styles.container}>
          <Header
                    navigation={navigation}
                    goBack
                    onBack={callback}
                    title="晓可骑手"
                    rightView={
                        (isManager)
                          ? <Text onPress={() => { this.chagneState('isManager', false); }} style={{ fontSize: 17, color: '#fff', paddingRight: 25 }}>取消</Text>
                          : (
                            <TouchableOpacity
onPress={() => { this.chagneState('managerVisible', true); }}
                        style={[{ marginRight: 20, paddingRight: 5, height: '100%' }, CommonStyles.flex_center]}
                            >
                              <Image source={require('../../images/home/more_point.png')} />
                            </TouchableOpacity>
                          )

                    }
          />
          {
                    data.length === 0 && !listStore.refreshing
                      ? (
                        <React.Fragment>
                          <View style={[CommonStyles.flex_center, styles.emptyDataWrap]}>
                            <Image source={require('../../images/emptyData/norider.png')} />
                          </View>
                          <View style={[CommonStyles.flex_center, styles.emptyTextWrap]}>
                            <Text style={styles.emptyText}>{'您还没有绑定骑手\n点击“绑定”按钮添加骑手'}</Text>
                          </View>
                          <View style={[styles.btnWrap, CommonStyles.flex_center]}>
                            <TouchableOpacity style={[styles.btnText]} onPress={() => this.openAlertVisible()}>
                              <Text style={{
                                fontSize: 17, color: '#fff', textAlign: 'center', letterSpacing: 2,
                              }}
                              >
绑定

                              </Text>
                            </TouchableOpacity>
                          </View>
                        </React.Fragment>
                      )
                      : (
                        <React.Fragment>
                          <FlatListView
                        renderItem={({ item, index }) => {
                          const noBorder = index === data.length - 1 ? styles.noBorder : {};
                          const borderRadiusTop = index === 0 ? styles.borderRadiusTop : {};
                          const borderRadiusBottom = index === data.length - 1 ? styles.borderRadiusBottom : {};
                          const marginBottom = index === data.length - 1 ? { marginBottom: 20 } : {};
                          return (
                            <View style={[styles.listItemWrap, borderRadiusBottom, borderRadiusTop, marginBottom]} key={index}>
                              <View style={[CommonStyles.flex_between, styles.listItemInnerWrap, noBorder]}>
                                <View style={[CommonStyles.flex_start]}>
                                  {
                                        isManager
                                          ? item.select
                                            ? (
                                              <TouchableOpacity onPress={() => { this.handleSelectItem(item, index); }}>
                                                <Image source={require('../../images/home/checked.png')} style={{ marginRight: 10 }} />
                                              </TouchableOpacity>
                                            )
                                            : (
                                              <TouchableOpacity onPress={() => { this.handleSelectItem(item, index); }}>
                                                <Image source={require('../../images/home/unchecked.png')} style={{ marginRight: 10 }} />
                                              </TouchableOpacity>
                                            )
                                          : null
                                    }
                                  <Image style={styles.userImg} source={require('../../images/order/head_portrait.png')} />
                                  <View style={{ paddingLeft: 10 }}>
                                    <Text style={{ fontSize: 14, color: '#222' }}>{item.realName}</Text>
                                    <Text style={{ fontSize: 12, color: '#999' }}>{item.phone}</Text>
                                  </View>
                                </View>
                                <View style={CommonStyles.flex_start}>
                                  <Text style={{ fontSize: 12, color: '#222' }}>累计配送订单数</Text>
                                  <Text style={{ fontSize: 12, color: CommonStyles.globalHeaderColor, paddingLeft: 5 }}>{item.orderNum}</Text>
                                </View>
                              </View>
                            </View>
                          );
                        }}
                        store={listStore}
                        data={data}
                        ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
                        numColumns={1}
                        refreshData={() => { this.requestRiderList(true); }}
                        loadMoreData={() => { this.requestRiderList(false); }}
                        style={{
                          paddingTop: 10,
                          backgroundColor: 'transparent',
                        }}
                          />
                        </React.Fragment>
                      )
                }
          {/* 选择弹窗 */}
          <Modal
                    animationType="fade"
                    transparent
                    visible={managerVisible}
                    onRequestClose={() => { this.setState({ managerVisible: false }); }}
                    onShow={() => {}}
          >
            <TouchableOpacity activeOpacity={1} onPress={() => { this.chagneState('managerVisible', false); }} style={{ flex: 1, position: 'relative' }}>
              <View style={styles.manager_ModalInner}>
                <TouchableOpacity
style={{
  paddingVertical: 8.5, paddingHorizontal: 25, borderBottomColor: '#f1f1f1', borderBottomWidth: 1,
}}
                                onPress={() => this.openAlertVisible()}
                >
                  <Text style={{ fontSize: 14, color: '#555' }}>新增骑手</Text>
                </TouchableOpacity>

                <TouchableOpacity
style={{ paddingVertical: 9, paddingHorizontal: 25 }}
                                onPress={() => {
                                  this.setState({
                                    isManager: true,
                                    managerVisible: false,
                                  });
                                }}
                >
                  <Text style={{ fontSize: 14, color: '#555' }}>管理骑手</Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>
          </Modal>
          {/* 新增弹窗 */}
          <Modal
            animationType="fade"
            transparent
            visible={alertVisible}
            onRequestClose={() => { this.setState({ alertVisible: false }); }}
            onShow={() => {}}
          >
            <KeyboardAvoidingView style={{ flex: 1 }} behavior="padding" enabled={entryDeleteVisible}>
              <ScrollView scrollEnabled={false} contentContainerStyle={styles.container_modal}>
                <View style={[styles.innerContainer]}>
                  <Text style={styles.title2}>新增骑手信息</Text>
                  <TextInputView
                    style={styles.inputStyle}
                    value={riderPhone}
                    onChangeText={(text) => {
                      this.setState({
                        riderPhone: text,
                      }, () => {
                        if (text.length === 11) {
                          this.getRiderName();
                        }
                      });
                    }}
                    numberOfLines={1}
                    maxLength={11}
                    placeholder="请输入手机号，将自动匹配骑手"
                  />
                  <View style={{ flexDirection: 'column', justifyContent: 'flex-start' }}>
                    {
                      searchResult === null
                        ? <Text style={{ fontSize: 12, color: '#EE6161', marginTop: 15 }}>*未匹配到骑手信息</Text>
                        : (searchResult.realName)
                          ? <Text style={styles.riderNameText}>{(searchResult.realName) ? `骑手：${searchResult.realName}` : ''}</Text>
                          : null
                    }
                    {
                        isBind
                          ? <Text style={{ fontSize: 12, color: '#EE6161', marginTop: 15 }}>*该骑手已与其他商户绑定</Text>
                          : null
                    }
                    {
                      !isAuth
                        ? <Text style={{ fontSize: 12, color: '#EE6161', marginTop: 15 }}>*该骑手未进行实名认证</Text>
                        : null
                  }
                  </View>
                  <View style={styles.row}>
                    <TouchableOpacity style={styles.btn} onPress={() => { this.setState({ alertVisible: false }); }}>
                      <Text style={styles.btn_text}>取消</Text>
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => this.handleConfirm()} style={[styles.btn, { borderColor: '#F1F1F1', borderLeftWidth: 1 }]}>
                      <Text style={styles.btn_text}>确定</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </ScrollView>
            </KeyboardAvoidingView>
          </Modal>
          {/* 输入验证码弹窗 */}
          <Modal
            animationType="fade"
            transparent
            visible={verifyVisible}
            onRequestClose={() => { this.setState({ verifyVisible: false }); }}
            onShow={() => {}}
          >
            <TouchableOpacity activeOpacity={1} style={[{ position: 'relative', flex: 1, backgroundColor: 'rgba(0, 0, 0, 0.3)' }]}>
              <View style={styles.inputModalContainer}>
                <Text style={{
                  paddingTop: 50, fontSize: 14, color: '#222', textAlign: 'center',
                }}
                >
                请输入骑手收到的验证码
                </Text>
                <View style={{ paddingTop: 30 }}>
                  <VerifyCodeInput
                    callback={(value) => { this.merchantBindRider(value); }}
                    secureTextEntry={false}
                  />
                </View>
              </View>
            </TouchableOpacity>
          </Modal>
          {/* 确认删除弹窗 */}
          <Modal
            animationType="fade"
            transparent
            visible={entryDeleteVisible}
            onRequestClose={() => { this.setState({ entryDeleteVisible: false }); }}
            onShow={() => {}}
          >
            <View style={[styles.container_modal]}>
              <View style={[styles.innerContainer]}>
                <Text style={[styles.title2, { fontSize: 17, color: '#222' }]}>确定删除所选的骑手吗？</Text>
                <View style={styles.row}>
                  <TouchableOpacity style={styles.btn} onPress={() => { this.setState({ entryDeleteVisible: false }); }}>
                    <Text style={styles.btn_text}>取消</Text>
                  </TouchableOpacity>
                  <TouchableOpacity onPress={() => this.handleGetDeleteData()} style={[styles.btn, { borderColor: '#F1F1F1', borderLeftWidth: 1 }]}>
                    <Text style={styles.btn_text}>确定</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </View>
          </Modal>
          {/* 删除操作栏 */}
          {
                    isManager
                      ? (
                        <View style={[styles.managerOpearteBar, CommonStyles.flex_between]}>
                          <TouchableOpacity
                            style={CommonStyles.flex_start}
                            onPress={() => {
                              this.handleSelectAll();
                            }}
                          >
                            {
                            isSelectAll
                              ? <Image source={require('../../images/mall/checked.png')} style={{ marginRight: 10 }} />
                              : <Image source={require('../../images/mall/unchecked.png')} style={{ marginRight: 10 }} />
                        }
                            <Text style={{ fontSize: 14, color: '#777' }}>全选</Text>
                          </TouchableOpacity>
                          <TouchableOpacity style={[styles.deleteBtn, CommonStyles.flex_center]} onPress={() => this.setState({ entryDeleteVisible: true })}>
                            <Text style={{ fontSize: 14, color: '#fff' }}>删除</Text>
                          </TouchableOpacity>
                        </View>
                      )
                      : null
                }
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  emptyDataWrap: {
    paddingTop: 72,
    paddingBottom: 19,
  },
  emptyTextWrap: {
    marginBottom: 40,
  },
  emptyText: {
    paddingHorizontal: 100,
    fontSize: 14,
    color: '#777',
    textAlign: 'center',
    lineHeight: 20,
  },
  btnWrap: {
    width,
    flexDirection: 'row',
  },
  btnText: {
    paddingVertical: 13,
    backgroundColor: CommonStyles.globalHeaderColor,
    borderRadius: 8,
    flex: 1,
    marginHorizontal: 40,
  },
  container_modal: {
    flex: 1,
    justifyContent: 'center',
    padding: 40,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  innerContainer: {
    borderRadius: 10,
    // alignItems: 'center',
    paddingHorizontal: 10,
    backgroundColor: '#fff',
    // paddingTop: 20
  },
  title: {
    color: '#030303',
    fontSize: 17,
  },
  title2: {
    color: '#030303',
    fontSize: 13,
    marginTop: 10,
    marginBottom: 16,
    marginTop: 25,

    textAlign: 'center',
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
  riderNameText: {
    fontSize: 12,
    color: '#222',
    marginTop: 15,
  },
  inputStyle: {
    borderWidth: 0.5,
    borderColor: 'rgba(77,77,77,0.5)',
    borderRadius: 8,
    fontSize: 14,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    flexDirection: 'row',
    paddingLeft: 10,
    flex: 0,
  },
  manager_ModalInner: {
    height: 74,
    backgroundColor: '#fff',
    position: 'absolute',
    right: 0,
    top: Platform.OS === 'ios' ? 44 + CommonStyles.headerPadding : 44,
    borderBottomLeftRadius: 5,
  },
  listItemWrap: {
    backgroundColor: '#fff',
    marginHorizontal: 10,
    paddingHorizontal: 15,
  },
  listItemInnerWrap: {
    paddingVertical: 15,
    borderBottomColor: 'rgba(0,0,0,0.08)',
    borderBottomWidth: 1,
  },
  userImg: {
    height: 50,
    width: 50,
    borderRadius: 25,
  },
  noBorder: {
    borderBottomColor: '#fff',
    borderBottomWidth: 0,
  },
  borderRadiusTop: {
    borderTopRightRadius: 8,
    borderTopLeftRadius: 8,
  },
  borderRadiusBottom: {
    borderBottomRightRadius: 8,
    borderBottomLeftRadius: 8,
  },
  managerOpearteBar: {
    position: 'absolute',
    bottom: Platform.OS === 'ios' ? CommonStyles.footerPadding : 0,
    left: 0,
    width,
    backgroundColor: '#fff',
    borderTopWidth: 0.7,
    borderTopColor: 'rgba(215,215,215,0.50)',
    paddingLeft: 25,
  },
  deleteBtn: {
    backgroundColor: CommonStyles.globalHeaderColor,
    paddingHorizontal: 33,
    paddingVertical: 17,
  },
  inputModalContainer: {
    height: 200,
    backgroundColor: '#fff',
    position: 'absolute',
    bottom: 0,
    left: 0,
    width,
  },
});

export default connect(
  state => ({ user: state.user.user || {} }),
)(XKRiderListScreen);
