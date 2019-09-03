// 验收中心
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,

  View,
  Text,
  Image,
  TouchableOpacity,
  TouchableHighlight,
  Modal,
  TextInput,
  Platform,
  ScrollView,
} from 'react-native';
import { connect } from 'rn-dva';

import moment from 'moment';
import Video from 'react-native-video';
import ImageView from '../../components/ImageView';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import Content from '../../components/ContentItem';
import CommonButton from '../../components/CommonButton';
import * as taskRequest from '../../config/taskCenterRequest';
import config from '../../config/config';
import { NavigationComponent } from '../../common/NavigationComponent';
import { MERCHANT_TYPE_MAP_NAME } from '../../const/task';
import { TakeOrPickParams, PickTypeEnum, TakeTypeEnum } from '../../const/application.js';
import ActionSheet from '../../components/Actionsheet';
import FixedFooter from '../../components/FixedFooter';
import Button from '../../components/Button';

const { width, height } = Dimensions.get('window');

const add = require('../../images/xiwei/add.png');

class TaskDetailNext extends NavigationComponent {
  static navigationOptions = {
    header: null,
  }

  state = {
    data: {},
    visible: false,
    taskIndex: 0,
  };

  blurState = {
    visible: false,
  }

  componentDidMount() {
    const { fetchTaskDetailNext, navigation } = this.props;
    const { id, taskcore } = navigation.state.params || {};
    fetchTaskDetailNext(taskcore, id);
  }


  _setState = (payload)=> {
    const { saveTask, taskDetailNext } = this.props;
    saveTask({
      taskDetailNext: {
        ...taskDetailNext,
        ...payload,
      },
    });
  }

  changeTaskText = (val, fieldKey) => {
    const { taskDetailNext } = this.props;
    const data = taskDetailNext.data || {};
    data.job.params.find((paramsItem) => {
      if (paramsItem.key === fieldKey) {
        paramsItem.value = val;
        return true;
      }
    });
    this._setState({
      data,
    });
  }

  _deletePicture = (item, index) => {
    const { taskDetailNext } = this.props;
    const data = taskDetailNext.data || {};
    const taskParams = data.job.params;
    taskParams.forEach((dataItem) => {
      if (dataItem.key === item.key) {
        dataItem.value.splice(index, 1);
      }
    });
    this._setState({
      data,
    });
  }

  renderTaskVideo = (itemdata, index) => {
    const { taskDetailNext } = this.props;
    const videos = itemdata.value;
    const { editor } = taskDetailNext;
    if (videos && videos.length) {
      return videos.map((item, index) => (
        <View
          key={index}
          style={styles.img_item_box}
        >
          <TouchableOpacity
            style={{ width: 60, height: 60 }}
            onPress={() => {
              if (item == config.qiniuUrl) {
                Toast.show('视频上传失败');
              } else {
                this.setState({
                  visible: true,
                  largeImage: item,
                  imageType: 'video',
                });
              }
            }}
          >
            {
              Platform.OS === 'ios' ? (
                <Video
                  source={{ uri: item || '' }}
                  ref={(ref) => { this.player = ref; }}
                  rate={0}
                  resizeMode="cover"
                  style={{ width: 60, height: 60 }}
                />
              ) : (
                <ImageView
                    resizeMode="cover"
                    source={{ uri: `${item}?vframe/jpg/offset/0` }}
                    sourceWidth={60}
                    sourceHeight={60}
                />
              )
            }
          </TouchableOpacity>
          {
            editor ? (
              <TouchableOpacity
                disabled={!editor}
                style={styles.img_item_delete}
                onPress={() => {
                  this._deletePicture(itemdata, index);
                }}
              >
                <Image
                  source={require('../../images/index/delete.png')}
                />
              </TouchableOpacity>
            ) : null
          }
        </View>
      ));
    }
    if (editor) {
      return (
        <TouchableOpacity
          disabled={!editor}
          key={999}
          onPress={() => {
            this.setState({
              taskIndex: index,
              taskType: 'Video',
            });
            this.ActionSheet.show();
          }
          }
          style={styles.img_item_box}
        >
          <Image source={add} style={{ width: 60, height: 60 }} />
        </TouchableOpacity>
      );
    }
  }

