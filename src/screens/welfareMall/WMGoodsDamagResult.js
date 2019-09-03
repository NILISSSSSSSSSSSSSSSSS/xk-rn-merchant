
/**
 * 货物报损详情
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
    TouchableOpacity
} from "react-native";
import { connect } from "rn-dva"
import moment from 'moment'
import CommonStyles from '../../common/Styles'
import * as nativeApi from '../../config/nativeApi'
import * as requestApi from '../../config/requestApi'
import * as utils from '../../config/utils'
import Header from '../../components/Header'
import Content from '../../components/ContentItem'
import ImageView from '../../components/ImageView'
import TextInputView from '../../components/TextInputView'

const goodsDamag = require('../../images/indianashopcart/goodsDamag.png')

const { width, height } = Dimensions.get("window")
function getwidth(val) {
    return width * val / 375
}

export default class WMGoodsDamagResult extends PureComponent {
    state = {
        refundDetail: {
            log: []
        },
        logistics: []
    }
    componentDidMount() {
        this.getDetail()
    }
    getDetail = () => {
        const { navigation } = this.props
        let orderData = this.props.navigation.getParam('orderData', {})
        let params = {
            // logisticsName: '',
            // logisticsNo: '',
            refundId: orderData.refundId
        }
        requestApi.refundReportDetail(params).then(res => {
            console.log('详情', res)
            let temp = res.log;
            temp && temp.reverse();
            res.log = temp
            this.setState({
                refundDetail: res
            })

        }).catch(err => {
            console.log(err)
        })
    }
    changeState(key, value) {
        this.setState({
            [key]: value
        });
    }
    renderItemContent = () => {
        const { refundDetail } = this.state
        let reason;
        return refundDetail.log && refundDetail.log.map((item, index) => {
            if (index === 0 && refundDetail.refundState === 'UNAPPROVED') {
                reason = refundDetail.reason
            }
            let textColor = '#999999'
            if (index === 0) {
                textColor = '#222222'
            }
            return (
                <View style={styles.itemJIndu} key={index}>
                    <View style={styles.circle}></View>
                    <View style={styles.itemText}>
                        <Text style={[styles.itemTitle, { color: textColor }]}>{item.refundInfo}</Text>
                        {/* <Text style={[styles.itemTitle, { color: textColor }]}>{item.refundInfo}{reason && `原因：${reason}`}</Text> */}
                        <Text style={styles.itemtextContent}>{moment(item.createTime * 1000).format('YYYY-MM-DD HH:mm:ss')}</Text>
                    </View>
                </View>
            )
        })
    }
    getRefundStatu = (status) => {
        switch (status) {
            case 'UNAUDITED': return '待审核'
            case 'UNAPPROVED': return '审核不通过'
            case 'VERIFIED': return '审核通过'
            case 'WAIT': return '等待平台收货'
            case 'RECEVIED': return '平台已收货'
            case 'DELIVERED': return '平台已发货'
        }
    }
    render() {
        const { navigation } = this.props
        const { refundDetail } = this.state
        let orderData = this.props.navigation.getParam('orderData', {})
        console.log('ceshi',orderData)
        return (
            <View style={styles.container} >
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
                    showsVerticalScrollIndicator={false}
                    showsHorizontalScrollIndicator={false}
                >
                    <Content style={styles.itemContent}>
                        <View style={styles.img}>
                            <Image source={{ uri: refundDetail.mainUrl }} style={{ width: getwidth(80), height: getwidth(80), borderRadius: 8 }} />
                        </View>
                        <View style={styles.textItem}>
                            <View><Text style={{ color: '#222222', fontSize: 14 }}>{refundDetail.goodsName}</Text></View>
                            {
                                refundDetail.skuName && <View><Text style={styles.price}>规格：{refundDetail.skuName} * 1</Text></View>
                            }
                        </View>
                    </Content>
                    <Content style={styles.content2Item}>
                        <View style={styles.content2Child}>
                            <Text style={{ color: '#222222', fontSize: 14 }}>订单编号：{refundDetail.orderId}</Text>
                        </View>
                        <View style={styles.content2Child}>
                            <Text style={{ color: '#222222', fontSize: 14 }}>报损进度：{this.getRefundStatu(refundDetail.refundState)}</Text>
                        </View>
                    </Content>
                    <Content style={styles.jinduView}>
                        <View style={styles.jinduItem}>
                            {
                                this.renderItemContent()
                            }
                        </View>
                    </Content>
                </ScrollView>

            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        ...CommonStyles.containerWithoutPadding,
        alignItems: 'center',
        backgroundColor: CommonStyles.globalBgColor,
    },
    itemContent: {
        width: getwidth(355),
        height: 100,
        flexDirection: 'row',
        alignItems: 'center'
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
    content2Item: {
        width: getwidth(355),
        height: 73,
        justifyContent: 'center'
    },
    content2Child: {
        width: getwidth(355),
        paddingHorizontal: 15,
        height: 73 / 2,
        justifyContent: 'center',
    },
    jinduView: {
        width: getwidth(355),
        flex: 1,
        paddingHorizontal: 15,
        paddingVertical: 15,
    },
    jinduItem: {
        width: '100%',
        height: '100%',
        borderLeftColor: '#D8D8D8',
        borderLeftWidth: 1,
    },
    itemJIndu: {
        width: '100%',
        height: 50,
    },
    circle: {
        width: 8,
        height: 8,
        borderRadius: 8,
        position: 'absolute',
        top: -4,
        left: -4,
        backgroundColor: '#4A90FA'
    },
    itemText: {
        paddingHorizontal: 15,
        marginTop: -4
    },
    itemTitle: {
        fontSize: 14,
    },
    itemtextContent: {
        color: '#999999',
        fontSize: 12
    }
})
