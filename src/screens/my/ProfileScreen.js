/*
 *个人资料
   */
import React, { Component } from 'react';
import {
  Text, View, StyleSheet, ScrollView, Dimensions, Modal, TouchableOpacity, StatusBar,
} from 'react-native';
import { connect } from 'rn-dva';

import moment from 'moment';
import * as requestApi from '../../config/requestApi';
import * as nativeApi from '../../config/nativeApi';
import { Validator } from '../../utils/validate-form';
import List, { ListItem, Splitter } from '../../components/List';
import {
  ExtraImage, ExtraAvatar, ExtraTextInput, ExtraDatePicker, ExtraGenderPicker, ExtraDistrictPicker,
} from '../../components/ListExtras';
import Header from '../../components/Header';
import Picker from '../../components/Picker';
import ActionSheet from '../../components/Actionsheet';

import Button from '../../components/Button';
import { qiniuUrlAdd } from '../../config/utils';
import { NavigationComponent } from '../../common/NavigationComponent';
import * as Address from '../../const/address';
import ListEmptyCom from '../../components/ListEmptyCom';
import {
  TakeOrPickCropEnum, TakeTypeEnum, PickTypeEnum, TakeOrPickParams,
} from '../../const/application';
import TextInputView from '../../components/TextInputView';

const { width, height } = Dimensions.get('window');

class ProfileScreen extends NavigationComponent {
    state = {
      textInputModalError: {},
      textInputModalVisible: false,
      textInputModalForm: {
        field: 'default',
        value: '',
        placeholder: '',
        title: '',
      },
    }

    blurState = {
      textInputModalVisible: false,
    }

    rules = [
      { field: 'nickname', required: true, msg: '昵称不能为空' },
      {
        field: 'nickname', min: 1, max: 10, msg: '昵称不超过10个字',
      },
      { field: 'signature', required: true, msg: '签名不能为空' },
      {
        field: 'signature', min: 1, max: 16, msg: '签名不超过16个字',
      },
    ]

    componentDidMount() {
      this.fetchProfile();
    }

    screenDidFocus = (payload) => {
      super.screenDidFocus(payload);
      StatusBar.setBarStyle('dark-content');
    }

    screenWillBlur = (payload) => {
      super.screenWillBlur(payload);
      StatusBar.setBarStyle('light-content');
    }

    fetchProfile() {
      const { userInfo = {} } = this.props;
      const mUserId = global.nativeProps ? global.nativeProps.userId : userInfo.id;
      this.props.fetchProfile(mUserId);
    }

    saveFieldValue = ({ field, value }) => {
      const { updateProfile } = this.props;
      const rules = this.rules.filter(rule => rule.field === field);
      const validator = new Validator(rules).validate({ [field]: value });
      if (!validator.validate) {
        this.setState({
          textInputModalError: { [field]: validator.msg },
        });
        return;
      }
      updateProfile(field, value, (isSuccess) => {
        if (isSuccess) {
          this.setState({
            textInputModalVisible: false,
            textInputModalError: {},
          });
        } else {
          this.setState({
            textInputModalError: { [field]: '保存失败' },
          });
        }
      });
    }

    _createDateData1=() => {
      const date = [];
      const fullYear = this.fullYear;
      const fullMonth = this.fullMonth;
      const fullDay = this.fullDay;
      for (let i = fullYear - 100; i <= fullYear; i++) {
        const month = [];
        for (let j = 1; j < (i == fullYear ? fullMonth + 1 : 13); j++) {
          const day = [];
          const nowDays = i == fullYear && j == fullMonth ? fullDay : 99;
          if (j === 2) {
            for (let k = 1; k < Math.min(29, nowDays + 1); k++) {
              day.push(`${k}日`);
            }
            // Leap day for years that are divisible by 4, such as 2000, 2004
            if (i % 4 === 0) {
              day.push(`${29}日`);
            }
          } else if (j in {
            1: 1, 3: 1, 5: 1, 7: 1, 8: 1, 10: 1, 12: 1,
          }) {
            for (let k = 1; k < Math.min(32, nowDays + 1); k++) {
              day.push(`${k}日`);
            }
          } else {
            for (let k = 1; k < Math.min(31, nowDays + 1); k++) {
              day.push(`${k}日`);
            }
          }
          const _month = {};
          _month[`${j}月`] = day;
          month.push(_month);
        }
        const _date = {};
        _date[`${i}年`] = month;
        date.push(_date);
      }
      console.log(date);
      return date;
    }

