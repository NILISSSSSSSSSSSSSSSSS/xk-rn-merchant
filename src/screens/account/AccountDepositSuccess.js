//保证金提取成功
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    BackHandler,
    Image,
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva";
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import * as requestApi from "../../config/requestApi";
import * as regular from "../../config/regular";
import ImageView from "../../components/ImageView";
import Content from "../../components/ContentItem";
import CommonButton from '../../components/CommonButton';
import NavigatorService from '../../common/NavigatorService';
const { width, height } = Dimensions.get("window");

export default class AccountDepositSuccess extends PureComponent {
    static navigationOptions = {
        header: null,
        gesturesEnabled: false, // 禁用ios左滑返回
    };
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props);

        this.state = {
            topParams:props.navigation.state.params || {}
        }
        this.listenBack()
    }
    listenBack=()=>{ //监听返回
        BackHandler.addEventListener('hardwareBackPress', this.onBackAndroid)
    }
    removeListen=()=>{
        BackHandler.removeEventListener('hardwareBackPress', this.onBackAndroid)
    }
    //触发返回键执行方法
    onBackAndroid = () => {
        this.goBack()
        return true;

    };
    componentWillUnmount(){
        this.removeListen()
    }
    goBack=()=>{
        this.removeListen()
        CustomAlert.onShow(
            "alert",
            "已冻结该身份权限，请重新登录",
            "登录",
            ()=>{NavigatorService.reset("Login")}
        );
    }

    render() {
        const { navigation } = this.props;
        const { topParams } = this.state;

        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={false}
                    title="提交成功"
                    leftView={
                        <TouchableOpacity
                            style={styles.headerLeftView}
                            onPress={this.goBack}
                        >
                            <Image
                                source={require("../../images/mall/goback.png")}
                            />
                        </TouchableOpacity>

                    }
                />

                <View style={styles.content}>
                    <Content style={{paddingHorizontal:40,paddingVertical:30,alignItems:'center'}}>
                        <ImageView
                            source={require("../../images/mall/pay_success.png")}
                            sourceWidth={66}
                            sourceHeight={66}
                            style={{marginBottom:12}}
                        />
                        <Text style={styles.text1}>提交成功，保证金将退回原支付账户</Text>
                        <Text style={styles.text1}>相关身份权益将停止使用。</Text>
                        <Text style={styles.text1}>如有问题，请联系晓可客服。</Text>
                        <CommonButton
                                title='确定'
                                style={styles.but}
                                textStyle={styles.butText}
                                onPress={this.goBack}
                            />
                        <View style={styles.butView}>
                            {/* <CommonButton
                                title='返回财务账户'
                                style={styles.but}
                                textStyle={styles.butText}
                                onPress={()=>navigation.navigate('FinancialAccount')}
                            /> */}
                            {/* <CommonButton
                                title='去缴费'
                                style={styles.but}
                                textStyle={styles.butText}
                                onPress={()=>navigation.navigate("PayCashDeposit", {
                                    callback:topParams.callback,
                                    name:topParams.name,
                                    merchantType:topParams.merchantType,
                                    page :'',
                                    canGoBack:true,
                                    route:'FinancialAccount'
                                })}
                            /> */}
                        </View>

                    </Content>

                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerLeftView: {
        width: 50,
        alignItems: 'center',
    },
    content: {
        width: width - 20,
        marginHorizontal: 10,
        marginTop: 10,
    },
    whiteBlock: {
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        height: 192,
        backgroundColor: "#fff",
    },
    text1: {
        fontSize: 14,
        color: "#222",
        marginTop: 6,
    },
    butView:{
        width:width-100,
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center'
    },
    but:{
        width:'40%',
        backgroundColor:'#fff',
        height:30,
        borderRadius:4,
        marginBottom:0,
        marginTop:30
    },
    butText:{
        color:CommonStyles.globalHeaderColor,
        fontSize:14
    }
});

