/**
 * 席位管理/新增席位
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
import ScrollableTabView from 'react-native-scrollable-tab-view';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import * as requestApi from '../../config/requestApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import ImageView from '../../components/ImageView';
import * as nativeApi from '../../config/nativeApi';
import * as utils from '../../config/utils';
import ActionSheet from '../../components/Actionsheet';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import ScrollableTabBar from '../../components/CustomTabBar/ScrollableTabBar';
import { NavigationPureComponent } from '../../common/NavigationComponent';
import { TakeOrPickParams, TakeTypeEnum, PickTypeEnum } from '../../const/application';

const { width, height } = Dimensions.get('window');

const tabs = ['使用模板', '不使用模板'];
class SeatAddScreen extends NavigationPureComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    this.state = {
      name: '',
      shopId: props.userShop.id,
      seatTypeId: this.props.navigation.state.params.seatTypeId,
      currentTab: 0,
      quantity: 0,
      images: [],
      modalVisible: false, // 选择图片
      showBigPicArr: [],
      showIndex: 0,
      showBigModal: false,
    };
  }

  blurState = {
    modalVisible: false, // 选择图片
    showBigModal: false,
  }

  save = () => {
    if (!/^[0-9]/.test(this.state.quantity)) {
      Toast.show('数量只能为0或正整数');
      return;
    }
    const params = {
      name: this.state.name,
      shopId: this.props.userShop.id,
      seatTypeId: this.state.seatTypeId,
    };
    this.state.currentTab === 0 ? params.quantity = parseInt(this.state.quantity) : params.images = this.state.images;
    if (this.state.name) {
      const func = this.state.currentTab === 0
        ? requestApi.mSeatBatchCreate
        : requestApi.mSeatCreate;
      Loading.show();
      func(params).then((data) => {
        this.props.navigation.state.params.callback();
        this.props.navigation.goBack();
      }).catch(()=>{
          
      });
    }
  };

  changeTab = (itemTab) => {
    this.setState({ currentTab: itemTab });
  };

  deleteImg = (image, index) => {
    const newImages = [];
    const images = this.state.images;
    for (let i = 0; i < images.length; i++) {
      i == index ? null : newImages.push(images[i]);
    }
    this.setState({ images: newImages });
  };

  addImage = (index) => {
    Loading.show();
    const { takeOrPickImageAndVideo } = this.props;
    const showPics = this.state.images;
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
      totalNum: 9 - showPics.length,
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      this.setState({ images: showPics.concat(res.map(item => item.url)) });
    });
  };

  renderUse = () => (
    <View style={{ width: width - 20 }}>
      <Content>
        <Line
          title="系列名称"
          type="input"
          point={null}
          placeholder="请输入系列名称"
          leftStyle={{ width: 70 }}
          maxLength={5}
          onChangeText={data => this.setState({ name: data })}
        />
        <Line
          title="数量"
          type="input"
          point={null}
          placeholder="请输入作为数量"
          leftStyle={{ width: 70 }}
          onChangeText={data => this.setState({ quantity: data })}
        />
      </Content>
      <Text style={styles.smallText}>
        *
        模板说明：若要创建A01、A02、A03...此类席位，系列名称输入A，数量输入数字即可。
        </Text>
    </View>
  );

  renderUnUse = () => (
    <Content>
      <Line
        title="系列名称"
        type="input"
        point={null}
        placeholder="请输入系列名称"
        leftStyle={{ width: 70 }}
        onChangeText={data => this.setState({ name: data })}
      />

      <View
        style={{
          flexDirection: 'row',
          width: width - 50,
          marginLeft: 15,
          marginVertical: 15,
          flexWrap: 'wrap',
        }}
      >
        {this.state.images.map((valueImage, index) => (
          <View
            key={index}
            style={[
              styles.imageViewTouch,
              {
                marginRight:
                  (index + 1) % 4 === 0 ? 0 : 10,
              },
            ]}
            key={index}
          >
            <View
              style={[
                styles.imageViewTouch,
                { paddingTop: 3, position: 'relative' },
              ]}
            >
              <TouchableOpacity
                onPress={() => {
                  const temp = [];
                  this.state.images.map((item) => {
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
                }
                style={{
                  width: (width - 80) / 4 - 5,
                  height: (width - 80) / 4 - 5,
                  borderRadius: 5,
                  overflow: 'hidden',
                }}
              >
                <ImageView
                  resizeMode="cover"
                  source={{ uri: utils.getPreviewImage(valueImage) }}
                  sourceWidth={(width - 80) / 4 - 5}
                  sourceHeight={(width - 80) / 4 - 5}
                />
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => this.deleteImg(valueImage, index)
                }
                style={{
                  position: 'absolute',
                  top: 0,
                  right: 0,
                }}
              >
                <ImageView
                  source={require('../../images/index/delete.png')}
                  sourceWidth={20}
                  sourceHeight={20}
                />
              </TouchableOpacity>
            </View>
          </View>
        ))}

        {this.state.images.length == 9 ? null : (
          <TouchableOpacity
            style={styles.imageViewTouch}
            onPress={() => {
              this.ActionSheet.show();
            }}
          >
            <View
              style={[
                styles.imageViewTouch,
                { paddingTop: 5 },
              ]}
            >
              <ImageView
                source={require('../../images/index/add_pic.png')}
                sourceWidth={(width - 80) / 4 - 5}
                sourceHeight={(width - 80) / 4 - 5}
              />
            </View>
          </TouchableOpacity>
        )}
        {this.state.images.length == 0 ? (
          <View
            style={{
              marginLeft: 13,
              height: (width - 80) / 4,
              paddingTop: 5,
              justifyContent: 'center',
            }}
          >
            <Text style={{ fontSize: 12, color: '#999999' }}>
              添加图片
                      </Text>
          </View>
        ) : null}
      </View>
    </Content>
  );

  changeState(key, value) {
    this.setState({
      [key]: value,
    });
  }

  render() {
    const { navigation } = this.props;
    const {
      currentTab, name, modalVisible, showBigPicArr, showIndex, showBigModal,
    } = this.state;
    return (
      <View style={styles.container}>
        <Header
          navigation={navigation}
          goBack
          title="新增席位"
          headerStyle={{ width }}
          rightView={(
            <TouchableOpacity
              onPress={() => this.save()}
              style={{ width: 50 }}
            >
              <Text
                style={{
                  fontSize: 17,
                  color: name ? '#fff' : 'gray',
                }}
              >
                保存
                        </Text>
            </TouchableOpacity>
          )}
        />
        <ScrollableTabView
          style={[CommonStyles.flex_1]}
          initialPage={0}
          onChangeTab={({ i }) => {
            this.changeTab(i);
          }}
          renderTabBar={() => (
            <ScrollableTabBar
              underlineStyle={{
                backgroundColor: '#fff',
                height: 8,
                borderRadius: 10,
                marginBottom: -5,
                // width: "5%",
                // marginLeft: "10%"
              }}
              tabStyle={{
                backgroundColor: '#4A90FA',
                height: 44,
                paddingBottom: -4,
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
          {tabs.map((itemTab, index) => (
            <View
              key={index}
              style={{ alignItems: 'center', marginTop: 10 }}
              tabLabel={itemTab}
            >
              {index == 0
                ? this.renderUse(itemTab)
                : this.renderUnUse(itemTab)}
            </View>
          ))}
        </ScrollableTabView>
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
  smallText: {
    color: '#999999',
    fontSize: 12,
    marginTop: 20,
    paddingHorizontal: 10,
  },
  imageViewTouch: {
    width: (width - 80) / 4,
    height: (width - 80) / 4,
  },
  imageView: {
    width: (width - 80) / 4,
    height: (width - 80) / 4,
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

  modalOutView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalInnerTopView: {
    flex: 1,
    width,
    backgroundColor: 'rgba(0, 0, 0, .5)',
  },
  modalInnerBottomView: {
    width,
    height: 156 + CommonStyles.footerPadding,
    backgroundColor: '#fff',
  },
  userImgLists_item: {
    justifyContent: 'center',
    alignItems: 'center',
    width,
    height: 50,
  },
  userImgLists_item1: {
    borderTopWidth: 1,
    borderTopColor: '#E5E5E5',
  },
  userImgLists_item2: {
    borderTopWidth: 5,
    borderTopColor: '#E5E5E5',
  },
  userImgLists_item_text: {
    fontSize: 16,
    color: '#000',
  },
  bigImage: {
    backgroundColor: 'rgba(0, 0, 0, 1)',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
});

export default connect(
  state => ({
    userShop: state.user.userShop,
  }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(SeatAddScreen);
