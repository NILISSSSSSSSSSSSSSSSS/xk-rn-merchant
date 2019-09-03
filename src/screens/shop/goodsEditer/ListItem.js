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
  TouchableHighlight,
  TouchableOpacity,
} from "react-native";
import { connect } from "rn-dva";
import * as utils from "../../../config/utils";
import CommonStyles from "../../../common/Styles";
import math from '../../../config/math.js';
import Picker from 'react-native-picker-xk';
import picker from '../../../components/Picker';
import ImageView from "../../../components/ImageView";
import Line from "../../../components/Line";
import TextInputView from "../../../components/TextInputView";
const { width, height } = Dimensions.get("window");
import PriceInputView from '../../../components/PriceInputView';
import { NavigationComponent } from "../../../common/NavigationComponent";
import SwipeRow from '../../../components/SwipeRow';
import { isset } from "../../../components/Actionsheet/utils";
class ListItem extends NavigationComponent {
  renderScaleView=()=>{
    const {state,navigation}=this.props
    const {requesParams}=state
    return(
      <View>
        <TouchableOpacity
                style={[
                  styles.contentTitle,
                  { flex: 1, flexDirection: 'row' },
                ]}
                onPress={() => (requesParams.skuAttr.length > 2
                  ? null
                  : navigation.navigate('GoodsScale', {
                    type: '新增',
                    skuAttr: requesParams.skuAttr,
                    callback: data => this.setScales(data),
                  }))
                }
              >
                <Text style={styles.title}>规格</Text>
                {requesParams.skuAttr.length > 2 ? null : (
                  <Text style={{ color: '#EE6161',textAlign: 'right',flex: 1}} > 新增 </Text>
                )}
              </TouchableOpacity>
              {requesParams.skuAttr.map((item, index) => (
                <SwipeRow style={{ backgroundColor: 'white' }} key={index} >
                  <TouchableOpacity
                    style={styles.delTextContainer}
                    onPress={() => this.deleteScale(index) }
                  >
                    <Text style={styles.deleteTextStyle}>删除</Text>
                  </TouchableOpacity>
                  <TouchableHighlight
                    underlayColor="#f1f1f1"
                    activeOpacity={0.5}
                    onPress={() => navigation.navigate(
                      'GoodsScale',
                      {type: '编辑',value: item,index,skuAttr: requesParams.skuAttr,callback: data => this.setScales(data)},
                    )}
                  >
                    <View style={{backgroundColor: 'white',paddingLeft: 15}} >
                      <View style={[styles.scaleView,{ borderBottomWidth: index == requesParams.skuAttr.length - 1 ? 0 : 1}]}>
                        <View>
                          <Text style={styles.title}> {item.name} {' '} </Text>
                          <View style={{ marginTop: 15, flexDirection: 'row' }}>
                            <Text style={styles.title}>规格： </Text>
                            <View style={{ flexDirection: 'row' }}>
                              {item.attrValues && item.attrValues.map(
                                  (item, index) => (
                                    <View style={styles.scaleTextView} key={index}>
                                      <Text style={styles.scaleText}>{item.name}</Text>
                                    </View>
                                  ),
                                )}
                            </View>
                          </View>
                        </View>
                        <ImageView
                          source={require('../../../images/index/expand.png')}
                          sourceWidth={14}
                          sourceHeight={14}
                        />
                      </View>
                    </View>
                  </TouchableHighlight>
                </SwipeRow>
              ))}
      </View>
    )
  }
  fenlei = (witch, value1, value2) => {
    const {
      requesParams,
      serviceCatalogs,
      industrys,
      serviceCatalogsName,
      industrysName,
    } = this.props.state;
    if (witch == 'goods' && serviceCatalogsName.length == 0) {
      Toast.show('请先添加品类');
      return;
    } if (witch == 'store' && industrysName.length == 0) {
      Toast.show('请先添加店铺分类');
      return;
    }
    Picker.init({
      ...picker.basicSet,
      pickerData: witch == 'goods' ? serviceCatalogsName : industrysName,
      selectedValue: [value1, value2],
      onPickerConfirm: (pickedValue) => {
        console.log(pickedValue);
        const category =JSON.parse(JSON.stringify(requesParams.base.category || {}))
        console.log('category',category)
        let name={};
        if (witch == 'goods') {
          name = {
            goodsClassificationName: pickedValue[1],
            goodsTypeIdName: pickedValue[0]
          };
          const goodsTypeItem=serviceCatalogs.find(item=>item.name == pickedValue[0])
          category.goodsTypeId=goodsTypeItem.code
          category.goodsClassificationId = goodsTypeItem.goodsCatalogs.find(item=>item.name == pickedValue[1]).id
        } else {
          name = {
            industryId1Name:  pickedValue[0],
            industryId2Name: pickedValue[1],
          };
          const industryItem=industrys.find(item=>item.name == pickedValue[0])
          category.industryId1=industryItem.code
          category.industryId2 = industryItem.children.find(item=>item.name == pickedValue[1]).code
        }
        this.props.setState({
          ...name,
          requesParams: {
            ...requesParams,
            base: {
              ...requesParams.base,
              category,
              ...category,
            },
          },
        });
      },
    });
    Picker.show();
  };
  deleteImg = (image, index) => {
    const newImages = [];
    const { requesParams } = this.props.state;
    const images = requesParams.base.showPics;
    for (let i = 0; i < images.length; i++) {
      i == index ? null : newImages.push(images[i]);
    }
    this.props.setState({
      requesParams: {
        ...requesParams,
        base: {
          ...requesParams.base,
          showPics: newImages,
        },
      },
    });
  };
  checkImage = (pictures, image, index) => {
    const showBigPicArr = [];
    pictures.map(item => showBigPicArr.push({ type: 'images', url: item }));
    this.props.setState({
      showBigPicArr,
      selectedImageIndex: index,
      visible: true,
    });
  };
  shopdDiscount = (key) => {
    // 选择店铺折扣
    const { requesParams, discountParams } = this.props.state;
    const {shopdDiscount}=discountParams
    this.props.setState({
      requesParams: {
        ...requesParams,
        base: {
          ...requesParams.base,
          discountType: key,
          discount: shopdDiscount,
        },
      },
    });
  };
  renderDiscountView=()=>{
    const { requesParams, customDiscount} = this.props.state;
    const base = requesParams.base;
    const items=[
      // {name:'店铺折扣',key:'SHOP_DISCOUNT'},
      {name:'使用会员价',key:'MEMBER_DISCOUNT',view:(color)=><Text style={{color}}>使用会员价</Text>},
      {name:'自定义折扣',key:'THE_CUSTOM_DISCOUNT',view:(color)=><Text style={{color}}>自定义折扣</Text>},
    ]
    const selectIcon=require('../../../images/shop/shopBut.png')
    const unSelectIcon=require('../../../images/shop/custom_unselect.png')
    return (
      <View style={{ width:width-50}}>
        <View style={{flexDirection: 'row',justifyContent:'space-between', alignItems: 'center',marginTop:10}}>
          {
            items.map((item,index)=>{
              const isSelect=item.key==base.discountType
              return(
                <View key={index}>
                  {
                    isSelect?
                    <TouchableOpacity  onPress={() => this.shopdDiscount(item.key)}>
                      <ImageBackground
                        style={[styles.saleTypeBut,{height:(((width-65)/2+10)/169)*58,width:(width-65)/2+10,marginTop:4}]}
                        source={require('../../../images/shop/shopBut.png')}
                        resizeMode="cover"
                      >
                          {item.view('#fff')}
                      </ImageBackground>
                    </TouchableOpacity>:
                    <TouchableOpacity
                      onPress={() => this.shopdDiscount(item.key)}
                      key={index}
                      style={[styles.saleTypeBut,{backgroundColor:'#F8F8F8',width:(width-65)/2}]}
                    >
                      {item.view('#666666')}
                    </TouchableOpacity>
                  }
                </View>
              )
            })
          }
        </View>
        {
          base.discountType=='THE_CUSTOM_DISCOUNT'?
          <Line
            title={'折扣'}
            type={'input'}
            inputType={'price'}
            placeholder={'请输入，例如8.5'}
            point={null}
            unit={'折'}
            style={{borderBottomWidth:0,paddingBottom:2,paddingRight:4,paddingLeft:0}}
            value={customDiscount.toString()}
            styleInput={{ textAlign: 'right' }}
            onChangeText={(data) => {
                    this.props.setState({
                        requesParams: {
                          ...requesParams,
                          base: {
                            ...requesParams.base,
                            discount: data,
                          },
                        },
                        customDiscount: data,
                      });
                  }}
          />
          :null
        }
      </View>
    )
  }
  renderPriceView=()=>{
    const {skuAttrValue,goodsTypeIdName,requesParams,customDiscount}=this.props.state
    return(
      <View>
        <Line
          title="价格设置"
          style={{ alignItems: 'flex-start',flexWrap: 'wrap' }}
          type="custom"
          point={null}
          rightView={this.renderDiscountView()}
        />
        {skuAttrValue
          && skuAttrValue.map((item, index) => {
            const hasWeight = goodsTypeIdName == '外卖类' || goodsTypeIdName == '在线购物';
            let discountPrice=math.multiply(math.divide(customDiscount || 0, 10),item.originalPrice || 0);
            let numArr= discountPrice.toString().split('.');
            numArr[1] && numArr[1].length>2?discountPrice=((discountPrice+0.01).toString().substring(0,numArr[0].length+3)):null;
            return (
              <View
                style={[styles.contentCon, { flexWrap: 'wrap', paddingBottom: 0 }]}
                key={index}
              >
                <Text style={styles.title}>{item.skuName && item.skuName.replace('|', '+')}</Text>
                <View style={[styles.row, { flexWrap: 'wrap', marginTop: 15, marginBottom: 20 }]}>
                  <View style={[styles.row, { width: hasWeight ? (width - 80) / 3 - 20 : (width - 60) / 2 - 20 }]}>
                    <PriceInputView
                      placeholder="请输入价格"
                      value={item.originalPrice}
                      style={{ flex: 1, minWidth: 20 }}
                      maxLength={10}
                      onChangeText={data => this.setPrice(data, index, 'originalPrice')}
                    />
                    <Text style={[styles.title, { marginLeft: 5 }]}>元</Text>
                  </View>

                  {hasWeight ? (
                    <View style={[styles.row, { marginLeft: 10, minWidth: (width - 70) / 3 - 30, justifyContent: 'flex-end' }]}>
                      <PriceInputView
                        placeholder="重量"
                        maxLength={6}
                        value={(item.weight && item.weight.toString()) || ''}
                        style={{ textAlign: 'right', flex: 1, minWidth: 20 }}
                        onChangeText={data => this.setPrice(data, index, 'weight')}
                      />
                      <Text style={[styles.title, { marginLeft: 5 }]}>g</Text>
                    </View>
                  ) : null}
                  <View style={[styles.row, { justifyContent: hasWeight ? 'flex-end' : 'flex-start', flex: 1 }]}>
                    <Text style={[styles.title, { marginLeft: 10, marginRight: 5, fontSize: 12 }]}>{requesParams.base.discountType=='MEMBER_DISCOUNT'?'会员价':'折扣价'}: </Text>
                    {
                      requesParams.base.discountType!='MEMBER_DISCOUNT'?
                      <Text numberOfLines={1} style={{ fontSize: 12 }}>
                        {discountPrice}
                      </Text>:
                      <PriceInputView
                      placeholder="会员价"
                      maxLength={10}
                      value={item.discountPrice}
                      style={{ textAlign: 'right', flex: 1, minWidth: 20 }}
                      onChangeText={data => {
                        this.setPrice(data, index, 'discountPrice')
                      }}
                    />
                    }
                    <Text style={[styles.title, { marginLeft: 5, fontSize: 12 }]}>元</Text>
                  </View>

                </View>
              </View>
            );
          })}
      </View>
    )
  }
  renderIntroView=()=>{
    const {requesParams}=this.props.state
    return(
      <TextInputView
        placeholder="请输入商品介绍，最多50字"
        placeholderTextColor="#ccc"
        style={{
          height: 100,
          textAlignVertical: 'top',
          textAlign: 'left',
          marginTop: Platform.OS === 'android' ? 0 : -5,
        }}
        maxLength={50}
        inputView={[
          styles.inputView,
          { height: 100 },
        ]}
        multiline
        value={requesParams.base.details}
        onChangeText={(data) => {
          this.props.setState({
            requesParams: {
              ...requesParams,
              base: {
                ...requesParams.base,
                details: data,
              },
            },
          });
        }}
      />
    )
  }
  renderPicView=()=>{
    const {requesParams}=this.props.state
    return(
      <View
      style={{
        flexDirection: 'row',
        width: width - 40,
        marginTop: 12,
        flexWrap: 'wrap',
      }}
    >
      {requesParams.base.showPics && requesParams.base.showPics.map(
          (valueImage, index) => (
            <View
              key={index}
              style={[ styles.imageViewTouch, { marginRight: (index + 1) % 3 === 0 ? 0 : 10 }]}
            >
              <View style={[ styles.imageViewTouch, { paddingTop: 3, position: 'relative'}]} >
                <TouchableOpacity
                  style={styles.imageView}
                  onPress={() => this.checkImage( requesParams.base.showPics, valueImage, index) }
                >
                  <ImageView
                    resizeMode="cover"
                    source={{ uri: utils.getPreviewImage(valueImage) }}
                    sourceWidth={(width - 50 - 30) / 3}
                    sourceHeight={(width - 50 - 30) / 3}
                  />
                  {valueImage == requesParams.base.mainPic ? (
                      <View style={styles.coverImageView}>
                        <Text style={{ color: 'white', fontSize: 10 }}> 封面</Text>
                      </View>
                    ) : null}
                </TouchableOpacity>
                <TouchableOpacity
                  style={{ position: 'absolute', top: 0, right: 0 }}
                  onPress={() => this.deleteImg(valueImage, index)}
                >
                  <ImageView
                    source={require('../../../images/index/delete.png')}
                    sourceWidth={20}
                    sourceHeight={20}
                  />
                </TouchableOpacity>
              </View>
            </View>
          ),
        )}

      {requesParams.base.showPics.length
        == 8 ? null : (
          <TouchableOpacity
            style={styles.imageViewTouch}
            onPress={() => this.props.showActionSheet()}
          >
            <View style={[styles.imageViewTouch, { paddingTop: 5 }]}>
              <ImageView
                source={require('../../../images/index/add_pic.png')}
                sourceWidth={(width - 50 - 30) / 3}
                sourceHeight={(width - 50 - 30) / 3}
              />
            </View>
          </TouchableOpacity>
        )}
    </View>
    )
  }
  setPrice = (data, index, witch) => {
    const skuAttrValue = JSON.parse(JSON.stringify(this.props.state.skuAttrValue || []));
    skuAttrValue.map((item,i)=>{
      index == i?skuAttrValue[i][witch] = data:null;
      return item
    })
    this.props.setState({ skuAttrValue});
  };

