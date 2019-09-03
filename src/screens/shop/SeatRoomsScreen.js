
/**
 * 席位管理/席位类型下的包间
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
  TouchableHighlight,
} from 'react-native';
import { connect } from 'rn-dva';
import ListView from 'deprecated-react-native-listview';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as utils from '../../config/utils';
import Model from '../../components/Model';
import SwipeListView from '../../components/SwipeListView';

const { width, height } = Dimensions.get('window');

class SeatRoomsScreen extends PureComponent {
    static navigationOptions = {
      header: null,
    }

    constructor(props) {
      super(props);
      this.ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
      this.state = {
        lists: [], // 列表
        modelVisible: false, // 显示删除modal
        visibleType: false, // 显示分类modal
        typeName: '',
        firstLoad: true,
        seatTypeId: this.props.navigation.state.params.seatTypeId,
        title: this.props.navigation.state.params.title,
        deleteId: '',
        rowMap: {},
        rowKey: '',
      };
    }

    componentDidMount() {
      this.getList();
    }

    getList = (message) => {
      message ? Toast.show(message) : Loading.show();
      const params = {
        shopId: this.props.userShop.id,
        seatTypeId: this.state.seatTypeId,
      };
      requestApi.mSeatList(params).then((data) => {
        const lists = data ? data : this.state.lists;
        lists.sort(utils.compareNumber('updatedAt'));// 按操作时间倒叙排列
        this.setState({
          lists,
          firstLoad: false,
        });
        Loading.hide();
      }).catch((error) => {
        Loading.hide();
        this.setState({
          firstLoad: false,
        });
      });
    }

    deleteSeat = (id) => {
      Loading.show();
      requestApi.mSeatDelete({ id }).then((data) => {
        this.setState({ modelVisible: false });
        this.closeRow();
        this.getList('删除成功');
      }).catch((error) => {
        Loading.hide();
      });
    }

    componentWillUnmount() {
      this.props.navigation.state.params.callback();
    }

    renderItem = (item, viewStyle, index) => (
      <TouchableHighlight
                underlayColor="#f1f1f1"
                activeOpacity={0.5}
                disabled={item.images ? false:true}
                onPress={() => {
                  this.closeRow();
                  this.props.navigation.navigate('SeatImages', {
                    data: item,
                    callback: (images) => {
                      const newLists = [...this.state.lists];
                      newLists[index].images = images;
                      this.setState({
                        lists: newLists,
                      });
                    },
                  });
                }}
                style={[styles.line, {
 width: width - 20, borderBottomWidth: index == this.state.lists.length - 1 ? 0 : 1, borderColor: '#F1F1F1', paddingHorizontal: 15 
}, viewStyle]}
            >
              <Text style={{ fontSize: 12, color: '#222222' }}>
{item.name} 
{' '}
<Text style={{ color: '#ccc' }}>{item.images ? '(有图)' : ''}</Text>
</Text>
            </TouchableHighlight>

    )

    closeRow() {
      const { rowMap, rowKey } = this.state;
      if (rowMap && rowMap[rowKey]) {
        rowMap[rowKey].closeRow();
      }
    }

    onRowDidOpen = (rowKey, rowMap) => {
      console.log('This row opened', rowKey);
      this.setState({ rowMap, rowKey });
    }

    render() {
      const { navigation } = this.props;
      const viewStyle = index => ({
        borderTopLeftRadius: index == 0 ? 8 : 0,
        borderTopRightRadius: index == 0 ? 8 : 0,
        borderBottomLeftRadius: index == this.state.lists.length - 1 ? 8 : 0,
        borderBottomRightRadius: index == this.state.lists.length - 1 ? 8 : 0,
        overflow: 'hidden',
      });
      return (
        <View style={styles.container}>
            <Header
                    navigation={navigation}
                    goBack
                    title={this.state.title}
                    rightView={(
                      <TouchableOpacity
                            onPress={() => {
                              this.closeRow();
                              navigation.navigate('SeatAdd', {
                                callback: () => this.getList('新增成功'),
                                seatTypeId: this.state.seatTypeId,
                              });
                            }}
                            style={{ width: 50 }}
>
  <Text style={{ fontSize: 17, color: '#fff' }}>新增</Text>
</TouchableOpacity>
)}
              />
            {/* <View style={styles.content}> */}
            <SwipeListView
                        isFirstLoad={this.state.firstLoad}
                        data={this.state.lists}
                        dataSource={this.ds.cloneWithRows(this.state.lists)}
                        renderRow={(data, rowId, index) => this.renderItem(data, viewStyle(index), index)
                        }
                        contentContainerStyle={{ paddingTop: 10, paddingBottom: 10 + CommonStyles.footerPadding }}
                        enableEmptySections={() => <View />}
                        renderHiddenRow={(data, secId, rowId, rowMap) => (
                          <View style={styles.rightContainer}>
                                  <TouchableOpacity
                                        style={[styles.delTextContainer, viewStyle(parseInt(rowId)), { borderTopLeftRadius: 0, borderBottomLeftRadius: 0 }]}
                                        onPress={() => this.setState({ modelVisible: true, deleteId: data.id })}
                                    >
                                      <Text style={styles.deleteTextStyle}>删除</Text>
                                    </TouchableOpacity>
                                </View>
                        )}
                        leftOpenValue={0}
                        rightOpenValue={-60}
                        onRowDidOpen={this.onRowDidOpen}
              />
            {/* {this.state.lists.map((item, index) => {
                        return this.renderItem({ item, index })
                    })} */}
            {/* </View> */}

            <Model
                    type="confirm"
                    title="确定删除席位？"
                    confirmText="提示"
                    visible={this.state.modelVisible}
                    onShow={() => this.setState({ modelVisible: true })}
                    onConfirm={() => this.deleteSeat(this.state.deleteId)}
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
  rightContainer: {
    flexDirection: 'row',
    backgroundColor: CommonStyles.globalBgColor,
    alignItems: 'center',
    justifyContent: 'flex-end',
    flex: 1,
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
    borderRadius: 10,
    marginTop: 10,
    overflow: 'hidden',
    flex: 1,
    marginBottom: CommonStyles.footerPadding + 10,
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    height: 40,
    backgroundColor: '#fff',
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
    padding: 40,
  },
  innerContainer: {
    borderRadius: 10,
    alignItems: 'center',
    height: 150,

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
    // lineHeight: 40
  },
  delTextContainer: {
    width: 60,
    height: 40,
    backgroundColor: '#EE6161',
    alignItems: 'center',
    justifyContent: 'center',
  },
  deleteTextStyle: {
    color: '#fff',
    fontSize: 14,
    textAlign: 'center',
  },

});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
  }),
)(SeatRoomsScreen);
