import React, { Component } from 'react';
import {
  View, Text, Modal, Dimensions, StyleSheet, TouchableOpacity, StatusBar, Platform,
} from 'react-native';
import ScrollableTabView from 'react-native-scrollable-tab-view';
import { connect } from 'rn-dva';
import {
  TASK_CATEGORIES, TASK_TYPES_DESPCRIPTION, TASK_MERCHANT_JOB_STATUS, TASK_MERCHANT_AUDIT_STATUS, MERCHANT_TYPE_MAP_NAME,
} from '../../const/task';
import Header from '../../components/Header';
import FlatListView from '../../components/FlatListView';
import CommonStyles from '../../common/Styles';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import AppointPicker from '../../components/AppointPicker';
import ConfirmModal from '../../components/Modals/ConfirmModal';
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');

class TaskListScreen extends NavigationComponent {
    state = {
      type: '',
      merchantType: '',
      dropMenuVisible: false,
      selectedTab: {},
      selectedIndex: 0,
      tabList: [],
      confirmVisible: false,
      visible: false,
      jobId: '', // 任务id
      delegateId: '', // 委派id
    }

    blurState = {
      confirmVisible: false,
      visible: false,
      dropMenuVisible: false,
    }

    screenDidFocus = (payload) => {
      super.screenDidFocus(payload);
      StatusBar.setBarStyle('light-content');
    }

    componentDidMount() {
      const { navigation } = this.props;
      const { type = TASK_CATEGORIES.TrainTask, merchantType = TASK_TYPES_DESPCRIPTION[0].name } = navigation.state.params || {};
      const tabList = type === TASK_CATEGORIES.TrainTask ? TASK_MERCHANT_JOB_STATUS : TASK_MERCHANT_AUDIT_STATUS;
      this.setState({
        type,
        merchantType,
        tabList,
        selectedTab: tabList[0],
        selectedIndex: 0,
      }, () => this.fetchTaskList(1, true));
    }

    fetchTaskList = (page = 1, isFirstLoad = false, pageSize = 10) => {
      const {
        type, merchantType, selectedTab, selectedIndex,
      } = this.state;
      const {
        statisticsKey, taskcore, name, key, ...others
      } = selectedTab;
      const nowMerchantType = this.props.navigation.getParam('merchantType', ''); // 获取当前商户身份
      console.warn('fetchTaskList');
      this.props.dispatch({
        type: 'task/fetchTaskList',
        payload: {
          type,
          formData: { jobMerchantType: nowMerchantType, merchantType, ...others },
          page,
          isFirstLoad,
          limit: pageSize,
        },
      });
    }

    fetchMerchantTypeList(merchantType) {
      console.warn('fetchMerchantTypeList');
      this.setState({
        merchantType,
        dropMenuVisible: false,
      }, () => this.fetchTaskList(1));
    }

    handlerRefreshData() {
      console.warn('handlerRefreshData');
      this.fetchTaskList(1);
    }

    handleLoadMoreData() {
      const { pagination } = this.props;
      const { hasMore, page } = pagination;
      console.warn('handleLoadMoreData', pagination);
      if (hasMore) {
        this.fetchTaskList(page + 1);
      }
    }

