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
  Keyboard,
  ImageBackground
} from 'react-native';
import { connect } from 'rn-dva';
import { StackActions, NavigationActions } from 'react-navigation';
import Radio from '../../components/Radio';
import Header from '../../components/Header';
import CommonStyles from '../../common/Styles';
import ImageView from '../../components/ImageView';
import TextInputView from '../../components/TextInputView';
import * as utils from '../../config/utils';
import * as nativeApi from '../../config/nativeApi';
import * as requestApi from '../../config/requestApi';
import Line from '../../components/Line';
import Content from '../../components/ContentItem';
import * as regular from '../../config/regular';
import ActionSheet from '../../components/Actionsheet';
import CommonButton from '../../components/CommonButton';
import Switch from 'react-native-switch-pro';
import PriceInputView from '../../components/PriceInputView';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import math from '../../config/math';
import { NavigationPureComponent } from '../../common/NavigationComponent';
import { TakeOrPickParams, TakeTypeEnum, PickTypeEnum } from '../../const/application';
const { width, height } = Dimensions.get('window');

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
      },
    };
    const detail = currentShop.detail || {};
    const merchantData = props.merchantData.identityStatuses || [];
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
      isNecessarily:1,//店铺资质是否必传
    };
  }

  blurState = {
    modalVisible: false, // 选择上传照片方式
    visible: false,
  }
  

  deleteImg = (image, index, witch, maxLength) => { //删除图片
    if (maxLength == 1) {
      this.updateDetail({
        [witch]: '',
      });
    } else {
      const newImages = [];
      const detail = this.state.currentShop.detail;
      const pictures = detail[witch];
      for (let i = 0; i < pictures.length; i++) {
        i == index ? null : newImages.push(pictures[i]);
      }
      this.updateDetail({
        [witch]: newImages,
        cover: detail.cover == image && witch != 'qualifiedPictures' ? newImages[0] || '' : detail.cover,
      });
    }
  };

  checkImage = (pictures, image, index, witch) => { //查看大图
    let showBigPicArr = [];
    if (witch != 'logo') {
      pictures.map(item => showBigPicArr.push({ type: 'images', url: item }));
    } else {
      showBigPicArr = [{ type: 'images', url: image }];
    }
    this.setState({
      showBigPicArr,
      selectedImageIndex: index,
      visible: true,
      witch,
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

  changeState(key, value) {
    this.setState({
      [key]: value,
      warningItem: '',
    });
  }
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
        }).catch(()=>{

        });
      }).catch(()=>{
          
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
      callback,
      avgConsumption
    } = this.state;
    const params = JSON.parse(JSON.stringify(currentShop.detail));
    params.range = parseFloat(params.range);
    params.fixedPhone = `${quhao}-${shortPhone}`;
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
    } else if (JSON.stringify(params.businessTime) == '{}' || !params.businessTime) {
      this.scrollToItem('businessTime');
      Toast.show('请选择营业时间');
    } else if (
      (!/(^[1-9](\d+)?(\.\d{1})?$)|(^0$)|(^\d\.\d{1}$)/.test(
        params.discount,
      )) || parseFloat(params.discount) > 9.9 || parseFloat(params.discount) == 0
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
    } else if (!params.qualifiedPictures || params.qualifiedPictures.length == 0) {
      this.scrollToItem('qualifiedPictures');
      Toast.show('请上传店铺相关资质');
    } else if (!params.pictures || params.pictures.length == 0) {
      this.scrollToItem('pictures');
      Toast.show('请上传展示图片');
    } else if (
      !params.description
      || params.description.length < 8
      || params.description.length > 50
    ) {
      this.scrollToItem('description');
      Toast.show('店铺介绍不得少于8个字或不得超过50个字');
    } else if (!params.address) {
      Toast.show('请选择店铺地址');
    } else {
      params.minMoney = math.multiply(parseFloat(minMoney), 100);
      params.maxMoney = math.multiply(parseFloat(maxMoney), 100);
      params.avgConsumption = math.multiply(parseFloat(avgConsumption), 100);

      const {navigation,userState,shops}=this.props
      shops.length ==0 ?params.shopType='MASTER':null
      if (!params.shopType && !params.id) {
        Toast.show('请选择店铺类型');
        this.scrollToItem('shopType');
        return
      }
      navigation.navigate('VerifyPhone', {
        phone: (userState.merchantData.merchant || {}).phone,
        editable: false,
        bizType: 'VALIDATE',
        onConfirm: (phone, code, navigation) => {
          Loading.show()
          // requestApi.smsCodeValidate({ phone, code }).then(() => {
            this.judgeFun(params,navigation,currentShop)
          // })
        }
      })
    }
  };

  renderImage = (witch, images, maxLength) => {
    let pictures = [];
    const detail = this.state.currentShop && this.state.currentShop.detail || {};
    if (maxLength == 1) {
      pictures = images ? [images] : [];
    } else {
      pictures = images ? [...images] : [];
    }
    let styleView = {
      flexDirection: 'row',
      width: width - 20,
      paddingHorizontal: 15,
      flexWrap: 'wrap',
      paddingTop: 12,
    };
    if (witch != 'pictures') {
      styleView = {
        ...styleView,
        borderTopWidth: 1,
        borderColor: '#F1F1F1',
        marginTop: 15,
      };
    }
    return (
      <View style={styleView}>
        {pictures.map((valueImage, index) => (
          <View
            style={[styles.imageViewTouch, { marginRight: (index + 1) % 3 === 0 ? 0 : 10 }]}
            key={index}
          >
            <View style={[styles.imageViewTouch, { paddingTop: 3, position: 'relative' }]}>
              <TouchableOpacity
                style={styles.imagesView}
                onPress={() => this.checkImage(
                  pictures,
                  valueImage,
                  index,
                  witch,
                )
                }
              >
                <ImageView
                  resizeMode="cover"
                  source={{
                    uri: utils.getPreviewImage(valueImage, '50p'),
                  }}
                  sourceWidth={(width - 50 - 30) / 3}
                  sourceHeight={(width - 50 - 30) / 3}
                />
                {valueImage == detail.cover && witch == 'pictures' ? (
                  <View style={styles.coverImageView}>
                    <Text style={{ color: 'white', fontSize: 10 }}> 封面 </Text>
                  </View>
                ) : null}
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => this.deleteImg(valueImage, index, witch, maxLength)}
                style={styles.deleteImageView}
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
        {pictures.length == maxLength || pictures.length > maxLength ? null : (
          <TouchableOpacity
            style={styles.imageViewTouch}
            onPress={() => {
              this.setState(
                {
                  modalVisible: true, witch, maxLength, selectOptions: ['拍照', '相册', '取消'],
                },
                this.ActionSheet.show(),
              );
            }}
          >
            <View style={[styles.imageViewTouch, { paddingTop: 5 }]}>
              <ImageView
                source={require('../../images/index/add_pic.png')}
                sourceWidth={(width - 50 - 30) / 3}
                sourceHeight={(width - 50 - 30) / 3}
              />
            </View>
          </TouchableOpacity>
        )}
        {
          witch=='topPic'?
          <Switch
            width={36}
            height={23}
            style={{position:'absolute',top:-35,right:15}}
            value={detail.useTopPic ? true : false}
            onSyncPress={(data) => {
              this.updateDetail({useTopPic:data})
            }}
          />:null
        }
      </View>
    );
  }

  editAdress = () => {
    const { navigation } = this.props;
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('StoreAddress', {
      currentShop,
      address: detail.address,
      callback: data => this.updateDetail(data),
    });
  }

  selectRightView = value => (
    <View style={styles.addressRightView}>
      <View style={{ marginBottom: 6, flex: 1, alignItems: 'flex-end' }}>
        <Text style={[styles.contentTopText]}>
          {' '}
          {' '}
          {value}
          {' '}
        </Text>
      </View>
      <ImageView
        source={require('../../images/index/expand.png')}
        sourceWidth={14}
        sourceHeight={14}
        style={{ marginTop: 2 }}
      />
    </View>
  )

  selectType = () => [
    this.setState({
      selectOptions: ['店中店', '分店', '取消'],
    }, () => {
      this.ActionSheet.show();
    }),
  ]

  selectFenlei = () => {
    const { navigation } = this.props;
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('StoreFenlei', {
      callback: (industry, industryName) => this.updateDetail({
        industry,
        industryName,
      }),
      industry: detail.industry,
    });
  }

  selectYingyeTime = () => {
    const { navigation } = this.props;
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('YingyeTime', {
      callback: (data={}) => {
        console.log('营业时间',data)
        this.updateDetail({ businessTime: data })
      },
      businessTime: detail.businessTime,
    });
  }
  renderYouhuiType=(detail)=>{
    const saleType=detail.saleType
    const list=[
      {key:'discount',view:(color)=><Text style={{color}}>店铺最低折扣</Text>},
      {key:'sale', view:(color)=><Text style={{color}}>享会员优惠</Text>},
    ]
    const onPress=(saleType)=>{
      this.updateDetail({saleType})
    }
    return(
      <View>
        <View style={styles.saleTypeView}>
        {
          list.map((item,index)=>{
            const selected=saleType==item.key
            return(
              selected?
              <TouchableOpacity key={index} onPress={()=>onPress(item.key)}>
                <ImageBackground
                  style={[styles.saleTypeBut,{height:(((width-65)/2+10)/169)*58,width:(width-65)/2+10,marginTop:4}]}
                  source={require('../../images/shop/shopBut.png')}
                  resizeMode="cover"
                >
                    {item.view('#fff')}
                 </ImageBackground>
              </TouchableOpacity>:
              <TouchableOpacity
                onPress={()=>onPress(item.key)}
                key={index}
                style={[styles.saleTypeBut,{backgroundColor:'#F8F8F8',width:(width-65)/2}]}
              >
                {item.view('#666666')}
              </TouchableOpacity>
            )
          })
        }
        </View>
        {
          saleType=='discount'?
          <Line
            title={'折扣'}
            type={'input'}
            placeholder={'请输入，例如8'}
            point={null}
            unit={'折'}
            style={{borderBottomWidth:0,paddingBottom:2,paddingRight:4}}
            value={detail.discount}
            styleInput={{ textAlign: 'right' }}
            onChangeText={(data)=>this.updateDetail({discount:data})}
          />
          :null
        }
      </View>
    )
  }
  items=(detail)=>{
    const { user,shops} = this.props;
    const { currentShop} = this.state;
    const topItems = [
      {
        title: '店铺地址', key: 'address', onPress: this.editAdress, type: 'horizontal',value:'fgjig jv;gv jerwo gkop;e krwgeow gjo jew gewj gjo'
      },
      {
        title: '店铺分类', key: 'industryName', onPress: this.selectFenlei, type: 'hozirontal', rightView: this.rightViewSelect(detail.industryName),
      },
      {
        title: '店铺名称', key: 'name', maxLength: 20, placeholder: '请输入店铺名字', type: 'input', value: detail.name, onChangeText: data => this.updateDetail({ name: data }),
      },
      { title: '优惠方式', key: 'youhuifangshi', rightView: this.renderYouhuiType(detail) , style: styles.logoView, leftStyle: { paddingLeft: 15 }},
      { title: '宣传语', key: 'xuanchuanyu', rightView: this.rightViewXuanchuanyu() },
      {
        title: '联系电话', key: 'contactPhones', rightView: this.rightViewContracts(), style: { alignItems: 'flex-start' },
      },
      {
        title: '营业时间', key: 'businessTime', onPress: this.selectYingyeTime, type: 'hozirontal', rightView: this.rightViewSelect(detail.businessTime && detail.businessTime.startAt && detail.businessTime.endAt ?(detail.businessTime.startAt+'-'+detail.businessTime.endAt):'')
      },
      { title: '人均消费', key: 'avgConsumption', type:'input',unit:'元',placeholder:'请输入金额' },
      {
        title: '当前店铺状态', key: 'onLine', type: 'radio', items: [{ title: '上线', value: 1 }, { title: '下线', value: 0 }],
      },
      {
        title: '当前是否接单', key: 'isBusiness', type: 'radio', items: [{ title: '接单中', value: 1 }, { title: '不接单', value: 0 }],
      },
      {
        title: '是否自动接单', key: 'automatic', type: 'radio', items: [{ title: '是', value: 1 }, { title: '否', value: 0 }],
      },
    ];
    !detail.id && shops.length>0?
    topItems.splice(1, 0,
        {
          title: '店铺类型', onPress: this.selectType, type: 'hozirontal', rightView: this.rightViewSelect(detail.shopType == 'SHOP_IN_SHOP' ? '店中店' : detail.shopType == 'BRANCH' ? '分店' : ''),
        })
      : null;
    currentShop.shopType == 'SHOP_IN_SHOP' && detail.id ? topItems.unshift({
      title: '上级店铺', key: 'masterMShopName', value: currentShop.masterMShopName || '暂无',
    }) : null;
    const items = [
      topItems,
      [
        {
          title: '顶部滚动图片', key: 'topPic', rightView: this.renderImage('topPic', detail.topPic, 9), style: styles.logoView, leftStyle: { paddingLeft: 15 },
        },
      ],
      [
        {
          title: '店铺logo', key: 'logo', rightView: this.renderImage('logo', detail.logo, 1), style: styles.logoView, leftStyle: { paddingLeft: 15 },
        },
      ],
      [
        {
          title: '相关资质', key: 'qualifiedPictures', rightView: this.renderImage('qualifiedPictures', detail.qualifiedPictures, 9), style: styles.logoView, leftStyle: { paddingLeft: 15 },
        },
      ],
      [
        { title: '接单范围', key: 'range', rightView: this.rightViewRange() },
        {
          title: '店铺介绍', key: 'description', rightView: this.rightViewDescription(), style: { alignItems: 'flex-start', flexWrap: 'wrap' },
        },
        {
          title: '展示图片', key: 'pictures', rightView: this.renderImage('pictures', detail.pictures, 9), style: styles.logoView, leftStyle: { paddingLeft: 15 },
        },
      ],
    ];
    if (detail.id) {
      items.unshift([
        { title: '店铺编号', key: 'code', value: detail.code },
        {
          title: '推荐码', key: 'mrCode', value: currentShop.mrCode, rightTextStyle: { color: CommonStyles.globalHeaderColor },
        },
      ]) ;
    }
    return items
  }

  render() {
    const { navigation ,user} = this.props;
    const {warningItem, currentShop, modalVisible, selectOptions} = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    console.log(detail)
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
              this.items(detail).map((item0, index0) => (
                <View key={index0} onLayout={(event) => { this[`group${index0}layout`] = event.nativeEvent.layout.y; }}>
                  <Content>
                    {
                      item0.map((item, index) => {
                        this[`${item.key}Group`] = this[`group${index0}layout`];
                        return (
                          <View key={index} onLayout={(event) => { this[`${item.key}layout`] = event.nativeEvent.layout.y; }}>
                            <Line
                              title={item.title}
                              type={item.rightView || item.type == 'radio' ? 'custom' : item.type}
                              placeholder={item.placeholder}
                              point={null}
                              leftStyle={{ ...item.leftStyle, color: warningItem == item.key ? CommonStyles.globalRedColor : '#222' }}
                              value={item.value}
                              style={[{ justifyContent: 'space-between', alignItems: 'center' }, item.type == 'hozirontal' && styles.fenleiView, item.style]}
                              onPress={item.onPress}
                              styleInput={{ textAlign: 'right' }}
                              unit={item.unit}
                              onChangeText={item.onChangeText}
                              rightTextStyle={[item.rightTextStyle, { textAlign: 'right' }]}
                              rightView={
                                item.type == 'radio'
                                  ? (
                                    <Radio
                                      contentstyle={{ flex: 1, flexWrap: 'wrap', marginLeft: 20 }}
                                      item0Style={{ flex: 1 }}
                                      item1Style={{ flex: 1 }}
                                      change={v => this.updateDetail({ [item.key]: v })}
                                      textStyle={{ color: '#777' }}
                                      value={detail[item.key]}
                                      options={item.items}
                                    />
                                  )
                                  : item.rightView
                              }
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
  rightViewXuanchuanyu = () => {
    const { currentShop, minMoney, maxMoney } = this.state;
    return (
      <View style={styles.addressRightView}>
        <Text style={[styles.contentTopText, { color: '#222' }]}> 每单均减 </Text>
        <PriceInputView
          placeholder=""
          inputView={{ width: 50 }}
          value={minMoney}
          style={{ textAlign: 'center', color: '#EE6161' }}
          maxLength={5}
          onChangeText={(data) => {
            this.setState({
              minMoney: data,
            });
          }}
          maxLength={5}
        />
        <Text style={[styles.contentTopText, { color: '#222' }]}> 元到 </Text>
        <PriceInputView
          inputView={{ width: 50 }}
          value={maxMoney}
          style={{ textAlign: 'center', color: '#EE6161' }}
          maxLength={5}
          onChangeText={(data) => {
            this.setState({
              maxMoney: data,
            });
          }}
        />
        <Text style={[styles.contentTopText, { color: '#222' }]}> 元 </Text>
      </View>
    );
  }

  rightViewContracts = () => {
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    return (
      <View style={{ flex: 1, marginRight: -15 }}>
        <TextInputView
          placeholder="请输入手机号码"
          placeholderTextColor="#ccc"
          keyboardType="numeric"
          maxLength={11}
          value={(detail.contactPhones && detail.contactPhones[0]) || ''}
          style={styles.managerPhone}
          onChangeText={data => this.updateDetail({
            contactPhones: [data],
          })
          }
        />

        <View style={styles.phoneView}>
          <TextInputView
            placeholder="区号"
            placeholderTextColor="#ccc"
            value={this.state.quhao}
            maxLength={4}
            keyboardType="numeric"
            inputView={{ width: 68 }}
            style={{ color: '#222', textAlign: 'right', paddingRight: 10 }}
            onChangeText={data => this.setState({
              quhao: data,
            })
            }
          />
          <Text style={{ width: 20 }}>  - </Text>
          <TextInputView
            placeholder="座机号码"
            placeholderTextColor="#ccc"
            value={this.state.shortPhone}
            maxLength={8}
            keyboardType="numeric"
            inputView={{ width: '36%' }}
            style={{
              textAlign: 'right',
              color: '#222',
            }}
            onChangeText={data => this.setState({
              shortPhone: data,
            })
            }
          />
        </View>
      </View>
    );
  }

  rightViewDescription = () => {
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    return (
      <TextInputView
        placeholder="请输入介绍内容，最多50字"
        placeholderTextColor="#ccc"
        style={{ textAlignVertical: 'top', color: '#222' }}
        maxLength={50}
        inputView={[
          {
            color: '#777777',
            height: 60,
            width: width - 50,
            marginTop: 15,
          },
        ]}
        multiline
        value={detail.description}
        onChangeText={data => this.updateDetail({
          description: data,
        })
        }
      />
    );
  }

  rightViewSelect = value => (
    <View style={[styles.addressRightView, { alignItems: 'flex-start' }]}>
      <View style={{ marginBottom: 6, flex: 1, alignItems: 'flex-end' }}>
        <Text style={[styles.contentTopText]}>
          {' '}
          {' '}
          {' '}
          {value}
        </Text>
      </View>
      <ImageView
        source={require('../../images/index/expand.png')}
        sourceWidth={14}
        sourceHeight={14}
        style={{ marginTop: 2 }}
      />
    </View>
  )

  rightViewRange = () => {
    const { currentShop } = this.state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    return (
      <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', position: 'relative', }}
      >
        <Text style={[styles.contentTopText, { color: '#ccc', position: 'absolute', top: 2, left: 0 }]}> 店铺地址为中心周围 </Text>
        <TextInputView
          placeholder="0"
          placeholderTextColor="#ccc"
          inputView={[styles.inputView,]}
          style={{ flex: 1, textAlign: 'right', paddingLeft: width - 240 }}
          value={detail.range ? detail.range.toString() : ''}
          onChangeText={data => this.updateDetail({
            range: data,
          })
          }
        />
        <Text style={[styles.contentTopText, { color: '#222' }]}> 公里(km) </Text>
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
  fenleiView: {
    alignItems: 'flex-start',
    justifyContent: 'space-between',
    flexWrap: 'wrap',
    paddingBottom: 9,
    marginTop: 0,
  },
  addressRightView: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    flex: 1,
    marginLeft: 10,
    alignItems: 'center',
  },
  discountRightView: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  logoView: {
    alignItems: 'flex-start',
    flexWrap: 'wrap',
    paddingLeft: 0,
    paddingRight: 0,
    paddingBottom: 10,
    marginTop: 0,
  },

  // line: {
  //     flexDirection: "row",
  //     // alignItems:'center',
  //     // height:42,
  //     paddingVertical: 14,
  //     paddingHorizontal: 10,
  //     borderColor: "#F1F1F1",
  //     borderBottomWidth: 1
  // },
  lineRightTitle: {
    color: '#777777',
    fontSize: 14,
    flex: 1,
    marginLeft: 10,
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
  contentTopText2: {
    fontSize: 14,
    color: '#222222',
    position: 'relative',
  },
  itemView: {
    width,
    paddingHorizontal: 10,
    paddingVertical: 10,
  },
  itemTitleText: {
    fontSize: 16,
    color: '#333',
  },
  inputView: {
    flex: 1,
    marginLeft: 10,
    color: '#777777',
  },
  phoneView: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 18,
    borderTopWidth: 1,
    borderColor: '#F1F1F1',
    justifyContent: 'flex-end',
    paddingRight: 15,
  },
  selectView: {
    width: '50%',
    flexDirection: 'row',
    alignItems: 'center',
  },
  imageViewTouch: {
    width: (width - 50 - 30) / 3 + 3,
    height: (width - 50 - 30) / 3 + 3,
    marginBottom: 10,
  },
  imagesView: {
    width: (width - 50 - 30) / 3,
    height: (width - 50 - 30) / 3,
    borderRadius: 5,
    overflow: 'hidden',
    position: 'relative',
  },
  delete: {
    position: 'absolute',
    top: 0,
    right: 0,
  },
  contentTopText: {
    fontSize: 14,
    color: '#222',
  },
  managerPhone: {
    marginBottom: 18,
    height: 20,
    marginLeft: 10,
    textAlign: 'right',
    paddingRight: 15,
    fontSize: 14,
    color: '#222',
  },
  deleteImageView: {
    position: 'absolute',
    top: 0,
    right: 0,
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
  coverImageView: {
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    justifyContent: 'center',
    alignItems: 'center',
    width: 40,
    height: 18,
    borderRadius: 10,
    position: 'absolute',
    bottom: 0,
    right: 4,
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
  btn_text: {
    textAlign: 'center',
    color: '#4A90FA',
    fontSize: 17,
    lineHeight: 40,
  },
  text: {
    color: '#222',
    fontSize: 14,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 20,
  },
  modalSelect: {
    flex: 1,
    justifyContent: 'center',
    padding: 40,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  innerContainer: {
    borderRadius: 10,
    // alignItems: "center",
    backgroundColor: '#EFEFEF',
  },
  selfSelect: {
    marginRight: 12,
    width: 15,
    height: 15,
  },
  saleTypeBut:{
    height:44,
    alignItems:'center',
    justifyContent:'center',
    borderRadius:8
  },
  saleTypeView:{
    width:width-50,
    ...CommonStyles.flex_between,
    marginLeft:15,
    marginTop:10
  }
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
