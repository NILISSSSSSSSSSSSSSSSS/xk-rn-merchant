import React, { Component } from 'react';
import {
  Text, View, StyleSheet, Dimensions, Image, ScrollView, TouchableOpacity, StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../../components/Header';
import TextInputView from '../../../components/TextInputView';
import FlatListView from '../../../components/FlatListView';
import CommonStyles from '../../../common/Styles';
import { ListItem } from '../../../components/List';
import ModalDemo from '../../../components/Model';

const searchgray = require('../../../images/mall/search_gray.png');

const { width, height } = Dimensions.get('window');

class RiderSearchScreen extends Component {
  constructor(props) {
    super(props);
    this.state = {
      riderName: '',
      searchName: '',
      pickConfirmVisible: false,
      pickedRider: {},
    };
  }

  componentDidMount() {
    this.searchData();
  }

  pickRider = (item) => {
    this.setState({
      pickedRider: item,
      pickConfirmVisible: true,
    });
  }

  changeSearchWord = (text) => {
    this.setState({
      riderName: text,
    });
  }

  searchData = () => {
    const { searchRiderList } = this.props;
    const { riderName } = this.state;
    this.setState({
      searchName: riderName,
    });
    searchRiderList(riderName);
  }

  renderExtra(currentPickRider) {
    return (
      <Text>
        { currentPickRider.distance != undefined ? (
          <Text style={styles.c2f12}>
            {'距离你 '}
            <Text style={styles.cbf12}>
              {`${currentPickRider.distance || 0}m`}
            </Text>
          </Text>
        ) : null }
        <Text style={styles.c2f12}>
          {'当前接单量 '}
          <Text style={styles.cbf12}>{currentPickRider.orderNum || 0}</Text>
        </Text>
      </Text>
    );
  }

  renderTitle = item => (
    <View style={[CommonStyles.flex_start, { height: 16, marginBottom: 10 }]}>
      <Text style={{
        color: '#222222',
        fontSize: 14,
        fontWeight: 'bold',
      }}
      >
        {item.realName}

      </Text>
      <Image
        source={require('../../../images/logistics/auth.png')}
        style={{
          marginLeft: 8, marginRight: 6, width: 16, height: 16,
        }}
      />
      <Image source={require('../../../images/logistics/health.png')} style={{ width: 16, height: 16 }} />
    </View>
  )

  renderItem = (item, index) => (
    <ListItem
        style={{
          backgroundColor: '#fff',
          marginHorizontal: 10,
          paddingHorizontal: 15,
          borderRadius: 8,
        }}
        title={this.renderTitle(item)}
        icon={item.avatar ? { uri: item.avatar } : require('../../../images/order/head_portrait.png')}
        iconStyle={{ width: 50, height: 50 }}
        subtitle={item.phone}
        subtitleStyle={{
          color: '#999',
          fontSize: 12,
        }}
        extra={this.renderExtra(item)}
        onPress={() => this.pickRider(item)}
    />
  )

  render() {
    const { riderName, pickConfirmVisible, pickedRider } = this.state;
    const { searchList, searchRiderList, navigation } = this.props;
    const { pagination = {}, list = [] } = searchList || {};

    return (
      <View style={styles.container}>
        <StatusBar barStyle="dark-content" />
        <Header
            navigation={navigation}
            headerStyle={styles.headerView}
            leftView={
              <View style={{ width: 0 }} />
            }
            centerView={(
              <TextInputView
                    inputView={[styles.headerItem, styles.headerCenterView]}
                    inputRef={(e) => { this.searchTextInput = e; }}
                    style={styles.headerTextInput}
                    autoFocus
                    returnKeyType="search"
                    returnKeyLabel="搜索"
                    placeholder="搜索已绑定骑手姓名"
                    placeholderTextColor="#999"
                    value={riderName}
                    onChangeText={this.changeSearchWord}
                    onSubmitEditing={this.searchData}
                    leftIcon={(
                      <TouchableOpacity
                            onPress={this.searchData}
                            style={[styles.headerTextInput_icon, styles.headerTextInput_search]}
                      >
                        <Image source={searchgray} />
                      </TouchableOpacity>
                    )}
                    rightIcon={
                        riderName === ''
                          ? null
                          : (
                            <TouchableOpacity
                                style={[styles.headerTextInput_icon, styles.headerTextInput_close]}
                                onPress={() => {
                                  this.clearTextInput();
                                }}
                            >
                              <Image source={require('../../../images/mall/close_gray.png')} style={styles.headerTextInput_close_img} />
                            </TouchableOpacity>
                          )
                    }
              />
)}
            rightView={(
              <TouchableOpacity
                    style={[styles.headerItem, styles.headerRightView]}
                    onPress={() => {
                      navigation.goBack();
                    }}
              >
                <Text style={styles.header_search_text}>取消</Text>
              </TouchableOpacity>
)}
        />
        <View style={{ flex: 1 }}>
          <FlatListView
                    type="Riders_Not_Find"
                    style={{
                      backgroundColor: '#EEEEEE',
                      marginBottom: 10,
                      flex: 1,
                      width,
                    }}
                    renderItem={({ item }) => this.renderItem(item)}
                    store={pagination}
                    data={pagination.isFirstLoad ? [] : list}
                    numColumns={1}
                    refreshData={() => searchRiderList(this.state.searchName, 1)}
                    loadMoreData={() => searchRiderList(this.state.searchName, pagination.page + 1)}
          />
        </View>
        {/* 确认指派骑手 */}
        <ModalDemo
                noTitle
                leftBtnText="取消"
                rightBtnText="确定"
                visible={pickConfirmVisible}
                title={`确定指派给骑手${pickedRider.realName}？`}
                type="confirm"
                onClose={() => {
                  this.setState({ pickConfirmVisible: false });
                }}
                onConfirm={() => {
                  const { pageFrom } = navigation.state.params || {};
                  if (pageFrom === 'ChooseRider') {
                    this.props.backToLogistics();
                  } else {
                    navigation.goBack();
                  }
                  this.props.chooseRider(pickedRider);
                  this.setState({ pickConfirmVisible: false });
                }}
        />
      </View>
    );
  }
}

export default connect(state => ({
  searchList: state.order.searchRiderList || {},
}), {
  searchRiderList: (riderName = '', page = 1, limit = 10) => ({ type: 'order/searchRiderList', payload: { page, limit, riderName } }),
  backToLogistics: () => ({ type: 'system/popPage', payload: { n: 2 } }),
  chooseRider: pickedRider => ({ type: 'order/changeLogistics', payload: { pickedRider } }),
})(RiderSearchScreen);


const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  serchView: {
    backgroundColor: CommonStyles.globalHeaderColor,
    width,
    height: 48 + CommonStyles.headerPadding,
    flexDirection: 'row',
    paddingTop: CommonStyles.headerPadding,
    alignItems: 'center',
  },
  headerTextInput_close: {
    right: 0,
  },
  headerTextInput_close_img: {
    width: 18,
    height: 18,
  },
  headerTextInput: {
    flex: 1,
    height: '100%',
    paddingHorizontal: 40,
    paddingVertical: 0,
    borderRadius: 15,
    fontSize: 14,
    backgroundColor: '#EEE',
  },
  headerCenterView: {
    position: 'relative',
    flex: 1,
    height: 30,
    marginLeft: 10,
    zIndex: 1,
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  headerTextInput_search: {
    left: 0,
  },
  headerRightView: {
    paddingLeft: 12,
    paddingRight: 23,
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
  headerView: {
    backgroundColor: '#fff',
  },
  c2f12: {
    color: '#222',
    fontSize: 12,
  },
  cbf12: {
    color: '#4A90FA',
    fontSize: 12,
  },
  cff14: {
    color: '#FFFFFF',
    fontSize: 14,
  },
  tabItemview: {
    height: 38,
    marginRight: 25,
    alignItems: 'center',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
  },
  tabTouchItem: {
    height: 36,
    justifyContent: 'center',
    alignItems: 'center',
  },
  chooseItem: {
    width: 45,
    height: 8,
    marginBottom: 0,
    backgroundColor: '#fff',
    borderRadius: 10,
    position: 'absolute',
    bottom: -5,
  },
});
