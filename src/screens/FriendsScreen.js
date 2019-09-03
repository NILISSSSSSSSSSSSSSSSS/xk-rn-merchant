// /**
// * 好友列表
// */
// import { requireNativeComponent,Platform,View, DeviceEventEmitter,} from 'react-native';
// import React, { Component, PureComponent } from "react";
// var MerchantFriendFrameLayout = requireNativeComponent('MerchantFriendFrameLayout', null);
// var NativeFriendScreen = requireNativeComponent('NativeFriendScreen', null);
// // import MerchantFriendFrameLayout from '../components/FragmentAndroid';
//
// export default class FriendScreen extends Component {
//    componentDidMount() {
//
//    }
//    render() {
//        return (
//            Platform.OS=='ios'?
//            <NativeFriendScreen style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
//            </NativeFriendScreen>
//            // :<MerchantFriendFrameLayout style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
//            // </MerchantFriendFrameLayout>
//            :<MerchantFriendFrameLayout style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}/>
//        );
//    }
// }

/**
 * 好友列表
 */
import {
  requireNativeComponent, Platform, StatusBar, View,
} from 'react-native';
import React, { Component, PureComponent } from 'react';
import SplashScreen from 'react-native-splash-screen';
import { connect } from 'react-redux';
import MerchantFriendFrameLayout from '../components/FragmentAndroid';
import { JOIN_AUDIT_STATUS } from '../const/user';
import ListEmptyCom from '../components/ListEmptyCom';
import Header from '../components/Header';
import CommonStyles from '../common/Styles';
import Button from '../components/Button';
// var MerchantFriendFrameLayout = requireNativeComponent('MerchantFriendFrameLayout', null);
const NativeFriendScreen = requireNativeComponent('NativeFriendScreen', null);

class FriendScreen extends Component {
    listener;
    componentDidMount() {
      Platform.OS === 'ios' ? null : this.fragment && this.fragment.create();
      SplashScreen.hide();
      // var xkMerchantEmitterModule = NativeModules.xkMerchantEmitterModule;
      // const myNativeEvt = new NativeEventEmitter(xkMerchantEmitterModule);  //创建自定义事件接口
      // this.listenerGoodsDetail=myNativeEvt.addListener('goodsDetail',(goodsInfo)=>this.handleJumpDetail(goodsInfo,'goodsDetail'));
      // this.listenerWelfareDetail=myNativeEvt.addListener('welfareDetail',(goodsInfo)=>this.handleJumpDetail(goodsInfo,'welfareDetail'));
    }

    componentWillUnmount() {
      // this.listenerGoodsDetail.remove()
      // this.listenerWelfareDetail.remove()  componentWillMount() {
      StatusBar.setBarStyle('light-content');
    }
    handleJumpDetail = (goodsInfo, key) => { // 批发商城
      // console.log('goodsId',goodsInfo)
      // if(key=='goodsDetail'){ //goodsId 5be52bcf0334553f3f44eeac
      //     this.props.navigation.navigate("SOMGoodsDetail", {
      //         goodsId: goodsInfo
      //     });
      // }else{//goodsId {goodsId: "5c106cee033455043da7c820", sequenceId: "5c89b01c0334557fe4a6cca8"}
      //     this.props.navigation.navigate('WMGoodsDetail', {
      //         goodsId: goodsInfo.goodsId,
      //         sequenceId: goodsInfo.sequenceId
      //     })
      // }
    }

    toAcitivePage = () => {
      const { firstMerchant, navPage } = this.props;
      navPage('AccountActive', { route: 'Friends', merchantType: firstMerchant.merchantType });
    }

    render() {
      const { auditStatus, createdMerchant } = this.props.user || {};
      if (auditStatus !== JOIN_AUDIT_STATUS.active || createdMerchant !== 1) {
        return (
          <View style={[CommonStyles.flex_1, CommonStyles.flex_center, { backgroundColor: '#fff' }]}>
            <Header title="好友" />
            <ListEmptyCom type={auditStatus !== JOIN_AUDIT_STATUS.un_active ? 'Friends_Not_Audit' : 'Friends_Not_Active'} style={{ paddingTop: 0 }}>
              <View style={{ marginTop: 60, display: auditStatus === JOIN_AUDIT_STATUS.un_active ? 'flex' : 'none' }}>
                <Button style={{ height: 44, width: 149, borderRadius: 4 }} type="primary" onPress={this.toAcitivePage} title="立即激活" />
              </View>
            </ListEmptyCom>
          </View>
        );
      }
      return (
        Platform.OS == 'ios'
          ? <NativeFriendScreen style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }} />
        // :<MerchantFriendFrameLayout style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        // </MerchantFriendFrameLayout>
          : (
            <MerchantFriendFrameLayout ref={(ref) => {
              this.fragment = ref;
            }}
            />
          )
      );
    }
}

export default connect(state => ({
  user: state.user.user,
  firstMerchant: state.user.firstMerchant,
}), {
  navPage: (routeName, params) => ({ type: 'userActive/navPage', payload: { routeName, params } }),
})(FriendScreen);
