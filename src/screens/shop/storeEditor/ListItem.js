/**
 * 填写注册资料
 */
import React, { Component, PureComponent } from "react";
import {
  StyleSheet,
  Dimensions,
  View,
  Text,
  Image,
  ImageBackground,
  TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva";
import Switch from '../../../components/Switch'
import * as utils from "../../../config/utils";
import Radio from "../../../components/Radio";
import CommonStyles from "../../../common/Styles";
import ImageView from "../../../components/ImageView";
import Line from "../../../components/Line";
import TextInputView from "../../../components/TextInputView";
const { width, height } = Dimensions.get("window");
import PriceInputView from '../../../components/PriceInputView';
import { NavigationComponent } from "../../../common/NavigationComponent";
class ListItem extends NavigationComponent {
  deleteImg = (image, index, witch, maxLength) => { //删除图片
    if (maxLength == 1) {
      this.props.updateDetail({
        [witch]: '',
      });
    } else {
      const newImages = [];
      const detail = this.props.detail;
      const pictures = detail[witch];
      for (let i = 0; i < pictures.length; i++) {
        i == index ? null : newImages.push(pictures[i]);
      }
      this.props.updateDetail({
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
    this.props.setState({
      showBigPicArr,
      selectedImageIndex: index,
      visible: true,
      witch,
    });
  };
  renderImage = (witch, images, maxLength) => {
    let pictures = [];
    const detail = this.props.detail || {};
    if (maxLength == 1) {
      pictures = images ? [images] : [];
    } else {
      pictures = images ? [...images] : [];
    }
    let canAdd=!(pictures.length == maxLength || pictures.length > maxLength )
    let styleView;
    if (witch != 'pictures') {
      styleView = {
        borderTopWidth: 1,
        borderColor: '#F1F1F1',
        marginTop: 15,
      };
    }
    return (
      <View style={[styles.imageRightView, styleView]}>
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
                  source={require('../../../images/index/delete.png')}
                  sourceWidth={20}
                  sourceHeight={20}
                />
              </TouchableOpacity>
            </View>
          </View>
        ))}
        {canAdd? (
          <TouchableOpacity
            style={styles.imageViewTouch}
            onPress={() => {
              this.props.setState(
                {
                  modalVisible: true, witch, maxLength, selectOptions: ['拍照', '相册', '取消'],
                },
                this.props.showActionSheet(),
              );
            }}
          >
            <View style={[styles.imageViewTouch, { paddingTop: 5 }]}>
              <ImageView
                source={require('../../../images/index/add_pic.png')}
                sourceWidth={(width - 50 - 30) / 3}
                sourceHeight={(width - 50 - 30) / 3}
              />
            </View>
          </TouchableOpacity>
        ):null}
      </View>
    );
  }

  editAdress = () => {
    const { navigation,state } = this.props;
    const { currentShop } = state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('StoreAddress', {
      currentShop,
      address: detail.address,
      callback: data => this.props.updateDetail(data),
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
        source={require('../../../images/index/expand.png')}
        sourceWidth={14}
        sourceHeight={14}
        style={{ marginTop: 2 }}
      />
    </View>
  )

  selectType = () => [
    this.props.setState({
      selectOptions: ['店中店', '分店', '取消'],
    }, () => {
      this.props.showActionSheet();
    }),
  ]

  selectFenlei = () => {
    const { navigation,state } = this.props;
    const { currentShop } = state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('StoreFenlei', {
      callback: (industry, industryName) => this.props.updateDetail({
        industry,
        industryName,
      }),
      industry: detail.industry,
    });
  }

  selectYingyeTime = () => {
    const { navigation ,state} = this.props;
    const { currentShop } = state;
    const detail = JSON.parse(JSON.stringify(currentShop.detail || {}));
    navigation.navigate('YingyeTime', {
      callback: (data={}) => {
        console.log('营业时间',data)
        this.props.updateDetail({ newBusinessTime: data })
      },
      newBusinessTime: detail.newBusinessTime,
    });
  }
  renderYouhuiType=(detail)=>{
    const discountType=detail.discountType
    const list=[
      {key:'SHOP_DISCOUNT',view:(color)=><Text style={{color}}>店铺最低折扣</Text>},
      {key:'THE_CUSTOM_DISCOUNT', view:(color)=><Text style={{color}}>享会员优惠</Text>}
    ]
    const onPress=(discountType)=>{
      this.props.updateDetail({discountType})
    }
    return(
      <View>
        <View style={styles.saleTypeView}>
        {
          list.map((item,index)=>{
            const selected=discountType==item.key
            return(
              selected?
              <TouchableOpacity key={index} onPress={()=>onPress(item.key)}>
                <ImageBackground
                  style={[styles.saleTypeBut,{height:(((width-65)/2+10)/169)*58,width:(width-65)/2+10,marginTop:4}]}
                  source={require('../../../images/shop/shopBut.png')}
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
          discountType=='SHOP_DISCOUNT'?
          <Line
            title={'最低折扣'}
            type={'input'}
            placeholder={'请输入，例如8'}
            point={null}
            unit={'折'}
            style={{borderBottomWidth:0,paddingBottom:2,paddingRight:4}}
            value={detail.discount}
            styleInput={{ textAlign: 'right' }}
            onChangeText={(data)=>this.props.updateDetail({discount:data})}
          />
          :null
        }
      </View>
    )
  }
  rightViewXuanchuanyu = () => {
    const { currentShop, minMoney, maxMoney } = this.props.state;
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
            this.props.setState({
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
            this.props.setState({
              maxMoney: data,
            });
          }}
        />
        <Text style={[styles.contentTopText, { color: '#222' }]}> 元 </Text>
      </View>
    );
  }

  rightViewContracts = () => {
    const { currentShop,quhao,shortPhone } = this.props.state;
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
          onChangeText={data => this.props.updateDetail({
            contactPhones: [data],
          })
          }
        />

        <View style={styles.phoneView}>
          <TextInputView
            placeholder="区号"
            placeholderTextColor="#ccc"
            value={quhao}
            maxLength={4}
            keyboardType="numeric"
            inputView={{ width: 68 }}
            style={{ color: '#222', textAlign: 'right', paddingRight: 10 }}
            onChangeText={data => this.props.setState({
              quhao: data,
            })
            }
          />
          <Text style={{ width: 20 }}>  - </Text>
          <TextInputView
            placeholder="座机号码"
            placeholderTextColor="#ccc"
            value={shortPhone}
            maxLength={8}
            keyboardType="numeric"
            inputView={{ width: '36%' }}
            style={{
              textAlign: 'right',
              color: '#222',
            }}
            onChangeText={data => this.props.setState({
              shortPhone: data,
            })
            }
          />
        </View>
      </View>
    );
  }

  rightViewDescription = () => {
    const { currentShop } = this.props.state;
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
        onChangeText={data => this.props.updateDetail({
          description: data,
        })
        }
      />
    );
  }

  rightViewRange = () => {
    const { currentShop } = this.props.state;
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
          onChangeText={data => this.props.updateDetail({
            range: data,
          })
          }
        />
        <Text style={[styles.contentTopText, { color: '#222' }]}> 公里(km) </Text>
      </View>
    );
  }
  renderRolling=(detail)=>{
    const {useTopPic}=this.props.state
    return(
      <View style={{paddingBottom:10}}>
        <Line
          title='顶部滚动图片'
          type='switch'
          style={{borderBottomWidth:0,paddingBottom:useTopPic?0:5}}
          value={useTopPic ? true : false}
          onChangeText={(data) => {
              console.log('data',data)
              this.props.setState({useTopPic:data})
          }}
        />
        {
          useTopPic
          ?this.renderImage('rollingPics', detail.rollingPics, 9)
          :null
        }
      </View>
    )
  }
  render() {
    const { state, item,detail,setState } = this.props
    const {warningItem}=state
    let rightView
    let onPress
    let onChangeText
    switch(item.key){
      case 'avgConsumption':onChangeText=(data)=>setState({[item.key]:data});break;
      case 'address':onPress=this.editAdress;break;
      case 'industryName':onPress=this.selectFenlei;break;
      case 'newBusinessTime':onPress=this.selectYingyeTime;break;
      case 'shopType':onPress=this.selectType;break;
      case 'discountType':rightView=this.renderYouhuiType(detail);break;
      case 'xuanchuanyu':rightView=this.rightViewXuanchuanyu();break;
      case 'contactPhones':rightView=this.rightViewContracts(detail);break;
      case 'logo':rightView=this.renderImage('logo', detail.logo, 1);break;
      case 'qualifiedPictures':rightView=this.renderImage('qualifiedPictures', detail.qualifiedPictures, 9);break;
      case 'range':rightView=this.rightViewRange();break;
      case 'description':rightView=this.rightViewDescription();break;
      case 'pictures':rightView=this.renderImage('pictures', detail.pictures, 9);break;
    }
    return (
      item.key=='rollingPics'?
      this.renderRolling(detail):
      <Line
        title={item.title}
        type={rightView || item.type == 'radio' ? 'custom' : item.type}
        placeholder={item.placeholder}
        point={null}
        leftStyle={{ ...item.leftStyle, color: warningItem == item.key ? CommonStyles.globalRedColor : '#222' }}
        value={item.value}
        style={[{ justifyContent: 'space-between', alignItems: 'center' }, item.style]}
        onPress={onPress}
        styleInput={{ textAlign: 'right' }}
        unit={item.unit}
        onChangeText={(data)=>{onChangeText ?onChangeText(data) : this.props.updateDetail({[item.key]:data})}}
        rightTextStyle={[item.rightTextStyle, { textAlign: 'right' }]}
        rightView={
          item.type == 'radio'
            ? (
              <Radio
                contentstyle={{ flex: 1, flexWrap: 'wrap', marginLeft: 20 }}
                item0Style={{ flex: 1 }}
                item1Style={{ flex: 1 }}
                change={v => this.props.updateDetail({ [item.key]: v })}
                textStyle={{ color: '#777' }}
                value={detail[item.key]>0?1:0}
                options={item.items}
              />
            )
            : rightView
        }
      />
    )
  }
}

const styles = StyleSheet.create({

  content: {
    alignItems: 'center',
    paddingBottom: 10,
  },
  addressRightView: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    flex: 1,
    marginLeft: 10,
    alignItems: 'center',
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
  phoneView: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: 18,
    borderTopWidth: 1,
    borderColor: '#F1F1F1',
    justifyContent: 'flex-end',
    paddingRight: 15,
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
  },
  imageRightView:{
    flexDirection: 'row',
    position:'relative',
    width: width - 20,
    paddingHorizontal: 15,
    flexWrap: 'wrap',
    paddingTop: 12,
  }
});

export default connect(
  state => ({
    userInfo: state.user.user || {},
    merchant: state.user.merchant || []
  }), {
    navPage: (routeName, params = {}) => ({ type: 'system/navPage', payload: { routeName, params } }),
    takeOrPickImageAndVideo: (options, callback) => ({ type: "application/takeOrPickImageAndVideo", payload: { options, callback } }),
  }
)(ListItem);
