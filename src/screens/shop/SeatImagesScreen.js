/**
 * 席位管理/包间图片
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  TouchableOpacity,
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import * as utils from '../../config/utils';
import ImageView from '../../components/ImageView';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { NavigationComponent } from '../../common/NavigationComponent';
import { TakeOrPickParams, TakeTypeEnum, PickTypeEnum } from '../../const/application';
import ActionSheet from '../../components/Actionsheet';

const { width, height } = Dimensions.get('window');

const imageWidth = 100;

class SeatImagesScreen extends NavigationComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    const params = this.props.navigation.state.params || {};
    this.state = {
      quantity: 0,
      data: params.data || { images: [] },
      callback: params.callback || (() => { }),
      showBigPicArr: [],
      showIndex: 0,
      showBigModal: false,
    };
  }

  blurState = {
    showBigModal: false,
  }

  save = () => {
    const { data, callback } = this.state;
    Loading.show();
    requestApi
      .mSeatUpdate(data)
      .then((res) => {
        callback(data.images);
        Toast.show('修改成功');
        this.props.navigation.goBack();
      })
      .catch((res) => {
        console.log(res);
      });
  };

  deleteImg = (image, index) => {
    const newImages = [];
    const images = this.state.data.images;
    for (let i = 0; i < images.length; i++) {
      i == index ? null : newImages.push(images[i]);
    }
    this.setState({
      data: {
        ...this.state.data,
        images: newImages,
      },
    });
  };

  addImage = (index) => {
    const { takeOrPickImageAndVideo } = this.props;
    const { data } = this.state;
    const showPics = data.images || [];
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
      totalNum: 9 - showPics.length,
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      this.setState({
        data: {
          ...data,
          images: showPics.concat(res.map(item => item.url)),
        },
      });
    });
  };

  showBigImg = ( index) => {
    const { data } = this.state;
    const temp = [];
    data.images.map((item) => {
      temp.push({
        type: 'images',
        url: item,
      });
    });
    this.setState({
      showBigPicArr: temp,
      showIndex: index,
      showBigModal: true,
    });
  }

  renderImage = (valueImage, index) => (
    <TouchableOpacity key={index} style={[styles.imageViewTouch, { position: 'relative' }]} key={index} onPress={() => this.showBigImg(index)}>
      <View style={{
        width: imageWidth, height: imageWidth, borderRadius: 5, overflow: 'hidden'
      }}>
        <ImageView resizeMode="cover" source={{ uri: utils.getPreviewImage(valueImage) }} sourceWidth={imageWidth} sourceHeight={imageWidth} />
      </View>
      <TouchableOpacity
        onPress={() => this.deleteImg(valueImage, index)}
        style={{ position: 'absolute', top: -5, right: -5 }}
      >
        <ImageView
          source={require('../../images/index/delete.png')}
          sourceWidth={20}
          sourceHeight={20}
        />
      </TouchableOpacity>
    </TouchableOpacity>
  )

  renderAddImage = () => (
    <TouchableOpacity style={styles.imageViewTouch} onPress={() => this.ActionSheet.show()}>
      <ImageView source={require('../../images/index/add_pic.png')} sourceWidth={imageWidth} sourceHeight={imageWidth} />
    </TouchableOpacity>
  )

  render() {
    const { navigation } = this.props;
    const {
      data, showBigPicArr, showIndex, showBigModal,
    } = this.state;
    const disabled = data.images.length === 0;
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack
          title={`包间-${data.name}`}
          headerStyle={{ width }}
          rightView={(
            <TouchableOpacity onPress={() => !disabled && this.save()} style={{ width: 50 }}>
              <Text style={{ fontSize: 17, color: !disabled ? '#fff' : 'gray' }}>保存</Text>
            </TouchableOpacity>
          )}
        />
        <View style={{ alignItems: 'center', marginTop: 10 }}>
          <View style={styles.imagesContainer}>
            {data.images.map((valueImage, index) => this.renderImage(valueImage, index))}
            {data.images.length == 9 ? null : this.renderAddImage()}
            {data.images.length % 3 === 1 && data.images.length < 9 ? <View style={styles.imageViewTouch} /> : null}
          </View>
        </View>
        <ShowBigPicModal
          ImageList={showBigPicArr}
          visible={showBigModal}
          showImgIndex={showIndex}
          onClose={() => {
            this.setState({
              showBigModal: false,
            });
          }}
        />
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          // title={'Which one do you like ?'}
          options={['拍照', '相册', '取消']}
          cancelButtonIndex={2}
          // destructiveButtonIndex={2}
          onPress={(index) => {
            if (index != 2) {
              this.addImage(index);
            }
          }}
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
  imageViewTouch: {
    width: imageWidth,
    height: imageWidth,
    marginVertical: 10,
  },
  delete: {
    position: 'absolute',
    top: 0,
    right: 0,
  },
  delTextContainer: {
    width: 84,
    backgroundColor: '#EE6161',
    alignItems: 'center',
    justifyContent: 'center',
  },
  deleteTextStyle: {
    color: '#fff',
    fontSize: 14,
  },
  bigImage: {
    backgroundColor: 'rgba(0, 0, 0, 1)',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  imagesContainer: {
    flexDirection: 'row',
    width: width - 20,
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    backgroundColor: '#fff',
    borderRadius: 5,
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
});

export default connect(
  state => ({
    userShop: state.user.userShop || {},
  }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(SeatImagesScreen);