  upload = (operateIndex) => {
    const { taskDetailNext } = this.props;
    const { data = {} } = taskDetailNext;
    const { taskIndex: index, taskType } = this.state;
    const maxImgLen = data.job.params[index].maxSize;
    let value = data.job.params[index].value || [];
    if (maxImgLen === value.length) {
      Toast.show('已经达到上限');
      return;
    }
    const func = operateIndex === 0 ? 'take' : 'pick';
    const params = new TakeOrPickParams({
      func,
      type: func === 'take' ? TakeTypeEnum[func + taskType] : PickTypeEnum[func + taskType],
      totalNum: maxImgLen - value.length,
    });
    this.props.takeOrPickImageAndVideo(
      params.getOptions(),
      (res) => {
        value = value.concat(res.map(item => item.url));
        data.job.params[index].value = value;
        this.setState({
          data,
        });
      },
    );
  }

  renderTaskImages = (item, index) => {
    const images = item.value;
    const { taskDetailNext } = this.props;
    const { editor } = taskDetailNext;
    if (images && images.length) {
      return images.map((img, index) => (
        <View
          key={index}
          style={styles.img_item_box}
        >
          <TouchableOpacity
            onPress={
              () => {
                this.setState({
                  visible: true,
                  largeImage: img,
                  imageType: 'image',
                });
              }
            }
          >
            <ImageView
              style={styles.img_item}
              source={{ uri: img || '' }}
              sourceWidth={60}
              sourceHeight={60}
              resizeMode="cover"
            />
          </TouchableOpacity>
          {
            editor ? (
              <TouchableOpacity
                disabled={!editor}
                style={styles.img_item_delete}
                onPress={() => {
                  this._deletePicture(item, index);
                }}
              >
                <Image
                  source={require('../../images/index/delete.png')}
                />
              </TouchableOpacity>
            ) : null
          }
        </View>
      ));
    }
    if (editor) {
      return (
        <TouchableOpacity
          disabled={!editor}
          onPress={() => {
            this.setState({
              taskIndex: index,
              taskType: 'Image',
            });
            this.ActionSheet.show();
          }}
          key={999}
          style={styles.img_item_box}
        >
          <Image source={add} style={{ width: 60, height: 60 }} />
        </TouchableOpacity>
      );
    }
  }

  rendertaskParams = (taskParams) => {
    const { taskDetailNext } = this.props;
    const { editor } = taskDetailNext;
    if (taskParams) {
      return taskParams.map((item, index) => {
        switch (item.media) {
          case 'text':
            return (
              <View style={{ marginTop: 10 }} key={index}>
                <Text style={styles.text}>
                  任务项
                  {index + 1}
                  :
                  {item.name}
                </Text>
                <TextInput
                  editable={editor}
                  style={{
                    width: width - 50, padding: 10, borderColor: '#CCC', borderWidth: 0.5, color: '#000',
                  }}
                  value={item.value}
                  returnKeyLabel="确定"
                  returnKeyType="done"
                  onChangeText={(val) => { this.changeTaskText(val, item.key); }}
                />
              </View>
            );
          case 'picture':
            return (
              <View style={{ marginTop: 10, width: width - 50 }} key={index}>
                <Text style={styles.text}>
                  任务项
                  {index + 1}
                  :
                  {item.name}
                </Text>
                <View style={{
                  flexDirection: 'row', flexWrap: 'wrap', width: width - 50, paddingBottom: 10,
                }}
                >
                  {
                    this.renderTaskImages(item, index)
                  }
                  {
                    item.value && item.value.length > 0 ? (
                      item.maxSize > item.value.length ? (
                        editor ? (
                          <TouchableOpacity
                            disabled={!editor}
                            onPress={() => {
                              this.setState({
                                taskIndex: index,
                                taskType: 'Image',
                              });
                              this.ActionSheet.show();
                              console.log('Image');
                            }
                            }
                            key={999}
                            style={styles.img_item_box}
                          >
                            <Image source={add} style={{ width: 60, height: 60 }} />
                          </TouchableOpacity>
                        ) : null
                      ) : null
                    ) : (
                      null
                    )
                  }
                </View>
              </View>
            );
          case 'video':
            return (
              <View style={{ marginTop: 10 }} key={index}>
                <Text style={styles.text}>
                  任务项
                  {index + 1}
                  :
                  {item.name}
                </Text>
                <View style={{
                  flexDirection: 'row', flexWrap: 'wrap', width: width - 50, paddingBottom: 10,
                }}
                >
                  {
                    this.renderTaskVideo(item, index)
                  }
                  {
                    item.value && item.value.length > 0 ? (
                      item.maxSize > item.value.length ? (
                        editor ? (
                          <TouchableOpacity
                            disabled={!editor}
                            onPress={() => {
                              this.setState({
                                taskIndex: index,
                                taskType: 'Video',
                              });
                              this.ActionSheet.show();
                              console.log('Video');
                            }}
                            key={999}
                            style={styles.img_item_box}
                          >
                            <Image source={add} style={{ width: 60, height: 60 }} />
                          </TouchableOpacity>
                        ) : null
                      ) : null
                    ) : (
                      null
                    )
                  }
                </View>
              </View>
            );
          default:
            return null;
        }
      });
    }
    return null;
  }

