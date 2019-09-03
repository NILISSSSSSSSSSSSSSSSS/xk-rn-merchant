/**
 * 席位管理
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  TouchableOpacity,
  Platform,
  Modal,
} from 'react-native';
import Toast from '../../components/Toast';
import { connect } from 'rn-dva';
import Content from '../../components/ContentItem';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import Model from '../../components/Model';
import TextInputView from '../../components/TextInputView';

const { width, height } = Dimensions.get('window');

class SeatScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    }

    constructor(props) {
      super(props);
      this.state = {
        listName: 'seat',
        lists: [], // 列表
        modelVisible: false, // 显示删除modal
        visible: false, // 显示分类或店铺选择modal
        typeName: '',
        firstLoad: true,
        deleteId: '', // 要删除的项的id
        currentShop: this.props.userShop,
      };
    }

    componentDidMount() {
      this.getList(true, false);
    }

    getList = (isFirst = false, isLoadingMore = false) => {
      this.props.fetchList({
        witchList: this.state.listName,
        isFirst,
        isLoadingMore,
        paramsPrivate: {
          shopId: this.state.currentShop.id,
        },
        api: requestApi.mSeatStatistics,
      });
    }

    componentWillUnmount() {
      RightTopModal.hide();
    }

    renderItem = ({ item, index }) => {
      const { listName } = this.state;
      const { longLists } = this.props;
      const length = longLists[listName] && longLists[listName].lists && longLists[listName].lists.length || 0;
      return (
        <Content
style={[styles.content, { marginBottom: index == length - 1 ? 5 : 0 }]}
key={index}
                onPress={() => this.props.navigation.navigate('SeatRooms', {
                  seatTypeId: item.seatTypeId,
                  title: item.seatTypeName,
                  callback: () => this.getList(true, false),
                })}
        >
          <Image
                    source={require('../../images/xiwei/canzhuo.png')}
                    style={styles.icon}
          />
          <View style={styles.itemRight}>
            <View style={[styles.line, { borderColor: '#F1F1F1', borderBottomWidth: 1 }]}>
              <Text style={{ fontSize: 14, color: '#222222' }}>{item.seatTypeName}</Text>
            </View>
            <View style={styles.line}>
              <Text style={{ fontSize: 12, color: '#222222' }}>
席位数量：
                <Text style={{ color: '#EE6161' }}>{item.count}</Text>
              </Text>
              <TouchableOpacity style={styles.deleteView} onPress={() => this.setState({ modelVisible: true, deleteId: item.seatTypeId })}>
                <Image
                                source={require('../../images/xiwei/delete.png')}
                                style={{ width: 15, height: 16 }}
                />
              </TouchableOpacity>

            </View>
          </View>

        </Content>
      );
    }

    delete = () => {
      Loading.show();
      const param = {
        shopId: this.props.userShop.id,
        id: this.state.deleteId,
      };
      requestApi.mSeatTypeDelete(param).then((data) => {
        this.setState({
          modelVisible: false,
          deleteId: '',
        });
        Toast.show('删除成功');
        this.getList(true, false);
      }).catch((error) => {
        Loading.hide();
      });
    }

    addType = () => {
      if (!this.state.typeName) {
        this.toast.show('请填写分类名')
        return;
      }
      Loading.show();
      const param = {
        shopId: this.props.userShop.id,
        name: this.state.typeName,
      };
      requestApi.mSeatTypeCreate(param).then((data) => {
        this.setState({
          typeName: '',
          visible: false,
        });
        Toast.show('新增成功');
        this.getList(true, false);
      }).catch((error) => {
        Loading.hide();
      });
    }

    showPopover() {
      let options = [];
      options = [...this.props.juniorShops];
      options.map((item) => {
        item.title = item.name;
        item.onPress = () => {
          this.setState({ visible: false, currentShop: item }, () => {
            this.getList(true, false);
          });
        };
      });
      RightTopModal.show({
        options,
        children: <View style={{ position: 'absolute', top: Platform.OS == 'ios' ? 0 : -CommonStyles.headerPadding }}>{this.renderHeader()}</View>,
        sanjiaoStyle: { right: 50 },
      });
    }

    renderHeader=() => {
      const { navigation } = this.props;
      return (
        <Header
                    navigation={navigation}
                    goBack
                    centerView={(
                      <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#fff' }}>席位管理</Text>
                        <TouchableOpacity
                                onPress={() => this.showPopover()}
                                style={{
                                  width: 50, alignItems: 'flex-end', position: 'absolute', right: 0, top: 0,
                                }}
                        >
                          <Text style={{ fontSize: 17, color: '#fff' }}>筛选</Text>
                        </TouchableOpacity>
                      </View>
)}
                    rightView={(
                      <TouchableOpacity
                            onPress={() => this.setState({ visible: true })}
                            style={{ width: 50, alignItems: 'center' }}
                      >
                        <Image source={require('../../images/caiwu/add.png')} />
                      </TouchableOpacity>
)}
        />
      );
    }

    render() {
      const { navigation, longLists } = this.props;
      const { visible, listName } = this.state;
      return (
        <View style={styles.container}>
          {this.renderHeader()}
          <FlatListView
                    type="K14_seatManage"
                    style={[{ backgroundColor: CommonStyles.globalBgColor, width }]}
                    renderItem={data => this.renderItem(data)
                    }
                    store={{
                      ...longLists[listName],
                      page: longLists[listName] && longLists[listName].listsPage || 1,
                    }}
                    data={longLists[listName] && longLists[listName].lists || []}
                    numColumns={1}
                    refreshData={() => this.getList(false, false)}
                    loadMoreData={() => this.getList(false, true)}
          />
          <Modal
                    animationType="fade"
                    transparent
                    visible={visible}
                    onRequestClose={() => { }}
          >
            <View style={[styles.containerModal, { backgroundColor: 'rgba(0, 0, 0, 0.5)' }]}>
              <View style={[styles.innerContainer, { backgroundColor: '#EFEFEF', paddingTop: 20 }]}>
                <Text style={styles.title}>新建分类</Text>
                <View style={{ height: 24, marginTop: 20 }}>
                  <TextInputView
                    placeholder="输入分类名"
                    placeholderTextColor="#ccc"
                    style={styles.modalInput}
                    value={this.state.typeName}
                    maxLength={10}
                    onChangeText={data => this.setState({ typeName: data })}
                    returnKeyType="done"
                  />
                </View>
                <View style={styles.row}>
                  <TouchableOpacity style={styles.btn}>
                    <Text onPress={() => this.setState({ visible: false, typeName: '' })} style={styles.btn_text}>取消</Text>
                  </TouchableOpacity>
                  <TouchableOpacity style={[styles.btn, { borderColor: '#DDD', borderLeftWidth: 1 }]}>
                    <Text onPress={() => this.addType()} style={styles.btn_text}>确定</Text>
                  </TouchableOpacity>
                </View>
                <Toast
                ref={(e) => {
                this.toast = e;
                }}
                position="top"
                positionValue={50}
            />
              </View>
            </View>
          </Modal>
          <Model
                    type="confirm"
                    title="确定要删除分类？"
                    confirmText="提示"
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    modalToast={this.state.modalToast}
                    onConfirm={() => this.delete()}
                    onClose={() => this.setState({ modelVisible: false })}
          />
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    flexDirection: 'column',
    alignItems: 'center',
    backgroundColor: CommonStyles.globalBgColor,
  },
  modal: {
    width,
    height: height - 44 - CommonStyles.headerPadding,
    marginTop: 44 + CommonStyles.headerPadding,
    alignItems: 'flex-end',
    backgroundColor: 'rgba(0,0,0,0.5)',
    position: 'absolute',
    top: 0,
    left: 0,
  },
  header: {
    width,
    height: 44 + CommonStyles.headerPadding,
    paddingTop: CommonStyles.headerPadding,
    overflow: 'hidden',
  },
  headerView: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width,
    height: 44 + CommonStyles.headerPadding,
    paddingTop: CommonStyles.headerPadding,
    backgroundColor: CommonStyles.globalHeaderColor,
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  left: {
    width: 120,

  },
  center: {
    flex: 1,
  },
  titleText: {
    fontSize: 17,
    color: '#fff',
  },
  icon: {
    width: 19,
    height: 19,
    marginRight: 19,
    marginTop: 10,
  },
  content: {
    paddingHorizontal: 20,
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: width - 20,
    marginLeft: 10,
    marginTop: 0,
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: 40,
  },
  itemRight: {
    flex: 1,

  },
  scaleTextView: {
    borderWidth: 1,
    borderColor: '#4A90FA',
    borderRadius: 16,
    justifyContent: 'center',
    height: 20,
  },
  scaleText: {
    fontSize: 12,
    color: '#4A90FA',
    paddingHorizontal: 10,

  },
  containerModal: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 40,
  },
  innerContainer: {
    borderRadius: 10,
    alignItems: 'center',
    // position:'relative'
  },
  title: {
    color: '#030303',
    fontSize: 17,
  },
  modalInput: {
    width: width - 105 - 33,
    borderWidth: 1,
    borderColor: '#DDD',
    backgroundColor: 'white',
    paddingLeft: 5,

  },
  row: {
    alignItems: 'center',
    width: '100%',
    flexDirection: 'row',
    marginTop: 20,
    borderColor: '#DDD',
    borderTopWidth: 1,
  },
  btn: {
    width: '50%',
    height: '100%',
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
    lineHeight: 50,
  },
  deleteView: {
    width: 30,
    height: 30,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalView: {
    width: 168,
    // borderWidth: 1,
    borderColor: '#DDDDDD',
    borderBottomLeftRadius: 10,
    marginLeft: 25,
    // overflow: 'hidden',
    position: 'relative',
    backgroundColor: 'white',
    maxHeight: 250,
    overflow: 'hidden',
  },
  line2: {
    paddingHorizontal: 15,
    borderBottomWidth: 1,
    borderColor: '#F1F1F1',
  },

});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
    longLists: state.shop.longLists || {},
    juniorShops: state.shop.juniorShops || [state.user.userShop || {}],
  }),
  dispatch => ({
    fetchList: (params = {}) => dispatch({ type: 'shop/getList', payload: params }),
    shopSave: (params = {}) => dispatch({ type: 'shop/save', payload: params }),
  }),
)(SeatScreen);
