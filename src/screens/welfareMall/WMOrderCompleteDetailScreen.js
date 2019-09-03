/* eslint-disable consistent-return */
/**
 * 福利商城 已完成订单
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

const { width, height } = Dimensions.get('window');

class WMOrderCompleteDetailScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        orderData: {
          lotteryTime: new Date(),
        },
        goodsData: {
          state: '',
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
      const goodsData = this.props.navigation.getParam('params');
      requestApi.detailJLottery({
        // sequenceId: '5c131526033455380df889bf',
        sequenceId: goodsData.termNumber,
        orderId: goodsData.orderId,
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
          goodsData,
          showBigPicArr: temp,
        });
      }).catch((err) => {
        console.log(err);
      });
    }

    // 获取订单详情
    getOrderDetail = () => {
      const goodsData = this.props.navigation.getParam('params');
      console.log('goodsData', goodsData);
      Loading.show();
      console.log('params', goodsData);
      const params = {
        orderId: goodsData.orderId,
      };
      requestApi.qureyWMOrderDetail(params).then((res) => {
        console.log('orderDetail', res);
        if (res) {
          this.setState({
            orderData: res,
            goodsData,
          });
        }
      }).catch((err) => {
        console.log(err);
      });
    }

    // 获取其他购买用户的记录
    getAllUserBuyList = () => {
      const { limit, page } = this.state;
      const goodsData = this.props.navigation.getParam('params');
      const param = {
        limit,
        page,
        sequenceId: goodsData.termNumber,
        orderId: goodsData.orderId,
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

    getOperateBtn = (itemData) => {
      const { navigation } = this.props;
      const { showImgLimit, winnerInfo, showBigPicArr } = this.state;
      if (!itemData) return;
      switch (itemData.lottery) {
        // eslint-disable-next-line consistent-return
        case 'SHARE_LOTTERY': return (
          <View style={{ paddingBottom: 10 }}>
            <Text style={[styles.showOrderText]}>{winnerInfo.content}</Text>
            <View style={styles.showOrderImgWrap}>
              {
                showBigPicArr && showBigPicArr.map((item, index) => {
                  if (index > showImgLimit - 1) return null;
                  return (
                    <TouchableOpacity key={index} onPress={() => { this.setState({ largeImage: item, showBingPicVisible: true, showImgIndex: index }); }}>
                      <Image style={styles.showOrderImg} defaultSource={require('../../images/skeleton/skeleton_img.png')} source={{ uri: (item.type === 'video') ? item.mainPic : item.url }} />
                      {
                          (item.type === 'video')
                            ? (
                              <View style={{
                                height: '100%', width: '100%', position: 'absolute', ...CommonStyles.flex_center,
                              }}
                              >
                                <Image style={{ height: 40, width: 40 }} source={require('../../images/index/video_play_icon.png')} />
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
              showBigPicArr && showBigPicArr.length > 3 && (
              <TouchableOpacity onPress={this.handleToogleShow}>
                <Text style={styles.showMoreImgBtn}>{showImgLimit === 3 ? '展开' : '收起'}</Text>
              </TouchableOpacity>
              )
            }
          </View>
        );
        case 'LOSING_LOTTERY': return null;
        // eslint-disable-next-line consistent-return
        case 'SHARE_AUDIT_ING': return (
          <TouchableOpacity style={styles.prizeInfoOperateWrap} onPress={() => { }}>
            <Text style={styles.prizeInfoBtn}>晒单审核中</Text>
          </TouchableOpacity>
        );
        // eslint-disable-next-line consistent-return
        case 'WINNING_LOTTERY': return (
          <TouchableOpacity style={styles.prizeInfoOperateWrap} onPress={() => { navigation.navigate('WMShowOrder', { orderInfo: itemData, callback: () => { this.getDetailJLottery(); } }); }}>
            <Text style={styles.prizeInfoBtn}>晒单返券</Text>
          </TouchableOpacity>
        );
        // eslint-disable-next-line consistent-return
        case 'SHARE_AUDIT_FAIL': return (
          <TouchableOpacity style={styles.prizeInfoOperateWrap} onPress={() => { navigation.navigate('WMShowOrder', { orderInfo: itemData, callback: () => { this.getDetailJLottery(); } }); }}>
            <Text style={styles.prizeInfoBtn}>重新晒单</Text>
          </TouchableOpacity>
        );
        default: null;
      }
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
        goodsData, showBingPicVisible, showImgIndex, userBuyRecord, showShareModal, winnerInfo, showImgLimit, showBigPicArr,
      } = this.state;
      console.log('userBuyRecord', userBuyRecord);
      console.log('orderData', winnerInfo);
      const gzDataList = [
        {
          label: '公证开奖时间：',
          value: moment(winnerInfo.thirdWinningTime * 1000).format('YYYY-MM-DD HH:mm'),
        },
        {
          label: '公证开奖期数：',
          value: winnerInfo.thirdWinningNo || 0,
        },
        {
          label: '公证开奖号码：',
          value: winnerInfo.thirdWinningNumber || 0,
        },
      ];
      const isShow = navigation.getParam('isShow', false); // 是否是展示作用，如果是，不显示操作按钮
      console.log('showBigPicArr', showBigPicArr);
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="中奖详情"
            rightView={(
              <TouchableOpacity onPress={() => { this.handleChangeState('showShareModal', true); }}>
                <Image style={styles.headRißghtIcon} source={require('../../images/wm/wmshare_icon.png')} />
              </TouchableOpacity>
            )}
          />
          <ScrollView
            style={{ marginBottom: CommonStyles.footerPadding }}
            showsHorizontalScrollIndicator={false}
            showsVerticalScrollIndicator={false}
          >
            {
                        // 新增的公证开奖
              <View style={styles.gzWrpa}>
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
            {/* 中奖人信息,有可能存在时间过期了，但是没人参与的订单(从首页最新揭晓进入的时候) */}
            <View style={styles.prizeWrap}>
              {
                winnerInfo.lotteryNumber
                  ? (
                    <View style={[styles.flexStart, (orderData.state === 'SHARE_LOTTERY' ? {} : styles.borderBottom)]}>
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
                        goodsWrap={orderData.state === 'SHARE_LOTTERY' ? { paddingBottom: 0 } : {}}
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
                  : null
                }

              {
                // 如果是本人中奖 显示操作按钮和晒单信息
                winnerInfo.isSelfLottery === 1 && !isShow && this.getOperateBtn(winnerInfo)
              }
              {
                // 如果不是本人，且晒单通过，只显示晒单信息
                winnerInfo.isSelfLottery === 0
                  ? winnerInfo.lottery === 'SHARE_LOTTERY'
                    ? (
                      <React.Fragment>
                        <Text style={styles.showOrderText}>{winnerInfo.content}</Text>
                        <View style={styles.showOrderImgWrap}>
                          {
                            showBigPicArr && showBigPicArr.map((item, index) => {
                              if (index > showImgLimit - 1) return;
                              return (
                                // eslint-disable-next-line react/no-array-index-key
                                <TouchableOpacity key={index} onPress={() => { this.setState({ largeImage: item, showBingPicVisible: true, showImgIndex: index }); }}>
                                  <Image style={styles.showOrderImg} defaultSource={require('../../images/skeleton/skeleton_img.png')} source={{ uri: (item.type === 'video' ? item.mainPic : getPreviewImage(item.url, '50p')) }} />
                                </TouchableOpacity>
                              );
                            })
                          }
                        </View>
                        {
                                showBigPicArr && showBigPicArr.length > 3 && (
                                <TouchableOpacity onPress={this.handleToogleShow}>
                                  <Text style={styles.showMoreImgBtn}>{showImgLimit === 3 ? '展开' : '收起'}</Text>
                                </TouchableOpacity>
                                )
                            }
                        {/* <View style={[styles.flexEnd, styles.commentWrap]}>
                            <Image style={{ width: 12, height: 12 }} source={require('../../images/wm/wm_comment_icon.png')} />
                            <Text style={styles.commentBtn}>评论</Text>
                        </View> */}
                      </React.Fragment>
                    )
                    : null
                  : null
              }
            </View>
            {/* 所有人购买历史 */}
            <View style={styles.carshListWrap}>
              {
                // orderData.goodsType !== 4 && dataList.map((item, index) => {
                userBuyRecord && userBuyRecord.length !== 0 && userBuyRecord.map((item, index) => (
                  // eslint-disable-next-line react/no-array-index-key
                  <View style={styles.buyListItem} key={index}>
                    <View style={[styles.flexStart_noCenter]}>
                      <TouchableOpacity activeOpacity={item.userType !== 'muser' ? 0.7 : 1} onPress={() => { item.userType !== 'muser' ? nativeApi.jumpPersonalCenter(item.userId) : null; }}>
                        <Image source={{ uri: getPreviewImage(item.avatar, '50p') }} style={styles.carshListItemimg} />
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
    color: '#222',
  },
  color_red: {
    color: '#EE6161',
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
    color: '#222',
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
  btmLabel: {
    fontSize: 14,
    color: '#555',
  },
  redColor: {
    color: '#EE6161',
  },
});

export default connect(
  state => ({ orderData: state.welfare.wmOrderDetail }),
)(WMOrderCompleteDetailScreen);
