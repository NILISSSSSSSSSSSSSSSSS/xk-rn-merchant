/**
 * 自营商城商品详情页
 */
import React, { Component, PureComponent } from "react";
import {
    StyleSheet,
    Dimensions,
    View,
    Text,
    TouchableOpacity,
    ImageBackground,
    Image,
    StatusBar,
    Platform,
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import config from "../../config/config";
import CommonStyles from "../../common/Styles";
import Header from "../../components/Header";
import * as requestApi from "../../config/requestApi";
import FlatListView from "../../components/FlatListView";
import WebViewCpt from "../../components/WebViewCpt";
import ShareTemplate from '../../components/ShareTemplate';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import * as nativeApi from "../../config/nativeApi";

const { width, height } = Dimensions.get("window");
const weibo = require("../../images/share/weibo.png");
const weixin = require("../../images/share/weixin.png");
const qqicon = require("../../images/share/qqicon.png");
const friendsquan = require("../../images/share/friendsquan.png");
const copylian = require("../../images/share/copylian.png");
const friends = require("../../images/share/friends.png");

class SOMGoodsDetailScreen extends Component {
    static navigationOptions = {
        header: null
    };
    _willBlurSubscription;
    _didFocusSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>{
            StatusBar.setBarStyle('dark-content')
        });
        this.state = {
            goodsData:{},
            canGoBack: false,
            modalVisible: false,
            modalLists: [
                {
                    id: 1,
                    title: "分享",
                    icon: require("../../images/mall/share.png"),
                    // routeName: "SOMShareTemp"
                    routeName: ""
                },
                {
                    id: 2,
                    title: "意见反馈",
                    icon: require("../../images/mall/fankui.png"),
                    routeName: "Feedback"
                }
            ],
            shareModal: false,
            shareUrl: "", // 分享链接
            shareParams: null,
            showBingPicVisible: false,
            bigIndex: 0, // 大图索引
            bigList: [], // 查看大图所有图片rr
            goodsId:(global.nativeProps && global.nativeProps.goodsId) || this.props.navigation.getParam('goodsId',''),
            prohibit: false, // 是否禁止webView加入购物车和立即购买
        };
    }

    componentDidMount() {
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            StatusBar.setBarStyle('light-content')
        );
        const { identityStatuses } = this.props.userInfo
        let temp = identityStatuses.map(item => item.auditStatus === 'active' ? true : false)
        if (!temp.includes(true)) {
            this.setState({
                prohibit: true,
            })
        }
        // if(global.nativeProps){ //如果是从原生到rn，获取用户信息初始化
        //      this.props.actions.changeState({user:global.loginInfo })
        // }
    }
    componentWillUnmount () {
        Loading.hide();
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    getGoodsDetail = () => {
        Loading.show();
        requestApi.goodsDetail({
            id: this.state.goodsId,
        }).then(res => {
            console.log('商品详情',res)
            this.props.navigation.navigate('Feedback',{ goodsData:res.base });
        }).catch(err => {
            console.log(err)
        })
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
            global.nativeProps?nativeApi.popToNative():
            navigation.goBack();
        }
    };
    //进入结算界面： SOMOrderConfirm
    jsOpenSOMOrderConfirm = e => {
        let index = e.indexOf(",");
        let str = e.substring(index + 1);
        let data = JSON.parse(str);
        let goodsList = [];
        console.log('data', data)
        if (data) {
            goodsList[0] = {};
            goodsList[0].goodsId = data.goodsAttrs.goodsId;
            goodsList[0].quantity = data.quantity;
            goodsList[0].goodsSkuCode = data.base.defaultSku.code;
            goodsList[0].goodsAttr = data.base.defaultSku.name;
            goodsList[0].goodsName = data.base.name;
            goodsList[0].url = data.base.showPicUrl[0];
            goodsList[0].price = data.base.defaultSku.price;
            goodsList[0].buyPrice = data.base.defaultSku.buyPrice;
            goodsList[0].goodsDivide = data.base.goodsDivide
            goodsList[0].subscription = data.base.defaultSku.subscription || 0
        }
        this.props.navigation.navigate("SOMOrderConfirm", {
            goodsList: goodsList
        });
    };
    // 打开购物车
    jsOpenAppShoppingCart = e => {
        this.props.navigation.navigate("SOMShoppingCart");
    };
    // 打开客服
    jsOpenAppCustomerService = e => {
        // Toast.show("开发中");
        nativeApi.createXKCustomerSerChat()
        // this.props.navigation.navigate('NativeCustomerService')
    };
    // 打开图片浏览
    jsOpenAppImageBrowser = param => {
        console.log("打开图片浏览",param);
        let _params = param.replace('jsOpenAppImageBrowser,','');
        let _data = JSON.parse(_params);
        let { index,list } = _data
        let temp = [];
        list.map(item => {
            if (item.type === 'img') {
                temp.push({
                    type: 'images',
                    url: item.url
                })
            }
            if (item.type === 'video') {
                temp.push({
                    mainPic: item.mainPic,
                    url: item.url,
                    type: 'video'
                })
            }
        })
        console.log(temp)
        StatusBar.setHidden(true);

        this.setState({
            bigIndex: index,
            bigList: temp,
            showBingPicVisible: true,
        })
    };
    // 打开全部评价
    jsOpenAppComments = e => {
        this.props.navigation.navigate("SOMGoodsComments", {
            goodsId:this.state.goodsId
        });
    };
    //  获取分享路径
    pushSharePath = e => {
        e = JSON.parse(e);
        console.log(e);
        this.changeState("shareUrl", e.shareUrl);
        this.changeState("shareParams", e.param);
    };

    // 加入购物车
    addToCart = () => {
        requestApi.requestGoodsSku({ goodsId }, res => {
            let goodsSkuCode = res.skuAttrValue[0].code;
            let quantity = 1;
            requestApi.requestMallCartCreate(
                { goodsId, goodsSkuCode, quantity },
                () => {
                    Toast.show("加入购物车成功");
                }
            );
        });
    };

    // 获取分析模板，如果没有弹窗
    handleGetShareInfo = () => {
        const { shareParams, prohibit , shareUrl,goodsId } = this.state;
        // 判断用户身份只有一个的时候是否入驻成功
        if (prohibit) {
            Toast.show('您尚未成功入驻，暂不能分享该商品！')
            return
        }
        requestApi.promotionTemplateQList({
            goodsId,
        }).then(res => {
            console.log('获取分析模板',res)
            if (res) { // 如果获取到了模板
                this.props.navigation.navigate('SOMShareTemp',{shareParams,shareUrl,goodsId})
            } else {
                if (shareParams) {
                    this.changeState("shareModal",true);
                } else {
                    Toast.show("获取分享信息失败");
                }
            }
        }).catch(err => {
            console.log(err)
        });
    }
    handleShowpage = () => {
        const { bigList,bigIndex } = this.state
        if (bigList.length > 0) {
            return !(Platform.OS === 'ios' && bigList[bigIndex].type === 'video')
        }
        return true
    }
    render() {
        const { navigation, userInfo } = this.props;
        const { goodsData, modalVisible, modalLists, shareModal, shareParams, shareUrl,goodsId,prohibit } = this.state;
        let _baseUrl = `${config.baseUrl_h5}goodsdetail`;
        let referralCode = userInfo.securityCode;
        let isHiddenPrice = ''
        if (prohibit) {
            isHiddenPrice='yes'
        } else {
            isHiddenPrice='no'
        }
        let _url = `${_baseUrl}?id=${goodsId}&merchantId=${userInfo.merchantId}&securityCode=${referralCode}&prohibit=${isHiddenPrice}`
        // let _url = `http://192.168.2.115:8080/#/goodsdetail?id=${goodsId}&merchantId=${userInfo.merchantId}&securityCode=${referralCode}&prohibit=${isHiddenPrice}`
        let source = {
            uri: _url,
            showLoading: true,
            headers: { "Cache-Control": "no-cache" }
        }
        console.log('showBingPicVisible',this.state.showBingPicVisible)
        return (
            <View style={styles.container}>
                <StatusBar barStyle={'dark-content'} />
                <WebViewCpt
                    loginInfo={global.loginInfo}
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
                        } else if (params[0] === "jsOpenAppCustomerService") {
                            this.jsOpenAppCustomerService(params);
                        } else if (params[0] === "jsOpenAppImageBrowser") {
                            this.jsOpenAppImageBrowser(data);
                        } else if (params[0] === "jsOpenAppComments") {
                            this.jsOpenAppComments(params);
                        } else if (params[0] === "jsOpenIndianaShopOrder") {
                            this.jsOpenSOMOrderConfirm(data);
                        } else if (params[0] === "pushSharePath") {
                            let _data = data.replace("pushSharePath,", "");
                            this.pushSharePath(_data);
                        } else if (params[0] === "jsHiddenXKHUDView") {
                            Loading.hide();
                        } else if (params[0] === "jsOpenUsrHome") {
                            let _data = data.replace('jsOpenUsrHome,','')
                            console.log('_data',_data)
                            nativeApi.jumpPersonalCenter(JSON.parse(_data).userId)                            
                        } else if (params[0] === "jsOpenZyMallStore") {
                            let _data = data.replace('jsOpenZyMallStore,','')
                            navigation.navigate('SOMShopDetail',JSON.parse(_data))
                        }else {
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
                            style={[CommonStyles.flex_center,styles.headerItem]}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.goBack();
                            }}
                        >
                            <Image
                                source={require("../../images/mall/goback_gray.png")}
                            />
                        </TouchableOpacity>
                    }
                    rightView={
                        <TouchableOpacity
                            style={[CommonStyles.flex_center,styles.headerItem]}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.changeState("modalVisible", true);
                            }}
                        >
                            <Image
                                source={require("../../images/mall/more_gray.png")}
                            />
                        </TouchableOpacity>
                    }
                />
                {/* 点击更多弹窗 */}
                {modalVisible && (
                    <TouchableOpacity
                        style={styles.modalOutView}
                        activeOpacity={1}
                        onPress={() => {
                            this.changeState("modalVisible", false);
                        }}
                    >
                        <ImageBackground
                            style={styles.modalInnerView}
                            source={require("../../images/mall/more_gray_modal.png")}
                        >
                            <View style={styles.moreModalWrap}>
                                {modalLists.map((item, index) => {
                                    let border = index === modalLists.length - 1 ? null : styles.border;
                                    return (
                                        <View style={{flex: 1,width: '100%',paddingHorizontal: 15,...CommonStyles.flex_center}} key={index}>
                                            <TouchableOpacity
                                                style={[styles.modalInnerItem,border]}
                                                activeOpacity={0.6}
                                                onPress={() => {
                                                    this.changeState("modalVisible",false);
                                                    if (item.routeName) { // 有路由就是反馈，没有就是分享
                                                        this.getGoodsDetail()
                                                    } else {
                                                        this.handleGetShareInfo()
                                                    }

                                                }}
                                            >
                                                <Image source={item.icon} />
                                                <Text
                                                    style={styles.modalInnerItem_text}
                                                >
                                                    {item.title}
                                                </Text>
                                            </TouchableOpacity>
                                        </View>
                                    )
                                })}
                            </View>
                        </ImageBackground>
                    </TouchableOpacity>
                )}
                {/* 分享 */}
                {
                    shareModal && <ShareTemplate
                        type='SOM'
                        onClose={() => { this.changeState("shareModal", false); }}
                        shareParams={shareParams}
                        shareUrl={shareUrl}
                    />
                }
                 {/* 查看大图 */}
                 <ShowBigPicModal
                    isShowPage={this.handleShowpage()}
                    ImageList={this.state.bigList}
                    visible={this.state.showBingPicVisible}
                    showImgIndex={this.state.bigIndex}
                    onClose={() => {
                        StatusBar.setHidden(false);
                        this.setState({
                            showBingPicVisible: false,
                    }) }}
                />
            </View >
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
        height: 44,
        paddingTop: 0,
        backgroundColor: "transparent"
    },
    headerItem: {
        width: 50
    },
    footerView: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: width,
        height: 50 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding
    },
    footerItem: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        height: 50
    },
    footerItem1: {
        flex: 1.6,
        backgroundColor: "#fff"
    },
    footerItem1_imgView: {
        justifyContent: "center",
        alignItems: "center",
        height: "100%",
        paddingHorizontal: 10
    },
    footerItem2: {
        flex: 1,
        backgroundColor: "#4A90FA"
    },
    footerItem3: {
        flex: 1,
        backgroundColor: "#EE6161"
    },
    footerItem_text: {
        fontSize: 14,
        color: "#fff"
    },

    modalOutView: {
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: "transparent"
    },
    modalInnerView: {
        position: "absolute",
        top: 44 + CommonStyles.headerPadding,
        right: 12,
        justifyContent: "flex-end",
        width: 126,
        height: 93
    },
    modalInnerItem: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center",
        width: "100%",
        height: '100%',
        borderBottomWidth: 1,
        borderBottomColor: 'rgba(255,255,255,.2)'
        // height: 41,

        // paddingLeft: 15
    },
    modalInnerItem_text: {
        fontSize: 17,
        color: "#fff",
        marginLeft: 8,
    },
    modalOutView2: {
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "rgba(0,0,0,0.5)"
    },
    shareModalView: {
        width: width - 55,
        marginHorizontal: 27.5,
        borderRadius: 8,
        backgroundColor: "#fff",
        overflow: "hidden"
    },
    shareModalView_img: {
        width: "100%",
        height: ((width - 55) * 217.5) / 319
    },
    shareModalView_center: {
        width: "100%",
        borderTopWidth: 1,
        borderTopColor: "#E5E5E5",
        borderBottomWidth: 1,
        borderBottomColor: "#E5E5E5"
    },
    shareModalView_center_top: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center",
        width: "100%",
        height: 80,
        paddingHorizontal: 10,
        paddingVertical: 7
    },
    shareModalView_center_top_left: {
        justifyContent: "space-between",
        flex: 1,
        height: "100%"
    },
    shareModalView_center_top_right: {
        width: 66,
        height: "100%"
    },
    shareModalView_center_top_right_img: {
        width: "100%",
        height: "100%"
    },
    shareModalView_center_top_left_text1: {
        fontSize: 12,
        color: "#777"
    },
    shareModalView_center_top_left_item1: {
        // paddingHorizontal: 20,
        // paddingVertical: 2,
        // borderRadius: 10,
        // backgroundColor: '#FF545B',
    },
    shareModalView_center_top_left_text2: {
        fontSize: 12,
        color: "#FF545B",
        paddingVertical: 2,
        borderRadius: 10
    },
    shareModalView_center_bom: {
        flexDirection: "row",
        flexWrap: "wrap",
        paddingTop: 10
    },
    shareModalView_center_bom_view: {
        justifyContent: "center",
        alignItems: "center",
        width: "25%",
        marginBottom: 10
    },
    shareModalView_center_bom_img: {
        width: 40,
        height: 40
    },
    shareModalView_center_bom_text: {
        fontSize: 10,
        color: "#777",
        marginTop: 5
    },
    shareModalView_bom: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: "100%",
        height: 36
    },
    shareModalView_bom_text: {
        fontSize: 14,
        color: "#222"
    },
    moreModalWrap: {
        height: 93 -12,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center'
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: 'rgba(255,255,255,.2)'
    },
});

export default connect(
    state => ({ 
        userInfo: state.user.user
     }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMGoodsDetailScreen);