    renderHeader() {
      const { navigation } = this.props;
      const { type, merchantType, dropMenuVisible } = this.state;
      const title = (
        <TouchableOpacity style={[CommonStyles.flex_center, { flexDirection: 'row' }]} onPress={() => this.setState({ dropMenuVisible: true })}>
          <Text style={CommonStyles.defaultHeaderText}>{`${type === TASK_CATEGORIES.TrainTask ? '培训任务' : '审核任务'}-${MERCHANT_TYPE_MAP_NAME[merchantType]}`}</Text>
          <View style={dropMenuVisible ? styles.triangle2 : styles.triangle} />
        </TouchableOpacity>
      );
      return (
        <Header
            headerStyle={styles.header}
            navigation={navigation}
            goBack
            // title={title}
            centerView={title}
        />
      );
    }
    renderDropMenu() {
      const { type, dropMenuVisible, merchantType } = this.state;
      const { merchantStatistics } = this.props;
      const title = (
        <TouchableOpacity style={[CommonStyles.flex_center, { flexDirection: 'row' }]} onPress={() => this.setState({ dropMenuVisible: false })}>
          <Text style={CommonStyles.defaultHeaderText}>{`${type === TASK_CATEGORIES.TrainTask ? '培训任务' : '审核任务'}-${MERCHANT_TYPE_MAP_NAME[merchantType]}`}</Text>
          <View style={dropMenuVisible ? styles.triangle2 : styles.triangle} />
        </TouchableOpacity>
      );
      return (
        <Modal
            animationType="fade"
            transparent
            visible={dropMenuVisible}
            onRequestClose={() => { this.setState({ dropMenuVisible: false }); }}
        >
          <TouchableOpacity
                activeOpacity={1}
                onPress={() => {
                  this.setState({
                    dropMenuVisible: false,
                  });
                }}
                style={styles.dropmenu}
          >
            <View style={styles.dropmenuTitle}>{title}</View>
            <View style={styles.triangleUp} />
            <View style={styles.menuWrap}>
              {
                    TASK_TYPES_DESPCRIPTION.map((task, index) => (
                      <TouchableOpacity
                                key={task.merchantType}
                                onPress={() => this.fetchMerchantTypeList(task.merchantType)}
                                style={[styles.menuItem, index === TASK_TYPES_DESPCRIPTION.length - 1 ? styles.noBorder : {}]}
                      >
                        <Text>
                          {`${task.name}(${merchantStatistics[task.merchantType] || 0})`}
                        </Text>
                      </TouchableOpacity>
                    ))
                }
            </View>
          </TouchableOpacity>
        </Modal>
      );
    }

    renderItem = ({ item, index }) => {
      const { navigation, user } = this.props;
      const { selectedTab, type } = this.state;
      const { page } = navigation.state.params;
      console.log(item);
      let taskResource = '';
      if (type === TASK_CATEGORIES.AuditTask) {
        taskResource = item.auditDelegateUserId === user.id ? item.auditMerchantType && item.auditMerchantName
          ? `${MERCHANT_TYPE_MAP_NAME[item.auditMerchantType]}-${item.auditMerchantName}` : ''
          : '系统分配';
      } else {
        taskResource = item.jobDelegateUserId === user.id ? item.jobMerchantType && item.jobMerchantName
          ? `${MERCHANT_TYPE_MAP_NAME[item.jobMerchantType]}-${item.jobMerchantName}` : ''
          : '系统分配';
      }

      const jobDelegateFlag = item.jobDelegateUserId && !(item.jobDelegateMerchantId && user.isAdmin && item.jobDelegateUserId === user.id); // 是否可以委派

      return (
        <TouchableOpacity
                style={styles.itemContent}
                key={index}
                onPress={() => {
                  // 审核中心   需要根据类型跳转界面
                  if (type === TASK_CATEGORIES.AuditTask && item.jobType === 'join') {
                    navigation.navigate('TaskDetail', { id: item.id, listcallBack: this.fetchTaskList });
                  } else {
                    navigation.navigate('TaskDetailNext', {
                      taskcore: selectedTab.taskcore,
                      type,
                      processStatus: item.processStatus,
                      auditStatus: item.auditStatus,
                      checkStatus: item.checkStatus,
                      id: item.id,
                      isToCneter: true,
                      callback: () => this.fetchTaskList(1),
                    });
                  }
                }
                }
        >
          <View style={{ flex: 1 }}>
            <View style={styles.taskType}>
              <Text style={styles.taskTypeText}>
                任务状态：
                {selectedTab.name}
              </Text>
              {
                type === TASK_CATEGORIES.TrainTask && selectedTab.statisticsKey === TASK_MERCHANT_JOB_STATUS[0].statisticsKey
                  ? (
                    <TouchableOpacity
                        disabled={jobDelegateFlag}
                        style={[styles.btnWeiPai, jobDelegateFlag ? styles.disabledButton : {}]}
                        onPress={() => {
                          this.setState({
                            jobId: item.id,
                            visible: true,
                          });
                        }}
                    >
                      <Text style={[{ fontSize: 16, color: CommonStyles.globalHeaderColor }, jobDelegateFlag ? styles.disabledButtonText : {}]}>委派</Text>
                    </TouchableOpacity>
                  ) : null
              }
            </View>
            <Text style={styles.text}>
联盟商名称：
              {item.joinMerchantName}
            </Text>
            <Text style={styles.text}>
联盟商身份：
              {MERCHANT_TYPE_MAP_NAME[item.joinMerchantType]}
            </Text>
            <Text style={styles.text}>
联盟商ID：
              {item.joinMerchantCode}
            </Text>
            <Text style={styles.text}>
联盟商联系电话：
              {item.joinMerchantPhone}
            </Text>
            {
                        item.joinMerchantCompany ? (
                          <Text style={styles.text}>
公司名称：
                            {item.joinMerchantCompany}
                          </Text>
                        ) : null
                    }
            {
              <Text style={styles.text}>
任务来源：
                {taskResource}
              </Text>
                    }
          </View>
        </TouchableOpacity>
      );
    };

