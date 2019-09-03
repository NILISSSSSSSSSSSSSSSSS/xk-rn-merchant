// 更新的模态框

import React, { Component } from 'react';
import {
  View, Text, StyleSheet, Modal, TouchableOpacity, Image, Dimensions, Animated, Easing, Platform, Linking, DeviceEventEmitter, Alert,
} from 'react-native';
import { connect } from 'rn-dva';
import Progress from './UpdateProgress';
import CommonStyles from '../common/Styles';
import { downloadAndInstall, openPermissionSettings } from '../config/nativeApi';
import Button from './Button';

const { width, height } = Dimensions.get('window');

class UpdateComModal extends Component {
    state = {
      immediateUpdate: false,
      planeAin: new Animated.Value(32),
      downloadError: false,
    }

    componentDidMount() {
      DeviceEventEmitter.addListener('downloadProgress', this._handleDownloadProgress);
      DeviceEventEmitter.addListener('downloadError', this._handleDownloadError);
    }

    componentWillUnmount() {
      DeviceEventEmitter.removeListener('downloadProgress', this._handleDownloadProgress);
      DeviceEventEmitter.addListener('downloadError', this._handleDownloadError);
    }

    _immediateUpdate = async () => {
      const { isMandatory } = this.props;
      this.setState({ immediateUpdate: true });

      if (Platform.OS === 'ios') {
        Linking.openURL('itms-apps://itunes.apple.com/app/id1448670815');
        // 非强制更新才能关闭弹框
        if (!isMandatory) this.handleCloseModal();
      }

      if (Platform.OS === 'android') {
        const url = this.props.updateInfo.url;
        if (url) {
          const isSuccess = await downloadAndInstall(url);
          if (!isSuccess) {
            Alert.alert('提示', '请为应用开启存储权限，以便下载最新的更新包，更新后可继续使用应用。', [
              {
                text: '确定',
                onPress: () => {
                  openPermissionSettings();
                },
              },
            ]);
            this.setState({ immediateUpdate: false });
          }
        }
      }
    }

    _handleDownloadProgress = (progress) => {
      const { modalVisible, isMandatory } = this.props;
      const { immediateUpdate } = this.state;
      console.log('下载进度=>', progress);
      if (modalVisible && immediateUpdate) {
        if (this.progress != progress) this.startPlaneAni(progress / 100);
        this.progress = progress;
        if (progress === 100) {
          // 非强制更新，才可以关闭弹框
          if (!isMandatory) {
            this._setState({
              modalVisible: false,
            });
          }
          this.setState({
            immediateUpdate: false,
          });
        }
      }
    }

    _handleDownloadError = () => {
      this.setState({
        downloadError: true,
      });
    }

    startPlaneAni = (progress) => {
      const val = progress * 270 >= 32 ? progress * 270 >= 248 ? 270 : progress * 270 : 32;
      Animated.timing(this.state.planeAin, {
        toValue: val,
        duration: 100,
        easing: Easing.linear,
      }).start();
      this.progressBar.progress = progress;
    }

    _setState = (state) => {
      const { isMandatory, modalVisible, updateInfo = {} } = this.props;
      this.props.saveUpgradeInfo({
        isMandatory,
        modalVisible,
        updateInfo,
        ...state,
      });
    }

    handleCloseModal = () => {
      const { isMandatory, readLaunchAppNotification } = this.props;
      const modalVisible = false;
      this._setState({ modalVisible });
      if (!modalVisible && !isMandatory) {
        readLaunchAppNotification();
      }
    }

    handleRedownload = () => {
      this.setState({
        downloadError: false,
      });
      this._immediateUpdate();
    }

