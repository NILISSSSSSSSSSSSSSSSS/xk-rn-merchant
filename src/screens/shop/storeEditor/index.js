/**
 * 编辑店铺信息
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  ScrollView,
  TouchableOpacity,
  Keyboard
} from 'react-native';
import { connect } from 'rn-dva';
import Header from '../../../components/Header';
import CommonStyles from '../../../common/Styles';
import * as requestApi from '../../../config/requestApi';
import Line from '../../../components/Line';
import Content from '../../../components/ContentItem';
import * as regular from '../../../config/regular';
import ActionSheet from '../../../components/Actionsheet';
import CommonButton from '../../../components/CommonButton';
import ShowBigPicModal from '../../../components/ShowBigPicModal';
import math from '../../../config/math';
import { NavigationPureComponent } from '../../../common/NavigationComponent';
const { width, height } = Dimensions.get('window');
import { TakeOrPickParams, TakeTypeEnum, PickTypeEnum } from '../../../const/application';
import ListItem from './ListItem.js';
import {items} from './ItemsData'
class StoreEditorScreen extends NavigationPureComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    const params = props.navigation.state.params || {};
    const currentShop = params.currentShop || {
      detail: {
        automatic: 1,
        isSelf: 0,
        onLine: 1,
        isBusiness: 1,
        discountType:'SHOP_DISCOUNT'
      },
    };
    const detail = currentShop.detail || {};
    this.state = {
      visible: false,
      selectedImageIndex: 0,
      qiniuToken: null,
      images: [],
      oldShop: currentShop,
      currentShop,
      quhao: detail.fixedPhone && detail.fixedPhone.split('-')[0] || '',
      shortPhone: detail.fixedPhone && detail.fixedPhone.split('-')[1] || '',
      modalVisible: false, // 选择上传照片方式
      minMoney: detail.minMoney && math.divide(detail.minMoney, 100),
      maxMoney: detail.maxMoney && math.divide(detail.maxMoney, 100),
      haveChanged: false, // 店铺信息是否有过更改
      route: params.route,
      selectOptions: [],
      callback: params.callback || (() => { }),
      avgConsumption: detail.avgConsumption && math.divide(detail.avgConsumption, 100),
      requestParams: {},
      showBigPicArr: [],
      useTopPic:true
    };
  }

  blurState = {
    modalVisible: false, // 选择上传照片方式
    visible: false,
  }
  componentDidMount(){
    Loading.show()
    requestApi.shopQueryQualification().then((data)=>{
      this.setState({isNecessarily:data.isNecessarily})
    }).catch((err)=>{
      console.log(err)
    });
  }

  updateDetail = (data) => { //修改店铺信息
    const { currentShop } = this.state;
    this.setState({
      warningItem: '',
      haveChanged: true,
      currentShop: {
        ...currentShop,
        detail: {
          ...currentShop.detail,
          ...data,
        },
      },
    });
  };
  scrollToItem = (key) => { //滚动到错误警告项
    this.setState({ warningItem: key });
    const itemLayout = (this[`${key}Group`] + this[`${key}layout`]) || 0;
    this.myScrollView.scrollTo({ x: 0, y: itemLayout, animated: true });
  }
  judgeFun=(params,navigation,currentShop)=>{
    Loading.show();
    const {getMerchantHome,updateShop}=this.props
    if (params.id) { // 修改店铺
      params.firstAuthStatus = null
      params.secondAuthStatus = null
      updateShop(params, () => {
        this.state.callback(currentShop);
        navigation.navigate('ApplyFormDone',{route:'StoreDetail'});
      });
    } else {// 新增店铺
      params.merchantType = 'shops';
      requestApi.requestAddShop(params).then((data) => {
        const freeParam = {
          template: {
            shopId: data.id,
            shopName: currentShop.detail.name,
            valuateType: 'NONE',
            postType: 'NONE',
          },
        };
        requestApi.fetchmUserOBMPostFeeCreate(freeParam).then((resdata) => { //创建运费模版
          this.state.callback();
          getMerchantHome();
          navigation.navigate('ApplyFormDone',{route:'StoreManage'});
        }).catch((err)=>{
          console.log(err)
        });
      });
    }
  }

  saveEditor = () => {
    Keyboard.dismiss();
    const {
      currentShop,
      quhao,
      shortPhone,
      minMoney,
      maxMoney,
      isNecessarily,
      avgConsumption,
      useTopPic
    } = this.state;
    const params = JSON.parse(JSON.stringify(currentShop.detail));
    params.range = parseFloat(params.range);
    params.fixedPhone = `${quhao}-${shortPhone}`;
    console.log('params',params)
    if(!params.industry || params.industry.length==0){
      Toast.show('请选择店铺分类');
      this.scrollToItem('industryName');
      return;
    }
    if (!regular.price(minMoney) || !regular.price(maxMoney)) {
      Toast.show('请输入正确金额格式的宣传语');
      this.scrollToItem('xuanchuanyu');
      return;
    }
    if (parseFloat(minMoney) > parseFloat(maxMoney)) {
      Toast.show('宣传语最小金额不能大于最大金额');
      this.scrollToItem('xuanchuanyu');
      return;
    }
    if (!params.name || params.name.length > 20) {
      this.scrollToItem('name');
      Toast.show('店铺名称最多20个字，必填');
    } else if (JSON.stringify(params.newBusinessTime) == '{}' || !params.newBusinessTime) {
      this.scrollToItem('newBusinessTime');
      Toast.show('请选择营业时间');
    } else if (
      params.discountType=='SHOP_DISCOUNT' && 
      (!/(^[1-9](\d+)?(\.\d{1})?$)|(^0$)|(^\d\.\d{1}$)/.test(params.discount,) || 
      parseFloat(params.discount) > 9.9 || 
      parseFloat(params.discount) == 0)
    ) {
      this.scrollToItem('discount');
      Toast.show('折扣最多一位小数的正数且大于0小于10');
    } else if (((params.contactPhones && (params.contactPhones.length == 0 || !params.contactPhones[0])) || (!params.contactPhones)) && (!shortPhone)) {
      this.scrollToItem('contactPhones');
      Toast.show('至少输入一个联系电话');
    } else if (params.contactPhones && params.contactPhones[0] && !regular.phone(params.contactPhones[0])) {
      this.scrollToItem('contactPhones');
      Toast.show('请输入正确格式的手机号码,11位数字');
    } else if (shortPhone && !quhao) {
      this.scrollToItem('contactPhones');
      Toast.show('请输入区号');
    } else if (params.fixedPhone != '-' && !regular.SeatNumber(params.fixedPhone)) {
      this.scrollToItem('contactPhones');
      Toast.show('请输入正确的座机号,区号以0开头，三到四位数字，座机号码6到8位数字');
    } else if (!regular.price(avgConsumption)) {
      this.scrollToItem('avgConsumption');
      Toast.show('请输入正确格式的金额');
    } else if (
      !(
        /(^[1-9](\d+)?(\.\d{1})?$)|(^0$)|(^\d\.\d{1}$)/.test(
          params.range,
        ) && params.range != 0
      )
    ) {
      this.scrollToItem('range');
      Toast.show('接单范围为最多一位小数的正数');
    } else if (!params.description) {
      this.scrollToItem('description');
      Toast.show('请填写店铺介绍');
    } else if (!params.logo) {
      this.scrollToItem('logo');
      Toast.show('请上传店铺logo');
    } else if ((!params.qualifiedPictures || params.qualifiedPictures.length == 0) && isNecessarily) {
      this.scrollToItem('qualifiedPictures');
      Toast.show('请上传店铺相关资质');
    } else if ((!params.rollingPics || params.rollingPics.length == 0) && useTopPic) {
      this.scrollToItem('rollingPics');
      Toast.show('请上传顶部滚动图片');
    }else if (!params.pictures || params.pictures.length == 0) {
      this.scrollToItem('pictures');
      Toast.show('请上传展示图片');
    } else if ( !params.description || params.description.length < 8 || params.description.length > 50 ) {
      this.scrollToItem('description');
      Toast.show('店铺介绍不得少于8个字或不得超过50个字');
    } else if (!params.address) {
      Toast.show('请选择店铺地址');
    } else {
      params.minMoney = math.multiply(parseFloat(minMoney), 100);
      params.maxMoney = math.multiply(parseFloat(maxMoney), 100);
      params.avgConsumption = math.multiply(parseFloat(avgConsumption), 100);
      !useTopPic?params.rollingPics=[]:null
      const {navigation,userState,shops}=this.props
      shops.length ==0 ?params.shopType='MASTER':null
      if (!params.shopType && !params.id) {
        Toast.show('请选择店铺类型');
        this.scrollToItem('shopType');
        return
      }
      if(params.rollingPics && params.rollingPics.length>0){
        params.rollingPics=params.rollingPics.map((item,index)=>{
          item={url:item,index}
          return item
        })
      }
      if (params.fixedPhone === '-') {
        params.fixedPhone = ''
      }
      if (params.contactPhones && params.contactPhones[0] === '') {
        params.contactPhones = ''
      }
      params.id?this.judgeFun(params,navigation,currentShop):
      navigation.navigate('VerifyPhone', {
        phone: (userState.merchantData.merchant || {}).phone,
        editable: false,
        bizType: 'VALIDATE',
        onConfirm: (phone, code, navigation) => {
          Loading.show()
          requestApi.smsCodeValidate({ phone, code }).then(() => {
            this.judgeFun(params,navigation,currentShop)
          }).catch((err)=>{
            console.log(err)
          });
        }
      })
    }
  };
  addImage = (index) => { //新增图片
    const { takeOrPickImageAndVideo } = this.props;
    const { maxLength, witch, currentShop } = this.state;
    let pictures = [];
    if (currentShop && currentShop.detail) {
      const witchImage = currentShop.detail[witch];
      if (maxLength == 1) {
        pictures = witchImage ? [witchImage] : [];
      } else {
        pictures = witchImage ? [...witchImage] : [];
      }
    }
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
      totalNum: maxLength - pictures.length,
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      pictures = pictures.concat(res.map(item => item.url));
      this.updateDetail({
        [witch]: maxLength == 1 ? pictures[0] : pictures,
        cover: witch == 'pictures' ? currentShop.detail.cover || pictures[0] : currentShop.detail.cover,
      });
    });
  };
  setCoverImage = () => { //设置封面
    this.setState({ visible: false });
    this.updateDetail({
      cover: this.state.currentShop.detail.pictures[
        this.state.selectedImageIndex
      ],
    });
  };
  render() {
    const { navigation ,user,shops} = this.props;
    const {currentShop, modalVisible, selectOptions} = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    return (
      <View style={styles.container}>
        <Header
          title="店铺信息"
          navigation={navigation}
          goBack={true}
          rightView={
            detail.id
              ? (
                <TouchableOpacity
                  onPress={() => this.saveEditor()}
                  style={{ width: 50 }}
                >
                  <Text style={{ fontSize: 17, color: '#fff' }}>保存</Text>
                </TouchableOpacity>
              )
              : null
          }
        />
        <ScrollView
          alwaysBounceVertical={false}
          style={{ flex: 1 }}
          contentContainerStyle={{ paddingBottom: CommonStyles.footerPadding + 10 }}
          ref={(view) => { this.myScrollView = view; }}
        >
          <View style={styles.content}>
            {
              items(shops,currentShop,this.state).map((item0, index0) => (
                <View key={index0} onLayout={(event) => { this[`group${index0}layout`] = event.nativeEvent.layout.y; }}>
                  <Content>
                    {
                      item0.map((item, index) => {
                        this[`${item.key}Group`] = this[`group${index0}layout`];
                        return (
                          <View key={index} onLayout={(event) => { this[`${item.key}layout`] = event.nativeEvent.layout.y; }}>
                            <ListItem
                                state={this.state}
                                showActionSheet={() => this.ActionSheet.show()}
                                setState={(data, callback = () => { }) => this.setState(data, () => callback())}
                                item={item}
                                detail={detail}
                                navigation={navigation}
                                scrollToItem={this.scrollToItem}
                                updateDetail={this.updateDetail}
                                setCoverImage={this.setCoverImage}
                              />
                          </View>
                        );
                      })
                    }
                  </Content>
                </View>
              ))
            }
            {
              detail.id ? null
                : <CommonButton title="提交审核" onPress={() => this.saveEditor()} />
            }
          </View>
        </ScrollView>
        <ActionSheet
          ref={o => (this.ActionSheet = o)}
          // title={'Which one do you like ?'}
          options={selectOptions}
          cancelButtonIndex={selectOptions.length - 1}
          // destructiveButtonIndex={2}
          onPress={(index) => {
            if (index != selectOptions.length - 1) {
              if (modalVisible) {
                this.addImage(index);
                this.setState({ modalVisible: false });
              } else {
                this.updateDetail({
                  shopType: index == 0 ? 'SHOP_IN_SHOP' : 'BRANCH',
                });
              }
            }
          }}
        />
        <ShowBigPicModal
          ImageList={this.state.showBigPicArr}
          visible={this.state.visible}
          showImgIndex={this.state.selectedImageIndex}
          callback={(index) => {
            this.setState({ selectedImageIndex: index });
          }}
          childrenStyles={{ top: CommonStyles.headerPadding, right: 17 }}
          onClose={() => {
            this.setState({
              visible: false,
            });
          }}
        >
          {
            this.state.witch == 'pictures' && detail.pictures && detail.cover != detail.pictures[this.state.selectedImageIndex]
              ? (
                <TouchableOpacity
                  style={styles.settingCover}
                  onPress={() => this.setCoverImage()}
                >
                  <Text style={{ color: 'white', fontSize: 14 }}>
                    设为封面
                    </Text>
                </TouchableOpacity>
              ) : null
          }
        </ShowBigPicModal>

      </View>
    );
  }

}
const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    backgroundColor: CommonStyles.globalBgColor,
  },
  content: {
    alignItems: 'center',
    paddingBottom: 10,
  },
  logoView: {
    alignItems: 'flex-start',
    flexWrap: 'wrap',
    paddingLeft: 0,
    paddingRight: 0,
    paddingBottom: 10,
    marginTop: 0,
  },
  line: {
    flexDirection: 'row',
    alignItems: 'center',
    // height: 50,
    paddingVertical: 18,
    paddingLeft: 15,
    paddingRight: 15,
    borderColor: '#F1F1F1',
    borderBottomWidth: 1,
    justifyContent: 'space-between',
  },
  inputView: {
    flex: 1,
    marginLeft: 10,
    color: '#777777',
  },
  bigImage: {
    backgroundColor: 'rgba(0, 0, 0, 1)',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  settingCover: {
    height: 50,
    justifyContent: 'center',
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
  btn: {
    width: '50%',
    height: 40,
  },
  button: {
    backgroundColor: '#4A90FA',
    borderRadius: 8,
    width: '80%',
    marginBottom: 20,
  },
  text: {
    color: '#222',
    fontSize: 14,
  },
});

export default connect(
  state => ({
    merchantData: state.user.merchantData || {},
    user: state.user.user || {},
    userState:state.user || {},
    shops: (state.user.merchantData || {}).shops || [],
    userShop: state.user.userShop || {},
    juniorShops: state.shop.juniorShops || [state.user.userShop || {}],
  }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
    getMerchantHome: (payload={}) => ({ type: 'user/getMerchantHome', payload }),
    updateShop: (params, callback) => ({ type: 'shop/updateShop', payload: { ...params, callback } }),
  },
)(StoreEditorScreen);
