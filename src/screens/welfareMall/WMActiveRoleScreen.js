/**
 * 活动规则
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    TouchableOpacity,
    Image,
    StatusBar
} from "react-native";
import { connect } from "rn-dva";


import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import WebViewCpt from "../../components/WebViewCpt";
import config from "../../config/config";

const { width, height } = Dimensions.get("window");

class WMActiveRoleScreen extends PureComponent {
    static navigationOptions = {
        header: null
    };
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', async (payload) =>{
            StatusBar.setBarStyle('dark-content')
        });
        this.state = {
        };
    }

    componentDidMount() {
        // Loading.show();
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>{
            StatusBar.setBarStyle('light-content')
        });
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
        this._willBlurSubscription && this._willBlurSubscription.remove();
        this._didFocusSubscription && this._didFocusSubscription.remove();
        Loading.hide();
    }
    render() {
        const { navigation, store } = this.props;
        let _baseUrl = `${config.baseUrl_h5}actRule`;
        // let referralCode = store.user.user.securityCode;
        const {param}=navigation.state.params || {}
        let _url = `${_baseUrl}?${param||''}`;
        let source = {
            uri: _url,
            showLoading: true,
            headers: { "Cache-Control": "no-cache" }
        }
        return (
            <View style={styles.container}>
                <StatusBar
                    barStyle="dark-content"
                    translucent={true}
                    // backgroundColor={'#fff'}
                />
                <Header
                    navigation={navigation}
                    goBack={true}
                    title='抽奖规则'
                    headerStyle={{ backgroundColor: '#fff' }}
                    titleTextStyle={{ color: '#222' }}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    navigation.goBack();
                                }}
                            // onPress={() => { navigation.goBack() }}
                            >
                                <Image
                                    style={{ width: 23, height: 23 }}
                                    source={require("../../images/back_gray.png")}
                                />
                            </TouchableOpacity>
                        </View>
                    }
                />
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
                        let params = data && data.split(",");
                        if (params[0] === "jsOpenAppShoppingCart") {
                            this.jsOpenAppShoppingCart(params);
                        } else if (params[0] === "jsHiddenXKHUDView") {
                            Loading.hide();
                        } else {
                            console.log(params);
                        }
                    }}
                    navigationChange={canGoBack => {
                        // this.changeState('canGoBack', canGoBack);
                    }}
                />

            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding
    },
    flexCenter: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    ScrollView: {
        position: 'absolute',
        left: 0,
        top: 44 + CommonStyles.headerPadding,
        width: width,
        height: height - (44 + CommonStyles.headerPadding)
    },
    content: {
        width: width,
        height: height - (44 + CommonStyles.headerPadding),
        position: 'relative'
    },
    bgImg: {
        height: '100%',
        width: '100%',
        position: 'absolute',
        left: 0,
        top: 0,
    },
    modalView: {
        position: 'absolute',
        top: 0,
        left: -6,
        width: width - 44,
        height: height - (126 + CommonStyles.headerPadding),
    },
    modalViewImg: {
        height: '100%',
        width: '100%'
    },
    modal: {
        marginHorizontal: 28,
        marginTop: 55,
        backgroundColor: 'rgba(10,10,10,0)'
    },
    modalTitleWrap: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 20,
        paddingBottom: 4,
    },
    borderBottom: {
        borderBottomColor: '#EB0697',
        borderBottomWidth: 2,
        marginBottom: 20
    },
    modalTitle: {
        color: '#130863',
        fontSize: 20
    },
    modalTitleImg: {
        marginHorizontal: 3
    },
    article: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'flex-start',
        paddingBottom: 10,
        // marginHorizontal: 15,
        backgroundColor: '#f4f2f6',
        borderBottomRightRadius: 8,
        borderBottomLeftRadius: 8
    },
    rightArc: {
        flex: 1,
        paddingRight: 5
    },
    number: {
        height: 20,
        width: 20,
        marginLeft: 25,
        borderRadius: 20,
        textAlign: 'center',
        lineHeight: 20,
        color: '#fff',
        backgroundColor: '#DC149D',
        marginTop: 2,
    },
    rightContent: {
        paddingLeft: 14,
        // width: width - 120,
        lineHeight: 20
    },
    headerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: "100%"
        // position: 'absolute'
    },
    left: {
        width: 50
    }
});

export default connect(
    state => ({ store: state })
)(WMActiveRoleScreen);
