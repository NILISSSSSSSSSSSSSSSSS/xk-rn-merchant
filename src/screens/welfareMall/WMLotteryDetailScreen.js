// 中奖详情页面
// 入口 最新揭晓，已完成列表未中奖详情
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
import { connect } from 'rn-dva';
import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import * as requestApi from '../../config/requestApi';
import ShareTemplate from '../../components/ShareTemplate';
import { getPreviewImage } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';
const defaultSource = require('../../images/skeleton/skeleton_img.png')
const { width, height } = Dimensions.get('window');

class WMLotteryDetailScreen extends NavigationComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    this.state = {
      orderData: {
        lotteryTime: new Date(),
      },
      winnerInfo: {
        pictures: [],
        thirdWinningTime: new Date(),
        thirdWinningNumber: '',
        thirdWinningNo: 0,
        lotteryNumber: 0,
        factDrawDate: moment().format('YYYY-MM-DD HH:mm:ss'),
      },
      showImgLimit: 3,
      limit: 10,
      page: 1,
      showBingPicVisible: false, // 显示大图modal状态
      showImgIndex: 0, // 显示大图，显示第几张图
      userBuyRecord: [], // 所有用户购买记录
      showShareModal: false, // 显示分享弹窗
      showBigPicArr: [], // 显示大图资源
    };
  }

  blurState = {
    showBingPicVisible: false, // 显示大图modal状态
    showShareModal: false, // 显示分享弹窗
  }

  componentDidMount() {
    Loading.show();
    // this.getOrderDetail()
    this.getDetailJLottery();
    this.getAllUserBuyList();
  }

  componentWillUnmount() {
    super.componentWillUnmount();
    Loading.hide();
  }

  // 获取中奖人晒单信息
  getDetailJLottery = () => {
    const { navigation } = this.props;
    const sequenceId = navigation.getParam('sequenceId', '');
    const orderId = navigation.getParam('orderId', '');
    requestApi.detailJLottery({
      sequenceId,
      orderId,
    }).then((res) => {
      console.log('resres', res);
      const temp = [];
      res.pictures && res.pictures.map((item) => {
        temp.push({
          type: 'images',
          url: item,
        });
      });
      if (res.videoMainUrl !== null && res.videoUrl !== null && res.videoMainUrl !== '' && res.videoUrl !== '') {
        temp.push({
          type: 'video',
          url: res.videoUrl,
          mainPic: res.videoMainUrl,
        });
      }
      this.setState({
        winnerInfo: res,
        showBigPicArr: temp,
      });
    }).catch((err) => {
      console.log(err);
    });
  }

  // 获取订单详情
  getOrderDetail = () => {
    // const orderId = this.props.navigation.getParam('orderId', '');
    const orderId = navigation.state.params.params.orderId || '';
    Loading.show();
    const params = {
      orderId,
    };
    requestApi.qureyWMOrderDetail(params).then((res) => {
      console.log('orderDetail', res);
      if (res) {
        this.setState({
          orderData: res,
        });
      }
    }).catch((err) => {
      console.log(err);
    });
  }
  getData = () => {
    const { navigation, dispatch } = this.props;
    const orderId = navigation.getParam('orderId', '');
    const params = {
      orderId,
    };
    dispatch({ type: 'welfare/qureyWMOrderDetail', payload: { params } });
  };
  // 获取其他购买用户的记录
  getAllUserBuyList = () => {
    const { limit, page } = this.state;
    const { navigation } = this.props;
    const sequenceId = navigation.getParam('sequenceId', '');
    const orderId = navigation.getParam('orderId', '');
    const param = {
      limit,
      page,
      sequenceId,
      orderId,
    };
    requestApi.jSequenceJoinQPage(param).then((res) => {
      console.log('购买记录', res);
      const temp = [];
      if (res) {
        res.data.map((item) => {
          const tempItem = item;
          tempItem.showMore = false;
          temp.push(tempItem);
        });
      }
      this.handleChangeState('userBuyRecord', temp);
    }).catch((err) => {
      console.log(err);
    });
  }

  handleToogleShow = () => {
    const { showImgLimit } = this.state;
    const len = showImgLimit === 3 ? 9 : 3;
    this.handleChangeState('showImgLimit', len);
  }

  handleChangeState = (key, value, callback = () => { }) => {
    this.setState({
      [key]: value,
    }, () => {
      callback();
    });
  }

  // 所有人购买记录
  handleToogleShowMore = (item, index) => {
    const { userBuyRecord } = this.state;
    item.showMore = !item.showMore;
    userBuyRecord[index] = item;
    this.handleChangeState('userBuyRecord', userBuyRecord);
  }

  render() {
    const { navigation, orderData } = this.props;
    const {
      showBingPicVisible, showImgIndex, userBuyRecord, showShareModal, winnerInfo, showImgLimit, showBigPicArr,
    } = this.state;
    console.log('userBuyRecord', userBuyRecord);
    console.log('orderData', winnerInfo);
    console.log('showBigPicArr', showBigPicArr);
    console.log('this.props',this.props)
    const gzDataList = [
      {
        label: '重庆时时彩开奖日期：',
        value: moment(winnerInfo.thirdWinningTime * 1000).format('YYYY-MM-DD'),
      },
      {
        label: '重庆时时彩开奖期数：',
        value: winnerInfo.thirdWinningNo || 0,
      },
      {
        label: '重庆时时彩开奖号码：',
        value: winnerInfo.thirdWinningNumber || 0,
      },
    ];
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack
          title="中奖详情"
          rightView={(
            <TouchableOpacity onPress={() => { this.handleChangeState('showShareModal', true); }}>
              <Image style={styles.headRightIcon} source={require('../../images/wm/wmshare_icon.png')} />
            </TouchableOpacity>
          )}
        />
        <ScrollView
          showsHorizontalScrollIndicator={false}
          showsVerticalScrollIndicator={false}
        >
          {
            // 新增的公证开奖
            <View style={styles.gzWrpa}>
              <View style={[CommonStyles.flex_between, { padding: 15, borderBottomColor: '#f1f1f1', borderBottomWidth: 1 }]}>
                <View style={[CommonStyles.flex_1, CommonStyles.flex_start]}>
                  <Image source={require('../../images/wm/blueLine.png')} style={{ width: 3, height: 12 }} />
                  <Text style={{ fontSize: 14, color: '#222', paddingLeft: 6 }}>开奖依据</Text>
                </View>
                <TouchableOpacity
                  activeOpacity={0.7}
                  style={[CommonStyles.flex_1, CommonStyles.flex_end]}
                  onPress={() => {
                    const param = {
                      thirdWinningTime: winnerInfo.thirdWinningTime,
                      thirdWinningNo: winnerInfo.thirdWinningNo,
                      thirdWinningNumber: winnerInfo.thirdWinningNumber,
                      termNumber: winnerInfo.termNumber,
                      userBuyRecord: winnerInfo.currentCustomerNum || 0, // 本期参与人次
                      lotteryNumber: winnerInfo.lotteryNumber, // 中奖编号
                    };
                    navigation.navigate('WMLotteryAlgorithm', { lotteryData: param });
                  }}
                >
                  <Text style={{ fontSize: 14, color: '#999', paddingRight: 6 }}>查看开奖算法</Text>
                  <Image source={require('../../images/wm/goto_gray.png')} />
                </TouchableOpacity>
              </View>
              {
                gzDataList.map((item, index) => {
                  const paddingBottom = index === gzDataList.length - 1 ? null : { paddingBottom: 0 };
                  return (
                    <View style={[CommonStyles.flex_start, { padding: 10 }, paddingBottom]} key={index}>
                      <Text style={styles.btmLabel}>{item.label}</Text>
                      <Text style={[styles.btmLabel, (index === 1) ? styles.redColor : null]}>{item.value}</Text>
                    </View>
                  );
                })
              }
            </View>
          }
          <View style={styles.prizeWrap}>
            <View style={[{ padding: 15, borderBottomColor: '#f1f1f1', borderBottomWidth: 1 }]}>
              <View style={[CommonStyles.flex_1, CommonStyles.flex_start]}>
                <Image source={require('../../images/wm/redLine.png')} style={{ width: 3, height: 12 }} />
                <Text style={{ fontSize: 14, color: '#222', paddingLeft: 6 }}>中奖详情</Text>
              </View>
            </View>
            {
              winnerInfo.lotteryNumber
                ? (
                  <View style={[styles.flexStart, styles.borderBottom]}>
                    <WMGoodsWrap
                      imgHeight={60}
                      imgWidth={60}
                      imgUrl={winnerInfo.avatar}
                      title={winnerInfo.nickname}
                      goodsTitleStyle={{ fontSize: 14, color: '#222' }}
                      showProcess={false}
                      showPrice={false}
                      imgStyle={styles.imgStyle}
                      numberOfLines={1}
                    >
                      <View style={[styles.flexStart, { marginTop: 10 }]}>
                        <Text style={styles.prizeInfoLabel}>中奖编号：</Text>
                        <Text style={[styles.prizeInfoLabel, styles.color_red]}>{winnerInfo.lotteryNumber}</Text>
                      </View>
                      <View style={[styles.flexStart, { marginTop: 1 }]}>
                        <Text style={styles.prizeInfoLabel}>开奖时间：</Text>
                        <Text style={styles.prizeInfoLabel}>{moment(winnerInfo.factDrawDate * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                      </View>
                    </WMGoodsWrap>
                  </View>
                )
                : <Text style={{ padding: 15, textAlign: 'center' }}>无人参与，系统自动开奖</Text>
            }
            {
              // 显示晒单信息
              winnerInfo.lottery === 'SHARE_LOTTERY'
                ? (
                  <React.Fragment>
                    <Text style={styles.showOrderText}>{winnerInfo.content}</Text>
                    <View style={styles.showOrderImgWrap}>
                      {
                        showBigPicArr && showBigPicArr.map((item, index) => {
                          if (index > showImgLimit - 1) return;
                          // eslint-disable-next-line consistent-return
                          return (
                            <TouchableOpacity key={index} onPress={() => { this.setState({ largeImage: item, showBingPicVisible: true, showImgIndex: index }); }}>
                              <Image style={styles.showOrderImg} defaultSource={defaultSource} source={{ uri: (item.type === 'video' ? item.mainPic : getPreviewImage(item.url, '50p')) }} />
                              {
                                item.type === 'video'
                                  ? (
                                    <View style={{
                                      height: 80, width: 80, position: 'absolute', top: 5, ...CommonStyles.flex_center,
                                    }}
                                    >
                                      <Image style={styles.video_btn} source={require('../../images/index/video_play_icon.png')} />
                                    </View>
                                  )
                                  : null
                              }
                            </TouchableOpacity>
                          );
                        })
                      }
                    </View>
                    {
                      (showBigPicArr && showBigPicArr.length > 3) && (
                        <TouchableOpacity onPress={this.handleToogleShow}>
                          <Text style={styles.showMoreImgBtn}>{showImgLimit === 3 ? '展开' : '收起'}</Text>
                        </TouchableOpacity>
                      )
                    }
                  </React.Fragment>
                )
                : null
            }
          </View>
          {/* 所有人购买历史 */}
          <View style={styles.carshListWrap}>
            <View style={[CommonStyles.flex_between, { padding: 15, borderBottomColor: '#f1f1f1', borderBottomWidth: 1 }]}>
              <View style={[CommonStyles.flex_1, CommonStyles.flex_start]}>
                <Image source={require('../../images/wm/blueLine.png')} style={{ width: 3, height: 12 }} />
                <Text style={{ fontSize: 14, color: '#222', paddingLeft: 6 }}>参与详情</Text>
              </View>
              <TouchableOpacity
                activeOpacity={0.7}
                style={[CommonStyles.flex_1, CommonStyles.flex_end]}
                onPress={() => {
                  navigation.navigate('WMPartakeDetail', { sequenceId: winnerInfo.termNumber });
                }}
              >
                <Text style={{ fontSize: 14, color: '#999', paddingRight: 6 }}>查看全部参与</Text>
                <Image source={require('../../images/wm/goto_gray.png')} />
              </TouchableOpacity>
            </View>
            {
              userBuyRecord.length === 0 && <Text style={{ padding: 15, textAlign: 'center' }}>无人参与，系统自动开奖</Text>
            }
            {
              // orderData.goodsType !== 4 && dataList.map((item, index) => {
              userBuyRecord && userBuyRecord.length !== 0 && userBuyRecord.map((item, index) => (
                <View style={styles.buyListItem} key={index}>
                  <View style={[styles.flexStart_noCenter]}>
                    <TouchableOpacity activeOpacity={item.userType !== 'muser' ? 0.7 : 1} onPress={() => { item.userType !== 'muser' ? nativeApi.jumpPersonalCenter(item.userId) : null; }}>
                      <Image source={item.avatar ? { uri: getPreviewImage(item.avatar, '50p') } : defaultSource} style={styles.carshListItemimg} />
                    </TouchableOpacity>
                    <View style={[styles.flex_1, styles.buyListItemRightWrap]}>
                      <View style={styles.flextBetwwen}>
                        <View style={styles.flexStart}>
                          <Text style={styles.buyListItemTitle}>购买注数:</Text>
                          <Text style={[styles.buyListItemTitle, { color: '#EE6161', paddingLeft: 5 }]}>{item.orderNumber}</Text>
                        </View>
                        <Text style={styles.buyListItemTime}>
                          购买时间：
                            {moment(item.createdAt * 1000).format('YYYY-MM-DD')}
                        </Text>
                      </View>
                      {
                        item.lotteryNumbers.map((itemData, j) => {
                          if (item.showMore) {
                            return (
                              <Text key={j} style={styles.buyListItemNum}>
                                编号：
                                  {itemData}
                              </Text>
                            );
                          }
                          if (j <= 2) {
                            return (
                              <Text key={j} style={styles.buyListItemNum}>
                                编号：
                                  {itemData}
                              </Text>
                            );
                          }
                        })
                      }
                      {
                        item.lotteryNumbers.length > 3 && (
                          <TouchableOpacity onPress={() => { this.handleToogleShowMore(item, index); }}>
                            <Text style={[styles.showMoreImgBtn, { paddingLeft: 0 }]}>{item.showMore ? '收起' : '展开'}</Text>
                          </TouchableOpacity>
                        )
                      }
                    </View>
                  </View>
                </View>
              ))
            }
          </View>
        </ScrollView>
        {/* 分享 */}
        {
          showShareModal && (
            <ShareTemplate
              type="WMOrderList"
              onClose={() => { this.handleChangeState('showShareModal', false); }}
              shareParams={winnerInfo}
            />
          )
        }
        {/* 查看大图 */}
        <ShowBigPicModal
          ImageList={showBigPicArr}
          visible={showBingPicVisible}
          showImgIndex={showImgIndex}
          onClose={() => { this.handleChangeState('showBingPicVisible', false); }}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  flex_1: {
    flex: 1,
  },
  flexStart: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  flexEnd: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  flexStart_noCenter: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
  },
  flextBetwwen: {
    justifyContent: 'space-between',
    flexDirection: 'row',
    alignItems: 'center',
  },
  headRightIcon: {
    marginRight: 25,
  },
  prizeWrap: {
    // borderWidth: 1,
    // borderColor: 'rgba(215,215,215,0.5)',
    borderRadius: 8,
    backgroundColor: '#fff',
    overflow: 'hidden',
    marginTop: 10,
    marginHorizontal: 10,
  },
  prizeInfoTitle: {
    fontSize: 14,
    color: '#222',
    lineHeight: 17,
  },
  prizeInfoLabel: {
    fontSize: 12,
    color: '#555',
  },
  color_red: {
    color: '#EE6161',
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  prizeInfoOperateWrap: {
    padding: 15,
    borderRadius: 8,
    margin: 10,
    paddingVertical: 13,
    backgroundColor: CommonStyles.globalHeaderColor,
  },
  prizeInfoBtn: {
    color: '#fff',
    textAlign: 'center',
  },
  carshListWrap: {
    margin: 10,
    borderRadius: 8,
    backgroundColor: '#fff',
    // borderWidth: 1,
    // borderColor: 'rgba(215,215,215,0.5)',
  },
  buyListItem: {
    padding: 15,
    borderBottomWidth: 1,
    borderColor: '#F1F1F1',
  },
  carshListItemimg: {
    height: 40,
    width: 40,
    borderRadius: 8,
  },
  buyListItemRightWrap: {
    paddingLeft: 10,
  },
  buyListItemTitle: {
    fontSize: 14,
    color: '#222',
  },
  buyListItemTime: {
    fontSize: 10,
    color: '#555',
  },
  buyListItemNum: {
    fontSize: 12,
    color: '#555',
    marginTop: 3,
  },
  showOrderText: {
    backgroundColor: '#fff',
    fontSize: 12,
    color: '#555',
    paddingHorizontal: 12,
    lineHeight: 17,
    paddingTop: 10,
  },
  showOrderImgWrap: {
    backgroundColor: '#fff',
    flexDirection: 'row',
    justifyContent: 'flex-start',
    flexWrap: 'wrap',
    paddingLeft: 15,
    paddingTop: 5,
    paddingBottom: 10,
  },
  showOrderImg: {
    width: 80,
    height: 80,
    marginRight: 5,
    marginTop: 5,
  },
  commentWrap: {
    padding: 15,
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  commentBtn: {
    fontSize: 12,
    color: '#777',
    paddingLeft: 3,
  },
  showMoreImgBtn: {
    color: CommonStyles.globalHeaderColor,
    fontSize: 12,
    paddingLeft: 15,
    marginTop: 5,
    paddingBottom: 5,
  },
  imgStyle: {
    borderRadius: 8,
  },
  gzWrpa: {
    backgroundColor: '#fff',
    margin: 10,
    marginBottom: 0,
    borderRadius: 8,
  },
  borderBottom: {
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  btmLabel: {
    fontSize: 14,
    color: '#555',
  },
  redColor: {
    color: '#EE6161',
  },
  video_btn: {
    // position: 'absolute',
    width: 30,
    height: 30,
  },
});

export default connect(
  state => ({ orderData: state.welfare.wmOrderDetail }),
)(WMLotteryDetailScreen);