  saveData = () => {
    const { taskDetailNext } = this.props;
    const { data = {} } = taskDetailNext;
    const { navigation } = this.props;
    const { callback, listcallBack } = navigation.state.params;
    if (!data.job || !data.job.id) {
      return;
    }
    const param = {
      jobId: data.job.id,
      params: {},
    };
    const taskParams = data.job.params;
    if (taskParams) {
      let _flag = false;
      for (let i = 0; i < taskParams.length; i++) {
        let flag = false;
        const item = taskParams[i];
        switch (item.media) {
          case 'text':
            if (item.required == 1 && (!item.value || (item.value && !item.value.trim()))) {
              Toast.show(`${item.name}任务必填`);
              flag = true;
              return;
            }
            if (item.maxSize && item.value && item.value.length > item.maxSize) {
              Toast.show(`${item.name}任务值不能超过${item.maxSize}个字`);
              flag = true;
              return;
            }
            break;
          case 'picture': case 'video':
            if (item.required == 1 && (!item.value || (item.value && item.value.length == 0))) {
              Toast.show(`${item.name}任务必填`);
              flag = true;
              return;
            }
            break;
          default:
            break;
        }
        if (!flag) {
          param.params[item.key] = item.value;
        } else {
          _flag = true;
        }
      }

      if (_flag) {
        return;
      }
    }
    console.log('calllback', callback);
    console.log('calllback', listcallBack);
    // callback(true)
    // return
    taskRequest.fetchMerchantJoinTaskFinish(param).then((res) => {
      if (callback) {
        callback(1);
      }
      if (listcallBack) {
        listcallBack(1);
      }
      navigation.goBack();
    }).catch((err)=>{
      console.log(err)
    });
  }

  merchantJoinTaskAudit = () => {
    const { navigation, taskDetailNext } = this.props;
    const { callback, listcallBack } = navigation.state.params;
    const { data = {} } = taskDetailNext;
    if (!data.job || !data.job.id) {
      return;
    }
    const param = {
      jobId: data.job.id,
    };
    taskRequest.fetchMerchantJoinTaskAudit(param).then((res) => {
      Toast.show('审核通过');
      if (callback) {
        callback(1);
      }
      if (listcallBack) {
        listcallBack(1);
      }
      navigation.goBack();
    }).catch((err)=>{
      console.log(err)
    });
  }

  renderBottomBtn = () => {
    const { taskDetailNext } = this.props;
    const {
      taskcore, callback, isToCneter, listcallBack,
    } = this.props.navigation.state.params;
    const { hasbtn, editor, data = {} } = taskDetailNext;
    const { user = {} } = this.props;
    const job = (data || {}).job || {};
    if ((taskcore == 'taskcore' && hasbtn) || (editor)) {
      return (
        <FixedFooter style={{ position: 'relative' }} fixedHeight={44}>
          <Button style={{ flex: 1, borderRadius: 0 }} title="完成并提交" type="primary" onPress={this.saveData} />
        </FixedFooter>
      );
    } if (taskcore == 'acceptancecore' && hasbtn && ((user.isAdmin && (job.jobDelegateMerchantId === user.merchantId || !job.jobDelegateMerchantId)) || user.id === job.checkDelegateUserId)) {
      return (
        <View>
          <CommonButton
            title="验收通过"
            style={{ marginLeft: 10, marginBottom: 0 }}
            onPress={() => CustomAlert.onShow(
              'confirm',
              '确定通过验收？',
              '提示',
              () => { },
              () => { this.merchantJoinTaskAcceptance(); },
              '通过',
              '取消',
            )}
          />
          <CommonButton
            onPress={() => {
              this.props.navigation.navigate('CancelTaskAudit', {
                listcallBack, taskId: job.id, taskcore, callback,
              });
            }}
            title="验收不通过"
            style={[styles.botton, styles.botton2]}
            textStyle={{ color: CommonStyles.globalHeaderColor }}
          />
        </View>
      );
    } if (taskcore == 'auditcore' && hasbtn && (user.isAdmin || user.id === job.auditDelegateUserId)) {
      return (
        <View>
          <CommonButton
            title="审核通过"
            style={[styles.botton, { marginBottom: 0 }]}
            onPress={() => CustomAlert.onShow(
              'confirm',
              '确定通过审核？',
              '提示',
              () => { },
              () => { this.merchantJoinTaskAudit(); },
              '通过',
              '取消',
            )}
          />
          <CommonButton
            onPress={() => {
              this.props.navigation.navigate('CancelTaskAudit', {
                listcallBack, isToCneter, taskcore: 'auditcore', taskId: job.id, callback,
              });
            }}
            title="审核不通过"
            style={[styles.botton, styles.botton2]}
            textStyle={{ color: CommonStyles.globalHeaderColor }}
          />
        </View>
      );
    }

    return null;
  }