    renderModal() {
      const { planeAin, immediateUpdate, downloadError } = this.state;
      const { isMandatory, modalVisible, updateInfo = {} } = this.props;
      return (
        <Modal
          animationType="none"
          transparent
          visible={modalVisible}
          onRequestClose={() => { }}
        >
          <TouchableOpacity style={styles.modal} activeOpacity={1} onPress={() => { isMandatory ? null : this.handleCloseModal(); }}>
            <View style={styles.modalContainer}>
              {
                isMandatory
                  ? null
                  : (
                    <View style={{ paddingBottom: 27, ...CommonStyles.flex_end }}>
                      <TouchableOpacity onPress={() => this.handleCloseModal()} activeOpacity={1}>
                        <Image source={require('../images/home/closeUpdate.png')} />
                      </TouchableOpacity>
                    </View>
                  )
              }
              {/* 检查是否在进行下载更新包 */}
              {
                !immediateUpdate
                  ? (
                    <TouchableOpacity activeOpacity={1} style={{ backgroundColor: '#fff', position: 'relative', borderRadius: 10 }}>
                      <Image fadeDuration={0} style={{ width: 295, position: 'relative', top: -27 }} source={require('../images/home/updateBgimg.png')} />
                      <View style={{
                        borderBottomLeftRadius: 15, borderBottomRightRadius: 15, position: 'relative', top: -20,
                      }}
                      >
                        <View style={{ paddingHorizontal: 25 }}>
                          <View style={[CommonStyles.flex_start, { backgroundColor: 'rgba(0,0,0,0)' }]}>
                            <Text style={{ marginBottom: 10, fontSize: 15, color: '#666' }}>更新内容</Text>
                          </View>
                          <Text style={{ lineHeight: 20, fontSize: 12, color: '#a1a1a1' }} numberOfLines={5}>{updateInfo.updateMessage}</Text>
                        </View>
                        {/* 判断是否是强制更新，显示不同按钮，现在修改为如果强制，不显示关闭按钮，否则显示 */}
                        <View style={{ marginVertical: 30, ...CommonStyles.flex_center }}>
                          <TouchableOpacity
                            onPress={() => { this._immediateUpdate(); }}
                            activeOpacity={1}
                          >
                            <Image fadeDuration={0} source={require('../images/home/update_btn.png')} />
                          </TouchableOpacity>
                        </View>
                      </View>
                    </TouchableOpacity>
                  )
                  : (
                    <TouchableOpacity activeOpacity={1} style={{ backgroundColor: '#fff', borderRadius: 10 }}>
                      <Image style={{ width: 295, position: 'relative', top: -27 }} fadeDuration={0} source={require('../images/home/updateBgimg.png')} />
                      <View style={{
                        backgroundColor: '#fff', borderBottomLeftRadius: 15, borderBottomRightRadius: 15, alignItems: 'center',
                      }}
                      >
                        <Progress
                            ref={dom => this.progressBar = dom}
                            progressColor="#89C0FF"
                            style={{
                              marginTop: 20,
                              height: 10,
                              width: 270,
                              backgroundColor: '#eee',
                              borderRadius: 10,
                            }}
                        />
                        <View style={{
                          position: 'absolute',
                          top: 20,
                          ...CommonStyles.flex_start,
                          width: 270,
                        }}
                        >
                          <Animated.View style={{
                            width: planeAin,
                            ...CommonStyles.flex_end,
                          }}
                          >
                            <Image
                                style={{
                                  width: 32, height: 20, position: 'relative', top: -5,
                                }}
                                source={require('../images/home/update_plane.png')}
                            />
                          </Animated.View>
                        </View>
                        {
                          downloadError
                            ? (
                              <View style={{ alignItems: 'center', marginVertical: 10 }}>
                                <Text style={{ fontSize: 14, color: '#999' }}>下载失败，请确定您的网络情况良好</Text>
                                <Button type="link" title="重新下载" titleStyle={{ fontSize: 14, color: '#ee6161' }} onPress={() => this.handleRedownload()} />
                              </View>
                            )
                            : (
                              <View style={{ alignItems: 'center', marginVertical: 20 }}>
                                <Text style={{ fontSize: 14, color: '#999' }}>版本正在努力更新中，请等待</Text>
                              </View>
                            )
                        }
                      </View>
                    </TouchableOpacity>
                  )
                }
            </View>
          </TouchableOpacity>
        </Modal>
      );
    }

    render() {
      return (
        <View style={styles.container}>
          {this.renderModal()}
        </View>
      );
    }
}

const styles = StyleSheet.create({
  container: {
    height: 0,
  },
  modal: {
    height,
    width,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  closeBtn: {
    width: 18,
    height: 18,
    borderRadius: 40,
    zIndex: 1,
  },
  closeWrap: {
    ...CommonStyles.flex_center,
    position: 'absolute',
    top: 45,
    right: 10,
    width: 24,
    height: 24,
    borderRadius: 40,
    zIndex: 1,
    backgroundColor: '#fff',
  },
  modalContainer: {

  },
});

export default connect((state) => {
  const upgradeInfo = state.upgrade.upgradeInfo || {};
  return {
    isMandatory: upgradeInfo.isMandatory || false,
    modalVisible: (upgradeInfo.modalVisible || false) && !state.system.isFirst,
    updateInfo: upgradeInfo.updateInfo || {},
  };
}, {
  saveUpgradeInfo: upgradeInfo => ({
    type: 'upgrade/save',
    payload: {
      upgradeInfo: { ...upgradeInfo },
    },
  }),
  readLaunchAppNotification: () => ({
    type: 'application/readLaunchAppNotification',
  }),
})(UpdateComModal);
