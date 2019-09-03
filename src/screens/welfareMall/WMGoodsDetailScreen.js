/**
 * 福利商城商品详情页
 */
import React, { Component, PureComponent } from 'react';
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
} from 'react-native';
import { connect } from 'rn-dva';


import config from '../../config/config';
import CommonStyles from '../../common/Styles';
import Header from '../../components/Header';
import * as requestApi from '../../config/requestApi';
import FlatListView from '../../components/FlatListView';
import WebViewCpt from '../../components/WebViewCpt';
import ShareTemplate from '../../components/ShareTemplate';
import ShowBigPicModal from '../../components/ShowBigPicModal';
import * as nativeApi from "../../config/nativeApi";
import { NavigationComponent } from '../../common/NavigationComponent';

const { width, height } = Dimensions.get('window');
const weibo = require('../../images/share/weibo.png')
const weixin = require('../../images/share/weixin.png')
const qqicon = require('../../images/share/qqicon.png')
const friendsquan = require('../../images/share/friendsquan.png')
const copylian = require('../../images/share/copylian.png')
const friends = require('../../images/share/friends.png')

class WMGoodsDetailScreen extends NavigationComponent {
    static navigationOptions = {
        header: null,
    }

    constructor(props) {
        super(props);
        this.state = {
            goodsData: {},
            canGoBack: false,
            modalVisible: false,
            modalLists: [
                {
                    id: 1,
                    title: '分享',
                    icon: require('../../images/mall/share.png'),
                    routeName: ''
                },
                {
                    id: 2,
                    title: '意见反馈',
                    icon: require('../../images/mall/fankui.png'),
                    routeName: 'Feedback'
                },
                // {
                //     id: 3,
                //     title: '往期揭晓',
                //     icon: require('../../images/mall/pre_prize_icon.png'),
                //     routeName: 'PastWinners'
                // }
            ],
            uri:'welfFareGoodsDetails',
            shareModal: false,
            shareUrl: '',  // 分享链接
            shareParams: null,
            showBingPicVisible: false,
            bigIndex: 0, // 大图索引
            bigList: [], // 查看大图所有图片
            goodsId:(global.nativeProps && global.nativeProps.goodsId) || this.props.navigation.getParam('goodsId',''),
            sequenceId:(global.nativeProps && global.nativeProps.sequenceId) || this.props.navigation.getParam('sequenceId','')
        }
    }

    blurState = {
        shareModal: false,
        modalVisible: false,
        showBingPicVisible: false,
    }

    screenDidFocus = (payload)=> {
        super.screenDidFocus(payload)
        StatusBar.setBarStyle('dark-content')
    }

    screenWillBlur = (payload)=> {
        super.screenWillBlur(payload)
        StatusBar.setBarStyle('light-content')
    }

    getGoodsDetail = (router = '') => {
        Loading.show();
        requestApi.lotteryDetail({
            sequenceId: this.state.sequenceId,
        }).then(res => {
            console.log('商品详情',this.props,res)
            if (router === 'Feedback') {
                this.props.navigation.navigate('Feedback', { goodsData:res.jSequence.goods });
            }
            if (router === 'PastWinners') {
                this.props.navigation.navigate('PastWinners', { goodsData:res.jSequence.goods });
            }
        }).catch(err => {
            console.log(err)
        })
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }

    postMessage = () => {
    }

