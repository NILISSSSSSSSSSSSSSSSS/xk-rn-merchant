 /**
 * 意见反馈
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

const { width, height } = Dimensions.get('window');

class FeedbackScreen extends NavigationComponent {
    static navigationOptions = {
      header: null,
    };

    constructor(props) {
      super(props);
      this.state = {
        // goodsData存在则是商品意见反馈，否则是用户意见反馈
        goodsData:
                (props.navigation.state.params
                    && props.navigation.state.params.goodsData)
                || null, // 商品信息
        qiniuToken: null,
        text: '',
        imgsLists: [],
        maxImgLen: 9, // 最大图片张数
        showBigPicVisible: false,
        bigIndex: 0,

      };
      requestApi.requestQiniuToken().then((res) => {
        this.setState({
          qiniuToken: res,
        });
      }).catch((err) => {
        console.log(err);
      });
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
      const { goodsData, text, imgsLists } = this.state;
      if (text === '' || text.length < 6) {
        Toast.show('请输入最少6字反馈内容！');
        return;
      }
      // 因为后台改了接口，现在调整上传图片的格式
      const imgVideos = imgsLists.map(item => ({ pic: item.type === 'video' ? item.cover : item.url, video: item.type === 'video' ? item.video || item.url : '' }));
      let params = {
        content: text,
        videos: imgVideos,
        app: 'ma',
      };
      let submitRequest = null;
      if (goodsData) {
        params = {
          ...params,
          goodsId: goodsData.id,
          goodsName: goodsData.name,
        };
        submitRequest = requestApi.requestGoodsFeedbackCreate;
      } else {
        params = {
          ...params,
          userType: 'muser',
          platform: 'ma',
        };
        submitRequest = requestApi.requestPersonalFeedbackCreate;
      }

      Loading.show();
      if (submitRequest) {
        submitRequest(params, () => {
          Toast.show('意见反馈成功', 1000);
          this.props.navigation.goBack();
        });
      }
    };

    componentWillUnmount() {
      super.componentWillUnmount();
      Loading.hide();
    }

    getPreviewPic = () => {
      const { imgsLists } = this.state;
      const temp = [];
      imgsLists.map((item) => {
        temp.push({
          url: item.cover || item.url,
          type: 'images',
        });
      });
      return temp;
    }

    render() {
      const { navigation } = this.props;
      const {
        text, imgsLists, maxImgLen, showBigPicVisible, bigIndex, goodsData,
      } = this.state;
      console.log('imgsLists', imgsLists);
     
      return (
        <View style={styles.container}>
          <Header
            navigation={navigation}
            goBack
            title="意见反馈"
          />
          <TouchableOpacity
            activeOpacity={1}
            onPress={() => {
              Keyboard.dismiss();
            }}
            style={styles.contentView}
          >
            <View style={{ position: 'relative' }}>
              <TextInputView
                inputView={styles.textInputView}
                inputRef={(e) => {
                  this.textInput = e;
                }}
                style={styles.textInput}
                multiline
                maxLength={500}
                value={text}
                onBlur={() => {
                  Keyboard.dismiss();
                }}
                placeholder="请输入反馈内容..."
                placeholderTextColor="#999"
                onChangeText={(_text) => {
                  console.log(_text);
                  this.changeState('text', _text.trim());
                }}
              />
              <View style={[CommonStyles.flex_end]}>
                <View style={styles.fontNumView}>
                  <Text
                    style={[styles.flex_start, styles.fontNum]}
                  >
                    {`${text.length}/500`}
                  </Text>
                </View>
              </View>
            </View>
            <View style={styles.imgsView}>
              {imgsLists.length !== 0
              && imgsLists.map((item, index) => {
                console.log('iem',item)
                if (index >= maxImgLen) return null;
                return (
                  <TouchableOpacity
                    key={item.cover || item.url}
                    style={styles.img_item_box}
                    onPress={() => {
                      this.setState({ bigIndex: index, showBigPicVisible: true });
                    }}
                  >
                    <ImageView
                      style={styles.img_item}
                      source={{ uri: getPreviewImage(item.cover || item.url) }}
                      sourceWidth={60}
                      sourceHeight={60}
                      resizeMode="cover"
                    />
                    {
                      item.type === 'video'
                        ? (
                          <View style={{
                            height: '100%', width: '100%', position: 'absolute', ...CommonStyles.flex_center,
                          }}
                          >
                            <Image style={{ width: 30, height: 30 }} source={require('../../images/index/video_play_icon.png')} />
                          </View>
                        )
                        : null
                    }
                    <TouchableOpacity
                      style={styles.img_item_delete}
                      onPress={() => {
                        this._deletePicture(item);
                      }}
                    >
                      <Image
                        source={require('../../images/index/delete.png')}
                      />
                    </TouchableOpacity>
                  </TouchableOpacity>
                );
              })}
              {imgsLists.length === 0
                || imgsLists.length < maxImgLen ? (
                  <TouchableOpacity
                        style={styles.img_item_box}
                        onPress={() => {
                          this.ActionSheet.show();
                        }}
                  >
                    <Image
                      style={styles.img_item}
                      source={require('../../images/order/upload_pic.png')}
                    />
                  </TouchableOpacity>
                ) : null}
            </View>
          </TouchableOpacity>
          <CommonButton title="确认提交" onPress={() => this.submit()} style={{ marginTop: 15 }} />
          {/* 选择上传方式 modal */}
          <ActionSheet
            ref={o => (this.ActionSheet = o)}
            // title={'Which one do you like ?'}
            options={['拍照', '相册', '取消']}
            cancelButtonIndex={2}
            // destructiveButtonIndex={2}
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
    alignItems: 'center',
  },
  flex_center: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  contentView: {
    // ...CommonStyles.shadowStyle,
    width: width - 20,
    borderRadius: 6,
    backgroundColor: '#fff',
    overflow: 'hidden',
    paddingBottom: 10,
    marginTop: 10,
  },
  textInputView: {
    height: 155,
    padding: 15,
  },
  textInput: {
    height: '100%',
    textAlignVertical: 'top',
  },
  imgsView: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
    justifyContent: 'flex-start',
    borderTopWidth: 1,
    borderTopColor: '#E5E5E5',
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
    paddingBottom: 15,
  },
  fontNum: {
    fontSize: 14,
    color: '#999',
  },
});

export default connect(
  state => ({ store: state }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(FeedbackScreen);
