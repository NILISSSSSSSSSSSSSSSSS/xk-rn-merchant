// 点击图片查看大图

import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    Dimensions,
    SafeAreaView,
    View,
    Text,
    Button,
    Image,
    Modal,
    ActivityIndicator,
    Platform,
    TouchableHighlight,
    TouchableOpacity,
} from 'react-native';
import Swiper from 'react-native-swiper';
import ImageView from './ImageView';
const { width, height } = Dimensions.get('window');
import Video from 'react-native-video';
import CommonStyles from '../common/Styles';
import PhotoView from 'react-native-photo-view-ex';
import LoadingAnim from './Loading';
export default class ShowBigPicModal extends Component {
  static defaultProps = {
    ImageList: [], // eg: [{type:'images', url: ''},{type:'video', url: ''}]
    onClose: () => { },
    showImgIndex: 0,
    isShowPage: false,
    visible: false,
    callback:()=>{},
    childrenStyles:{top:CommonStyles.headerPadding,left:10},
  }
  state = {
    paused: true,
    showErrorInfo: false,
    showLoading: true, // 加载动画显示
  }
  player = null ;
  resetVideo = (callBack = () => {}) => {
    this.player && this.player.seek(0);
    this.setState({
      paused: true,
      showErrorInfo:false,
    }, () => {
      callBack();
    });
  }
  // 如果是商品详情，显示页码
  _renderPagination = (index, total, context) => {
    return (
      <View style={[CommonStyles.flex_start,styles.showPageWrap]}>
        <View style={[styles.paginationStyle,CommonStyles.flex_1]}>
          <Text style={{ color: 'white',textAlign: 'center' }}>
          <Text style={styles.paginationText}>{index + 1}</Text>/{total}
          </Text>
        </View>
      </View>
    );
    }
  _renderGoBack = () => {
    const { onClose } = this.props;
    return (
      // <View style={[CommonStyles.flex_start,styles.iosGoBackBtn]}>
        <TouchableOpacity style={styles.back} activeOpacity={0.7} onPress={() => { this.resetVideo(onClose); }}>
          <Image source={require('../images/mall/goback_gray.png')} />
        </TouchableOpacity>
      // </View>
    );
  }
  changeState = (key = '', value = '') => {
    this.setState({
      [key]: value,
    });
  }
  componentWillunmount(){
    this.timer.clearTimeout();
  }
  renderChildren=(item,index)=>{
    return (
      <View style={[{position:'absolute'},this.props.childrenStyles]}>
        {this.props.children}
      </View>
    );
  }
  handleShowPage = () => {
    const { ImageList, showImgIndex} = this.props;
    let bool = true;
    if (ImageList.length > 0) {
      bool = !(Platform.OS === 'ios' && ImageList[showImgIndex].type === 'video');
    }
    this.setState({ platformShowPage: bool });
  }
  handleShowLoading = (index, showImgIndex, status) => {
    index === showImgIndex && this.setState({ showLoading: status })
  }
  render() {
    const { ImageList, onClose, visible, showImgIndex,isShowPage ,callback} = this.props;
    const { paused,showErrorInfo,showLoading, platformShowPage } = this.state;
    console.log('ImageList',ImageList)
    return (
      <Modal
        animationType="fade"
        transparent={true}
        visible={visible}
        onRequestClose={() => {
          this.resetVideo(onClose);
        }}
        // presentationStyle="fullScreen"
        onShow={() => { }}
        // style={styles.modal}
      >
        <Swiper
          autoplay={false}
          dotStyle={styles.banner_dot}
          loop={false}
          index={showImgIndex}
          activeDotStyle={styles.banner_activeDot}
          renderPagination={(isShowPage && platformShowPage) ? this._renderPagination : null}
          onIndexChanged={(index) => {
            callback(index);
            this.resetVideo();
            this.handleShowPage();
          }}
        >
          {
            ImageList && ImageList.length !== 0 && ImageList.map((item, index) => {
              if (item.type === 'images') {
                return (
                  <TouchableOpacity
                    key={index}
                    style={styles.bigImage}
                    onPress={() => {
                      if (showLoading) { this.resetVideo(onClose); }
                    }}
                    activeOpacity={1}
                  >
                  {
                    //显示返回bar
                    this._renderGoBack()
                  }
                  <PhotoView
                    scale={1}
                    source={{uri: item.url}}
                    minimumZoomScale={Platform.OS === 'ios' ? 0.8 : 0.5}
                    maximumZoomScale={3}
                    androidScaleType="centerCrop"
                    onLoad={() => console.log('Image loaded!')}
                    style={{width, height,position:'absolute'}}
                    onLoadStart={(e) => {
                      console.log('onLoadStart');
                      this.handleShowLoading(index, showImgIndex, true)
                    }}
                    onViewTap={() => {
                      this.resetVideo(onClose);
                    }}
                    onLoadEnd={(status) => {
                      console.log('onLoadEnd');
                      this.handleShowLoading(index, showImgIndex, false)
                    }}
                    onError={() => {
                      console.log('地址错误',item.url);
                    }}
                  />
                  {/* <View style={[CommonStyles.flex_1,{position:'absolute',top: 0, left: 0,zIndex:1000,width,height: 100,backgroundColor:'red'}]}> */}
                    {this.renderChildren(item,index)}
                  {/* </View> */}
                  </TouchableOpacity>
                );
              }
              if (item.type === 'video') {
                return (
                  <React.Fragment key={index}>
                    {
                      //显示返回bar
                      !(Platform.OS === 'ios') && this._renderGoBack()
                    }
                    {/* 显示播放按钮 */}
                    {
                      paused && !showErrorInfo && !showLoading && item.url && !(Platform.OS === 'ios')
                      ?
                      <TouchableOpacity style={styles.playBtn} onPress={() => {
                        this.changeState('paused',false);
                      }} activeOpacity={1}>
                        <Image style={{position: 'absolute',top: 8.5,left:8.5,width: 70,height: 70}} source={require('../images/index/video_play_icon.png')} />
                      </TouchableOpacity>
                      : null
                    }
                    {/* 显示错误提示 */}
                    {
                      showErrorInfo || !item.url
                      ? <TouchableOpacity style={styles.playBtnWrap} onPress={() => { onClose(); this.changeState('showErrorInfo',false); }}>
                        <Text style={{color: '#fff'}}>视频解析错误！</Text>
                      </TouchableOpacity>
                      : null
                    }
                    <TouchableOpacity
                      key={index}
                      style={[styles.bigImage]}
                      onPress={() => { }}
                      activeOpacity={1}
                    >
                      {
                        (Platform.OS === 'ios') && <TouchableOpacity style={styles.iosCloseBtn} onPress={() => {onClose();}} />
                      }
                      <Video source={{uri:item.url}}
                        ref={(ref) => { this.player = ref; }}
                        rate={Platform.OS === 'ios' ? (paused) ? 0 : 1 : 1} // Store reference,设为0安卓会报错
                        // poster={item.mainPic}
                        // posterResizeMode='center'
                        resizeMode="contain"
                        style={{width,height}}
                        // style={{width: videoWidth,height:videoHieght}}
                        paused={paused}
                        repeat={true}
                        onLoadStart={() => {
                          item.url 
                          ? this.handleShowLoading(index, showImgIndex, true)
                          : this.setState({ showLoading: false, showErrorInfo:true });
                        }}
                        onLoad={(e) => {
                          console.log('video load end');
                          this.handleShowLoading(index, showImgIndex, false)
                        }}
                        onError={(error) => {
                          console.log('error',error);
                          this.changeState('showErrorInfo',true);
                        }}
                        onEnd={() => {
                          this.changeState('paused',true);
                        }}
                      >
                        {this.renderChildren(item,index)}
                      </Video>
                    </TouchableOpacity>
                  </React.Fragment>
                );
              }
            })
          }
        </Swiper>
        {
          // 加载动画
          showLoading && <LoadingAnim visible={showLoading} />
        }
      </Modal>
    );
  }
}

