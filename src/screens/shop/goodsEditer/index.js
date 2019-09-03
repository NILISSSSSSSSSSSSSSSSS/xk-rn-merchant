/**
 * 编辑商品信息
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  Dimensions,

  View,
  Text,
  Button,
  Image,
  ScrollView,
  TouchableOpacity,
  Switch,
  TouchableHighlight,
  Platform,
} from 'react-native';
import { connect } from 'rn-dva';
import math from '../../../config/math.js';
import Picker from 'react-native-picker-xk';
import Header from '../../../components/Header';
import CommonStyles from '../../../common/Styles';
import ImageView from '../../../components/ImageView';
import TextInputView from '../../../components/TextInputView';
import * as utils from '../../../config/utils';
import * as nativeApi from '../../../config/nativeApi';
import * as requestApi from '../../../config/requestApi';
import Line from '../../../components/Line';
import Content from '../../../components/ContentItem';
import SwipeRow from '../../../components/SwipeRow';
import * as regular from '../../../config/regular';
import PriceInputView from '../../../components/PriceInputView';
import ShowBigPicModal from '../../../components/ShowBigPicModal';
import { NavigationPureComponent } from '../../../common/NavigationComponent';
import { TakeOrPickParams, TakeTypeEnum, PickTypeEnum } from '../../../const/application';
import ActionSheet from '../../../components/Actionsheet';
import {items} from './ItemsData'
import ListItem from './ListItem.js';
const { width, height } = Dimensions.get('window');
class GoodsEditorScreen extends NavigationPureComponent {
  static navigationOptions = {
    header: null,
  };

  constructor(props) {
    super(props);
    const params = JSON.parse(JSON.stringify(props.navigation.state.params || {}));
    const currentGoods = (params.currentGoods && {
      ...params.currentGoods,
    }) || {
        goods: {},
        category: {},
      };
    const currentShop = params.currentShop && { ...params.currentShop } || {};
    this.state = {
      showBigPicArr: [],
      requesParams: {
        base: {
          goodsName: '',
          details: '',
          shopId: currentShop.id,
          goodsTypeId: props.serviceCatalogList[0] && props.serviceCatalogList[0].code || '',
          purchased: 0,
          isSeatOnline: 1, // 商品类必须在线选座
          free: 0,
          deposit: 0,
          mainPic: '',
          goodsClassificationId: '',
          goodsStatus: 'DOWN',
          industryId1: '',
          industryId2: '',
          showPics: [],
          ...currentGoods.goods,
          ...currentGoods.goods.category,
          discount: (currentGoods.goods.discount && math.divide(currentGoods.goods.discount, 100)) || params.discountParams.shopdDiscount,
          discountType:currentGoods.goods.discountType || 'THE_CUSTOM_DISCOUNT', // 商品价格折扣类型 SHOP_DISCOUNT 店铺 THE_CUSTOM_DISCOUNT 自定义 MEMBER_DISCOUNT会员折扣
        },
        reservation: {
          refunds: currentGoods.goods.refunds || 'CONSUME_BEFORE',
          refundsTime: currentGoods.goods.refundsTime || 30 * 60,
          reservation: currentGoods.goods.refunds ? 1 : 0,
        },
        skuAttr:
          (currentGoods.goodsSkuAttrsVO
            && currentGoods.goodsSkuAttrsVO.attrList)
          || [],
        // skuAttrValue: currentGoods.goodsSkuVOList || []
      },
      images: [],
      callback: props.navigation.getParam('callback', (() => { })),
      currentShop,
      currentGoods,
      refundsList: params.refundsList || [],
      industrys: params.industrys || [],
      serviceCatalogs: params.serviceCatalogs || [],
      industrysName: params.industrysName || [],
      serviceCatalogsName: params.serviceCatalogsName || [],
      goodsClassificationName: params.goodsClassificationName || '',
      goodsTypeIdName: params.goodsTypeIdName || '',
      industryId1Name: params.industryId1Name || '',
      industryId2Name: params.industryId2Name || '',
      selectedImageIndex: 0,
      visible: false,
      discountParams:params.discountParams || {},
      customDiscount: (currentGoods.goods.discount && math.divide(currentGoods.goods.discount, 100)) || params.discountParams.shopdDiscount,
      oldParams: params,
      skuAttrValue: currentGoods.goodsSkuVOList && [...currentGoods.goodsSkuVOList] || [],
    };
  }

  blurState = {
    visible: false,
  }

  getIndurstry = () => {
    const { requesParams } = this.state;
    requestApi.shopAndCatalogQList({shopId: this.state.currentShop.id}).then((res) => {
        const newCate = [];
        const category = requesParams.base.category;
        const name = {
          goodsClassificationName: '',
          goodsTypeIdName: '',
          industryId1Name: '',
          industryId2Name: '',
        };
        for (const item of res.serviceCatalogs) {
          const cate = [];
          if (requesParams.base.id&& item.code == category.goodsTypeId) {
            name.goodsTypeIdName = item.name || '';
          }
          for (item2 of item.goodsCatalogs) {
            cate.push(item2.name);
            if (requesParams.base.id&& item2.code == category.goodsClassificationId) {
              name.goodsClassificationName = item2.name || '';
            }
          }
          newCate.push({ [item.name]: cate });
        }
        const newInd = [];
        for (const item of res.industrys) {
          const ind = [];
          if (requesParams.base.id&& item.code == category.industryId1) {
            name.industryId1Name = item.name || '';
          }
          for (item2 of item.children) {
            ind.push(item2.name || '');
            if (requesParams.base.id&& item2.code == category.industryId2) {
              name.industryId2Name = item2.name || '';
            }
          }
          newInd.push({ [item.name]: ind });
        }
        this.setState({
          industrysName: newInd,
          serviceCatalogsName: newCate,
          industrys: res.industrys,
          serviceCatalogs: res.serviceCatalogs,
          ...name,
        });
      }).catch((err)=>{
        console.log(err)
      });
  };

  componentWillUnmount() {
    this.props.navigation.state.params = this.state.oldParams;
    Picker.hide();
  }

  componentDidMount() {
    const { currentGoods, requesParams, currentShop } = this.state;
    if (!currentGoods.goods.id) {
      this.getIndurstry();
    }
  }


  save = (params) => {
    Loading.show();
    const { callback, currentGoods, } = this.state;
    const func = currentGoods.goods.id ? requestApi.shopGoodsUpdate : requestApi.shopGoodsCreate;
    func(params)
      .then((data) => {
        console.log(params);
        let tabPage = 0;
        for (let i = 0; i < this.props.serviceCatalogList.length; i++) {
          params.goods.base.goodsTypeId == this.props.serviceCatalogList[i].code ? tabPage = i : null;
        }
        if (params.goods.base.goodsStatus == 'UP' && currentGoods.goods.id) {
          requestApi.shopOBMAdded({ id: currentGoods.goods.id }).then(() => {
            callback(tabPage);
            Toast.show('修改成功');
            Loading.hide();
            this.props.navigation.goBack();
          }).catch(()=>{
          
          });
        } else {
          callback(tabPage);
          Loading.hide();
          Toast.show(currentGoods.goods.id ? '修改成功' : '新增成功');
          this.props.navigation.goBack();
        }
      }).catch(()=>{
          
      });
  }

  saveEditor = () => {
    const {
      currentGoods,
      skuAttrValue,
      goodsTypeIdName,
      requesParams,
      discountParams
    } = this.state;
    const params = JSON.parse(JSON.stringify(requesParams));
    params.skuAttrValue = JSON.parse(JSON.stringify(skuAttrValue));
    const isMemberPrice=params.base.discountType=='MEMBER_DISCOUNT'
    if (
      !params.base.goodsName
      || params.base.goodsName.length > 15
    ) {
      Toast.show('商品名称最多15个字，必填');
      return;
    }
    if (
      !params.base.details
      || params.base.details.length > 50
    ) {
      Toast.show('商品介绍最多50个字，必填');
      return;
    }
    if (params.skuAttr.length == 0) {
      Toast.show('请设置规格');
      return;
    }
    if (params.skuAttrValue.length == 0) {
      Toast.show('请设置规格价格');
      return;
    }
    if (!params.base.mainPic) {
      Toast.show('请点击展示图片设置商品主图');
      return;
    }
    if ((!regular.price(params.base.discount) || parseFloat(params.base.discount) == 0 || parseFloat(params.base.discount) > 10) && !isMemberPrice) {
      Toast.show('请输入正确格式的折扣,且大于0，最大为10');
      return;
    }
    for (let i = 0; i < params.skuAttr.length; i++) {
      for (let j = 0; j < params.skuAttr[i].attrValues.length; j++) {
        (params.skuAttr[i].attrValues)[j].showPics ? null : (params.skuAttr[i].attrValues)[j].showPics = params.base.mainPic;
      }
    }
    if (([params.base.deposit, params.base.free, params.base.zeroOrder].filter(item => item == 1)).length > 1) {
      Toast.show('免费下单、定金功能、最后结算时付款三种功能只能选择其一');
      return;
    }
    for (let i = 0; i < params.skuAttrValue.length; i++) {
      const wrongOriginalPrice=!regular.price(params.skuAttrValue[i].originalPrice)
      const memberPrice=parseFloat(params.skuAttrValue[i].discountPrice)
      let discountPrice=parseFloat(params.skuAttrValue[i].discountPrice)
      const wrongMemberPrice=!regular.price(params.skuAttrValue[i].discountPrice) && isMemberPrice
      const originalPrice=parseFloat(params.skuAttrValue[i].originalPrice)
      if (wrongOriginalPrice || wrongMemberPrice) {
        Toast.show(`请输入正确格式的规格${wrongOriginalPrice?'价格':'会员价'}`);
        return;
      }
      let finalOriginalPrice = math.multiply(params.skuAttrValue[i].originalPrice, 100);
      params.skuAttrValue[i].originalPrice = finalOriginalPrice;
      isMemberPrice?params.skuAttrValue[i].discountPrice=math.multiply(discountPrice,100) : params.skuAttrValue[i].discountPrice = (parseFloat(params.base.discount || 0) / 10) * finalOriginalPrice;
      params.skuAttrValue[i].skuUrl ? null : params.skuAttrValue[i].skuUrl = params.base.mainPic;
      discountPrice=params.skuAttrValue[i].discountPrice
      if (!(goodsTypeIdName == '服务类' && params.base.free) && ( originalPrice== 0 || discountPrice==0 || discountPrice<1)) {
        Toast.show('商品价格和折扣价格不能为0且不能小于0.01');
        return;
      }
      if(memberPrice && isMemberPrice && memberPrice>originalPrice){
        Toast.show('会员价格不能大于原价');
        return;
      }
      if (goodsTypeIdName == '服务类' && params.base.deposit && (params.skuAttrValue.length > 1 || (params.skuAttrValue.length == 1 && discountPrice === 0))) {
        Toast.show('服务类作为定金功能时,价格属性只能存在一条,且折后金额或会员价必须大于0');
        return;
      }
      if (goodsTypeIdName == '服务类' && params.base.free && discountPrice != 0 ) {
        Toast.show('免费下单时，折后金额或会员价必须为0');
        return;
      }
      if (goodsTypeIdName == '服务类' && params.base.zeroOrder && (params.skuAttrValue.length > 1 || (params.skuAttrValue.length == 1 && discountPrice == 0 ))) {
        Toast.show('选择最后结算时付款时,价格属性只能存在一条,且折后金额或会员价必须大于0');
        return;
      }
      
    }
    params.base.discount = math.multiply(params.base.discount, 100);
    if (
      goodsTypeIdName == '住宿类'
      || goodsTypeIdName == '外卖类'
      || (goodsTypeIdName == '服务类' && params.base.purchased != 1)
    ) {
      params.base.isSeatOnline = 0;
    } else {
      params.base.isSeatOnline = 1;
    }
    if (goodsTypeIdName == '外卖类' || goodsTypeIdName == '住宿类' || goodsTypeIdName == '在线购物') {
      params.base.purchased = 0;
      params.base.isSeatOnline = 0;
    }
    const params1 = {
      goods: params,
    };
    if (currentGoods.goods.id) {
      if (currentGoods.goods.goodsStatus == 'UP') {
        Loading.show();
        requestApi.shopOBMUnshelve({ id: currentGoods.goods.id }).then(() => { // 先下架，再修改
          this.save(params1);
        }).catch((err)=>{
          console.log(err)
        });
      } else {
        this.save(params1);
      }
    } else {
      this.save(params1);
    }
  };

  changeRequestParams = (data) => {
    this.setState({
      requesParams: {
        ...this.state.requesParams,
        ...data,
      },
    });
  };
  setCoverImage = () => {
    const { requesParams, selectedImageIndex } = this.state;
    this.setState({
      visible: false,
      requesParams: {
        ...requesParams,
        base: {
          ...requesParams.base,
          mainPic: requesParams.base.showPics[selectedImageIndex],
        },
      },
    });
  };
  addImage = (index) => {
    const { requesParams } = this.state;
    const { takeOrPickImageAndVideo } = this.props;
    let showPics = requesParams.base.showPics;
    const params = new TakeOrPickParams({
      func: index === 0 ? 'take' : 'pick',
      type: index === 0 ? TakeTypeEnum.takeImage : PickTypeEnum.pickImage,
      totalNum: 8 - showPics.length,
    });
    takeOrPickImageAndVideo(params.getOptions(), (res) => {
      showPics = showPics.concat(res.map(item => item.url));
      this.setState({
        requesParams: {
          ...requesParams,
          base: {
            ...requesParams.base,
            showPics,
            mainPic: showPics[0],
          },
        },
      });
    });
  };
  render() {
    this.props.navigation.state.params = this.state.oldParams;
    const { navigation } = this.props;
    const {
      requesParams
    } = this.state;
    const base = requesParams.base;
    return (
      <View style={styles.container}>
        <Header
          title="商品信息"
          navigation={navigation}
          goBack
          rightView={(
            <TouchableOpacity
              onPress={() => this.saveEditor()}
              style={{ width: 50 }}
            >
              <Text style={{ fontSize: 17, color: '#fff' }}>
                保存
              </Text>
            </TouchableOpacity>
          )}
        />
        <ScrollView alwaysBounceVertical={false} style={{ flex: 1 }} contentContainerStyle={{paddingBottom:CommonStyles.footerPadding}}>
          <View style={styles.content}>
            {
              items(this.state).map((item0, index0) => {
                return(
                  <Content key={index0}>
                    {
                      item0.map((item,index)=>{
                        return(
                          <View key={index} onLayout={(event) => { this[`${item.key}layout`] = event.nativeEvent.layout.y; }}>
                            <ListItem
                              state={this.state}
                              showActionSheet={() => this.ActionSheet.show()}
                              setState={(data, callback = () => { }) => this.setState(data, () => callback())}
                              item={item}
                              changeRequestParams={this.changeRequestParams}
                              navigation={navigation}
                              scrollToItem={this.scrollToItem}
                              updateDetail={this.updateDetail}
                              setCoverImage={this.setCoverImage}
                            />
                        </View>
                        )
                      })
                    }
                  </Content>
                )
              })
            }
          </View>
        </ScrollView>
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
            requesParams.base.mainPic != requesParams.base.showPics[this.state.selectedImageIndex]
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
});

export default connect(
  state => ({
    serviceCatalogList: state.shop.serviceCatalogList || [],
  }),
  {
    takeOrPickImageAndVideo: (options, callback) => ({ type: 'application/takeOrPickImageAndVideo', payload: { options, callback } }),
  },
)(GoodsEditorScreen);
