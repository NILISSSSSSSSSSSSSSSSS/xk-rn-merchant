/**
 * 关于我们
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    Button,
    Image,
    ScrollView,
    StatusBar,
    TouchableOpacity,
    Platform
} from "react-native";
import { connect } from "rn-dva";
import * as nativeApi from '../../config/nativeApi';
import DeviceInfo from 'react-native-device-info';
import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import { getProtocolUrl } from '../../config/utils'
const ruzhulogo = require('../../images/user/ruzhulogo.png')
const logotxt = require('../../images/user/logotxt.png')
const yizhanshi = require('../../images/user/yizhanshi.png')

const { width, height } = Dimensions.get("window");
function getwidth(val) {
    return width * val / 375
}
export default class AboutUsScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };

    constructor(props) {
        super(props);
        this.state = {
        }
    }

    componentDidMount() {
    }
    componentWillUnmount() {
    }
    handleGetShopProUrl = () => {
        const { navigation } = this.props
        getProtocolUrl('MAM_APP_USER_PROTOCOL').then((res)=> {
            navigation.navigate('AgreementDeal',{title:'晓可联盟商服务协议',uri: res.url})
        }).catch(()=> {
            // Toast.show("协议请求失败")
        })
    }
    handleGetShopConcealPro = () => {
        const { navigation } = this.props
        getProtocolUrl('MAM_PRIVACY_PROTOCOL').then((res)=> {
            navigation.navigate('AgreementDeal',{title:'晓可联盟隐私协议',uri: res.url})
        }).catch(()=> {
            // Toast.show("协议请求失败")
        })
    }
    render() {
        const { navigation } = this.props;
        return (
            <View style={styles.container}>
            {/* <StatusBar barStyle={'dark-content'} /> */}
                <Header
                    // headerStyle={{backgroundColor:'#fff'}}
                    goBack={true}
                    navigation={navigation}
                    // leftView={<TouchableOpacity
                    //     style={[styles.headerItem, styles.left]}
                    //     onPress={() => {
                    //         navigation.goBack();
                    //         }
                    //     }
                    // >
                    //     <Image source={require('../../images/mall/gobackblack.png')} />
                    // </TouchableOpacity>}
                    // titleTextStyle={{color:'#000'}}
                    title={"关于我们"}
                />
                <View style={styles.mainview}>
                    <Image source={ruzhulogo} style={styles.topIcon}/>
                    <Image source={logotxt}/>
                    <View style={styles.centertxt}>
                        <Image source={yizhanshi}/>
                    </View>
                    <View style={{flex:1,position:'absolute',bottom:0,alignItems:'center',paddingBottom:15}}>
                        <View style={styles.versionview}>
                            <Text style={styles.c9f10}>版本号{DeviceInfo.getVersion()}</Text>
                        </View>
                    </View>
                </View>
                <View>
                    <View style={styles.btnview}>
                        <View style={{flexDirection:'row',justifyContent:'center'}}>
                            <TouchableOpacity
                            onPress={()=>{
                                this.handleGetShopProUrl()
                            }}>
                                <Text style={styles.cbf10}>《晓可联盟商服务协议》</Text>
                            </TouchableOpacity>
                            <Text style={styles.cgrayf10}>和</Text>
                            <TouchableOpacity
                            onPress={()=>{
                                this.handleGetShopConcealPro()
                            }}>
                                <Text style={styles.cbf10}>《晓可联盟隐私协议》</Text>
                            </TouchableOpacity>
                        </View>
                        <Text style={styles.cgrayf10}>Copyright © 2019 四川晓可科技有限公司 .All Rights Reserved. </Text>
                    </View>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        // alignItems:'center'
    },
    cgrayf10:{
        color:'#3F3F3F',
        fontSize:10,
        lineHeight:13
    },
    cbf10:{
        color:'#4A90FA',
        fontSize:10,
        lineHeight:13
    },
    c9f10:{
        color:'#999999',
        fontSize:10
    },
    mainview:{
        // width:getwidth(355),
        height:height- 64-CommonStyles.headerPadding-CommonStyles.footerPadding - 46,
        // flex: 1,
        marginBottom:0,
        margin:10,
        backgroundColor:'#fff',
        borderRadius:8,
        alignItems:'center'
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
    },
    left: {
        width: 50
    },
    centertxtcontent:{
        color:'#999999',
        fontSize:20,
        fontFamily: 'STBaoliSC-Regular'
    },
    centertxt:{
        marginTop:45,
        alignItems:'center',
    },
    topIcon:{
        marginTop:60,
        width:100,
        height:100
    },
    btnview:{
        marginTop:15,
        justifyContent: 'center',
        alignItems: 'center'
    },
    versionview:{
        // backgroundColor: 'blue'
    }
});