    _uploadPicture = (index) => {
      const { takeOrPickImageAndVideo } = this.props;
      const params = new TakeOrPickParams({
        func: index === 0 ? 'take' : 'pick',
        type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
        crop: TakeOrPickCropEnum.Crop,
        totalNum: 1,
      });
      takeOrPickImageAndVideo(params.getOptions(), (res) => {
        this.saveFieldValue({ field: 'avatar', value: res[0].url });
      });
    };

    handleDatePicker = ({ field, value }) => {
      const today = new Date();
      this.fullYear = today.getFullYear();
      this.fullMonth = today.getMonth() + 1;
      this.fullDay = today.getDate();
      const defaultDate = value == null ? moment()._d : moment(value, 'YYYY-MM-DD')._d;
      console.log(defaultDate);
      Picker._showDatePicker((date) => {
        console.log(field, date);
        this.saveFieldValue({ field, value: moment(date, 'YYYY-MM-DD').valueOf() / 1000 });
      }, this._createDateData1, defaultDate);
    }

    handleAreaPicker = ({ field, value }) => {
      Picker._showAreaPicker((data = {}) => {
        const districtCode = data.codes.length >= 3 ? data.codes[2] : '';
        console.log(data, districtCode);
        this.saveFieldValue({ field, value: districtCode });
      }, Address.getNamesByDistrictCode(value));
    }

    handleTextInput = ({ field, value }, title, placeholder) => {
      this.setState({
        textInputModalForm: {
          field, value, title, placeholder,
        },
        textInputModalVisible: true,
      });
    }

    handleModalSave = () => {
      const { textInputModalForm } = this.state;
      this.saveFieldValue(textInputModalForm);
    }

    renderTextInputModal = () => {
      const { textInputModalForm, textInputModalError, textInputModalVisible } = this.state;
      const errorText = textInputModalError[textInputModalForm.field];
      return (
        <Modal
          transparent
          visible={textInputModalVisible}
          onRequestClose={() => {}}
        >
          <TouchableOpacity style={styles.modalBack} onPress={() => this.setState({ textInputModalVisible: false })} activeOpacity={1}>
            <TouchableOpacity style={styles.modalContent} activeOpacity={1}>
              <View style={styles.modalHeader}>
                <Text style={styles.modalTitle}>{textInputModalForm.title}</Text>
              </View>
              <View style={styles.modalBody}>
                <TextInputView
                  inputView={styles.textInputView}
                  style={styles.textInput}
                  placeholder={textInputModalForm.placeholder}
                  value={textInputModalForm.value}
                  onChangeText={text => this.setState({
                    textInputModalForm: {
                      ...textInputModalForm,
                      value: text,
                    },
                  })}
                />
                <Text style={!errorText ? { height: 0 } : { color: 'red' }}>{errorText}</Text>
              </View>
              <View style={styles.buttons}>
                <Button titleStyle={{ fontSize: 15 }} title="取消" type="link" onPress={() => this.setState({ textInputModalVisible: false })} />
                <Button titleStyle={{ fontSize: 15 }} title="保存" type="link" style={{ marginLeft: 40 }} onPress={() => this.handleModalSave()} />
              </View>
            </TouchableOpacity>
          </TouchableOpacity>
        </Modal>
      );
    }

