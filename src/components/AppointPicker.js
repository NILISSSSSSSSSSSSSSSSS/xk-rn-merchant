
import React, { PureComponent, Component } from 'react';
import {
  Image, Modal, StyleSheet, View, Dimensions, TouchableOpacity, Text,
} from 'react-native';
import { connect } from 'rn-dva';

import ScrollableTabView from 'react-native-scrollable-tab-view';
import DefaultTabBar from './CustomTabBar/DefaultTabBar';
import FlatListView from './FlatListView';
import CommonStyles from '../common/Styles';
import ListEmptyCom from './ListEmptyCom';

const tabData = ['委派给联盟商', '委派给分号'];
const defaultImg = require('../images/default/default_355_213.png');

const { width, height } = Dimensions.get('window');

class AppointPicker extends Component {
    static defaultProps = {
      visible: false,
      getAppointArr: () => {}, // 获取选择的人
      taskId: '', // 如果是预委派，只能选择分店，此参数可不传，如果是单个任务委派，需要传入id，获取联盟商和员工列表
      type: '', // task，任务预委派，check验收预委派，audit审核预委派
    }

    state = {
      selectArr: [],
      isSelectedAll: false,
      tabIndex: 0,
    }

    componentDidMount() {
    }

    refresh = (page = 1) => {
      const { taskId, type } = this.props;
      // 预委派
      if (taskId !== '') {
        const params = {
          jobId: taskId,
          page,
          limit: 10,
        };
        this.props.fetchMerchantDelegate(params);
        this.props.fetchEmployeeDelegate({ page, limit: 10 });
        console.log('tabIndexrefresh', this.state.tabIndex);
        return;
      }
      this.props.fetchStaffList({ type, params: { page, limit: 20 }});
    }

    changeState = (key, value) => {
      this.setState({
        [key]: value,
      });
    }

    _renderFlatListView = () => {
      const { taskId, singleAppontAccountList:singleStaffList,singleMerchantList:singleMerchant} = this.props;
      const { tabIndex } = this.state;
      const staffList = this.getStaffData();

      if (taskId !== '') {
        const _merchantList = singleMerchant.id ? [singleMerchant] : [];
        console.log('singleMerchantsingleMerchant', tabIndex === 0 ? _merchantList : singleStaffList.data);
        console.log('tabIndex', this.state.tabIndex);
        return (
          <ScrollableTabView
                    initialPage={0}
                    onChangeTab={({ i }) => {
                      // 只能单选，清空选择的数据,还原之前选择的数据状态
                      this.handleResetList();
                      this.setState({
                        tabIndex: i,
                        selectArr: [],
                      });
                    }}
                    renderTabBar={() => (
                      <DefaultTabBar
                            underlineStyle={{
                              backgroundColor: '#fff',
                              height: 0,
                              borderRadius: 10,
                              marginBottom: -5,
                              width: '10%',
                              marginLeft: '8%',
                            }}
                            tabStyle={{
                              backgroundColor: '#fff',
                              height: 30,
                              paddingBottom: -4,
                            }}
                            activeTextStyle={{ fontSize: 14, color: '#999' }}
                            inActiveTextStyle={{ fontSize: 16, color: '#222' }}
                            style={{
                              backgroundColor: '#fff',
                              paddingTop: 15,
                              // height: 30,
                              borderBottomWidth: 0,
                              overflow: 'hidden',
                            }}
                      />
                    )}
          >
            {
                    tabData.map((itemTab, i) => (
                      <FlatListView
                                style={{
                                  backgroundColor: '#fff',
                                }}
                                // store={}
                                tabLabel={itemTab}
                                key={itemTab}
                                data={tabIndex === 0 ? _merchantList : singleStaffList.data}
                                ListHeaderComponent={() => null}
                                ListEmptyComponent={tabIndex === 0 ? <ListEmptyCom /> : <ListEmptyCom type="AddPointModal" />}
                                ItemSeparatorComponent={() => null}
                                ListFooterComponent={() => null}
                                renderItem={this._renderStaffItem}
                                refreshData={() => {
                                  this.refresh(1);
                                }}
                                loadMoreData={() => {
                                  this.refresh(1);
                                }}
                      />
                    ))
                }
          </ScrollableTabView>
        );
      }
      return (
        <FlatListView
                style={{
                  backgroundColor: '#fff',
                }}
                ListEmptyComponent={<ListEmptyCom type="AddPointModal" />}
                store={staffList}
                data={this.handleFliterData()}
                ListHeaderComponent={() => null}
                ItemSeparatorComponent={() => null}
                ListFooterComponent={() => null}
                renderItem={this._renderStaffItem}
                refreshData={() => {
                  this.refresh(1);
                }}
                loadMoreData={() => {
                  this.refresh(staffList.page + 1);
                }}
        />
      );
    }

