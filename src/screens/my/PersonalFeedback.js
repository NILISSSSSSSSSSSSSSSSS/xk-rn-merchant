 /**
 * 我的/意见反馈
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  Platform,
  View,
  Text,
  Keyboard,
  TouchableOpacity,
  Image,
  Button,
  ScrollView,
} from 'react-native';
import DeviceInfo from 'react-native-device-info';

import { connect } from 'rn-dva';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import CommonButton from '../../components/CommonButton';
import * as requestApi from '../../config/requestApi';
import * as nativeApi from '../../config/nativeApi';
import { getPreviewImage } from '../../config/utils';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import ActionSheet from '../../components/Actionsheet';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { NavigationComponent } from '../../common/NavigationComponent';
import { PickTypeEnum, TakeTypeEnum, TakeOrPickParams } from '../../const/application';
import * as regular from '../../config/regular'
const { width, height } = Dimensions.get('window');

class PersonalFeedback extends NavigationComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    this.state = {
      text: '', // 反馈内容
      phone: this.props.phone, // 反馈用户手机号
      imgsLists: [], // 上传图片的缩略图
      maxImgLen: 4, // 最大图片张数
      showBigPicVisible: false, // 是否查看大图
      bigIndex: 0, // 查看大图的索引
    };
  }

  blurState = {
    showBigPicVisible: false,
  }

  componentDidMount() { }

  changeState(key, value) {
    this.setState({
      [key]: value,
    });
  }

  _uploadPicture = (index, hasVideo) => {
    let { imgsLists } = this.state;
    const { maxImgLen } = this.state;
    const { takeOrPickImageAndVideo } = this.props;
    const takeType = hasVideo ? TakeTypeEnum.takeImage : TakeTypeEnum.takeImageOrVideo;
    const pickType = hasVideo ? PickTypeEnum.pickImage : PickTypeEnum.pickImageOrVideo;
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? takeType : pickType,
      totalNum: maxImgLen - imgsLists.length,
      duration: 180
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      imgsLists = imgsLists.concat(res);
      this.setState({ imgsLists });
    });
  };

  _deletePicture = (item) => {
    const data = this.state.imgsLists;
    console.log(data);
    for (let i = 0; i < data.length; i++) {
      if (item.url === data[i].url) {
        data.splice(i, 1);
      }
    }
    this.changeState('imgsLists', data);
  };

  submit = () => {
    Keyboard.dismiss();
    const { text, imgsLists, phone } = this.state;
    if (text === '' || text.length < 1) {
      Toast.show('请输入反馈内容！');
      return;
    }
    if (phone === '' || phone.length < 1) {
      Toast.show('请输入您的联系方式！');
      return;
    }
    if (!regular.phone(phone)) {
      Toast.show('请输入正确的联系方式！');
      return;
    }
    // 因为后台改了接口，现在调整上传图片的格式
    const imgVideos = imgsLists.map(item => ({ pic: item.type === 'video' ? item.cover : item.url, video: item.type === 'video' ? item.video || item.url : '' }));
    let params = {
      content: text,
      videos: imgVideos,
      app: 'ma',
      userType: 'muser',
      platform: 'ma',
      userPhone: phone,
      channel: Platform.OS === 'ios' ? 'appStore' : 'official', // 下载渠道 andorid official  ios appStore
      clientVersion: DeviceInfo.getVersion()
    };
    Loading.show();
    console.log('params',params)
    requestApi.requestPersonalFeedbackCreate(params, () => {
      Toast.show('意见反馈成功', 1000);
      this.props.navigation.goBack();
    });
  };

  componentWillUnmount() {
    super.componentWillUnmount();
    Loading.hide();
  }

  getPreviewPic = () => {
    const { imgsLists } = this.state;
    const temp = [];
    imgsLists.map((item) => {
      temp.push({ url: item.cover || item.url, type: 'images', });
    });
    return temp;
  }

  renderPreviewImg = () => {
    const { imgsLists, maxImgLen } = this.state;
    return (
      <React.Fragment>
        {
          imgsLists.map((item, index) => {
            console.log('item',item)
            if (index >= maxImgLen) return null;
            return (
              <TouchableOpacity
                key={item.cover || item.url}
                style={styles.img_item_box}
                onPress={() => { this.setState({ bigIndex: index, showBigPicVisible: true }) }}
              >
                <ImageView
                  style={styles.img_item}
                  source={{ uri: getPreviewImage(item.cover || item.url) }}
                  sourceWidth={60}
                  sourceHeight={60}
                  resizeMode="cover"
                />
                {
                  item.type === 'video' && (
                    <View style={{ height: '100%', width: '100%', position: 'absolute', ...CommonStyles.flex_center }}>
                      <Image style={{ width: 30, height: 30 }} source={require('../../images/index/video_play_icon.png')} />
                    </View>
                  )
                }
                <TouchableOpacity
                  style={styles.img_item_delete}
                  onPress={() => { this._deletePicture(item) }}
                >
                  <Image source={require('../../images/index/delete.png')}/>
                </TouchableOpacity>
              </TouchableOpacity>
            );
          })
        }
      </React.Fragment>
    )
  }
  getUploadImg = () => {
    return (
      <TouchableOpacity
        style={[styles.img_item_box]}
        onPress={() => {
          this.ActionSheet.show();
        }}
      >
        <Image style={styles.img_item} source={require('../../images/wm/upload_icon.png')}/>
      </TouchableOpacity>
    )
  }
  render() {
    const { navigation } = this.props;
    const { text, phone, imgsLists, maxImgLen, showBigPicVisible, bigIndex } = this.state;
    let disableBtn = !text || !regular.phone(phone); // 手机格式错误提交按钮置灰，不可点击     当意见内容小于1或者大于300个时，提交按钮置灰，
    let disableColor = disableBtn ? '#cdcdcd' : CommonStyles.globalHeaderColor;
    console.log('imgsLists', imgsLists);
    return (
      <View style={styles.container}>
        <Header navigation={navigation} goBack title="意见反馈"/>
        <ScrollView>
          <TouchableOpacity
            activeOpacity={1}
            onPress={() => {  Keyboard.dismiss();}}
            style={styles.contentView}
          >
            <View style={{ position: 'relative' }}>
              <TextInputView
                inputView={styles.textInputView}
                inputRef={(e) => { this.textInput = e }}
                style={styles.textInput}
                multiline
                maxLength={300}
                value={text}
                onBlur={() => { Keyboard.dismiss() }}
                placeholder="请发表您的宝贵意见，1~300文字以内～"
                placeholderTextColor="#999"
                onChangeText={(_text) => { this.changeState('text', _text.trim()) }}
              />
              <View style={[CommonStyles.flex_end]}>
                <View style={styles.fontNumView}>
                  <Text style={[CommonStyles.flex_start, styles.fontNum]}>
                    {`${text.length}/300`}
                  </Text>
                </View>
              </View>
            </View>
          </TouchableOpacity>
          <View style={[styles.imgsView]}>
            <Text style={[{ fontSize: 12, color: '#222', paddingLeft: 15, }]}>上传图像({ `${imgsLists.length}/4` })</Text>
            <View style={[CommonStyles.flex_start]}>
              {
                imgsLists.length !== 0 ? this.renderPreviewImg() : null
              }
              {
                imgsLists.length === 0 || imgsLists.length < maxImgLen ? this.getUploadImg() : null
              }
            </View>
            <View style={[CommonStyles.flex_end]}><Text style={[{ fontSize: 12, color: '#999',paddingTop: 10 }]}>视频最多上传1个且在3分钟内</Text></View>
          </View>
          {/* 手机号码 */}
          <View style={[CommonStyles.flex_between, styles.userPhoneView]}>
            <Text style={[{ fontSize: 14, color: '#222' }]}>手机号码</Text>
            <TextInputView
                inputView={styles.phoneInputView}
                inputRef={(e) => { this.phoneInput = e;}}
                style={styles.phoneInput}
                multiline
                maxLength={11}
                value={phone}
                onBlur={() => { Keyboard.dismiss()}}
                placeholder="请输入您的手机号码"
                placeholderTextColor="#999"
                keyboardType='numeric'
                rest={{ keyboardType: 'numeric' }}
                onChangeText={(_text) => {
                  console.log(_text);
                  this.changeState('phone', _text.trim());
                }}
              />
          </View>
          {/* 提示信息 */}
          <View style={[styles.userNoticeInfo]}>
            <Text style={[{ fontSize: 12, color: '#EE6161' }]}>*请留下手机号码，以便我们联系您!</Text>
          </View>
          <CommonButton title="提交" onPress={() => this.submit()} style={{ marginHorizontal:10, backgroundColor: disableColor, borderColor: disableColor, }} activeOpacity={disableBtn ? 1 : 0.65} />
        </ScrollView>
        
        {/* 选择上传方式 modal */}
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          options={['拍照', '相册', '取消']}
          cancelButtonIndex={2}
          onPress={(index) => {
            const hasVideo = imgsLists.find(item => item.type === 'video');
            if ([0, 1].includes(index)) {
              this._uploadPicture(index, hasVideo);
            }
          }}
        />
        {/* 查看大图 */}
        <ShowBigPicModal
          ImageList={imgsLists}
          visible={this.state.showBigPicVisible}
          showImgIndex={this.state.bigIndex}
          onClose={() => {
            this.setState({
              showBigPicVisible: false,
            });
          }}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  flex_center: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  contentView: {
    // ...CommonStyles.shadowStyle,
    borderRadius: 8,
    backgroundColor: '#fff',
    overflow: 'hidden',
    paddingBottom: 10,
    marginTop: 10,
    marginHorizontal: 10,
  },
  userPhoneView: {
    marginTop: 0,
    marginHorizontal: 10,
    marginBottom: 10,
    padding: 15,
    backgroundColor: '#fff',
    borderRadius: 8,
  },
  textInputView: {
    height: 155,
    padding: 15,
  },
  phoneInputView: {

  },
  textInput: {
    height: '100%',
    color: '#222',
    fontSize: 14,
    textAlignVertical: 'top',
  },
  phoneInput: {
    height: '100%',
    textAlignVertical: 'center',
    color: '#555',
    fontSize: 14,
    textAlign: 'right'
  },
  imgsView: {
    backgroundColor: '#fff',
    borderRadius: 8,
    margin: 10,
    padding: 15,
    paddingLeft: 0,
  },
  img_item_box: {
    position: 'relative',
    width: 60,
    height: 60,
    marginTop: 10,
    marginLeft: 15,
    // borderWidth: 0.5,
    // borderColor: "#f1f1f1",
    // borderRadius: 6
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
  submitView: {
    // ...CommonStyles.shadowStyle,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: width - 20,
    // height: 44,
    paddingVertical: 14,
    marginHorizontal: 10,
    borderRadius: 8,
    backgroundColor: '#4A90FA',

  },
  submitView_text: {
    fontSize: 17,
    color: '#fff',
  },
  modal: {
    // height: 342,
    flex: 1,

    backgroundColor: 'rgba(10,10,10,.5)',
    position: 'relative',
  },
  modalContent: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    width,
    backgroundColor: '#fff',
  },
  color_red: {
    color: '#EE6161',
  },
  modalItemText: {
    fontSize: 17,
    color: '#222',
  },
  modalItem: {
    paddingVertical: 15,
    width,
    position: 'relative',
  },
  marginTop: {
    marginTop: 5,
  },
  borderBottom: {
    borderBottomColor: '#f1f1f1',
    borderBottomWidth: 1,
  },
  block: {
    width,
    height: 5,
    backgroundColor: '#F1F1F1',
    position: 'absolute',
    top: 0,
    left: 0,
  },
  flex_end: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
  },
  flex_start: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
  fontNumView: {
    // backgroundColor: "rgba(0,0,0,.2)"
    paddingRight: 15,
    paddingBottom: 11,
  },
  fontNum: {
    fontSize: 14,
    color: '#999',
  },
  userNoticeInfo: {
    paddingLeft: 25,
    paddingTop: 5,
  },
});

export default connect(
  state => ({ phone: state.user.user.phone }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(PersonalFeedback);
