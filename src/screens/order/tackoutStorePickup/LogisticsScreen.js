/**
 * 物流提交(v1.1)  - 已经过时
 */

 import React, { Component } from 'react'
 import { Text, View, ScrollView, ImageBackground, StyleSheet, Dimensions } from 'react-native'
import Header from '../../../components/Header';
import ReceiverCard from './components/ReceiverCard';
import CommonStyles from '../../../common/Styles';
import LogisticsCheck from './components/LogisticsCheck';
import { connect } from 'rn-dva';
import RiderCard from './components/RiderCard';
import GoodsSkuCard from './components/GoodsSkuCard';
import ThirdCard from './components/ThirdCard';
import FixedFooter, { FixedSpacer, FixedButton, FixedHeight, FixedTips } from '../../../components/FixedFooter';
import { fetchMerchantDispatchOrder, fetchmUserUploadLogistics } from '../../../config/Apis/order';

import math from '../../../config/math';

let backImg = require("../../../images/logistics/back.png");
const { width, height } = Dimensions.get("window");

const getWidth = (dP)=> {
  return dP * width / 375;
}

class LogisticsScreen extends Component {
  state = {
    logisticsName: "",
    logisticsNo: "",
    postType: "OWN",
  }

  componentDidMount(){
    const { navigation, logisticsQuery } = this.props;
    const { orderId, isGoodsTakeOut } = navigation.state.params || {};
    logisticsQuery(orderId)
  }

  submitForm() {
    const { navigation, logistics, currentPickRider, userShop, changeLastRider, changeLastLogisticsName } = this.props;
    let pickedRider = logistics.pickedRider || (currentPickRider && {...currentPickRider, isLast: true });
    const { orderId, isGoodsTakeOut, callback } = navigation.state.params || {};
    let { id: shopId } = userShop || {};
    let goodsData = logistics.goodsData || {};
    if(logistics.postType==="OWN") {
      let param = {
          phone: pickedRider.phone,
          shopId: shopId,
          riderId: pickedRider.id,
          realName: pickedRider.realName,
          goodsOrderNo: orderId,
          xKModule: 'shop',
          ...goodsData,
      }
      Loading.show()
      fetchMerchantDispatchOrder(param).then(res=> {
        // 回退页面，更新数据
        changeLastRider(pickedRider);
        callback && callback()
        navigation.goBack();
      }).catch(error=> {
        console.log("派单错误")
      })
    } else if(logistics.postType==="THIRD") {
      if(!logistics.logisticsNo){
          Toast.show('请录入单号')
          return
      }
      if(!logistics.logisticsName){
          Toast.show('请选择物流公司')
          return
      }
      let param = {
          logisticsName: logistics.logisticsName,
          orderId: orderId,
          logisticsNo: logistics.logisticsNo,
          postType: logistics.postType
      }
      Loading.show()
      fetchmUserUploadLogistics(param).then((res)=>{
        changeLastLogisticsName(logistics.logisticsName);
        callback && callback()
        navigation.goBack();
      }).catch(error=> {
        console.log("错误")
      })
    } else {
      let param = {
        orderId: orderId,
        postType: logistics.postType,
        logisticsName: "HIMSELF",
      }
      Loading.show()
      fetchmUserUploadLogistics(param).then((res)=>{
        callback && callback()
        navigation.goBack();
      }).catch(error=> {
        console.log("错误")
      })
    }
  }