    _renderStaffItem = ({ item, index }) => {
      const topBorderRadius = index === 0 ? styles.topBorderRadius : null;
      const { tabIndex } = this.state;
      const { taskId } = this.props;
      return (
        <TouchableOpacity
            activeOpacity={0.65}
            key={index}
            onPress={() => {
              if (taskId === '') { // 预委派选择
                this.handleSelect(item, index);
                return;
              }
              // 单个委派选择
              this.handleSingleSelect(item, index);
            }}
            style={[CommonStyles.flex_between, topBorderRadius, styles.staffItemWrap]}
        >
          <View style={[CommonStyles.flex_start]}>
            <Image source={item.avatar ? { uri: item.avatar } : defaultImg} style={{ height: 50, width: 50, borderRadius: 25 }} />
            <View style={styles.staffTextInfo}>
              <Text style={{ fontSize: 14, color: '#222' }}>{tabIndex === 0 && taskId !== '' ? item.realName || item.nickname : item.realName || item.nickname}</Text>
              <Text style={{ fontSize: 12, color: '#999', paddingTop: 5 }}>{item.phone}</Text>
            </View>
          </View>
          {
                item.isSelected
                  ? <Image source={require('../images/mall/checked.png')} />
                  : <Image source={require('../images/mall/unchecked.png')} />
            }
        </TouchableOpacity>
      );
    }

    _renderBottomBtn = () => {
      const { taskId, getAppointArr, singleAppontAccountList:singleStaffList ,singleMerchantList:singleMerchant} = this.props;
      const { selectArr = [], isSelectedAll, tabIndex } = this.state;
      const activeStyle = selectArr.length > 0 ? styles.multipleBtn_active : styles.multipleBtn_unActive;
      const touchOpacity = selectArr.length > 0 ? 0.65 : 1;
      // 如果是单个任务委派
      if (taskId !== '') {
        const _merchantList = singleMerchant.id ? [singleMerchant] : [];
        const EmptyData = tabIndex === 0 ? _merchantList : singleStaffList.data;
        console.log('EmptyData////', EmptyData, singleStaffList);
        if (EmptyData.length === 0) return null;
        return (
          <TouchableOpacity
                activeOpacity={touchOpacity}
                style={[styles.multipleBtnWrap]}
                onPress={() => {
                  if (selectArr.length === 0) return;
                  this.handleCloseModal();
                }}
          >
            <View style={[CommonStyles.flex_1, activeStyle, CommonStyles.flex_center]}>
              <Text style={styles.multipleBtnText}>确定</Text>
            </View>
          </TouchableOpacity>
        );
      }
      const staffList = this.handleFliterData();
      if (staffList.length !== 0) {
        // 如果是预委派
        return (
          <View style={[styles.selectAllWrap, CommonStyles.flex_between]}>
            <TouchableOpacity
                    onPress={() => {
                      this.handleSelectAll();
                    }}
                    style={[CommonStyles.flex_start, styles.selectAllBtn]}
            >
              {
                        isSelectedAll
                          ? <Image source={require('../images/mall/checked.png')} />
                          : <Image source={require('../images/mall/unchecked.png')} />
                    }
              <Text style={{ fontSize: 14, color: '#222', marginLeft: 6 }}>全选</Text>
            </TouchableOpacity>
            <TouchableOpacity
                        onPress={() => {
                          if (selectArr.length === 0) return;
                          this.handleCloseModal();
                        }}
                        activeOpacity={touchOpacity}
                        style={[styles.selectComplete, CommonStyles.flex_center, activeStyle]}
            >
              <Text style={{ fontSize: 17, color: '#fff', letterSpacing: 2 }}>完成</Text>
            </TouchableOpacity>
          </View>
        );
      }
      return null;
    }

    // 预委派过滤列表中存在的员工
    handleFliterData = () => {
      const allListData = JSON.parse(JSON.stringify(this.getStaffData())); // 获取的所有员工列表
      const nowStaffList = this.getListData(); // 列表中存在的员工列表
      if (nowStaffList.data.length === 0) return allListData.data;
      const temp = nowStaffList.data.map(item => item.id);
      const temp1 = [];
      allListData.data.forEach((item) => {
        if (!temp.includes(item.id)) {
          temp1.push(item);
        }
      });
      return temp1;
    }