  merchantJoinTaskAcceptance = () => {
    const { navigation, taskDetailNext } = this.props;
    const { callback, listcallBack } = navigation.state.params;
    const { data = {} } = taskDetailNext;
    if (!data.job || !data.job.id) {
      return;
    }
    const param = {
      jobId: data.job.id,
      // action: 'yes',
      // merchantTaskNode:merchantTaskNode
    };
    taskRequest.fetchMerchantJoinTaskAcceptance(param).then((res) => {
      Toast.show('验收通过');
      if (callback) {
        callback(1);
      }
      if (listcallBack) {
        listcallBack(1);
      }
      navigation.goBack();
    }).catch((err)=>{
      console.log(err)
    });
  }

  renderLogData = () => {
    const { data = {} } = this.props.taskDetailNext;
    if (data.histories && data.histories.length) {
      return data.histories.map((item, index) => {
        let borderSty = data.histories.length === 1 ? null : { borderLeftColor: '#CCC', borderLeftWidth: 1 };
        if (index === 0) {
          return (
            <View style={[{ flex: 1, height: 50 }, borderSty]} key={index}>
              <View style={{ flexDirection: 'row' }}>
                <Image
                  source={require('../../images/user/juge_record.png')}
                  style={{
                    width: 17, height: 20, position: 'absolute', left: -9, top: -2,
                  }}
                />
                <View style={{ marginLeft: 18 }}>
                  <Text style={[styles.smallText, { color: '#222' }]}>{moment(item.updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                </View>
              </View>
              <View style={{ marginLeft: 18 }}>
                <Text style={styles.text} numberOfLines={3}>{item.log}</Text>
              </View>
            </View>
          );
        }
        borderSty = {
          borderLeftColor: '#CCC',
          borderLeftWidth: 1,
        };
        let imgBorderSty = index === data.histories.length - 1 ? borderSty : null;
        borderSty = index === data.histories.length - 1 ? null : borderSty;
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
              <Text style={[styles.text]} numberOfLines={3}>{item.log}</Text>
            </View>
          </View>
        );
      });
    }
    return null;
  }

  getNameByKey = (status, flag) => {
    if (flag === 1) {
      switch (status) {
        case 'did':
          return '已完成';
        case 're_do':
          return '待重做';
        default: return '未完成';
      }
    } else if (flag === 2) {
      switch (status) {
        case 'audit_fail':
          return '审核失败';
        case 'audit_success':
          return '审核成功';
        default: return '未审核';
      }
    } else {
      switch (status) {
        case 'check_fail':
          return '验收失败';
        case 'check_success':
          return '验收成功';
        default: return '未验收';
      }
    }
  }

  render() {
    const { navigation, taskDetailNext } = this.props;
    const { data = {} } = taskDetailNext;
    const { imageType, visible, largeImage } = this.state;
    const { taskcore, callback } = navigation.state.params;

    return (
      <View style={styles.container}>
        <Header navigation={navigation} goBack onBack={callback} title="任务详情" />
        <Modal
          animationType="fade"
          transparent
          visible={visible}
          onRequestClose={() => {
            this.setState({ visible: false, imageType: 'image' });
          }}
          onShow={() => { }}
        >
          <TouchableHighlight
            style={styles.bigImage}
            onPress={() => this.setState({ visible: false, imageType: 'image' })}
          >
            {
              imageType === 'video'
                ? (
                  <Video
                    source={{ uri: largeImage }} // Can be a URL or a local file.
                    ref={(ref) => { this.player = ref; }}
                    rate={1} // Store reference
                    resizeMode="contain"
                    // onBuffer={this.onBuffer}                // Callback when remote video is buffering
                    // onError={this.videoError}               // Callback when video cannot be loaded
                    style={{ width, height }}
                  />
                )
                : (
                  <ImageView
                    isGetSize
                    source={{ uri: largeImage }}
                    sourceWidth={width}
                  />
                )

            }
          </TouchableHighlight>
        </Modal>
        <ScrollView>
          <Content style={styles.content}>
            <View style={[CommonStyles.flex_1, CommonStyles.flex_between]}>
              <Text style={styles.text}>
                任务类型：
                {data && data.job && data.job.step === 0 ? '联盟商入驻任务' : '联盟商培训任务'}
              </Text>
              {
                data.job
                && (
                  <Text style={[styles.text, { color: CommonStyles.globalHeaderColor }]}>
                    {this.getNameByKey(taskcore == 'taskcore' || taskcore == 'auditcore' ? data.job.processStatus : data.job.checkStatus, taskcore == 'taskcore' || taskcore == 'auditcore' ? 1 : 3)}
                  </Text>
                )
              }
            </View>
            <Text style={styles.text}>
              联盟商名称：
              {data && data.job && data.job.joinMerchantName}
            </Text>
            <Text style={styles.text}>
              联盟商身份：
              {data && data.job &&  MERCHANT_TYPE_MAP_NAME[data.job.joinMerchantType]}
            </Text>
            <Text style={styles.text}>
              联盟商ID：
              {data && data.job && data.job.joinMerchantCode}
            </Text>
            <Text style={[styles.text, { marginBottom: 0 }]}>
              联盟商联系电话：
              {data && data.job && data.job.joinMerchantPhone}
            </Text>
          </Content>
          {
            data && data.job && data.job.params && data.job.params.length > 0 && (
              <Content style={[styles.content, { flexDirection: 'column', alignItems: 'flex-start' }]}>
                {/* <Text style={styles.text}>任务{index + 1}:'任务名字没返回'</Text> */}
                {
                  this.rendertaskParams(data.job.params)
                }
              </Content>
            )
          }
          {
            data && data.histories && data.histories.length > 0 && (
              <Text style={{
                marginLeft: 25, color: '#777', fontSize: 14, marginTop: 15,
              }}
              >
                任务进度

              </Text>
            )
          }
          {
            data && data.histories && data.histories.length > 0 && (
              <Content style={[styles.content, { marginTop: 10, marginBottom: 10 }]}>
                <View>
                  {
                    this.renderLogData()
                  }
                </View>
              </Content>
            )
          }
        </ScrollView>
        {
          this.renderBottomBtn()
        }
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          // title={'Which one do you like ?'}
          options={['拍摄', '相册', '取消']}
          cancelButtonIndex={2}
          // destructiveButtonIndex={2}
          onPress={(index) => {
            if (index != 2) {
              this.upload(index);
            }
          }}
        />
      </View>
    );
  }
}

export default connect(
  state => ({
    user: state.user.user || {},
    merchant: state.user.merchant || [],
    taskDetailNext: state.task.taskDetailNext || {},
  }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
    fetchTaskDetailNext: (taskcore, jobId)=> ({ type: 'task/fetchTaskDetailNext', payload: { taskcore, jobId } }),
    saveTask: (payload)=> ({ type: 'task/save', payload }),
  },
)(TaskDetailNext);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  text: {
    color: '#222',
    fontSize: 14,
    marginBottom: 15,
  },
  bigImage: {
    backgroundColor: 'rgba(0, 0, 0, 1)',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  headerItem: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%',
  },
  left: {
    width: 50,
  },
  content: {
    width: width - 20,
    marginLeft: 10,
    padding: 15,
    paddingHorizontal: 15,
    // flexDirection: "row",
    // alignItems: "center",
  },
  content2: {
    width: width - 20,
    marginLeft: 10,
    padding: 15,
    paddingHorizontal: 15,
    alignItems: 'center',
  },
  smallText: {
    fontSize: 13,
    color: '#999',
    marginBottom: 2,
  },
  itemType: {
    fontSize: 14,
    color: CommonStyles.globalHeaderColor,
  },
  image: {
    width: 68,
    height: 68,
    borderRadius: 6,
    overflow: 'hidden',
    marginRight: 15,
  },
  imageView: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',

  },
  botton: {
    marginLeft: 10,
  },
  botton2: {
    backgroundColor: '#fff',
    marginBottom: 20 + CommonStyles.footerPadding,
  },
  btn: {
    justifyContent: 'center',
    alignItems: 'center',
    height: 50,
    marginBottom: CommonStyles.footerPadding,
    backgroundColor: '#4A90FA',
  },
  img_item_box: {
    width: 60,
    height: 60,
    marginTop: 10,
    borderWidth: 0.5,
    marginLeft: 10,
    borderColor: '#f1f1f1',
    borderRadius: 6,
  },
  img_item: {
    width: '100%',
    height: '100%',
    borderRadius: 6,
    overflow: 'hidden',
  },
  img_item_delete: {
    position: 'absolute',
    top: -5,
    right: -5,
    alignItems: 'flex-end',
    width: 24,
    height: 24,
  },
});