    goBack = () => {
        const { navigation } = this.props;
        const { canGoBack } = this.state;
        if (canGoBack) {
            this.webViewRef.goBack();
        } else {
            global.nativeProps?nativeApi.popToNative():
            navigation.goBack();
        }
    }
    //进入结算界面：
    jsOpenIndianaShopOrder(e) {
        let str = e.replace('jsOpenIndianaShopOrder,','')
        let data = JSON.parse(str)
        console.log('data1111',data)
        let datalist = []
        let totlePrice = 0
        if (data.jSequence.goods.id) {
                datalist[0] = {}
                datalist[0].goodsId = data.jSequence.goods.id
                datalist[0].quantity = data.quantity
                datalist[0].price = data.jSequence.lotteryWay.eachNotePrice
                datalist[0].name = data.jSequence.goods.name
                datalist[0].url = data.jSequence.goods.mainPic
                datalist[0].lotteryNumber = null
                datalist[0].participateStake = data.jSequence.currentCustomerNum
                datalist[0].drawTime = data.jSequence.expectLotteryDate
                datalist[0].drawType = data.jSequence.lotteryWay.jDrawType
                datalist[0].maxStake = data.jSequence.lotteryWay.eachSequenceNumber
                datalist[0].sequenceId = data.jSequence.id
                totlePrice = data.quantity * data.jSequence.lotteryWay.eachNotePrice;
                this.props.navigation.navigate('IndianaShopOrder', { data: datalist, totlePrice: totlePrice });
                return
        }
        Toast.show('请求中,请稍候...')
    }
    // 打开购物车
    jsOpenAppShoppingCart = (e) => {
        this.props.navigation.navigate('IndianaShopCart');
    }
    // 打开客服
    jsOpenAppCustomerService = (e) => {
        // Toast.show('开发中');
        nativeApi.createXKCustomerSerChat()

    }
    // 打开图片浏览
    jsOpenAppImageBrowser = (param) => {
        let _params = param.replace('jsOpenAppImageBrowser,','');
        let _data = JSON.parse(_params);
        let { index,list } = _data
        let temp = [];
        console.log('list',list)
        list.map(item => {
            if (item.type === 'img') {
                temp.push({
                    url: item.url,
                    type: 'images'
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
        console.log('打开图片浏览',JSON.parse(_params));

    }
    // 打开全部评价
    jsOpenAppComments = (e) => {
        this.props.navigation.navigate('WMAllShowOrder', { goodsId:this.state.goodsId });
    }
    //  获取分享路径
    pushSharePath = (e) => {
        e = e.replace('pushSharePath,', '')
        let param = JSON.parse(e);
        this.changeState('shareUrl', param.shareUrl);
        this.changeState('shareParams', param.param);
    }
    componentWillUnmount() {
        super.componentWillUnmount();
        Loading.hide();
    }
    goToAlgorithm (data) {
      let _data = data.replace('jsOpenAlgorithm,', '');
      console.log(JSON.parse(_data))
      requestApi.detailJLottery({
          sequenceId: JSON.parse(_data).sequenceId
      }).then(res => {
          console.log('resres', res)
          let param = {
            thirdWinningTime: res.thirdWinningTime,
            thirdWinningNo: res.thirdWinningNo,
            thirdWinningNumber: res.thirdWinningNumber,
            termNumber: res.termNumber,
            userBuyRecord: res.currentCustomerNum || 0, // 本期参与人次
            lotteryNumber: res.lotteryNumber, // 中奖编号
          }
          this.props.navigation.navigate('WMLotteryAlgorithm',{lotteryData: param})
      }).catch(err => {
          console.log(err)
      })
  }
  goToNewDetail (data) {
    let _data = data.replace('jsOpenPrizeDetail,', '');
    this.props.navigation.navigate('WMNewGoodsDetail',JSON.parse(_data))
  }
  handleShowpage = () => {
      const { bigList,bigIndex } = this.state
      if (bigList.length > 0) {
        return !(Platform.OS === 'ios' && bigList[bigIndex].type === 'video')
      }
      return true
  }
    render() {
        const { navigation, userInfo,dispatch } = this.props;
        const { goodsData, modalVisible,uri, modalLists, shareModal, shareParams, shareUrl ,goodsId,sequenceId} = this.state;
        let _baseUrl = `${config.baseUrl_h5}welfFareGoodsDetails`;
        let referralCode = userInfo.securityCode;
        let _url = `${_baseUrl}?id=${sequenceId}&goodsId=${goodsId}&merchantId=${userInfo.merchantId}&securityCode=${referralCode}`;
    //   let _url = `http://192.168.2.115:8080/#/lotteryIndex?id=${sequenceId}&goodsId=${goodsId}&merchantId=${userInfo.merchantId}&securityCode=${referralCode}`; // 本地测试地址
        let source = {
            uri: _url,
            showLoading: true,
            headers: { "Cache-Control": "no-cache" }
        }
        return (
            <View style={styles.container}>
            <StatusBar barStyle={'dark-content'} />
                {<WebViewCpt
                    webViewRef={(e) => { this.webViewRef = e }}
                    isNeedUrlParams={true}
                    source={source}
                    postMessage={() => {
                        this.postMessage();
                    }}
                    getMessage={(data) => {
                        let params = data && data.split(',');
                        console.log('params',params)
                        if (params[0] === 'jsOpenAppShoppingCart') {
                            this.jsOpenAppShoppingCart(params);
                        } else if (params[0] === 'jsOpenAppCustomerService') {
                            this.jsOpenAppCustomerService(params);
                        } else if (params[0] === 'jsOpenAppImageBrowser') {
                            this.jsOpenAppImageBrowser(data);
                        } else if (params[0] === 'jsOpenAppComments') {// 打开全部晒单
                            this.jsOpenAppComments(params);
                        } else if (params[0] === 'pushSharePath') {
                            this.pushSharePath(data);
                        } else if (params[0] === 'jsOpenIndianaShopOrder') {
                            this.jsOpenIndianaShopOrder(data);
                        } else if (params[0] === 'jsOpenAllParticipant') {//打开所有参与详情
                          navigation.navigate('WMPartakeDetail',{sequenceId})
                        } else if (params[0] === 'jsOpenPrizeDetail') {//跳转商品详情
                            this.goToNewDetail(data)
                        } else if (params[0] === 'jsOpenRecentLottery') {// 跳转到往期揭晓
                          this.getGoodsDetail('PastWinners')
                        } else if (params[0] === 'goToLotteryActivity') {// 跳到抽奖转盘
                          navigation.navigate('WMLotteryActivity')
                        } else if (params[0] === 'jsOpenAlgorithm') {// 开奖算法
                          this.goToAlgorithm(data)
                        } else if (params[0] === 'jsHiddenXKHUDView') {
                            Loading.hide()
                        } else {
                            console.log(params);
                        }
                    }}
                />}

                <Header
                    navigation={navigation}
                    headerStyle={styles.headerStyle}
                    leftView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.goBack();
                            }}
                        >
                            <Image source={require('../../images/mall/goback_gray.png')} />
                        </TouchableOpacity>
                    }
                    rightView={
                        <TouchableOpacity
                            style={styles.headerItem}
                            activeOpacity={0.6}
                            onPress={() => {
                                this.changeState('modalVisible', true);
                            }}
                        >
                            <Image source={require('../../images/mall/more_gray.png')} />
                        </TouchableOpacity>
                    }
                />

                {/* 点击更多弹窗 */}
                {
                    modalVisible &&
                    <TouchableOpacity
                        style={styles.modalOutView}
                        activeOpacity={1}
                        onPress={() => {
                            this.changeState('modalVisible', false);
                        }}
                    >
                        <ImageBackground
                            style={styles.modalInnerView}
                            resizeMode='center'
                            source={require('../../images/mall/more_modal_bg.png')}
                        >
                            {/* <View style={[CommonStyles.flex_center,{height: 81,marginTop: 13}]}> */}
                            <View style={[CommonStyles.flex_center,{height: 127 - 11,marginTop: 13}]}>
                            {
                                modalLists.map((item, index) => {
                                    let bottomBorder = index === modalLists.length - 1 ? null : styles.borderBottom;
                                    return (
                                        <View key={index} style={[CommonStyles.flex_1,{paddingHorizontal: 10}]}>
                                            <TouchableOpacity
                                                key={index}
                                                style={[styles.modalInnerItem,bottomBorder]}
                                                activeOpacity={0.6}
                                                onPress={() => {
                                                    this.changeState('modalVisible', false);
                                                    if (item.routeName) {
                                                        // 福利详情和自营详情的goodsData的商品名字不一样，这里统一，然后跳转商品反馈
                                                        if (item.routeName === 'Feedback') {
                                                            this.getGoodsDetail('Feedback')
                                                            return
                                                        }
                                                        if (item.routeName === 'PastWinners') {
                                                            this.getGoodsDetail('PastWinners')
                                                        }
                                                    } else {
                                                        console.log('shareParamsshareParams', shareParams)
                                                        if (shareParams) {
                                                            this.changeState('shareModal', true);
                                                        } else {
                                                            Toast.show('获取分享信息失败');
                                                        }
                                                    }
                                                }}
                                            >
                                                <View style={[CommonStyles.flex_1,CommonStyles.flex_start]}>
                                                    <Image source={item.icon} />
                                                    <Text style={styles.modalInnerItem_text}>{item.title}</Text>
                                                </View>
                                            </TouchableOpacity>
                                        </View>
                                    )
                                })
                            }
                            </View>
                        </ImageBackground>
                    </TouchableOpacity>
                }
                {/* 分享 */}
                {
                    shareModal && <ShareTemplate
                        type='WM'
                        onClose={() => { this.changeState("shareModal", false); }}
                        shareParams={shareParams}
                        shareUrl={shareUrl}
                        callback={() => { Toast.show('分享成功') }} // 确认分享回调
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
            </View>
        );
    }
};

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
    },
    headerStyle: {
        position: 'absolute',
        top: CommonStyles.headerPadding,
        height: 44,
        paddingTop: 0,
        backgroundColor: 'transparent',
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        width: 50,
    },
    footerView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: 50 + CommonStyles.footerPadding,
        paddingBottom: CommonStyles.footerPadding,
    },
    footerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
    },
    footerItem1: {
        flex: 1.6,
        backgroundColor: '#fff',
    },
    footerItem1_imgView: {
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        paddingHorizontal: 10,
    },
    footerItem2: {
        flex: 1,
        backgroundColor: '#4A90FA',
    },
    footerItem3: {
        flex: 1,
        backgroundColor: '#EE6161',
    },
    footerItem_text: {
        fontSize: 14,
        color: '#fff',
    },
    modalOutView: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: 'transparent',
        // backgroundColor: 'blue'
    },
    modalInnerView: {
        position: 'absolute',
        top: 44 + CommonStyles.headerPadding,
        right: 12,
        width: 126,
        height: 130,
        // height: 93
    },
    modalinnerItem_border: {
        borderTopWidth: 1,
        borderTopColor: 'rgba(255,255,255,0.2)',
    },
    modalInnerItem: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center",
        width: "100%",
        height: '100%',
        paddingLeft: 5,
        // height: 41,
        // paddingHorizontal: 15,
        // flexDirection: 'row',
        // justifyContent: 'flex-start',
        // alignItems: 'center',
        // width: '100%',
        // height: 41,
        // paddingLeft: 15,
        // paddingTop: 10
        // backgroundColor:'rgba(10,10,10,.5)'
    },
    modalInnerItem_text: {
        fontSize: 17,
        color: '#fff',
        marginLeft: 8,
    },
    modalOutView2: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0,0,0,0.5)',
    },
    shareModalView: {
        width: width - 55,
        marginHorizontal: 27.5,
        borderRadius: 8,
        backgroundColor: '#fff',
        overflow: 'hidden',
    },
    shareModalView_img: {
        width: '100%',
        height: 110,
    },
    shareModalView_center: {
        width: '100%',
        // borderTopWidth: 1,
        // borderTopColor: '#E5E5E5',
        borderBottomWidth: 1,
        borderBottomColor: '#E5E5E5',
    },
    shareModalView_center_top: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        width: '100%',
        height: 80,
        paddingHorizontal: 10,
        paddingVertical: 7,
    },
    shareModalView_center_top_left: {
        justifyContent: 'space-between',
        height: '100%',
    },
    shareModalView_center_top_right: {
        width: 66,
        height: '100%',
    },
    shareModalView_center_top_right_img: {
        width: '100%',
        height: '100%',
    },
    shareModalView_center_top_left_text1: {
        fontSize: 12,
        color: '#777',
    },
    shareModalView_center_top_left_item1: {
        paddingHorizontal: 20,
        paddingVertical: 2,
        borderRadius: 10,
        backgroundColor: '#FF545B',
    },
    shareModalView_center_top_left_text2: {
        fontSize: 12,
        color: '#fff',
    },
    shareModalView_center_bom: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingTop: 10,
    },
    shareModalView_center_bom_view: {
        justifyContent: 'center',
        alignItems: 'center',
        width: '25%',
        marginBottom: 10,
    },
    shareModalView_center_bom_img: {
        width: 40,
        height: 40,
    },
    shareModalView_center_bom_text: {
        fontSize: 10,
        color: '#777',
        marginTop: 5,
    },
    shareModalView_bom: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: '100%',
        height: 36,
    },
    shareModalView_bom_text: {
        fontSize: 14,
        color: '#222',
    },
    goodsInfoWrap: {
        padding: 10,
    },
    goodsTitle: {
        fontSize: 14,
        color: '#222'
    },
    goodsInfoPrice: {
        paddingHorizontal: 7,
        paddingVertical: 4,
        backgroundColor: '#FF545B',
        color: '#fff',
        fontSize: 12,
        borderRadius: 20,
    },
    borderBottom: {
        borderBottomWidth: 1,
        borderBottomColor: 'rgba(255,255,255,.2)'
    },
});

export default connect(
    (state) => ({
        userInfo: state.user.user,
     }),
    (dispatch) => ({ dispatch })
)(WMGoodsDetailScreen);