const styles = StyleSheet.create({
    modal: {
        flex: 1,
        width,
        backgroundColor: 'green',
    },
    bigImage: {
        backgroundColor: 'rgba(0, 0, 0, 1)',
        flex:1,
        justifyContent: 'center',
        alignItems: 'center',
        position: 'relative',
    },
    banner_activeDot: {
        width: 12,
        height: 4,
        borderRadius: 10,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: 20,
        backgroundColor: '#fff',
    },
    banner_dot: {
        width: 4,
        height: 4,
        borderRadius: 4,
        marginLeft: 1.5,
        marginRight: 1.5,
        marginBottom: 20,
        backgroundColor: '#fff',
    },
    playBtn: {
        position: 'absolute',
        zIndex: 10,
        // borderRadius: 10,
        textAlign: 'center',
        paddingVertical: 10,
        paddingHorizontal: 18,
        left: (width - 87) / 2,
        top: (height - 87) / 2,
        width: 87,
        height: 87,
        // backgroundColor: 'red'
        // borderWidth: 1,
        // borderColor: '#f1f1f1',
    },
    playBtnWrap: {
        position: 'absolute',
        flex: 1,
        width,
        height,
        zIndex: 100,
        ...CommonStyles.flex_center,
    },
    paginationText: {
        color: 'white',
        fontSize: 20,
        textAlign: 'center',
    },
    paginationStyle: {
        ...CommonStyles.flex_center,
    },
    showPageWrap: {
        position: 'absolute',
        bottom: (CommonStyles.footerPadding === 0) ? 0 : CommonStyles.footerPadding,
        right: 0,
        width,
        height: 50,
        backgroundColor: 'rgba(10,10,10,0.5)',
    },
    back:{
        height:50,
        width: 50,
        position:'absolute',
        top: CommonStyles.headerPadding,
        justifyContent:'center',
        left: 0,
        zIndex: 11,
        paddingLeft: 17,
    },
    iosCloseBtn: {
        position: 'absolute',
        top: 10 + CommonStyles.headerPadding,
        left: 30,
        height: 40,
        width: 55,
        zIndex: 10,
    },
});
