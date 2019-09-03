/**
 * 福利商城商品详情页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
  ImageBackground,
  Image,
  StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';


import config from '../../config/config';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import FlatListView from '../../components/FlatListView';
import WebViewCpt from '../../components/WebViewCpt';
import ShareTemplate from '../../components/ShareTemplate';
import ModalDemo from '../../components/Model';
import * as requestApi from '../../config/requestApi';
import { NavigationComponent } from '../../common/NavigationComponent';
import ShowBigPicModal from '../../components/ShowBigPicModal';

const { width, height } = Dimensions.get('window');

class WMXFGoodsDetailScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    }

    webViewRef = null

    constructor(props) {
      super(props);
      this.state = {
        goodsData: props.navigation.getParam('goodsData', { goodsId: '', sequenceId: '' }),
        canGoBack: false,
        modalVisible: false,
        modalLists: [
          {
            id: 1,
            title: '分享',
            icon: require('../../images/mall/share.png'),
            routeName: '',
          },
          {
            id: 2,
            title: '意见反馈',
            icon: require('../../images/mall/fankui.png'),
            routeName: 'Feedback',
          },
        ],
        shareModal: false,
        shareUrl: '', // 分享链接
        shareParams: null,
        isPrizeShareModal: false, // 中奖分享状态
        isPrizeShareData: {}, // 中奖分享数据
        confimVis: false, // 分享后弹窗
        showBingPicVisible: false,
        bigIndex: 0, // 大图索引
        bigList: [], // 查看大图所有图片
      };
    }

    blurState = {
      modalVisible: false,
      confimVis: false, // 分享后弹窗
      isPrizeShareModal: false, // 中奖分享状态
      shareModal: false,
    }

    screenDidFocus = (payload) => {
      super.screenDidFocus(payload);
    }

    componentDidMount() {
      // Loading.show();
    }

    changeState(key, value) {
      this.setState({
        [key]: value,
      });
    }

    postMessage = () => {
      const { isShare } = this.state;
      if (isShare) {
        this.setState({
          confimVis: true,
        });
      }
    }

    // 检查是否分享
    handleCheckoutShare = () => {
      const { goodsData } = this.state;
      if (goodsData.goodsShare === 'YES_SHARE' && goodsData.state === 'WAIT_FOR_RECEVING') { // 如果已经分享，显示领取弹窗
        // StatusBar.setBarStyle('dark-content')
        this.setState({
          isShare: true,
        }, () => {
          if (this.state.isShare) {
            this.setState({
              confimVis: true,
            });
          }
        });
      }
    }

    goBack = () => {
      const { navigation } = this.props;
      const { canGoBack } = this.state;

      if (canGoBack) {
        this.webViewRef.goBack();
      } else {
        navigation.goBack();
      }
    }

    // 打开购物车
    jsOpenAppShoppingCart = (e) => {
      this.props.navigation.navigate('IndianaShopCart');
    }

    // 打开图片浏览
    jsOpenAppImageBrowser = (param) => {
      console.log('打开图片浏览');
      try {
        const _params = param.replace('jsOpenAppImageBrowser,', '');
        const _data = JSON.parse(_params);
        const { index, list } = _data;
        const temp = [];
        console.log('list', list);
        list.map((item) => {
          if (item.type === 'img') {
            temp.push({
              url: item.url,
              type: 'images',
            });
          }
          if (item.type === 'video') {
            temp.push({
              mainPic: item.mainPic,
              url: item.url,
              type: 'video',
            });
          }
        });
        console.log(temp);
        StatusBar.setHidden(true);

        this.setState({
          bigIndex: index,
          bigList: temp,
          showBingPicVisible: true,
        });
      } catch (error) {
        console.log('打开图片浏览', error);
      }
    }

    // 打开全部评价
    jsOpenAppComments = (e) => {
      this.props.navigation.navigate('WMAllShowOrder', { goodsId: this.state.goodsData.goodsId });
    }

    //  获取分享路径
    pushSharePath = (e) => {
      e = e.replace('pushSharePath,', '');
      const param = JSON.parse(e);
      // 适配param参数字段
      param.param.sequence = param.param.jSequence;
      // 匹配分享参数字段
      param.param.termNumber = param.param.jSequence.id;
      param.param.showSkuName = param.param.jSequence.goods.atrrName || '无';
      param.param.mainUrl = param.param.jSequence.goods.mainPic;
      param.param.goodsName = param.param.jSequence.goods.name;
      this.changeState('shareUrl', param.shareUrl);
      this.changeState('shareParams', param.param);
    }

    componentWillUnmount() {
      super.componentWillUnmount();
      Loading.hide();
    }

    // 中奖分享
    shareMyLottery = (e) => {
      e = e.replace('shareMyLottery,', '');
      console.log('paramsparams', JSON.parse(e));
      const _e = JSON.parse(e);
      _e.termNumber = _e.jOrderLotteryVO.termNumber;
      _e.showSkuName = _e.jSequence.goods.atrrName || '无';
      _e.mainUrl = _e.jSequence.goods.mainPic;
      this.setState({
        isPrizeShareModal: true,
        isPrizeShareData: _e,
      });
    }

    // 确人分享 回调函数
    jOrderDoShare = () => {
      const { isPrizeShareData } = this.state;
      const param = {
        orderId: isPrizeShareData.jOrderLotteryVO.orderId,
      };
      requestApi.platOrderDoShare(param).then((res) => {
        console.log(res);
        if (isPrizeShareData.jSequence.goods.goodsType !== 'virtual') {
          this.changeState('confimVis', true);
        }
        this.webViewRef.reload();
      }).catch((err) => {
        console.log(err);
      });
    }

    // 去领取商品
    goToGetLotteryGoods = () => {
      const { isPrizeShareData, goodsData } = this.state;
      const { navigation } = this.props;
      console.log('isPrizeShareData', isPrizeShareData);
      console.log('goodsData',goodsData)
      if (this.state.isPrizeShareData.jSequence) { // 如果分享了直接点击领取
        navigation.navigate('WMGetLotterGoods', { data: [this.state.isPrizeShareData.jSequence.goods], jOrderLotteryVO: this.state.isPrizeShareData.jOrderLotteryVO });
        this.changeState('confimVis', false);
      } else { // 分享了，下次进入页面再领取
        Loading.show();
        requestApi.allDetailLottery({
          sequenceId: goodsData.termNumber || goodsData.sequenceId,
        }).then((res) => {
          console.log(res);
          res.termNumber = res.jOrderLotteryVO.termNumber;
          res.showSkuName = res.jSequence.goods.atrrName || '无';
          res.mainUrl = res.jSequence.goods.mainPic;
          navigation.navigate('WMGetLotterGoods', { data: [res.jSequence.goods], jOrderLotteryVO: res.jOrderLotteryVO, listItemData: goodsData });
          this.changeState('confimVis', false);
        }).catch((err) => {
          console.log(err);
        });
      }
    }

    goToAlgorithm(data) {
      const _data = data.replace('jsOpenAlgorithm,', '');
      console.log(JSON.parse(_data));
      requestApi.detailJLottery({
        sequenceId: JSON.parse(_data).sequenceId,
      }).then((res) => {
        console.log('resres', res);
        const param = {
          thirdWinningTime: res.thirdWinningTime,
          thirdWinningNo: res.thirdWinningNo,
          thirdWinningNumber: res.thirdWinningNumber,
          termNumber: res.termNumber,
          userBuyRecord: res.currentCustomerNum || 0, // 本期参与人次
          lotteryNumber: res.lotteryNumber, // 中奖编号
        };
        this.props.navigation.navigate('WMLotteryAlgorithm', { lotteryData: param });
      }).catch((err) => {
        console.log(err);
      });
    }

    goToNewDetail(data) {
      const _data = data.replace('jsOpenPrizeDetail,', '');
      this.props.navigation.navigate('WMNewGoodsDetail', JSON.parse(_data));
    }

    goShowOrder = (e) => {
      e = e.replace('jsWinningLottery,', '');
      console.log('paramsparams', JSON.parse(e));
      const _e = JSON.parse(e);
      this.props.navigation.navigate('WMShowOrder', { orderInfo: { orderId: _e.orderId }, routerIn: 'XFGoodsDetail' });
    }
    getGoodsDetail = (router = '') => {
      Loading.show();
      requestApi.lotteryDetail({
          sequenceId: this.state.goodsData.sequenceId,
      }).then(res => {
          console.log('商品详情',this.props,res)
          if (router === 'Feedback') {
              this.props.navigation.navigate('Feedback', { goodsData:res.jSequence.goods });
          }
          if (router === 'PastWinners') {
              this.props.navigation.navigate('PastWinners', { goodsData:res.jSequence.goods });
          }
      }).catch(err => {
          console.log(err)
      })
  }
    render() {
      const { navigation } = this.props;
      const {
        goodsData, modalVisible, modalLists, shareModal, shareParams, shareUrl, isPrizeShareModal, isPrizeShareData, confimVis,
      } = this.state;
      console.log('goodsData', goodsData);
      const source = {
        uri: `${config.baseUrl_h5}welfConsumptionDetails?id=${goodsData.sequenceId || goodsData.termNumber}&orderId=${goodsData.orderId || ''}`,
        showLoading: true,
        headers: { "Cache-Control": "no-cache" }
      };

      return (
        <View style={styles.container}>
          {/* <StatusBar barStyle={'dark-content'} /> */}
          <WebViewCpt
                    webViewRef={(e) => { this.webViewRef = e; }}
                    isNeedUrlParams
                    source={source}
                    postMessage={(data) => {
                      console.log('data', data);
                      this.handleCheckoutShare();
                    }}
                    getMessage={(data) => {
                        let params = data && data.split(',');
                        console.log(params);
                        if (params[0] === 'jsOpenAppImageBrowser') {
                            this.jsOpenAppImageBrowser(data);
                        } else if (params[0] === 'jsOpenAppComments') { // 往期晒单
                            this.props.dispatch({type:'welfare/setWMXFWebViewReload',payload:{needReLoad: false}})
                            this.jsOpenAppComments(params);
                        } else if (params[0] === 'pushSharePath') {
                            this.pushSharePath(data);
                        } else if (params[0] === 'jsHiddenXKHUDView') {
                            Loading.hide()
                        } else if (params[0] === 'jsWinningLottery') {
                            this.goShowOrder(data) // 晒单
                        } else if (params[0] === 'jsReceiveMyLottery') { // 领取奖品
                            this.goToGetLotteryGoods();
                        } else if (params[0] === 'shareMyLottery') {
                            this.shareMyLottery(data)
                        }  else if (params[0] === 'jsOpenAlgorithm') { // 开奖算法
                            this.props.dispatch({type:'welfare/setWMXFWebViewReload',payload:{needReLoad: false}})
                            this.goToAlgorithm(data)
                        } else if (params[0] === 'jsOpenPrizeDetail') { // 商品详情
                            this.props.dispatch({type:'welfare/setWMXFWebViewReload',payload:{needReLoad: false}})
                            this.goToNewDetail(data)
                        }else if (params[0] === 'jsOpenAllParticipant') { // 参与详情
                            // this.goParticipationDetail()
                            if (shareParams) {
                                this.props.dispatch({type:'welfare/setWMXFWebViewReload',payload:{needReLoad: false}})
                                navigation.navigate('WMPartakeDetail', { sequenceId: shareParams.jSequence.id })
                            } else {
                                Toast.show('获取失败，请重试！')
                            }
                        } else if (params[0] === 'jsOpenRecentLottery') {// 跳转到往期揭晓
                          this.getGoodsDetail('PastWinners')
                        }else if (params[0] === 'goToLotteryActivity') {// 跳到抽奖转盘
                          navigation.navigate('WMLotteryActivity')
                        }  else {
                            console.log(params);
                        }
                    }}
          />

          <Header
            navigation={navigation}
            headerStyle={styles.headerStyle}
            leftView={(
              <TouchableOpacity
                    style={styles.headerItem}
                    activeOpacity={0.6}
                    onPress={() => {
                      this.goBack();
                    }}
              >
                <Image source={require('../../images/mall/goback_gray.png')} />
              </TouchableOpacity>
            )}
            rightView={(
              <TouchableOpacity
                    style={styles.headerItem}
                    activeOpacity={0.6}
                    onPress={() => {
                      this.changeState('modalVisible', true);
                    }}
              >
                <Image source={require('../../images/mall/more_gray.png')} />
              </TouchableOpacity>
            )}
          />
          {/* 点击更多弹窗 */}
          {
                    modalVisible
                    && (
                    <TouchableOpacity
                      style={styles.modalOutView}
                      activeOpacity={1}
                      onPress={() => {
                        this.changeState('modalVisible', false);
                      }}
                    >
                      <ImageBackground
                        style={styles.modalInnerView}
                        source={require('../../images/mall/more_gray_modal.png')}
                      >

                        <View style={styles.moreModalWrap}>
                          {
                              modalLists.map((item, index) => {
                                const border = index === modalLists.length - 1 ? null : styles.border;
                                return (
                                  <View
                                    style={{
                                      flex: 1, width: '100%', paddingHorizontal: 10, ...CommonStyles.flex_center,
                                    }}
                                    key={index}
                                  >
                                    <TouchableOpacity
                                      style={[styles.modalInnerItem, border]}
                                      activeOpacity={0.6}
                                      onPress={() => {
                                        this.changeState('modalVisible', false);
                                        if (item.routeName) {
                                          // 福利详情和自营详情的goodsData的商品名字不一样，这里统一，然后跳转商品反馈
                                          if (item.routeName === 'Feedback') {
                                            const data = goodsData;
                                            if (goodsData.goodsName) {
                                              data.name = goodsData.goodsName;
                                            }
                                            // 自营和福利商品都是返回的id,消费取goodsId
                                            data.id = goodsData.goodsId;
                                            console.log('反馈数据', data);
                                            navigation.navigate(item.routeName, { goodsData: data });
                                          }
                                          // navigation.navigate(item.routeName, { goodsData });
                                        } else {
                                          console.log('shareParamsshareParams', shareParams);
                                          if (shareParams) {
                                            this.changeState('shareModal', true);
                                          } else {
                                            Toast.show('获取分享信息失败');
                                          }
                                        }
                                      }}
                                    >
                                      <Image source={item.icon} />
                                      <Text
                                      style={styles.modalInnerItem_text}
                                      >
                                        {item.title}
                                      </Text>
                                    </TouchableOpacity>
                                  </View>
                                );
                              })
                            }
                        </View>
                      </ImageBackground>
                    </TouchableOpacity>
                    )
                }
          {/* 分享 */}
          {
              shareModal && (
              <ShareTemplate
                type="WM"
                onClose={() => { this.changeState('shareModal', false); }}
                shareParams={shareParams}
                shareUrl={shareUrl}
                callback={() => { Toast.show('分享成功'); }}
              />
              )
          }
          {/* 中奖分享 */}
          {
            isPrizeShareModal && (
            <ShareTemplate
                type="XFDetail"
                shareUrl={shareUrl}
                onClose={() => { this.changeState('isPrizeShareModal', false); }}
                shareParams={isPrizeShareData}
                callback={this.jOrderDoShare}
            />
            )
            }
          {/* 分享后弹窗 */}
          <ModalDemo
            noTitle={false}
            visible={confimVis}
            btnText="确定"
            title="分享成功，你可以领取礼品啦！"
            onClose={() => {
              this.changeState('confimVis', false);
            }}
            onConfirm={() => {
              this.goToGetLotteryGoods();
            }}
          />
          {/* 查看大图 */}
          <ShowBigPicModal
            isShowPage
            ImageList={this.state.bigList}
            visible={this.state.showBingPicVisible}
            showImgIndex={this.state.bigIndex}
            onClose={() => {
              StatusBar.setHidden(false);
              this.setState({
                showBingPicVisible: false,
              });
            }}
          />
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  headerStyle: {
    position: 'absolute',
    top: CommonStyles.headerPadding,
    height: 44,
    paddingTop: 0,
    backgroundColor: 'transparent',
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    width: 50,
  },
  footerView: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 50 + CommonStyles.footerPadding,
    paddingBottom: CommonStyles.footerPadding,
  },
  footerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: 50,
  },
  footerItem1: {
    flex: 1.6,
    backgroundColor: '#fff',
  },
  footerItem1_imgView: {
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
    paddingHorizontal: 10,
  },
  footerItem2: {
    flex: 1,
    backgroundColor: '#4A90FA',
  },
  footerItem3: {
    flex: 1,
    backgroundColor: '#EE6161',
  },
  footerItem_text: {
    fontSize: 14,
    color: '#fff',
  },
  modalOutView: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'transparent',
  },
  modalInnerView: {
    position: 'absolute',
    top: 44 + CommonStyles.headerPadding,
    right: 12,
    justifyContent: 'flex-end',
    width: 126,
    height: 93,
  },
  modalInnerItem: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    width: '100%',
    height: '100%',
    paddingLeft: 5,
    // height: 41,
    // paddingLeft: 15
  },
  border: {
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(255,255,255,.2)',
  },
  modalInnerItem_text: {
    fontSize: 17,
    color: '#fff',
    marginLeft: 8,
  },

  moreModalWrap: {
    height: 93 - 12,
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default connect(
  null,
)(WMXFGoodsDetailScreen);
