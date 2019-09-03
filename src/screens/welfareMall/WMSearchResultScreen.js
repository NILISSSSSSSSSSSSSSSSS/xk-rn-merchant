/**
 * 福利商城搜索结果页
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  
  View,
  ScrollView,
  Text,
  TouchableOpacity,
  Image,
  Button,
  Keyboard,
} from 'react-native';
import { connect } from 'rn-dva';


import moment from 'moment';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import ImageView from '../../components/ImageView';
import WMGoodsWrap from '../../components/WMGoodsWrap';
import TextInputView from '../../components/TextInputView';
import math from '../../config/math';
import { showSaleNumText } from '../../config/utils'

const { width, height } = Dimensions.get('window');
class WMSearchResultScreen extends Component {
    static navigationOptions = {
      header: null,
    }
    scrollHeight = 0;
    constructor(props) {
      super(props);
      this.state = {
        keyword: props.navigation.getParam('keyword', ''),
        page: 1,
        limit: 10,
        refreshing: false,
        loading: false,
        hasMore: false,
        total: 0,
        goodLists: [],
        searchText: props.navigation.getParam('keyword', ''),
      };
    }

    componentDidMount() {
      Loading.show();
      this.qureyCategoryDataByCode(1, this.state.keyword, true);
      Keyboard.dismiss();
    }

    // 获取搜索的数据
    qureyCategoryDataByCode = (page = 1, keyWord = this.state.keyWord, loading = false) => {
      const { limit, total, goodLists } = this.state;
      if (loading) {
        this.handleChangeState('loading', true);
      }
      requestApi.jmallEsSearch({
        page,
        limit,
        jCondition: {
          categoryCode: '',
          goodsName: keyWord,
        },
      }).then((data) => {
        console.log('%cdata', 'color: green', data || []);
        let _data;
        if (page === 1) {
          _data = data ? data.data : [];
        } else {
          _data = data ? [...goodLists, ...data.data] : goodLists;
        }
        const _total = page === 1 ? (data && data.total) : total;
        const hasMore = data ? _total !== _data.length : false;
        this.setState({
          refreshing: false,
          loading: false,
          page,
          hasMore,
          total: _total,
          goodLists: _data,
        });
      }).catch((err) => {
        this.setState({
          refreshing: false,
          loading: false,
        });
      });
    }
    // 提交搜索
    onSubmitText = (data) => {
      Loading.show();
      Keyboard.dismiss();
      const { searchText, historyLists } = this.state;
      let keyword;
      if (data) {
        keyword = data;
      } else {
        if (searchText.trim().length === 0) {
          Loading.hide();
          Toast.show('请输入搜索内容');
          this.handleChangeState('searchText', '');
          return;
        }
        keyword = searchText;
      }
      requestApi.storageSearchWMHistory('save', [], keyword);
      this.qureyCategoryDataByCode(1, keyword, true);
    };
    handleChangeState(key, value) {
      this.setState({
        [key]: value,
      });
    }
    getPrizeLable = (drawType) => {
      switch (drawType) {
        case 'bymember': return (
          <Image source={require('../../images/wm/processPrizeicon.png')} />
        );
        case 'bytime': return (
          <Image source={require('../../images/wm/timePrizeicon.png')} />
        );
        case 'bytime_or_bymember': return (
          <Image source={require('../../images/wm/byTimeOrProcess.png')} />
        );
        case 'bytime_and_bymember': return (
          <Image source={require('../../images/wm/byTimeAndProcess.png')} />
        );

        default: return null;
      }
    }
    renderItem = ({ item, index }) => {
      const borderRadiusTop = index === 0 ? styles.borderRadiusTop : null;
      const borderRadiusBottom = index === this.state.goodLists.length - 1 ? styles.borderRadiusBottom : null;
      const time = moment(item.expectDrawTime * 1000).format('MM-DD HH:mm');
      const value = math.multiply(math.divide(item.currentCustomerNum , item.eachSequenceNumber),100 ) ;
      // const processValue = (item.currentCustomerNum / item.eachSequenceNumber).toFixed(1) * 100
      const processValue = (value < 1 && value !== 0) ? '1' : parseInt(value);
      const processPercent = `${processValue}%`;
      let fixedNumber = item.eachSequenceNumber > 100000 ? 0 : 1;
      const showText = `${showSaleNumText(item.currentCustomerNum,fixedNumber)}/${showSaleNumText(item.eachSequenceNumber,fixedNumber)}`
      return (
        <TouchableOpacity
            style={[styles.goodsItemWrap, borderRadiusBottom, borderRadiusTop]}
            onPress={() => {
              this.props.navigation.navigate('WMGoodsDetail', {
                goodsId: item.goodsId,
                sequenceId: item.sequenceId,
              });
            }}
        >
          <View style={{
            position: 'absolute', top: 15, left: 15, zIndex: 1,
          }}
          >
            { // 获取开奖类型标签
              this.getPrizeLable(item.drawType)
            }
          </View>
          <WMGoodsWrap
            imgUrl={item.mainUrl}
            title={() => ( // 单独处理样式
              <Text style={styles.goodsViewText} numberOfLines={2}>
                <Text style={[styles.red_color]}>{`[${math.divide(item.perPrice, 100)}消费券夺${math.divide(item.price, 100)}元]`}</Text>
                {item.goodsName}
              </Text>
            )}
            showProcess
            type={item.drawType}
            processValue={processValue}
            label="开奖人次："
            timeLabel="开奖时间："
            timeValue={time}
            showText={showText}
            labelStyle={styles.labelStyle}
            renderInsertContent={() => (
              <React.Fragment>
                {/* <View style={{ height: 14,width: 100,paddingHorizontal: 5,marginTop: 5,marginBottom: 2,backgroundColor:'#FFEFEA',borderRadius: 14,...CommonStyles.flex_center }}>
                  <Text style={{ fontSize: 10,color:"#FF8523",textAlign: 'center' }}>中奖后凭券0元兑换</Text>
                </View> */}
                <View style={[CommonStyles.flex_start, { marginTop: 6 }]}>
                  <Text style={styles.labelText}>消费券：</Text>
                  <Text style={[styles.labelText, { color: '#222' }]}>{math.divide(item.perPrice, 100)}</Text>
                </View>
              </React.Fragment>
            )}
          />
        </TouchableOpacity>
      );
    }
    render() {
      const { navigation, store } = this.props;
      const { keyword, goodLists, searchText } = this.state;

      return (
        <View style={styles.container}>
          <Header
              navigation={navigation}
              goBack
              rightView={
                <View style={{ width: 15 }} />
              }
              centerView={(
                <View style={[styles.headerCenterItem1, CommonStyles.flex_1]}>
                  <TouchableOpacity
                    activeOpacity={0.8}
                    style={[CommonStyles.flex_1]}
                    onPress={() => {
                      // navigation.navigate('SOM')
                    }}
                  >
                    <TextInputView
                    inputView={[styles.headerItem, styles.headerCenterView]}
                    inputRef={(e) => { this.searchTextInput = e; }}
                    style={styles.headerTextInput}
                    value={searchText}
                    onChangeText={(text) => {
                      this.handleChangeState('searchText', text);
                    }}
                    returnKeyType="search"
                    onSubmitEditing={() => {
                      this.onSubmitText();
                    }}
                    leftIcon={(
                      <View style={[styles.headerTextInput_icon, styles.headerTextInput_search]}>
                        <Image source={require('../../images/mall/search.png')} />
                      </View>
                    )}
                    />
                  </TouchableOpacity>
                </View>
                )
              }
          />
          <FlatListView
          flatRef={(e) => { e && (this.flatListRef = e); }}
          style={styles.flatList}
          store={this.state}
          data={goodLists}
          onScroll={(e) => {
            const y = e.nativeEvent.contentOffset.y;
            this.scrollHeight = y;
          }}
          ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
          renderItem={this.renderItem}
          numColumns={1}
          refreshData={() => {
            this.handleChangeState('refreshing', true);
            this.qureyCategoryDataByCode(1, keyword, true);
          }}
          rightView={
            <View style={{ width: 0, backgroundColor: CommonStyles.globalRedColor }} />
          }
          loadMoreData={() => {
            this.qureyCategoryDataByCode(this.state.page + 1, keyword, true);
          }}
          />
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
  headerCenterView: {
    flex: 1,
  },
  headerCenterItem1: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
    flex: 1,
    height: 30,
    // paddingLeft: 5,
    // paddingRight: 10,
    borderRadius: 15,
    backgroundColor: 'rgba(255,255,255,0.3)',
    overflow: 'hidden',
  },
  headerCenterItem1_text: {
    fontSize: 12,
    color: '#fff',
    marginRight: 10,
  },
  headerCenterItem2: {
    width: 114,
  },
  headerCenterItem2_icon: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    height: '100%',
  },
  headerRightView: {
    width: 50,
  },
  headerRight_line: {
    width: 1,
    height: 23,
    backgroundColor: 'rgba(255,255,255,0.23)',
  },
  headerRight_icon: {
    flex: 1,
  },
  flatList: {
    flex: 1,
    backgroundColor: CommonStyles.globalBgColor,
  },
  flatListLine: {
    height: 1,
    backgroundColor: '#F1F1F1',
  },
  goodsItemWrap: {
    marginHorizontal: 10,
    backgroundColor: '#fff',
  },
  borderRadiusTop: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  borderRadiusBottom: {
    borderBottomLeftRadius: 8,
    borderBottomRightRadius: 8,
  },
  labelStyle: {
    fontSize: 12,
    color: '#777',
    paddingRight: 5,
  },
  headerTextInput: {
    flex: 1,
    height: '100%',
    paddingLeft: 35,
    paddingRight: 11,
    paddingVertical: 0,
    borderRadius: 15,
    fontSize: 14,
    // backgroundColor: 'rgba(255,255,255,0.3)',
    color: '#fff',

  },
  headerTextInput_icon: {
    position: 'absolute',
    top: 0,
    justifyContent: 'center',
    alignItems: 'center',
    width: 40,
    height: '100%',
    zIndex: 2,
  },
  headerTextInput_search: {
    left: 0,
  },
  headerTextInput_close: {
    right: 0,
  },
  headerTextInput_close_img: {
    width: 18,
    height: 18,
  },
  labelText: {
    fontSize: 12,
    color: '#777',
  },
  red_color: {
    color: '#EE6161',
  },
  goodsViewText: {
    fontSize: 14,
    lineHeight: 18,
    paddingLeft: 6,
    paddingTop: 8,
    color: '#101010',
  },
});

export default connect(
  state => ({ store: state }),
)(WMSearchResultScreen);
