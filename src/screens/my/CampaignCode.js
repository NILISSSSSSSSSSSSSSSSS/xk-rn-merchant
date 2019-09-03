/**
 * 我的推广码
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Modal,
    Text,
    Image,
    TouchableOpacity,
    ImageBackground
} from "react-native";
import { connect } from "rn-dva";
import CameraRoll from '@react-native-community/cameraroll';
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import QRCode from "react-native-qrcode-svg";
import config from '../../config/config';
import CommonButton from '../../components/CommonButton';
import {RequestWritePermission} from '../../config/permission.js';
import ViewShot from 'react-native-view-shot';
import * as nativeApi from '../../config/nativeApi';
const { width, height } = Dimensions.get("window");
function getwidth(val) {
  return (width * val) / 375;
}

class CampaignCodeScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    constructor(props){
      super(props)
      this.state={
        visible:false,//分享弹框
      }
    }
    componentWillUnmount(){
      this.setState({visible:false})
    }
    takeToImage=() => { //保存图片
      this.refs.location.capture().then(async (uri) => {
        console.log(uri);
        let granted = await RequestWritePermission();
        if(!granted) return;
        CameraRoll.saveToCameraRoll(uri)
          .then((result) => {
            Toast.show('已保存');
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

    nextOprate=(item)=>{
      this.setState({visible:false},()=>{
        item.func && item.func()
      })
    }
    share=(type)=>{
      const {userInfo} = this.props;
      const url=config.baseUrl_share_h5+'scanCode?securityCode='+userInfo.securityCode
      const title='晓可广场，享最低折扣！'
      const info='点击立刻注册>>>>>>>>>'
      const iconUrl= 'https://gc.xksquare.com/logo/xkgc_icon.png'
      nativeApi.nativeShare(type, url, title, info, iconUrl).then((res) => {
        console.log('分享返回结果', res);
        Loading.hide();
      }).catch((e) => {
        Toast.show('分享失败，请重试！');
        Loading.hide();
      });
    }
    renderView=(isSave)=>{
      const {navigation,userInfo,} = this.props;
      const qrValue=config.baseUrl_share_h5+'scanCode?securityCode='+userInfo.securityCode
      let avatar=userInfo.avatar ==(config.netHeader+'://gc.xksquare.com/FgbxxWwWCxqHiTiD_2YBgfSlYmau') ||
                  !userInfo.avatar?
                  require('../../images/default/user.png')
                  :{ uri: userInfo.avatar }
      return(
        <ImageBackground style={{flex:1}} source={require('../../images/my/campaignCode_bg.png')}>
          {
            !isSave &&
            <TouchableOpacity style={styles.header} onPress={()=>navigation.goBack()}>
              <Image source={require('../../images/header/back.png')} style={{tintColor:'#fff'}}/>
            </TouchableOpacity>
          }

          <View style={[styles.content,{marginTop:isSave?getwidth(46)+CommonStyles.footerPadding:0}]}>
            <Image source={require('../../images/my/dicount_bg.png')} style={{width:getwidth(236),height:getwidth(171)}}/>
            <View style={{borderRadius:6,overflow:'hidden'}}>
              <ImageBackground style={styles.card} source={require('../../images/my/qrcode_bg.png')}>
                  <View style={styles.codeView}>
                      <QRCode
                          value={qrValue}
                          size={getwidth(205)}
                          logo={avatar}
                          logoSize={getwidth(50)}
                      />
                  </View>
                  <Text style={styles.textView_text1}>安全码：{userInfo.securityCode}</Text>
              </ImageBackground>
            </View>
          {
            !isSave &&
            <CommonButton
              title='分享'
              textStyle={{color:'#5270FF'}}
              style={styles.button}
              onPress={()=>this.setState({visible:true})}
            />
          }
            <Text style={[styles.bottomText,{marginTop:isSave?getwidth(55):getwidth(14)}]}>扫码下载晓可广场，享万店最低折扣！</Text>
          </View>
        </ImageBackground>
      )
    }

    render() {
      const modalItems=[
        {name:'微信好友',func:()=>this.share('WX'),icon:require('../../images/my/wechat_share.png')},
        {name:'朋友圈',func:()=>this.share('WX_P'),icon:require('../../images/my/friends_share.png')},
        {name:'QQ',func:()=>this.share('QQ'),icon:require('../../images/my/qq_share.png')},
        // {name:'复制图片',icon:require('../../images/my/copy_share.png')},
        {name:'保存本地',func:this.takeToImage, icon:require('../../images/my/save_share.png')},
      ]
        return (
            <View style={styles.container}>
                {this.renderView(0)}
                <ViewShot ref='location' style={styles.saveView}>
                  {this.renderView(1)}
                </ViewShot>

                <Modal
                  animationType={'slide'}
                  visible={this.state.visible}
                  transparent={true}
                >
                  <TouchableOpacity onPress={()=>this.setState({visible:false})} style={styles.modalTop}/>
                  <View style={styles.modalContent}>
                    <View style={styles.shareView}>
                        {
                          modalItems.map((item,index)=>{
                            return(
                              <TouchableOpacity key={index} onPress={()=>this.nextOprate(item)}>
                                <Image source={item.icon}/>
                                <Text style={styles.shareText}>{item.name}</Text>
                              </TouchableOpacity>
                            )
                          })
                        }
                    </View>
                    <TouchableOpacity
                      style={{flex:1,alignItems:'center',justifyContent:'center'}}
                      onPress={()=>this.setState({visible:false})}
                    >
                      <Text style={{color:'#222',fontSize:14}}>关闭</Text>
                    </TouchableOpacity>
                  </View>
                </Modal>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    header:{
      marginTop:CommonStyles.headerPadding+getwidth(20),
      width:getwidth(50),
      alignItems:'center'
    },
    content: {
        alignItems: "center",
        flex: 1,
        paddingBottom:CommonStyles.footerPadding
    },
    card: {
        width: getwidth(306),
        height: getwidth(335),
        justifyContent: "center",
        alignItems: "center"
    },
    codeView: {
        padding:5,
        backgroundColor:'#fff'
    },
    textView_text1: {
        fontSize: 17,
        color: "#fff",
        marginTop:getwidth(20)
    },
    button:{
      marginTop:getwidth(20),
      width:getwidth(306),
      backgroundColor:'#fff',
      marginBottom:0,
      height:getwidth(40)
    },
    bottomText:{
      color:'#fff',
      fontSize:14
    },

    modalTop:{
      backgroundColor:'rgba(0,0,0,0.5)',
      flex:1
    },
    modalContent:{
      backgroundColor:'#fff',
      width,
      height:152+CommonStyles.footerPadding,
      paddingBottom:CommonStyles.footerPadding,
      borderTopLeftRadius:8,
      borderTopRightRadius:8
    },
    saveView:{
      position:'absolute',
      top:-height,
      width,
      height
    },
    shareView:{
      flexDirection:'row',
      padding:25,
      justifyContent:'space-between',
      borderBottomColor:'#f1f1f1',
      borderBottomWidth:1
    },
    shareText:{
      marginTop:7,
      color:'#777',
      fontSize:10,
      textAlign:'center'
    }
});

export default connect(
    state => ({
      merchantData:state.user.merchantData || {},
      userInfo:state.user.user || {}
     })
)(CampaignCodeScreen);