  setScales = (data) => {
    const skuAttrValue = [];
    if (data.length == 1) {
      for (let k = 0; k < data[0].attrValues.length; k++) {
        skuAttrValue.push({
          skuName: data[0].attrValues[k].name,
          originalPrice: '',
          discountPrice: '',
          skuCode: data[0].attrValues[k].code,
          weight: '',
        });
      }
    } else {
      for (let i = 0; i < data.length; i++) {
        for (let j = 0; j < data[i].attrValues.length; j++) {
          if (i < (data.length == 2 ? data.length - 1 : data.length - 2)) {
            for (let k = 0; k < data[i + 1].attrValues.length; k++) {
              if (data.length == 2) {
                skuAttrValue.push({
                  skuName: `${data[i].attrValues[j].name}+${data[i + 1].attrValues[k].name}`,
                  originalPrice: '',
                  discountPrice: '',
                  skuCode: `${data[i].attrValues[j].code}|${data[i + 1].attrValues[k].code}`,
                  weight: '',
                  skuUrl: '',
                });
              } else {
                if (i < data.length - 1) {
                  for (let h = 0; h < data[i + 2].attrValues.length; h++) {
                    skuAttrValue.push({
                      skuName: `${data[i].attrValues[j].name}+${data[i + 1].attrValues[k].name}+${data[i + 2].attrValues[h].name}`,
                      originalPrice: '',
                      discountPrice: '',
                      skuCode: `${data[i].attrValues[j].code}|${data[i + 1].attrValues[k].code}|${data[i + 2].attrValues[h].code}`,
                      weight: '',
                    });
                  }
                }
              }
            }
          }
        }
      }
    }
    this.props.setState({ skuAttrValue });
    this.props.changeRequestParams({
      skuAttr: data,
    });
  };

