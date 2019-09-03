/**
 * 往期中奖纪录
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  
  Platform,
  StatusBar,
  View,
  Text,
  TouchableOpacity,
  Image,
  Button,
  ImageBackground,
  ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import FlatListView from '../../components/FlatListView';

const defaultImg = require('../../images/default/user.png');
const nperIcon = require('../../images/wm/pastWinnerIcon.png');
const goMoreIcon = require('../../images/wm/pastWinnerMore.png');
const nperBtn = require('../../images/wm/pastWinnerBtn.png');

const { width, height } = Dimensions.get('window');

class PastWinners extends Component {
  componentDidMount() {
    this.getData(1);
  }

  getData = (page = 1) => {
    const { navigation, dispatch } = this.props;
    const goodsData = navigation.getParam('goodsData', '');
    const params = {
      page,
      limit: 10,
      goodsId: goodsData.id,
    };
    dispatch({ type: 'welfare/getPastWinnerList', payload: { params } });
  }

  handleChangeState = (key = '', value = '') => {
    this.setState({ [key]: value });
  }

  // 中奖详情
  gotToLotterDetail = (item) => {
    if (item.usage === 'welfare') {
      this.props.navigation.push('WMLotteryDetail', {
        sequenceId: item.jSequenceId || '',
        orderId: item.orderId || '',
      });
      return
    }
    this.props.navigation.push('WMXFGoodsDetail', {
      goodsData: {
        sequenceId: item.jSequenceId || '',
        orderId: item.orderId || '',
        goodsId: item.goodsId
      },
    });

  }

    renderItem = ({ item, index }) => {
      const { pastWinnerList } = this.props;
      const marginBottom = index === pastWinnerList.data.length - 1 ? styles.marginBottom : {};
      return (
        <React.Fragment>
          { index === 0 ? <View style={styles.topBgView} /> : null }
          <View style={[styles.itemWrap, marginBottom]}>
            <View style={[CommonStyles.flex_start, styles.itemTitleWrpa]}>
              <Image source={nperIcon} />
              <Text style={[styles.itemNperText, styles.titleStyle]}>{item.currentNper >= 10 ? `第${item.currentNper}期` : `第0${item.currentNper}期`}</Text>
              <Text style={styles.titleStyle}>{moment(item.realityLotteryDate * 1000).format('YYYY-MM-DD HH:mm')}</Text>
            </View>
            <View style={[CommonStyles.flex_between, styles.joinUserInfo]}>
              {
                item.userId
                  ? (
                    <View style={[CommonStyles.flex_start_noCenter]}>
                      <Image source={item.avatar ? { uri: item.avatar } : defaultImg} style={styles.userImage} />
                      <View style={{ paddingLeft: 15 }}>
                        <Text numberOfLines={1} style={styles.userInoText}>{item.userName || ''}</Text>
                        <Text style={[styles.userInoText, { color: '#999', paddingTop: 5 }]}>
                          中奖号码：
                          <Text style={[styles.userInoText, styles.color_red]}>{`${item.jLotteryNumber}`}</Text>
                        </Text>
                      </View>
                    </View>
                  )
                  : <Text style={styles.infoText}>无人参与，系统自动开奖！</Text>
              }
              <View style={[styles.btnWrap]}>
                <TouchableOpacity
                  activeOpacity={0.65}
                  style={[CommonStyles.flex_between, styles.itemMoreBtn]}
                  onPress={() => { this.gotToLotterDetail(item); }}
                >
                  <ImageBackground source={nperBtn} style={[{ width: '100%', height: '100%' }, CommonStyles.flex_center]} imageStyle={{ width: 72, height: 26 }}>
                    <View style={[CommonStyles.flex_start]}>
                      <Text style={styles.itemMoreText}>中奖详情</Text>
                      <Image source={goMoreIcon} />
                    </View>
                  </ImageBackground>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </React.Fragment>
      );
    }

    render() {
      const { navigation, pastWinnerList } = this.props;
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="往期揭晓"
          />
          <FlatListView
            style={styles.flatList}
            store={pastWinnerList.params}
            data={pastWinnerList.data || []}
            emptyStyle={{ paddingBottom: 40 }}
            renderItem={this.renderItem}
            ListHeaderComponent={() => null}
            refreshData={() => {
              this.getData(1);
            }}
            ItemSeparatorComponent={() => (
              <View style={styles.flatListLine} />
            )}
            loadMoreData={() => {
              this.getData(pastWinnerList.params.page + 1);
            }}
            ListFooterComponent={() => null}
          />
        </View>
      );
    }
}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
  },
  flatList: {
    width,
    backgroundColor: CommonStyles.globalBgColor,
  },
  separator: {
    borderColor: '#F1F1F1',
    width,
    height: 0,
    borderWidth: 0.5,
  },
  itemWrap: {
    marginHorizontal: 10,
    marginTop: 10,
    backgroundColor: '#fff',
    borderRadius: 6,
  },
  itemTitleWrpa: {
    height: 40,
    paddingHorizontal: 15,
    paddingTop: 14,
    paddingBottom: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F1F1',
  },
  itemNperText: {
    paddingLeft: 4,
    paddingRight: 10,
  },
  titleStyle: {
    fontSize: 14,
    color: '#222',
  },
  joinUserInfo: {
    paddingHorizontal: 15,
    paddingTop: 15,
    paddingBottom: 12,
  },
  itemMoreBtn: {
    width: 72,
    height: 26,
    position: 'absolute',
    bottom: 0,
  },
  itemMoreText: {
    color: '#fff',
    fontSize: 12,
    paddingRight: 2,
    textAlign: 'center',
  },
  userImage: {
    width: 50,
    height: 50,
    borderRadius: 6,
  },
  infoText: {
    fontSize: 14,
    color: '#222',
  },
  userInoText: {
    fontSize: 14,
    color: '#222',
    paddingTop: 5,
    maxWidth: 168,
  },
  color_red: {
    color: '#EE6161',
  },
  btnWrap: {
    height: '100%',
    width: 72,
    minHeight: 26,
  },
  marginBottom: {
    marginBottom: 10,
  },
  topBgView: {
    backgroundColor: CommonStyles.globalHeaderColor,
    height: 49,
    width,
    position: 'absolute',
    top: 0,
  },
  flatListLine: {
    height: 1,
    backgroundColor: CommonStyles.globalBgColor,
  },
});

export default connect(
  state => ({
    userInfo: state.user.user,
    pastWinnerList: state.welfare.pastWinnerList,
  }),
  dispatch => ({ dispatch }),
)(PastWinners);
