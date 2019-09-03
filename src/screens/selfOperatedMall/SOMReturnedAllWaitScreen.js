/**
 * 申请售后 退款退货
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
    Modal,
    TouchableOpacity,
    BackHandler
} from "react-native";
import { connect } from "react-redux";
import { bindActionCreators } from "redux";
import actions from "../../action/actions";
import TextInputView from '../../components/TextInputView';
import ImageView from '../../components/ImageView';
import CountDown from '../../components/CountDown';
import * as requestApi from '../../config/requestApi';

import Header from "../../components/Header";
import CommonStyles from "../../common/Styles";
import moment from 'moment'
import * as scanConfig from "../../config/scanConfig";
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { getPreviewImage, keepTwoDecimalFull } from "../../config/utils";
import math from "../../config/math";


const logisticsComData = [
    // {
    //     title: 'XK'
    // },
    {
        title: 'SF'
    },
    {
        title: 'YD'
    },
    {
        title: 'ZT'
    },
    {
        title: 'ST'
    },
    {
        title: 'YT'
    },
    {
        title: 'BSHT'
    },
    {
        title: 'HIMSELF'
    },
]
const { width, height } = Dimensions.get("window");

class SOMReturnedAllWaitScreen extends Component {
    static navigationOptions = {
        header: null
    };
    timer = null;
    _didFocusSubscription;
    _willBlurSubscription;
    constructor(props) {
        super(props);
        this._didFocusSubscription = props.navigation.addListener('willFocus', payload =>{
            this.getDetails()
            BackHandler.addEventListener('hardwareBackPress', this.handleBackPress)
        });
        this.state = {
            data: {
                goodsInfo: [
                    {
                        realPrice: 0,
                    }
                ],
                refundMessage: null,
                refundReason: '',
                refundAmount: '',
                refundEvidence: [],
                refundTime: +new Date() / 1000
            },
            countDown: '2天00小时00分钟00秒',
            logisticsId: '',
            logisticsCom: '请选择',
            modalVisible: false,
            showBigModal: false, // 查看大图模态
            showImgIndex: 0,
            isGetData: false, // 防止闪百
            ImageList:[],
        }
    }
    componentDidMount() {
        Loading.hide()
        this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload =>
            BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        );
    }

    componentWillUnmount() {
        this.timer && clearInterval(this.timer);
        this._didFocusSubscription && this._didFocusSubscription.remove();
        this._willBlurSubscription && this._willBlurSubscription.remove();
    }
    // 处理物理返回。返回到订单列表
    handleBackPress = () => {
        const { navigation } = this.props
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn', () => { })
        let isFocused = this.props.navigation.isFocused()
        // console.log('routerIn',routerIn)
        if (isFocused) {
            if (routerIn === 'details') {
                navigation.goBack()
            }
            if (routerIn === 'returnAll') {
                navigation.navigate('SOMOrder');
            }
            return true
        } 
        BackHandler.removeEventListener('hardwareBackPress', this.handleBackPress)
        return false
    }
    handleCountDown = (dealline) => {
        let time = moment(dealline).diff(moment());
        // console.log('time')
        this.timer = setInterval(() => {
            let t = null;
            let d = null;
            let h = null;
            let m = null;
            let s = null;
            //js默认时间戳为毫秒,需要转化成秒
            t = time / 1000;
            d = Math.floor(t / (24 * 3600));
            h = Math.floor((t - 24 * 3600 * d) / 3600);
            m = Math.floor((t - 24 * 3600 * d - h * 3600) / 60);
            s = Math.floor((t - 24 * 3600 * d - h * 3600 - m * 60));
            time -= 1000;
            if (time < 0) {
                this.setState({
                    countDown: '提交'
                }, () => {
                    clearInterval(this.timer)
                })
                return
            }
            // console.log(moment(dealline))
            let _day = d === 0 ? 1 : d;
            this.setState({
                countDown:  _day * h + ((h === 0) ? '' : '小时') + m + '分钟' + s + '秒'
            })
            Loading.hide();
        }, 1000)
    }
    getDetails = () => {
        Loading.show();
        const { navigation } = this.props
        let id = navigation.getParam('refundId', '')
        let params = {
            refundId: id
        }
        requestApi.mallOrderRefundDetail(params).then(res => {
            // console.log('resres',res)
            // res.goodsInfo[0].refundCount = 2
            // 倒计时;
            let isRefused = false;
            if ( res.refundStatus === 'PRE_PLAT_RECEIVE' || res.refundStatus === 'PRE_REFUND' || res.refundStatus === 'REFUNDING' || res.refundStatus === 'COMPLETE') {
                navigation.navigate('SOMRefundProcess', { refundId: id, routerIn: 'SOMReturnedAllWait' })
                return
            }
            if (res.refundStatus === 'APPLY') {
                let isAfter = moment().isAfter(moment(res.refundTime * 1000).add(res.refundAutoAcceptTime, 's'))
                console.log('isAfter',isAfter)
                console.log('moment',moment().format('YYYY-MM-DD hh:mm:ss'))
                isAfter ? this.setState({countDown: '提交'}) :this.handleCountDown(moment(res.refundTime * 1000).add(res.refundAutoAcceptTime, 's'))
            }
            if (res.refundStatus === 'PRE_USER_SHIP') {
                Loading.hide();
                this.setState({
                    countDown: '提交'
                })
            }
            if (res.refundStatus === 'REFUSED') {
                isRefused = true
            }
            // 匹配查看大图，视频的uri地址
            let temp = [];
            let refundEvidence = res.refundEvidence || []
            // console.log('refundEvidence',refundEvidence)
            refundEvidence.length !== 0 && refundEvidence.map((item,index) => {
                if (item.refundVideo !== '') {
                    temp.push({
                        type: 'video',
                        url: item.refundVideo
                    })
                } else {
                    temp.push({
                        type: 'images',
                        url: item.refundPic
                    })
                }
            })
            this.setState({
                isRefused,
                data: res,
                isGetData: true,
                ImageList: temp,
            }, () => {
                this.props.actions.setRefundAmount(res.goodsInfo, res)
            })
        }).catch(err => {
            // console.log('err')
            Loading.hide()
        })
    }
    handleChangeState = (key = '', value = '') => {
        this.setState({
            [key]: value
        }, () => {
            // console.log('%cChangeState', 'color:green', this.state)
        })
    }
    handleGotoSub = () => {
        const { logisticsCom, logisticsId } = this.state
        const { navigation } = this.props
        if (logisticsCom === '请选择' || logisticsId === '') return
        if (!/^[0-9]*$/.test(logisticsId)) {
            Toast.show('快递单号只能输入数字哦！')
            return
        }
        let id = navigation.getParam('refundId', '')
        let params = {
            logisticsName: logisticsCom,
            logisticsNo: logisticsId,
            refundId: id
        }
        requestApi.mallOrderMUserRefundUploadLogistice(params).then(res => {
            Toast.show('提交成功!')
            navigation.navigate('SOMRefundProcess', { refundId: id,routerIn: 'SOMReturnedAllWait' })
        }).catch((err)=>{
            console.log(err)
          });
    }
    // 匹配物流信息
    getLogisticsInfo = (name) => {
        switch (name) {
            // case 'XK': return '晓可自营物流'
            case 'SF': return '顺丰'
            case 'YD': return '韵达'
            case 'ZT': return '中通'
            case 'ST': return '申通'
            case 'YT': return '圆通'
            case 'BSHT': return '百世汇通'
            case 'HIMSELF': return '用户自行配送'
            case '请选择': return '请选择'
        }
    }
    getRefusedTest = () => {
        const { data } = this.state
        if (data.goodsInfo[0].refundCount >= 2 && data.refundStatus === 'REFUSED') {
            return '平台已拒绝，如有疑问请联系客服！'
        }
         else if (data.refundStatus === 'REFUSED') {
            return '申请已被拒绝！'
        } else {
            return `* 若卖家在规定时间内未处理，系统将自动为您退款`
        }
    }
    getRefundPrice = (data) => {
        // console.log('datadata',data)
        let allPice = 0;
        data.goodsInfo.map(item => {
            allPice += math.divide(item.realPrice , 100)
        })
        allPice += math.divide(data.postFee , 100)
        return allPice
    }
    // 重新申请需要匹配数据格式
    handleRefundAgain = () => {
        const { navigation } = this.props
        let data = JSON.parse(JSON.stringify(this.state.data))
        if (data.goodsInfo[0].refundCount >= 2) {
            Toast.show('超出申请次数限制，暂不能申请！')
            return
        }
        data.goodsInfo.map(item => {
            item['num'] = item.buyCount
            item['goodsShowAttr'] = item.goodsAttr
        })
        // console.log(data)
        // navigation.navigate('SOMReturnedAll', { afterSaleGoods: data.goodsInfo, orderInfo:data, callback: () => {} })
        // navigation.navigate('SOMAfterSaleCategory', { afterSaleGoods: selectData, orderInfo: this.state.goodsData, callback, })
        navigation.navigate('SOMAfterSaleCategory', { afterSaleGoods: data.goodsInfo, orderInfo:data, callback: () => {} })
    }
    getBotton = (data) => {
        const { logisticsId, logisticsCom } = this.state
        if (data.refundAutoAcceptTime === 0 || data.refundStatus === 'PRE_USER_SHIP') {
            return (
                <TouchableOpacity style={[styles.countDownWrap, (logisticsCom === '请选择' || logisticsId === '') ? styles.disableBtn : null]}
                    onPress={this.handleGotoSub}
                    activeOpacity={(logisticsCom === '请选择' || logisticsId === '') ? 1 : 0.2}>
                    <Text style={[styles.countDownText, (logisticsCom === '请选择' || logisticsId === '') ? styles.disableBtn : null]}>提交</Text>
                </TouchableOpacity>
            )
        } else {
            return (
                <View style={[styles.countDownWrap]}>
                    <Text style={[styles.countDownText]}>等待卖家同意</Text>
                </View>
            )
        }
    }
    render() {
        const { navigation, store } = this.props;
        const { data, countDown, logisticsId, logisticsCom, modalVisible, showBigModal,showImgIndex,ImageList,isRefused,isGetData } = this.state
        let callback = navigation.getParam('callback', () => { })
        let routerIn = navigation.getParam('routerIn', '')
        let refundAmount = (store.mallReducer.refundAmount || 0)
        console.log('data',data)
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    leftView={
                        <View>
                            <TouchableOpacity
                                style={[styles.headerItem, styles.left]}
                                onPress={() => {
                                    // console.log(routerIn)
                                    if (routerIn === 'details') {
                                        navigation.goBack()
                                    }
                                    if (routerIn === 'returnAll') {
                                        navigation.navigate('SOMOrder');
                                        // if (callback) { callback() }
                                    }
                                }}
                            >
                                <Image source={require('../../images/mall/goback.png')} />
                            </TouchableOpacity>
                        </View>
                    }
                    title={"退货退款中"}
                />
                {
                    isGetData
                    ? <ScrollView
                        showsHorizontalScrollIndicator={false}
                        showsVerticalScrollIndicator={false}
                    >
                        <View style={styles.goodsWrpa}>
                            {
                                data.goodsInfo.length > 0 && data.goodsInfo.map((item, index) => {
                                    let price = (math.divide(item.goodsPrice , 100)).toFixed(2)
                                    let borderBottom = index === data.goodsInfo.length - 1 ? {} : styles.borderBottom
                                    return (
                                        <View style={[styles.goodsItem, styles.flex_1, styles.flex_start_noCenter, borderBottom]} key={index}>
                                            <View style={[styles.flex_1, styles.flex_start]}>
                                                <View style={[styles.imgWrap, styles.flex_center]}>
                                                    <Image source={{ uri: getPreviewImage(item.goodsPic, '50p') }} style={styles.imgStyle} />
                                                </View>
                                                <View style={[styles.flex_1, styles.goodsInfo]}>
                                                    <Text numberOfLines={2} style={styles.goodsTitle}>{item.goodsName}</Text>
                                                    <Text style={styles.goodsAttr}>{item.goodsAttr} x {item.buyCount}</Text>
                                                    <View style={[styles.flex_1, styles.flex_start, { marginTop: 5 }]}>
                                                        <Text style={styles.goodsPriceLabel}>价格:</Text>
                                                        <Text style={styles.goodsPriceValue}>{price}</Text>
                                                    </View>
                                                </View>
                                            </View>
                                        </View>
                                    )
                                })
                            }
                        </View>
                        <View style={styles.selectWrap}>
                            <View style={[styles.flex_start, styles.selectItem]}>
                                <Text style={styles.selectItem_text}>退货退款原因：{data.refundReason}</Text>
                            </View>
                            <View style={[styles.flex_between, styles.selectItem]} onPress={() => { }}>
                                <Text style={styles.selectItem_text}>退款金额：￥{keepTwoDecimalFull(math.divide(refundAmount , 100))}</Text>
                            </View>
                            <View style={[styles.flex_start, styles.selectItem, { borderBottomWidth: 1 }]}>
                                <Text style={[styles.selectItem_text]}>退货退款说明：{data.refundMessage || '无'}</Text>
                            </View>
                            <View style={[styles.flex_start, styles.selectItem, { borderBottomWidth: 0 }]}>
                                <Text style={styles.selectItem_text}>退货退款时间：{moment(data.refundTime * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                            </View>
                        </View>
                        {
                            (data.refundAutoAcceptTime === 0 || data.refundStatus === 'PRE_USER_SHIP') ?
                                <React.Fragment>
                                    <View style={[styles.showSubItem, { marginBottom: 10, }]}>
                                        <View style={styles.flex_between}>
                                            <Text style={styles.showSubItemText}>退货地址：</Text>
                                            <Text style={[styles.showSubItemText, { fontSize: 12, color: '#555',flex:1,textAlign: 'right' }]} numberOfLines={2}>{data.refundAddress}</Text>
                                        </View>
                                        <View style={[CommonStyles.flex_1,CommonStyles.flex_end,{marginTop: 5}]}>
                                            <Text numberOfLines={1} style={[styles.showSubItemText, { textAlign: 'right', fontSize: 12,marginRight: 10, color: '#555',lineHeight: 17,flex:1, maxWidth: 200}]}>{data.refundReceiver}</Text>
                                            <Text style={[styles.showSubItemText, { textAlign: 'right', fontSize: 12, color: '#555',lineHeight: 17 }]}>{ data.refundPhone }</Text>
                                        </View>
                                        {/* <Text style={[styles.showSubItemText, { textAlign: 'right', fontSize: 12, color: '#555',lineHeight: 17,flex:1, }]}>{data.refundReceiver} { data.refundPhone }</Text> */}
                                    </View>
                                    <View style={[styles.showSubItem, styles.flex_between]}>
                                        <View style={[styles.flex_start]}>
                                            <Text style={styles.showSubItemText}>快递单号：</Text>
                                            <View style={[{width: '80%'}]}>
                                                <TextInputView
                                                    value={logisticsId}
                                                    onChangeText={(value) => {
                                                        this.handleChangeState('logisticsId', value)
                                                    }}
                                                    keyboardType='number-pad'
                                                    placeholder="请填写"
                                                    placeholderTextColor='#ccc'
                                                    keyboardType='default'
                                                    maxLength={20}
                                                />
                                            </View>
                                        </View>
                                    </View>
                                    <TouchableOpacity style={[styles.showSubItem, styles.flex_between, { marginVertical: 10 }]} onPress={() => { this.handleChangeState('modalVisible', true) }}>
                                        <View style={[styles.flex_start]}>
                                            <Text style={styles.showSubItemText}>快递公司</Text>
                                        </View>
                                        <View style={styles.flex_start}>
                                            <Text style={[styles.showSubItemText, { color: '#999' }]}>{this.getLogisticsInfo(logisticsCom)}</Text>
                                            <Image source={require('../../images/mall/goto_gray.png')} />
                                        </View>
                                    </TouchableOpacity>
                                </React.Fragment>
                                : null
                        }
                        <View style={[styles.selectWrap, { marginBottom: 0 }]}>
                            <View style={[styles.flex_between, styles.selectItem, { paddingVertical: 10 }]}>
                                <Text style={styles.selectItem_text}>上传凭证</Text>
                            </View>
                            <View style={[styles.flex_start, styles.selectItem]}>
                                <ScrollView
                                    showsVerticalScrollIndicator={false}
                                    horizontal={true}
                                >
                                    {
                                        data.refundEvidence && data.refundEvidence.length !== 0 ?
                                            data.refundEvidence.map((item, index) => {
                                                return (
                                                    <View key={index} style={styles.img_item_box}>
                                                        <TouchableOpacity
                                                            activeOpacity={0.5}
                                                            onPress={() => {
                                                                this.setState({
                                                                    showBigModal: true,
                                                                    showImgIndex: index,
                                                                })
                                                            }}
                                                        >
                                                            <ImageView
                                                                style={styles.img_item}
                                                                source={{ uri: (item.refundVideo !== '')?item.refundPic: getPreviewImage(item.refundPic) }}
                                                                sourceWidth={60}
                                                                sourceHeight={60}
                                                                resizeMode='cover'
                                                            />
                                                            {
                                                                item.refundVideo !== ''
                                                                ? <View style={{height: '100%',width: '100%',position: 'absolute',...CommonStyles.flex_center}}>
                                                                    <Image style={styles.video_btn} source={require('../../images/index/video_play_icon.png')} />
                                                                </View>
                                                                : null
                                                            }
                                                        </TouchableOpacity>
                                                    </View>
                                                );
                                            })
                                            : <Text>无</Text>
                                    }
                                </ScrollView>
                            </View>
                        </View>
                        <View style={styles.noticeInfoWrap}>
                            <Text style={styles.noticeInfoText}>{this.getRefusedTest()}</Text>
                        </View>
                        {
                            isRefused
                            ? !(data.goodsInfo[0].refundCount >= 2)
                                ? <TouchableOpacity
                                style={[styles.countDownWrap]}
                                onPress={() => {
                                    this.handleRefundAgain()
                                }}
                                >
                                    <Text style={[styles.countDownText]}>再次申请</Text>
                                </TouchableOpacity>
                                : null
                            : countDown !== '提交' ?
                                <View style={styles.countDownWrap}>
                                    {/* <Text style={styles.countDownText}>{countDown}</Text> */}
                                    <CountDown
                                        //date={new Date(parseInt(endTime))}
                                        date={moment(data.refundTime * 1000).add(data.refundAutoAcceptTime,'s')}
                                        days={{ plural: ' ', singular: ' ' }}
                                        hours=':'
                                        mins=':'
                                        segs='  '
                                        type='orderApply'
                                        label='等待卖家同意'
                                        daysStyle={styles.countDownText}
                                        hoursStyle={styles.countDownText}
                                        minsStyle={styles.countDownText}
                                        secsStyle={styles.countDownText}
                                        firstColonStyle={styles.countDownText}
                                        secondColonStyle={styles.countDownText}
                                        onEnd={() => {
                                            this.getDetails();
                                        }}
                                    />
                                </View>
                                : this.getBotton(data)
                        }
                    </ScrollView>
                    : null
                }

                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={modalVisible}
                    onRequestClose={() => {
                        // console.log(0)
                    }}
                >
                    <View style={styles.modal}>
                        <View style={styles.modalContent}>
                            <View style={[styles.modalItem, styles.flex_center, styles.borderBottom]}>
                                <Text style={[styles.modalItemText, styles.color_red]}>请选择物流</Text>
                            </View>
                            <ScrollView
                                showsHorizontalScrollIndicator={false}
                                style={{height: 190}}
                            >
                            {
                                logisticsComData.length > 0 && logisticsComData.map((item, index) => {
                                    return (
                                        <TouchableOpacity
                                            key={index}
                                            style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                            onPress={() => {
                                                this.setState({
                                                    // reason: item.refundReason,
                                                    // reasonId: item.refundReasonId,
                                                    modalVisible: false,
                                                    logisticsCom: item.title,
                                                })
                                            }}>
                                            <Text style={styles.modalItemText}>{this.getLogisticsInfo(item.title)}</Text>
                                        </TouchableOpacity>
                                    )
                                })
                            }
                            </ScrollView>
                            <TouchableOpacity activeOpacity={1} onPress={() => { this.handleChangeState('modalVisible', false) }} style={[styles.modalItem, styles.flex_center]}>
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
                <ShowBigPicModal
                ImageList={ImageList}
                visible={showBigModal}
                showImgIndex={showImgIndex}
                onClose={() => {
                    this.handleChangeState('showBigModal',false)
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
    flex_center: {
        justifyContent: 'center',
        alignItems: 'center'
    },
    flex_start: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
        alignItems: 'center'
    },
    flex_start_noCenter: {
        justifyContent: 'flex-start',
        flexDirection: 'row',
    },
    flex_between: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center'
    },
    flex_1: {
        flex: 1
    },
    goodsWrpa: {
        borderRadius: 8,
        backgroundColor: '#fff',
        margin: 10,
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)',
        overflow: 'hidden',
        // marginBottom: 60
    },
    goodsItem: {
        padding: 15,
        backgroundColor: '#fff',
    },
    selectedBtnWrap: {
        marginRight: 10
    },
    unSelected: {
        width: 15,
        height: 15,
        borderWidth: 1,
        borderColor: '#979797',
        borderRadius: 15,
    },
    goodsTitle: {
        lineHeight: 17,
        fontSize: 12,
        color: '#222'
    },
    imgStyle: {
        height: 69,
        width: 69,
        borderRadius: 6,
    },
    imgWrap: {
        borderRadius: 6,
        borderWidth: 1,
        borderColor: '#E5E5E5',
        backgroundColor: '#fff',
        height: 69,
        width: 69,
    },
    goodsInfo: {
        paddingLeft: 10,
        flex: 1
    },
    goodsAttr: {
        fontSize: 10,
        color: '#999',
        marginTop: 5
    },
    goodsPriceLabel: {
        fontSize: 10,
        color: '#999',
    },
    goodsPriceValue: {
        fontSize: 10,
        color: '#101010',
        paddingLeft: 7
    },
    selectWrap: {
        margin: 10,
        marginTop: 0,
        borderRadius: 8,
        backgroundColor: '#fff',
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)'
    },
    selectItem: {
        borderBottomColor: '#F1F1F1',
        borderBottomWidth: 1,
        padding: 13,
    },
    selectItem_text: {
        fontSize: 14,
        color: '#222'
    },
    selectItem_img: {
        width: 14,
        height: 8
    },
    time: {
        color: '#444'
    },
    colon: {
        color: CommonStyles.globalRedColor
    },
    modal: {
        // height: 342,
        flex: 1,
        backgroundColor: 'rgba(10,10,10,.5)',
        position: 'relative'
    },
    modalContent: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        width,
        backgroundColor: '#fff',
        paddingBottom: CommonStyles.footerPadding,
    },
    color_red: {
        color: '#EE6161'
    },
    modalItemText: {
        fontSize: 17,
        color: '#222',

    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: 'relative'
    },
    marginTop: {
        marginTop: 5
    },
    borderBottom: {
        borderBottomColor: '#f1f1f1',
        borderBottomWidth: 1,
    },
    block: {
        width,
        height: 5,
        backgroundColor: '#F1F1F1',
        position: 'absolute',
        top: 0,
        left: 0
    },
    bottomBtn: {
        margin: 10,
        marginTop: 0,
        paddingVertical: 11,
        backgroundColor: '#4A90FA',
        borderRadius: 8
    },
    bottomBtnText: {
        textAlign: 'center',
        color: '#fff',
        fontSize: 17
    },
    disableBtn: {
        backgroundColor: '#999',
        color: '#fff'
    },
    headerItem: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
        // position: 'absolute'
    },
    left: {
        width: 50
    },
    img_item: {
        borderRadius: 6,
    },
    img_item_box: {
        borderRadius: 6,
        marginRight: 10,
        borderWidth: 0.7,
        borderColor: '#f1f1f1',
    },
    noticeInfoWrap: {
        paddingHorizontal: 25,
        paddingTop: 15,
        paddingBottom: 30
    },
    noticeInfoText: {
        color: '#EE6161',
        fontSize: 12,
    },
    countDownWrap: {
        marginHorizontal: 10,
        marginBottom: 30,
        borderRadius: 8,
        backgroundColor: '#4A90FA',
        height: 44,
        justifyContent: 'center',
        alignItems: 'center'
    },
    countDownText: {
        fontSize: 17,
        color: '#fff',
        textAlign: 'center'
    },
    showSubItem: {
        marginHorizontal: 10,
        borderRadius: 8,
        paddingVertical: 10,
        paddingHorizontal: 15,
        backgroundColor: '#fff',
        borderWidth: 1,
        borderColor: 'rgba(215,215,215,0.5)'
    },
    showSubItemText: {
        fontSize: 14,
        color: '#222'
    },
    video_btn: {
        // position: 'absolute',
        width: 30,
        height: 30,
    },
});

export default connect(
    state => ({ store: state }),
    dispatch => ({ actions: bindActionCreators(actions, dispatch) })
)(SOMReturnedAllWaitScreen);
