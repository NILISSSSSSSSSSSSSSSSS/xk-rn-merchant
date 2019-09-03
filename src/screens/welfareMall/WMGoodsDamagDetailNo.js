/**
 * 货物报损详情(未经客服处理)
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
    TouchableOpacity,
    Modal
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../common/Styles'
import * as nativeApi from '../../config/nativeApi'
import * as requestApi from '../../config/requestApi'
import Header from '../../components/Header'
import ImageView from '../../components/ImageView'
import TextInputView from '../../components/TextInputView'
import Content from '../../components/ContentItem'
const { width, height } = Dimensions.get("window")
import ShowBigPicModal from '../../components/ShowBigPicModal';
import { getPreviewImage,getLogisticsInfo } from '../../config/utils'
import { NavigationPureComponent } from "../../common/NavigationComponent";
import math from '../../config/math';
function getwidth(val) {
    return width * val / 375
}
const saoma = require('../../images/indianashopcart/saoma.png')
const lists = [
    // {
    //     label: '晓可自营物流',
    //     value: 'XK'
    // },
    {
        label: '顺丰',
        value: 'SF'
    },
    {
        label: '韵达',
        value: 'YD'
    },
    {
        label: '中通',
        value: 'ZT'
    },
    {
        label: '申通',
        value: 'ST'
    },
    {
        label: '圆通',
        value: 'YT'
    },
    {
        label: '百世汇通',
        value: 'BSHT'
    },
    {
        label: '用户自行配送',
        value: 'HIMSELF'
    },
]
export default class WMGoodsDamagDetailNo extends NavigationPureComponent {

    state = {
        refundDetail: {
            explainUrls: [],
            refundState: 'UNAUDITED'
        },
        logisticsNo: '',
        logisticsName: '',
        visible: false,
        showBingPicVisible: false,
        showImgIndex: 0,
    }

    blurState = {
        visible: false,
        showBingPicVisible: false,
    }

    componentDidMount() {
        this.getDetail()
    }
    getDetail = () => {
        Loading.show();
        const { navigation } = this.props
        let orderData = this.props.navigation.getParam('orderData', {})
        let params = {
            // logisticsName: '',
            // logisticsNo: '',
            refundId: orderData.refundId
        }
        requestApi.refundReportDetail(params).then(res => {
            console.log('详情', res)
            this.changeState('refundDetail', res)

        }).catch(err => {
            console.log(err)
        })
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    getImgList = () => {
        const { refundDetail } = this.state
        let imgList = refundDetail.explainUrls || [];
        if (imgList.length === 0) return []
        let temp = [];
        imgList.map(item => {
            let _item = JSON.parse(item);
            if (_item.video && _item.video !== '') {
                temp.push({
                    type: 'video',
                    url: _item.video
                });
            } else {
                temp.push({
                    type: 'images',
                    url: _item.pic
                });
            }

        })
        return temp
    }
    renderImg = () => {
        const { refundDetail } = this.state
        console.log(refundDetail)
        let imgList = refundDetail.explainUrls || []
        return imgList.map((item, index) => {
            let _item = JSON.parse(item)
            console.log('_item',_item)
            return (
                <TouchableOpacity
                    key={index}
                    onPress={() => {
                        this.setState({
                            showImgIndex: index,
                            showBingPicVisible: true,
                        })
                    }}>
                        <ImageView
                            style={styles.img_item}
                            source={{ uri: _item.video === '' ? getPreviewImage(_item.pic):_item.pic }}
                            sourceWidth={60}
                            sourceHeight={60}
                            resizeMode='cover'
                        />
                        {
                            _item.video !== ''
                            ? <View style={{height: 60,width: 60,top:10,position: 'absolute',...CommonStyles.flex_center}}>
                                <Image style={{height: 30,width: 30}} source={require('../../images/index/video_play_icon.png')} />
                            </View>
                            : null
                        }
                    </TouchableOpacity>
            )
        })
    }
    handleSubmit = () => {
        const { logisticsName, logisticsNo,log_name } = this.state
        let orderData = this.props.navigation.getParam('orderData', {})
        let callback = this.props.navigation.getParam('callback', () => { })
        if (logisticsName === '') {
            Toast.show('请选择快递公司！')
            return
        }
        if (logisticsNo === '') {
            Toast.show('请填写快递单号！')
            return
        }
        if (!/^[0-9]*$/.test(logisticsNo)) {
            Toast.show('快递单号只能输入数字哦！')
            return
        }
        Loading.show()
        let params = {
            logisticsName: log_name,
            logisticsNo,
            refundId: orderData.refundId,
            orderId: orderData.orderId,
        }
        requestApi.jRefundOrderAddLogistics(params).then(res => {
            console.log('详情提交物流', res)
            Toast.show('提交成功!')
            callback()
            this.props.navigation.goBack()
        }).catch(err => {
            console.log(err)
        })
    }
    // navigation.navigate('WMGoodsDamagResult')
    renderChuli = () => {
        const { navigation } = this.props
        const { logisticsNo, logisticsName, refundDetail } = this.state
        return (
            <View>
                <View style={{ width: getwidth(355), alignItems: 'center', justifyContent: 'center', marginTop: 15 }}><Text>客服已经同意您的申请</Text></View>
                <View style={[styles.showSubItem, { marginBottom: 10, }]}>
                    <View style={CommonStyles.flex_between}>
                        <Text style={styles.showSubItemText}>退货地址：</Text>
                        <Text style={[styles.showSubItemText, { fontSize: 12, color: '#555',flex:1,textAlign: 'right' }]} numberOfLines={2}>{refundDetail.refundAddress}</Text>
                    </View>
                    <View style={[CommonStyles.flex_end,{marginTop: 5}]}>
                        <Text numberOfLines={1} style={[styles.showSubItemText, { textAlign: 'right', fontSize: 12,marginRight: 10, color: '#555',lineHeight: 17,flex:1, maxWidth: 200}]}>{refundDetail.refundReceiver}</Text>
                        <Text style={[styles.showSubItemText, { textAlign: 'right', fontSize: 12, color: '#555',lineHeight: 17 }]}>{ refundDetail.refundPhone }</Text>
                    </View>
                </View>
                <View style={[CommonStyles.flex_center]}>
                    <Content>
                        <TextInputView
                            maxLength={20}
                            value={logisticsNo}
                            onChangeText={(text) => { this.changeState('logisticsNo', text) }}
                            inputView={styles.inputView}
                            leftIcon={<Text style={{ color: '#222222', fontSize: 14 }}>快递运单号：</Text>}
                            rightIcon={<TouchableOpacity style={{ width: getwidth(44), height: getwidth(44), justifyContent: 'center', alignItems: 'flex-end' }}>
                                {/* <Image source={saoma} style={{ width: 16, height: 16 }} /> */}
                            </TouchableOpacity>}
                        />
                    </Content>
                    <Content>
                        <TouchableOpacity
                            onPress={() => {
                                this.changeState('visible', true)
                            }}
                            style={[CommonStyles.flex_between, { padding: 15 }]}>
                            <Text style={{ color: '#222222', fontSize: 14 }}>快递公司：</Text>
                            <View style={CommonStyles.flex_start}>
                                <Text>{(logisticsName === '') ? '请选择' : logisticsName}</Text>
                                <Image source={require('../../images/mall/goto_gray.png')} />
                            </View>
                        </TouchableOpacity>
                    </Content>
                </View>
                <TouchableOpacity
                    style={[styles.submitView, { marginBottom: 20 }]}
                    activeOpacity={0.8}
                    onPress={() => {
                        this.handleSubmit()
                    }}
                >
                    <Text style={styles.submitView_text}>提交</Text>
                </TouchableOpacity>
            </View>
        )
    }
    render() {
        const { navigation } = this.props
        const { refundDetail, visible, showBingPicVisible,showImgIndex } = this.state
        let orderData = navigation.getParam('orderData', {})
        return (
            <View style={styles.container}>
                <Header
                    navigation={navigation}
                    goBack={true}
                    centerView={
                        <View style={{ position: 'relative', flex: 1, alignItems: 'center' }}>
                            <Text style={{ fontSize: 17, color: '#fff' }}>报损详情</Text>
                        </View>
                    }
                />
                <ScrollView
                    showsHorizontalScrollIndicator={false}
                    showsVerticalScrollIndicator={false}
                    style={{ width: width, height: height - 44}} contentContainerStyle={{ alignItems: 'center' }}>
                    <Content style={[styles.itemContent, { flexDirection: 'row', alignItems: 'center',paddingVertical: 15 }]}>
                        <View style={styles.img}>
                            <Image source={{ uri:getPreviewImage(orderData.mainUrl, '50p')}} style={{ width: getwidth(80), height: getwidth(80), borderRadius: 8}} />
                        </View>
                        <View style={styles.textItem}>
                            <View><Text style={{ color: '#222222', fontSize: 14 }}>{orderData.goodsName}</Text></View>
                            {
                                orderData.showSkuName && <View><Text style={styles.price}>规格：{orderData.showSkuName || '无'}</Text></View>
                            }
                            <View><Text style={styles.price}>消费券：{math.divide(orderData.price , 100)}</Text></View>
                        </View>
                    </Content>
                    <View style={[styles.itemContent, { justifyContent: 'center',backgroundColor: '#fff',marginTop: 10,borderRadius: 6 }]}>
                        <View style={[styles.item2View, { borderBottomColor: '#F1F1F1', borderBottomWidth: 1, }]}>
                            <Text>报损原因：{refundDetail.reason}</Text>
                        </View>
                        <View style={styles.item2View}>
                            <Text>报损时间：{moment(refundDetail.createAt * 1000).format('YYYY-MM-DD HH:mm')}</Text>
                        </View>
                    </View>
                    <Content style={[styles.itemContent, {justifyContent: 'center',paddingBottom: 15,}]}>
                        <View style={styles.imgTitle}>
                            <Text>报损凭证</Text>
                        </View>
                        <View style={styles.imgs}>
                            {
                                this.renderImg()
                            }
                        </View>
                    </Content>
                    {
                        (refundDetail.refundState === 'UNAPPROVED')
                                ? <TouchableOpacity
                                    style={styles.submitView}
                                    activeOpacity={0.8}
                                    onPress={() => { navigation.navigate('WMGoodsDamag', { orderData }) }}
                                >
                                    <Text style={styles.submitView_text}>重新审核</Text>
                                </TouchableOpacity>
                                : null
                    }
                    {
                        refundDetail.refundState !== 'UNAUDITED' && refundDetail.refundState !== 'UNAPPROVED'
                            ? this.renderChuli()
                            : null

                    }

                </ScrollView>
                <View style={{position: 'absolute',height: 50,width,bottom:CommonStyles.footerPadding,left: 0}}>
                    {
                        refundDetail.refundState === 'UNAUDITED'
                        ? <TouchableOpacity
                            style={[styles.waitWrap]}
                            activeOpacity={0.8}
                            onPress={() => {
                                Toast.show('请等待客服处理！')
                            }}
                        >
                            <Text style={styles.submitView_text}>等待客服处理</Text>
                        </TouchableOpacity>
                        : null
                    }
                </View>
                <Modal
                    animationType="fade"
                    transparent={true}
                    visible={visible}
                    onRequestClose={() => { this.changeState('visible', false) }}
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
                            {lists && lists.length > 0 && lists.map((item, index) => {
                                return (
                                    <TouchableOpacity key={index} style={[styles.modalItem, styles.flex_center, styles.borderBottom]}
                                        onPress={() => {
                                            this.setState({
                                                visible: false,
                                                logisticsName: getLogisticsInfo(item.value),
                                                log_name: item.value
                                            })
                                        }}
                                    >
                                        <Text style={styles.modalItemText}>{item.label}</Text>
                                    </TouchableOpacity>
                                );
                            })}
                            </ScrollView>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => { this.changeState('visible', false) }}
                                style={[styles.modalItem, styles.flex_center]}
                            >
                                <View style={styles.block} />
                                <Text style={[styles.modalItemText]}>取消</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
                {/* 查看大图 */}
                <ShowBigPicModal
                    ImageList={this.getImgList()}
                    visible={showBingPicVisible}
                    showImgIndex={showImgIndex}
                    onClose={() => { this.changeState('showBingPicVisible', false) }}
                />
            </View >
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
        flex: 1,
        position: 'relative'
    },
    itemContent: {
        width: getwidth(355),
    },
    img: {
        width: getwidth(80),
        height: getwidth(80),
        marginLeft: 15,
        justifyContent: 'center',
        alignItems: 'center',
    },
    textItem: {
        height: getwidth(80),
        flex: 1,
        paddingHorizontal: 10,
    },
    price: {
        color: '#555555',
        fontSize: 10,
        marginTop: 7
    },
    img_item: {
        width: '100%',
        height: '100%',
        borderRadius: 6,
        overflow: 'hidden',
        marginRight: 15,
        marginTop: 10
    },
    item2View: {
        paddingVertical: 15,
        width: getwidth(355),
        paddingHorizontal: 15,
        justifyContent: 'center',
        color: '#222222',
        fontSize: 14
    },
    imgTitle: {
        paddingTop: 15,
        paddingHorizontal: 15,
    },
    imgs: {
        ...CommonStyles.flex_start,
        flexWrap: 'wrap',
        flexDirection: 'row',
        paddingHorizontal: 15,
    },
    submitView: {
        // ...CommonStyles.shadowStyle,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        width: width - 20,
        height: 44,
        marginHorizontal: 10,
        borderRadius: 8,
        backgroundColor: '#4A90FA',
        marginTop: 20
    },
    submitView_text: {
        fontSize: 17,
        color: '#fff',
    },
    inputView: {
        width: getwidth(355),
        height: 40,
        flexDirection: 'row',
        paddingHorizontal: 15,
        alignItems: 'center'
    },
    flex_center: {
        justifyContent: 'center',
        flexDirection: 'row',
    },
    flex_1: {
        flex: 1
    },
    modal: {
        // height: 342,
        flex: 1,
        backgroundColor: "rgba(10,10,10,.5)",
        position: "relative"
    },
    modalContent: {
        position: "absolute",
        bottom: 0,
        left: 0,
        width,
        backgroundColor: "#fff",
        paddingBottom: CommonStyles.footerPadding,
    },
    color_red: {
        color: "#EE6161"
    },
    modalItemText: {
        fontSize: 17,
        color: "#222"
    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: "relative"
    },
    marginTop: {
        marginTop: 5
    },
    borderBottom: {
        borderBottomColor: "#f1f1f1",
        borderBottomWidth: 1
    },
    block: {
        width,
        height: 5,
        backgroundColor: "#F1F1F1",
        position: "absolute",
        top: 0,
        left: 0
    },
    flex_end: {
        flexDirection: "row",
        justifyContent: "flex-end",
        alignItems: "center"
    },
    flex_start: {
        flexDirection: "row",
        justifyContent: "flex-start",
        alignItems: "center"
    },
    waitWrap: {
        position: 'absolute',
        width,
        bottom: 0,
        left: 0,
        zIndex: 10,
        height: 50,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#4A90FA',
    },
    modalItem: {
        paddingVertical: 15,
        width,
        position: 'relative'
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
})
