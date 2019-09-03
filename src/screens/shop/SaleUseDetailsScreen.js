/**
 * 首页/促销管理/使用明细
 */


import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
} from 'react-native';
import { connect } from 'rn-dva';
import moment from 'moment';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import FlatListView from '../../components/FlatListView';
import * as requestApi from '../../config/requestApi';

const { width, height } = Dimensions.get('window');

class SaleUseDetailsScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    }

    constructor(props) {
      super(props);
      const { page, currentData } = this.props.navigation.state.params || {};
      this.state = {
        listName: `saleuse${page}`,
        currentData: currentData || {},
        page: page || 'card',
      };
    }

    componentDidMount() {
      this.getList(true, false);
    }
    componentWillUnmount() {
    }

    getList = (isFirst = false, isLoadingMore = false) => {
      const func = this.state.page == 'card' ? requestApi.shopListMember : requestApi.shopListCoupon;
      this.props.fetchList({
        witchList: this.state.listName,
        isFirst,
        isLoadingMore,
        paramsPrivate: {
          memberId: this.state.currentData.id,
          couponId: this.state.currentData.id,
        },
        api: func,
      });
    }

    renderItem = ({ item, index }) => {
      const page = this.state.page;
      const { longLists } = this.props;
      const { listName } = this.state;
      const length = longLists[listName] && longLists[listName].lists && longLists[listName].lists.length || 0;
      const viewStyle = {
        borderTopLeftRadius: index == 0 ? 8 : 0,
        borderTopRightRadius: index == 0 ? 8 : 0,
        borderBottomLeftRadius: index == length - 1 ? 8 : 0,
        borderBottomRightRadius: index == length - 1 ? 8 : 0,
        overflow: 'hidden',
      };
      let rightValue = '';
      let usefulColor = '#222222';
      if (page == 'card') {
        rightValue = `已使用${item.usedNum}次`;
        item.usedNum == 0 ? usefulColor = '#777777' : usefulColor = '#222222';
      } else {
        switch (item.couponStatus) { // 优惠券使用状态，UNUSED 未使用，INUSE 使用中，USED 已使用
          case 'UNUSED': rightValue = '未使用'; usefulColor = '#222222'; break;
          case 'INUSE': rightValue = '使用中'; usefulColor = '#222222'; break;
          case 'USED': rightValue = '已使用'; usefulColor = '#777777'; break;
          default: break;
        }
      }
      return (
        <View style={[styles.item, viewStyle]}>
          <ImageView
            source={item.pic ? { uri: item.pic } : require('../../images/caiwu/cash_left.png')}
            sourceWidth={40}
            sourceHeight={40}
            style={{ marginRight: 10, borderRadius: 40 }}
          />
          <View style={{ flex: 1, justifyContent: 'center' }}>
            <Text style={{ color: '#222222', fontSize: 14 }}>{item.userName || '用户名'}</Text>
            <Text style={{ color: '#555555', fontSize: 10, marginTop: 6 }}>
              {`领取时间 ${item.createdAt ? moment(item.createdAt * 1000).format('YYYY-MM-DD HH:mm') : ''}`}
            </Text>
          </View>
          <Text style={[styles.rightText, { color: usefulColor }]}>{rightValue}</Text>
        </View>
      );
    }
    render() {
      const { navigation, longLists } = this.props;
      const { page, listName } = this.state;
      return (
        <View style={styles.container}>
          <Header
                    title="使用明细"
                    navigation={navigation}
                    goBack
          />
          {/* <View style={styles.content}> */}
          <FlatListView
            style={styles.listView}
            renderItem={data => this.renderItem(data)}
            store={{
              ...longLists[listName],
              page: longLists[listName] && longLists[listName].listsPage || 1,
            }}
            data={longLists[listName] && longLists[listName].lists || []}
            ItemSeparatorComponent={() => <View style={styles.flatListLine} />}
            numColumns={1}
            refreshData={() => this.getList(false, false)}
            loadMoreData={() => this.getList(false, true)}
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
  item: {
    borderBottomWidth: 1,
    borderColor: '#F1F1F1',
    paddingHorizontal: 15,
    paddingVertical: 10,
    flexDirection: 'row',
    alignItems: 'center',
    width: width - 20,
    marginLeft: 10,
    backgroundColor: '#fff',
  },
  rightText: {
    color: '#777777',
    fontSize: 14,
  },
  flatListLine: {
    height: 1,
    backgroundColor: CommonStyles.globalBgColor,
  },
  listView: {
    width,
    backgroundColor: CommonStyles.globalBgColor,
  },


});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
    longLists: state.shop.longLists || {},
  }),
  dispatch => ({
    fetchList: (params = {}) => dispatch({ type: 'shop/getList', payload: params }),
  }),
)(SaleUseDetailsScreen);