  deleteScale = (index) => {
    const skuAttr = this.props.state.requesParams.skuAttr;
    const newSpecifications = [];
    for (let i = 0; i < skuAttr.length; i++) {
      i === index ? null : newSpecifications.push(skuAttr[i]);
    }
    this.setScales(newSpecifications);
  };

  refound = () => {
    const { refundsList, requesParams } = this.props.state;
    const reservation = requesParams.reservation;
    let selectRefunds = {};
    for (const item of refundsList) {
      item.key == reservation.refunds ? (selectRefunds = item) : null;
    }
    this.props.navigation.navigate('GoodsRefund', {
      selectRefunds,
      refundsList,
      refundsTime: reservation.refundsTime,
      callback: (data, refundsTime) => {
        const reservation1 = {
          refunds: data ? data.key : '',
          refundsTime: data ? refundsTime : '',
          reservation: data ? 1 : 0,
        };
        this.props.setState({
          requesParams: {
            ...requesParams,
            reservation: reservation1,
            base: {
              ...requesParams.base,
              refound1: data ? data.title : '否',
              ...reservation1,
            },
          },
        });
      },
    });
  };
  render() {
    const { state, item,setState } = this.props
    const {warningItem,requesParams}=state
    let onPress
    switch(item.key){
      case 'goodsTypeIdName':onPress=()=>{this.fenlei('goods',state.goodsTypeIdName,state.goodsClassificationName)};break;
      case 'industryId1Name':onPress=()=>{this.fenlei('store', state.industryId1Name, state.industryId2Name)};break;
      case 'refound':onPress=this.refound;break;
    }
    return ( item.renderView?this[item.renderView]():
            <Line
            style={item.style ||{
              height: 50,
              paddingVertical: 0,
              alignItems: 'center',
            }}
            point={null}
            title={item.title}
            maxLength={item.maxLength}
            type={item.rightView?'custom':item.type}
            placeholder={item.placeholder}
            styleInput={{ textAlign: 'right' }}
            value={item.value}
            rightValueStyle={item.rightValueStyle}
            rightView={item.rightView?this[item.rightView]():null}
            onChangeText={(data) => {
              let value = data;
              if (item.key == 'goodsStatus') {
                data == true
                  ? (value = 'UP')
                  : (value = 'DOWN');
              }
              setState({
                requesParams: {
                  ...requesParams,
                  base: {
                    ...requesParams.base,
                    [item.key]: value,
                  },
                },
              });
            }}
            onPress={onPress}
          />
    )
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
  contentSwipe: {
    width,
    flex: 1,
    backgroundColor: 'yellow',
    justifyContent: 'center',
    alignItems: 'center',
  },
  line: {
    paddingVertical: 14,
    paddingHorizontal: 10,
    borderColor: '#F1F1F1',
    borderBottomWidth: 1,
  },
  scaleView: {
    borderColor: '#F1F1F1',
    paddingVertical: 15,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingRight: 15,
  },
  scaleRightView: {
    width: width - 20,
    borderTopWidth: 1,
    borderColor: '#F1F1F1',
    marginTop: 13,
  },
  title: {
    fontSize: 14,
    color: '#222222',
  },
  scaleTextView: {
    borderWidth: 1,
    borderColor: '#4A90FA',
    borderRadius: 16,
    marginRight: 10,
    justifyContent: 'center',
    alignItems: 'center',
    height: 16,
  },
  scaleText: {
    fontSize: 12,
    color: '#4A90FA',
    paddingHorizontal: 10,
  },
  contentTitle: {
    fontSize: 14,
    color: '#222222',
    paddingHorizontal: 15,
    paddingVertical: 18,
    borderWidth: 1,
    borderColor: '#F1F1F1',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
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
  },
  input: {
    flex: 1,
    padding: 0,
    textAlign: 'right',
    fontSize: 14,
    height: 20,
  },
  discountInput: {
    textAlign: 'center',
    fontSize: 12,
    color: '#222',
    width: 48,
    borderColor: '#ddd',
    borderWidth: 1,
    // height: 30,
    borderRadius: 6,
  },
  discountText: {
    fontSize: 12,
    marginLeft: 4,
  },
  contentCon: {
    paddingHorizontal: 15,
    paddingTop: 20,
    paddingBottom: 20,
    borderBottomWidth: 1,
    borderColor: '#f1f1f1',

  },
  introduction: {
    padding: 15,
    color: '#777777',
    fontSize: 14,
  },
  selectView: {
    width: '50%',
    flexDirection: 'row',
    alignItems: 'center',
  },
  imageViewTouch: {
    width: (width - 50 - 30) / 3 + 5,
    height: (width - 50 - 30) / 3 + 5,
  },
  imageView: {
    width: (width - 50 - 30) / 3 + 5,
    height: (width - 50 - 30) / 3 + 5,
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
  imageView: {
    width: (width - 50 - 30) / 3,
    height: (width - 50 - 30) / 3,
    borderRadius: 5,
    overflow: 'hidden',
  },
  selectDiscount:{
    width:(width-66)/2,
    height:58,
    alignItems:'center',
    justifyContent:'center'
  },
  saleTypeBut:{
    height:44,
    alignItems:'center',
    justifyContent:'center',
    borderRadius:8
  },
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