    // 选择任务 || 验收 || 审核 的员工
    handleSelect = (item, index) => {
      const { appointList } = this.props;
      const { selectArr } = this.state;
      const _index = this.getListIndex();
      const _data = JSON.parse(JSON.stringify(appointList)); // 所有list获取
      _data[_index].data[index].isSelected = !_data[_index].data[index].isSelected;
      if (_data[_index].data[index].isSelected) {
        selectArr.push(_data[_index].data[index]);
      } else {
        let spliceIndex;
        selectArr.forEach((_item, i) => {
          if (_item.id === _data[_index].data[index].id) {
            spliceIndex = i;
          }
        });
        if (spliceIndex !== undefined) {
          selectArr.splice(spliceIndex, 1);
        }
      }
      console.log('selectArr', selectArr);
      this.props.updateStaffList({ appointList: _data });
      this.setState({
        selectArr,
        isSelectedAll: selectArr.length === _data[_index].data.length,
      });
    }

    // 全部选择
    handleSelectAll = () => {
      const { appointList } = this.props;
      let { selectArr, isSelectedAll } = this.state;
      const nowList = this.getStaffData();
      if (nowList.data.length === 0) return;
      if (!isSelectedAll) {
        selectArr = nowList.data;
      } else {
        selectArr = [];
      }
      nowList.data.forEach((item) => {
        item.isSelected = !isSelectedAll;
      });
      const _data = JSON.parse(JSON.stringify(appointList)); // 所有list获取
      _data[this.getListIndex()] = nowList;
      this.props.updateStaffList({ appointList: _data });
      this.setState({
        isSelectedAll: !isSelectedAll,
        selectArr,
      });
    }

    // 单个委派选择
    handleSingleSelect = (item, index) => {
      let { tabIndex, selectArr } = this.state;
      const { singleMerchantList ,singleAppontAccountList} = this.props;
      if (tabIndex === 0) { // 单个委派选择联盟商的时候
        let merchantData = singleMerchantList || {};
        merchantData.isSelected = !merchantData.isSelected;
        if (merchantData.isSelected) { // 单个委派只有一个下级联盟商
          selectArr.push(merchantData);
        } else {
          selectArr = [];
        }
        this.props.updateSingleAppointList({
          singleMerchantList: {
            ...singleMerchantList,
            data: merchantData,
          },
        });
      } else {
        selectArr = [];
        const singleStaffList = singleAppontAccountList.data;
        singleStaffList.forEach((listItem) => { // 只能单选
          if (item.id === listItem.id) {
            listItem.isSelected = true;
            selectArr.push(item);
          } else {
            listItem.isSelected = false;
          }
        });
        console.log('data', selectArr);
        this.props.updateSingleAppointList({
          singleAppontAccountList: {
            ...singleAppontAccountList,
            data: singleStaffList,
          },
        });
      }
      this.setState({
        selectArr,
      });
    }

    // 单个委派切换tab，还原选择状态
    handleResetList = () => {
      const { tabIndex } = this.state;
      const { singleMerchantList,singleAppontAccountList } = this.props;
      if (tabIndex === 0) {
        const merchantData = singleMerchantList;
        merchantData.isSelected = false;
        this.props.updateSingleAppointList({
          singleMerchantList: {
            ...singleMerchantList,
            data: merchantData,
          },
        });
      } else {
        const singleStaffList = singleAppontAccountList.data;
        singleStaffList.forEach((item) => {
          item.isSelected = false;
        });
        this.props.updateSingleAppointList({
          singleAppontAccountList: {
            ...singleAppontAccountList,
            data: singleStaffList,
          },
        });
      }
    }

    // 获取当前数据索引
    getListIndex = () => {
      const { type } = this.props;
      let _index = 0; // 当前list索引
      switch (type) {
        case 'task': _index = 0; break;
        case 'check': _index = 1; break;
        case 'audit': _index = 2; break;
        default: _index = 0; break;
      }
      return _index;
    }

    // 获取当前预委派类型列表数据
    getListData = () => {
      const { navigation, appointedList,type } = this.props;
      let dataSource = [];
      switch (type) {
        case 'task': dataSource = appointedList[0]; break;
        case 'check': dataSource = appointedList[1]; break;
        case 'audit': dataSource = appointedList[2]; break;
        default: dataSource = appointedList[0]; break;
      }
      return dataSource;
    }

