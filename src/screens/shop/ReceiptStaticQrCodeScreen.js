/* eslint-disable max-len */
/* eslint-disable no-irregular-whitespace */
/* eslint-disable react/no-string-refs */
/**
 * 静态二维码
 */
import React, { Component, PureComponent } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Dimensions,
  TouchableOpacity,
  ImageBackground,
} from 'react-native';
import CameraRoll from '@react-native-community/cameraroll';
import { connect } from 'rn-dva';
import QRCode from 'react-native-qrcode-svg';
import ViewShot from 'react-native-view-shot';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import ImageView from '../../components/ImageView';
import DashLine from '../../components/DashLine';
import ModalDemo from '../../components/Model';
import * as scanConfig from '../../config/scanConfig';
import config from '../../config/config';
import {RequestWritePermission} from '../../config/permission.js';

const { width, height } = Dimensions.get('window');
function getwidth(val) {
  return (width * val) / 375;
}

class ReceiptStaticQrCodeScreen extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {

    };
  }

    takeToImage=() => {
      this.refs.location.capture().then(async (uri) => {
        console.log(uri);
        let granted = await RequestWritePermission();
        if(!granted) return;
        CameraRoll.saveToCameraRoll(uri)
          .then((result) => {
            Toast.show('已保存到手机相册');
            console.log(`保存成功！地址如下：\n${result}`);
          })
          .catch((error) => {
            if(error=='Error: 用户拒绝访问'){
              CustomAlert.onShow(
                "alert",
                "若要继续保存图片，请到手机设置中心打开相册权限",
                "您已拒绝相册访问权限"
            );
            }else{
              alert(`保存失败！\n${error}`);   
            }
          });
      }).catch(
        error => alert(error),
      );
    }

      renderTakeImage=(qrUri) => {
        const { navigation, userShop } = this.props;
        const params = navigation.state.params || {};
        const shopIcon = params.logo || userShop.logo || '';
        console.log(qrUri);
        return (
          <ImageBackground
                resizeMode="stretch"
                style={styles.contentSty}
                source={require('../../images/qrcode/background.png')}
          >
            <View style={styles.storeImg}>
              <ImageView
                    source={shopIcon ? { uri: shopIcon } : require('../../images/qrcode/store.png')}
                    resizeMode="cover"
                    sourceWidth={83}
                    sourceHeight={83}
              />
            </View>
            <Text style={styles.storeName}>{params.title || userShop.name}</Text>
            <View style={styles.codeimg}>
              <QRCode
                value={qrUri}
                size={222}
              />
            </View>
          </ImageBackground>
        );
      }

      render() {
        const { navigation, user, userShop } = this.props;
        const params = navigation.state.params || {};
        let qrParams = {};
        const shopIcon = params.logo || userShop.logo || '';
        params.title
          ? qrParams = {// 店铺详情
            storeId: params.storeId || userShop.id,
            userId: user.id,
            lat: params.lat,
            lng: params.lng,
            securityCode: user.securityCode,
          }
          : qrParams = {// 静态二维码
            userId: user.id,
            merchantId: user.merchantId,
            storeId: userShop.id,
          };
        const takeImageUri =`${config.baseUrl_share_h5}codeShop?shopId=${params.storeId || userShop.id}&merchantId=${user.merchantId}&logo=${shopIcon}&name=${encodeURIComponent(`${params.title}`)}&securityCode=${user.securityCode}&condensationCode=1`;
        // const otherUri=scanConfig.qrCodeValue(params.title ?'store_detail':'store_receipt', qrParams)
        const otherUri = params.title ? takeImageUri : scanConfig.qrCodeValue('store_receipt', qrParams);
        return (
          <View style={styles.container}>
            <Header
                    title={params.title ? '店铺二维码' : '静态二维码'}
                    navigation={navigation}
                    goBack
                    rightView={
                        params.title
                        && (
                        <TouchableOpacity
                            style={styles.headerItem}
                            onPress={this.takeToImage}
                        >
                          <Text style={{ fontSize: 17, color: '#fff' }}>保存</Text>
                        </TouchableOpacity>
                        )
                    }
            />
            {
                    this.renderTakeImage(otherUri)
                }
            <ViewShot ref="location" style={{ position: 'absolute', top: -height }} options={{ format: 'png', quality: 1 }}>
              {this.renderTakeImage(takeImageUri)}
            </ViewShot>


          </View>
        );
      }
}

const styles = StyleSheet.create({
  container: {
    ...CommonStyles.containerWithoutPadding,
    alignItems: 'center',
    backgroundColor: '#4688ED',
  },
  headerItem: {
    width: 50,
  },
  contentSty: {
    width: 314,
    height: 415,
    marginTop: 57,
    alignItems: 'center',
  },
  storeImg: {
    // ...CommonStyles.shadowStyle,
    justifyContent: 'center',
    alignItems: 'center',
    width: 83,
    height: 83,
    marginTop: -83 / 2 + 21,
    borderWidth: 1,
    borderColor: '#F1F1F1',
    borderRadius: 83 / 2,
    backgroundColor: '#fff',
    overflow: 'hidden',
  },
  storeName: {
    fontSize: 16,
    color: '#000',
    fontWeight: '500',
    marginTop: 10,
    letterSpacing: 0.1,
  },
  codeimg: {
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    marginTop: getwidth(15),
  },
});

export default connect(
  state => ({
    user: state.user.user || {},
    userShop: state.user.userShop || {},
  }),
)(ReceiptStaticQrCodeScreen);
