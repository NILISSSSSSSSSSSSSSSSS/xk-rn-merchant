// 验收中心/任务详情
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,

  View,
  Text,
  Button,
  Image,
  TouchableOpacity,
  Platform,
  ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';

import moment from 'moment';

import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import DashLine from '../../components/DashLine';
import * as taskRequest from '../../config/taskCenterRequest';
import { MERCHANT_TYPE_MAP_NAME } from '../../const/task';

const { width, height } = Dimensions.get('window');

function getwidth(val) {
  return width * val / 375;
}

class TaskDetail extends PureComponent {
    static navigationOptions = {
      header: null,
    };

    componentDidMount() {
      this.requestInitData();
    }

    requestInitData = () => {
      const { navigation, fetchTaskDetail } = this.props;
      const { id } = navigation.state.params || {};
      fetchTaskDetail(id);
    }

    goToDetail = (item) => {
      const { navigation } = this.props;
      const { listcallBack } = navigation.state.params;
      // const { data } = this.state;
      const { taskDetail: data } = this.props;
      const taskType = item.step;
      if (taskType == 0) {
        let hasBtn = false;
        if (item.auditStatus === 'un_audit') {
          hasBtn = true;
        }
        const params = {
          page: 'task',
          isshops: item.merchantType === 'shops' ? true : false,
          taskUserId: item.taskCreateUserId,
          merchantType: item.joinMerchantType,
          name: '入驻信息',
          listcallBack,
          merchantTaskNode: item.merchantTaskNode,
          taskId: item.id,
          hasBtn,
          editor: true,
          callback: this.requestInitData,
          joinMerchantId: item.joinMerchantId,
          auditStatus: item.auditStatus,

        };
        if (data && data.jobs) {
          data.jobs.find(item => item.processStatus != 'did')
            ? params.cantAudit = '请先完成任务' : data.jobs.find(item => item.checkStatus != 'check_success')
              ? params.cantAudit = '请先验收任务' : null;
        }
        navigation.navigate('MyApplyForm', params);
      } else {
        navigation.navigate('TaskDetailNext', {
          taskId: item.id,
          merchantId: item.merchantId,
          merchantTypeName: item.merchantTypeName,
          taskcore: 'auditcore',
          auditStatus: item.auditStatus,
          processStatus: item.processStatus,
          checkStatus: item.checkStatus,
          id: item.id,
          merchantCode: item.merchantCode,
          merchantName: item.merchantName,
          taskName: item.taskName,
          isMe: item.isMe,
          merchantTaskNode: item.merchantTaskNode,
          callback: this.requestInitData,
          listcallBack,
          taskStatus: item.processStatus,
        });
      }
    }

    renderLogs = () => {
      const { taskDetail: data } = this.props;
      if (data && data.histories) {
        return data.histories.map((item, index) => {
          let borderSty = { borderLeftColor: '#CCC', borderLeftWidth: 1 };
          if (data.histories.length === 1) {
            borderSty = null;
          }
          if (index === 0) {
            return (
              <View style={[{ flex: 1, height: 50, flexDirection: 'row' }, borderSty]} key={index}>
                <Image
                  source={require('../../images/user/juge_record.png')}
                  style={{
                    width: 17, height: 20, position: 'absolute', left: -9, top: -2,
                  }}
                />
                <View style={{ marginLeft: 18 }}>
                  <Text style={[styles.smallText, { color: '#222' }]}>{moment(item.updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                  <Text style={[styles.text]}>{item.log}</Text>
                </View>
              </View>
            );
          }
          borderSty = {
            borderLeftColor: '#CCC',
            borderLeftWidth: 1,
          };
          let imgBorderSty = null;
          if (index === data.histories.length - 1) {
            imgBorderSty = borderSty;
            borderSty = null;
          }
          return (
            <View style={[{ flex: 1, height: 50, flexDirection: 'row' }, borderSty]} key={index}>
              <View style={[{ height: 12 }, imgBorderSty]}>
                <Image
                  source={require('../../images/user/juge_record1.png')}
                  style={{
                    width: 12, height: 12, position: 'absolute', left: -6, marginTop: 8, backgroundColor: '#fff',
                  }}
                />
              </View>
              <View style={{ marginLeft: 18 }}>
                <Text style={[styles.smallText, { color: '#222' }]}>{moment(item.updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                <Text style={[styles.text]}>{item.log}</Text>
              </View>
            </View>
          );
        });
      }
    }
    render() {
      const { navigation, taskDetail: data } = this.props;
      console.log('data',data)
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="任务详情"
          />
          <ScrollView>
            {
              (data.lists || []).map((onedata, index1) => (
                <Content style={styles.content} key={index1}>
                  {
                    (onedata || []).map((item, index) => (
                      <Line
                        style={{ paddingLeft: 0, paddingRight: 0 }}
                        key={index}
                        point={null}
                        title={item.step === 0 ? '入驻联盟商信息' : `第${item.step}级审核任务`}
                        value={item.name}
                        type="horizontal"
                        onPress={
                            () => {
                              this.goToDetail(item);
                            }
                        }
                      />
                    ))
                  }
                </Content>
              ))
            }
            {
              data && data.histories && (
                <View>
                  <Text style={{
                    margin: 15, marginLeft: 25, color: '#777', fontSize: 14,
                  }}
                  >
                  审核记录
                  </Text>
                  <Content style={[styles.content, styles.content2, { flexDirection: 'row', marginBottom: 10 }]}>
                    <View>
                      {
                        this.renderLogs()
                      }
                    </View>
                  </Content>
                </View>
              )
            }
          </ScrollView>
        </View>
      );
    }
}

export default connect(state=> ({
  taskDetail: state.task.taskDetail || {},
}), {
  fetchTaskDetail: (jobId)=> ({ type: 'task/fetchTaskDetail', payload: { jobId } }),
})(TaskDetail);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  text: {
    color: '#222',
    fontSize: 14,
    marginBottom: 15,
  },
  content: {
    width: width - 20,
    marginLeft: 10,
    paddingHorizontal: 15,
  },
  content2: {
    marginTop: 0,
    paddingTop: 15,
    flexDirection: 'row',
  },
  smallText: {
    fontSize: 13,
    color: '#999',
    marginBottom: 2,
  },
  logsItem: {
    width: getwidth(355),
    height: 65,
    paddingHorizontal: 12,
  },
  icoroundcontent: {
    borderLeftColor: '#D8D8D8',
    borderLeftWidth: 1,
    height: '100%',
    paddingHorizontal: 15,
  },
  iconround: {
    backgroundColor: '#4A90FA',
    width: 10,
    height: 10,
    borderRadius: 10,
    position: 'absolute',
    left: -5,
    top: -5,
  },
});
