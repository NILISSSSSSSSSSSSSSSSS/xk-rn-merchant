/**
 * 注册提交完成
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Platform,
    Image,
    TouchableOpacity,
    BackHandler,
} from "react-native";
import { connect } from "rn-dva";
import NavigatorService from '../../common/NavigatorService';

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import ImageView from "../../components/ImageView";
import CommonButton from '../../components/CommonButton';
import { NavigationComponent } from "../../common/NavigationComponent";
const { width, height } = Dimensions.get("window");

class ApplyFormDoneScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };
    constructor(props) {
        super(props);
        const params = props.navigation.state.params || {}
        const merchantType=params.merchantType || 'shops'
        this.state = {
            type: params.type || '',
            merchantType,
            joinStatus:params.joinStatus,
            auditStatus:params.auditStatus,
            route:params.route
        }
    }
    screenDidFocus = (payload)=> {
      BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid)
    }

    screenWillBlur = (payload) => {
      this.removeEventListener()
    }
    removeEventListener=()=>{
      BackHandler.removeEventListener('hardwareBackPress',this.onBackAndroid)
    }
     //触发返回键执行方法
     onBackAndroid = () => {
        this.goBack()
        return true;
    };
    goNext=()=>{
      this.removeEventListener()
        const {navigation}=this.props
        this.refresh()
        if(this.state.route){
            navigation.navigate(this.state.route)
        }else{
            NavigatorService.resetTab("My", {})
        }
    }
    refresh=()=>{
        this.props.getMerchantHome()
    }
    goBack=()=>{
        this.goNext()
    }

    render() {
        const { navigation} = this.props;
        const {route}=this.state
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title="提交完成"
                    leftView={
                        <TouchableOpacity
                            style={{width:50,alignItems:'center'}}
                            onPress={this.goBack}
                        >
                            <Image
                                source={require("../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>

                    }
                />

                <View style={styles.content}>
                  <ImageView
                      source={require("../../images/mall/pay_success.png")}
                      sourceWidth={66}
                      sourceHeight={66}
                      style={{marginTop:30}}
                  />
                  {
                    route=='StoreManage' || route=='StoreDetail' ?
                    <View style={{alignItems:'center'}}>
                      <Text style={{marginTop:18,fontSize:14}}>店铺信息提交完成</Text>
                      <Text style={{marginTop:4,fontSize:14}}>请等待平台审核</Text>
                    </View>:
                    <Text style={styles.text1}>联盟商信息提交完成</Text>
                  }
                  <CommonButton title={'返回'} onPress={() => { this.goNext() }} style={styles.btn}/>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    content: {
        width: width - 20,
        marginHorizontal: 10,
        marginTop: 10,
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#fff",
        borderRadius:6,
        paddingBottom:30
    },
    text1: {
        fontSize: 17,
        fontWeight:'bold',
        color: "#222",
        marginTop: 18,
    },
    btn: {
        width:width-50,
        marginTop:30,
        marginBottom:0
    },
});

export default connect(
    state => ({
        userInfo:state.user.user || {}
    }),{
        getMerchantHome:(payload={})=>({type: 'user/getMerchantHome', payload }),
    }
)(ApplyFormDoneScreen);
