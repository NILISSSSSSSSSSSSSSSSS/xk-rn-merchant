/**
 * 福利抽奖 转盘
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    
    View,
    ScrollView,
    Text,
    TouchableOpacity,
    ImageBackground,
    Image,
    StatusBar,
    Platform,
    Clipboard
} from "react-native";
import { connect } from "rn-dva";

import config from "../../config/config";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as requestApi from "../../config/requestApi";
import * as nativeApi from "../../config/nativeApi";
import FlatListView from "../../components/FlatListView";
import WebViewCpt from "../../components/WebViewCpt";

const { width, height } = Dimensions.get("window");
import { NavigationComponent } from '../../common/NavigationComponent';

class WMLotteryActivityScreen extends NavigationComponent {
    static navigationOptions = {
        header: null
    };
    constructor(props) {
        super(props);
        this.state = {
            canGoBack: false
        };
    }
    screenDidFocus = (payload) => {
        StatusBar.setBarStyle('dark-content');
      }
  
    screenWillBlur = (payload) => {
        StatusBar.setBarStyle('dark-content');
    }

    componentDidMount() {
        // Loading.show();
    }

    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    postMessage = () => { };

    goBack = () => {
        const { navigation } = this.props;
        const { canGoBack } = this.state;

        if (canGoBack) {
            this.webViewRef.goBack();
        } else {
            navigation.goBack();
        }
    };

    componentWillUnmount() {
        Loading.hide();
    }
    // 跳转到客服
    gotoCunstom = () => {
        nativeApi.createXKCustomerSerChat();
    }
    goOrderDetail = (data) => {
        console.log('data',data)
        let _data = JSON.parse(data.replace('jsOpenCouponInfo,', ''))
        console.log('_data',_data)
        const { navigation } = this.props
        let nextData = {
            key: 4,
            nextOperTitle: null,
            nextOperFunc: null,
            more: [
                { title: "联系客服", func: () => { this.gotoCunstom() } },
            ],
            status: "交易完成"
        }
        let orderData = {
            orderId: _data.data.orderNo
        }
        navigation.navigate(
            "SOMOrderDetails",
            {
                nextData,
                data:orderData,
                callback: () => {},
            }
        );
    }
    render() {
        const { navigation, dispatch } = this.props
    //   let _url = `http://192.168.2.115:8083/#/lotteryactivity?regionCode=${global.regionCode}`
        let source = {
            // uri: `${config.baseUrl_h5}lotteryactivity?regionCode=000000`,
            uri: `${config.baseUrl_h5}lotteryactivity?regionCode=${global.regionCode}`,
            // uri: _url,
            showLoading: true,
            headers: { "Cache-Control": "no-cache" }
        }
        return (
            <View style={styles.container}>
                <StatusBar barStyle={'dark-content'} />
                {/* <Header
                    navigation={navigation}
                    goBack={true}
                    title='抽奖'
                    headerStyle={{ backgroundColor: CommonStyles.globalHeaderColor }}
                    titleTextStyle={{ color: '#fff' }}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    navigation.goBack();
                                }}
                            // onPress={() => { navigation.goBack() }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                /> */}
                <WebViewCpt
                    webViewRef={e => {
                        this.webViewRef = e;
                    }}
                    isNeedUrlParams={true}
                    source={source}
                    postMessage={() => {
                        this.postMessage();
                    }}
                    getMessage={data => {
                        console.log(data)
                        let params = data && data.split(",");
                        if (params[0] === "jsOpenAppShoppingCart") {
                            this.jsOpenAppShoppingCart(params);
                        } else if (params[0] === "jsHiddenXKHUDView") {
                            Loading.hide();
                        } else if (params[0] === "jsOpenCouponInfo") {
                            this.goOrderDetail(data)
                        } else if(params[0] === "jsOpenMyPrize"){
                            navigation.navigate('WMMyPrizeRecord');
                        } else if (params[0] === "jsOpenRedEnvelope") {
                            // Loading.hide();
                            // 跳转到消费抽奖商品详情页面
                            // navigation.navigate('WMXFGoodsDetail', {sequenceId: ''})
                        } else if (params[0] === 'jsOpenActRule') {
                            navigation.navigate('WMActiveRole')
                        } else if (params[0] === 'lotteryStart') { // 已经抽奖，需要刷新中奖公告页面
                            dispatch({ type: 'welfare/save', payload: { refreshPrizeMessage: true } })
                        } else {
                            console.log(params);
                        }
                    }}
                    navigationChange={canGoBack => {
                        // this.changeState('canGoBack', canGoBack);
                    }}
                />
                <Header
                    navigation={navigation}
                    headerStyle={styles.headerStyle}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            activeOpacity={0.6}
                            onPress={() => {
                                navigation.goBack();
                            }}
                        >
                            <Image
                                source={require("../../images/mall/goback_gray.png")}
                            />
                        </TouchableOpacity>
                    }
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    headerStyle: {
        position: "absolute",
        top: CommonStyles.headerPadding,
        left: 0,
        height: 44,
        width: 200,
        paddingTop: 0,
        backgroundColor: "transparent",
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%",
        width: 50
    },
    left: {
        width: 50
    }
});

export default connect(
    null,
    dispatch => ({ dispatch })
)(WMLotteryActivityScreen);
