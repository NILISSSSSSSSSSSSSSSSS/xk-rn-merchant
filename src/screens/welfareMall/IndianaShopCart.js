/**
 * 夺宝购物车
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
  Alert,
  TouchableOpacity,
} from 'react-native';

import moment from 'moment';
import { connect } from 'rn-dva';
import Header from '../../components/Header'
import CommonStyles from '../../common/Styles'
import ImageView from '../../components/ImageView';
import FlatListView from '../../components/FlatListView';
import Process from '../../components/Process';
import * as requestApi from '../../config/requestApi';
import TextInputView from '../../components/TextInputView';

import {
  formatPriceStr, getPreviewImage, keepTwoDecimalFull, keepTwoDecimal, showSaleNumText,
} from '../../config/utils';
import ListEmptyCom from '../../components/ListEmptyCom';
import math from '../../config/math.js';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import { JOIN_AUDIT_STATUS } from '../../const/user';

const { width, height } = Dimensions.get('window');

const fuwulei = require('../../images/categroy/fuwulei.png');
const unchecked = require('../../images/mall/unchecked.png');
const checked = require('../../images/mall/checked.png');
const shixiao = require('../../images/indianashopcart/shixiao.png');

function getwidth(val) {
  return width * val / 375;
}

const queryParam = {
  userId: '',
  page: 1,
  limit: 10,
};

class IndianaShopCart extends Component {
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
      super(props);
      this._didFocusSubscription = props.navigation.addListener('didFocus', (payload) => {
        this.firstRequest();
        this.muserAccDetail();
      });
      this.state = {
        store: {
          refreshing: false,
          loading: false,
          hasMore: true,
          isFirstLoad: true,
        },
        data: [],
        isManager: false,
        isAllChoose: 0,
        userCurrency: 0, // 用户消费券余额
      };
    }

    firstRequest = () => {
      const { store } = this.state;
      this.setState({
        store,
      });
      const { userInfo } = this.props;
      queryParam.page = 1;
      queryParam.userId = userInfo.id;
      requestApi.jfmallCartQList(queryParam).then((res) => {
        console.log('购物车', res);
        if (res) {
          const data = res.data ? res.data : [];
          let hasMore = true;
          if (data.length < 10) {
            hasMore = false;
          }
          store.hasMore = hasMore;
          store.refreshing = false;
          store.isFirstLoad = false;
          data.forEach((item, index) => {
            item.checkedData = 0;
            // if (index % 2 === 0) {
            //     item.status = 0
            // } else {
            //     item.status = 0
            // }
          });
          this.setState({
            store,
            isAllChoose: 0,
            data,
          }, () => {
            console.log('购物车刷新', data);
          });
        } else {
          store.hasMore = false0;
          store.refreshing = false;
          store.isFirstLoad = false;
          this.setState({
            isAllChoose: 0,
            store,
            data: [],
          });
        }
      }).catch(() => {
        store.hasMore = false;
        store.refreshing = false;
        store.isFirstLoad = false;
        this.setState({
          store,
        });
      });
    }
    componentWillUnmount() {
      this._didFocusSubscription && this._didFocusSubscription.remove();
      this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    componentDidMount() {
      Loading.show();
      this._willBlurSubscription = this.props.navigation.addListener('willBlur', (payload) => {
        this.goBackPage();
      });
    }
    // 获取用户余额
    muserAccDetail = () => {
      const { userInfo } = this.props;
      const { auditStatus, createdMerchant } = userInfo || {};
      // 商户未入驻，不获取商户余额
      if (auditStatus !== JOIN_AUDIT_STATUS.success || createdMerchant !== 1) {
        return;
      }
      const pararms = {
        currency: 'xfq',
      };
      requestApi.muserAccDetail(pararms, false).then((res) => {
        console.log('用户余额', res);
        if (res) {
          this.setState({
            userCurrency: res.userAccXfq.usable || 0,
          });
        }
      }).catch((err) => {
        console.log(err);
        Loading.hide();
      });
    }
    changecheckedData = (ele) => {
      const { data } = this.state;
      data.find((item) => {
        if (item.goodsId === ele.goodsId) {
          if (item.checkedData === 1) {
            item.checkedData = 0;
          } else {
            item.checkedData = 1;
          }
          return true;
        }
      });
      const onedata = data.find((item) => {
        if (item.checkedData === 0) {
          return true;
        }
      });
      if (onedata) {
        this.setState({
          data,
          isAllChoose: 0,
        });
      } else {
        this.setState({
          data,
          isAllChoose: 1,
        });
      }
    }
    changeQuantity = (ele, flag) => {
      // flag 1  加
      console.log('ele', ele);
      console.log('flag', flag);
      const { data } = this.state;
      const maxData = 9999; // 不限购最大的数量
      const numberLimit = ele.shoppingNumberLimit; // -1 时候不限购
      data.find((item) => {
        if (item.goodsId === ele.goodsId) {
          if (flag === 1) {
            const buyMaxdata = numberLimit === -1 ? maxData : numberLimit;
            // 不限购并且购买数量在最大限制范围内
            console.log('buyMaxdata', buyMaxdata);
            if (numberLimit === -1 && item.quantity < buyMaxdata) {
              item.quantity++;
              console.log('item', item);
              return;
            }
            // 等于和超过最大限购数量
            if (item.quantity >= buyMaxdata) {
              Toast.show(`您最多只能兑奖${buyMaxdata}注`, 2000);
              return;
            }
            item.quantity++;
          } else {
            if (item.quantity <= 1) {
              Toast.show('数量不能小于1', 2000);
              return;
            }
            item.quantity -= 1;
          }
        }
      });
      console.log('data', data);
      this.setState({
        data,
      });
    }
    changeCount = (one, val) => {
      const { data } = this.state;
      let maxdata = 9999;
      if (val == null) {
        Toast.show('只能输入数字');
        return;
      }
      if (isNaN(val)) {
        Toast.show('只能输入数字');
        return;
      }
      // 如果不限购就为最大值，限购则是限购的数量
      maxdata = one.shoppingNumberLimit !== -1 ? one.shoppingNumberLimit : maxdata;
      if (val && (val < 1 || val > maxdata)) {
        Toast.show(`您最多能兑奖${maxdata}注，最少1注`, 2000);
      }
      if (val && val > 9999) {
        Toast.show(`您最多能兑奖${maxdata}注，最少1注`, 2000);
        return;
      }
      data.find((item) => {
        if (item.goodsId === one.goodsId) {
          item.quantity = val;
        }
      });
      this.setState({
        data,
      });
    }
    toDetail = (item) => {
      const { navigation } = this.props;
      item.mainUrl = item.url;
      item.id = item.sequenceId;
      item.goodsName = item.names;
      item.jSequenceId = item.sequenceId;
      item.perPrice = item.oldPrice;
      item.expectDrawTime = item.drawTime;
      navigation.navigate('WMGoodsDetail', { goodsId: item.goodsId, sequenceId: item.sequenceId });
    }
    renderItem = ({ item, index }) => {
      const drawType = item.drawType;
      const { isManager } = this.state;
      let br = null;
      if (index === 0) {
        br = {
          borderTopLeftRadius: 10,
          borderTopRightRadius: 10,
        };
      }
      if (index === this.state.data.length - 1) {
        br = {
          borderBottomRightRadius: 10,
          borderBottomLeftRadius: 10,
        };
      }
      if (this.state.data.length === 1) {
        br = {
          borderTopLeftRadius: 10,
          borderTopRightRadius: 10,
          borderBottomRightRadius: 10,
          borderBottomLeftRadius: 10,
        };
      }
      const { navigation } = this.props;
      const time = moment(item.drawTime * 1000).format('MM-DD HH:mm');
      const value = math.multiply(math.divide(item.participateStake, item.maxStake), 100);
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      const fixedNumber = item.maxStake > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.participateStake, fixedNumber)}/${showSaleNumText(item.maxStake, fixedNumber)}`;

      return (
        <View style={[styles.itemContaner, br]} key={index}>
          {
            (isManager || item.status === 1) && (
              <TouchableOpacity
                style={[CommonStyles.flex_center, styles.optItem]}
                onPress={() => { this.changecheckedData(item); }}
              >
                <ImageView
                  source={item.checkedData === 1 ? checked : unchecked}
                  sourceWidth={18}
                  sourceHeight={18}
                />
              </TouchableOpacity>
            )
          }
            {
              item.status === 0
              && (
                <View style={[CommonStyles.flex_center, { paddingLeft: 15 }]}>
                  <Image source={shixiao} style={{ width: 33, height: 18 }} />
                </View>
              )
            }
            <TouchableOpacity
              onPress={() => {
                navigation.push('WMGoodsDetail', {
                  goodsId: item.goodsId,
                  sequenceId: item.sequenceId,
                });
              }}
                activeOpacity={0.7}
                style={{ flexDirection: 'row', flex: 1, position: 'relative' }}
              >
                <WMGoodsWrap
                  imgUrl={item.url}
                  title={item.name}
                  showProcess
                  showPrice={false}
                  type={item.drawType}
                  processValue={processValue}
                  label="开奖进度："
                  timeLabel="开奖时间："
                  timeValue={time}
                  showText={showText}
                  labelStyle={styles.labelStyle}
                  imgStyle={styles.imgStyle}
                  goodsTitleStyle={styles.goodsTitleStyle}
                >
                  <View style={[CommonStyles.flex_start, { marginTop: 6 }]}>
                    <Text style={styles.labelText}>消费券：</Text>
                    <Text style={[styles.labelText, styles.color_red]}>{keepTwoDecimal(math.divide(item.price, 100))}</Text>
                  </View>
                    <View style={[styles.changeCount]}>
                      <TouchableOpacity
                        style={{
                          borderWidth: 1,
                          borderColor: '#e6e6e6',
                          borderTopLeftRadius: 3,
                          borderBottomLeftRadius: 3,
                          borderRightWidth: 0,
                        }}
                        onPress={() => { this.changeQuantity(item, 0); }}
                        >
                          <View style={styles.touchCountView}><View style={{ width: getwidth(8), height: 1, backgroundColor: '#ccc' }} /></View>
                        </TouchableOpacity>
                        <View style={{
                          width: getwidth(40),
                          justifyContent: 'center',
                          alignItems: 'center',
                          borderWidth: 1,
                          borderColor: '#e6e6e6',
                        }}
                        >
                          <TextInputView
                            keyboardType="numeric"
                            style={{ textAlign: 'center', color: '#a9a9a9' }}
                            value={item.quantity}
                            onChangeText={(val) => {
                              this.changeCount(item, val);
                            }}
                            />
                        </View>
                        <TouchableOpacity
                          style={{
                            borderWidth: 1,
                            borderColor: '#e6e6e6',
                            borderLeftWidth: 0,
                            borderTopRightRadius: 3,
                            borderBottomRightRadius: 3,
                          }}
                          onPress={() => { this.changeQuantity(item, 1); }}
                        >
                          <View style={styles.touchCountView}><Text style={{ color: '#ccc' }}>+</Text></View>
                        </TouchableOpacity>
                      </View>
                  </WMGoodsWrap>
              </TouchableOpacity>
          </View>
      );
    }
    renderSeparator = () => <View style={styles.separatorCom} />
    // 下拉刷新
    refreshData = () => {
      this.firstRequest();
    }
    // 上拉加载
    loadMoreData = () => {
      const { store, data } = this.state;
      const hasMore = store.hasMore;
      const list = [];
      if (hasMore) {
        queryParam.page += 1;
        requestApi.jfmallCartQList(queryParam).then((res) => {
          console.log('loadMore', res);
          if (res) {
            const list = res.data;
            let hasMore = true;
            if (list.length < 10) {
              hasMore = false;
            }
            store.hasMore = hasMore;
            store.loading = false;
            list.forEach((item) => {
              item.checkedData = 0;
            });
            this.setState({
              store,
              data: data.concat(list),
            });
          } else {
            store.hasMore = false;
            store.loading = false;
            this.setState({
              store,
            });
          }
        }).catch(() => {
          store.hasMore = false;
          store.loading = false;
          this.setState({
            store,
          });
        });
      }
    }
    touchIsManager = () => {
      const { data } = this.state;
      data.forEach((item) => {
        item.checkedData = 0;
      });
      this.setState({
        data,
        isManager: !this.state.isManager,
        isAllChoose: 0,
      });
    }
    // 验证商品数量
    checkoutGoodsNum = (item) => {
      const maxdata = item.shoppingNumberLimit !== -1 ? item.shoppingNumberLimit : 9999;
      if (item.quantity === '') {
        return false;
      }
      if (isNaN(item.quantity)) {
        return false;
      }
      if (item.quantity && (item.quantity > 0 && item.quantity <= maxdata)) {
        return true;
      }
      return false;
    }
    // 离开购物车，保存购物车的数量
    goBackPage = () => {
      const { navigation } = this.props;
      const param = {
        cart: [],
      };
      const { data } = this.state;
      data.forEach((item) => {
        param.cart.push({
          quantity: this.checkoutGoodsNum(item) ? item.quantity : item.shoppingNumberLimit,
          id: item.id,
        });
      });
      if (param.cart.length === 0) {
        navigation.goBack();
        return;
      }
      requestApi.jfmallCartUpdateQuantity(param);
    }
    // 点击结算,保存数量
    changeGoodsNum = () => {
      const param = {
        cart: [],
      };
      const { data } = this.state;
      data.forEach((item) => {
        param.cart.push({
          quantity: this.checkoutGoodsNum(item) ? item.quantity : item.shoppingNumberLimit,
          id: item.id,
        });
      });
      requestApi.jfmallCartUpdateQuantity(param)
    }
    // 判断是否全是失效商品
    isAllExpire = () => {
      const { data } = this.state;
      const temp = [];
      data.map((item) => {
        if (item.status === 0) {
          temp.push(true);
        } else {
          temp.push(false);
        }
      });
      return temp.includes(false);
    }
    // 点击全选
    changAllchoose = () => {
      const { data } = this.state;
      if (!this.isAllExpire() && !this.state.isManager) {
        Toast.show('当前无有效商品可选择');
        return;
      }
      data.forEach((item) => {
        if (this.state.isManager) {
          item.checkedData = !this.state.isAllChoose ? 1 : 0;
        } else {
          if (item.status === 1) {
            item.checkedData = !this.state.isAllChoose ? 1 : 0;
          }
        }
      });
      this.setState({
        data,
        isAllChoose: !this.state.isAllChoose ? 1 : 0,
      });
    }
    yirushouCang = () => {
      const { userInfo } = this.props;
      const param = {
        userId: userInfo.id,
        ids: [],
      };
      // 是否包含失效商品
      let hasExpire = false;
      const { data } = this.state;
      const newdata = [];
      data.forEach((item) => {
        if (item.checkedData === 1) {
          param.ids.push(item.id);
          if (item.status === 0) {
            hasExpire = true;
          }
        } else {
          newdata.push(item);
        }
      });
      if (param.ids.length === 0) {
        Toast.show('请选择商品', 2000);
        return;
      }
      if (hasExpire) {
        Toast.show('不能将失效商品加入到收藏夹');
        return;
      }
      requestApi.jfmallCartMoveToFavorites(param).then((res) => {
        Toast.show('已成功移入收藏', 2000);
        const hasNoChoose = newdata.find((item) => {
          if (item.checkedData === 0) {
            return true;
          }
        });
        if (hasNoChoose) {
          this.setState({
            data: newdata,
            isAllChoose: 0,
          });
        } else if (newdata.length === 0) {
          this.setState({
            data: newdata,
            isAllChoose: 0,
          });
        } else {
          this.setState({
            data: newdata,
            isAllChoose: 1,
          });
        }
      }).catch(() => {
        Toast.show('收藏失败', 2000);
      });
    }
    deletegoods = () => {
      const { data } = this.state;
      const params = {
        ids: [],
      };
      const newdata = [];
      data.forEach((item) => {
        if (item.checkedData === 1) {
          params.ids.push(item.id);
        } else {
          newdata.push(item);
        }
      });
      if (params.ids.length === 0) {
        Toast.show('请选择商品', 2000);
        return;
      }
      requestApi.jfmallCartDestroy(params).then((res) => {
        Toast.show('已成功删除', 2000);
        const hasNoChoose = newdata.find((item) => {
          if (item.checkedData === 0) {
            return true;
          }
        });
        if (hasNoChoose) {
          this.setState({
            data: newdata,
            isAllChoose: 0,
          });
        } else if (newdata.length === 0) {
          this.setState({
            data: newdata,
            isAllChoose: 0,
          });
        } else {
          this.setState({
            data: newdata,
            isAllChoose: 1,
          });
        }
      }).catch(() => {
        Toast.show('删除失败', 2000);
      });
    }
    jupupage = () => {
      const { navigation, userInfo, checkAuditStatus } = this.props;
      const { auditStatus, createdMerchant } = userInfo || {};
      const { data, userCurrency } = this.state;

      checkAuditStatus(() => {
        const totlePrice = this.getTotalPrice();
        const listdata = [];
        data.forEach((item) => {
          if (item.checkedData === 1) {
            listdata.push(item);
          }
        });
        if (listdata.length === 0) {
          Toast.show('请选择商品', 2000);
          return;
        }
        // let filter_buynumber = data.filter(item => item.shoppingNumberLimit !== -1 && item.quantity > item.shoppingNumberLimit)
        // if (filter_buynumber.length !== 0) {
        //   Toast.show('您选择的商品中，购买数量超出限制，请确认后再次结算', 2000);
        //   return
        // }
        if (parseFloat(userCurrency) == 0 || parseFloat(userCurrency) < math.divide(totlePrice, 100)) {
          Toast.show('您的消费券不足！');
          return;
        }
        const res = [];
        listdata.find((item) => {
          if (item.status === 0) {
            res.push(item);
          }
        });
        if (res.length > 0) {
          Toast.show('所选项目包含失效商品');
          return;
        }
        console.log('list', listdata);
        const temp = [];
        listdata.length > 0 && listdata.map((item) => {
          if (!this.checkoutGoodsNum(item)) {
            Toast.show('您选择的商品中，购买数量不正确！');
            temp.push(false);
          } else {
            temp.push(true);
          }
        });
        if (temp.includes(false)) return;
        this.changeGoodsNum(); // 保存数量
        navigation.navigate('IndianaShopOrder', { data: listdata, totlePrice: this.totlePrice, callback: this.firstRequest });
      });
    }
    getTotalPrice = () => {
      const { data } = this.state;
      let sum = 0;
      data.forEach((item) => {
        if (item.checkedData === 1 && item.price) {
          sum += math.multiply(item.price, item.quantity);
        }
      });
      this.totlePrice = sum;
      return sum;
    }
    render() {
      const { navigation } = this.props;
      const {
        store, data, isManager, isAllChoose, userCurrency,
      } = this.state;
      const title = isManager ? '完成' : '管理';
      const totlePrice = this.getTotalPrice();
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            leftView={(
              <TouchableOpacity
                style={[styles.headerItem, styles.left]}
                onPress={() => { navigation.goBack() }}
              >
                <Image source={require('../../images/mall/goback.png')} />
              </TouchableOpacity>
              )}
            centerView={(
              <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                <Text style={{ fontSize: 17, color: '#fff' }}>夺奖购物车</Text>
              </View>
              )}
            rightView={
              (data && data.length > 0)
                ? (
                  <TouchableOpacity style={{ width: 50 }} onPress={this.touchIsManager}>
                  <Text style={{ fontSize: 17, color: '#fff' }}>{title}</Text>
                </TouchableOpacity>
                )
                : null
            }
          />
          <View style={{ width: '100%', height: '100%', paddingHorizontal: 10 }}>
            <FlatListView
              data={data}
              style={styles.flatListSty}
              renderItem={this.renderItem}
              store={store}
              ListEmptyComponent={<ListEmptyCom type="shopCarEmpty" />}
              ItemSeparatorComponent={this.renderSeparator}
              refreshData={this.refreshData}
              loadMoreData={this.loadMoreData}
              footerStyle={{ backgroundColor: '#EEEEEE' }}
              />
            </View>
            {
              !isManager
                ? data && data.length > 0
                  && (
                    <View style={styles.footer}>
                      <View style={[{ borderColor: '#F1F1F1', borderWidth: 1, paddingHorizontal: 15 }, CommonStyles.flex_1, CommonStyles.flex_start]}>
                        <Text style={{ color: '#222222', fontSize: 14, marginLeft: getwidth(14) }}>合计消费券：</Text>
                        <Text style={{ color: '#EE6161', fontSize: 14 }}>{math.divide(totlePrice , 100)}</Text>
                        <Text style={{ color: '#222222', fontSize: 14, marginLeft: 15 }}>剩余消费券：</Text>
                        <Text style={{ color: '#EE6161', fontSize: 14 }}>{userCurrency || 0}</Text>
                        </View>
                      <View style={[CommonStyles.flex_between, { width, height: 50 }]}>
                        <TouchableOpacity
                          style={[CommonStyles.flex_start, { paddingLeft: 30 }]}
                          onPress={this.changAllchoose}
                          >
                            <ImageView
                              source={
                                isAllChoose === 1
                                  ? checked
                                  : unchecked
                              }
                              sourceWidth={18}
                              sourceHeight={18}
                              />
                            <Text style={{ marginLeft: 15, color: '#777777', fontSize: 14 }}>全选</Text>
                          </TouchableOpacity>
                          <TouchableOpacity
                            activeOpacity={0.75}
                            onPress={this.jupupage}
                            style={{
                              width: getwidth(105), height: 50, backgroundColor: '#4A90FA', marginRight: 0, alignItems: 'center', justifyContent: 'center'
                            }}
                          >
                            <Text style={{ color: '#FFFFFF', fontSize: 17 }}>结算</Text>
                          </TouchableOpacity>
                        </View>
                    </View>
                  )
                : data && data.length > 0
                  && (
                    <View style={{
                      position: 'absolute',
                      bottom: CommonStyles.footerPadding,
                      height: 50,
                      width,
                      backgroundColor: '#FFFFFF',
                      flexDirection: 'row',
                    }}
                  >
                    <View style={{ flex: 1 }}>
                      <TouchableOpacity
                        style={{
                          width: 64, height: 50, marginLeft: getwidth(25), flexDirection: 'row', justifyContent: 'center', alignItems: 'center'
                        }}
                        onPress={this.changAllchoose}
                        >
                          <ImageView
                            source={
                              isAllChoose === 1
                                ? checked
                                : unchecked
                              }
                              sourceWidth={18}
                              sourceHeight={18}
                            />
                            <Text style={{ marginLeft: 15, color: '#777777', fontSize: 14 }}>全选</Text>
                        </TouchableOpacity>
                      </View>
                    <TouchableOpacity
                      onPress={this.yirushouCang}
                      style={{
                        width: getwidth(105), height: 50, backgroundColor: '#4A90FA', alignItems: 'center', justifyContent: 'center'
                      }}
                    >
                      <Text style={{ color: '#FFFFFF', fontSize: 17 }}>移入收藏</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      onPress={this.deletegoods}
                      style={{
                        width: getwidth(105), height: 50, backgroundColor: '#EE6161', marginRight: 0, alignItems: 'center', justifyContent: 'center'
                      }}
                    >
                      <Text style={{ color: '#FFFFFF', fontSize: 17 }}>删除</Text>
                    </TouchableOpacity>
                  </View>
                  )
            }
          </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    backgroundColor: CommonStyles.globalBgColor,
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
  flatListSty: {
    marginBottom: 140,
    flex: 1,
    width: '100%',
    backgroundColor: '#EEEEEE',
  },
  itemContaner: {
    flexDirection: 'row',
    // paddingVertical: 15,
    backgroundColor: '#fff',
  },
  rightView: {
    flex: 1,
    marginLeft: 10,
    paddingHorizontal: 10,
  },
  optItem: {
    paddingLeft: 15,
  },
  separatorCom: {
    width,
    height: 0,
    borderWidth: 0.5,
    borderColor: '#F1F1F1',
  },
  itemImg: {
    width: getwidth(80),
    height: getwidth(80),
    borderColor: '#E6E6E6',
    borderRadius: 8,
    borderWidth: 1,
  },
  processSty: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
    flex: 1,
    paddingHorizontal: 8,
    paddingVertical: 4,
  },
  processSty2: {
    flexDirection: 'row',
    flex: 1,
    alignItems: 'center',
    marginTop: 3,
    paddingHorizontal: 8,
  },
  changeCount: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'flex-end',

  },
  touchCountView: {
    width: getwidth(20),
    height: getwidth(20),
    justifyContent: 'center',
    alignItems: 'center',
  },
  footer: {
    position: 'absolute',
    bottom: CommonStyles.footerPadding,
    height: 80,
    width,
    backgroundColor: '#FFFFFF',
  },
  processItem: {
    marginTop: 5,
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 4,
  },
  processItem1: {
    paddingHorizontal: 10,
    paddingBottom: 6,
  },
  bgBlue: {
    backgroundColor: '#f0f6ff',
  },
  bgYellow: {
    backgroundColor: '#FFF4E1',
  },
  bgDeepYellow: {
    backgroundColor: '#F5A623',
  },
  bgDeepBlue: {
    color: '#4A90FA',
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 7,
  },
  imgStyle: {
    borderRadius: 8,
  },
  goodsTitleStyle: {
    fontSize: 14,
    lineHeight: 18,
    color: '#222',
  },
  labelText: {
    fontSize: 12,
    color: '#777',
  },
  color_red: {
    color: '#EE6161',
  },
});

export default connect(
  state => ({
    store: state,
    userInfo: state.user.user,
  }),
  {
    checkAuditStatus: callback => ({ type: 'user/check', payload: { callback } }),
  },
)(IndianaShopCart);