    renderConfirmModal() {
      const { jobId, delegateId } = this.state;
      return (
        <ConfirmModal
            visible={this.state.confirmVisible}
            title="委派说明"
            content="为了更好的帮助您完成任务，你可以委派给联盟商或者分号来进行任务，当委派成功之后，你还可以继续完成任务"
            onRequestClose={() => this.setState({ confirmVisible: false })}
            buttons={[
              { text: '取消', type: 'cancel' },
              {
                text: '立即委派',
                type: 'submit',
                onPress: () => {
                  this.setState({ confirmVisible: false });
                  this.props.dispatch({
                    type: 'task/setJobDelegate',
                    payload: {
                      jobId,
                      delegateId,
                      callback: () => this.fetchTaskList(1),
                    },
                  });
                },
              },
            ]}
        />
      );
    }
    render() {
      const {
        tabList, type, selectedTab, selectedIndex,
      } = this.state;
      const { list, pagination, statistics } = this.props;
      return (
        <View style={styles.container}>
          <StatusBar barStyle="light-content" />
          { this.renderHeader() }
          { this.renderDropMenu() }
          <ScrollableTabView
            initialPage={0}
            onChangeTab={({ i }) => {
              if (i !== selectedIndex) {
                this.setState({ selectedIndex: i, selectedTab: tabList[i] }, () => this.fetchTaskList(1));
              }
            }}
            renderTabBar={() => (
              <ScrollableTabBar
                underlineStyle={{
                  backgroundColor: '#fff',
                  height: 8,
                  borderRadius: 10,
                  marginBottom: -5,
                }}
                tabStyle={{
                  backgroundColor: '#4A90FA',
                  height: 44,
                }}
                activeTextColor="#fff"
                inactiveTextColor="rgba(255,255,255,.5)"
                tabBarTextStyle={{ fontSize: 14 }}
                style={{
                  backgroundColor: '#4A90FA',
                  height: 44,
                  borderBottomWidth: 0,
                  overflow: 'hidden',
                }}
              />
            )}
          >
            {
              tabList.map((itemTab, index) => (
                <FlatListView
                    type={type === TASK_CATEGORIES.TrainTask ? 'SHRZ_01_1_taskCenter' : 'SHRZ_01_auditCenter'}
                    style={{
                      backgroundColor: '#EEE',
                      marginBottom: 10,
                      width,
                    }}
                    renderItem={data => this.renderItem(data)}
                    tabLabel={`${itemTab.name}(${statistics[itemTab.statisticsKey] || 0})`}
                    key={itemTab.name}
                    store={pagination}
                    data={list}
                    numColumns={1}
                    refreshData={() => this.handlerRefreshData()}
                    loadMoreData={() => this.handleLoadMoreData()}
                />
              ))
            }
          </ScrollableTabView>
          { this.renderConfirmModal()}
          <AppointPicker
            type="task"
            taskId={this.state.jobId}
            visible={this.state.visible}
            onClose={() => { this.setState({ visible: false }); }}
            getAppointArr={(res) => {
              this.setState({
                confirmVisible: true,
                delegateId: res[0].data[0].id,
              });
            }}
          />
        </View>
      );
    }
}