    render() {
      const { navigation, profile, loading } = this.props;
      const code = profile.code || 200;
      const birthday = profile.birthday == null ? profile.birthday : moment(profile.birthday * 1000).format('YYYY-MM-DD');
      const disabled = !!global.nativeProps;

      return (
        <View style={{ flex: 1 }}>
          <Header
            headerStyle={styles.header}
            title="个人资料"
            onBack={() => global.nativeProps && nativeApi.popToNative()}
            goBack
            navigation={navigation}
            backStyle={{ tintColor: '#222' }}
            titleTextStyle={{ color: '#222' }}
          />
          <ScrollView style={styles.contentContainer}>
            {
              loading ? null : code === 200 ? (
                <List style={styles.list}>
                  <ListItem
                    style={styles.listItem}
                    extraContainerStyle={styles.extraContainer}
                    title="用户头像"
                    onExtraPress={() => this.ActionSheet.show()}
                    extra={<ExtraAvatar disabled={disabled} field="avatar" value={profile.avatar} onPress={() => this.ActionSheet.show()} />}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    extraContainerStyle={styles.extraContainer}
                    title="昵称"
                    onExtraPress={() => this.handleTextInput({ field: 'nickname', value: profile.nickname }, '修改昵称', '1-10个字符')}
                    extra={<ExtraTextInput disabled={disabled} field="nickname" value={profile.nickname || profile.realName} onPress={() => this.handleTextInput({ field: 'nickname', value: profile.nickname }, '修改昵称', '1-10个字符')} />}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    title="生日"
                    extra={<ExtraDatePicker style={{ width: 200, paddingVertical: 10 }} disabled={disabled} field="birthday" value={birthday} onPress={formItem => this.handleDatePicker(formItem)} />}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    extraContainerStyle={styles.extraContainer}
                    title="年龄"
                    extra={String(profile.age || '暂无')}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    extraContainerStyle={styles.extraContainer}
                    title="性别"
                    extra={<ExtraGenderPicker disabled field="sex" value={profile.sex} onPress={formItem => console.log('调用修改性别接口')} />}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    extraContainerStyle={styles.extraContainer}
                    title="安全码"
                    extra={String(profile.securityCode || '')}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    title="地址"
                    extra={<ExtraDistrictPicker style={{ width: 200, paddingVertical: 10 }} disabled={disabled} field="districtCode" value={Address.getNamesByDistrictCode(profile.districtCode)} onPress={formItem => this.handleAreaPicker({ field: 'districtCode', value: profile.districtCode })} />}
                  />
                  <Splitter />
                  <ListItem
                    style={styles.listItem}
                    horizontal={false}
                    title="签名"
                    extraContainerStyle={styles.extraContainer2}
                    onExtraPress={() => this.handleTextInput({ field: 'signature', value: profile.signature }, '修改签名', '1-16个字符')}
                    extra={<ExtraTextInput disabled={disabled} field="signature" value={profile.signature} placeholder="简单介绍一下自己…" onPress={formItem => this.handleTextInput({ field: 'signature', value: profile.signature }, '修改签名', '1-16个字符')} />}
                  />
                </List>
              ) : <View style={{ marginTop: 71 }}><ListEmptyCom type="Hide_Profile" title="对方隐藏了个人资料" /></View>
            }
          </ScrollView>
          <ActionSheet
            ref={o => (this.ActionSheet = o)}
            // title={'Which one do you like ?'}
            options={['拍照', '相册', '取消']}
            cancelButtonIndex={2}
            // destructiveButtonIndex={2}
            onPress={(index) => {
              if (index != 2) {
                this._uploadPicture(index);
              }
            }}
          />
          {this.renderTextInputModal()}
        </View>
      );
    }
}

const styles = StyleSheet.create({
  contentContainer: {
    backgroundColor: '#fff',
  },
  list: {
    marginHorizontal: 25,
    width: width - 50,
  },
  header: {
    backgroundColor: '#FFF',
    borderColor: 'rgba(0,0,0,0.08)',
    borderWidth: 1,
  },
  modalBack: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.3)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    width: 270,
    paddingHorizontal: 15,
    backgroundColor: '#fff',
    borderRadius: 6,
  },
  modalHeader: {
    paddingVertical: 25,
  },
  buttons: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
  },
  listItem: {
    paddingVertical: 15,
  },
  modalTitle: {
    fontSize: 17,
    color: '#000',
  },
  textInputView: {
    paddingBottom: 15,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(0,0,0,0.06)',
    height: 'auto',
  },
  textInput: {
    color: '#999',
    fontSize: 15,
    flex: 0,
  },
  extraContainer: {
    paddingVertical: 10,
    minWidth: 200,
    marginLeft: 10,
  },
  extraContainer2: {
    width: width - 25 * 2,
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'flex-start',
    paddingVertical: 10,
    minHeight: 40,
  },
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    profile: state.my.profile || {},
    loading: state.loading.effects['my/fetchProfile'],
  }),
  {
    fetchProfile: mUserId => ({ type: 'my/fetchProfile', payload: { mUserId } }),
    updateProfile: (field, value, callback) => ({ type: 'my/updateProfile', payload: { field, value, callback } }),
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(ProfileScreen);