    // 获取当前任务类型的员工
    getStaffData = () => {
      const { appointList, type } = this.props;
      let staffList = [];
      switch (type) {
        case 'task': staffList = appointList[0]; break;
        case 'check': staffList = appointList[1]; break;
        case 'audit': staffList = appointList[2]; break;
        default: staffList = appointList[0]; break;
      }
      return staffList;
    }

    // 关闭modal
    handleCloseModal = () => {
      const { onClose, getAppointArr, taskId } = this.props;
      const { tabIndex } = this.state;
      if (taskId === '') {
        getAppointArr(this.state.selectArr);
      } else {
        getAppointArr((tabIndex === 0) ? [{ type: 'merchant', data: this.state.selectArr }] : [{ type: 'staff', data: this.state.selectArr }]);
      }
      this.setState({
        selectArr: [],
        isSelectedAll: false,
        tabIndex: 0,
      }, () => {
        onClose();
        this.refresh();
      });
    }

    render() {
      const { visible, onClose } = this.props;
      return (
        <Modal
           animationType="slide"
           transparent
           visible={visible}
           onRequestClose={() => {
             this.setState({ selectArr: [], isSelectedAll: false, tabIndex: 0 }, () => {
               onClose(); this.refresh();
             });
           }}
           onShow={() => { this.refresh(); }}
        >
          <View style={styles.modalContainer}>
            <TouchableOpacity
                activeOpacity={0.9}
                style={{ height, width }}
                onPress={() => {
                  this.setState({ selectArr: [], isSelectedAll: false, tabIndex: 0 }, () => {
                    onClose(); this.refresh();
                  });
                }}
            />
            <View style={[styles.selectWrap]}>
              {
                this._renderFlatListView()
              }
            </View>
            {
              this._renderBottomBtn()
            }
          </View>
        </Modal>
      );
    }
}
const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    backgroundColor: 'rgba(10,10,10,.4)',
  },
  selectWrap: {
    height: 594,
    backgroundColor: '#fff',
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
    position: 'absolute',
    left: 0,
    bottom: 0,
    width,
    paddingTop: 15,
    paddingBottom: 50 + CommonStyles.footerPadding,
    // paddingHorizontal: 25,
    // paddingVertical: 5,
  },
  multipleBtnWrap: {
    position: 'absolute',
    bottom: 0 + CommonStyles.footerPadding,
    left: 0,
    height: 50,
    width,
    backgroundColor: '#fff',
  },
  multipleBtnText: {
    textAlign: 'center',
    letterSpacing: 2,
    color: '#fff',
    fontSize: 17,
  },
  multipleBtn_active: {
    backgroundColor: 'rgba(74,144,250,1)',
  },
  multipleBtn_unActive: {
    backgroundColor: 'rgba(74,144,250,0.5)',
  },
  selectAllWrap: {
    position: 'absolute',
    bottom: 0 + CommonStyles.footerPadding,
    left: 0,
    height: 50,
    width,
    backgroundColor: '#fff',
  },
  selectAllBtn: {
    marginLeft: 25,
    paddingRight: 5,
    height: '100%',
  },
  selectComplete: {
    height: '100%',
    paddingHorizontal: 33,
  },
  topBorderRadius: {
    borderTopLeftRadius: 8,
    borderTopRightRadius: 8,
  },
  staffItemWrap: {
    paddingHorizontal: 25,
    paddingVertical: 10,
  },
  staffTextInfo: {
    paddingLeft: 10,
  },
});
export default connect(
  state => ({
    singleAppontAccountList:state.task.singleAppontAccountList || {},
    singleMerchantList:state.task.singleMerchantList || {},
    appointList:state.task.appointList,
    appointedList:state.task.appointedList,

}),{
    fetchMerchantDelegate:(payload={})=>({type: 'task/fetchMerchantDelegate', payload }),
    fetchEmployeeDelegate:(payload={})=>({type: 'task/fetchEmployeeDelegate', payload }),
    fetchStaffList:(payload={})=>({type: 'task/fetchStaffList', payload }),
    updateStaffList:(payload={})=>({type: 'task/updateStaffList', payload }),
    updateSingleAppointList:(payload={})=>({type: 'task/updateSingleAppointList', payload }),
}
)(AppointPicker);