export default connect(state => ({
  pagination: state.task.taskList.pagination,
  list: state.task.taskList.list,
  statistics: state.task.taskList.statistics || {},
  merchantStatistics: state.task.taskList.merchantStatistics || {},
  taskHomeData: state.task.taskHomeData,
  user: state.user.user,
}))(TaskListScreen);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  dropmenu: {
    width,
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  triangle2: {
    width: 0,
    height: 0,
    borderTopWidth: 0,
    borderRightWidth: 4,
    borderBottomWidth: 6,
    borderLeftWidth: 4,
    borderTopColor: 'transparent',
    borderRightColor: 'transparent',
    borderBottomColor: '#fff',
    borderLeftColor: 'transparent',
    borderStyle: 'solid',
    marginLeft: 5,
  },
  triangle: {
    width: 0,
    height: 0,
    borderTopWidth: 6,
    borderRightWidth: 4,
    borderBottomWidth: 0,
    borderLeftWidth: 4,
    borderTopColor: '#fff',
    borderRightColor: 'transparent',
    borderBottomColor: 'transparent',
    borderLeftColor: 'transparent',
    borderStyle: 'solid',
    marginLeft: 5,
  },
  triangleUp: {
    width: 0,
    height: 0,
    borderTopWidth: 0,
    borderRightWidth: 8,
    borderBottomWidth: 8,
    borderLeftWidth: 8,
    borderTopColor: 'transparent',
    borderRightColor: 'transparent',
    borderBottomColor: '#fff',
    borderLeftColor: 'transparent',
    marginTop: -10,
  },
  dropmenuTitle: {
    height: 44,
    marginTop: Platform.OS === 'android' ? 11 : CommonStyles.headerPadding + 11,
  },
  menuWrap: {
    width: 160,
    backgroundColor: '#FFF',
    borderRadius: 4,
    justifyContent: 'center',
    paddingHorizontal: 10,
    // alignItems: 'center'
  },
  menuItem: {
    height: 44,
    // width: 100,
    borderBottomColor: 'rgba(0,0,0,0.08)',
    borderBottomWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  noBorder: {
    borderBottomWidth: 0,
  },
  itemContent: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 15,
    width: width - 20,
    marginLeft: 10,
    backgroundColor: '#fff',
    borderRadius: 10,
    // ...CommonStyles.shadowStyle
  },
  taskType: {
    paddingTop: 4,
    paddingBottom: 19,
    borderBottomColor: 'rgba(0,0,0,0.08)',
    borderBottomWidth: 1,
    marginBottom: 8,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  taskTypeText: {
    fontSize: 16,
    color: '#222',
    height: 22,
    lineHeight: 22,
    flex: 1,
  },
  btnWeiPai: {
    borderWidth: 1,
    borderColor: CommonStyles.globalHeaderColor,
    width: 72,
    height: 30,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 4,
  },
  disabledButton: {
    opacity: 0.3,
    borderColor: '#999',
  },
  disabledButtonText: {
    color: '#999',
  },
  text: {
    fontSize: 14,
    color: '#999',
    lineHeight: 20,
    height: 20,
    marginTop: 8,
  },
});