   render() {
     const { navigation, changeLogistics, logistics, navChooseRider, orderDetail, navChoosePostCompany, navChooseGoodsSku } = this.props;
     const { orderId, isGoodsTakeOut, callback } = navigation.state.params || {};
     const { currentPickRider = null, goodsData = null} = logistics || {};
     const { address, name = "上官楚楚", phone } = orderDetail || {};
     let pickedRider = logistics.pickedRider || (currentPickRider && {...currentPickRider, isLast: true });
     let price = isGoodsTakeOut ? pickedRider ?pickedRider.price : 0 : goodsData ? goodsData.price : 0;
     if(logistics && !logistics.postType) logistics.postType = orderDetail.postType || "OWN";

     let fixedFooterBtns = [
       { type: "spacer"},
       logistics.postType==="OWN" ? { type: "tips", title: "配送费¥"+math.divide(price, 100), style: { marginRight: 10 }, titleStyle: { color: "#777", fontSize: 12, fontWeight: "normal" } } : null,
       { 
         type: "primary", 
         style: styles.fixedBlue, 
         title: "确认提交", 
         onPress: ()=> this.submitForm(), 
         disabled: (logistics.postType==="OWN" &&  !pickedRider) || (logistics.postType==="THIRD" &&  (!logistics.logisticsName || !logistics.logisticsNo)),
         disabledStyle: { backgroundColor: '#DFDFDF',}
       }
     ]
     return (
       <View style={styles.container}>
       <ScrollView  style={styles.contentContainer} style={styles.scrollContentContainer}>
         <View style={styles.statusBack}></View>
         <ImageBackground source={backImg} style={styles.headerBack}>
            <Header 
              goBack
              navigation={navigation}
              title="选择配送方式"
              headerStyle={styles.headerStyle}
              onBack={()=> callback && callback()}
            />
            <View style={styles.headerTitle}>
              <Text style={styles.headerTitleText}>收货人信息</Text>
            </View>
            <View style={styles.headerReceiver}>
                <ReceiverCard address={address} name={name} phone={phone} />
            </View>
         </ImageBackground>
         <LogisticsCheck value={logistics.postType} style={styles.logisticsCheck} onChange={(postType)=> changeLogistics({ postType })} />
         {
            [
              logistics.postType==="OWN" ? <RiderCard style={styles.riderCard} currentPickRider={pickedRider} onNavigate={()=> navChooseRider(orderId, isGoodsTakeOut)} /> : null,
              logistics.postType==="OWN" && !isGoodsTakeOut ? <GoodsSkuCard style={styles.riderCard} currentGoodsSku={logistics.goodsData} onNavigate={()=> navChooseGoodsSku(orderId)} /> : null,
              logistics.postType==="THIRD" ? <ThirdCard onChange={(thirdCardForm)=> changeLogistics(thirdCardForm)} style={styles.thridCard} logisticsNo={logistics.logisticsNo} logisticsName={logistics.logisticsName} onNavigate={()=> navChoosePostCompany(orderId)} /> : null
            ].filter(item=> !!item)
         }
       </ScrollView>
       <FixedFooter>
          {
            fixedFooterBtns.filter(btn=> !!btn).map(btn=> {
              switch (btn.type) {
                case "spacer": return <FixedSpacer />
                case "tips": return <FixedTips {...btn} />
                default: return <FixedButton {...btn} />;
              }
            })
          }
         </FixedFooter>
       </View>
     )
   }
}

export default connect(state=> ({
  logistics: state.order.logistics,
  orderDetail: state.order.orderDetail,
  userShop: state.user.userShop || {},
}), {
  logisticsQuery: (orderId)=> ({ type: 'order/logisticsQuery', payload: orderId }),
  changeLogistics: (item)=> ({ type: "order/changeLogistics", payload: item}),
  changeLastRider: (rider)=> ({ type: 'order/save', payload: { lastPickRider: rider }}),
  changeLastLogisticsName: (logisticsName)=> ({ type: 'order/save', payload: { lastLogisticsName: logisticsName }}),
  navChooseRider: (orderId, isGoodsTakeOut)=> ({ type: "system/navPage", payload: { routeName: "ChooseRider", params: { orderId, isGoodsTakeOut } } }),
  navChoosePostCompany: (orderId)=> ({ type: "system/navPage", payload: { routeName: "ChoosePostCompany", params: { orderId } } }),
  navChooseGoodsSku:  (orderId)=> ({ type: "system/navPage", payload: { routeName: "ChooseSendType2", params: { orderId } } }),
})(LogisticsScreen);

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
  },
  contentContainer: {
    flex: 1,
    marginBottom: FixedHeight + CommonStyles.footerPadding,
  },
  scrollContentContainer: {
    paddingBottom: 10
  },
  statusBack: {
    height: CommonStyles.headerPadding, 
    width,
    backgroundColor: CommonStyles.globalHeaderColor,
  },
  headerBack: {
    width,
    height: getWidth(150),
    overflow: "visible",
    marginBottom: 45
  },
  headerStyle: {
    backgroundColor: 'transparent',         
    height: 44,
    paddingTop: 0, 
  },
  headerReceiver: {
    height: 90,
    width: width,
    paddingHorizontal: 10,
    overflow: "visible",
    marginBottom: -45,
  },
  headerTitle: {
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'flex-end',
  },
  headerTitleText: {
    fontWeight: "bold",
    color: "#FFFFFF",
    fontSize: 20,
    marginLeft: 45,
    marginBottom: 18
  },
  logisticsCheck: {
    width: getWidth(355),
    marginHorizontal: getWidth(10),
    marginTop: getWidth(10),
  },
  riderCard: {
    width: getWidth(355),
    marginHorizontal: getWidth(10),
    marginTop: getWidth(10),
    paddingHorizontal: getWidth(15),
  },
  thridCard: {
    width: getWidth(355),
    marginTop: getWidth(10),
    marginHorizontal: getWidth(10),
    paddingHorizontal: getWidth(15),
  }
})